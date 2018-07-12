package com.alisacasino.bingo.models.gifts 
{
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class AccumulatedGiftContents 
	{
		
		public var contents:Vector.<CommodityItem>;
		
		private var itemByType:Object;
		
		public function AccumulatedGiftContents() 
		{
			contents = new Vector.<CommodityItem>();
			itemByType = {};
		}
		
		public function addCommodityByType(commodityType:String, quantity:int):void
		{
			//sosTrace( "AccumulatedGiftContents.addCommodityByType > commodityType : " + commodityType + ", quantity : " + quantity);
			var commodityItem:CommodityItem = itemByType[commodityType];
			if (!commodityItem)
			{
				commodityItem = new CommodityItem(commodityType, 0);
				itemByType[commodityType] = commodityItem;
				contents.push(commodityItem);
			}
			
			commodityItem.quantity += quantity;
		}
		
		public function getCommodityQuantity(commodityType:String):int
		{
			var commodityItem:CommodityItem = itemByType[commodityType];
			if (commodityItem)
				return commodityItem.quantity;
			
			return 0;
		}
		
		public function fromCommodityItemMessages(payload:/*CommodityItemMessage*/Array):AccumulatedGiftContents
		{
			for each (var item:CommodityItemMessage in payload) 
			{
				var commodityType:String = CommodityType.getTypeByCommodityItemMessageType(item.type);
				addCommodityByType(commodityType, item.quantity);
			}
			return this;
		}
		
	}

}