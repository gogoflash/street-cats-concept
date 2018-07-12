package com.alisacasino.bingo.utils.backgroundThread 
{
	import com.alisacasino.bingo.platform.PlatformServices;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	
	
	public class WorkerManager
	{
		private var worker:Worker;
        private var inChannel:MessageChannel;
        private var outChannel:MessageChannel;
		
		private var callbacks:Object;
		
		public function WorkerManager() 
		{
			callbacks = new Object();
		}
			
		public function initialize():void 
		{
			sosTrace("flash.system.Worker isSupported: ", Worker.isSupported, SOSLog.DEBUG);
			
			if (!Worker.isSupported || PlatformServices.isCanvas)
				return;
				
			var _urlRequest:URLRequest = new URLRequest("Worker.swf");
            var _loader:Loader = new Loader();
            var _lc:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null);
            
            _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
            _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
            _loader.load(_urlRequest, _lc);
		}
		
		public function get isEnabled():Boolean
		{
			return Worker.isSupported && worker;
		}
		
		public function completeHandler(e:Event):void
        { 
            worker = WorkerDomain.current.createWorker(e.target.bytes);
			worker.addEventListener(flash.events.Event.WORKER_STATE, workerStateHandler);
            inChannel = worker.createMessageChannel(Worker.current);
            outChannel = Worker.current.createMessageChannel(worker);
            
            worker.setSharedProperty("out", inChannel);
            worker.setSharedProperty("in", outChannel);
		
            inChannel.addEventListener(Event.CHANNEL_MESSAGE, handler_receiveInMessage);
            
			//trace("flash.system.Worker created");
			sosTrace("flash.system.Worker created", SOSLog.DEBUG);
            worker.start();  
            //inChannel.receive(true);
        }
		
		public function errorHandler(e:IOErrorEvent):void
        {
            sosTrace("flash.system.Worker load error", e.text, SOSLog.DEBUG);
			//trace("flash.system.Worker load error"+e.text);
        }
		
		public function deflateByteArray(byteArray:ByteArray, callback:Function, callbackId:String):void
        {
			callbacks["deflate" + callbackId] = callback;
			outChannel.send({command:"deflate", data:byteArray, callbackId:callbackId});
		}
		    
		public function inflateByteArray(byteArray:ByteArray, callback:Function, callbackId:String):void
        {
			callbacks["inflate" + callbackId] = callback;
			outChannel.send({command:"inflate", data:byteArray, callbackId:callbackId});
		}
		
		public function handler_receiveInMessage(event:Event):void
        {
            if(inChannel.messageAvailable)
            {
				var data:Object = inChannel.receive() as Object;
				if (!data)
					return;
				//sosTrace("WorkerManager.handler_receiveInMessage ", data['command'] + data['callbackId'], SOSLog.DEBUG);	
				switch(data['command']) {
					case "deflate" : 
					case "inflate" : 
						var callbackId:String = data['command'] + data['callbackId'];
						if (callbackId in callbacks) {
							callbacks[callbackId](data['data'], data['callbackId']);
							delete callbacks[callbackId];
						}
						break;
				}
			}
        }
		
		private static function workerStateHandler(e:flash.events.Event):void {
			//trace("workerStateHandler  ", e.type, e.toString());
		}
		
	}

}