package com.alisacasino.bingo.store.items
{
	import com.alisacasino.bingo.models.offers.CustomOfferManager;
	import com.alisacasino.bingo.models.offers.OfferItemData;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.CustomOfferMessage;
	import com.alisacasino.bingo.protocol.SignInMessage.Platform;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.store.IStoreItem;
	import com.alisacasino.bingo.utils.Constants;
	
	public class ComboItem implements IStoreItem
	{
		private var mItemId:String;
		private var mValue:int;
		private var mValueLabel:String;
		private var mPrice:String;
		private var _minLifetimeValue:Number = 0;
		private var _maxLifetimeValue:Number = 0;
		
		public var title:String;
		public var salePersent:uint;
		public var badgeTexture:String;
		public var priceTexture:String;
		public var percentTextColor:uint = 0xFFFFFF;
		public var priceTextBorderColor:uint = 0x007AD0;
		public var priceTextColor:uint = 0xFFFFFF;
		
		public var isCustomOffer:Boolean;
		private var _items:Array;
		private var _totalQuantity:int;
		
		public function ComboItem(source:Object)
		{
			_items = new Array();
			
			if (!source)
				return;
				
			mItemId = source.item_id;
			mValue = source.value;
			mPrice = source.price;
			mValueLabel = source.value_label;
			_minLifetimeValue = parseFloat(source.min_lifetime_value);
			_maxLifetimeValue = parseFloat(source.max_lifetime_value);
		
			if (source.coins_amount > 0) {
				_items.push(new OfferItemData(Type.CASH, source.coins_amount));
				_totalQuantity += source.coins_amount;
			}
			
			//if (source.tickets_amount > 0)
				//_items.push(new OfferItemData(Type.TICKET, source.tickets_amount));
			
			if (source.energy_amount > 0) {
				_items.push(new OfferItemData(Type.ENERGY, source.energy_amount));
				_totalQuantity += source.energy_amount;
			}
			
			//if (source.keys_amount > 0)
				//_items.push(new OfferItemData(Type.KEY, source.keys_amount));
				
			//badgeTexture = "offers/badge_red";
			//priceTexture = "offers/label_blue";
			
			title = 'title' in source ? String(source['title']) : Constants.TITLE_LIMITED_TIME_OFFER;
			salePersent = 'salePercent' in source ? parseInt(source['salePercent']) : 0;
			badgeTexture = parsePercentBadgeField('percentBadgeColor' in source ? source['percentBadgeColor'] : null);
			priceTexture = parsePriceBadgeField('badgeColor' in source ? source['badgeColor'] : null);
			percentTextColor = 'percentTextColor' in source ? parseInt(source['percentTextColor']) : 0xffffff;
			priceTextBorderColor = 'priceTextBorderColor' in source ? parseInt(source['priceTextBorderColor']) : 0x007AD0;    
			priceTextColor = 'priceTextColor' in source ? parseInt(source['priceTextColor']) : 0xffffff;
			
			//debugValues(0, 13000);	
		}
		
		public function get itemId():String
		{
			return mItemId;
		}
		
		public function get value():int
		{
			return mValue;
		}
		
		public function get price():String 
		{
			return mPrice;
		}

		public function get valueLabel():String 
		{
			return mValueLabel;
		}
		
		public function get minLifetimeValue():Number
		{
			return _minLifetimeValue;
		}
		
		public function get maxLifetimeValue():Number
		{
			return _maxLifetimeValue;
		}
		
		public function get items():Array
		{
			return _items;
		}
		
		public function parseCustomOfferMessage(message:CustomOfferMessage):void
		{
			if (!message)
				return;
			
			for each (var item:CommodityItemMessage in message.items) {
				_items.push(new OfferItemData(item.type, item.quantity));
			}
			
			mItemId = CustomOfferManager.getCustomOfferId(message);
			mValue = isNaN(message.price) ? 0 : message.price;
			mPrice = isNaN(message.priceWithSale) ? 'NaN' : message.priceWithSale.toString();
			mValueLabel = message.price.toString();
			title = message.title;
			salePersent = uint(message.salePercents);
			
			badgeTexture = parsePercentBadgeField(message.percentBadgeColor);
			priceTexture = parsePriceBadgeField(message.percentBadgeColor);
			percentTextColor = message.percentTextColor.toNumber() == 0 ? 0xffffff : uint(message.percentTextColor.toNumber());
			priceTextBorderColor = message.priceTextBorderColor.toNumber() == 0 ? 0x007AD0 : uint(message.priceTextBorderColor.toNumber());    
			priceTextColor = message.priceTextColor.toNumber() == 0 ? 0xffffff : uint(message.priceTextColor.toNumber());
			
			isCustomOffer = true;
		}
		
		public function toString():String 
		{
			return "[ComboItem itemId=" + itemId + " value=" + value + toStringItems() + " price=" + price + 
						" valueLabel=" + valueLabel + " minLifetimeValue=" + minLifetimeValue + " maxLifetimeValue" + maxLifetimeValue
						"]";
		}
		
		private function toStringItems():String
		{
			var i:int;
			var string:String = ' items:';
			var offerItem:OfferItemData;
			for (i = 0; i < items.length; i++) {
				offerItem = items[i] as OfferItemData;
				string += ' ' + CommodityType.getTypeByCommodityItemMessageType(offerItem.type) + ": " + offerItem.count;
			}
			return string;
		}
		
		private function parsePercentBadgeField(raw:String):String
		{
			if (!raw)
				return "offers/badge_red";
				
			switch(raw) {
				case "PINK": 	return "offers/badge_pink";
				case "PURPLE": 	return "offers/badge_purple";
				case "RED": 	return "offers/badge_red"; 
			}
			
			return "offers/badge_red";
		}
		
		private function parsePriceBadgeField(raw:String):String
		{
			if (!raw)
				return "offers/badge_red";
			
			switch(raw) {
				case "BLUE": 	return "offers/label_blue";
				case "YELLOW": 	return "offers/label_yellow";
				case "RED": 	return "offers/label_red"; 
			}
			
			return "offers/label_blue";
		}
		
		private function debugValues(countDispersion:Number = 0.5, maxValue:uint = 2000):void
		{
			mValue = Math.random() > 0.5 ? Math.random()*2000 : 0;
			mPrice = String(int(Math.random()*100)) + '.99';
			mValueLabel = String(int(Math.random()*2000)) + '.99';
			
			if (Math.random() > countDispersion)
				_items.push(new OfferItemData(Type.CASH, Math.random() * maxValue));
				
			//if (Math.random() > countDispersion)
				//_items.push(new OfferItemData(Type.TICKET, Math.random() * maxValue));
				
			if (Math.random() > countDispersion)
				_items.push(new OfferItemData(Type.ENERGY, Math.random() * maxValue));
				
			//if (Math.random() > countDispersion)
				//_items.push(new OfferItemData(Type.KEY, Math.random() * maxValue));
			
			//if (Math.random() > countDispersion)
				//_items.push(new OfferItemData(Type.SLOT_MACHINE_SPIN_0, Math.random()*200));
				
			//if (Math.random() > countDispersion)
				//_items.push(new OfferItemData(Type.DAUB_HINT, Math.random()*100));
				
		}

		public function get totalQuantity():int 
		{
			return _totalQuantity;
		}
	}
}