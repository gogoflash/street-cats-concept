package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	public class BingoWorker extends Sprite 
	{
		private var outChannel:MessageChannel;
        private var inChannel:MessageChannel;
		
		public function BingoWorker() 
		{
			//trace('WORK', Worker.current.isPrimordial);
			if(Worker.current.isPrimordial)
				return;
				
			init();
		}
		
		public function init(e:Event = null):void 
		{
			outChannel = Worker.current.getSharedProperty("out");
			
			inChannel = Worker.current.getSharedProperty("in");
			inChannel.addEventListener(Event.CHANNEL_MESSAGE, handler_receive);
			//inChannel.receive(true);
		}
		
		public function handler_receive(event:Event):void
        {
            if(inChannel.messageAvailable)
            {
            	var object:Object = inChannel.receive() as Object;
				if (!object)
					return;
					
				switch(object['command']) {
					case "deflate" : 
						(object['data'] as ByteArray).deflate();
						outChannel.send(object);
						break;
					case "inflate" : 
						(object['data'] as ByteArray).inflate();
						outChannel.send(object);
						break;	
				}
			}
        }
	}
}