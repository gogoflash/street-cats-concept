package com.alisacasino.bingo.models.offers 
{
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import com.alisacasino.bingo.store.IStoreItem;
	import com.alisacasino.bingo.store.items.OfferStoreItem;
	import starling.events.EventDispatcher;
	
	public class OfferItemsPack
	{
		//public static var PURCHASE_PROGRESS_BASE:String = 'PURCHASE_PROGRESS_BASE';
		
		public static var PURCHASE_PROGRESS_WAIT:String = 'PURCHASE_PROGRESS_WAIT';
		
		public static var PURCHASE_PROGRESS_COMPLETE:String = 'PURCHASE_PROGRESS_COMPLETE';
		
		public function OfferItemsPack() 
		{
			//_purchaseProgress = PURCHASE_PROGRESS_BASE;
			items = [];
		}
		
		public var offerItem:OfferItem;
		
		public var items:Array;
		
		public var percent:Number = 0;
		
		public var storeItem:OfferStoreItem;
		
		private var _purchaseProgress:String;
		
		public function parse(raw:Object):void 
		{
			if(!raw)
				return;
			
			percent = 'percent' in raw ? parseFloat(raw['percent']) : 0;
			
			if (OfferStoreItem.checkCorrectRaw(raw))
			{
				storeItem = new OfferStoreItem();
				storeItem.parse(raw);
				storeItem.isItemsPack = true;
				storeItem.data = this;
			}
			
			var itemsRaw:Object = 'items' in raw ? (raw['items'] as Object) : {};
			var item:CommodityItem;	
			for each(var itemRaw:Object in itemsRaw)
			{
				if ('type' in itemRaw && (!('quantity' in itemRaw) || itemRaw['quantity'] > 0)) {
					item = new CommodityItem('', 0);
					item.parse(itemRaw);
					items.push(item);
				}
			}	
		}
		
		public function get purchaseProgress():String
		{
			return _purchaseProgress;
		}
		
		public function set purchaseProgress(value:String):void
		{
			if (_purchaseProgress == value)
				return;
				
			_purchaseProgress = value;
			
			if (offerItem)
				offerItem.dispatchEventWith(OfferItem.EVENT_PACK_PURCHASED_CHANGE, true);
		}
		
		/*public function setPurchaseProgressQuiet(value:String):void
		{
			_purchaseProgress = value;
		}	*/
	}

}

