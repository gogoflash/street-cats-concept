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
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.Align;
	
	
	public class SimpleProgressBar extends Sprite
	{
		private var progressFrame:Image;
		private var progressFillImage:Image;
		private var label:XTextField;
		
		private var _value:Number = 0;
		
		private var atlas:AtlasAsset
		private var backgroundTexture:String
		private var fillTexture:String;
		//private var labelShiftX:int;
		//private var labelShiftY:int;
		//private var labelStyle:XTextFieldStyle;
		private var fillShiftX:Number;
		
		public function SimpleProgressBar(atlas:AtlasAsset, backgroundTexture:String, fillTexture:String, fillShiftX:Number)
		{
			this.atlas = atlas;
			this.backgroundTexture = backgroundTexture;
			this.fillTexture = fillTexture;
			this.fillShiftX = fillShiftX;
			
			init();
		}
		
		public function setLabel(style:XTextFieldStyle, shiftX:int = 0, shiftY:int = 0):void
		{
			label = new XTextField(progressFrame.width, progressFrame.height, style, '12:12:12');
			label.x = shiftX * pxScale;
			label.y = shiftY * pxScale;
			//label.border = true;
			addChild(label);
		}
		
		private function init():void
		{				
			progressFillImage = new Image(atlas.getTexture(fillTexture));
			progressFillImage.mask = new Quad(progressFillImage.width, progressFillImage.height);
			progressFillImage.mask.width = 0;
			
			
			progressFrame = new Image(atlas.getTexture(backgroundTexture));
			addChild(progressFrame);
				
			
			addChild(progressFillImage);
			//debugTest();
		}
		
		public function get value():Number
		{
			return _value;
		}
		
		public function set value(v:Number):void
		{
			if (_value == v)
				return;
				
			_value = Math.min(1, Math.max(0, v));
			//trace('1', v, _value);
			progressFillImage.mask.width = (fillShiftX * pxScale + (progressFillImage.texture.frameWidth - 2 * fillShiftX * pxScale) * _value);
		}
		
		public function set labelText(value:String):void
		{
			if(label)
				label.text = value;
		}
		
		public function animateValues(progress:Number, duration:Number=1.0, delay:Number = 0.0):void
		{
			Starling.juggler.tween(this, duration, {delay:delay, value:progress, transition:Transitions.EASE_OUT_BACK});
		}
		
		private function debugTest():void {
			setInterval(function():void {
				animateValues(Math.random(), 1, 0);
				labelText = Math.round(Math.random() * 15).toString() + '/' + Math.round(Math.random() * 15).toString();
			}, 2000);
		}
		
		private function debugSet():void {
			animateValues(Math.random(), 1, 0);
			labelText = Math.round(Math.random() * 15).toString() + '/' + Math.round(Math.random() * 15).toString();
		}
	}
}