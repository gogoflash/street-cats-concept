package com.alisacasino.bingo.models.gifts
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.player.CollectCommodityItem;
	import com.alisacasino.bingo.commands.player.UpdateLobbyBarsTrueValue;
	import com.alisacasino.bingo.commands.serverRequests.SendGiftsAccepted;
	import com.alisacasino.bingo.models.FacebookIdAndTimestamp;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.SignInOkMessage;
	import com.alisacasino.bingo.protocol.UnacceptedGiftMessage;
	import com.alisacasino.bingo.utils.ConnectionManager;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.FacebookData;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.GiftGenerationStrategy;
	import com.alisacasino.bingo.utils.TimeService;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAGiftClaimEvent;
	import com.alisacasino.bingo.utils.sharedObjects.SharedObjectManager;
	import flash.display3D.VertexBuffer3D;
	import flash.utils.getTimer;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class GiftsModel extends EventDispatcher
	{
		public static const CALL_INCOMING_ITEMS_TIMEOUT:int = 30 * 1000;
		
		// таймаут для посыла подарка другу:
		public static const GIFT_MESSAGE_LIFETIME_MILLIS:Number = 23 * 60 * 60 * 1000;
		public static const DEV_GIFT_MESSAGE_LIFETIME_MILLIS:Number = 0.01 * 60 * 1000;
		
		public static const PLAYER_CAN_COLLECT_GIFTS_PERIOD_MILLIS:Number = 23 * 60 * 60 * 1000;
		public static const DEV_PLAYER_CAN_COLLECT_GIFTS_PERIOD_MILLIS:Number =  6 * 60 * 60 * 1000;
		
		static public const GIFT_HARD_LIMIT:Number = 80;
		static public const DEV_GIFT_HARD_LIMIT:Number = 2;
		
		public static const UPDATE_CASH_TABLE_PERIOD:Number = 23 * 60 * 60;
		public static const DEV_UPDATE_CASH_TABLE_PERIOD:Number = 6 * 60 * 60; // на сервере захардкожено 6 часов
		
		public static var SOSTRACE_LOGGING_ENABLE:Boolean = false;
		
		public static var DEBUG_MODE:Boolean = false;
		
		public static var DEBUG_SHOW_TIMER:Boolean = false;
		
		public static const KEY_GIFT_SESSION_SEED:String = 'KEY_GIFT_SESSION_SEED';
		public static const KEY_GIFT_START_INDEX:String = 'KEY_GIFT_START_INDEX';
		public static const KEY_GIFT_ACCEPT_CYCLE_TIMESTAMP:String = 'KEY_GIFT_ACCEPT_CYCLE_TIMESTAMP';
		static public const EVENT_CHANGE_AVAILABLE_TO_GET:String = "EVENT_CHANGE_AVAILABLE_TO_GET";
		static public const GIFTS_DESERIALIZED:String = "giftsDeserialized";
		
		
		private var giftsAcceptCycleTimestamp:Number = 0;
		
		private var lastCallIncomingItems:int;  
		
		private var giftsSessionSeed:int = -1;
		private var giftsStartIndex:int = 0;
		private var giftsCashTable:Vector.<int>;
		
		
		private var _giftRequests:Vector.<IncomingGiftData>;
		
		public function get giftRequests():Vector.<IncomingGiftData>
		{
			return _giftRequests;
		}
		
		private var processedRequestIDs:Array;
		private var lastGiftAcceptedTimestampMillis:Number;
		private var giftsAcceptedInSessionCount:uint;   // инкрементится сервером когда присылаем GiftsAcceptedMessage. Обнуляется сервером каждые 6 часов(хардкод). 
		
		private var _provisionallyAcceptedGifts:Vector.<IncomingGiftData>;
		
		/**
		 * Refers to the gifts accepted in the current client session
		 */
		public function get provisionallyAcceptedGifts():Vector.<IncomingGiftData>
		{
			return _provisionallyAcceptedGifts;
		}
		
		public function GiftsModel()
		{
			processedRequestIDs = [];
			lastGiftAcceptedTimestampMillis = 0;
			giftsAcceptedInSessionCount = 0;
			_giftRequests = new Vector.<IncomingGiftData>();
			_provisionallyAcceptedGifts = new Vector.<IncomingGiftData>();
			
			Game.addEventListener(ConnectionManager.SIGN_IN_COMPLETE_EVENT, signInCompleteEventHandler);
		}
		
		public function parseSignInMessage(message:SignInOkMessage):void
		{
			giftsSessionSeed = gameManager.clientDataManager.getValue(KEY_GIFT_SESSION_SEED, -1);
			giftsStartIndex = gameManager.clientDataManager.getValue(KEY_GIFT_START_INDEX, 0);
			giftsAcceptCycleTimestamp = gameManager.clientDataManager.getValue(KEY_GIFT_ACCEPT_CYCLE_TIMESTAMP, 0); 
			
			sosTrace('GiftsModel.parseSignInMessage 0', TimeService.serverTime - giftsAcceptCycleTimestamp, giftsAcceptCycleTimestamp, TimeService.serverTime);
			
			if ((giftsAcceptCycleTimestamp > TimeService.serverTime) || ((TimeService.serverTime - giftsAcceptCycleTimestamp) > updateCashTablePeriod)) {
				cleanGiftsSeedAndIndex(TimeService.serverTime);
			}
			
			lastGiftAcceptedTimestampMillis = message.player.hasLastGiftAcceptedTimestampMillis ? message.player.lastGiftAcceptedTimestampMillis.toNumber() : 0;
			giftsAcceptedInSessionCount = message.player.hasGiftsAcceptedInSessionCount ? message.player.giftsAcceptedInSessionCount : 0;
			
			sosTrace('GiftsModel.parseSignInMessage ', giftsSessionSeed, giftsStartIndex, lastGiftAcceptedTimestampMillis);
		}
		
		public function deserializeUnacceptedGifts(gifts:/*UnacceptedGiftMessage*/Array):void
		{
			//_giftRequests = new Vector.<IncomingGiftData>();
			
			sosTrace('GiftsModel.deserializeUnacceptedGifts ', gifts ? gifts.length : 0, giftsSessionSeed, giftsStartIndex);
			
			if (!gifts)
			{
				return;
			}
			
			var newGifts:Vector.<IncomingGiftData> = new <IncomingGiftData>[];
			var incomingGiftData:IncomingGiftData;
			for each (var giftMessage:UnacceptedGiftMessage in gifts)
			{
				var requestID:String = giftMessage.requestId;
				
				//sosTrace('GiftsModel gift message: ', requestID, processedRequestIDs.indexOf(requestID), giftMessage.senderFacebookIdString);
				
				if (processedRequestIDs.indexOf(requestID) != -1)
					continue;
				
				incomingGiftData = new IncomingGiftData(giftMessage.requestId, giftMessage.senderFacebookIdString)	
				giftRequests.push(incomingGiftData);
				newGifts.push(incomingGiftData);
				processedRequestIDs.push(requestID);
			}
			
			if (giftRequests.length > 0 && giftsSessionSeed == -1) {
				giftsSessionSeed = giftRequests[0].seed;
				gameManager.clientDataManager.setValue(KEY_GIFT_SESSION_SEED, giftsSessionSeed);
				giftsCashTable = GiftGenerationStrategy.generateInboxGiftsCashTable(giftsSessionSeed, giftHardLimit, 8);
			}
			
			if (!giftsCashTable && giftsSessionSeed != -1) 
				giftsCashTable = GiftGenerationStrategy.generateInboxGiftsCashTable(giftsSessionSeed, giftHardLimit, 8);
			
			GiftGenerationStrategy.setGifts(newGifts, giftRequests, giftsCashTable, giftsStartIndex);
			
			dispatchEventWith(GIFTS_DESERIALIZED);
			dispatchEventWith(EVENT_CHANGE_AVAILABLE_TO_GET);
		}
		
		public function addToProvisionallyAcceptedGifts(gift:IncomingGiftData):void
		{
			if (provisionallyAcceptedGifts.indexOf(gift) == -1)
			{
				provisionallyAcceptedGifts.push(gift);
				dispatchEventWith(EVENT_CHANGE_AVAILABLE_TO_GET);
			}
			else
			{
				sosTrace("Trying to add gift to session-accepted a second time", SOSLog.WARNING);
			}
		}
		
		public function collectAcceptedInSessionGifts():AccumulatedGiftContents
		{
			var accumulatedGiftContents:AccumulatedGiftContents = new AccumulatedGiftContents();
			//var startIndex:int =  checkGiftAcceptSessionExpired() ? 0 : giftsAcceptedInSessionCount;
	
			var gift:IncomingGiftData;
			var collectedGifts:int = 0;
			for (var i:int = 0; i < provisionallyAcceptedGifts.length; i++)
			{
				gift = provisionallyAcceptedGifts[i];
				var index:int = giftRequests.indexOf(gift);
				if (index != -1)
					giftRequests.splice(index, 1);
				
				if (gift.cancelled)
					continue;
				
				collectedGifts++;
				//var generatedGift:Object = GiftGenerationStrategy.generateGift(i + startIndex);
				accumulatedGiftContents.addCommodityByType(CommodityType.CASH, gift.cashBonus/*generatedGift["coinsWon"]*/);
			}
			
			/*if (collectedGifts <= 0)
			{
				//If player cancelled every gift request
				accumulatedGiftContents.addCommodityByType(CommodityType.CASH, 1);
			}*/
			
			for each (var item:CommodityItem in accumulatedGiftContents.contents)
			{
				var collectCommand:CollectCommodityItem = new CollectCommodityItem(item, "gift", null, false);
				collectCommand.doNotSendPlayerUpdate = true;
				collectCommand.execute();
				
				gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAGiftClaimEvent(collectedGifts, item.type, item.quantity));
			}
			
			//new UpdateLobbyBarsTrueValue(0.4).execute();
			
			sendAndClearAcceptedGifts();
			
			Game.connectionManager.sendPlayerUpdateMessage();
			
			return accumulatedGiftContents;
		}
		
		private function sendAndClearAcceptedGifts():void
		{
			var requestIDList:Array = [];
			for each (var item:IncomingGiftData in provisionallyAcceptedGifts)
			{
				requestIDList.push(item.requestID);
			}
			
			//If last gift acceptance session was started 11 hours ago or earlier, we need to update session timestamp and reset gift count
			if(checkGiftAcceptSessionExpired())
			{
				lastGiftAcceptedTimestampMillis = Game.connectionManager.currentServerTime;
				giftsAcceptedInSessionCount = 0;
				cleanGiftsSeedAndIndex();
			}
			
			giftsAcceptedInSessionCount += requestIDList.length;
			giftsStartIndex += requestIDList.length;
			gameManager.clientDataManager.setValue(KEY_GIFT_START_INDEX, giftsStartIndex)
			
			new SendGiftsAccepted(requestIDList).execute();
			provisionallyAcceptedGifts.length = 0;
			
			dispatchEventWith(EVENT_CHANGE_AVAILABLE_TO_GET);
		}
		
		private function checkGiftAcceptSessionExpired():Boolean 
		{
			sosTrace('GiftsModel checkGiftAcceptSessionExpired ', lastGiftAcceptedTimestampMillis, giftAcceptTimeout , Game.connectionManager.currentServerTime);
			return lastGiftAcceptedTimestampMillis + giftAcceptTimeout < Game.connectionManager.currentServerTime;
		}
		
		private function get giftAcceptTimeout():Number
		{
			if (Constants.isDevBuild)
				return DEV_PLAYER_CAN_COLLECT_GIFTS_PERIOD_MILLIS;
			
			return PLAYER_CAN_COLLECT_GIFTS_PERIOD_MILLIS;
		}
		
		public function get giftMessageLifetime():Number
		{
			if (Constants.isDevBuild)
				return DEV_GIFT_MESSAGE_LIFETIME_MILLIS;
			
			return GIFT_MESSAGE_LIFETIME_MILLIS;
		}
		
		public function get giftHardLimit():Number
		{
			if (Constants.isDevBuild)
				return DEV_GIFT_HARD_LIMIT;
			
			return GIFT_HARD_LIMIT;
		}
		
		public function get updateCashTablePeriod():Number
		{
			if (Constants.isDevBuild)
				return DEV_UPDATE_CASH_TABLE_PERIOD;
			
			return UPDATE_CASH_TABLE_PERIOD;
		}
		
		
		public function getUncollectedGifts():Vector.<IncomingGiftData>
		{
			//return new <IncomingGiftData>[]; // for debug
			var result:Vector.<IncomingGiftData> = giftRequests.concat();
			
			if (SOSTRACE_LOGGING_ENABLE)
				sosTrace("GiftsModel.getUncollectedGifts giftRequests.length: ",  result.length);
				
			for each (var item:IncomingGiftData in provisionallyAcceptedGifts)
			{
				var indexInResult:int = result.indexOf(item);
				if (indexInResult != -1)
				{
					result.splice(indexInResult, 1);
				}
			}

			
			//sosTrace("Gift1.getUncollectedGifts: ", ' giftRequests. ', giftRequests.length, ' provisionallyAcceptedGifts ', provisionallyAcceptedGifts.length, ' giftsAcceptedInSessionCount ' , giftsAcceptedInSessionCount, ' checkGiftAcceptSessionExpired ', checkGiftAcceptSessionExpired());		
			
			var giftLimit:int = giftHardLimit - (checkGiftAcceptSessionExpired() ? 0 : giftsAcceptedInSessionCount);
			
			if (result.length + provisionallyAcceptedGifts.length > giftLimit)
			{
				result.length = Math.max(0, giftLimit - provisionallyAcceptedGifts.length);
			}
			
			//sosTrace("Gift2.getUncollectedGifts: ", result.length, giftLimit - provisionallyAcceptedGifts.length);		
			
			return result;
		}
		
		
		public function limitReached():Boolean
		{
			if (checkGiftAcceptSessionExpired())
			{
				return false;
			}
			return giftsAcceptedInSessionCount >= giftHardLimit;
		}
		
		public function get availableToAccept():int
		{
			return giftRequests.length;
		}
		
		public function get timeToWaitForNextGift():Number
		{
			if(DEBUG_SHOW_TIMER)
				lastGiftAcceptedTimestampMillis = 1503309850257 - 1*60*60*1000 - 37*60*1000  // 0 * 60 * 60 * 1000;
				
			if (checkGiftAcceptSessionExpired())
			{
				return 0;
			}
			//sosTrace('GiftsModel timeToWaitForNextGift ', lastGiftAcceptedTimestampMillis, giftAcceptTimeout , Game.connectionManager.currentServerTime);
			return lastGiftAcceptedTimestampMillis + giftAcceptTimeout - Game.connectionManager.currentServerTime;
		}
		
		/**
		 * количество подарков, которые реально можно забрать с учетом таймаутов и прочего.
		 * */
		public function get availableToGetCount():int
		{
			//return 8;
			
			//sosTrace('GiftsModel availableToGetCount ', getUncollectedGifts().length, timeToWaitForNextGift, giftRequests.length, _provisionallyAcceptedGifts.length, Math.min(giftHardLimit, giftRequests.length) - _provisionallyAcceptedGifts.length);
			
			if (!DEBUG_MODE && !PlatformServices.facebookManager.isConnected) 
				return 0;
			
			return getUncollectedGifts().length;	
				
			//if (getUncollectedGifts().length <= 0)
				//return 0;
				
			//return getUncollectedGifts().length; //Math.min(giftHardLimit, giftRequests.length) - _provisionallyAcceptedGifts.length;
		}
		
		public function registerInboxDialogShow():void 
		{
			SharedObjectManager.instance.setSharedProperty("lastInboxShowTime", Game.connectionManager.currentServerTime);
		}
	
		/*********************************************************************************************************************
		 *
		 *
		 * 
		 *********************************************************************************************************************/		
		
		private function signInCompleteEventHandler(e:Event):void 
		{
			callIncomingItems(true);
		}
		
		public function callIncomingItems(ignoreLastCallTimeout:Boolean = false):void 
		{
			if (!DEBUG_MODE && !PlatformServices.facebookManager.isConnected) 
				return;
			
			if (Player.current && Player.current.isActivePlayer) 	
				return;
				
			if (!ignoreLastCallTimeout && (getTimer() - lastCallIncomingItems) < CALL_INCOMING_ITEMS_TIMEOUT)
				return;
			
			//if (gameManager.giftsModel.timeToWaitForNextGift > 0)	
				//return;
			
			lastCallIncomingItems = getTimer();	
			
			Game.connectionManager.sendRequestIncomingItemsMessage();
		}
		
		private function cleanGiftsSeedAndIndex(giftsAcceptCycleTimestamp:Number = 0):void {
			sosTrace('GiftsModel.cleanGiftsSeedAndIndex');
			giftsSessionSeed = -1;
			gameManager.clientDataManager.setValue(KEY_GIFT_SESSION_SEED, -1);
			giftsStartIndex = 0;
			gameManager.clientDataManager.setValue(KEY_GIFT_START_INDEX, 0);
			giftsCashTable = null; 
			
			this.giftsAcceptCycleTimestamp = giftsAcceptCycleTimestamp;
			gameManager.clientDataManager.setValue(KEY_GIFT_ACCEPT_CYCLE_TIMESTAMP, giftsAcceptCycleTimestamp); 
		}
		
		public function clear(dispatchChangeEvent:Boolean = true):void 
		{
			cleanGiftsSeedAndIndex();
			
			processedRequestIDs = [];
			lastGiftAcceptedTimestampMillis = 0;
			giftsAcceptedInSessionCount = 0;
			
			_giftRequests = new Vector.<IncomingGiftData>();
			_provisionallyAcceptedGifts = new Vector.<IncomingGiftData>();
			
			if(dispatchChangeEvent)
				dispatchEventWith(EVENT_CHANGE_AVAILABLE_TO_GET);
		}
		
		/*********************************************************************************************************************
		 *
		 * debug methods
		 * 
		 *********************************************************************************************************************/		
		
		public function debugAddGifts(count:int):void
		{
			var newDebugGiftRequests:Vector.<IncomingGiftData> = createDebugGifts(count);
			_giftRequests = _giftRequests.concat(newDebugGiftRequests);
			
			if (_giftRequests.length > 0 && giftsSessionSeed == -1) {
				giftsSessionSeed = _giftRequests[0].seed;
				gameManager.clientDataManager.setValue(KEY_GIFT_SESSION_SEED, giftsSessionSeed);
				giftsCashTable = GiftGenerationStrategy.generateInboxGiftsCashTable(giftsSessionSeed, giftHardLimit, 8);
			}
			
			if (!giftsCashTable && giftsSessionSeed != -1) 
				giftsCashTable = GiftGenerationStrategy.generateInboxGiftsCashTable(giftsSessionSeed, giftHardLimit, 8);
			
			GiftGenerationStrategy.setGifts(newDebugGiftRequests, _giftRequests, giftsCashTable, giftsStartIndex);	
			
			dispatchEventWith(GIFTS_DESERIALIZED);
			dispatchEventWith(EVENT_CHANGE_AVAILABLE_TO_GET);
		}
		
		private function createDebugGifts(count:int):Vector.<IncomingGiftData>
		{
			var result:Vector.<IncomingGiftData> = new Vector.<IncomingGiftData>();
			
			for (var i:int = 0; i < count; i++)
			{
				var gift:IncomingGiftData = new IncomingGiftData((Math.random() * (int.MAX_VALUE - 1) + 1).toString(), generateRandomString(10));
				
				gift.senderFirstName = FacebookData.debugGetStringUserName(Math.random() > 0.8, Math.random() > 0.5);//generateRandomString(10);
				
				result.push(gift);
			}
			
			return result;
		}
		
		private function generateRandomString(numChars:int):String
		{
			var result:String = "";
			for (var i:int = 0; i < numChars; i++)
			{
				result += int(Math.random() * 26 + 10).toString(36);
			}
			return result;
		}
		
	}

}