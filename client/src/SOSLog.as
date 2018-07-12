package 
{
	import adobe.utils.CustomActions;
	import avmplus.getQualifiedClassName;
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.logging.SOSLogItem;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.GameManager;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.XMLSocket;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class SOSLog
	{
		static public const LOG_MESSAGE_LIMIT:int = 4000;
		
		static public var logMessages:/*SOSLogItem*/Array = [];
		
		static private var xmlSocket:XMLSocket;
		
		static private var messageQueue:Array = [];
		
		static private var socketConnected:Boolean;
		static private var traceOutput:com.alisacasino.bingo.logging.ITraceOutput;
		
		static public const SYSTEM:String = "SYSTEM";
		static public const DEBUG:String = "DEBUG";
		static public const INFO:String = "INFO";
		static public const WARNING:String = "WARNING";
		static public const ERROR:String = "ERROR";
		static public const FATAL:String = "FATAL";
		static public const TRACE:String = "TRACE";
		static public const FINER:String = "FINER";
		
		static private var logItemPool:Vector.<SOSLogItem> = new Vector.<SOSLogItem>();
		
		static private var candidates:Array;
		static private var connecting:Boolean;
		
		static public function connectTracer():void
		{
			disconnectTracer();
			
			if (!messageQueue)
			{
				messageQueue = [];
			}
			candidates = [];
			
			connecting = true;
			
			if (!Constants.isDevFeaturesEnabled && !Constants.isLocalBuild && !Constants.enableProdLogging)
				return;
			
			if (PlatformServices.isCanvas && !Constants.isLocalBuild)
			{
				if (!Game.current || !Game.current.gameScreenLoaded)
				{
					return;
				}
			}
			
			connectTo('localhost', 4444);
			connectTo('192.168.1.253', 4444);
			connectTo('192.168.1.106', 4444);
			connectTo('192.168.1.28', 4444);
			connectTo('192.168.43.28', 4444);
			connectTo('192.168.1.13', 4444);
			connectTo('10.0.1.55', 4444);
			connectTo('10.0.1.4', 4444);
			connectTo('10.0.1.14', 4444);
			connectTo('10.0.1.19', 4444);
			connectTo('192.168.1.7', 4444);
			connectTo('192.168.1.2', 4444);
			connectTo('192.168.1.4', 4444);
			connectTo('192.168.1.160', 4444);
		}
		
		static public function connectTo(ip:String, port:int):void
		{
			var xmlSocketCandidate:XMLSocket = new XMLSocket();
			xmlSocketCandidate.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            xmlSocketCandidate.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            xmlSocketCandidate.addEventListener(Event.CONNECT, onConnect);
			try
			{
				xmlSocketCandidate.connect(ip, port);
				candidates.push(xmlSocketCandidate);
			}
			catch (e:Error)
			{
				trace("SOSLOG.Connection error");
			}
		}
		
		static public function disconnectTracer():void
		{
			if (xmlSocket && xmlSocket.connected) 
			{
				xmlSocket.close();
				connecting = false;
				socketConnected = false;
				xmlSocket = null;
			}
		}
		
		static public function restore():void
		{
			connecting = false;
			socketConnected = false;
			xmlSocket = null;
			connectTracer();
		}
		
		static private function onConnect(e:Event):void 
		{
			if (xmlSocket)
			{
				(e.target as XMLSocket).close();
				return;
			}
			xmlSocket = e.target as XMLSocket;
			for each (var item:XMLSocket in candidates) 
			{
				if (item != xmlSocket)
				{
					try
					{
						item.close();
					}
					catch (e:Error)
					{
						
					}
				}
			}
			socketConnected = true;
			add("Connected to socket");
			while (messageQueue.length) 
			{
				xmlSocket.send(messageQueue.shift());
			}
		}
		
		static private function onSecurityError(e:SecurityErrorEvent):void 
		{
			//trace("SOSLOG.onSecurityError");
		}
		
		static private function onIOError(e:IOErrorEvent):void 
		{
			//trace("SOSLOG.onIOError");
		}
		
		static public function add(string:String, type:String = "SYSTEM"):void
		{
			if (!xmlSocket && !connecting && !GameManager.instance.deactivated)
			{
				connectTracer();
			}
			
			//trace(string);
			
			string = GameManager.instance.getSessionID() + ": " + string;
			
			var logItem:SOSLogItem = getLogItem();
			logItem.message = string;
			logItem.type = type;
			logItem.time = getTimer();
			logMessages.push(logItem);
			
			while (logMessages.length > LOG_MESSAGE_LIMIT)
			{
				logItemPool.push(logMessages.shift());
			}
			
			
			var message:String = '!SOS<showMessage key="'+type+'"><![CDATA[' + String(getTimer() / 1000) + ':' + string +']]></showMessage>';
			if (socketConnected) 
			{
				try 
				{
					xmlSocket.send(message);
				} 
				catch (e:Error) 
				{
					messageQueue.push(message);
				}
			} 
			else 
			{
				messageQueue.push(message);
			}
			
			while (messageQueue.length > LOG_MESSAGE_LIMIT) 
			{
				messageQueue.shift();
			}
		}
		
		static private function getLogItem():SOSLogItem
		{
			if (logItemPool.length)
			{
				return logItemPool.pop();
			}
			
			return new SOSLogItem();
		}
		
		static public function objectToString(target:Object, depth:uint = 0):String
		{
			var tab:String = '	';
			var i:uint;
			for (i = 0; i < depth; i++) 
			{
				tab += '	';
			}
			
			if (target == null)
			{
				return tab + "null";
			}
			
			if (typeof(target) != 'object') 
			{
				return tab+target.toString();
			} 
			
			if (target.hasOwnProperty("toString"))
			{
				return tab + target.toString();
			}
			
			var out : String = '';
			
			var item:*;
			var dat:*;
			var objectToDescribe:String;
			var enter:String = '\n';
			for (item in target) 
			{
				dat = target[item];
				if (typeof dat == 'object') 
				{
					out += tab+'['+item+']' + enter;
					objectToDescribe = objectToString(dat, depth+1);
					out += (objectToDescribe != '' ? objectToDescribe : tab + '...') + enter;
					out += tab+'[/'+item+']' + enter;
				}
			}
			
			var step:int = 0;
			for (item in target) {
				dat = target[item];
				if (typeof dat != 'object') {
					if (step) { out += enter; }
					out += tab+''+item+' = '+dat;
					step++;
				}
			}
			
			return out;
		}
		
	}

}