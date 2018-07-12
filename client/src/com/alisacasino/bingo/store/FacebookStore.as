package com.alisacasino.bingo.store
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.controls.LoadingWheel;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAStoreTransactionStateEvent;
	
	public class FacebookStore implements IStore
	{
		private static var sInstance:FacebookStore = null;
		
		private var _lastPurchaseReceiptObject:Object;
		
		public function get lastPurchaseReceiptObject():Object
		{
			return _lastPurchaseReceiptObject;
		}
		
		public static function get instance():FacebookStore
		{
			if (sInstance == null)
			{
				sInstance = new FacebookStore();
			}
			return sInstance;
		}
		
		public function init():void
		{
		}
		
		public function purchaseItem(item:IStoreItem):void
		{
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreTransactionStateEvent(DDNAStoreTransactionStateEvent.INITIALIZED, item.itemId));
			
			showFacebookPurchaseDialog(item.itemId, function(data:Object):void
			{
				if (data.hasOwnProperty("status") && String(data.status) == "completed")
				{
					gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreTransactionStateEvent(DDNAStoreTransactionStateEvent.PLATFORM_PURCHASE_COMPLETED, item.itemId));
					
					Game.dispatchEventWith(StoreEvent.PURCHASE_COMPLETED, false, {item: item, facebookPaymentId: String(data.payment_id)});
				}
				else
				{
					gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreTransactionStateEvent(DDNAStoreTransactionStateEvent.PLATFORM_PURCHASE_FAILED, String(data.status)));
					
					LoadingWheel.removeIfAny();
				}
			});
		}
		
		private function showFacebookPurchaseDialog(itemId:String, callback:Function):void
		{
			var params:Object = new Object();
			params.action = "purchaseitem";
			params.product = "https://static-bingo2.alisagaming.net/assets-prod/last-cdn/og/products/" + itemId + ".html";
			PlatformServices.facebookManager.dialog("pay", params, callback);
		}
		
		public function consumeItem(item:IStoreItem):void
		{
		}
		
		public function get appStoreLink():String
		{
			return '';
		}
	}
}
