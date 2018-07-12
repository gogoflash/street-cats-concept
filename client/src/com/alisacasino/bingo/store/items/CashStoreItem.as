package com.alisacasino.bingo.store.items 
{
	import com.alisacasino.bingo.models.sales.SaleType;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.StoreItemDataMessage;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.store.IStoreItem;
	import com.alisacasino.bingo.utils.Settings;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CashStoreItem implements IStoreItem
	{
		public var itemID:String;
		public var price:Number;
		public var quantity:uint;
		public var oldQuantiy:uint;
		public var percentBonus:uint;
		public var showSaleBadge:Boolean;
		
		public function CashStoreItem() 
		{
			
		}
		
		static public function fromSettingsObject(settingsObject:Object):CashStoreItem
		{
			var cashItem:CashStoreItem = new CashStoreItem();
			
			cashItem.itemID = settingsObject.itemId;
			cashItem.price = settingsObject.price;
			cashItem.quantity = settingsObject.cashQuantity;
			cashItem.oldQuantiy = settingsObject.oldQuantity;
			cashItem.percentBonus = settingsObject.percentBonus;
			cashItem.showSaleBadge = 'showSaleBadge' in settingsObject ? Boolean(settingsObject.showSaleBadge) : false;
			
			//cashItem.percentBonus = Math.random() * 100;
			//cashItem.showSaleBadge = true;
			return cashItem;
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
			return quantity;
		}
		
		public function get hasSale():Boolean
		{
			if (Settings.instance.isSuperSale)
			{
				return quantity != oldQuantiy;
			}
			
			return false;
		}
		
		public function get badgeTexture():String
		{
			if (percentBonus > 50)
				return 'store/badge_red';
			else if(percentBonus > 30)	
				return 'store/badge_blue';
			else
				return 'store/badge_green';
				
			return 'store/badge_green';
		}
		
	}

}