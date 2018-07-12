package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	import com.alisacasino.bingo.models.chests.ChestsData;
	import com.alisacasino.bingo.protocol.Type;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNADustConversionTransaction extends DDNATransactionEvent
	{
		
		public function DDNADustConversionTransaction(dustCostChestConversion:int, chestType:int) 
		{
			addParamsField("transactionType", "PURCHASE");
			addParamsField("transactionName", "dustToChestConversion");
			addSpentCurrency(Type.DUST, dustCostChestConversion);
			addParamsField("productsReceived", {items: [{item: {
						itemAmount: 1,
						itemName: ChestsData.chestTypeToString(chestType),
						itemType: "chest"
					}}]});
		}
		
	}

}