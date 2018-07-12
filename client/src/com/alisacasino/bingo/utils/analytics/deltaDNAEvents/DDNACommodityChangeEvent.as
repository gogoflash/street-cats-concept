package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	import com.alisacasino.bingo.utils.analytics.events.CommodityAddedEvent;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNACommodityChangeEvent extends DDNAEvent
	{
		
		public function DDNACommodityChangeEvent(sourceEvent:CommodityAddedEvent) 
		{
			if (sourceEvent.commodityQuantity < 0)
			{
				addEventType("commodityRemoved");
			}
			else
			{
				addEventType("commodityAdded");
			}
			addParamsField("commodityChangeSource", sourceEvent.source);
			addParamsField("commodityQuantity", sourceEvent.commodityQuantity);
			addParamsField("commodityType", sourceEvent.commodityType);
			if(sourceEvent.powerupType) addParamsField("commodityPowerupType", sourceEvent.powerupType);
			if (sourceEvent.additionalSourceData) addParamsField("commodityChangeSourceAdditionalData", sourceEvent.additionalSourceData);
			if (sourceEvent.subType) addParamsField("commoditySubType", sourceEvent.subType);
		}
		
	}

}