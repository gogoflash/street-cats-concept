package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNANewPlayerEvent extends DDNAEvent
	{
		
		public function DDNANewPlayerEvent() 
		{
			super();
			addEventType("newPlayer");
		}
		
	}

}