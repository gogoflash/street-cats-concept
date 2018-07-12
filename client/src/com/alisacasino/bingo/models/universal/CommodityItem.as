package com.alisacasino.bingo.models.universal 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CommodityItem 
	{
		public var type:String;
		public var subType:String;
		public var quantity:int;
		
		public var data:*;
		
		public function CommodityItem(type:String, quantity:int) 
		{
			this.type = type;
			this.quantity = quantity;
		}
		
		public function clone():CommodityItem
		{
			return CommodityItem.create(type, subType, quantity, data);
		}
		
		public static function create(type:String, subType:String, quantity:int, data:* = null):CommodityItem
		{
			var commodityItem:CommodityItem = new CommodityItem(type, quantity);
			commodityItem.subType = subType;
			commodityItem.data = data;
			return commodityItem;
		}
		
		public static function getCommodityItemTexture(type:String):Texture
		{
			var textureName:String = "bars/cash";
			
			switch (type)
			{
				case CommodityType.CASH:
					textureName = "bars/cash";
					break;
				case CommodityType.POWERUP:
					textureName = "bars/energy";
					break;
				case CommodityType.SCORE:
					textureName = "bars/score";
					break;	
				defalt:
					throw new Error("Unknown commodity item");
					break;
			}
			
			return AtlasAsset.CommonAtlas.getTexture(textureName);
		}
		
		public function toString():String 
		{
			return "[CommodityItem type=" + type + " quantity=" + quantity + "]";
		}
		
		public function parse(raw:Object):void 
		{
			if(!raw)
				return;
				
			type = raw['type'];
			quantity = 'quantity' in raw ? raw['quantity'] : 1;
			subType = 'subType' in raw ? raw['subType'] : null;
		}
		
	}

}