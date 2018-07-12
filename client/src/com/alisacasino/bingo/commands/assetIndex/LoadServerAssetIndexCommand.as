package com.alisacasino.bingo.commands.assetIndex 
{
	import com.alisacasino.bingo.assets.AssetsManager;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.commands.ICommand;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.Settings;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	internal class LoadServerAssetIndexCommand extends CommandBase
	{
		private var indexLoader:URLLoader;
		
		public function LoadServerAssetIndexCommand() 
		{
			finishOnFail = true;
		}
		
		override protected function startExecution():void 
		{
			loadContentIndex();
		}
		
		public function loadContentIndex():void 
		{
			indexLoader = new URLLoader();
			indexLoader.addEventListener(Event.COMPLETE, indexLoader_completeHandler);
			indexLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, indexLoader_httpStatusHandler);
			indexLoader.addEventListener(IOErrorEvent.IO_ERROR, indexLoader_ioErrorHandler);
			indexLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, indexLoader_securityErrorHandler);
			indexLoader.dataFormat = URLLoaderDataFormat.TEXT;
			indexLoader.load(new URLRequest(Settings.instance.assetIndexParent + "assetIndex.txt" + generateRandomArgument()));
		}
		
		private function generateRandomArgument():String
		{
			return "?res=" + int(Math.random() * int.MAX_VALUE);
		}
		
		private function indexLoader_httpStatusHandler(e:HTTPStatusEvent):void 
		{
			//sosTrace( "LoadServerAssetIndexCommand.indexLoader_httpStatusHandler > e : " + e, SOSLog.DEBUG);
		}
		
		private function indexLoader_securityErrorHandler(e:SecurityErrorEvent):void 
		{
			sosTrace( "LoadAssetIndexCommand.indexLoader_securityErrorHandler > e : " + e, SOSLog.ERROR);
			fail();
		}
		
		private function indexLoader_ioErrorHandler(e:IOErrorEvent):void 
		{
			sosTrace( "LoadAssetIndexCommand.indexLoader_ioErrorHandler > e : " + e, SOSLog.ERROR);
			fail();
		}
		
		override protected function fail():void 
		{
			AssetsManager.instance.assetIndexManager.parseServerIndex("");
			super.fail();
		}
		
		private function indexLoader_completeHandler(e:Event):void 
		{
			var rawIndexData:String = indexLoader.data;
			AssetsManager.instance.assetIndexManager.parseServerIndex(rawIndexData);
			finish();
		}
		
		override protected function finish():void 
		{
			//sosTrace( "LoadServerAssetIndexCommand.finish", SOSLog.DEBUG);
			super.finish();
		}
	}

}