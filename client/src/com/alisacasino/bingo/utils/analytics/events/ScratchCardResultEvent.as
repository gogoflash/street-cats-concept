package com.alisacasino.bingo.utils.analytics.events 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ScratchCardResultEvent extends AnalyticsEvent
	{
		
		public function ScratchCardResultEvent(winnings:int, multiplier:int)
		{
			addEventType("scratchCardResult");
			addField("winnings", winnings);
			addField("multiplier", multiplier);
		}
	}

}