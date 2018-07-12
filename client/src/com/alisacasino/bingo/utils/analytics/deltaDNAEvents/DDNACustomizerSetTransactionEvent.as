package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.protocol.Type;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNACustomizerSetTransactionEvent extends DDNATransactionEvent
	{
		
		public function DDNACustomizerSetTransactionEvent(price:int, customizerItemBase:CustomizerItemBase) 
		{
			addParamsField("transactionType", "PURCHASE");
			addParamsField("transactionName", "customizerSetPurchase");
			addSpentCurrency(Type.CASH, price);
			addParamsField("productsReceived", {items: [{item: {
						itemAmount: 1,
						itemName: customizerItemBase.name,
						itemType: customizerItemBase.getTypeStringID()
					}}]});
		}
		
	}

}