package com.alisacasino.bingo.dialogs.chests
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.utils.EffectsManager;
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.utils.Align;
	import starling.textures.Texture;
	import starling.display.Image;
	
	public class ChestGoodView extends Sprite
	{
		public static var TWEEN_TYPE_ALL:uint = 1;
		public static var TWEEN_TYPE_VALUE:uint = 2;
		
		private var iconImage:Image;
		private var titleBg:Image;
		private var title:XTextField;
		
		private var atlas:AtlasAsset;
		private var bgTexture:String;
		private var bgScale9Rect:Rectangle;
		private var bgWidth:Number;
		private var iconTexture:String;
		private var _value:String;
		private var tweenType:uint;
		private var labelStyle:XTextFieldStyle;
		
		public function ChestGoodView(atlas:AtlasAsset, 
									bgTexture:String, 
									bgScale9Rect:Rectangle,
									bgWidth:Number,
									iconTexture:String, 
									labelStyle:XTextFieldStyle,
									tweenType:uint,
									valueString:String) {
			this.atlas = atlas;
			this.bgTexture = bgTexture;
			this.bgScale9Rect = bgScale9Rect;
			this.bgWidth = bgWidth;
			this.iconTexture = iconTexture;
			this.tweenType = tweenType;
			_value = valueString;
			this.labelStyle = labelStyle;
			initialize();
		}
		
		public function reInit(atlas:AtlasAsset, bgTexture:String, iconTexture:String, labelStyle:XTextFieldStyle, tweenType:uint):void 
		{
			if (this.atlas != atlas || this.bgTexture != bgTexture) {
				titleBg.texture = atlas.getTexture(bgTexture);
				titleBg.readjustSize();
				titleBg.alignPivot(Align.LEFT, Align.CENTER);
				this.bgTexture = bgTexture;
			}
			
			if (this.atlas != atlas || this.iconTexture != iconTexture) {
				iconImage.texture = atlas.getTexture(iconTexture);
				iconImage.readjustSize();
				iconImage.alignPivot(Align.LEFT, Align.CENTER);
				this.iconTexture = iconTexture;
			}
			
			this.atlas = atlas;
			this.tweenType = tweenType;
			
			if (this.labelStyle != labelStyle) {
				this.labelStyle = labelStyle;
				title.textStyle = labelStyle;
			}
		}
		
		public function setProperties(iconShiftX:int, iconShiftY:int, labelShiftX:int, labelShiftY:int):void 
		{
			iconImage.readjustSize();
			iconImage.alignPivot(Align.LEFT, Align.CENTER);
			
			iconImage.x = iconShiftX * pxScale;
			iconImage.y = iconShiftY * pxScale;
			title.x = /*iconImage.pivotX + */labelShiftX * pxScale;
			title.y = title.pivotY / 2 + labelShiftY * pxScale;
			//trace('CHestGoodView.setProperties: ', iconImage.texture, iconImage.pivotX, title.pivotY);
		}
		
		protected function initialize():void 
		{
			titleBg = new Image(atlas.getTexture(bgTexture));
			if (bgScale9Rect) {
				titleBg.scale9Grid = bgScale9Rect;
				titleBg.width = bgWidth;
			}
			titleBg.alignPivot(Align.LEFT, Align.CENTER);
			addChild(titleBg);
			
			iconImage = new Image(atlas.getTexture(iconTexture));
			iconImage.alignPivot();
			addChild(iconImage);

			title = new XTextField((bgWidth != 0 ? bgWidth : titleBg.width) - iconImage.pivotX, titleBg.height, labelStyle, _value);
			title.alignPivot(Align.LEFT, Align.BOTTOM);
			//title.border = true;
			title.y = title.pivotY/2;
			title.x = iconImage.pivotX;
			addChild(title);
			
			if (tweenType == TWEEN_TYPE_ALL) {
				titleBg.alpha = 0;
				title.scaleY = 0;
				iconImage.scale = 0;
			}
			else if (tweenType == TWEEN_TYPE_VALUE) {
				title.scaleY = 0;
			}
		}
		
		public function set value(string:String):void {
			if (_value == string)
				return;
				
			_value = string;
			title.text = _value;
		}
		
		public function get value():String {
			return _value;
		}
		
		public function show(delay:Number, valueShowDelay:Number = 0):void
		{
			if (tweenType == TWEEN_TYPE_ALL) {
				Starling.juggler.tween(titleBg, 0.1, {transition:Transitions.LINEAR, delay:delay, alpha:1});
				Starling.juggler.tween(iconImage, 0.35, {transition:Transitions.EASE_OUT_BACK, delay:(delay + 0.02), scale:1});
				Starling.juggler.tween(title, 0.3, {transition:Transitions.EASE_OUT_BACK, delay:(delay + valueShowDelay), scaleY:1});
			}
			else if (tweenType == TWEEN_TYPE_VALUE) {
				Starling.juggler.tween(title, 0.3, {transition:Transitions.EASE_OUT_BACK, delay:(delay + valueShowDelay), scaleY:1});
			}
		}
			
		public function hide(delay:Number, forceHide:Boolean = false):void
		{
			if (forceHide)
			{
				Starling.juggler.removeTweens(titleBg);
				Starling.juggler.removeTweens(iconImage);
				Starling.juggler.removeTweens(title);
				
				if (tweenType == TWEEN_TYPE_ALL) {
					titleBg.alpha = 0;
					title.scaleY = 0;
					iconImage.scale = 0;
				}
				else if (tweenType == TWEEN_TYPE_VALUE) {
					title.scaleY = 0;
				}
				
				return;
			}
			
			if (tweenType == TWEEN_TYPE_ALL) {
				Starling.juggler.tween(titleBg, 0.2, {transition:Transitions.EASE_IN_BACK, delay:delay, width:0, height:0});
				Starling.juggler.tween(iconImage, 0.2, {transition:Transitions.EASE_IN_BACK, delay:(delay + 0.02), scaleY:0});
				Starling.juggler.tween(title, 0.2, {transition:Transitions.EASE_IN_BACK, delay:(delay + 0.02), scaleY:0});
			}
			else if (tweenType == TWEEN_TYPE_VALUE) {
				Starling.juggler.tween(title, 0.2, {transition:Transitions.EASE_IN_BACK, delay:(delay + 0.02), scaleY:0});
			}
		}
		
		public function animate(fromValue:int, toValue:int):void 
		{
			Starling.juggler.removeTweens(this);
			EffectsManager.removeJump(iconImage);
			//EffectsManager.removeJump(title);
			
			numberValue = fromValue;
			
			Starling.juggler.tween(this, 1, {numberValue:toValue});
			
			EffectsManager.jump(iconImage, 10, 1, 1.4, 0.07, 0.04, 0.0, 0, 0, 1.8, true, false);
			EffectsManager.jump(title, 10, 1, 1.15, 0.07, 0.04, 0.0, 0, 0, 2.8, true, false);
		}
		
		public function set numberValue(value:int):void {
			if (_numberValue == value)
				return;
				
			_numberValue = value;
			title.text = _numberValue.toString();
		}
		
		public function get numberValue():int {
			return _numberValue;
		}
		
		private var _numberValue:int;
	}	
}
