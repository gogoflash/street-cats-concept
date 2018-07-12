package com.alisacasino.bingo.assets.loading.nativeLoaderWrappers 
{
	import adobe.utils.CustomActions;
	import com.alisacasino.bingo.assets.loading.LoadManager;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.helpers.FileLoaderQueue;
	import com.alisacasino.bingo.utils.InternalStorageAPI;
	import com.alisacasino.bingo.utils.LoadUtils;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	internal class FileLoaderWrapper extends LoaderWrapperBase implements IBinaryLoader
	{
		
		private var _binaryData:ByteArray;
		
		public function FileLoaderWrapper() 
		{
			super();
		}
		
		override public function load(uri:String, callback:Function = null, errorCallback:Function = null):void 
		{
			super.load(uri, callback, errorCallback);
			
			//TODO: move to the usual place, the thread manager
			loadFileReference();
		}
		
		private function loadFileReference():void 
		{
			var contentRoot:File;
			
			if (loadType == LoadUtils.LOCAL_LOAD)
			{
				contentRoot = File.applicationDirectory;
			}
			else
			{
				contentRoot = InternalStorageAPI.getCacheDirectory() as File;
			}
			
			LoadManager.instance.loadQueue.loadFile(contentRoot, getURI(), onFileLoaded, onFileFailed);
		}
		
		private function onFileFailed():void 
		{
			sosTrace( "FileLoaderWrapper.onFileFailed " + getURI, SOSLog.ERROR);
			fail();
		}
		
		private function onFileLoaded(fileReference:FileReference):void 
		{
			sosTrace( "FileLoaderWrapper.onFileLoaded > fileReference : " + fileReference.name, SOSLog.DEBUG);
			if (disposed)
			{
				return;
			}
			var file:File = fileReference as File;
			_binaryData = file.data;
			gameManager.backgroundThreadManager.addNormalPriorityFunction(parseBinaryData, _binaryData);
		}
		
		protected function parseBinaryData(data:ByteArray):void 
		{
			throw new Error("parseBinaryData() must be overridden in children");
		}
		
		override public function dispose():void 
		{
			if (_binaryData)
			{
				_binaryData.clear();
			}
			_binaryData = null;
			super.dispose();
		}
		
		public function getBinaryData():ByteArray 
		{
			return _binaryData;
		}
		
	}

}