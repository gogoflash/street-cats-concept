package com.alisacasino.bingo.store
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.messages.HandlePurchaseOkMessage;
	import com.alisacasino.bingo.controls.LoadingWheel;
	import com.alisacasino.bingo.dialogs.ServiceDialog;
	import com.alisacasino.bingo.models.offers.OfferManager;
	import com.alisacasino.bingo.protocol.PurchaseOkMessage;
	import com.alisacasino.bingo.protocol.SignInMessage.Platform;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.Settings;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAStoreTransactionStateEvent;
	import com.milkmangames.nativeextensions.android.AndroidIAB;
	import com.milkmangames.nativeextensions.android.AndroidPurchase;
	import com.milkmangames.nativeextensions.android.events.AndroidBillingErrorEvent;
	import com.milkmangames.nativeextensions.android.events.AndroidBillingEvent;
	import starling.core.Starling;
	
	public class GooglePlayStore implements IStore
	{
		private const GOOGLE_PLAY_LICENSE_KEY:String = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAn76uGg2Ykp6i6OBbOu4px0ijihx7X1InnuDiQp/07Evkss6M4g6CbXNAQm1z484HsYd40t2qq1xjdLwLYeDmL64GLqsqIRJH0RYfuptg2siM/uve6O7cafHpPGcl3a8tJlpb0rAwYTBtdRVB0RBdXYpA4W9DWvE9CiJICzOnmC/yyOGlONqC0rhhwLTBcNnk0vMDu3VrSBRgtptUBZ04Ad9ACWevB7mcIkwLEJ+9oFOe+8lrVqGPjxq/zauYUC7batVwYl1S4uuaHxr3L74qN98+tz77VyqE/Gr/dQMrv2ksvrPf9EN5rtDe9jk5Vd+odHTmvv/B0kX1cttDCrtK8wIDAQAB";
		private const GOOGLE_PLAY_DEV_LICENSE_KEY:String = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnOiLkWUHyMV33nrCJGrhW+LpB/X/S+ZOPRf2CLD0OBTfoBGtfItySmXfftJecbC1TuXJmOUSq9MYptq0m2gdJpFspJmYPe4wyZ4FTmFwmcAmQ7wbXR6tZgffFjcXkMRqNJTH5MXbrPTZGRDyEwgVhNrV6fRQ1BWE84fNX8tJdV9AdAL2NgLFOjlMuBotfx9cROyLj6GhwSBRUTZG2g0l5q57RQf1vIjpWxR0bKDz0caNvTaY33iTcVdHjZ+uH9uWphGXubSjGOZsO7iToBQo8PecgcMCrg4H6JecvdGoZRDVBFjiF8E86NtarV6AIkpDFeopVHx07yqZQ3yYTUb9tQIDAQAB";
		private var _lastPurchaseReceiptObject:Object;
		
		public function get lastPurchaseReceiptObject():Object
		{
			return _lastPurchaseReceiptObject;
		}
		
		public static const APP_STORE_URL:String = "market://details?id=air.com.alisacasino.bingo";
		
		private static var sInstance:GooglePlayStore = null;
		
		private var mSettings:Settings = Settings.instance;
		
		private var mIsInitialized:Boolean;

		public static function get instance():GooglePlayStore
		{
			if (sInstance == null) {
				sInstance = new GooglePlayStore();
			}
			return sInstance;
		}
		
		public function init():void
		{
			if (!mIsInitialized) {
				AndroidIAB.create();
				AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.SERVICE_READY,onServiceReady);
				AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.PURCHASE_SUCCEEDED, onPurchaseSuccess);
				AndroidIAB.androidIAB.addEventListener(AndroidBillingErrorEvent.PURCHASE_FAILED, onPurchaseFailed);
				AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.INVENTORY_LOADED, onInventoryLoaded);
				AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.CONSUME_SUCCEEDED, onConsumed);
				AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.ITEM_DETAILS_LOADED, onItemDetails);
				if (Constants.isDevBuild)
				{
					AndroidIAB.androidIAB.startBillingService(GOOGLE_PLAY_DEV_LICENSE_KEY);
				}
				else 
				{
					AndroidIAB.androidIAB.startBillingService(GOOGLE_PLAY_LICENSE_KEY);
				}
				
				mIsInitialized = true;
			}
		}
		
		public function purchaseItem(item:IStoreItem):void
		{
			if (ServiceDialog.DEBUG_PAYMENTS && Constants.isDevBuild) 
			{
				var purchaseOkMessage:PurchaseOkMessage = new PurchaseOkMessage();
				purchaseOkMessage.itemId = item.itemId;
				var handleCommand:HandlePurchaseOkMessage = new HandlePurchaseOkMessage(purchaseOkMessage);
				Starling.juggler.delayCall(handleCommand.execute, 0.5);
				return;
			}
			
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreTransactionStateEvent(DDNAStoreTransactionStateEvent.INITIALIZED, item.itemId));
			
			_lastPurchaseReceiptObject = null;
			sosTrace( "GooglePlayStore.purchaseItem > item : " + item.itemId + " - " + item.value, SOSLog.INFO);
			AndroidIAB.androidIAB.purchaseItem(item.itemId);
		}
		
		public function consumeItem(item:IStoreItem):void
		{
			if (!item)
				return;
			
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreTransactionStateEvent(DDNAStoreTransactionStateEvent.ITEM_CONSUME_REQUESTED, item.itemId));
			
			AndroidIAB.androidIAB.consumeItem(item.itemId);
		}
		
		public function get appStoreLink():String
		{
			return APP_STORE_URL;
		}
			
		private function onServiceReady(e:AndroidBillingEvent):void
		{
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreTransactionStateEvent(DDNAStoreTransactionStateEvent.PLATFORM_PURCHASE_FAILED, e.jsonData));
			AndroidIAB.androidIAB.loadPlayerInventory();
		}

		private function onPurchaseSuccess(e:AndroidBillingEvent):void
		{
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreTransactionStateEvent(DDNAStoreTransactionStateEvent.PLATFORM_PURCHASE_COMPLETED, e.jsonData));
			AndroidIAB.androidIAB.loadPlayerInventory();
		}

		private function onPurchaseFailed(e:AndroidBillingErrorEvent):void
		{
			LoadingWheel.removeIfAny();
		}

		private function onInventoryLoaded(e:AndroidBillingEvent):void
		{
			for each (var androidPurchase:AndroidPurchase in e.purchases) {
				var item:IStoreItem = gameManager.storeData.findItemByItemId(androidPurchase.itemId);
				if (item)
				{
					
					_lastPurchaseReceiptObject = {itemId: item.itemId, receipt: androidPurchase.jsonData, transactionReceiptSignature: androidPurchase.signature};
					
					
					gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreTransactionStateEvent(DDNAStoreTransactionStateEvent.FOUND_PURCHASED_ITEM, androidPurchase.itemId));
					
					Game.dispatchEventWith(StoreEvent.PURCHASE_COMPLETED, false, {
						item: item,
						jsonData: androidPurchase.jsonData,
						signature: androidPurchase.signature
					});
					
				}
				else 
				{
					sosTrace("Could not find item with ID " + androidPurchase.itemId, SOSLog.ERROR);
					gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreTransactionStateEvent(DDNAStoreTransactionStateEvent.COULD_NOT_FIND_ITEM, androidPurchase.itemId));
				}
			}
		}

		private function onConsumed(e:AndroidBillingEvent):void
		{
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreTransactionStateEvent(DDNAStoreTransactionStateEvent.ITEM_CONSUMED, e.itemId));
			
			AndroidIAB.androidIAB.loadPlayerInventory();
		}

		private function onItemDetails(e:AndroidBillingEvent):void
		{
		}

	}
}