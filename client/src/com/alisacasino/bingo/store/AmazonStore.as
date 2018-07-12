package com.alisacasino.bingo.store
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.controls.LoadingWheel;
	import com.alisacasino.bingo.utils.Settings;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAStoreTransactionStateEvent;
	import com.amazon.device.iap.cpt.AmazonIapV2;
	import com.amazon.device.iap.cpt.AmazonIapV2Event;
	import com.amazon.device.iap.cpt.PurchaseResponse;
	import com.amazon.device.iap.cpt.RequestOutput;
	import com.amazon.device.iap.cpt.SkuInput;
	import com.amazon.device.iap.cpt.SkusInput;
	

	public class AmazonStore implements IStore
	{
		public static const APP_STORE_URL:String = "amzn://apps/android?p=air.com.alisacasino.bingo";
		
		private static var sInstance:AmazonStore = null;
		private var mIsInitialized:Boolean;
		private var mSettings:Settings = Settings.instance;
		
		private var _lastPurchaseReceiptObject:Object;
		
		public function get lastPurchaseReceiptObject():Object
		{
			return _lastPurchaseReceiptObject;
		}
		
		public static function get instance():AmazonStore
		{
			if (sInstance == null) {
				sInstance = new AmazonStore();
			}
			return sInstance;
		}
		
		public function init():void
		{
			sosTrace( "AmazonStore.init", SOSLog.DEBUG);
			if (!mIsInitialized) 
			{
				sosTrace( "mIsInitialized : " + mIsInitialized, SOSLog.DEBUG);
				AmazonIapV2.addEventListener(AmazonIapV2Event.PURCHASE_RESPONSE, purchaseResponseHandler);
				AmazonIapV2.addEventListener(AmazonIapV2Event.GET_PURCHASE_UPDATES_RESPONSE, getPurchaseUpdatesResponseHandler);
				AmazonIapV2.addEventListener(AmazonIapV2Event.GET_PRODUCT_DATA_RESPONSE, getProductDataResponseHandler);
				AmazonIapV2.addEventListener(AmazonIapV2Event.GET_USER_DATA_RESPONSE, getUserDataResponseHandler);
				mIsInitialized = true;
			}
		}
		
		private function getUserDataResponseHandler(e:AmazonIapV2Event):void 
		{
			sosTrace( "AmazonStore.getUserDataResponseHandler > e : " + e, SOSLog.DEBUG);
		}
		
		private function getProductDataResponseHandler(e:AmazonIapV2Event):void 
		{
			sosTrace( "AmazonStore.getProductDataResponseHandler > e : " + e, SOSLog.DEBUG);
		}
		
		private function getPurchaseUpdatesResponseHandler(e:AmazonIapV2Event):void 
		{
			sosTrace( "AmazonStore.getPurchaseUpdatesResponseHandler > e : " + e, SOSLog.DEBUG);
		}
		
		public function purchaseItem(item:IStoreItem):void
		{
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreTransactionStateEvent(DDNAStoreTransactionStateEvent.INITIALIZED, item.itemId));
			
			_lastPurchaseReceiptObject = null;
			sosTrace( "AmazonStore.purchaseItem > item : " + item, SOSLog.DEBUG);
			var skuInput:SkuInput = new SkuInput(item.itemId);
			var requestOutput:RequestOutput = AmazonIapV2.purchase(skuInput);
			sosTrace( "requestOutput : " + requestOutput.requestId, SOSLog.DEBUG);
			
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreTransactionStateEvent(DDNAStoreTransactionStateEvent.AMAZON_REQUEST_ID_RECEIVED, requestOutput.requestId));
		}
		
		private function purchaseResponseHandler(e:AmazonIapV2Event):void 
		{
			sosTrace( "AmazonStore.purchaseResponseHandler > e : " + e, SOSLog.DEBUG);
			var response:PurchaseResponse = e.purchaseResponse;
			
			sosTrace( "response : " + response, SOSLog.DEBUG);
			sosTrace( "response : " + response.status, SOSLog.DEBUG);
			
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreTransactionStateEvent(DDNAStoreTransactionStateEvent.PLATFORM_PURCHASE_COMPLETED, response.status + "," + response.requestId));
			
			
			if (response.status == "SUCCESSFUL")
			{
				var item:IStoreItem = gameManager.storeData.findItemByItemId(response.purchaseReceipt.sku);
				
				if (item)
				{
					_lastPurchaseReceiptObject = {itemId: item.itemId, amazonPurchaseToken: response.purchaseReceipt.receiptId, amazonUserID: response.amazonUserData.userId};
					
					
					gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreTransactionStateEvent(DDNAStoreTransactionStateEvent.FOUND_PURCHASED_ITEM, item.itemId));
					
					Game.dispatchEventWith(StoreEvent.PURCHASE_COMPLETED, false, {
						item: item,
						userId: response.amazonUserData.userId,
						receiptId: response.purchaseReceipt.receiptId
					});
					
				}
				else
				{
					gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreTransactionStateEvent(DDNAStoreTransactionStateEvent.FAILED_TO_FIND_ITEM_FOR_SUCCESSFUL_PURCHASE, response.purchaseReceipt.sku));
				}
			}
			else 
			{
				gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreTransactionStateEvent(DDNAStoreTransactionStateEvent.PLATFORM_PURCHASE_FAILED, response.status));
				LoadingWheel.removeIfAny();
			}
		}
		
		public function consumeItem(item:IStoreItem):void
		{
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreTransactionStateEvent(DDNAStoreTransactionStateEvent.ITEM_CONSUME_REQUESTED, item.itemId));
		}
		
		public function getSKUs():void 
		{
			sosTrace( "AmazonStore.getSKUs", SOSLog.DEBUG);
			
			var skusInput:SkusInput = new SkusInput();
			
			var skus:Vector.<String> = new  Vector.<String>();
			for each (var item:IStoreItem in Settings.instance.coinsItems) 
			{
				skus.push(item.itemId);
			}
			
			skusInput.skus = skus;
			
			var productData:RequestOutput = AmazonIapV2.getProductData(skusInput);
			sosTrace( "productData : " + productData.requestId, SOSLog.DEBUG);
		}

		public function get appStoreLink():String
		{
			return APP_STORE_URL;
		}
	}
}