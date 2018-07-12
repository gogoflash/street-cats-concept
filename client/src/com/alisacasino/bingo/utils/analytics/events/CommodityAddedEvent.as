package com.alisacasino.bingo.utils.analytics.events 
{
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import com.alisacasino.bingo.models.universal.CommodityType;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CommodityAddedEvent extends AnalyticsEvent
	{
		public var additionalSourceData:String;
		public var powerupType:String;
		public var subType:String;
		public var source:String;
		public var commodityQuantity:int;
		public var commodityType:String;
		
		public function CommodityAddedEvent(commodityType:String, commodityQuantity:int, source:String)
		{
			if (commodityType.indexOf(":") != -1)
			{
				var splitType:Array = commodityType.split(":");
				commodityType = splitType[0];
				subType = splitType[1];
				if (commodityType == CommodityType.POWERUP)
				{
					powerupType = splitType[1];
				}
			}
			
			if (source.indexOf(":") != -1)
			{
				var splitSource:Array = source.split(":");
				source = splitSource[0];
				additionalSourceData = splitSource[1];
			}
			
			this.source = source;
			this.commodityQuantity = commodityQuantity;
			this.commodityType = commodityType;
			
			addEventType("commodityAddedEvent");
			addField("type", commodityType);
			addField("quantity", commodityQuantity);
			addField("source", source);
			addField("powerupType", powerupType);
			addField("subType", subType);
			addField("additionalSourceData", additionalSourceData);
		}
		
		static public function fromCommodityItem(reward:CommodityItem, source:String):CommodityAddedEvent
		{
			return new CommodityAddedEvent(reward.type, reward.quantity, source);
		}
		
	}

}