package com.alisacasino.bingo.utils.analytics.events 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class RareChestEvent extends AnalyticsEvent
	{
		
		public function RareChestEvent() 
		{
			addEventType("rareChestOpened");
		}
		
	}

}