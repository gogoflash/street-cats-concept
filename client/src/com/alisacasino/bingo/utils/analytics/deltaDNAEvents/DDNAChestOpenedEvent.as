package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	import com.alisacasino.bingo.models.chests.ChestData;
	import com.alisacasino.bingo.models.chests.ChestsData;
	import com.alisacasino.bingo.models.universal.Price;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNAChestOpenedEvent extends DDNAEvent
	{
		
		public function DDNAChestOpenedEvent(chestData:ChestData, source:String, chestPrice:Price) 
		{
			super();
			addEventType("chestOpened");
			addParamsField("chestType", ChestsData.chestTypeToString(chestData.type));
			addParamsField("chestSeed", chestData.seed);
			addParamsField("reward", createRewardObject("chestReward", chestData.prizes));
			addParamsField("chestOpenSource", source);
			if (chestPrice)
			{
				addParamsField("price", chestPrice.price);
				addParamsField("priceType", chestPrice.getPriceTypeString());
			}
			
		}
		
	}

}