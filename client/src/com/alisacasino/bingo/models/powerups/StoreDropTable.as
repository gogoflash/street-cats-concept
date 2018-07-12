package com.alisacasino.bingo.models.powerups 
{
	import com.alisacasino.bingo.protocol.PlatformShopPowerupDropMessage;
	import com.alisacasino.bingo.protocol.ShopPowerupDropMessage;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class StoreDropTable 
	{
		public var dropTableByItemID:Object;
		
		public function StoreDropTable() 
		{
			dropTableByItemID = {};
		}
		
		public function deserialize(platformDrop:PlatformShopPowerupDropMessage):StoreDropTable
		{
			for each (var item:ShopPowerupDropMessage in platformDrop.shopPowerupDrops) 
			{
				dropTableByItemID[item.itemId] = new PowerupDropTable().deserialize(item.powerupDropTable);
			}
			
			return this;
		}
		
		public function getDropTableForItem(itemID:String):PowerupDropTable
		{
			if (!dropTableByItemID.hasOwnProperty(itemID))
			{
				sosTrace("No drop table found for store item with itemID " + itemID, SOSLog.ERROR);
				return null;
			}
			
			return dropTableByItemID[itemID];
		}
		
	}

}