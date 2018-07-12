package com.alisacasino.bingo.store
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.messages.HandlePurchaseOkMessage;
	import com.alisacasino.bingo.controls.LoadingWheel;
	import com.alisacasino.bingo.dialogs.ServiceDialog;
	import com.alisacasino.bingo.models.offers.OfferManager;
	import com.alisacasino.bingo.protocol.PurchaseOkMessage;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.Settings;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAStoreTransactionStateEvent;
	import com.milkmangames.nativeextensions.ios.StoreKit;
	import com.milkmangames.nativeextensions.ios.StoreKitProduct;
	import com.milkmangames.nativeextensions.ios.events.StoreKitErrorEvent;
	import com.milkmangames.nativeextensions.ios.events.StoreKitEvent;
	import starling.core.Starling;

	public class AppleAppStore implements IStore
	{
		public static const APP_STORE_URL:String = "http://alisa.tm/1u3L1q8";
		
		public static var sInstance:AppleAppStore = null;
		private var mSettings:Settings = Settings.instance;
		private var mIsInitialized:Boolean = false;
		
		private var _lastPurchaseReceiptObject:Object;
		
		public function get lastPurchaseReceiptObject():Object
		{
			return _lastPurchaseReceiptObject;
		}
		
		public function AppleAppStore()
		{
		}
		
		public static function get instance():AppleAppStore
		{
			if (sInstance == null) {
				sInstance = new AppleAppStore();
			}
			return sInstance;
		}

		public function init():void
		{
			if (!mIsInitialized) {
				StoreKit.create();
				StoreKit.storeKit.addEventListener(StoreKitEvent.PRODUCT_DETAILS_LOADED,onProductsLoaded);
				StoreKit.storeKit.addEventListener(StoreKitEvent.PURCHASE_SUCCEEDED,onPurchaseSuccess);
				StoreKit.storeKit.addEventListener(StoreKitEvent.PURCHASE_CANCELLED,onPurchaseUserCancelled);
				//StoreKit.storeKit.addEventListener(StoreKitEvent.TRANSACTIONS_RESTORED,onTransactionsRestored);
				StoreKit.storeKit.addEventListener(StoreKitErrorEvent.PRODUCT_DETAILS_FAILED,onProductsFailed);
				StoreKit.storeKit.addEventListener(StoreKitErrorEvent.PURCHASE_FAILED,onPurchaseFailed);
				//StoreKit.storeKit.addEventListener(StoreKitErrorEvent.TRANSACTION_RESTORE_FAILED,onTransactionRestoreFailed);
				
				mIsInitialized = true;
			}
			loadProducts();
		}
		
		public function loadProducts():void
		{
			// the first thing to do is to supply a list of product ids you want to display,
			// and Apple's server will respond with a list of their details (titles, price, etc)
			// assuming the ids you pass in are valid.  Even if you don't need to use this
			// information, you must make the details request before doing a purchase.
			// the list of ids is passed in as an as3 vector (typed Array.)
			var productIdList:Vector.<String>=new Vector.<String>();
			
			// when this is done, we'll get a PRODUCT_DETAILS_LOADED or PRODUCT_DETAILS_FAILED event and go	on from there...
			StoreKit.storeKit.loadProductDetails(productIdList);
		}
		
		public function onProductsLoaded(e:StoreKitEvent):void
		{
			sosTrace( "AppleAppStore.onProductsLoaded > e : " + e, SOSLog.DEBUG);
			trace("AppleAppStore::onProductsLoaded");
			for each (var product:StoreKitProduct in e.validProducts) {
				trace("AppleAppStore::onProductLoaded, product " + product);
				sosTrace( "product : " + product, SOSLog.DEBUG);
			}
		}
		
		public function onProductsFailed(e:StoreKitErrorEvent):void
		{
			sosTrace( "AppleAppStore.onProductsFailed > e : " + e, SOSLog.DEBUG);
			trace("AppleAppStore::onProductsFailed");
		}
		
		public function onPurchaseSuccess(e:StoreKitEvent):void
		{
			sosTrace( "AppleAppStore.onPurchaseSuccess > e : " + e, SOSLog.DEBUG);
			
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreTransactionStateEvent(DDNAStoreTransactionStateEvent.PLATFORM_PURCHASE_COMPLETED, e.productId));
			
			var item:IStoreItem = gameManager.storeData.findItemByItemId(e.productId);
			
			if (item) 
			{

				sosTrace( "item : " + item.itemId, SOSLog.DEBUG);
				
				var receipt:String;
				
				if(StoreKit.storeKit.isAppReceiptAvailable()) {//iOS 7+
					receipt = StoreKit.storeKit.getAppReceipt();
				} else {//iOS 6-
					receipt = e.receipt;
				}
				
				
				sosTrace( "receipt : " + receipt, SOSLog.DEBUG);
				
				_lastPurchaseReceiptObject = {itemId: item.itemId, receipt: receipt, transactionId: e.transactionId};
				
				gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreTransactionStateEvent(DDNAStoreTransactionStateEvent.FOUND_PURCHASED_ITEM, item.itemId));
				
				Game.dispatchEventWith(StoreEvent.PURCHASE_COMPLETED, false, {
					item: item,
					receipt: receipt
				});
			}
			else
			{
				gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreTransactionStateEvent(DDNAStoreTransactionStateEvent.FAILED_TO_FIND_ITEM_FOR_SUCCESSFUL_PURCHASE, e.productId));
			}
		}

		public function onPurchaseUserCancelled(e:StoreKitEvent):void
		{
			sosTrace( "AppleAppStore.onPurchaseUserCancelled > e : " + e, SOSLog.DEBUG);
			LoadingWheel.removeIfAny();
		}

		public function onPurchaseFailed(e:StoreKitErrorEvent):void
		{
			sosTrace( "AppleAppStore.onPurchaseFailed > e : " + e, SOSLog.DEBUG);
			LoadingWheel.removeIfAny();
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
			
			_lastPurchaseReceiptObject = null;
			
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreTransactionStateEvent(DDNAStoreTransactionStateEvent.INITIALIZED, item.itemId));
			
			StoreKit.storeKit.purchaseProduct(item.itemId);
		}
		
		public function consumeItem(item:IStoreItem):void
		{
		}
		
		public function get appStoreLink():String
		{
			return APP_STORE_URL;
		}
	}
}