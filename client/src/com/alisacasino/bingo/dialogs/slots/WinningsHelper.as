package com.alisacasino.bingo.dialogs.slots 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class WinningsHelper 
	{
		
		public function WinningsHelper() 
		{
			
		}
		
		public static function getCommodityItemTexture(commodityType:String):Texture
		{
			var textureName:String = "winnings_icons/coin";
			
			switch (commodityType)
			{
				case CommodityType.CASH:
					textureName = "winnings_icons/coin";
					break;
				case CommodityType.ENERGY:
					textureName = "winnings_icons/energy";
					break;
				case CommodityType.KEY:
					textureName = "winnings_icons/key";
					break;
				case CommodityType.TICKET:
					textureName = "winnings_icons/ticket";
					break;
				default:
					throw new Error("Unknown commodity item");
					break;
			}
			
			return AtlasAsset.SlotMachineAtlas.getTexture(textureName);
		}
		
	}

}