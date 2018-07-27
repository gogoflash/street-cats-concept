package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.commands.dialogCommands.ShowStore;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.sales.SaleType;
	import com.alisacasino.bingo.screens.storeWindow.StoreScreen;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.Settings;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.utils.TweenHelper;
	
	import starling.display.Image;
	import starling.events.Event;

	public class CashBar extends ResourceBar
	{
		private var mAtlas:AtlasAsset = AtlasAsset.CommonAtlas;
		private var valueTween:Tween;
		
		private var targetValue:int;
		
		public var deferAnimation:Boolean;
		private var onTriggeredCallback:Function;
		
		public var custom:Boolean;
		
		public function CashBar(hidePlusButton:Boolean = false, onTriggeredCallback:Function = null)
		{
			super(Settings.instance.saleType, hidePlusButton);
			
			this.onTriggeredCallback = onTriggeredCallback;
			icon = new Image(mAtlas.getTexture("cats/fish_blue"));
			mCriticalValue = Constants.CRITICAL_VALUE_CASH;
			
			if (Player.current)
				setNewValue(Player.current.cashCount - Player.current.reservedCashCount, false);
			
			
			addEventListener(Event.TRIGGERED, onTriggered);
			
			icon.useHandCursor = true;
			mBtn.addReactDisplayObject(icon);
			mBtn.alpha = 0;
			
			
			if(!custom)
				addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			if (Player.current)
				setNewValue(Player.current.cashCount - Player.current.reservedCashCount);
		}
		
		private function onTriggered(e:Event):void
		{
			if (onTriggeredCallback != null)
				onTriggeredCallback();
		}
	}
}