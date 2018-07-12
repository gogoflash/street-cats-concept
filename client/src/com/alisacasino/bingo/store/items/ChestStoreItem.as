package com.alisacasino.bingo.store.items 
{
	import com.alisacasino.bingo.models.universal.Price;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.store.IStoreItem;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ChestStoreItem implements IStoreItem
	{
		public var priceObject:Price;
		public var itemID:String;
		public var price:Number;
		public var priceType:int;
		
		public function ChestStoreItem() 
		{
			
		}
		
		static public function fromSettingsObject(settingsObject:Object):ChestStoreItem
		{
			var chestItem:ChestStoreItem = new ChestStoreItem();
			
			chestItem.itemID = settingsObject.itemId;
			chestItem.price = settingsObject.price;
			chestItem.priceType = getPriceTypeFromSettingsString(settingsObject.priceType);
			
			chestItem.priceObject = new Price(chestItem.priceType, chestItem.price);
			
			return chestItem;
		}
		
		static private function getPriceTypeFromSettingsString(string:String):int 
		{
			if (!string)
			{
				sosTrace("Could not read chest price type", SOSLog.ERROR);
				return Type.REAL;
			}
			switch(string.toLowerCase())
			{
				case "cash":
					return Type.CASH;
				case "real":
					return Type.REAL;
			}
			return Type.REAL;
		}
		
		public function get itemId():String 
		{
			return itemID;
		}
		
		public function get value():int 
		{
			return Math.round(price);
		}
		
		public function get totalQuantity():int 
		{
			return 1;
		}
		
	}

}