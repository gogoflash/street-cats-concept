package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.commands.dialogCommands.ShowStore;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.powerups.PowerupModel;
	import com.alisacasino.bingo.models.sales.SaleType;
	import com.alisacasino.bingo.screens.storeWindow.StoreScreen;
	import com.alisacasino.bingo.utils.Constants;
	
	import starling.display.Image;
	import starling.events.Event;

	public class EnergyBar extends ResourceBar
	{
		private var mAtlas:AtlasAsset = AtlasAsset.CommonAtlas;
		private var mPlayer:Player = Player.current;
		private var powerupModel:PowerupModel;
		private var onTriggeredCallback:Function;
		
		public function EnergyBar(hidePlusButton:Boolean = false, onTriggeredCallback:Function = null)
		{
			super(SaleType.NO_SALE, hidePlusButton);
			this.onTriggeredCallback = onTriggeredCallback;
			
			icon = new Image(mAtlas.getTexture("bars/energy"));
			mCriticalValue = Constants.CRITICAL_VALUE_ENERGY;
			
			powerupModel = gameManager.powerupModel;
			
			setNewValue(powerupModel.powerupsTotal - powerupModel.reservedPowerupsCount, false);
			
			//addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.TRIGGERED, onTriggered);
			
			icon.useHandCursor = true;
			mBtn.addReactDisplayObject(icon);
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}	
		
		private function enterFrameHandler(e:Event):void 
		{
			//value = gameManager.powerupModel.powerupsTotal - gameManager.powerupModel.reservedPowerupsCount;
			setNewValue(powerupModel.powerupsTotal - powerupModel.reservedPowerupsCount);
		}

		/*private function onAddedToStage(e:Event):void
		{
			mImage.x = mImage.width * 0.2;
			pivotX = width / 2 - mImage.width * 0.3;
		}*/
		
		private function onTriggered(e:Event):void
		{
			if (onTriggeredCallback != null)
				onTriggeredCallback();
		}
		
		override protected function getAnimationDuration(count:int):Number {
			if (count >= 7)
				return 1.8;
			else if (count >= 3)
				return 1;
			else if (count > 0)
				return 0.5;
			
			return 0.5;
		}
	}
}