package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	import com.alisacasino.bingo.protocol.Type;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNAScratchCardTransactionEvent extends DDNATransactionEvent
	{
		
		public function DDNAScratchCardTransactionEvent(cardType:String, price:int) 
		{
			super();
			addParamsField("transactionType", "PURCHASE");
			addParamsField("transactionName", "scratchCardBuy");
			addSpentCurrency(Type.CASH, price);
			addParamsField("productsReceived", {items: [{item: {
						itemAmount: 1,
						itemName: cardType,
						itemType: "scratchCard"
					}}]});
		}
		
	}

}