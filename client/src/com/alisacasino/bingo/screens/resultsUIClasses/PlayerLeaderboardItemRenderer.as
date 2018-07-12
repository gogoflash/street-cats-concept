package com.alisacasino.bingo.screens.resultsUIClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.screens.resultsUIClasses.LeaderboardItemRenderer;
	import flash.geom.Rectangle;
	import starling.display.Image;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class PlayerLeaderboardItemRenderer extends LeaderboardItemRenderer
	{
		
		public function PlayerLeaderboardItemRenderer() 
		{
			
		}
		
		override protected function createBackground():void 
		{
			background = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/leaderboard_position_background"));
			(background as Image).scale9Grid = new Rectangle(47*pxScale, 0, 2*pxScale, 0);
			background.width = 650 * pxScale;
			background.x = (ITEM_WIDTH* pxScale - background.width) / 2;
			background.y = (ITEM_HEIGHT* pxScale - background.height) / 2;
			container.addChild(background);
		}
		
	}

}