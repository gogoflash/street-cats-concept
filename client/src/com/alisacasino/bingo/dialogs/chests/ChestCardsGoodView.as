package com.alisacasino.bingo.dialogs.chests 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.components.CardsIconView;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.utils.EffectsManager;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.utils.Align;
	
	public class ChestCardsGoodView extends Sprite 
	{
		private var cardsIconView:CardsIconView;
		private var titleBg:Image;
		private var title:XTextField;
		
		private var bgWidth:Number;
		private var _value:String;
		private var labelStyle:XTextFieldStyle;
		private var cardType:int;
		private var cardColorType:int;
		
		public function ChestCardsGoodView(bgWidth:Number, cardType:int, cardColorType:int, labelStyle:XTextFieldStyle, valueString:String) 
		{
			super();
			this.bgWidth = bgWidth;
			this.cardType = cardType;
			this.cardColorType = cardColorType;
			_value = valueString;
			this.labelStyle = labelStyle;
			initialize();
		}
		
		public function setProperties(iconShiftX:int, iconShiftY:int, labelShiftX:int, labelShiftY:int):void 
		{
			cardsIconView.x = iconShiftX * pxScale;
			cardsIconView.y = iconShiftY * pxScale;
			title.x = /*iconImage.pivotX + */labelShiftX * pxScale;
			title.y = title.pivotY / 2 + labelShiftY * pxScale;
		}
		
		protected function initialize():void 
		{
			titleBg = new Image(AtlasAsset.CommonAtlas.getTexture('buy_cards/gray_bg'));
			titleBg.scale9Grid = ResizeUtils.getScaledRect(27, 0, 2, 0);
			titleBg.width = bgWidth;
			titleBg.alignPivot(Align.LEFT, Align.CENTER);
			addChild(titleBg);

			cardsIconView = new CardsIconView(cardType, cardColorType);
			//cardsIconView.x = -202*pxScale;
			//cardsIconView.y = -40 * pxScale;
			//cardsIconView.scale = 0.5;
			addChild(cardsIconView);
			
			title = new XTextField((bgWidth != 0 ? bgWidth : titleBg.width) - cardsIconView.pivotX, titleBg.height, labelStyle, _value);
			title.alignPivot(Align.LEFT, Align.BOTTOM);
			//title.border = true;
			title.y = title.pivotY/2;
			title.x = cardsIconView.pivotX;
			addChild(title);
			
			titleBg.alpha = 0;
			title.scaleY = 0;
			cardsIconView.scale = 0;
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
			Starling.juggler.tween(titleBg, 0.1, {transition:Transitions.LINEAR, delay:delay, alpha:1});
			Starling.juggler.tween(cardsIconView, 0.35, {transition:Transitions.EASE_OUT_BACK, delay:(delay + 0.02), scale:1});
			Starling.juggler.tween(title, 0.3, {transition:Transitions.EASE_OUT_BACK, delay:(delay + valueShowDelay), scaleY:1});
		}
			
		public function hide(delay:Number, forceHide:Boolean = false):void
		{
			if (forceHide)
			{
				Starling.juggler.removeTweens(titleBg);
				Starling.juggler.removeTweens(cardsIconView);
				Starling.juggler.removeTweens(title);
				
				titleBg.alpha = 0;
				title.scaleY = 0;
				cardsIconView.scale = 0;
				
				return;
			}
			
			Starling.juggler.tween(titleBg, 0.2, {transition:Transitions.EASE_IN_BACK, delay:delay, width:0, height:0});
			Starling.juggler.tween(cardsIconView, 0.2, {transition:Transitions.EASE_IN_BACK, delay:(delay + 0.02), scaleY:0});
			Starling.juggler.tween(title, 0.2, {transition:Transitions.EASE_IN_BACK, delay:(delay + 0.02), scaleY:0});
		}
		
		public function animate(fromValue:int, toValue:int):void 
		{
			Starling.juggler.removeTweens(this);
			EffectsManager.removeJump(cardsIconView);
			//EffectsManager.removeJump(title);
			
			numberValue = fromValue;
			
			Starling.juggler.tween(this, 1, {numberValue:toValue});
			
			EffectsManager.jump(cardsIconView, 10, 1, 1.4, 0.07, 0.04, 0.0, 0, 0, 1.8, true, false);
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