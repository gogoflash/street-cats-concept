package com.alisacasino.bingo.assets.loading.nativeLoaderWrappers 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.utils.TimeService;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.utils.getTimer;
	import starling.events.EnterFrameEvent;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	internal class URLLoaderWrapper extends RemoteLoaderWrapperBase
	{
		protected var urlLoader:URLLoader;
		private var _loading:Boolean;
		
		private var bytesLoaded:Number = 0;
		private var startTimestamp:int;
		
		public function URLLoaderWrapper()
		{
			super();
		}
		
		override public function load(uri:String, callback:Function = null, errorCallback:Function = null):void 
		{
			super.load(uri, callback, errorCallback);
			urlLoader = new URLLoader();
			urlLoader.addEventListener(flash.events.Event.COMPLETE, urlLoader_completeHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlLoader_ioErrorHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoader_securityErrorHandler);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, urlLoader_httpStatusHandler);
			urlLoader.addEventListener(Event.OPEN, urlLoader_openHandler);
			
			urlLoader.dataFormat = getDataFormat();
			
			var request:URLRequest = new URLRequest(getRemoteURI());
			
			urlLoader.load(request);
			_loading = true;
			
			startTimestamp = getTimer();
		}
		
		private function urlLoader_httpStatusHandler(e:HTTPStatusEvent):void 
		{
		}
		
		private function urlLoader_openHandler(e:Event):void 
		{
			startTimestamp = getTimer();
			Game.current.addEventListener(EnterFrameEvent.ENTER_FRAME, current_enterFrameHandler);
		}
		
		private function current_enterFrameHandler(e:EnterFrameEvent):void 
		{
			accountForTransferSpeed();
		}
		
		private function accountForTransferSpeed():void 
		{
			var frameDifference:int = urlLoader.bytesLoaded - bytesLoaded;
			bytesLoaded = urlLoader.bytesLoaded;
			gameManager.watchdogs.connectionWatchdog.reportTransferRate(frameDifference);
		}
		
		protected function getDataFormat():String
		{
			throw new Error("getDataFormat() must be overridden in subclasses");
		}
		
		protected function urlLoader_securityErrorHandler(e:SecurityErrorEvent):void 
		{
			_loading = false;
			sosTrace("Error while loading " + getRemoteURI(), SOSLog.ERROR);
			fail();
		}
		
		protected function urlLoader_ioErrorHandler(e:IOErrorEvent):void 
		{
			_loading = false;
			sosTrace("Error while loading " + getRemoteURI(), SOSLog.ERROR);
			fail();
		}
		
		override protected function fail():void 
		{
			super.fail();
			Game.current.removeEventListener(Event.ENTER_FRAME, current_enterFrameHandler);
		}
		
		protected function urlLoader_completeHandler(e:Event):void 
		{
			Game.current.removeEventListener(Event.ENTER_FRAME, current_enterFrameHandler);
			accountForTransferSpeed();
			_loading = false;
			complete();
		}
		
		override public function dispose():void 
		{
			super.dispose();
			if (_loading)
			{
				try
				{
					urlLoader.close();
				}
				catch (e:Error)
				{
					sosTrace( "e : " + e, SOSLog.ERROR);
				}
			}
			Game.current.removeEventListener(Event.ENTER_FRAME, current_enterFrameHandler);
			urlLoader = null;
		}
		
		override public function get progress():Number 
		{
			if (urlLoader &&  urlLoader.bytesTotal > 0)
			{
				return urlLoader.bytesLoaded / urlLoader.bytesTotal;
			}
			return 0;
		}
		
	}

}