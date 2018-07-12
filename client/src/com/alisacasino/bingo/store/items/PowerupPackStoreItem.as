package com.alisacasino.bingo.store.items 
{
	import com.alisacasino.bingo.protocol.StorePowerupDataMessage;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.store.IStoreItem;
	import com.alisacasino.bingo.utils.Settings;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class PowerupPackStoreItem implements IStoreItem
	{
		public var itemID:String;
		public var dropTableItemID:String;
		public var price:Number;
		public var priceType:int;
		public var normalQuantity:uint;
		public var magicQuantity:uint;
		public var rareQuantity:uint;
		public var oldNormalQuantity:uint;
		public var oldMagicQuantity:uint;
		public var oldRareQuantity:uint;
		public var percentBonus:uint;
		public var showSaleBadge:Boolean;
		
		public function PowerupPackStoreItem() 
		{
			
		}
		
		static public function fromSettingsObject(settingsObject:Object):PowerupPackStoreItem 
		{
			var powerupPackItem:PowerupPackStoreItem = new PowerupPackStoreItem();
			powerupPackItem.itemID = settingsObject.itemId;
			powerupPackItem.dropTableItemID = settingsObject.dropTableItemId;
			powerupPackItem.price = settingsObject.price;
			powerupPackItem.priceType = getPriceTypeFromSettingsString(settingsObject.priceType);
			powerupPackItem.normalQuantity = settingsObject.normalQuantity;
			powerupPackItem.magicQuantity = settingsObject.magicQuantity;
			powerupPackItem.rareQuantity = settingsObject.rareQuantity;
			powerupPackItem.oldNormalQuantity = settingsObject.oldNormalQuantity;
			powerupPackItem.oldMagicQuantity = settingsObject.oldMagicQuantity;
			powerupPackItem.oldRareQuantity = settingsObject.oldRareQuantity;
			powerupPackItem.percentBonus = settingsObject.percentBonus;
			powerupPackItem.showSaleBadge = 'showSaleBadge' in settingsObject ? Boolean(settingsObject.showSaleBadge) : false;
			
			return powerupPackItem;
		}
		
		static private function getPriceTypeFromSettingsString(string:String):int 
		{
			switch(string.toLowerCase())
			{
				case "cash":
					return Type.CASH;
				case "real":
					return Type.REAL;
			}
			return Type.CASH;
		}
		
		/* INTERFACE com.alisacasino.bingo.store.IStoreItem */
		
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
			return normalQuantity + magicQuantity + rareQuantity;
		}
		
		public function get hasSale():Boolean
		{
			if (Settings.instance.isSuperSale)
			{
				return (normalQuantity != oldNormalQuantity) ||
					(magicQuantity != oldMagicQuantity) ||
					(rareQuantity != oldRareQuantity);
			}
			
			return false;
		}
		
	}

}