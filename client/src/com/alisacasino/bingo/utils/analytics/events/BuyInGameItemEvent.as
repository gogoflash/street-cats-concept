package com.alisacasino.bingo.utils.analytics.events 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class BuyInGameItemEvent extends AnalyticsEvent
	{
		
		public function BuyInGameItemEvent(itemType:String, itemQuantity:Number, priceType:String, price:Number) 
		{
			addEventType("buyInGameItem");
			addField("itemType", itemType);
			addField("itemQuantity", itemQuantity);
			addField("priceType", priceType);
			addField("price", price);
		}
		
	}

}