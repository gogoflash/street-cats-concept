package com.alisacasino.bingo.controls
{
	import by.blooddy.crypto.image.palette.IPalette;
	import com.alisacasino.bingo.utils.caurina.transitions.Tweener;
	import flash.utils.setInterval;
	import starling.animation.Transitions;
	import starling.display.Quad;
	import starling.textures.Texture;
	import starling.utils.Align;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class Scale9ProgressBar extends Sprite
	{
		protected var glass:Image;
		protected var fill:Image;
		private var label:XTextField;
		
		protected var _value:Number = -1;
		
		protected var fillLeftGap:Number;
		protected var fillRightGap:Number;
		protected var enableFillCorrection:Boolean;
		
		public function Scale9ProgressBar(  foregroundTexture:Texture,
											foregroundScale9Rect:Rectangle,
											fillTexture:Texture,
											fillScale9Rect:Rectangle,
											
											bgWidth:Number,
											fillShiftY:Number,
											fillLeftGap:Number,
											fillRightGap:Number,
											enableFillCorrection:Boolean = false,
											fillMaskMode:Boolean = false
											)
		{
			this.fillLeftGap = fillLeftGap;
			this.fillRightGap = fillRightGap;
			this.enableFillCorrection = enableFillCorrection;
			
			glass = new Image(foregroundTexture);
			glass.scale9Grid = foregroundScale9Rect;
			glass.width = bgWidth;
			
			fill = new Image(fillTexture);
			fill.scale9Grid = fillScale9Rect;
			fill.alignPivot(Align.LEFT, Align.CENTER);
			fill.y = fill.pivotY + fillShiftY;
			fill.x = fillLeftGap;
			
			if (fillMaskMode) 
			{
				fill.width = bgWidth - fillLeftGap - fillRightGap;
				fill.mask = new Quad(fill.width, glass.height);
				fill.mask.width = 0;
			}
			
			addChild(fill);
			addChild(glass);
			
			value = 0;
			
			//debugTest();
		}
		
		public function setLabel(style:XTextFieldStyle, shiftX:int = 0, shiftY:int = 0):void
		{
			label = new XTextField(glass.width, glass.height, style, '');
			label.x = shiftX * pxScale;
			label.y = shiftY * pxScale;
			//label.border = true;
			addChild(label);
		}
		
		public function set labelText(value:String):void
		{
			if(label)
				label.text = value;
		}
			
		public function setProperties(fillColor:uint):void 
		{
			fill.color = fillColor;
		}
		
		public function setBackgroundImage(backgroundTexture:Texture, scale9Grid:Rectangle, bgWidth:Number, color:uint = 0xFFFFFF, alpha:Number = 1):void
		{
			var bg:Image = new Image(backgroundTexture);
			bg.scale9Grid = scale9Grid;
			bg.width = bgWidth;
			bg.color = color;
			bg.alpha = alpha;
			addChildAt(bg, 0);
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
			
			if (fill.mask)
				fill.mask.width = fill.texture.nativeWidth * _value;
			else	
				fill.width = (glass.width - fillLeftGap - fillRightGap) * _value;
			
			if (enableFillCorrection)
				fillCorrection();
		}
		
		protected function fillCorrection():void 
		{
			var correctionWidth:Number = fill.texture.frameWidth / 2;
			if (fill.width < correctionWidth) 
				fill.height =  Math.pow(fill.width/correctionWidth, 0.4) * fill.texture.frameHeight;
			else 
				fill.height = fill.texture.frameHeight;
		}
		
		public function animateValues(progress:Number, duration:Number=1.0, delay:Number = 0.0, transition:String = null):void
		{
			if (duration == 0 && delay == 0)
				value = progress;
			else	
				Starling.juggler.tween(this, duration, {delay:delay, value:progress, transition:(transition || Transitions.EASE_OUT)});
		}
		
		private function debugTest():void 
		{
			setInterval(function():void 
			{
				//var rnd:Number = value == 0.75 ? 0.25 : 0.75;
				var rnd:Number = 0.98 + Math.random() * 0.02;
				animateValues(rnd, 1, 0);
				labelText = Math.round(rnd * 100).toString() + '/' + Math.round(100).toString();
			}, 4000);
		}
	}
}