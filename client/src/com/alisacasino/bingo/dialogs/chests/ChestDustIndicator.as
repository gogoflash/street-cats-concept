package com.alisacasino.bingo.dialogs.chests
{
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.utils.EffectsManager;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.utils.Align;
	import starling.textures.Texture;
	import starling.display.Image;
	
	public class ChestDustIndicator extends Sprite
	{
		public static var TWEEN_TYPE_ALL:uint = 1;
		public static var TWEEN_TYPE_VALUE:uint = 2;
		
		private var icon:AnimationContainer;
		private var titleBg:Image;
		private var title:XTextField;
		
		private var atlas:AtlasAsset;
		private var bgTexture:String;
		private var iconTexture:String;
		private var _value:String;
		private var tweenType:uint;
		private var labelStyle:XTextFieldStyle;
		private var descriptionTitle:XTextField;
		
		public function ChestDustIndicator()
		{
			this.atlas = AtlasAsset.CommonAtlas;
			this.bgTexture = "bars/base_glow";
			_value = "0";
			this.labelStyle = XTextFieldStyle.getWalrus(33, 0xFFFFFF).setShadow();
			tweenType = TWEEN_TYPE_VALUE;
			initialize();
		}
		
		protected function initialize():void
		{
			descriptionTitle = new XTextField(200 * pxScale, 30 * pxScale, XTextFieldStyle.getWalrus(24, 0xFFFFFF, Align.LEFT).setStroke(), "Dust price:");
			//descriptionTitle.alpha = ;
			descriptionTitle.x = -4 * pxScale;
			descriptionTitle.alignPivot(Align.LEFT, Align.BOTTOM);
			//addChild(descriptionTitle);
			
			titleBg = new Image(atlas.getTexture(bgTexture));
			titleBg.alignPivot(Align.LEFT, Align.CENTER);
			//titleBg.y = 36 * pxScale;
			addChild(titleBg);
			
			icon = new AnimationContainer(MovieClipAsset.PackBase);
			icon.scale = 0.9;
			icon.pivotX = 2*pxScale;
			icon.pivotY = 42*pxScale;
			//icon.y = 36*pxScale;
			icon.repeatCount = 0;
			icon.playTimeline('bulb', false, true, 25);
			addChild(icon);
			
			title = new XTextField(titleBg.width - icon.pivotX, titleBg.height, labelStyle, _value);
			title.alignPivot(Align.LEFT, Align.BOTTOM);
			title.y = title.pivotY / 2;
			title.x = icon.pivotX;
			addChild(title);
			
			if (tweenType == TWEEN_TYPE_ALL)
			{
				titleBg.alpha = 0;
				title.scaleY = 0;
				icon.scale = 0;
			}
			else if (tweenType == TWEEN_TYPE_VALUE)
			{
				title.scaleY = 0;
			}
		}
		
		public function set value(string:String):void
		{
			if (_value == string)
				return;
			
			_value = string;
			title.text = _value;
		}
		
		public function get value():String
		{
			return _value;
		}
		
		public function show(delay:Number, valueShowDelay:Number = 0):void
		{
			if (tweenType == TWEEN_TYPE_ALL)
			{
				Starling.juggler.tween(titleBg, 0.1, {transition: Transitions.LINEAR, delay: delay, alpha: 1});
				Starling.juggler.tween(icon, 0.35, {transition: Transitions.EASE_OUT_BACK, delay: (delay + 0.02), scale: 1});
				Starling.juggler.tween(title, 0.3, {transition: Transitions.EASE_OUT_BACK, delay: (delay + valueShowDelay), scaleY: 1});
			}
			else if (tweenType == TWEEN_TYPE_VALUE)
			{
				Starling.juggler.tween(title, 0.3, {transition: Transitions.EASE_OUT_BACK, delay: (delay + valueShowDelay), scaleY: 1});
			}
		}
		
		public function hide(delay:Number, forceHide:Boolean = false):void
		{
			if (forceHide)
			{
				Starling.juggler.removeTweens(titleBg);
				Starling.juggler.removeTweens(icon);
				Starling.juggler.removeTweens(title);
				
				if (tweenType == TWEEN_TYPE_ALL)
				{
					titleBg.alpha = 0;
					title.scaleY = 0;
					icon.scale = 0;
				}
				else if (tweenType == TWEEN_TYPE_VALUE)
				{
					title.scaleY = 0;
				}
				
				return;
			}
			
			if (tweenType == TWEEN_TYPE_ALL)
			{
				Starling.juggler.tween(titleBg, 0.2, {transition: Transitions.EASE_IN_BACK, delay: delay, scale: 0});
				Starling.juggler.tween(icon, 0.2, {transition: Transitions.EASE_IN_BACK, delay: (delay + 0.02), scaleY: 0});
				Starling.juggler.tween(title, 0.2, {transition: Transitions.EASE_IN_BACK, delay: (delay + 0.02), scaleY: 0});
			}
			else if (tweenType == TWEEN_TYPE_VALUE)
			{
				Starling.juggler.tween(title, 0.2, {transition: Transitions.EASE_IN_BACK, delay: (delay + 0.02), scaleY: 0});
			}
		}
		
		public function animate(fromValue:int, toValue:int):void
		{
			Starling.juggler.removeTweens(this);
			EffectsManager.removeJump(icon);
			
			numberValue = fromValue;
			
			Starling.juggler.tween(this, 1, {numberValue: toValue});
			
			EffectsManager.jump(icon, 10, 1, 1.4, 0.07, 0.04, 0.0, 0, 0, 1.8, true, false);
			EffectsManager.jump(title, 10, 1, 1.15, 0.07, 0.04, 0.0, 0, 0, 2.8, true, false);
		}
		
		public function setProperties(labelShiftX:int, labelShiftY:int):void {

			title.x = labelShiftX * pxScale;
			title.y = title.pivotY / 2 + labelShiftY * pxScale;
		}
		
		public function set numberValue(value:int):void
		{
			if (_numberValue == value)
				return;
			
			_numberValue = value;
			title.text = _numberValue.toString();
		}
		
		public function get numberValue():int
		{
			return _numberValue;
		}
		
		private var _numberValue:int;
	}
}
