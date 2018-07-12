package com.alisacasino.bingo.models.collections 
{
	import com.alisacasino.bingo.assets.ImageAsset;
	import com.alisacasino.bingo.protocol.CustomizationType;
	import com.alisacasino.bingo.protocol.CardType;
	import com.alisacasino.bingo.protocol.CollectionItemDataMessage;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.ExchangeBubbleContent;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.ICardData;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CollectionItem extends EventDispatcher implements ICardData
	{
		protected var _id:int;
		protected var _name:String;
		protected var _rarity:int;
		
		public var index:int;
		public var image:ImageAsset;
		public var weight:Number;
		
		public var duplicates:int;
		
		public var numberToExchange:int;
		public var collection:Collection;
		
		private var _owned:Boolean;
		
		protected var _comingSoon:Boolean;
		protected var _awaitBurn:Boolean;
		
		public function CollectionItem() 
		{
			
		}
		
		public function get owned():Boolean 
		{
			return _owned;
		}
		
		public function set owned(value:Boolean):void 
		{
			if (_owned != value)
			{
				_owned = value;
				dispatchEventWith(Event.CHANGE);
			}
		}
		
		public function get dustGain():Number
		{
			return gameManager.gameData.getCollectionDustGain(_rarity);
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function set id(value:int):void
		{
			_id = value;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
		
		public function get rarity():int
		{
			return _rarity;
		}
		
		public function set rarity(value:int):void
		{
			_rarity = value;
		}
		
		public function get quantity():int
		{
			return duplicates;
		}
		
		public function set quantity(value:int):void
		{
			duplicates = value;
		}
		
		public function get type():int
		{
			return -1;
		}

		public function get baseBubbleContentClass():Class {
			return ExchangeBubbleContent;
		}
		
		public function get setID():int
		{
			return -1;
		}
		
		public function get defaultItem():Boolean
		{
			return false;
		}
		
		public function get itemData():*
		{
			return this;
		}
		
		public function get comingSoon():Boolean
		{
			return _comingSoon;
		}
		
		public function set comingSoon(value:Boolean):void
		{
			_comingSoon = value;
		}
		
		public function get awaitBurn():Boolean
		{
			return _awaitBurn;
		}
		
		public function set awaitBurn(value:Boolean):void
		{
			_awaitBurn = value;
		}
		
		public function changeQuantity(value:int):void
		{
			quantity += value;
			if (value < 0)
				awaitBurn = true;
		}
		
		static public function fromDataMessage(itemDataMessage:CollectionItemDataMessage, collection:Collection):CollectionItem
		{
			var item:CollectionItem = new CollectionItem();
			item.id = itemDataMessage.itemId;
			item.name = itemDataMessage.name;
			item.weight = itemDataMessage.weight;
			item.image = gameManager.loadManager.getImageAssetByName(itemDataMessage.imagePath);
			item.index = itemDataMessage.itemIdx;
			item.rarity = itemDataMessage.rarity;
			item.numberToExchange = itemDataMessage.numberToConvert;
			item.collection = collection;
			return item;
		}
		
		public function toString():String 
		{
			return "[CollectionItem name=" + name + " index=" + index + " image=" + image + " weight=" + weight + " id=" + id + 
						" owned=" + owned + " duplicates=" + duplicates + " rarity=" + rarity + " numberToExchange=" + numberToExchange + 
						"]";
		}
		
		public function get rarityString():String {
			switch(rarity) {
				case CardType.NORMAL: return 'NORMAL';
				case CardType.MAGIC: return 'SILVER';
				case CardType.RARE: return 'GOLD';
			}
			return 'unknown';
		}
		
		public function get rarityGlowBg():String {
			switch(rarity) {
				case CardType.NORMAL: return "cards/card_glow_cian";
				case CardType.MAGIC: return "cards/card_glow_blue";
				case CardType.RARE: return "cards/card_glow_gold";
			}
			return "cards/card_glow_cian";
		}
	}

}