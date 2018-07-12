package com.alisacasino.bingo.utils
{
	import com.alisacasino.bingo.assets.AssetsManager;
	import com.alisacasino.bingo.assets.loading.assetIndices.AssetIndexManager;
	import com.alisacasino.bingo.assets.loading.LoadManager;
	import com.alisacasino.bingo.assets.loading.ResourceType;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.LoaderQueueEntry;
	import com.alisacasino.bingo.platform.PlatformServices;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.CompressionAlgorithm;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class LoadUtils
	{
		static public const SERIALIZED_FORMAT_PREFIX:uint = 0x61627366; // abfs in ASCII, means Alisa Bingo Serialized Format
		
		private static var serializeBitmapDataCallbacks:Object = new Object();
		
		public static function movieClipToBitmap(obj:DisplayObject):Bitmap
		{
			var clip:MovieClip = obj as MovieClip;
			var myBitmapData:BitmapData = new BitmapData(clip.width, clip.height, true, 0x00000000);
			myBitmapData.draw(clip);
			return new Bitmap(myBitmapData);
		}
		
		static private function getLoadTypesInOrder(uri:String):Array 
		{
			if (PlatformServices.isCanvas)
			{
				return [REMOTE_LOAD];
			}
			
			return getMobileLoadTypes(uri);
		}
		
		static private function getMobileLoadTypes(uri:String):Array 
		{
			var loadTypes:Array = [];
			
			var localFile:Boolean = localFileExists(uri);
			var cachedFile:Boolean = InternalStorageAPI.fileExists(uri);
			//sosTrace('LoadUtils.getMobileLoadTypes fileExists ', cachedFile, SOSLog);
			if (cachedFile && AssetsManager.instance.assetIndexManager.cachedFileIsUpToDate(uri))
			{
				loadTypes.push(CACHED_LOAD);
			}
			
			if (localFile)
			{
				loadTypes.push(LOCAL_LOAD);
			}
			
			loadTypes.push(REMOTE_LOAD);
			
			if (cachedFile && !AssetsManager.instance.assetIndexManager.cachedFileIsUpToDate(uri))
			{
				loadTypes.push(CACHED_LOAD);
			}
			
			return loadTypes;
		}
		
		static public function getLoaderPreferenceQueue(resourceType:String, uri:String):Vector.<LoaderQueueEntry> 
		{
			var loadTypes:Array = getLoadTypesInOrder(uri);
			
			var result:Vector.<LoaderQueueEntry> = new Vector.<LoaderQueueEntry>();
			
			for each (var loadType:String in loadTypes) 
			{
				result.push(new LoaderQueueEntry(getNativeLoaderClass(resourceType, loadType), loadType));
			}
			
			return result;
		}
		
		static public function extractSerializedFormat(data:ByteArray):BitmapData 
		{
			sosTrace( "LoadUtils.extractSerializedFormat > data : ");
			if (data.length <= 4)
			{
				return null;
			}
			var compressedData:ByteArray = new ByteArray();
			compressedData.writeBytes(data, 4);
			compressedData.inflate();
			compressedData.position = 0;
			var width:int = compressedData.readInt();
			var height:int = compressedData.readInt();
			if (width < 1 || height < 1)
			{
				return null;
			}
			var bitmapData:BitmapData = new BitmapData(width, height, true, 0xFFFF0000);
			bitmapData.setPixels(new Rectangle(0, 0, width, height), compressedData);
			return bitmapData;
		}
		
		static public function serializeBitmapData(bitmapData:BitmapData, callback:Function = null, callbackId:String = null):ByteArray 
		{
			var compressedData:ByteArray = new ByteArray();
			compressedData.writeInt(bitmapData.width);
			compressedData.writeInt(bitmapData.height);
			var pixelData:ByteArray = bitmapData.getPixels(new Rectangle(0, 0, bitmapData.width, bitmapData.height));
			compressedData.writeBytes(pixelData, 0, 0);
			
			if (callback && callbackId) {
				serializeBitmapDataCallbacks[callbackId] = callback;
				gameManager.workerManager.deflateByteArray(compressedData, callback_completeSerializeBitmapData, callbackId);
				return null;
			}
			
			compressedData.deflate();
			
			var binaryData:ByteArray = new ByteArray();
			binaryData.writeUnsignedInt(SERIALIZED_FORMAT_PREFIX);
			binaryData.writeBytes(compressedData);
			//sosTrace("LoadUtils.serializeBitmapData ", compressedData.length,SOSLog.DEBUG);
			return binaryData;
		}
		
		static private function callback_completeSerializeBitmapData(byteArray:ByteArray, callbackId:String):void 
		{
			var binaryData:ByteArray = new ByteArray();
			binaryData.writeUnsignedInt(SERIALIZED_FORMAT_PREFIX);
			binaryData.writeBytes(byteArray);
			//sosTrace("callback_completeSerializeBitmapData ", binaryData.length, SOSLog.DEBUG);
				
			if (callbackId in serializeBitmapDataCallbacks) {
				serializeBitmapDataCallbacks[callbackId](binaryData);
				delete serializeBitmapDataCallbacks[callbackId];
			}
		}
		
		static private function getNativeLoaderClass(resourceType:String, loadType:String):Class 
		{
			return LoadManager.instance.getNativeLoaderClass(resourceType, loadType);
		}
		
		private static function needToUseFileLoader(loadType:String):Boolean
		{
			return loadType == CACHED_LOAD || loadType == LOCAL_LOAD;
		}
		
		
		private static var localFileExistenceCache:Object = { };
		
		private static function localFileExists(path:String):Boolean
		{
			if (!localFileExistenceCache.hasOwnProperty(path))
			{
				var localAppFile:File = File.applicationDirectory.resolvePath(path);
				if (!localAppFile.exists && path.indexOf("/") == 0)
				{
					var modifiedPath:String = path.substr(1);
					
					localAppFile = File.applicationDirectory.resolvePath(modifiedPath);
				}
				
				localFileExistenceCache[path] = localAppFile.exists;
			}
			
			return localFileExistenceCache[path];
		}
		
		public static const LOCAL_LOAD:String = "localLoad";
		public static const CACHED_LOAD:String = "cachedLoad";
		public static const REMOTE_LOAD:String = "remoteLoad";
		static private var listed:Boolean;
	}
}
