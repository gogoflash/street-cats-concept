package com.alisacasino.bingo.logging 
{
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.controls.LoadingWheel;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.ServerConnection;
	import com.alisacasino.bingo.utils.Settings;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import starling.core.Starling;
	
	public class SendLog extends CommandBase
	{
		private var fileName:String;
		private var content:String;
		private var showPreloader:Boolean = false;
		private var hideLoaderDelayCallId:uint;
		
		public function SendLog(fileName:String, content:String, showPreloader:Boolean = true) 
		{
			this.fileName = fileName;
			this.content = content;
			this.showPreloader = showPreloader;
		}
		
		override protected function startExecution():void 
		{
			if (!fileName || fileName == '' || !content || content == '')
				return;
			
			var hostUrl:String;
			if (ServerConnection.current)
				hostUrl = ServerConnection.current.host;
			
			if (!hostUrl)	
				hostUrl = Settings.instance.firstServerHost;
				
			if (!hostUrl) {
				if(showPreloader)
					EffectsManager.showScreenText('Cant send log. No host.');
				return;
			}
				
			var urlRequest:URLRequest = new URLRequest();
			//urlRequest.url = 'http://bingo2-dev0.alisagaming.net:9095/push';
			urlRequest.url = (hostUrl.search('http://') == -1 ? 'http://' : '') + hostUrl + ':9095/push';
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = JSON.stringify({key:(fileName+'.html'), content:content});
			urlRequest.requestHeaders.push(new URLRequestHeader("Content-type", "application/json"));
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.load(urlRequest);
			
			if (showPreloader)
			{
				LoadingWheel.show();
				hideLoaderDelayCallId = Starling.juggler.delayCall(completeLoading, 20, 'Send log timeout expire');
				
				urlLoader.addEventListener(Event.COMPLETE, completeHandler);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler); 
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
				urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityHandler); 
				urlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler); 
				
				function completeHandler(event:Event):void {
					//trace('SendLog.completeHandler');
					sosTrace('SendLog.completeHandler');
					completeLoading('Send log successfull!', true);
				}
				
				function securityHandler(event:SecurityErrorEvent):void {
					//trace('SendLog.securityHandler', event.text);
					sosTrace('SendLog.securityHandler', event.text);
					completeLoading('Send log security error', true);
				}
				
				function errorHandler(event:IOErrorEvent):void {
					//trace('SendLog.errorHandler', event.text);
					sosTrace('SendLog.errorHandler', event.text);
					completeLoading('Send log io error', true);
				}
				
				function httpStatusHandler(event:HTTPStatusEvent):void {
					//trace('SendLog.httpStatusHandler', event.status);
				}
				
				function progressHandler(event:ProgressEvent):void {
					//trace('SendLog.progressHandler', Math.ceil((event.bytesLoaded / event.bytesTotal) * 100));
					sosTrace('SendLog.progressHandler', Math.ceil((event.bytesLoaded / event.bytesTotal) * 100));
					EffectsManager.showScreenText('Send log progress: ' + String(Math.ceil((event.bytesLoaded / event.bytesTotal) * 100)) + '%');
				}
			}
		}
		
		private function completeLoading(text:String = '', cleanLoaderDelayCallId:Boolean = false):void 
		{
			if (cleanLoaderDelayCallId)
				Starling.juggler.removeByID(hideLoaderDelayCallId);
				
			LoadingWheel.removeIfAny();
			EffectsManager.showScreenText(text);
		}
		
	}

}