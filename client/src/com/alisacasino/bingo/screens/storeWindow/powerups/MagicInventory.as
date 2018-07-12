package com.alisacasino.bingo.screens.storeWindow.powerups 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.models.powerups.Powerup;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class MagicInventory extends PowerupInventoryGroup
	{
		
		public function MagicInventory() 
		{
			powerups = gameManager.powerupModel.getMagicPowerups();
			backgroundTexture = AtlasAsset.CommonAtlas.getTexture("store/dark_blue_background");
			contentBackgroundTexture = AtlasAsset.CommonAtlas.getTexture("store/light_blue_background");
			rarityIcon = AtlasAsset.CommonAtlas.getTexture("store/powerups/rarity_blue");
			countTexture = AtlasAsset.CommonAtlas.getTexture("store/red_circle_blue_outline");
			textColor = 0x00ffe4;
			rarityText = "MAGIC";
		}
		
	}

}