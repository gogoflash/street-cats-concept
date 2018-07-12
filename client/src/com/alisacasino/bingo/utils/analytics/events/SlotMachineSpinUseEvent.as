package com.alisacasino.bingo.utils.analytics.events 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class SlotMachineSpinUseEvent extends AnalyticsEvent
	{
		
		public function SlotMachineSpinUseEvent(spinType:String, winType:String) 
		{
			addEventType("slotMachineSpinUse");
			addField("spinType", spinType);
			addField("winType", winType);
		}
		
	}

}