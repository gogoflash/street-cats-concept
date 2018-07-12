package com.alisacasino.bingo.commands.gameLoading 
{
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.utils.Constants;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class LoadSettingsFile extends CommandBase
	{
		private var loader:URLLoader;
		private var staticHost:String;
		
		public var data:String;
		
		private var _errorMessage:String;
		
		public function LoadSettingsFile(staticHost:String) 
		{
			this.staticHost = staticHost;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(IOErrorEvent.IO_ERROR, loader_ioErrorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_securityErrorHandler);
			loader.addEventListener(flash.events.Event.COMPLETE, loader_completeHandler);
			
			var settingsURL:String = staticHost;
			if (PlatformServices.isAndroid)
				settingsURL += Constants.ANDROID_SETTINGS_FILENAME;
			else if (PlatformServices.isIOS)
				settingsURL += Constants.IOS_SETTINGS_FILENAME;
			else
				settingsURL += Constants.FACEBOOK_SETTINGS_FILENAME;
		
			if (Constants.isDevBuild)
				settingsURL += "-dev.json";
			else
				settingsURL += ".json";
				
			var request:URLRequest = new URLRequest(settingsURL+"?time=" + new Date().getTime());
			if (PlatformServices.isMobile) {
				request.idleTimeout = Constants.NETWORK_REQUEST_TIMEOUT_MILLIS;
			}
			
			loader.load(request);
		}
		
		private function loader_completeHandler(e:Event):void 
		{
			data = String(loader.data);
			finish();
		}
		
		private function loader_securityErrorHandler(e:SecurityErrorEvent):void 
		{
			_errorMessage = e.text;
			fail();
		}
		
		private function loader_ioErrorHandler(e:IOErrorEvent):void 
		{
			_errorMessage = e.text;
			fail();
		}
		
		public function get errorMessage():String {
			return _errorMessage;
		}
		
		override protected function stopInternal():void 
		{
			super.stopInternal();
			
			if (!loader)
				return;
			
			loader.removeEventListener(IOErrorEvent.IO_ERROR, loader_ioErrorHandler);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_securityErrorHandler);
			loader.removeEventListener(flash.events.Event.COMPLETE, loader_completeHandler);
			
			try
			{
				loader.close();
			}
			catch (e:Error)
			{
				
			}
		}
		
	}

}