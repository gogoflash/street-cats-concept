package com.alisacasino.bingo.models.skinning 
{
	import com.alisacasino.bingo.assets.ImageAsset;
	import com.alisacasino.bingo.protocol.CustomizationType;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.ICardData;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.SelectBubbleContent;
	import starling.events.EventDispatcher;
	import com.alisacasino.bingo.protocol.CardType;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CustomizerItemBase extends EventDispatcher implements ICardData
	{
		public static const EVENT_RESOURCES_LOADED:String = 'EVENT_RESOURCES_LOADED';
		
		protected var _id:int = -1;
		protected var _name:String;
		protected var _rarity:int;
		protected var _type:int;
		protected var _quantity:int;
		protected var _setID:int = -1;
		protected var _defaultItem:Boolean;
		
		protected var _uiAssetPath:String;
		private var _uiAsset:ImageAsset;
		
		public var uid:String;
		public var order:int;
		public var baseItem:Boolean;
		public var weight:Number;
		
		protected var _comingSoon:Boolean;
		protected var _awaitBurn:Boolean;
		
		public var onLoadComplete:Function;

		public function CustomizerItemBase() 
		{
			
		}

		public function get id():int
		{
			return _id;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get rarity():int
		{
			return _rarity;
		}
		
		public function get type():int
		{
			return _type;
		}

		public function get quantity():int
		{
			return _quantity;
		}
		
		public function set quantity(value:int):void
		{
			_quantity = value;
		}
		
		public function get dustGain():Number
		{
			return gameManager.gameData.getCustomizerDustGain(_rarity);
		}
		
		public function get baseBubbleContentClass():Class {
			return SelectBubbleContent;
		}
		
		public function get setID():int
		{
			return _setID;
		}
		
		public function get customizerSet():CustomizerSet
		{
			if (setID != -1)
			{
				return gameManager.skinningData.getSetByID(setID);
			}
			
			return null;
		}
		
		public function get defaultItem():Boolean
		{
			return _defaultItem;
		}
		
		public function set defaultItem(value:Boolean):void
		{
			_defaultItem = value;
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
		
		public function get itemData():*
		{
			return this;
		}
		
		public function changeQuantity(value:int):void
		{
			quantity += value;
			
			if (value < 0)
				awaitBurn = true;
		}
		
		public function setBaseProperties(rawData:Object):void 
		{
			_id = rawData.id;
			uid = rawData.uid;
			order = rawData.order;
			_rarity = rawData.rarity;
			_name = rawData.name;
			_uiAssetPath = rawData.imageUrl;
			weight = rawData.weight;
			_setID = rawData.setId;
		}
		
		public function get uiAsset():ImageAsset {
			if (!_uiAsset)
				_uiAsset = new ImageAsset(uiAssetPath);
				
			return _uiAsset;	
		}
		
		protected function get uiAssetPath():String {
			return _uiAssetPath;
		}
		
		public final function get sourceAssetPath():String {
			return _uiAssetPath;
		}
		
		public function callOnLoadComplete():void {
			if (onLoadComplete != null) {
				onLoadComplete();
				onLoadComplete = null;
			}
			
			dispatchEventWith(EVENT_RESOURCES_LOADED);
		}
		
		public function getTypeStringID():String
		{
			switch(_type)
			{
				case CustomizationType.DAUB_ICON:
					return "customDauber";
				case CustomizationType.CARD:
					return "customCardSkin";
				case CustomizationType.VOICEOVER:
					return "customCallerPack";
				default:
					return "unknown";
			}
		}
		
		public function getTypeLabel():String
		{
			switch(_type)
			{
				case CustomizationType.DAUB_ICON:
					return "Custom Dauber";
				case CustomizationType.CARD:
					return "Card Skin";
				case CustomizationType.VOICEOVER:
					return "Caller Pack";
				default:
					return "unknown";
			}
		}
		
		public function get rarityString():String {
			switch(_rarity) {
				case CardType.NORMAL: return 'NORMAL';
				case CardType.MAGIC: return 'SILVER';
				case CardType.RARE: return 'GOLD';
			}
			return 'unknown';
		}
		
		public function get rarityGlowBg():String {
			switch(_rarity) {
				case CardType.NORMAL: return "cards/card_glow_cian";
				case CardType.MAGIC: return "cards/card_glow_blue";
				case CardType.RARE: return "cards/card_glow_gold";
			}
			return "cards/card_glow_cian";
		}
	}

}