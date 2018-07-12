package com.alisacasino.bingo.models.offers 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.models.universal.ValueDataTable;
	import starling.textures.Texture;
	
	public class CashIconType 
	{
		public static const CARD_2:int = 0;
		public static const CARD_4:int = 1;
		public static const CASE:int = 2;
		public static const BAG:int = 3;
		public static const SAFE:int = 4;
		
		public function CashIconType() 
		{
			
		}
		
		public static function parseFromString(raw:String):ValueDataTable
		{
			if (raw == null || raw == '')
				return null;
			
			var sourceTypes:Array = [CARD_2, CARD_4, CASE, BAG, SAFE];	
			var array:Array = raw.split(',');	
			var length:int = Math.min(array.length, sourceTypes.length);
			var table:ValueDataTable = new ValueDataTable();
			for (var i:int = 0; i < length; i++) {
				table.add(array[i], sourceTypes[i]);
			}
			
			return table;
		}
		
		public static function isBigImage(type:int):Boolean {
			return type == CASE || type == BAG || type == SAFE;
		}
		
		public static function textureByType(type:int):Texture 
		{
			switch(type) {
				case CARD_2: 	return AtlasAsset.ScratchCardAtlas.getTexture('offers/card_cash_2');
				case CARD_4: 	return AtlasAsset.ScratchCardAtlas.getTexture('offers/card_cash_4');
				case CASE: 		return AtlasAsset.ScratchCardAtlas.getTexture('offers/cash_case');
				case BAG: 		return AtlasAsset.ScratchCardAtlas.getTexture('offers/cash_bag');
				case SAFE: 		return AtlasAsset.CommonAtlas.getTexture('store/cash_icons/icon6');
			}
			return AtlasAsset.getEmptyTexture();
		}
		
		public static function questAwardTextureByType(type:int):Texture 
		{
			switch(type) {
				case CARD_2: 	return AtlasAsset.CommonAtlas.getTexture('store/cash_icons/icon2');
				case CARD_4: 	return AtlasAsset.CommonAtlas.getTexture('store/cash_icons/icon3');
				case CASE: 		return AtlasAsset.CommonAtlas.getTexture('store/cash_icons/icon4');
				case BAG: 		return AtlasAsset.ScratchCardAtlas.getTexture('offers/cash_bag');
				case SAFE: 		return AtlasAsset.CommonAtlas.getTexture('store/cash_icons/icon6');
			}
			return AtlasAsset.getEmptyTexture();
		}
		
		public static function get defaultTable():ValueDataTable 
		{
			return new ValueDataTable({200:CashIconType.CARD_2, 350:CashIconType.CARD_4, 500:CashIconType.CASE, 2000:CashIconType.BAG, 2000000:CashIconType.SAFE});
		}
	}

}