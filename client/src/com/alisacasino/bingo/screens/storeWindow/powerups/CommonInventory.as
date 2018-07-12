package com.alisacasino.bingo.screens.storeWindow.powerups 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CommonInventory extends PowerupInventoryGroup
	{
		
		public function CommonInventory() 
		{
			powerups = gameManager.powerupModel.getCommonPowerups();
			backgroundTexture = AtlasAsset.CommonAtlas.getTexture("store/dark_green_background");
			contentBackgroundTexture = AtlasAsset.CommonAtlas.getTexture("store/light_green_background");
			rarityIcon = AtlasAsset.CommonAtlas.getTexture("store/powerups/rarity_green");
			countTexture = AtlasAsset.CommonAtlas.getTexture("store/red_circle_green_outline");
			textColor = 0x6cff00;
			rarityText = "NORMAL";
		}
		
	}

}