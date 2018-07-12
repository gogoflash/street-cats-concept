package com.alisacasino.bingo.assets.loading.nativeLoaderWrappers
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.SignInMessage.Platform;
	import com.alisacasino.bingo.utils.Constants;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.getTimer;
	import starling.events.EnterFrameEvent;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	internal class MultimediaLoaderWrapper extends RemoteLoaderWrapperBase
	{
		protected var loader:Loader;
		
		private var bytesLoaded:Number = 0;
		private var startTimestamp:int = -1;
		
		public function MultimediaLoaderWrapper()
		{
			super();
		}
		
		override public function load(uri:String, callback:Function = null, errorCallback:Function = null):void 
		{
			super.load(uri, callback, errorCallback);
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_completeHandler);
			loader.contentLoaderInfo.addEventListener(Event.INIT, loader_initHandler);
			loader.contentLoaderInfo.addEventListener(Event.OPEN, loader_openHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loader_ioErrorHandler);
			loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, loader_httpStatusHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loader_progressHandler);
			
			var request:URLRequest = new URLRequest(getRemoteURI());
			//sosTrace( "request : " + request.url, SOSLog.DEBUG);
			var loaderContext:LoaderContext;
			if (PlatformServices.isCanvas && !Constants.isLocalBuild)
			{
				loaderContext = new LoaderContext(true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain);
			}
			
			try
			{
				bytesLoaded = 0;
				
				loader.load(request, loaderContext);
			}
			catch (e:Error)
			{
				sosTrace( "Error e : " + e, e.getStackTrace(), SOSLog.ERROR);
				fail();
			}
		}
		
		private function loader_openHandler(e:Event):void 
		{
			Game.current.addEventListener(EnterFrameEvent.ENTER_FRAME, current_enterFrameHandler);
			startTimestamp = getTimer();
		}
		
		private function loader_progressHandler(e:ProgressEvent):void 
		{
			if (e.bytesLoaded <= 0)
				return;
				
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loader_progressHandler);
		}
		
		private function loader_httpStatusHandler(e:HTTPStatusEvent):void 
		{
			//Game.current.addEventListener(EnterFrameEvent.ENTER_FRAME, current_enterFrameHandler);
		}
		
		private function current_enterFrameHandler(e:EnterFrameEvent):void 
		{
			accountForTransferSpeed();
		}
		
		private function accountForTransferSpeed():void 
		{
			var frameDifference:int = loader.contentLoaderInfo.bytesLoaded - bytesLoaded;
			bytesLoaded = loader.contentLoaderInfo.bytesLoaded;
			gameManager.watchdogs.connectionWatchdog.reportTransferRate(frameDifference);
		}
		
		protected function loader_ioErrorHandler(e:IOErrorEvent):void 
		{
			sosTrace("Error while loading " + getRemoteURI(), SOSLog.ERROR);
			fail();
		}
		
		override protected function fail():void 
		{
			super.fail();
			Game.current.removeEventListener(Event.ENTER_FRAME, current_enterFrameHandler);
		}
		
		protected function loader_initHandler(e:Event):void
		{
		
		}
		
		protected function loader_completeHandler(e:Event):void
		{
			accountForTransferSpeed();
			Game.current.removeEventListener(Event.ENTER_FRAME, current_enterFrameHandler);
		}
		
		override public function dispose():void 
		{
			if (loader)
			{
				loader.unloadAndStop(false);
			}
			super.dispose();
		}
		
		override public function get progress():Number 
		{
			if (loader && loader.contentLoaderInfo && loader.contentLoaderInfo.bytesTotal > 0)
			{
				return loader.contentLoaderInfo.bytesLoaded / loader.contentLoaderInfo.bytesTotal;
			}
			return 0;
		}
	
	}

}