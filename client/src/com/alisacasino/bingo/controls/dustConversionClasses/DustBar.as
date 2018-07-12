package com.alisacasino.bingo.controls.dustConversionClasses
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.commands.dialogCommands.ShowStore;
	import com.alisacasino.bingo.controls.ResourceBar;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.sales.SaleType;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.storeWindow.StoreScreen;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.Settings;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import feathers.controls.Button;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.utils.TweenHelper;
	
	import starling.display.Image;
	import starling.events.Event;

	public class DustBar extends Sprite
	{
		private var mAtlas:AtlasAsset = AtlasAsset.CommonAtlas;
		
		private var button:Button;
		
		private var dustAnimation:AnimationContainer;
		private var bg:Image;
		
		private var label:XTextField;
		
		protected var targetValue:int;
		
		public function DustBar()
		{
			bg = new Image(AtlasAsset.CommonAtlas.getTexture("bars/white_glow_bar"));
			bg.scale9Grid = ResizeUtils.getScaledRect(1, 0, 1, 0);
			bg.width = 216 * pxScale;
			bg.pivotY = 29 * pxScale;
			bg.y = 6 * pxScale;
			addChild(bg);
			
			label = new XTextField(125*pxScale/* * scale*/, 50*pxScale/* * scale*/, XTextFieldStyle.getWalrus(30), '0');
			label.touchable = false;
			label.pivotY = 25 * pxScale;
			label.pivotX = 62 * pxScale;
			label.x = 107 * pxScale;
			label.y = 10 * pxScale;
			//label.border = true;
			addChild(label);
			
			dustAnimation = new AnimationContainer(MovieClipAsset.PackBase);
			dustAnimation.pivotX = 35*pxScale;
			dustAnimation.pivotY = 42*pxScale;
			//dustAnimation.y = 28*pxScale + 41*pxScale;
			dustAnimation.repeatCount = 0;
			dustAnimation.playTimeline('bulb', false, true, 25);
			addChild(dustAnimation);
			dustAnimation.useHandCursor = true;
			
			var touchQuad:Quad = new Quad(250*pxScale, 84*pxScale);
			touchQuad.alpha = 0.0;
			
			button = new Button();
			button.pivotX = dustAnimation.pivotX;
			button.pivotY = dustAnimation.pivotY;
			button.defaultSkin = touchQuad;
			button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
			button.useHandCursor = true;
			addChild(button);
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			if (Player.current)
				setNewValue(Player.current.dustCount, false);
		}
		
		public function get value():uint
		{
			return label.numValue;
		}

		public function set value(value:uint):void
		{
			if (label.numValue == value)
			{
				return;
			}
			label.numValue = value;
		}
		
		private function button_triggeredHandler(e:Event):void 
		{
			SoundManager.instance.playSfx(SoundAsset.ButtonClick, 0, 0, SoundAsset.DEFAULT_BUTTON_CLICK_VOLUME, 0, true);
			dispatchEventWith(Event.TRIGGERED);
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			if (Player.current)
				setNewValue(Player.current.dustCount - Player.current.reservedDustCount);
		}
		
		public function setNewValue(newValue:uint, animate:Boolean = true, delay:Number = 0.0):void
		{
			if (targetValue == newValue)
				return;
			
			var div:int = newValue - targetValue;
		    targetValue = newValue;	
			
			var duration:Number = getAnimationDuration(div);
				
			Starling.juggler.removeTweens(label);
			EffectsManager.removeJump(dustAnimation);
			EffectsManager.removeJump(label);

			if (animate)
			{
				if(div > 0)
				{
					label.animateToValue(newValue, duration, delay);
				
					var jumpsCount:int = Math.max(5, duration/0.11);
					
					EffectsManager.jump(dustAnimation, jumpsCount, 1, 1.2, 0.07, 0.04, 0.0, 0, 0, 1.8, true, false);
					EffectsManager.jump(label, jumpsCount, 1, 1.3, 0.07, 0.04, 0.0, 0, 0, 2.8, true, false);
				}
				else
				{
					label.animateToValue(newValue, duration, delay);
				}
			}
			else
			{
				value = newValue;
			}
		}
		
		protected function getAnimationDuration(count:int):Number {
			if (count >= 100)
				return 1.8;
			else if (count >= 10)
				return 1;
			else if (count > 0)
				return 0.5;
			
			return 0.5;
		}
		
	}
}