package com.alisacasino.bingo.store 
{
	import com.alisacasino.bingo.models.offers.OfferItem;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.PlatformStoreItemsDataMessage;
	import com.alisacasino.bingo.protocol.StaticDataMessage;
	import com.alisacasino.bingo.protocol.StoreItemDataMessage;
	import com.alisacasino.bingo.protocol.StorePowerupDataMessage;
	import com.alisacasino.bingo.store.items.CashStoreItem;
	import com.alisacasino.bingo.store.items.ChestStoreItem;
	import com.alisacasino.bingo.store.items.OfferStoreItem;
	import com.alisacasino.bingo.store.items.PowerupPackStoreItem;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class StoreData
	{
		public var cashItems:Vector.<CashStoreItem>;
		public var powerupItems:Vector.<PowerupPackStoreItem>;
		public var chestItems:Vector.<ChestStoreItem>;
		public var noMoneyRepeat:int;
		
		public function StoreData() 
		{
			reset();
		}
		
		public function deserializeSettingsData(settingsData:Object):void
		{
			reset();
			
			for each(var rawCashItemData:Object in settingsData.cashItems)
			{
				cashItems.push(CashStoreItem.fromSettingsObject(rawCashItemData));
			}
			
			for each(var rawPowerupData:Object in settingsData.powerupItems)
			{
				powerupItems.push(PowerupPackStoreItem.fromSettingsObject(rawPowerupData));
			}
			
			for each(var rawChestData:Object in settingsData.chestItems)
			{
				chestItems.push(ChestStoreItem.fromSettingsObject(rawChestData));
			}
			
			cashItems.sort(quantitySort);
		}
		
		private function reset():void 
		{
			cashItems = new Vector.<CashStoreItem>();
			powerupItems = new Vector.<PowerupPackStoreItem>();
			chestItems = new Vector.<ChestStoreItem>();
		}
		
		private function quantitySort(a:CashStoreItem, b:CashStoreItem):int
		{
			if (a.quantity > b.quantity)
			{
				return 1;
			}
			if (a.quantity < b.quantity)
			{
				return -1;
			}
			return 0;
		}
		
		public function isCashItem(itemId:String):Boolean 
		{
			for each (var item:CashStoreItem in cashItems) 
			{
				if (item.itemID == itemId)
				{
					return true;
				}
			}
			
			return  false;
		}
		
		public function findItemByItemId(itemId:String):IStoreItem
		{
			for each (var item:CashStoreItem in cashItems) 
			{
				if (item.itemId == itemId)
					return item;
			}
			
			for each (var powerupItem:PowerupPackStoreItem in powerupItems) 
			{
				if (powerupItem.itemId == itemId)
					return powerupItem;
			}
			
			for each (var chestItem:ChestStoreItem in chestItems) 
			{
				if (chestItem.itemId == itemId)
					return chestItem;
			}
			
			var offerStoreItem:OfferStoreItem = gameManager.offerManager.getOfferStoreItemById(itemId);
			if (offerStoreItem)
				return offerStoreItem;
			
			return null;
		}
		
	}

}