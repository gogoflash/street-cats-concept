package com.alisacasino.bingo.components
{
	
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.Fonts;
	import com.alisacasino.bingo.controls.BingoTextFormat;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.utils.StringUtils;
	import com.alisacasino.bingo.utils.TimeService;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.setInterval;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.Align;
	
	
	public class ClockTimerView extends Sprite
	{
		private var timerBg:Image;
		private var timerArrow:Image;
		private var timerLabel:TextField;
		private var timerLabelShiftX:int;
		private var stringFormat:Vector.<String>;
		private var startAngle:Number;
		private var timerLabelShortShiftX:int;
		
		private var timerImagesScaleMax:Number = 0.82;
		
		public function ClockTimerView(timerLabelShiftX:int, startAngle:Number = 0, timerLabelShortShiftX:int = 25)
		{
			this.timerLabelShiftX = timerLabelShiftX;
			this.startAngle = startAngle;
			this.timerLabelShortShiftX = timerLabelShortShiftX;
			init();
			
			stringFormat = new < String > ['h', 'min', 'm', 'sec', 'sec', '  ', '  ', '', ''];
		}
		
		public function init():void
		{				
			timerBg = new Image(AtlasAsset.CommonAtlas.getTexture("controls/clock_bg"));
			timerBg.alignPivot();
			timerBg.scale = 0;
			addChild(timerBg);
			
			var timerTextFormat:BingoTextFormat = new BingoTextFormat(Fonts.WALRUS_BOLD, 24 * pxScale, 0x5D5D5D, Align.LEFT);
			
			timerLabel = new TextField(170 * pxScale, 30 * pxScale, '2H 49MIN', timerTextFormat);
			timerLabel.alignPivot();
			timerLabel.x = timerLabelShiftX * pxScale;
			timerLabel.y = 0*pxScale;
			//timerLabel.border = true;
			timerLabel.pixelSnapping = false;
			timerLabel.scaleX = 1.3;
			timerLabel.scaleY = 0;
			addChild(timerLabel);
			
			timerArrow = new Image(AtlasAsset.CommonAtlas.getTexture("controls/clock_arrow"));
			//timerArrow.alignPivot();
			timerArrow.pivotX = 13 * pxScale;
			timerArrow.pivotY = 12 * pxScale;
			timerArrow.rotation = startAngle;
			timerArrow.scale = 0;
			addChild(timerArrow);
			//resize();
			
		}

		public function setTime(time:int, callArrowTween:Boolean = true):void
		{
			if(!gameManager.deactivated)
				timerLabel.text = StringUtils.formatTimeShort(time, stringFormat);
			
			timerLabel.x = (timerLabel.text.length > 5 ? timerLabelShiftX : (timerLabelShortShiftX + timerLabelShiftX)) * pxScale;
			
			if(callArrowTween)
				roundTween(timerArrow);
		}
		
		public function resize():void
		{

		}
		
		public function clean():void
		{
			Starling.juggler.removeTweens(timerBg);
			Starling.juggler.removeTweens(timerLabel);
			Starling.juggler.removeTweens(timerArrow);
		}
		
		public function show(delay:Number):void
		{
			Starling.juggler.tween(timerBg, 0.2, {transition:Transitions.EASE_OUT_BACK, delay:delay, scale:timerImagesScaleMax});
			Starling.juggler.tween(timerArrow, 0.2, {transition:Transitions.EASE_OUT_BACK, delay:delay, scale:timerImagesScaleMax});
			Starling.juggler.tween(timerLabel, 0.2, {transition:Transitions.EASE_OUT_BACK, delay:(delay + 0.15), scaleX:1, scaleY:1 });
		}
		
		public function hide(delay:Number, onComplete:Function = null):void
		{
			Starling.juggler.tween(timerBg, 0.2, {transition:Transitions.EASE_IN_BACK, delay:delay, scale:0});
			Starling.juggler.tween(timerArrow, 0.2, {transition:Transitions.EASE_IN_BACK, delay:delay, scale:0});
			Starling.juggler.tween(timerLabel, 0.2, {transition:Transitions.EASE_IN_BACK, delay:(delay + 0.15), scaleX:0, scaleY:0, onComplete:onComplete });
		}
		
		public function get contentWidth():uint
		{
			return -timerLabel.pivotX + timerLabel.x + timerLabel.textBounds.x + timerLabel.textBounds.width;
		}
		
		private function roundTween(displayObject:DisplayObject):void
		{
			//var tween:Tween = new Tween(displayObject, 0.9, Transitions.EASE_OUT_BACK);
			var tween:Tween = new Tween(displayObject, 1.2, Transitions.EASE_OUT_ELASTIC);
			tween.delay = 0.1;
			tween.animate('rotation', displayObject.rotation + 2*Math.PI/5);
			//tween.onComplete = roundTween;
			//tween.onCompleteArgs = [displayObject];
			Starling.juggler.add(tween);
		}
		
	}
}