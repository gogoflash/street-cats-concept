package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNAPowerupCollectedFromCell extends DDNAEvent
	{
		
		public function DDNAPowerupCollectedFromCell(powerup:String) 
		{
			addEventType("powerupCollectedFromCell");
			
			addParamsField("powerup", powerup);
			addRoundID();
		}
		
	}

}