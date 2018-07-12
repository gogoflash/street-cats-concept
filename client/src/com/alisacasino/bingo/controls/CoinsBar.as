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

	public class CoinsBar extends ResourceBar
	{
		private var mAtlas:AtlasAsset = AtlasAsset.CommonAtlas;
		private var mPlayer:Player = Player.current;
		private var valueTween:Tween;
		
		private var targetValue:int;
		
		public var deferAnimation:Boolean;
		
		public function CoinsBar(hidePlusButton:Boolean = false)
		{
			super(Settings.instance.saleType, hidePlusButton);
			icon = new Image(mAtlas.getTexture("bars/cash"));
			mCriticalValue = Constants.CRITICAL_VALUE_CASH;
			if (mPlayer)
			{
				setWithoutAnimation(mPlayer.cashCount);
			}
			
			addEventListener(Event.TRIGGERED, showBuyCoinsDialog);
			
			icon.useHandCursor = true;
			mBtn.addReactDisplayObject(icon);
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			if (mPlayer && !deferAnimation)
			{
				value = mPlayer.cashCount;
			}
		}
		
		private function showBuyCoinsDialog(e:Event):void
		{
			new ShowStore(StoreScreen.CASH_MODE, true).execute();
		}
		
		override public function set value(val:uint):void 
		{
			if (targetValue == val)
				return;
			
			if (val > value)
			{
				clearAnimations();
				targetValue = val;
				Starling.juggler.delayCall(animate, 0.2, val);
			}
			else
			{
				setWithoutAnimation(val);
			}
		}
		
		public function setWithoutAnimation(val:uint):void 
		{
			clearAnimations();
			targetValue = val;
			resetIconTransformation();
			superValue = val;
		}
		
		private function clearAnimations():void 
		{
			Starling.juggler.removeTweens(icon);
			Starling.juggler.remove(valueTween);
		}
		
		private function resetIconTransformation():void 
		{
			icon.scale = 1;
			icon.rotation = 0;
		}
		
		private function animate(target:uint):void 
		{
			var diff:int = target - value;
			var steps:int = diff / 2;
			steps = Math.max(1, Math.min(steps, 10));
			
			var animateValueTarget:int = value + diff / steps;
			
			var tween:Tween = TweenHelper.tween(icon, 0.01, {scale: 1.6})
				.chain(icon, 0.15, {scale:1.4});
			var tween2:Tween = TweenHelper.tween(this, 0.01, {superValue: animateValueTarget})
				.chain(this, 0.15, {});
			var tween3:Tween = TweenHelper.tween(mLabel, 0.01, {scale: 1.6})
				.chain(mLabel, 0.15, {scale:1.4});
				
			for (var i:int = 0; i < steps; i++) 
			{
				tween.chain(icon, 0.01, {scale: 1.6})
				.chain(icon, 0.15, {scale:1.4});
				
				animateValueTarget = value + diff / steps * (i + 1);
				tween2.chain(this, 0.01, {superValue: animateValueTarget})
				.chain(this, 0.15, {});
				
				tween3.chain(mLabel, 0.01, {scale: 1.6})
				.chain(mLabel, 0.15, {scale:1.4});
			}
			
			tween.chain(icon, 0.2, {scale: 1, rotation: 0, transition:Transitions.EASE_OUT_BOUNCE});
			tween3.chain(mLabel, 0.2, {scale: 1, rotation: 0, transition:Transitions.EASE_OUT_BOUNCE});
		}
		
		public function get superValue():int
		{
			return super.value;
		}
		
		public function set superValue(value:int):void
		{
			super.value = value;
		}
		
		public function tweenAnimate(val:int):void 
		{
			deferAnimation = true;
			
			mLabel.animateToValue(super.value + val, 1);
			
			EffectsManager.jump(icon, 10, 1, 1.4, 0.07, 0.04, 0.0, 0, 0, 1.8, true, false);
			EffectsManager.jump(mLabel, 10, 1, 1.15, 0.07, 0.04, 0.0, 0, 0, 2.8, true, false);
			EffectsManager.jump(mBtn, 10, 1, 1.2, 0.07, 0.04, 0.0, 0, 0, 2.8, true, false);
		}
	}
}