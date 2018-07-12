package com.alisacasino.bingo.screens.storeWindow.cash 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.screens.storeWindow.cash.CashStorePlaque;
	import feathers.core.FeathersControl;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class SmallBlueItem extends CashStorePlaque
	{
		
		
		public function SmallBlueItem() 
		{
			
		}
		
		override protected function getBackgroundTexture():Texture 
		{
			return AtlasAsset.CommonAtlas.getTexture("store/dark_blue_background");
		}
		
		override protected function getContentBackground():Texture 
		{
			return AtlasAsset.CommonAtlas.getTexture("store/light_blue_background");
		}
		
		override protected function getElementWidth():Number 
		{
			return 273 * pxScale;
		}
		
		override protected function getElementHeight():Number 
		{
			return 229 * pxScale;
		}
		
		
	}

}