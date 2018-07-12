package com.alisacasino.bingo.utils.analytics
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.Settings;
	import com.alisacasino.bingo.utils.TimeService;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAAppsflyerDataEvent;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNACommodityChangeEvent;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAEvent;
	import com.alisacasino.bingo.utils.analytics.events.AnalyticsEvent;
	import com.alisacasino.bingo.utils.analytics.events.CommodityAddedEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import starling.core.Starling;
	import starling.events.EnterFrameEvent;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DeltaDNAAnalytics
	{
		private static var devURL:String = "https://collect12825rnbng.deltadna.net/collect/api/27693335530638985336859739515160/bulk";
		private static var prodURL:String = "https://collect12825rnbng.deltadna.net/collect/api/27693340475210941605265860015160/bulk";
		private var queue:Vector.<DDNAEvent>;
		private var installConversationSent:Boolean;
		
		public static const eventConversionTable:Object = {
		
		};
		
		public function DeltaDNAAnalytics()
		{
			queue = new Vector.<DDNAEvent>();
		}
		
		public function setFrameListener(game:Game):void
		{
			game.addEventListener(EnterFrameEvent.ENTER_FRAME, current_enterFrameHandler);
		}
		
		private function current_enterFrameHandler(e:EnterFrameEvent):void
		{
			sendQueue();
		}
		
		private function sendQueue():void
		{
			if (queue.length < 1)
				return;
				
				
			var outputObject:Object = {};
			var exportedEventList:Array = [];
			
			
			while (queue.length)
			{
				exportedEventList.push(queue.shift().getContents());
			}
			
			outputObject["eventList"] = exportedEventList;
			
			var request:URLRequest = new URLRequest(Constants.isDevBuild ? devURL : prodURL);
			request.method = URLRequestMethod.POST;
			request.requestHeaders = [new URLRequestHeader("content-type", "application/json")];
			request.data = JSON.stringify(outputObject);
			sosTrace( "request.data : ", outputObject);
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loader_completeHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, loader_httpStatusHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loader_ioErrorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_securityErrorHandler);
			loader.load(request);
		}
		
		public function formatJSON(serializedJSON : String, useTabs : Boolean = true) : String {
		var strings : Object = {};

		// Save backslashes in strings and strings, so that they were not modified during the formatting.
		serializedJSON = serializedJSON.replace(/(\\.)/g, saveString);
		serializedJSON = serializedJSON.replace(/(".*?"|'.*?')/g, saveString);
		// Remove white spaces
		serializedJSON = serializedJSON.replace(/\s+/, "");

		var indent : int = 0;
		var result : String = "";

		for (var i : uint = 0; i < serializedJSON.length; i++) {
			var char : String = serializedJSON.charAt(i);
			switch (char) {
				case "{":
				case "[":
					result += char + "\n" + makeTabs(++indent, useTabs);
					break;
				case "}":
				case "]":
					result += "\n" + makeTabs(--indent, useTabs) + char;
					break;
				case ",":
					result += ",\n" + makeTabs(indent, useTabs);
					break;
				case ":":
					result += ": ";
					break;
				default:
					result += char;
					break;
			}
		}

		result = result.replace(/\{\s+\}/g, stripWhiteSpace);
		result = result.replace(/\[\s+\]/g, stripWhiteSpace);
		result = result.replace(/\[[\d,\s]+?\]/g, stripWhiteSpace);

		// restore strings
		result = result.replace(/\\(\d+)\\/g, restoreString);
		// restore backslashes in strings
		result = result.replace(/\\(\d+)\\/g, restoreString);

		return result;

		function saveString(...args) : String {
			var string : String = args[0];
			var index : uint = uint(args[2]);

			strings[index] = string;

			return "\\" + args[2] + "\\";
		}

		function restoreString(...args) : String {
			var index : uint = uint(args[1]);
			return strings[index];
		}

		function stripWhiteSpace(...args) : String {
			var value : String = args[0];
			return value.replace(/\s/g, '');
		}

		function makeTabs(count : int, useTabs : Boolean) : String {
			return new Array(count + 1).join(useTabs ? "\t" : "       ");
		}
	}
		
		public function sendEvent(deltaDNAEvent:DDNAEvent):void
		{
			if (!Settings.instance.ddnaLoggingEnabled)
				return;
			
			if (!Player.current)
				return;
			
			if (!Constants.isDevBuild && Player.current.isAdmin)
				return;
			
			queue.push(deltaDNAEvent);
		}
		
		private function loader_securityErrorHandler(e:SecurityErrorEvent):void
		{
		
		}
		
		private function loader_ioErrorHandler(e:IOErrorEvent):void
		{
		
		}
		
		private function loader_completeHandler(e:Event):void
		{
		
		}
		
		private function loader_httpStatusHandler(e:HTTPStatusEvent):void
		{
		}
		
		public function sendCommodityAddedEventCopy(commodityAddedEvent:CommodityAddedEvent):void
		{
			if (commodityAddedEvent.commodityQuantity == 0)
				return;
			
			sendEvent(new DDNACommodityChangeEvent(commodityAddedEvent));
		}
		
		public function sendInstallConversationData(data:String):void 
		{
			if (installConversationSent)
			{
				return;
			}
			
			if (Player.current && data)
			{
				var event:DDNAAppsflyerDataEvent = new DDNAAppsflyerDataEvent(data);
				if (!event.valid)
				{
					sosTrace("Invalid install data", data, SOSLog.WARNING);
					return;
				}
				sendEvent(event);
				installConversationSent = true;
			}
		}
	
	}

}