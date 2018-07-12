package com.alisacasino.bingo.store.items 
{
	import com.alisacasino.bingo.models.universal.Price;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.store.IStoreItem;
	import com.alisacasino.bingo.utils.TypeParser;
	
	public class OfferStoreItem implements IStoreItem 
	{
		public function OfferStoreItem() {
		}
		
		public var isItemsPack:Boolean;
		
		public var data:*;
		
		private var _itemId:String;
		private var _totalQuantity:int;
		
		private var _price:Price;
		
		public function parse(raw:Object):void
		{
			if (!raw)
				return;
				
			_itemId = String(raw['storeItemId']);
			_price = new Price(Type.REAL, 999.99);
			_price.parse(raw);
			
			_totalQuantity = 1;
		}
		
		public function get price():Price
		{
			return _price;
		}
		
		/* INTERFACE com.alisacasino.bingo.store.IStoreItem */
		
		public function get itemId():String 
		{
			return _itemId;
		}
		
		public function get value():int 
		{
			return Math.round(_price.price);
		}
		
		public function get totalQuantity():int 
		{
			return _totalQuantity;
		}
		
		public static function checkCorrectRaw(raw:Object):Boolean
		{
			if (!raw || !('priceType' in raw))
				return false;
			
			switch(raw['priceType']) {
				case TypeParser.REAL: return 'storeItemId' in raw && raw['storeItemId'] != null && raw['storeItemId'] != '' && 'price' in raw && parseFloat(raw['price']) > 0;
				case TypeParser.DUST: 
				case TypeParser.CASH: return 'price' in raw && parseFloat(raw['price']) > 0;
				case TypeParser.FREE: return true; 
				default 			: return false;
			}
			
			return false;
		}
		
	}

}