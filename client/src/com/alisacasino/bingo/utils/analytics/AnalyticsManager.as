package com.alisacasino.bingo.utils.analytics 
{
	import by.blooddy.crypto.Base64;
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.screens.LoadingScreen;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.TimeService;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAEvent;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAStartGameEvent;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNATutorialEvent;
	import com.alisacasino.bingo.utils.analytics.events.AnalyticsEvent;
	import com.alisacasino.bingo.utils.analytics.events.BuyInGameItemEvent;
	import com.alisacasino.bingo.utils.analytics.events.CommodityAddedEvent;
	import com.alisacasino.bingo.utils.analytics.events.PlayerStateEvent;
	import com.alisacasino.bingo.utils.sharedObjects.SharedObjectManager;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class AnalyticsManager 
	{
		private var eventQueue:Vector.<AnalyticsEvent>;
		private var _deltaDNAAnalytics:DeltaDNAAnalytics;
		
		public function get deltaDNAAnalytics():DeltaDNAAnalytics 
		{
			return _deltaDNAAnalytics;
		}
		
		public var sessionUUID:String = "";
		public var ddnaSessionUUID:String = "";
		
		public function AnalyticsManager() 
		{
			resetSessionID();
			resetDDNASessionID();
			
			eventQueue = new Vector.<AnalyticsEvent>();
			_deltaDNAAnalytics = new DeltaDNAAnalytics();
			//TimeService.addOneSecondCallback(sendOutEvents);
		}
		
		private function sendOutEvents():void 
		{
			if (eventQueue.length < 1)
			{
				return;
			}
			
			var assembledData:Array = [];
			while (eventQueue.length)
			{
				var eventData:Object = eventQueue.pop().export();
				if (eventData)
				{
					assembledData.push(eventData);
				}
			}
			
			if (assembledData.length < 1)
			{
				return;
			}
			
			var request:URLRequest = new URLRequest(Constants.ANALYTICS_HOST + "/api/clients/" + Constants.analyticsAppId + "/events");
			request.method = URLRequestMethod.POST;
			request.requestHeaders = [new URLRequestHeader("content-type", "application/json")];
			request.data = JSON.stringify(assembledData);
			
			sosTrace( "AnalyticsManager.sendOutEvents:\n" + request.data, SOSLog.INFO);
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loader_completeHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loader_ioErrorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_securityErrorHandler);
			loader.load(request);
		}
		
		private function loader_securityErrorHandler(e:SecurityErrorEvent):void 
		{
			e.preventDefault();
			sosTrace( "AnalyticsManager.loader_securityErrorHandler", SOSLog.ERROR);
		}
		
		private function loader_ioErrorHandler(e:IOErrorEvent):void 
		{
			e.preventDefault();
			sosTrace( "AnalyticsManager.loader_ioErrorHandler", SOSLog.ERROR);
		}
		
		private function loader_completeHandler(e:Event):void 
		{
			e.preventDefault();
			sosTrace( "AnalyticsManager.loader_completeHandler", SOSLog.INFO);
		}
		
		public function sendEvent(analyticsEvent:AnalyticsEvent):AnalyticsEvent 
		{
			populateEventWithContext(analyticsEvent);
			
			/*
			if (Player.current)
			{
				deltaDNAAnalytics.sendEventCopy(analyticsEvent);
			}
			*/
			
			eventQueue.push(analyticsEvent);
			
			return analyticsEvent;
		}
		
		public function populateEventWithContext(analyticsEvent:AnalyticsEvent):void 
		{
			analyticsEvent.addField("sessionUUID", sessionUUID);
			
			var deviceId:String;
			if (PlatformServices.isCanvas)
			{
				deviceId = SharedObjectManager.instance.getSharedProperty("canvasDeviceId", null);
				if (!deviceId)
				{
					deviceId = generateUUID();
					SharedObjectManager.instance.setSharedProperty("canvasDeviceId", deviceId);
				}
			}
			else 
			{
				deviceId = PlatformServices.interceptor.deviceId;
			}
			analyticsEvent.addField("deviceId", deviceId);
			analyticsEvent.addField("timestamp", TimeService.serverTimeMs);
			analyticsEvent.addField("sessionTime", getTimer()/1000);
			analyticsEvent.addField("socialId", gameManager.facebookId);
			analyticsEvent.addField("version", gameManager.getVersionString());
			analyticsEvent.addField("context", generateContextData());
			if (Player.current)
			{
				analyticsEvent.addField("playerId", Player.current.playerId);
			}
		}
		
		private function generateContextData():Object
		{
			var contextObject:Object = { };
			contextObject["firstSession"] = gameManager.firstSession;
			
			var locationString:String = "Unknown state";
			
			if (Game.current)
			{
				var gameScreen:GameScreen = Game.current.currentScreen as GameScreen;
				if (gameScreen)
				{
					if (gameScreen.state == GameScreen.STATE_IN_GAME)
					{
						locationString = "In-game";
					}
					else if (gameScreen.state == GameScreen.STATE_PRE_GAME)
					{
						locationString = "Pre-game";
					}
					else
					{
						locationString = "Unknown GameScreen state";
					}
				}
				else if(Game.current.currentScreen is LoadingScreen)
				{
					locationString = "Loading";
				}
			}
			
			contextObject["location"] = locationString;
			
			return contextObject;
		}
		
		public function resetSessionID():void 
		{
			sessionUUID = generateUUID();
		}
		
		public function resetDDNASessionID():void 
		{
			ddnaSessionUUID = generateUUID();
		}
		
		public function sendCommodityAddedEvent(commodityType:String, commodityQuantity:int, source:String):CommodityAddedEvent 
		{
			if (source == "" || !source)
			{
				sosTrace("No CAE source", new Error().getStackTrace(), SOSLog.WARNING);
			}
			var commodityAddedEvent:CommodityAddedEvent = new CommodityAddedEvent(commodityType, commodityQuantity, source);
			sendEvent(commodityAddedEvent);
			deltaDNAAnalytics.sendCommodityAddedEventCopy(commodityAddedEvent);
			return commodityAddedEvent;
		}
		
		public function sendTutorialEvent(type:String, value:* = null):void
		{
			var event:AnalyticsEvent = new AnalyticsEvent();
			event.addEventType("tutorialEvent");
			event.addField("type", type);
			if(value != null)
				event.addField("value", value);
			
			sendEvent(event);
			
			sendDeltaDNAEvent(new DDNATutorialEvent(type, value));
			//trace('tutor event > ', type, value);
		}
		
		public function sendPlayerStateEvent(player:Player):void
		{
			if (!player)
			{
				return;
			}
			sendEvent(new PlayerStateEvent(player));
		}
		
		public function sendDeltaDNAEvent(deltaDNAEvent:DDNAEvent):void 
		{
			deltaDNAAnalytics.sendEvent(deltaDNAEvent);
		}
		
		public function sendInstallConversationData(data:String):void 
		{
			deltaDNAAnalytics.sendInstallConversationData(data);
		}
		
		private function generateUUID():String
		{
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes(PlatformServices.interceptor.deviceId);
			
			var uuid:String = Base64.encode(ba);
			for (var i:int = 0; i < 8; i++) 
			{
				uuid += uint(uint.MAX_VALUE * Math.random()).toString(16);
			}
			uuid = uuid.substr(0, 72);
			return uuid;
		}
		
	}

}