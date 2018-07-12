package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNAGiftClaimEvent extends DDNAEvent
	{
		
		public function DDNAGiftClaimEvent(collectedGifts:int, type:String, quantity:int) 
		{
			addEventType("giftClaim");
			addParamsField("totalGiftsClaimed", collectedGifts);
			addParamsField("commodityQuantity", quantity);
			addParamsField("commodityType", type);
		}
		
	}

}