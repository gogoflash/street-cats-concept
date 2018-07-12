package com.alisacasino.bingo.utils.analytics.events 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class SlotMachineSpinAcquiredEvent extends AnalyticsEvent
	{
		
		public function SlotMachineSpinAcquiredEvent(spinType:String, quantity:int) 
		{
			addEventType("slotMachineSpinAcquired");
			addField("spinType", spinType);
			addField("quantity", quantity);
		}
		
	}

}