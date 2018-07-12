package com.alisacasino.bingo.commands.assetIndex 
{
	import com.alisacasino.bingo.assets.AssetsManager;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.commands.ICommand;
	import com.alisacasino.bingo.utils.InternalStorageAPI;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	internal class LoadLocalAssetIndex extends CommandBase
	{
		private var localAssetIndex:File;
		
		public function LoadLocalAssetIndex() 
		{
			finishOnFail = true;
		}
		
		override protected function startExecution():void 
		{
			getLocalIndexFile();
		}
		
		private function getLocalIndexFile():void 
		{
			localAssetIndex = (InternalStorageAPI.getCacheDirectory() as File).resolvePath("assetIndex.local");
			if (localAssetIndex.exists)
			{
				localAssetIndex.addEventListener(Event.COMPLETE, localAssetIndex_completeHandler);
				localAssetIndex.addEventListener(IOErrorEvent.IO_ERROR, localAssetIndex_ioErrorHandler);
				localAssetIndex.addEventListener(SecurityErrorEvent.SECURITY_ERROR, localAssetIndex_securityErrorHandler);
				localAssetIndex.load();
			}
			else 
			{
				fail();
			}
		}
		
		private function localAssetIndex_securityErrorHandler(e:SecurityErrorEvent):void 
		{
			fail();
		}
		
		private function localAssetIndex_ioErrorHandler(e:IOErrorEvent):void 
		{
			fail();
		}
		
		private function localAssetIndex_completeHandler(e:Event):void 
		{
			AssetsManager.instance.assetIndexManager.parseLocalIndex(localAssetIndex.data);
			finish();
		}
		
	}

}