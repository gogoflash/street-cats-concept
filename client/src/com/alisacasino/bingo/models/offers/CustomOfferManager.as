package com.alisacasino.bingo.models.offers 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.CustomOfferMessage;
	import com.alisacasino.bingo.protocol.SignInMessage.Platform;
	import com.alisacasino.bingo.protocol.StaticDataMessage;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.store.items.ComboItem;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.TimeService;
	import com.netease.protobuf.Int64;
	
	public class CustomOfferManager
	{
		public static var DEBUG_MODE:Boolean = false;
		
		private var offers:Array;
		private var commitToShowOffer:CustomOfferMessage;
		
		private var offersGlobalTimeout:int = 10;
		
		private const PROPERTY_LAST_HIDE:String = 'lastHide';
		
		private const PROPERTY_LAST_PURCHASE:String = 'lastPurchase';
		
		private var _lastShowTime:int = -1;
		private var _showedOffers:Object;
		
		private var offersById:Object;
		
		//private var lastOpenedDialog:LimitedTimeOfferDialog;
		
		public function CustomOfferManager() {
			offers = [];
			offersById = {};
		}
		
		public function deserializeStaticData(staticData:StaticDataMessage):void 
		{
			if (!staticData) {
				sosTrace("Null static data passed to CustomOfferManager", SOSLog.WARNING);
				return;
			}
			
			offers = [];
			offersById = {};
			var offer:CustomOfferMessage;
			var i:int;
			var length:int = staticData.customOffers.length;
			for (i = 0; i < length; i++) {
				offer = staticData.customOffers[i];
				if (offer.enabled) {
					offers.push(offer);
					offersById[offer.androidItemId] = offer;
					offersById[offer.iosItemId] = offer;
					offersById[offer.amazonItemId] = offer;
					offersById[offer.facebookItemId] = offer;
				}	
			}
			
			offersGlobalTimeout = staticData.offersGlobalTimeout.toNumber();
			
			_lastShowTime = -1;
			commitToShowOffer = null;
		
			if(DEBUG_MODE)
				debugCreateTestOffers();
		}
		/*
		public function trigger(trigger:String, showImmediate:Boolean = true):LimitedTimeOfferDialog
		{
			var offer:CustomOfferMessage = getOffer(trigger);
			
			//if (showImmediate) 
				//return showOfferDialog(offer);
			
			commitToShowOffer = offer;
			return null;	
		}
		*/
		
		public function triggerCriticalResourceValues():void
		{
			if(!Player.current)
				return;
			
			//trace('> ', Player.current.keysCount > Constants.CRITICAL_VALUE_KEYS , Player.current.coinsCount > Constants.CRITICAL_VALUE_COINS,
				//Player.current.energyCount > Constants.CRITICAL_VALUE_ENERGY, Player.current.ticketsCount > Constants.CRITICAL_VALUE_TICKETS);
				
			if (Player.current.cashCount > Constants.CRITICAL_VALUE_CASH &&
				gameManager.powerupModel.powerupsTotal > Constants.CRITICAL_VALUE_ENERGY) {
					if (commitToShowOffer && commitToShowOffer.trigger == OfferTriggers.LOW_RESOURCES)
						commitToShowOffer = null;
					return;	
				}
			
			commitToShowOffer = getOffer(OfferTriggers.LOW_RESOURCES);	
			//trace('> 1', commitToShowOffer != null);
		}
		
		/*
		public function commitShowOfferDialog(clearCommitToShowTrigger:Boolean = true):LimitedTimeOfferDialog
		{
			if (!commitToShowOffer)
				return null;
				
			// чекаем. может условия уже не выполняются
			if (!checkOfferRestrictions(commitToShowOffer)) {
				commitToShowOffer = null;
				return null;
			}
			
			var dialog:LimitedTimeOfferDialog = showOfferDialog(commitToShowOffer);
			
			if(clearCommitToShowTrigger)
				commitToShowOffer = null;
			
			return dialog;	
		}
		*/
		
		private function checkOfferRestrictions(offer:CustomOfferMessage):Boolean
		{
			if (!offer || inactiveByGlobalTimeout())
				return false;
				
			if (getCustomOfferId(offer) in showedOffers) {
				var offerData:Object = showedOffers[getCustomOfferId(offer)];
				//trace('client data, offer ', offer.trigger, PROPERTY_LAST_HIDE in offerData ? (TimeService.serverTime - offerData[PROPERTY_LAST_HIDE]) : 0, PROPERTY_LAST_PURCHASE in offerData ? (TimeService.serverTime - offerData[PROPERTY_LAST_PURCHASE]): 0 );
				if (PROPERTY_LAST_HIDE in offerData && offer.timeoutOnHide.toNumber() > 0 && (TimeService.serverTime - offerData[PROPERTY_LAST_HIDE] < offer.timeoutOnHide.toNumber()))
					return false;
				
				if (PROPERTY_LAST_PURCHASE in offerData && offer.timeoutOnPurchase.toNumber() > 0 && (TimeService.serverTime - offerData[PROPERTY_LAST_PURCHASE] < offer.timeoutOnPurchase.toNumber()))
					return false;
			}
			
			//trace('lifetime (to check must be false, false)', Player.current.lifetimeValue, offer.ltvMin, offer.ltvMax, isNaN(offer.ltvMin) ? 'NaN' : (Player.current.lifetimeValue < offer.ltvMin), isNaN(offer.ltvMax) ? 'NaN' : (Player.current.lifetimeValue > offer.ltvMax));
			
			if (Player.current.lifetimeValue < offer.ltvMin)
				return false;
				
			if (offer.ltvMax != -1 && Player.current.lifetimeValue > offer.ltvMax)
				return false;
				
			return true;	
		}
		
		private function getOffer(trigger:String):CustomOfferMessage
		{
			if (inactiveByGlobalTimeout())
				return null;
				
			var offer:CustomOfferMessage;
			var i:int;
			var length:int = offers.length;
			for (i = 0; i < length; i++) {
				offer = offers[i] as CustomOfferMessage;
				if (offer.trigger == trigger && checkOfferRestrictions(offer))
					return offer;
			}
			
			return null;
		}
		
		private function inactiveByGlobalTimeout():Boolean
		{
			//trace('inactive by custom offer global timer ', (TimeService.serverTime - lastShowTime) < offersGlobalTimeout, TimeService.serverTime - lastShowTime); 
			return (TimeService.serverTime - lastShowTime) < offersGlobalTimeout;
		}
		
		/*
		private function showOfferDialog(offerMessage:CustomOfferMessage):LimitedTimeOfferDialog
		{
			if (!offerMessage)
				return null;
			
			var comboItem:ComboItem = new ComboItem(null);
			comboItem.parseCustomOfferMessage(offerMessage);
			
			lastShowTime = TimeService.serverTime;
			
			lastOpenedDialog = new LimitedTimeOfferDialog(comboItem);
			lastOpenedDialog.show();
			return lastOpenedDialog;
		}
		*/
		
		public function handleCloseOfferDialog(comboItem:ComboItem):void
		{
			if (!comboItem.isCustomOffer)
				return;
				
			//lastOpenedDialog = null;
				
			saveToClientData(comboItem.itemId, PROPERTY_LAST_HIDE, TimeService.serverTime)
		}
		
		public function handlePurchase(comboItem:ComboItem):void
		{
			/*
			// remove dialog
			if(lastOpenedDialog) {
				lastOpenedDialog.closeDialog();
				lastOpenedDialog = null;
			}
			*/
			
			if(comboItem.isCustomOffer)
				saveToClientData(comboItem.itemId, PROPERTY_LAST_PURCHASE, TimeService.serverTime)
		}
		
		public function saveToClientData(offerId:String, property:String, value:*):void
		{
			var offerData:Object = showedOffers[offerId];
			if (!offerData) {
				offerData = {};
				showedOffers[offerId] = offerData;
			}
			offerData[property] = value;
			
			gameManager.clientDataManager.setValue("customOfferLastShowTime", showedOffers);
		}
		
		public function get showedOffers():Object
		{
			if (!_showedOffers)
				_showedOffers = gameManager.clientDataManager.getValue("customOfferShowedData", {});
			
			return _showedOffers;
		}
		
		public function get lastShowTime():int
		{
			if (_lastShowTime == -1)
				_lastShowTime = gameManager.clientDataManager.getValue("customOfferLastShowTime", 0);
			
			return _lastShowTime;
		}
		
		public function set lastShowTime(value:int):void 
		{
			if (_lastShowTime == value)
				return;
			_lastShowTime = value;
			gameManager.clientDataManager.setValue("customOfferLastShowTime", _lastShowTime);
		}
		
		public static function getCustomOfferId(message:CustomOfferMessage):String
		{
			switch(PlatformServices.platform) {
				case Platform.APPLE_APP_STORE: 	return message.iosItemId;
				case Platform.AMAZON_APP_STORE:	return message.amazonItemId;
				case Platform.GOOGLE_PLAY:		return message.androidItemId;
				default: 						return message.facebookItemId;
			}
		}
		
		public function getOfferById(id:String):ComboItem
		{
			var offer:CustomOfferMessage = id in offersById ? offersById[id] : null
			if (!offer)
				return null;
			
			var comboItem:ComboItem = new ComboItem(null);
			comboItem.parseCustomOfferMessage(offer);
			return comboItem;
		}
		
		public function debugCreateTestOffers():void
		{
			//debugCreateTestOffer(OfferTriggers.AFTER_NO_MONEY_ALERT);
			//debugCreateTestOffer(OfferTriggers.BUY_DIALOG_EXIT, null, 20, 20);
			//debugCreateTestOffer(OfferTriggers.EMPTY_GIFT_DIALOG_CLOSE, null, 5, 5);
			//debugCreateTestOffer(OfferTriggers.FREE_DAUB_ALERT_FINISHED);
			//debugCreateTestOffer(OfferTriggers.HARVEST_DAILY_BONUS);
			//debugCreateTestOffer(OfferTriggers.INSTEAD_INVITE_FRIENDS);
			//debugCreateTestOffer(OfferTriggers.LOW_RESOURCES);
			//debugCreateTestOffer(OfferTriggers.ROUND_FINISH);
		}
		
		public function debugCreateTestOffer(trigger:String, id:String = null, timeoutOnHide:int=0,  timeoutOnPur:int=0):void
		{
			var offer:CustomOfferMessage = new CustomOfferMessage();
			offer.trigger = trigger;
			offer.title = trigger;
			
			offer.facebookItemId = id || trigger;
			
			offer.ltvMax = 0;
			offer.ltvMin = 0;
			offer.price = parseFloat((200 * Math.random()).toFixed(2));
			offer.priceWithSale = parseFloat((200 * Math.random()).toFixed(2));
			offer.salePercents = int(100 * Math.random());
			
			offer.enabled = true;
			offer.timeout
			offer.timeoutOnHide = Int64.fromNumber(timeoutOnHide);
			offer.timeoutOnPurchase = Int64.fromNumber(timeoutOnPur);
			
			offers.push(offer);
			
			offersById[offer.androidItemId] = offer;
			offersById[offer.iosItemId] = offer;
			offersById[offer.amazonItemId] = offer;
			offersById[offer.facebookItemId] = offer;
			
			offer.items = [];
			var item:CommodityItemMessage;
			
			
			item = new CommodityItemMessage();
			item.type = Type.CASH;
			item.quantity = int(47*Math.random());
			offer.items.push(item);
			
			item = new CommodityItemMessage();
			item.type = Type.ENERGY;
			item.quantity = int(74*Math.random());
			offer.items.push(item);
			
			/*item = new CommodityItemMessage();
			item.type = Type.KEY;
			item.quantity = int(84*Math.random());
			offer.items.push(item);
			
			item = new CommodityItemMessage();
			item.type = Type.TICKET;
			item.quantity = int(84*Math.random());
			offer.items.push(item);
			
			item = new CommodityItemMessage();
			item.type = Type.SLOT_MACHINE_SPIN_3;
			item.quantity = 1;
			offer.items.push(item);
			
			item = new CommodityItemMessage();
			item.type = Type.DAUB_HINT;
			item.quantity = 2;
			offer.items.push(item);
			*/
		}
		
		public function debugCleanOffersData():void {
			
		}
	
	}

}