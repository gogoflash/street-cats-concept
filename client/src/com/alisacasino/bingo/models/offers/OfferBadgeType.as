package com.alisacasino.bingo.models.offers 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.models.universal.ValueDataTable;
	import starling.textures.Texture;
	
	public class OfferBadgeType 
	{
		public static const ROUND_SAW_EDGE_GREEN:int = 0;
		public static const ROUND_SAW_EDGE_PURPLE:int = 1;
		public static const ROUND_SAW_EDGE_RED:int = 2;
		
		public function OfferBadgeType() 
		{
			
		}
		
		public static function parseFromString(raw:String):ValueDataTable
		{
			if (raw == null || raw == '')
				return null;
			
			var sourceTypes:Array = [ROUND_SAW_EDGE_GREEN, ROUND_SAW_EDGE_PURPLE, ROUND_SAW_EDGE_RED];	
			var array:Array = raw.split(',');	
			var length:int = Math.min(array.length, sourceTypes.length);
			var table:ValueDataTable = new ValueDataTable();
			for (var i:int = 0; i < length; i++) {
				table.add(array[i], sourceTypes[i]);
			}
			
			return table;
		}
		
		public static function textureBorderedByType(type:int):Texture 
		{
			switch(type) {
				case ROUND_SAW_EDGE_GREEN: 	return AtlasAsset.ScratchCardAtlas.getTexture('offers/badge_bordered_green');
				case ROUND_SAW_EDGE_PURPLE: return AtlasAsset.ScratchCardAtlas.getTexture('offers/badge_bordered_purple');
				case ROUND_SAW_EDGE_RED: 	return AtlasAsset.ScratchCardAtlas.getTexture('offers/badge_bordered_red');
			}
			return AtlasAsset.getEmptyTexture();
		}
		
		public static function textureByType(type:int):Texture 
		{
			switch(type) {
				case ROUND_SAW_EDGE_GREEN: 	return AtlasAsset.ScratchCardAtlas.getTexture('offers/badge_green');
				case ROUND_SAW_EDGE_PURPLE: return AtlasAsset.ScratchCardAtlas.getTexture('offers/badge_purple');
				case ROUND_SAW_EDGE_RED: 	return AtlasAsset.ScratchCardAtlas.getTexture('offers/badge_red');
			}
			return AtlasAsset.getEmptyTexture();
		}
		
		public static function get defaultTable():ValueDataTable 
		{
			return new ValueDataTable({60:OfferBadgeType.ROUND_SAW_EDGE_GREEN, 75:OfferBadgeType.ROUND_SAW_EDGE_PURPLE, 10000:OfferBadgeType.ROUND_SAW_EDGE_RED});
		}
	}

}