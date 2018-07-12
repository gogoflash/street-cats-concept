package com.alisacasino.bingo.models.slots 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class SlotItem 
	{
		
		static public const ALISA_ICON:String = "alisaIcon";
		static public const COIN:String = "coin";
		static public const TICKET:String = "ticket";
		static public const ENERGY:String = "energy";
		static public const KEY:String = "key";
		static public const STAR:String = "star";
		
		private static var allItems:Array = [ALISA_ICON, COIN, TICKET, ENERGY, KEY, STAR];
		private static var reelRandoms :Array = [COIN, TICKET, ENERGY, TICKET, KEY];
		
		static public function getRandomForReelSpin():String
		{
			return reelRandoms[int(Math.random() * reelRandoms.length)];
		}
		
		static public function getRandom():String
		{
			return allItems[int(Math.random() * allItems.length)];
		}
		
		static public function getAllPossibleItems():Array
		{
			return allItems;
		}
		
		public static function getItemTexture(itemType:String):Texture
		{
			var textureName:String = "store/powerups/instabingo";
			
			switch (itemType)
			{
				case SlotItem.ALISA_ICON:
					textureName = "store/powerups/instabingo";
					break;
				case SlotItem.COIN:
					textureName = "store/powerups/set_blue";
					break;
				case SlotItem.ENERGY:
					textureName = "store/powerups/rarity_green";
					break;
				case SlotItem.KEY:
					textureName = "store/powerups/tube_blue";
					break;
				case SlotItem.TICKET:
					textureName = "store/powerups/card_yellow";
					break;
				case SlotItem.STAR:
					textureName = "store/powerups/card_yellow";
					break;
				defalt:
					throw new Error("Unknown slot item");
					break;
			}
			
			return AtlasAsset.CommonAtlas.getTexture(textureName);
		}
		
		public static function getSmallItemTexture(itemType:String):Texture
		{
			var textureName:String = "bars/cash";
			
			switch (itemType)
			{
				case SlotItem.ALISA_ICON:
					textureName = "bars/alisa";
					break;
				case SlotItem.COIN:
					textureName = "bars/cash";
					break;
				case SlotItem.ENERGY:
					textureName = "bars/energy";
					break;
				case SlotItem.KEY:
					textureName = "bars/key";
					break;
				case SlotItem.TICKET:
					textureName = "bars/tickets";
					break;
				case SlotItem.STAR:
					textureName = "bars/exp";
					break;
				defalt:
					throw new Error("Unknown slot item");
					break;
			}
			
			return AtlasAsset.CommonAtlas.getTexture(textureName);
		}
		
		static public function getRandomForReelSpinExcluding(excludedItem:String):String
		{
			var adjustedItemsList:Array = reelRandoms.concat();
			var indexOfExcluded:int = adjustedItemsList.indexOf(excludedItem);
			while (indexOfExcluded != -1)
			{
				adjustedItemsList.splice(indexOfExcluded, 1);
				indexOfExcluded = adjustedItemsList.indexOf(excludedItem);
			}
			return adjustedItemsList[int(Math.random() * adjustedItemsList.length)];
		}
	}

}