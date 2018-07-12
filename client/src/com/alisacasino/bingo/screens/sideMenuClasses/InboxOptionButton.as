package com.alisacasino.bingo.screens.sideMenuClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.gifts.GiftsModel;
	import flash.utils.setInterval;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class InboxOptionButton extends OptionButton
	{
		public function InboxOptionButton(iconTexture:Texture, labelText:String) 
		{
			super(iconTexture, labelText);
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			gameManager.giftsModel.addEventListener(GiftsModel.EVENT_CHANGE_AVAILABLE_TO_GET, handler_changeGiftsAvailableToGet);
			handler_changeGiftsAvailableToGet(null);
			
			//setInterval(function():void{ inboxLabelCount = int(15*Math.random()) }, 1000);
		}
		
		private function handler_changeGiftsAvailableToGet(event:Event):void 
		{
			if (!gameManager.tutorialManager.tutorialFirstLevelPassed
				|| gameManager.giftsModel.availableToGetCount <= 0) {
				labelCount = 0;
				return;
			}
			
			labelCount = gameManager.giftsModel.availableToGetCount;
		}

		override public function dispose():void {
			gameManager.giftsModel.removeEventListener(GiftsModel.EVENT_CHANGE_AVAILABLE_TO_GET, handler_changeGiftsAvailableToGet);
			super.dispose();
		}
	}
}