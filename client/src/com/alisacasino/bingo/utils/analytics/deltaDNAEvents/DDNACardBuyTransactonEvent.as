package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	import com.alisacasino.bingo.protocol.Type;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNACardBuyTransactonEvent extends DDNATransactionEvent
	{
		
		public function DDNACardBuyTransactonEvent(price:int, cards:int, roundID:String) 
		{
			super();
			addParamsField("transactionType", "PURCHASE");
			addParamsField("transactionName", "bingoCardBuy");
			
			if(roundID)
				addParamsField("matchID", roundID);
			
			addSpentCurrency(Type.CASH, price);
			addParamsField("productsReceived", {items: [{item: {
						itemAmount: cards,
						itemName: roundID,
						itemType: "bingoCard"
					}}]});
		}
		
	}

}