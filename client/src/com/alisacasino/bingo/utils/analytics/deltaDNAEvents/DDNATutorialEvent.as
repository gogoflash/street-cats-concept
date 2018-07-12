package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNATutorialEvent extends DDNAEvent
	{
		
		public function DDNATutorialEvent(step:String, additionalData:* = null)
		{
			super();
			addEventType("tutorialStep");
			addParamsField("step", step);
			addParamsField("additionalTutorialStepData", additionalData ? String(additionalData) : "");
		}
		
	}

}