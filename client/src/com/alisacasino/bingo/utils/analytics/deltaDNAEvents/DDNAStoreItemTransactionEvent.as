package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	import com.alisacasino.bingo.models.universal.Price;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.SignInMessage.Platform;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.store.IStoreItem;
	import com.alisacasino.bingo.store.items.CashStoreItem;
	import com.alisacasino.bingo.store.items.ChestStoreItem;
	import com.alisacasino.bingo.store.items.OfferStoreItem;
	import com.alisacasino.bingo.store.items.PowerupPackStoreItem;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNAStoreItemTransactionEvent extends DDNATransactionEvent
	{
		private var receiptObject:Object;
		private var storeItem:IStoreItem;
		
		public function DDNAStoreItemTransactionEvent(storeItem:IStoreItem, powerupsGained:Object = null, receiptObject:Object = null) 
		{
			super();
			this.storeItem = storeItem;
			this.receiptObject = receiptObject;
			addParamsField("productID", storeItem.itemId);
			addParamsField("transactionType", "PURCHASE");
			if (storeItem is CashStoreItem)
			{
				addCashStoreItemToEvent(storeItem as CashStoreItem);
			}
			else if (storeItem is PowerupPackStoreItem)
			{
				addPowerupPackStoreItemToEvent(storeItem as PowerupPackStoreItem, powerupsGained);
			}
			else if (storeItem is ChestStoreItem)
			{
				addChestStoreItemToEvent(storeItem as ChestStoreItem);
			}
			else if (storeItem is OfferStoreItem) 
			{
				addOfferStoreItemToEvent(storeItem as OfferStoreItem);
			}
			else
			{
				addParamsField("transactionName", "unknownPurchase");
			}
			
			if (receiptObject && (receiptObject["itemId"] == storeItem.itemId))
			{
				switch(PlatformServices.platform)
				{
					case Platform.AMAZON_APP_STORE:
						addAmazonReceipt();
						break;
					case Platform.APPLE_APP_STORE:
						addIOSReceipt();
						break;
					case Platform.GOOGLE_PLAY:
						addGooglePlayReceipt();
						break;
				}
			}
		}
		
		private function addGooglePlayReceipt():void 
		{
			addParamsField("transactionServer", "GOOGLE");
			addParamsField("transactionReceipt", receiptObject["receipt"]);
			addParamsField("transactionReceiptSignature", receiptObject["transactionReceiptSignature "]);
		}
		
		private function addIOSReceipt():void 
		{
			addParamsField("transactionServer", "APPLE");
			addParamsField("transactionID", receiptObject["transactionId"]);
			addParamsField("transactionReceipt", receiptObject["receipt"]);
		}
		
		private function addAmazonReceipt():void 
		{
			addParamsField("transactionServer", "AMAZON");
			addParamsField("amazonPurchaseToken", receiptObject["amazonPurchaseToken"]);
			addParamsField("amazonUserID ", receiptObject["amazonUserID"]);
		}
		
		private function addChestStoreItemToEvent(chestStoreItem:ChestStoreItem):void 
		{
			addSpentCurrency(chestStoreItem.priceType, chestStoreItem.price);
			addParamsField("productsReceived", createRewardProductsList([chestStoreItem]));
			addParamsField("transactionName", "chestStorePurchase");
		}
		
		private function addPowerupPackStoreItemToEvent(powerupPackStoreItem:PowerupPackStoreItem, powerupsGained:Object):void 
		{
			addSpentCurrency(powerupPackStoreItem.priceType, powerupPackStoreItem.price);
			addParamsField("productsReceived", createRewardProductsList([], powerupsGained));
			addParamsField("transactionOnSale", powerupPackStoreItem.hasSale);
			addParamsField("transactionName", "powerupStorePurchase");
		}
		
		private function addCashStoreItemToEvent(cashStoreItem:CashStoreItem):void 
		{
			addParamsField("productsReceived", createRewardProductsList([cashStoreItem]));
			addSpentCurrency(Type.REAL, cashStoreItem.price);
			addParamsField("transactionOnSale", cashStoreItem.hasSale);
			addParamsField("transactionName", "cashStorePurchase");
		}
		
		private function addOfferStoreItemToEvent(offerStoreItem:OfferStoreItem):void 
		{
			addParamsField("productsReceived", createRewardProductsList([offerStoreItem]));
			addSpentCurrency(offerStoreItem.price.priceType, offerStoreItem.price.price);
			addParamsField("transactionName", "offerPurchase");
		}
		
	}

}