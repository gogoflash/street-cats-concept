package com.alisacasino.bingo.assets.loading.nativeLoaderWrappers 
{
	import com.alisacasino.bingo.utils.LoadUtils;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class BitmapLoaderWrapper extends MultimediaLoaderWrapper implements IBitmapLoader
	{
		private var cachedSerializedBinaryData:ByteArray;
		private var getBinaryDataCallback:Function;
		
		public function BitmapLoaderWrapper() 
		{
			super();
		}
		
		public function getBitmapData():BitmapData
		{
			if (loader && loader.contentLoaderInfo && loader.contentLoaderInfo.content)
			{
				return (loader.contentLoaderInfo.content as Bitmap).bitmapData;
			}
			return null;
		}
		
		override protected function loader_completeHandler(e:Event):void 
		{
			//sosTrace( "BitmapLoaderWrapper.loader_completeHandler > e : " + e, SOSLog.DEBUG);
			super.loader_completeHandler(e);
			
			if (!(loader.contentLoaderInfo.content is Bitmap))
			{
				sosTrace("Wrong content type for bitmap loader", SOSLog.ERROR);
				fail();
			}
			else
			{
				complete();
			}
		}
		
		public function getBinaryData():ByteArray
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
					LoadUtils.serializeBitmapData(getBitmapData(), callback_getBinaryDataCallback, getURI());
					return
				}
			}
			
			callback(getBinaryData());
		}
		
		private function callback_getBinaryDataCallback(data:ByteArray):void {
			cachedSerializedBinaryData = data;
			if (getBinaryDataCallback != null) {
				getBinaryDataCallback(data);
				getBinaryDataCallback = null;
			}
		}
		
		override public function get useWorker():Boolean 
		{
			return gameManager.workerManager.isEnabled;
		}
		
		override public function dispose():void 
		{
			if (getBitmapData())
			{
				getBitmapData().dispose();
			}
			if (cachedSerializedBinaryData)
			{
				cachedSerializedBinaryData.clear();
				cachedSerializedBinaryData = null;
			}
			super.dispose();
		}
		
	}

}