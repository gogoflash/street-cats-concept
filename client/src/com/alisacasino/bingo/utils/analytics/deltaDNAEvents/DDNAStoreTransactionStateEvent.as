package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNAStoreTransactionStateEvent extends DDNAEvent
	{
		static public const INITIALIZED:String = "initialized";
		static public const PLATFORM_PURCHASE_COMPLETED:String = "platformPurchaseCompleted";
		static public const COULD_NOT_FIND_ITEM:String = "couldNotFindItem";
		static public const FOUND_PURCHASED_ITEM:String = "foundPurchasedItem";
		static public const PURCHASE_DATA_SENT_TO_SERVER:String = "purchaseDataSentToServer";
		static public const PURCHASE_FAILED_ON_SERVER:String = "purchaseFailedOnServer";
		static public const FAILED_TO_FIND_ITEM_FOR_SUCCESSFUL_PURCHASE:String = "failedToFindItemForSuccessfulPurchase";
		static public const PURCHASE_SUCCEDED_ON_SERVER:String = "purchaseSuccededOnServer";
		static public const ITEM_CONSUMED:String = "itemConsumed";
		static public const ITEM_CONSUME_REQUESTED:String = "itemConsumeRequested";
		static public const AMAZON_REQUEST_ID_RECEIVED:String = "amazonRequestIdReceived";
		static public const PLATFORM_PURCHASE_FAILED:String = "platformPurchaseFailed";
		
		public function DDNAStoreTransactionStateEvent(state:String, additionalData:String) 
		{
			addEventType("storeTransactionState");
			addParamsField("storeItemTransactionState", state);
			
			if (additionalData)
			{
				addParamsField("storeItemTransactionAdditionalData", additionalData);
			}
		}
		
	}

}