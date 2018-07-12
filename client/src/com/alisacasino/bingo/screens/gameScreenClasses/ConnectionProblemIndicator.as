package com.alisacasino.bingo.screens.gameScreenClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ConnectionProblemIndicator extends Sprite
	{
		private var image:Image;
		private var showing:Boolean = false;
		
		public function ConnectionProblemIndicator() 
		{
			touchable = false;
			
			image = new Image(AtlasAsset.CommonAtlas.getTexture("game/connection_warning"));
			image.visible = false;
			image.alignPivot();
			addChild(image);
		}
		
		public function show():void
		{
			if (!showing)
			{
				showing = true;
				switchVisibility();
			}
		}
		
		private function switchVisibility():void 
		{
			image.visible = !image.visible;
			Starling.juggler.delayCall(switchVisibility, 0.7);
		}
		
		public function hide():void
		{
			if (showing)
			{
				showing = false;
				image.visible = false;
				Starling.juggler.removeDelayedCalls(switchVisibility);
			}
		}
		
	}

}