package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNALoadingTimingEvent extends DDNAEvent
	{
		
		public function DDNALoadingTimingEvent(second:int) 
		{
			addEventType("loadingTiming");
			addParamsField("secondsPassed", second);
		}
		
	}

}