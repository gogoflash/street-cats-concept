package com.alisacasino.bingo.assets.loading.nativeLoaderWrappers 
{
	import avmplus.getQualifiedClassName;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.LoadUtils;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class BitmapFileLoaderWrapper extends FileLoaderWrapper implements IBitmapLoader
	{
		private var loader:Loader;
		private var bitmap:Bitmap;
		private var bitmapData:BitmapData;
		private var cachedSerializedBinaryData:ByteArray;
		private var extractingViaLoader:Boolean;
		private var getBinaryDataCallback:Function;
		
		public function BitmapFileLoaderWrapper() 
		{
			super();
		}
		
		public function getBitmapData():BitmapData 
		{
			if (bitmapData)
			{
				return bitmapData;
			}
			if (bitmap)
			{
				return bitmap.bitmapData;
			}
			return null;
		}
		
		override protected function parseBinaryData(data:ByteArray):void 
		{
			var shouldParseAsInternalFormat:Boolean = false;
			if (data.length > 4)
			{
				var prefix:uint = data.readUnsignedInt();
				sosTrace( "prefix : " + prefix.toString(16));
				if (prefix == LoadUtils.SERIALIZED_FORMAT_PREFIX)
				{
					shouldParseAsInternalFormat = true;
				}
			}
			
			if (shouldParseAsInternalFormat)
			{
				gameManager.backgroundThreadManager.addNormalPriorityFunction(extractSerializedFormat, data);
			}
			else
			{
				gameManager.backgroundThreadManager.addNormalPriorityFunction(extractViaLoader, data);
			}
		}
		
		private function extractViaLoader(data:ByteArray):void 
		{
			extractingViaLoader = true;
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, loader_initHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loader_ioErrorHandler);
			
			var context:LoaderContext = new LoaderContext();
			context.allowCodeImport = true;
			context.applicationDomain = ApplicationDomain.currentDomain;
			try
			{
				loader.loadBytes(data, context);
			}
			catch (e:Error)
			{
				//sosTrace( "BitmapFileLoaderWrapper Loader.loadBytes error : " + e, SOSLog.ERROR);
				checkBitmapAndComplete();
			}
		}
		
		private function loader_initHandler(e:Event):void 
		{
			if (loader.contentLoaderInfo.content is Bitmap)
			{
				bitmap = loader.contentLoaderInfo.content as Bitmap;
				checkBitmapAndComplete();
			}
			else if (loader.contentLoaderInfo.content is MovieClip)
			{
				gameManager.backgroundThreadManager.addNormalPriorityFunction(extractBitmap, loader.contentLoaderInfo.content);
			}
		}
		
		private function loader_ioErrorHandler(e:IOErrorEvent):void 
		{
			sosTrace( "BitmapFileLoaderWrapper.loader_ioErrorHandler > e : " + e, SOSLog.ERROR);
			e.preventDefault();
			fail();
		}
		
		private function extractSerializedFormat(data:ByteArray):void 
		{
			extractingViaLoader = false;
			try
			{
				bitmapData = LoadUtils.extractSerializedFormat(data);
				cachedSerializedBinaryData = data;
			}
			catch (e:Error)
			{
				sosTrace( "LoadUtils.extractSerializedFormat error : " + e, getURI() ,SOSLog.ERROR);
				bitmapData = null;
				cachedSerializedBinaryData = null;
				
				fail();
				return;
			}
			
			if (!bitmapData)
			{
				cachedSerializedBinaryData = null;
				extractViaLoader(data);
			}
			else
			{
				checkBitmapAndComplete();
			}
		}
		
		private function extractBitmap(source:DisplayObject):void 
		{
			//Used to get bitmapdata from locally cached image files (those are loaded as MovieClips for some reason)
			try
			{
				bitmap = LoadUtils.movieClipToBitmap(source);
			}
			catch (e:Error)
			{
				sosTrace("Error while trying to draw bitmapData from swf loader " + e, SOSLog.ERROR);
			}
			checkBitmapAndComplete();
		}
		
		private function findFirstBitmap(content:*):void 
		{
			if (bitmap)
				return;
			
			if (content is Bitmap)
			{
				bitmap = content as Bitmap;
			}
			
			var doc:DisplayObjectContainer = content as DisplayObjectContainer;
			if (doc)
			{
				for (var i:int = 0; i < doc.numChildren; i++) 
				{
					findFirstBitmap(doc.getChildAt(i));
				}
			}
		}
		
		private function checkBitmapAndComplete():void 
		{
			if (!bitmapData && !bitmap)
			{
				sosTrace("Could not get bitmapData content from cached file " + getURI(), SOSLog.ERROR);
				fail();
			}
			else
			{
				complete();
			}
		}
		
		override public function dispose():void 
		{
			if (bitmap && bitmap.bitmapData)
			{
				bitmap.bitmapData.dispose();
			}
			if (bitmapData)
			{
				bitmapData.dispose();
			}
			if (loader)
			{
				loader.unloadAndStop(true);
			}
			if (cachedSerializedBinaryData)
			{
				cachedSerializedBinaryData.clear();
				cachedSerializedBinaryData = null;
			}
			super.dispose();
		}
		
		override public function getBinaryData():ByteArray
		{
			if (!getBitmapData())
			{
				return null;
			}
			
			if (!cachedSerializedBinaryData)
			{
				var bitmapData:BitmapData = getBitmapData();
				cachedSerializedBinaryData = LoadUtils.serializeBitmapData(bitmapData);
			}
			
			return cachedSerializedBinaryData;
		}
		
		public function getBinaryDataThrowWorker(callback:Function):void
		{
			if(useWorker) {
				if (!getBitmapData())
					callback(null);
				
				if (!cachedSerializedBinaryData) {
					getBinaryDataCallback = callback;
					//sosTrace('BitmapFileLoaderWrapper.getBinaryDataThrowWorker ', getURI(), SOSLog.INFO);
					LoadUtils.serializeBitmapData(getBitmapData(), callback_getBinaryDataCallback, getURI());
					return
				}
			}
			
			callback(getBinaryData());
		}
		
		private function callback_getBinaryDataCallback(data:ByteArray):void {
			cachedSerializedBinaryData = data;
			//sosTrace('BitmapFileLoaderWrapper.callback_getBinaryDataCallback ', getURI(), SOSLog.INFO);
			if (getBinaryDataCallback != null) {
				getBinaryDataCallback(data);
				getBinaryDataCallback = null;
			}
		}
		
		override public function get useWorker():Boolean 
		{
			return gameManager.workerManager.isEnabled;
		}
		
		override public function get shouldCache():Boolean 
		{
			return extractingViaLoader;
		}
		
	}

}