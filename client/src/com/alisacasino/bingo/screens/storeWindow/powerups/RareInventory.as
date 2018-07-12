package com.alisacasino.bingo.screens.storeWindow.powerups 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.models.powerups.Powerup;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class RareInventory extends PowerupInventoryGroup
	{
		
		public function RareInventory() 
		{
			powerups = gameManager.powerupModel.getRarePowerups();
			backgroundTexture = AtlasAsset.CommonAtlas.getTexture("store/dark_yellow_background");
			contentBackgroundTexture = AtlasAsset.CommonAtlas.getTexture("store/light_yellow_background");
			rarityIcon = AtlasAsset.CommonAtlas.getTexture("store/powerups/rarity_yellow");
			countTexture = AtlasAsset.CommonAtlas.getTexture("store/red_circle_yellow_outline");
			textColor = 0xfff600;
			rarityText = "RARE";
		}
		
	}

}