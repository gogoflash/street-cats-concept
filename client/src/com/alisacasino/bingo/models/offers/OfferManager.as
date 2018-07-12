package com.alisacasino.bingo.models.offers 
{
	import by.blooddy.crypto.Adler32;
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.player.CollectCommodityItems;
	import com.alisacasino.bingo.commands.player.ShowReservedDrops;
	import com.alisacasino.bingo.controls.LoadingWheel;
	import com.alisacasino.bingo.dialogs.CommodityTakeOutDialog;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.offers.FirstTimeOfferDialog;
	import com.alisacasino.bingo.dialogs.offers.OfferDialog;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.models.universal.ValueDataTable;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.CardType;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.protocol.CustomizationType;
	import com.alisacasino.bingo.protocol.StaticDataMessage;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.store.items.OfferStoreItem;
	import com.alisacasino.bingo.utils.ConnectionManager;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.Settings;
	import com.alisacasino.bingo.utils.TimeService;
	import com.alisacasino.bingo.utils.TypeParser;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.setInterval;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	public class OfferManager extends EventDispatcher
	{
		public static var DEBUG_MODE:Boolean = true;
		
		public static const EVENT_UPDATE:String = "EVENT_OFFER_MANAGER_CHANGE";
		
		public var levelMin:uint = 0;
		
		public var gamesCountMin:uint = 0;
		
		private const PROPERTY_LAST_START:String = 'lastStart';
		
		private const PROPERTY_PURCHASE_COUNT:String = 'purchaseCount';
		
		private const PROPERTY_COOLDOWN:String = 'cooldown';
		
		private const PROPERTY_BONUS_RECEIVED:String = 'bonus_received';
		
		private const PROPERTY_SHOWS_AMOUNT:String = 'showsAmount';
		
		public function OfferManager() 
		{
			DEBUG_MODE = Constants.isDevBuild || Constants.isLocalBuild;
			
			actualOffers = new Object();
			offersById = new Object();
			disabledOffersById = new Object();
			offersByStoreItemId = new Object();
			offersStoreItemById = new Object();
			// учесть, что игрок может заплатить и в текущей сессии. И нужно будет пересчитать текущую акцию, чтобы отрубились по условию последнего платежа
			
			//offerActivityTimer = new Timer(1000);
			//offerActivityTimer.addEventListener(flash.events.TimerEvent.TIMER, handler_offerActivityTimer);
			
			rewardsAlignSingleList = [];
			rewardsAlignSingleList.push([CardAlignProperties.create(0, -24, -7)]);
			rewardsAlignSingleList.push([CardAlignProperties.create(0, -24, 5)]);
			
			rewardsAlignDoubleList = [];
			rewardsAlignDoubleList.push([CardAlignProperties.create(-40, -42, -9), CardAlignProperties.create(30, 0, 11)]);
			
			rewardsAlignTripleList = [];
			rewardsAlignTripleList.push([CardAlignProperties.create(-65, 13, -15), CardAlignProperties.create(3, -57, 0), CardAlignProperties.create(65, 47, 10)]);
			rewardsAlignTripleList.push([CardAlignProperties.create( -65, 2, -15), CardAlignProperties.create(-7, -46, -8), CardAlignProperties.create(65, 6, 10)]);
			
			rewardsAlignTripleListSlim = [];
			rewardsAlignTripleListSlim.push([CardAlignProperties.create(-44, 8, -15), CardAlignProperties.create(3, -47, 0), CardAlignProperties.create(45, 20, 10)]);
			rewardsAlignTripleListSlim.push([CardAlignProperties.create( -49, -4, -15), CardAlignProperties.create( -7, -46, -8), CardAlignProperties.create(46, 5, 10)]);
		}
		
		private var _offerId:String = '';
		
		private var _offerStart:int;
		
		private var actualOffers:Object;
		
		private var offersById:Object;
		
		private var disabledOffersById:Object;
		
		private var _processedOffers:Object;
		
		private var _currentOffer:OfferItem;
		
		private var _eventOffer:OfferItem;
		
		private var _debugOffer:OfferItem;
		
		private var _windowShowed:Boolean;
				
		private var nearestChangeTimer:Timer;
		
		private var offerActivityTimer:Timer;
		
		private var nearestChangeTime:uint;
		
		private var lastOfferHideTime:int;
		
		private var offersByStoreItemId:Object;
		private var offersStoreItemById:Object;
		
		private var rewardsAlignIndexSingle:int;
		private var rewardsAlignIndexDouble:int;
		private var rewardsAlignSingleList:Array;
		private var rewardsAlignDoubleList:Array;
		private var rewardsAlignTripleList:Array;
		private var rewardsAlignTripleListSlim:Array;
		
		private var holdOnDeactivateOfferStoreItem:OfferStoreItem;
		
		public function parseOffers(data:Object):void 
		{
			offersById = {};
			disabledOffersById = {};
			offersByStoreItemId = {};
			offersStoreItemById = {};
			
			data ||= {};
			
			var offerRaw:Object;
			var offer:OfferItem;
			var itemsPack:OfferItemsPack;
			for each(offerRaw in data) 
			{
				//continue;
				
				offer = new OfferItem();
				offer.parse(offerRaw as Object);
				
				if(offer.storeItem) {
					offersByStoreItemId[offer.storeItem.itemId] = offer;
					offersStoreItemById[offer.storeItem.itemId] = offer.storeItem;
				}	
				
				if (offer.rewards) 
				{
					for each(itemsPack in offer.rewards) 
					{
						if (itemsPack.storeItem) {
							offersByStoreItemId[itemsPack.storeItem.itemId] = offer;
							offersStoreItemById[itemsPack.storeItem.itemId] = itemsPack.storeItem;
						}	
					}
				}
				
				if (offer.enabled) {
					offersById[offer.id] = offer;
				}
				else {
					disabledOffersById[offer.id] = offer;
				}
			}
			
			if (DEBUG_MODE)
				createDebugOffers();
		}
		
		public function deserializeStaticData(staticData:StaticDataMessage):void 
		{
			if (!staticData)
			{
				sosTrace("Null static data passed to OfferManager", SOSLog.WARNING);
				return;
			}
		}
		
		public function init():void
		{
			clean();
			
			var player:Player = Player.current;
			player.addEventListener(Player.EVENT_LEVEL_CHANGE, handler_playerChange);
			player.addEventListener(Player.EVENT_LIFE_TIME_VALUE_CHANGE, handler_playerChange);
			player.addEventListener(Player.EVENT_CASH_CHANGE, handler_playerChange);
			
			setInitOffer(gameManager.clientDataManager.getValue("currentOfferId", ''));
		}
		
		public function clean():void
		{
			_offerId = offerId;
			_offerStart = offerStart;
			lastOfferHideTime = int.MIN_VALUE;
			
			_processedOffers = null;
			actualOffers = {};
			nearestChangeTime = 0;
			
			//offerActivityTimer.stop();
			
			if(nearestChangeTimer) {
				nearestChangeTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, handler_nearestChangeTimer);
				nearestChangeTimer.stop();
				nearestChangeTimer = null;
			}
		}
		
		public function resetRewardsAlignIndex():void {
			rewardsAlignIndexSingle = 0;
			rewardsAlignIndexDouble = 0;
		}
		
		public function getRewardsAlignProperties(itemsCount:int, hasCenterImage:Boolean, isSlimBackground:Boolean):Array
		{
			if (itemsCount == 1) {
				if (rewardsAlignIndexSingle >= rewardsAlignSingleList.length)
					rewardsAlignIndexSingle = 0;
				return rewardsAlignSingleList[rewardsAlignIndexSingle++];
			}
			
			if (itemsCount == 2) {
				if (rewardsAlignIndexDouble >= rewardsAlignDoubleList.length)
					rewardsAlignIndexDouble = 0;
				return rewardsAlignDoubleList[rewardsAlignIndexDouble++];
			}
			
			if (itemsCount >= 3) {
				if(isSlimBackground)
					return rewardsAlignTripleListSlim[hasCenterImage ? 0 : 1];
				else	
					return rewardsAlignTripleList[hasCenterImage ? 0 : 1];
			}
				
			return [];
		}
		
		public function getOfferStoreItemById(id:String):OfferStoreItem 
		{
			return id in offersStoreItemById ? (offersStoreItemById[id] as OfferStoreItem) : null; 
		}
		
		public function getOfferByStoreItemId(id:String):OfferItem 
		{
			return id in offersByStoreItemId ? (offersByStoreItemId[id] as OfferItem) : null; 
		}
		
		public function claimBoughtOffer(offerStoreItem:OfferStoreItem):void 
		{
			if (!offerStoreItem)
				return;
			
			if (gameManager.deactivated && PlatformServices.isIOS)
			{
				holdOnDeactivateOfferStoreItem = offerStoreItem;
				Game.addEventListener(Game.ACTIVATED, handler_iosActivate);
				return;
			}	
				
			var offerItem:OfferItem = getOfferByStoreItemId(offerStoreItem.itemId);
			if (!offerItem)
				return;
			
			var	commoditiesRewards:Array;
			
			if (offerStoreItem.isItemsPack)
			{
				commoditiesRewards = offerItem.getCommoditiesRewards(offerStoreItem.itemId);
				
				if(offerItem.type == OfferType.FIRST_PAYMENT)
					saveToClientData(offerItem.id, offerStoreItem.itemId, true);
			}
			else
			{
				commoditiesRewards = offerItem.getCommoditiesRewards();
			}
			
			var collectCommodityItemsCommand:CollectCommodityItems = new CollectCommodityItems(commoditiesRewards, "offerItem:" + offerStoreItem.itemId, true, false);
			collectCommodityItemsCommand.execute();
			
			if (offerItem.showTotalDialog) 
			{
				if(offerStoreItem.isItemsPack)
					DialogsManager.addDialog(new CommodityTakeOutDialog(commoditiesRewards, offerItem.type != OfferType.FIRST_PAYMENT, 1, completeBuyItemsPack, [offerStoreItem.data]), true);	
				else
					DialogsManager.addDialog(new CommodityTakeOutDialog(commoditiesRewards), true);	
			}
			else {
				if(offerItem.type != OfferType.FIRST_PAYMENT)
					new ShowReservedDrops(0.5).execute();
			}
			
			// ставим на кулдаун
			if (offerItem.cooldownOnPurchase > 0) {
				saveToClientData(offerItem.id, PROPERTY_COOLDOWN, TimeService.serverTime + offerItem.cooldownOnPurchase, false);
				
				// нужно подкрутить ласт старт, иначе выйдет, что по нему акция как будто до сих пор активна:
				saveToClientData(offerItem.id, PROPERTY_LAST_START, TimeService.serverTime - offerItem.duration, true);
			}
			
			lastOfferHideTime = TimeService.serverTime;
				
			var purchaseCount:int = getFromClientData(offerItem.id, PROPERTY_PURCHASE_COUNT, 0);
			saveToClientData(offerItem.id, PROPERTY_PURCHASE_COUNT, purchaseCount + 1);
			
			if (_debugOffer && offerItem.id == _debugOffer.id) 
				_debugOffer = null;
			
			refresh();
		}
		
		private function handler_iosActivate(e:Event):void 
		{
			Game.removeEventListener(Game.ACTIVATED, handler_iosActivate);
			claimBoughtOffer(holdOnDeactivateOfferStoreItem);
			holdOnDeactivateOfferStoreItem = null;
		}
		
		private function completeBuyItemsPack(offerItemsPack:OfferItemsPack):void {
			if (offerItemsPack)
				offerItemsPack.purchaseProgress = OfferItemsPack.PURCHASE_PROGRESS_COMPLETE;
		}
		
		public function getOfferBonus(offer:OfferItem):void 
		{
			if (!offer)
				return;
			
			saveToClientData(offer.id, PROPERTY_BONUS_RECEIVED, true);
			
			offerId = '';
			
			refresh();
		}
		
		/********************************************************************************************************************************
		* 
		* 
		* 
		********************************************************************************************************************************/
		
		private function handler_playerChange(e:Event):void {
			if (!currentOffer)
				refresh();
		}
		
		public function get processedOffers():Object
		{
			if (!_processedOffers)
				_processedOffers = gameManager.clientDataManager.getValue("processedOffersData", {});
			
			return _processedOffers;
		}
		
		public function saveToClientData(offerId:String, property:String, value:*, commitSave:Boolean = true):void
		{
			var offerData:Object = processedOffers[offerId] as Object;
			if (!offerData) {
				offerData = {};
				processedOffers[offerId] = offerData;
			}
			offerData[property] = value;
			
			/* lastShowStartTime, lastPurchase */
			
			/*sosTrace('OfferManager.saveFromClientData', offerId, property, value);
			for (var key:String in processedOffers) {
				var obj:Object = processedOffers[key] as Object;
				trace(obj['0.99'], obj['2.99'], obj['4.99']);
				for (var key_1:String in obj) {
					sosTrace('>', key, key_1, obj[key_1]);
				}
			}*/
			
			if(commitSave)
				gameManager.clientDataManager.setValue("processedOffersData", processedOffers, true);
		}
		
		public function getFromClientData(offerId:String, property:String, defaultValue:*):*
		{
			var offerData:Object = processedOffers[offerId] as Object;
			
			/*sosTrace('OfferManager.getFromClientData', offerId, property, (offerData && property in offerData) ? offerData[property] : (offerData));
			
			if (offerData) {
				for (var key:String in offerData) {
					sosTrace('>', key, offerData[key]);
				}
			}*/
			
			return (offerData && property in offerData) ? offerData[property] : defaultValue;
		}
		
		public function set offerId(value:String):void 
		{
			if(_offerId == value)
				return;
			
			_offerId = value;
			
			gameManager.clientDataManager.setValue("currentOfferId", _offerId);
		}
		
		public function get offerId():String 
		{
			return _offerId;
		}
		
		public function set offerStart(value:int):void 
		{
			if(_offerStart == value)
				return;
			
			_offerStart = value;
		}
		
		public function get offerStart():int 
		{
			return _offerStart;
		}
		
		public function get isAvailable():Boolean 
		{
			//if (DEBUG_MODE)
				//return true;
			
			//trace('время от реги: ', Boolean((TimeService.serverTime < (discountPurchaseCooldown + $model.player.regTime))), discountPurchaseCooldown + $model.player.regTime - TimeService.serverTime, discountPurchaseCooldown, $model.player.regTime, TimeService.serverTime);
			
			// обязательно, чтобы был получен айдишник имеющейся акции, время ее начала, а так же время последнего захода и платежа 
			if(!Game.current || !Game.current.isSignInComplete)
				return false;
				
			// верный левел
			if(Player.current.level < levelMin || Player.current.gamesCount < gamesCountMin)
				return false;
		
			return true; 
		}
		
		public function get offerActiveFinishTime():int 
		{
			if(!isAvailable || !currentOffer)
				return TimeService.serverTime - 1;
			
			return getOfferFinishTime(currentOffer, offerStart);
		}
		
		public function get dialogShowed():Boolean {
			return currentOffer ? currentOffer.dialogShowed : true;
		}
		
		public function set dialogShowed(value:Boolean):void 
		{
			if(currentOffer)
			{
				currentOffer.dialogShowed = value;
			}
		}
		
		public function get currentOffer():OfferItem 
		{
			return _debugOffer || _currentOffer;
		}
		
		public function set currentOffer(value:OfferItem):void 
		{
			if(_currentOffer == value)
				return;
			
			_currentOffer = value;
				
			if (_currentOffer && _currentOffer.iconImageAsset && !_currentOffer.iconImageAsset.loaded)
				_currentOffer.iconImageAsset.load(dispatchUpdate, null);
			
			sosTrace('OfferManager.currentOffer', _currentOffer ? value.id : 'no ');
		}
		
		public function get eventOffer():OfferItem 
		{
			return _debugOffer || _eventOffer;
		}
		
		public function set eventOffer(value:OfferItem):void 
		{
			if(_eventOffer == value)
				return;
			
			_eventOffer = value;
				
			if (_eventOffer && _eventOffer.iconImageAsset && !_eventOffer.iconImageAsset.loaded)
				_eventOffer.iconImageAsset.load(dispatchUpdate, null);
		}
		
		public function set debugOffer(value:OfferItem):void 
		{
			_debugOffer = value;
			
			if (_debugOffer && _debugOffer.iconImageAsset && !_debugOffer.iconImageAsset.loaded)
				_debugOffer.iconImageAsset.load(dispatchUpdate, null);
		}	
		
		public function get debugOffer():OfferItem 
		{
			return _debugOffer;
		}	
		
		public function isOfferMatchConditions(offer:OfferItem):Boolean 
		{
			//trace('isSaleActive', offer.id, TimeService.serverTime >= offer.start && TimeService.serverTime < offer.finish);
			var player:Player = Player.current;
			
			if (offer.roundLossCount > 0 && offer.roundLossCount > player.sequenceRoundLossCount)
				return false;
			
			//if (offer.lastPayment > 0)	
				//trace('lastPayment >> ', gameManager.lastPaymentTime, TimeService.serverTime - gameManager.lastPaymentTime, offer.lastPayment > (TimeService.serverTime - gameManager.lastPaymentTime));	
			if (offer.lastPayment > 0 && (gameManager.lastPaymentTime == 0 || offer.lastPayment > (TimeService.serverTime - gameManager.lastPaymentTime)))
				return false;
			
			//if (offer.lastVisit > 0)
				//trace('lastVisit >> ', TimeService.serverTime - gameManager.lastSignInTime, (offer.lastVisit > 0 && offer.lastVisit >(TimeService.serverTime - gameManager.lastSignInTime)));	
			if (offer.lastVisit > 0 && offer.lastVisit > (TimeService.serverTime - gameManager.lastSignInTime))	
				return false;
				
			return 	player.level < offer.maxLevel && player.level >= offer.minLevel
					&& player.lifetimeValue < offer.maxLtv && player.lifetimeValue >= offer.minLtv
					&& player.cashCount < offer.maxCash && player.cashCount >= offer.minCash;
		}
		
		public function isOfferPassStartFinish(offer:OfferItem):Boolean 
		{
			return TimeService.serverTime >= offer.start && TimeService.serverTime < offer.finish;
		}
		
		public function showDialog(offer:OfferItem, initLoadResourses:Boolean = true, callStoreOnHide:Boolean=false, canOpenOverCurrent:Boolean = true, debugMode:Boolean = false):void
		{
			if ((offer.type != OfferType.EVENT && offer.type != OfferType.SINGLE_SHOW && currentOffer != offer) && !debugMode) {
				LoadingWheel.removeIfAny();
				return;
			}
			
			if(debugMode)	
				debugOffer = offer;
				
			if (offer.isResoursesLoaded)
			{
				LoadingWheel.removeIfAny();
				
				if(offer.type == OfferType.FIRST_PAYMENT)
					DialogsManager.addDialog(new FirstTimeOfferDialog(callStoreOnHide), canOpenOverCurrent);
				else if (offer.type == OfferType.SINGLE_SHOW)
					DialogsManager.addDialog(new OfferDialog(callStoreOnHide, offer));	
				else if (offer.type == OfferType.EVENT)
					DialogsManager.addDialog(new OfferDialog(callStoreOnHide, offer));	
				else
					DialogsManager.addDialog(new OfferDialog(callStoreOnHide));	
			}
			else
			{
				if (!initLoadResourses) {
					LoadingWheel.removeIfAny();
					return;
				}
				
				// block screen
				LoadingWheel.show();
				
				offer.loadResources(showDialog, offer, false, callStoreOnHide, canOpenOverCurrent, debugMode);	
			}
		}
		
		public function tryShowOfferDialogByType(offerType:String, delay:Number = 0, blockUI:Boolean = false):void 
		{
			var offer:OfferItem = getActiveOfferByType(offerType);
			if (!offer) 
				return;
			
			if (delay > 0) {
				Starling.juggler.delayCall(tryShowOfferDialogByType, delay, offerType, 0);
				
				if (blockUI)
					Starling.current.stage.touchable = false;
				
				return;
			}
			
			Starling.current.stage.touchable = true;
			
			showDialog(offer);
		}
		
		/********************************************************************************************************************************
		* 
		* 
		* 
		********************************************************************************************************************************/
		
		
		/**
		 * Данные из полей на юзере, приходящие на старте. Этот метод запускает весь механизм. 
		*/
		public function setInitOffer(offerId:String, offerStart:int = 0):void 
		{
			_offerId = offerId;
			_offerStart = offerStart;
			
			// DEBUG: тестовые данные:
			//lastPaymentTime = TimeService.serverTime - 5*86400;
			
			//_offerId = 'FTO';
			//_offerStart = TimeService.serverTime - 25;
			
			/*(offersById['FTO'] as OfferItem).duration = 20;
			(offersById['FTO'] as OfferItem).cooldown = 10;*/
			
			//saveToClientData('FTO', PROPERTY_LAST_START, TimeService.serverTime - 25);
			
			// Для платящих 
			/*(offersById['2745'] as OfferItem).start = TimeService.serverTime + 6 - 1000000;
			(offersById['2745'] as OfferItem).duration = 5;
			(offersById['2745'] as OfferItem).cooldown = 45;
			(offersById['2745'] as OfferItem).finish = TimeService.serverTime + 10;//1140;
			
			// Для неплатящих
			(offersById['2744'] as OfferItem).start = TimeService.serverTime + 15;
			//(offersById['2744'] as OfferItem).finish = TimeService.serverTime + 20;//1140;
			(offersById['2744'] as OfferItem).lastPayment = 6;
			
			// Для незаходивших
			previousLoginTime = TimeService.serverTime - 5*24*60*60;
			(offersById['2746'] as OfferItem).start = TimeService.serverTime + 1;
			(offersById['2746'] as OfferItem).finish = TimeService.serverTime + 160;//1140;
			(offersById['2746'] as OfferItem).duration = 17;
			(offersById['2746'] as OfferItem).cooldown = 20;*/
			
			sosTrace('OfferManager.setInitOffer', offerId, offerStart);
			
			var player:Player = Player.current;
			var playerIdString:String = player.playerId.toString();
			var serverTime:int = TimeService.serverTime;
			var offer:OfferItem;
			
			for each(offer in offersById) 
			{
				//offer.duration = 120;
				//offer.cooldown = 90;
				
				if (_offerId == offer.id) {
					actualOffers[offer.id] = offer;
					continue;
				}
				
				if(serverTime > offer.finish || player.level > offer.maxLevel || player.lifetimeValue > offer.maxLtv)
					continue;
				
				if (isOfferPurchaseLimitReached(offer) || isOfferShowsAmountLimitReached(offer))
					continue;
					
				if(offer.userIds && offer.userIds.indexOf(playerIdString) == -1)	
					continue;	
					
				actualOffers[offer.id] = offer;
			}
			
			var key:String;
			var offerDataRaw:Object;
			for (key in processedOffers) 
			{
				offer = offersById[offersById];
				if (!offer)
					continue;
					
				offerDataRaw = processedOffers[key];
				
				if (PROPERTY_LAST_START in offerDataRaw)
					lastOfferHideTime = Math.max(lastOfferHideTime, int(offerDataRaw[PROPERTY_LAST_START]) + offer.duration);
				
				if (PROPERTY_COOLDOWN)
					lastOfferHideTime = Math.max(lastOfferHideTime, int(offerDataRaw[PROPERTY_COOLDOWN]) - Math.max(offer.cooldown, offer.cooldownOnPurchase));
			}
			
			refresh();
		}
		
		/**
		 * Изменились какие-то условия, пересчитать текущую активную акцию
		 * */
		public function refresh():void 
		{
			refreshCurrentOffer();
			
			setNearestChangeTimer();
			
			//trace('refresh()');
			dispatchUpdate();
		}
		
		private function refreshCurrentOffer():void 
		{
			//trace('OfferManager.refreshCurrentOffer ', isAvailable, currentOffer ? (currentOffer.id + ' ' + currentOffer.title) : 'no current offer');
			sosTrace('OfferManager.refreshCurrentOffer',  isAvailable, offerId, TimeService.serverTime, offerStart);
			
			if (currentOffer)
				sosTrace('OfferManager.refreshCurrentOffer currentOffer', currentOffer.id + ' ' + currentOffer.title, isOfferPassStartFinish(currentOffer) , !isOfferInCooldown(currentOffer, true, false), TimeService.serverTime, offerStart);
				
			
			if(!isAvailable) 
			{
				currentOffer = null;
				offerId = '';
				offerStart = 0;
				
				eventOffer = null;
				
				return;
			}
			
			var player:Player = Player.current;
			var offer:OfferItem;
			
			// ивентовые акции работают параллельно:
			eventOffer = getActiveOfferByType(OfferType.EVENT); 
			
			// даллее пробуем найти имеющуюся акцию: 
			if(offerId != null && offerId != '')
			{
				if (offerId in offersById) 
				{
					offer = offersById[offerId] as OfferItem;
				
					// оффер ожидает выдачи бонуса
					if (checkAwaitingTakeBonus(offer)) {
						currentOffer = offer;
						return;
					}
					
					// если текущая акция во временных пределах, не вошла в кулдаун, не кончились количество показов и количестов покупок, то возвращаем ее:
					if(isOfferPassStartFinish(offer) && !isOfferInCooldown(offer, true, false) && !isOfferPurchaseLimitReached(offer) && !isOfferShowsAmountLimitReached(offer)) 
					{
						currentOffer = offer;
						offerStart = getFromClientData(offer.id, PROPERTY_LAST_START, 0);
						return;
					}	
					else
					{
						offerId = '';
						offerStart = 0;
					}	
				}
				else 
				{
					offerId = '';
					offerStart = 0;
				}
			}
			
			// далее акция первого платежа:
			offer = getActiveOfferByType(OfferType.FIRST_PAYMENT);
			if(offer) 
			{
				offerStart = 0;
				offerId = offer.id;
				currentOffer = offer;
				return;
			}
			
			// далее обычная периодичная акция
			offer = getActiveOfferByType(OfferType.BASE);
			if(offer) 
			{
				offerStart = 0;
				offerId = offer.id;
				currentOffer = offer;
				return;
			}
			
			currentOffer = null;
			offerId = '';
			offerStart = 0;
			//setNearestChangeTimer();
		}
	
		private function getOfferFinishTime(offer:OfferItem, offerStartTime:int):int 
		{
			if (!offer)
				return TimeService.serverTime - 1;
		
			if (checkAwaitingTakeBonus(offer))
				return int.MAX_VALUE;
			
			if(offerStartTime == 0)
				return offer.finish;//Math.min(offer.finish, TimeService.serverTime + offer.duration);
		
			return Math.min(offer.finish, offerStartTime + offer.duration + 1);
		}
		
		private function isOfferInCooldown(offer:OfferItem, checkOverleapCooldown:Boolean = false, checkLastOfferTimeout:Boolean = true):Boolean 
		{
			if (checkAwaitingTakeBonus(offer))	
				return false;
				
			var cooldownTimestamp:int = getFromClientData(offer.id, PROPERTY_COOLDOWN, 0);
			if (cooldownTimestamp > 0 && TimeService.serverTime < cooldownTimestamp) {
				sosTrace(offer.id, 'isOfferInCooldown cooldownTimestamp > 0', cooldownTimestamp, TimeService.serverTime < cooldownTimestamp, TimeService.serverTime, cooldownTimestamp);
				return true;
			}
		
		//sosTrace('isOfferInCooldown lastStartTimestamp', TimeService.serverTime - (lastStartTimestamp + offer.duration) , lastStartTimestamp, TimeService.serverTime > (lastStartTimestamp + offer.duration), (TimeService.serverTime < (lastStartTimestamp + offer.duration + offer.cooldown)), (lastStartTimestamp + offer.duration + offer.cooldown) - TimeService.serverTime);		
			var lastStartTimestamp:int = getFromClientData(offer.id, PROPERTY_LAST_START, 0);	
			if (lastStartTimestamp > 0 && TimeService.serverTime > (lastStartTimestamp + offer.duration) && (TimeService.serverTime < (lastStartTimestamp + offer.duration + offer.cooldown))) {
				sosTrace(offer.id, 'isOfferInCooldown lastStartTimestamp > 0', lastStartTimestamp, TimeService.serverTime > (lastStartTimestamp + offer.duration), (TimeService.serverTime < (lastStartTimestamp + offer.duration + offer.cooldown)), offer.duration + offer.cooldown, TimeService.serverTime);
				return true;
			}
				
			// проверка на то, что перескочили кулдаун и должны быть как бы активны, ибо кулдаун пройден, но не всегда это так. 
			if (checkOverleapCooldown && lastStartTimestamp > 0 && (TimeService.serverTime > (lastStartTimestamp + offer.duration + offer.cooldown))) {
				sosTrace(offer.id, 'isOfferInCooldown checkOverleapCooldown', lastStartTimestamp, TimeService.serverTime , (lastStartTimestamp + offer.duration + offer.cooldown), offer.duration, offer.cooldown);
				return true;
			}
			
			if (checkLastOfferTimeout && offer.lastOfferTimeout > 0 && (offer.lastOfferTimeout > (TimeService.serverTime - lastOfferHideTime))) {
				sosTrace(offer.id, 'isOfferInCooldown checkLastOfferTimeout', offer.lastOfferTimeout, offer.lastOfferTimeout, TimeService.serverTime, lastOfferHideTime);
				return true;
			}
				
			return false;	
		}
		
		/*private function isOfferCanBeActive(offer:OfferItem, offerStartTimestamp:int):Boolean {
			if (!offer)
				return false;
			trace('>> ', TimeService.serverTime < (offerStartTimestamp + offer.duration), isOfferInCooldown(offer));
			return offerStartTimestamp != 0 && TimeService.serverTime < (offerStartTimestamp + offer.duration) && !isOfferInCooldown(offer);
		}*/
		
		public function isOfferPurchaseLimitReached(offer:OfferItem):Boolean {
			if (!offer)
				return true;
			
			var purchaseCount:int = getFromClientData(offer.id, PROPERTY_PURCHASE_COUNT, 0);	
			return offer.purchaseMaxCount > 0 && purchaseCount > 0 && purchaseCount >= offer.purchaseMaxCount;
		}
		
		private function isOfferShowsAmountLimitReached(offer:OfferItem):Boolean {
			if (!offer)
				return true;
			
			var showsAmount:int = getFromClientData(offer.id, PROPERTY_SHOWS_AMOUNT, 0);		
			return showsAmount > 0 && offer.showsAmount > 0 && showsAmount >= offer.showsAmount;
		}
		
		public function setOfferStart():void 
		{
			if(currentOffer && offerStart == 0)
			{
				offerStart = TimeService.serverTime;
				
				handleShowOffer(currentOffer);
				
				lastOfferHideTime = TimeService.serverTime + currentOffer.duration;
				
				setNearestChangeTimer();
				
				dispatchUpdate();
			}
		}
		
		public function handleShowOffer(offer:OfferItem):void 
		{
			if(offer)
			{
				saveToClientData(offer.id, PROPERTY_LAST_START, TimeService.serverTime, false);
				encreaseOfferShowsCount(offer);
				//lastOfferHideTime = TimeService.serverTime + currentOffer.duration;
			}
		}
		
		public function getActiveOfferByType(type:String):OfferItem 
		{
			var offer:OfferItem;
			var returnOffer:OfferItem;
			for each(offer in actualOffers) 
			{
				if(offer.type != type)
					continue;
				
				// акции, которой необходимо довыдать бонус условия проверки фиолетовы:
				if (checkAwaitingTakeBonus(offer))
					return offer;
				
				//trace('> ', offer.id, type, isOfferPassStartFinish(offer), isOfferMatchConditions(offer), !isOfferPurchaseLimitReached(offer), !isOfferInCooldown(offer), !isOfferShowsAmountLimitReached(offer));	
					
				if(!isOfferPassStartFinish(offer) || !isOfferMatchConditions(offer) || isOfferPurchaseLimitReached(offer) || isOfferInCooldown(offer) || isOfferShowsAmountLimitReached(offer))
					continue;
					
				if (returnOffer)
					returnOffer = offer.order > returnOffer.order ? offer : returnOffer;
				else 
					returnOffer = offer;
			}
			 
			return returnOffer;
		}
		
		public function cleanOfferClientData(offer:OfferItem):void
		{
			if(!offer)
				return;
			
			if (offer.id in processedOffers)
				delete processedOffers[offer.id];
			
			gameManager.clientDataManager.setValue("processedOffersData", processedOffers, true);	
		}
		
		private function dispatchUpdate():void {
			dispatchEventWith(EVENT_UPDATE);
		}
		
		private function encreaseOfferShowsCount(offer:OfferItem):void 
		{
			if (!offer)
				return;
				
			var showsAmount:int = getFromClientData(offer.id, PROPERTY_SHOWS_AMOUNT, 0);
			showsAmount++;
			saveToClientData(offer.id, PROPERTY_SHOWS_AMOUNT, showsAmount);
		}
		
		//-------------------------------------------------------------------------
		//
		// Таймер слежки за ближайшей следующей акцией 
		//
		//-------------------------------------------------------------------------
		
		private function setNearestChangeTimer(refreshNearestChangeTime:Boolean = true):void 
		{
			if(refreshNearestChangeTime)
				nearestChangeTime = getNearestChangeTime();
			
			var changeTimeout:uint;
			if(nearestChangeTime >= int.MAX_VALUE || nearestChangeTime == 0)
				changeTimeout = 10 * 60;
			else
				changeTimeout = Math.max(uint(nearestChangeTime - TimeService.serverTime), 1);
			
			sosTrace('setNearestChangeTimer ', changeTimeout, refreshNearestChangeTime, '|', nearestChangeTime - TimeService.serverTime);
			//trace('setNearestChangeTimer ', changeTimeout, nearestChangeTime, refreshNearestChangeTime);
			
			if(changeTimeout > 0)
			{
				if(!nearestChangeTimer) {
					nearestChangeTimer = new Timer(1000, 1);
					nearestChangeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, handler_nearestChangeTimer);
				}
				
				nearestChangeTimer.reset();
				nearestChangeTimer.repeatCount = Math.ceil(changeTimeout/2); 
				nearestChangeTimer.start();
			}
			else
			{
				if(nearestChangeTimer) 
				{
					nearestChangeTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, handler_nearestChangeTimer);
					nearestChangeTimer.stop();
					nearestChangeTimer = null;
				}
				
				//refresh();
			}
		}
		
		private function handler_nearestChangeTimer(e:TimerEvent):void 
		{
			//sosTrace('handler_nearestChangeTimer.', TimeService.serverTime, nearestChangeTime);
			if(TimeService.serverTime >= nearestChangeTime) {
				//sosTrace('handler_nearestChangeTimer CALL REFRESH');
				//trace('handler_nearestChangeTimer CALL REFRESH')//, TimeService.serverTime, nearestChangeTime);
				nearestChangeTime = 0;
				refresh();
			}
			else {
				setNearestChangeTimer(false);
			}
		}
		
		private function getNearestChangeTime():int 
		{
			if(!isAvailable)
				return 0;
			
			var player:Player = Player.current;
			var playerLevel:int = player.level;
			var offer:OfferItem;
			var minTime:int = int.MAX_VALUE;
			var serverTime:int = TimeService.serverTime;
			var cooldownOnHide:int;
			var cooldownOnPurchase:int;
			
			if (eventOffer)
				minTime = eventOffer.finish;
				
			if (currentOffer)
			{
				return Math.min(minTime, getOfferFinishTime(currentOffer, offerStart));
			}
			
			//trace('OfferManager.getNearestChangeTime');
			
			for each(offer in actualOffers) 
			{
				if(offer.type == OfferType.SINGLE_SHOW)
					continue;
					
				cooldownOnPurchase = 0;
				cooldownOnHide = 0;
				
				//trace('Акция ', offer.id, offer.finish - serverTime, serverTime, offer.start, offer.finish);
				if(serverTime >= offer.finish || !isOfferMatchConditions(offer) || isOfferPurchaseLimitReached(offer) || isOfferShowsAmountLimitReached(offer))
					continue;
				
				if (checkAwaitingTakeBonus(offer))
					continue;
				
				//trace('> ', offer.id, type, isOfferPassStartFinish(offer),  !isOfferInCooldown(offer));	
			
				if (serverTime < offer.start) {
					minTime = Math.min(minTime, Math.max(offer.start, lastOfferHideTime + offer.lastOfferTimeout));
				}
				else 
				{
					var offerData:Object = offer.id in processedOffers ? processedOffers[offer.id] : null;
					if (offerData) 
					{
						if (PROPERTY_COOLDOWN in offerData)
							cooldownOnPurchase = offerData[PROPERTY_COOLDOWN];
						
						if (PROPERTY_LAST_START in offerData)
							cooldownOnHide = offerData[PROPERTY_LAST_START] + offer.duration + offer.cooldown;
							
						if (Math.max(cooldownOnHide, cooldownOnPurchase, lastOfferHideTime + offer.lastOfferTimeout) > serverTime) {
							minTime = Math.min(minTime, Math.max(cooldownOnHide, cooldownOnPurchase, lastOfferHideTime + offer.lastOfferTimeout));
						}
					}
				}
					
				//minTime = Math.min(minTime, offer.finish);
				
				/*cooldownOnHide = getFromClientData(offer.id, PROPERTY_LAST_START, 0) + offer.duration + offer.cooldown;
				cooldownOnPurchase = getFromClientData(offer.id, PROPERTY_COOLDOWN, 0);
				if (Math.max(cooldownOnHide, cooldownOnPurchase) > serverTime) 
				{
					minTime = Math.min(minTime, Math.max(cooldownOnHide, cooldownOnPurchase) - serverTime);
					//	trace( offer.id, 'offer min change timeout: ', Math.max(cooldownOnHide, cooldownOnPurchase) - serverTime);
				}*/
			}
			
			return minTime;
		}	
		
		public function checkAwaitingTakeBonus(offer:OfferItem):Boolean
		{
			if (offer.type != OfferType.FIRST_PAYMENT)
				return false;
			
			if (getFromClientData(offer.id, PROPERTY_BONUS_RECEIVED, false))
				return false;
				
			var itemsPack:OfferItemsPack;
			for each(itemsPack in offer.rewards) 
			{
				if (itemsPack.storeItem) {
					if (!getFromClientData(offer.id, itemsPack.storeItem.itemId, false))
						return false;
				}
			}
				
			return true;
		}
		
		/********************************************************************************************************************************
		* 
		* DEBUG:
		* 
		********************************************************************************************************************************/
		
		private function createDebugOffers():void 
		{
			var offer:OfferItem;
			
			//return;
			
			/*offer = debugCreateOfferItem('FIRST TIME OFFER', OfferType.FIRST_PAYMENT, 1, null, null, 20, 0, 10, 0, 3, 0, int.MAX_VALUE, true, 4, 99, 0, 0, 60).parseRewards([debugCreateOfferAwards(90, 0.99, TypeParser.REAL, 200, 10, 20), debugCreateOfferAwards(75, 2.99, TypeParser.REAL, 500, 10, 20, 0, 2), debugCreateOfferAwards(60, 4.99, TypeParser.REAL, 650, 10, 20, 0, 0, 0, 0, 2)]);
			offersById[offer.id] = offer;*/
			
			debugCreateOfferItem('LTO 2 pack: smile, cash price', OfferType.BASE, 1, null, 'offer_cat_smile', 1000, 10, 8, 10, 3, 0, int.MAX_VALUE, true, 0, 199, 17, 0, 75, 0, 0, TypeParser.CASH).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 0, 0, 2, 2, 2), debugCreateOfferAwards(0, 0, TypeParser.REAL, 0, 0, 0, 0, 0, 0, 0, 2)]);
			debugCreateOfferItem('LTO 2 pack: no cat, FREE', OfferType.BASE, 1, null, '', 1000, 10, 8, 10, 3, 0, int.MAX_VALUE, true, 0, 199, 0, 0, 75, 0, 0, TypeParser.FREE).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 0, 0, 2, 2, 2), debugCreateOfferAwards(0, 0, TypeParser.REAL, 0, 0, 0, 0, 0, 0, 0, 2)]);
			
			//offer = debugCreateOfferItem('LTO 3 pack: amaze, FREE', OfferType.BASE, 1, null, 'offer_cat_amaze', 17, 10, 8, 10, 1, 0, int.MAX_VALUE, true, 0, 199, 0, 0, 100, 2, 0, TypeParser.FREE).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 450, 0, 2, 2, 2), debugCreateOfferAwards(0, 0, TypeParser.REAL, 0, 0, 2, 0, 0, 0, 0, 2), debugCreateOfferAwards(0, 0, TypeParser.REAL, 550, 30, 20, 10, 0, 0, 0, 1)]);
			//offersById[offer.id] = offer;
			
			/*offer = debugCreateOfferItem('LTO 1 pack: last visit 70 sec cash 250, amaze', OfferType.BASE, 1, null, 'offer_cat_amaze', 25, 10, 8, 10, 2, 0, int.MAX_VALUE, true, 0, 199, 4.95, 9.99, 10).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 250)]);
			offer.lastVisit = 70;
			offersById[offer.id] = offer;*/
			
			/*offer = debugCreateOfferItem('LTO 1 pack: last payment 70 sec cash 250, amaze', OfferType.BASE, 1, null, 'offer_cat_amaze', 25, 10, 8, 10, 2, 0, int.MAX_VALUE, true, 0, 199, 4.95, 9.99, 10).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 250)]);
			offer.lastPayment = 70;
			offersById[offer.id] = offer;*/
			
			/*debugCreateOfferItem('LTO 1 pack: cash 650, smile', OfferType.BASE, 1, null, 'offer_cat_smile', 1000, 10, 8, 10, 3, 0, int.MAX_VALUE, true, 0, 199, 4.95, 9.99, 75).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 650)]);
			debugCreateOfferItem('LTO 1 pack: cash 250, amaze', OfferType.BASE, 1, null, 'offer_cat_amaze', 1000, 10, 8, 10, 3, 0, int.MAX_VALUE, true, 0, 199, 4.95, 9.99, 0).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 250)]);
			debugCreateOfferItem('LTO 1 pack: cash 650, powerups, smile', OfferType.BASE, 1, null, 'offer_cat_smile', 1000, 10, 8, 10, 3, 0, int.MAX_VALUE, true, 0, 199, 4.95, 9.99).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 650, 2)]);
			debugCreateOfferItem('LTO 1 pack: 3 cards, smile', OfferType.BASE, 1, null, 'offer_cat_smile', 1000, 10, 8, 10, 3, 0, int.MAX_VALUE, true, 0, 199, 4.95, 9.99).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 0, 0, 2, 2, 2)]);
			debugCreateOfferItem('LTO 1 pack: cash, 3 cards, smile', OfferType.BASE, 1, null, 'offer_cat_smile', 1000, 10, 8, 10, 3, 0, int.MAX_VALUE, true, 0, 199, 4.95, 9.99).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 400, 0, 2, 2, 2)]);
			debugCreateOfferItem('LTO 1 pack: cash, 3 cards, 650 smile', OfferType.BASE, 1, null, 'offer_cat_smile', 1000, 10, 8, 10, 3, 0, int.MAX_VALUE, true, 0, 199, 4.95, 9.99).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 650, 0, 2, 2, 2)]);
			
			debugCreateOfferItem('LTO 2 pack: no cat', OfferType.BASE, 1, null, '', 1000, 10, 8, 10, 3, 0, int.MAX_VALUE, true, 0, 199, 4.95, 9.99, 75).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 0, 0, 2, 2, 2), debugCreateOfferAwards(0, 0, TypeParser.REAL, 0, 0, 0, 0, 0, 0, 0, 2)]);
			offer = debugCreateOfferItem('LTO 2 pack: amaze', OfferType.BASE, 1, null, 'offer_cat_amaze', 1000, 10, 8, 10, 3, 0, int.MAX_VALUE, true, 0, 199, 4.95, 9.99, 75).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 0, 0, 2, 2, 2), debugCreateOfferAwards(0, 0, TypeParser.REAL, 0, 0, 0, 0, 0, 0, 0, 2)]);
			debugCreateOfferItem('LTO 2 pack: no timer, smile ', OfferType.BASE, 1, null, 'offer_cat_smile', 1000, 10, 8, 10, 3, 0, int.MAX_VALUE, false, 0, 199, 4.95, 9.99, 0).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 0, 0, 20), debugCreateOfferAwards(0, 0, TypeParser.REAL, 500, 0, 0, 0, 0, 0, 0, 0)]);
			
			debugCreateOfferItem('LTO 2 pack: cash 25000, cards, amaze ', OfferType.BASE, 1, null, 'offer_cat_amaze', 1000, 10, 8, 10, 3, 0, int.MAX_VALUE, true, 0, 199, 4.95, 9.99, 75).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 25000, 0, 2, 2, 0,0,0,3), debugCreateOfferAwards(0, 0, TypeParser.REAL, 0, 0, 0, 0, 0, 0, 0, 2)]);
			debugCreateOfferItem('LTO 2 pack: cash 9999, smile', OfferType.BASE, 1, null, 'offer_cat_smile', 1000, 10, 8, 10, 3, 0, int.MAX_VALUE, true, 0, 199, 4.95, 9.99, 0).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 9999), debugCreateOfferAwards(0, 0, TypeParser.REAL, 500, 0, 0, 0, 0, 0, 0, 0)]);
			
			debugCreateOfferItem('LTO 2 pack: price minimum, amaze', OfferType.BASE, 1, null, 'offer_cat_amaze', 1000, 10, 8, 10, 3, 0, int.MAX_VALUE, true, 0, 199, 0.15, 0.95, 75).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 0, 0, 2, 2, 2), debugCreateOfferAwards(0, 0, TypeParser.REAL, 0, 0, 0, 0, 0, 0, 0, 2)]);
			debugCreateOfferItem('LTO 2 pack: price maximum wo badge, smile', OfferType.BASE, 1, null, 'offer_cat_smile', 1000, 10, 8, 10, 3, 0, int.MAX_VALUE, true, 0, 199, 999.95, 2999.95, 0).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 0, 0, 20), debugCreateOfferAwards(0, 0, TypeParser.REAL, 500, 0, 0, 0, 0, 0, 0, 0)]);
			debugCreateOfferItem('LTO 2 pack: price maximum with badge, smile', OfferType.BASE, 1, null, 'offer_cat_smile', 1000, 10, 8, 10, 3, 0, int.MAX_VALUE, true, 0, 199, 999.95, 2999.95, 90).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 0, 0, 20), debugCreateOfferAwards(0, 0, TypeParser.REAL, 500, 0, 0, 0, 0, 0, 0, 0)]);
			
			debugCreateOfferItem('LTO 3 pack: smile', OfferType.BASE, 1, null, 'offer_cat_smile', 1000, 10, 8, 10, 3, 0, int.MAX_VALUE, true, 0, 199, 4.95, 9.99, 75).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 0, 2, 4, 2), debugCreateOfferAwards(0, 0, TypeParser.REAL, 0, 0, 0, 0, 0, 0, 0, 2), debugCreateOfferAwards(0, 0, TypeParser.REAL, 0, 0, 0, 0, 1, 2, 0, 0)]);
			offer = debugCreateOfferItem('LTO 3 pack: amaze', OfferType.BASE, 1, null, 'offer_cat_amaze', 1000, 10, 8, 10, 3, 0, int.MAX_VALUE, true, 0, 199, 4.95, 9.99, 90).parseRewards([debugCreateOfferAwards(0,0, TypeParser.REAL,100), debugCreateOfferAwards(0, 0, TypeParser.REAL, 0, 0, 0, 0, 0,0,0,2), debugCreateOfferAwards(0, 0, TypeParser.REAL, 0, 0, 0, 0, 5,0,0,0)]);
			//offersById[offer.id] = offer;
			
			debugCreateOfferItem('LTO 4 pack: no timer, no cat', OfferType.BASE, 1, null, null, 1000, 10, 8, 10, 3, 0, int.MAX_VALUE, false, 0, 199, 195.95, 659.99, 0).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 100), debugCreateOfferAwards(0, 0, TypeParser.REAL, 550, 30, 20, 10, 0, 0, 0, 1), debugCreateOfferAwards(0, 0, TypeParser.REAL, 200, 0, 0, 0, 4, 1, 1, 6), debugCreateOfferAwards(0, 0, TypeParser.REAL, 0, 0, 0, 0, 0, 0, 0, 4)]);
			*/
			
			//debugAddOffersWidthCustomIcons();
			
			debugAddOffersWidthPurchasePacks();
			
			debugAddOffersWidthCustomImagesAndAnimations();
			
			
			//offer = debugCreateOfferItem('LTO ', OfferType.BASE, 1, null, 'offer_cat_smile', 20, 20, 5, 15, 1, 0, int.MAX_VALUE, true, 0, 199, 4.95, 9.99, 75, 2).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 650)]);
			//offer = debugCreateOfferItem('LTO ', OfferType.BASE, 1, null, 'offer_cat_smile', 20, 5, 5, 15, 1, TimeService.serverTime + 10, TimeService.serverTime + 67, true, 0, 199, 4.95, 9.99, 75, 2).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 650)]);
			//offersById[offer.id] = offer;
			
			
			//offer = debugCreateOfferItem('SHO ', OfferType.SINGLE_SHOW, 1, null, 'offer_cat_smile', 0, 0, 5, 15, 2, 0, int.MAX_VALUE, false, 0, 199, 4.95, 9.99, 75, 2, 1).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 650)]);
			//offersById[offer.id] = offer;
			
			
			/*offer = debugCreateOfferItem('SHO 2 purchase pack no cat', OfferType.SINGLE_SHOW, 1, null, '', 30, 0, 30, 30, 1, 0, int.MAX_VALUE, true, 0, 199, 0.0, 9.99, 0, 2, 2);
			offer.parseRewards([debugCreateOfferAwards(45, 2.99, TypeParser.REAL, 0, 0, 2, 2, 2), debugCreateOfferAwards(90, 4.99, TypeParser.REAL, 0, 0, 0, 0, 0, 0, 0, 2)]);
			offersById[offer.id] = offer;*/
			
			
			offer = debugCreateOfferItem('EVENT OFFER ', OfferType.EVENT, 1, null, 'offer_cat_smile', 20, 20, 5, 15, 2, 0, int.MAX_VALUE, true, 0, 199, 4.95, 9.99, 75, 0).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 650)]);
			offer.customIcon = 'offers/debug_icon_no_energy.png';
			//offersById[offer.id] = offer;
			
			var itemsPack:OfferItemsPack;
			for each(offer in disabledOffersById) 
			{
				if (offer.rewards) 
				{
					for each(itemsPack in offer.rewards) 
					{
						if (itemsPack.storeItem) {
							offersByStoreItemId[itemsPack.storeItem.itemId] = offer;
							offersStoreItemById[itemsPack.storeItem.itemId] = itemsPack.storeItem;
						}
					}
				}
			}
			
			
		}
		
		private static var debugOfferId:int = 1;
		
		private function debugCreateOfferItem(title:String, type:String, order:int = 1, image:String = null, animation:String = null, duration:uint = 20, lastOfferTimeout:uint = 20, cooldown:int = 5, cooldownOnPurchase:int = 10, 
											purchaseMaxCount:int = 1, start:uint = 0, finish:uint = int.MAX_VALUE, showTimer:Boolean = true, 
											minLevel:int = 0, maxLevel:int = 199, price:Number = 10, oldPrice:Number = 0, salePercents:Number = 67, showsAmount:int = 0, roundLossCount:int = 0, priceType:String = 'REAL'):OfferItem
		{
			var offer:OfferItem = new OfferItem();
			offer.parse({
				storeItemId: (debugOfferId.toString() + '_' + price.toString()),
				//touchRect:"311,526,485,74",
				price:price,
				priceType:priceType,
				salePercents:salePercents
			});
			
			offer.id = debugOfferId++.toString();
			offer.title = title;
			offer.type = type;
			offer.order = order;
			offer.image = image;
			offer.animation = animation;
			offer.start = start;
			offer.finish = finish;
			offer.duration = duration;
			offer.lastOfferTimeout = lastOfferTimeout;
			offer.cooldown = cooldown;
			offer.cooldownOnPurchase = cooldownOnPurchase;
			offer.minLevel = minLevel;
			offer.maxLevel = maxLevel;
			offer.minLtv = 0;
			offer.maxLtv = 1000;
			offer.oldPrice = oldPrice;
			offer.showsAmount = showsAmount;
			offer.purchaseMaxCount = purchaseMaxCount;
			offer.showTimer = showTimer;
			//offer.storeItem:IStoreItem;
			offer.isDebug = true;
			offer.showTotalDialog = true;
			offer.roundLossCount = roundLossCount;
			
			offer.presentationMode = OfferPresentationMode.BADGE_LOBBY | OfferPresentationMode.BADGE_STORE_BTN;
			
			offer.enabled = false;
			//offersById[offer.id] = offer;
			disabledOffersById[offer.id] = offer;
			
			if(offer.storeItem) {
				offersByStoreItemId[offer.storeItem.itemId] = offer;
				offersStoreItemById[offer.storeItem.itemId] = offer.storeItem;
			}	
			
			return offer;
		}
		
		private function debugCreateOfferAwards(percent:Number = 0, price:Number = 0, priceType:String = 'REAL', cash:int = 0, pwrUpsNormal:int=0, pwrUpsMagic:int=0, pwrUpsRare:int=0, collectionNormal:int=0, collectionMagic:int=0, collectionRare:int = 0, customizers:int = 0):Object
		{
			var awardsRaw:Array = [];
			
			if(percent > 0)
				awardsRaw['percent'] = percent;
				
			if (price > 0) 
			{
				awardsRaw['price'] = price;
				awardsRaw['priceType'] = priceType//TypeParser.REAL;
				awardsRaw['storeItemId'] = price;
			}
			
			var awardsItemsRaw:Array = [];
			awardsItemsRaw.push({type:CommodityType.CASH, quantity:cash});
			awardsItemsRaw.push({type:CommodityType.POWERUP_CARD, subType:Powerup.RARITY_NORMAL, quantity:pwrUpsNormal});
			awardsItemsRaw.push({type:CommodityType.POWERUP_CARD, subType:Powerup.RARITY_MAGIC, quantity:pwrUpsMagic});
			awardsItemsRaw.push({type:CommodityType.POWERUP_CARD, subType:Powerup.RARITY_RARE, quantity:pwrUpsRare});
			awardsItemsRaw.push({type:CommodityType.COLLECTION, subType:CardType.NORMAL, quantity:collectionNormal});
			awardsItemsRaw.push({type:CommodityType.COLLECTION, subType:CardType.MAGIC, quantity:collectionMagic});
			awardsItemsRaw.push({type:CommodityType.COLLECTION, subType:CardType.RARE, quantity:collectionRare});
			awardsItemsRaw.push({type:CommodityType.CUSTOMIZER, quantity:customizers});
			awardsRaw['items'] = awardsItemsRaw;
			
			return awardsRaw;
		}
		
		private function debugCreateOfferAwardChests(percent:Number = 0, price:Number = 0, chestsBronze:int=0, chestsSilver:int=0, chestsGold:int=0, chestsSuper:int=0, chestsPremium:int=0):Object
		{
			var awardsRaw:Array = [];
			
			if(percent > 0)
				awardsRaw['percent'] = percent;
				
			if (price > 0)
				awardsRaw['price'] = price;
			
			var awardsItemsRaw:Array = [];	
			awardsItemsRaw.push({type:CommodityType.CHEST, subType:ChestType.BRONZE, quantity:chestsBronze});
			awardsItemsRaw.push({type:CommodityType.CHEST, subType:ChestType.SILVER, quantity:chestsSilver});
			awardsItemsRaw.push({type:CommodityType.CHEST, subType:ChestType.GOLD, quantity:chestsGold});
			awardsItemsRaw.push({type:CommodityType.CHEST, subType:ChestType.SUPER, quantity:chestsSuper});
			awardsItemsRaw.push({type:CommodityType.CHEST, subType:ChestType.PREMIUM, quantity:chestsPremium});
			awardsRaw['items'] = awardsItemsRaw;
			
			return awardsRaw;
		}
		
		/*private function getStoreItem(offerPack:OfferItemsPack, price:Number = 10, salePercents:Number = 67):OfferStoreItem
		{
			debugOfferId++;
			
			var offerStoreItem:OfferStoreItem = new OfferStoreItem();
			offerStoreItem.data = offerPack;
			offerStoreItem.parse({
				storeItemId: (debugOfferId.toString() + '_' + price.toString()),
				price:price
			});
			
			offerPack.percent = salePercents;
			
			offersByStoreItemId[offerStoreItem.itemId] = offerPack.offerItem;
			offersStoreItemById[offerStoreItem.itemId] = offerStoreItem;
			
			return offerStoreItem;
		}*/
		
		public function debugGetOfferStatusString(offer:OfferItem):String
		{
			if (!offer)
				return 'no offer';
			
			var string:String = '';
			string += 'start-finish:' + debugGetHtmlBooleanString(isOfferPassStartFinish(offer));
			string += ' , cooldown pass:' + debugGetHtmlBooleanString(!isOfferInCooldown(offer));
			string += ' , pass ltv-cash-level: ' + debugGetHtmlBooleanString(isOfferMatchConditions(offer));
			string += ' , pass purchase limit: ' + debugGetHtmlBooleanString(!isOfferPurchaseLimitReached(offer));
			string += ' , pass show amount limit: ' + debugGetHtmlBooleanString(!isOfferShowsAmountLimitReached(offer));
			
			return string;
			
			//if (!Game.current.gameScreen)
				//return;
			
			//var text:String = 'is firstSession: ' + gameManager.firstSession.toString() + '\n';
			//text += 'Player.lifetimeValue: ' + Player.current.lifetimeValue.toString() + '\n';
			
			//GameScreen.debugShowTextField(text);
		}
		
		private function debugGetHtmlBooleanString(value:Boolean):String {
			return '<font color="#' + (value ? '00ff00' : 'ff0000') + '">' + value + '</font>';
		}

		public function debugGetOfferClientDataString(offer:OfferItem):String
		{
			if (!offer)
				return 'no offer';
			
			var string:String = 'OFFER CLIENT DATA: ';
			
			var offerData:Object = offer.id in processedOffers ? processedOffers[offer.id] : null;
			if (!offerData)
				return string + 'NO DATA';
			
			if (PROPERTY_PURCHASE_COUNT in offerData) {
				string += ' purchase count: ' + offerData[PROPERTY_PURCHASE_COUNT];
			}
			
			if (PROPERTY_SHOWS_AMOUNT in offerData) {
				string += ', shows amount: ' + offerData[PROPERTY_SHOWS_AMOUNT];
			}
			
			if (PROPERTY_COOLDOWN in offerData) {
				string += ', cooldown till: ' + getDateString(offerData[PROPERTY_COOLDOWN]);
			}
			
			if (PROPERTY_LAST_START in offerData) {
				string += ', last start: ' + getDateString(offerData[PROPERTY_LAST_START]);
			}

			return string;
			
			//if (!Game.current.gameScreen)
				//return;
			
			//var text:String = 'is firstSession: ' + gameManager.firstSession.toString() + '\n';
			//text += 'Player.lifetimeValue: ' + Player.current.lifetimeValue.toString() + '\n';
			
			//GameScreen.debugShowTextField(text);
		}
		
		private function getDateString(time:int):String 
		{
			var logDate:Date = new Date();
			logDate.setTime(time * 1000);
			
			return logDate.getFullYear().toString() + '.' + logDate.getMonth().toString() + "." + logDate.getDate().toString() + "_" + padWithZeroes(logDate.getHours(), 2) + "-" + padWithZeroes(logDate.getMinutes(), 2) + "-" + padWithZeroes(logDate.getSeconds(), 2);
		}
		
		private function padWithZeroes(num:int, minLength:uint):String
		{
			var str:String = num.toString();
			while (str.length < minLength)
			{
				str = "0" + str;
			}
			return str;
		}
		
		public function debugGetActiveOffers(nullItemTitle:String = ''):Array
		{
			var list:Array = [];
			var offer:OfferItem;
			
			//var parsedFromServerOffers:Array = [];
			var localDebugOffers:Array = [];
			
			for each(offer in offersById) 
			{
				if (offer.isDebug)
					localDebugOffers.push({text:offer.id + ': ' + offer.title, object:offer});
				else
					list.push({text:offer.id + ': ' + offer.title, object:offer});
			}
			
			for each(offer in disabledOffersById) 
			{
				if (offer.isDebug)
					localDebugOffers.push({text:offer.id + ': ' + offer.title, object:offer});
				else
					list.push({text:offer.id + ': ' + offer.title, object:offer});
			}
			
			list = list.concat(localDebugOffers);
			
			/*list.sort(function(a:Object, b:Object):int 
			{ 
				if (a.object.isDebug)
				{
					return 1;
				}
				if (b.object.isDebug)
				{
					return -1;
				}
				else
				{
					if (a.object.enabled)
						return -1;
					else if (b.object.enabled)
						return 1;
					else
						return 0;
				}
				
				return 0;
			});*/
					
			list.unshift({text:nullItemTitle, object:null});
			
			return list;
		}
		
		public function get debugChangeTimerInfo():String {
			var string:String = 'nearestChangeTime: ' + Math.max(nearestChangeTime - TimeService.serverTime, 0);
			if (nearestChangeTimer)
				string += ' , timer: ' + Math.max(0, nearestChangeTimer.repeatCount - nearestChangeTimer.currentCount);
			return string;
		}
		
		private function debugAddOffersWidthPurchasePacks():void 
		{
			var offerItemPacks:OfferItem = debugCreateOfferItem('LTO 2 purchase pack no cat', OfferType.BASE, 1, null, '', 1000, 10, 8, 10, 1, 0, int.MAX_VALUE, true, 0, 199, 0.0, 9.99, 0);
			offerItemPacks.parseRewards([debugCreateOfferAwards(45, 2.99, TypeParser.REAL, 0, 0, 2, 2, 2), debugCreateOfferAwards(90, 249, TypeParser.CASH, 0, 0, 0, 0, 0, 0, 0, 2)]);
			
			offerItemPacks = debugCreateOfferItem('LTO 2 purchase pack cat amaze', OfferType.BASE, 1, null, 'offer_cat_amaze', 1000, 10, 8, 10, 1, 0, int.MAX_VALUE, true, 0, 199, 0.0, 9.99, 0);
			offerItemPacks.parseRewards([debugCreateOfferAwards(45, 99, TypeParser.CASH, 3000, 0, 2, 2, 2), debugCreateOfferAwards(75, 4999, TypeParser.CASH, 0, 0, 0, 0, 0, 0, 0, 2)]);
			
			offerItemPacks = debugCreateOfferItem('LTO 3 purchase pack no cat', OfferType.BASE, 1, null, '', 1000, 10, 8, 10, 1, 0, int.MAX_VALUE, true, 0, 199, 0.0, 9.99, 0);
			offerItemPacks.parseRewards([debugCreateOfferAwards(30, 2.99, TypeParser.REAL, 0, 0, 2, 2, 2), debugCreateOfferAwards(56, 14.99, TypeParser.REAL, 0, 0, 0, 0, 0, 0, 0, 2), debugCreateOfferAwards(15, 99.9999, TypeParser.REAL, 300, 2, 0, 0, 2, 0, 0, 0)]);
			
			offerItemPacks = debugCreateOfferItem('LTO 3 purchase pack cat amaze', OfferType.BASE, 1, null, 'offer_cat_amaze', 1000, 10, 8, 10, 2, 0, int.MAX_VALUE, true, 0, 199, 0.0, 9.99, 0);
			offerItemPacks.parseRewards([debugCreateOfferAwards(45, 2.99, TypeParser.REAL, 3000, 0, 2, 2, 2), debugCreateOfferAwards(75, 44.99, TypeParser.REAL, 0, 0, 0, 0, 0, 0, 0, 2), debugCreateOfferAwards(95, 199.99, TypeParser.REAL, 0, 2, 0, 0, 2, 2, 0, 0)]);
		}
		
		private function debugAddOffersWidthCustomIcons():void 
		{
			var offerItem:OfferItem = debugCreateOfferItem('ICON TEST 1', OfferType.BASE, 1, null, '', 1000, 10, 8, 10, 1, 0, int.MAX_VALUE, true, 0, 199, 9.99, 9.99, 70).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 1000)]);
			offerItem.customIcon = 'offers/debug_icon_chest_super_top.png';
			
			offerItem = debugCreateOfferItem('ICON TEST 2', OfferType.BASE, 1, null, 'offer_cat_amaze', 1000, 10, 8, 10, 1, 0, int.MAX_VALUE, true, 0, 199, 9.99, 9.99, 0).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 1000)]);
			offerItem.customIcon = 'offers/debug_icon_gold_medal.png';
			
			offerItem = debugCreateOfferItem('ICON TEST 3', OfferType.BASE, 1, null, '', 1000, 10, 8, 10, 1, 0, int.MAX_VALUE, true, 0, 199, 9.99, 9.99, 30).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 1000)]);
			offerItem.customIcon = 'offers/debug_icon_no_energy.png';
			
			offerItem = debugCreateOfferItem('ICON TEST 4', OfferType.BASE, 1, null, 'offer_cat_amaze', 1000, 10, 8, 10, 2, 0, int.MAX_VALUE, true, 0, 199, 9.99, 9.99, 90).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 1000)]);
			offerItem.customIcon = 'offers/debug_icon_tube_blue.png';
			
		}
		
		private function debugAddOffersWidthCustomImagesAndAnimations():void 
		{
			debugCreateOfferItem('IMAGE offer fullscreen, no timer', OfferType.BASE, 1, 'offers/offer_test_fullscreen.png', null, 12000, 1200, 1000, 12210, 1, 0, int.MAX_VALUE, false, 0, 199, 19, 0, 88).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 1000), debugCreateOfferAwards(0, 0, TypeParser.REAL, 0, 10)]);
			debugCreateOfferItem('IMAGE offer partscreen', OfferType.BASE, 1, 'offers/offer_test_part_screen.png', null, 12000, 1200, 1000, 12210, 1, 0, int.MAX_VALUE, true, 0, 199, 19, 0, 33).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 500), debugCreateOfferAwards(0, 0, TypeParser.REAL, 0, 0, 0, 0, 0, 0, 1, 1)]);
			
			debugCreateOfferItem('ANIM 3 PACK', OfferType.BASE, 1, null, 'cat_disconnect', 12000, 1200, 1000, 12210, 1, 0, int.MAX_VALUE, true, 0, 199, 19, 0, 33).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 500), debugCreateOfferAwards(0, 0, TypeParser.REAL, 0, 0, 0, 0, 0, 0, 1, 1), debugCreateOfferAwards(0, 0, TypeParser.REAL, 110, 10)]);
			debugCreateOfferItem('ANIM 2 PACK', OfferType.BASE, 1, null, 'tutor_hand', 12000, 1200, 1000, 12210, 1, 0, int.MAX_VALUE, true, 0, 199, 19, 0, 33).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 500), debugCreateOfferAwards(0, 0, TypeParser.REAL, 0, 0, 0, 0, 0, 0, 1, 1)]);
			debugCreateOfferItem('ANIM 1 PACK', OfferType.BASE, 1, null, 'tutor_hand', 12000, 1200, 1000, 12210, 1, 0, int.MAX_VALUE, true, 0, 199, 19, 0, 33).parseRewards([debugCreateOfferAwards(0, 0, TypeParser.REAL, 500)]);
			
		}
		
	}
}
