package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.display.Quad;
	import starling.utils.Align;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class AnimatedProgressBar extends Sprite
	{
		protected var bg:Image;
		protected var fill:Image;
		protected var edge:Image;
		protected var levelLabel:XTextField;
		
		protected var _value:Number;
		protected var maskX:Number;
		protected var edgeTexture:String;
		protected var edgeWidthShift:Number;
		
		public function AnimatedProgressBar(backgroundTexture:String,
											fillTexture:String,
											edgeTexture:String,
											backgroundScale9X:Number,
											backgroundScale9Width:Number,
											fillScale9X:Number,
											fill9Width:Number,
											maskX:Number,
											bgWidth:Number,
											edgeWidthShift:Number
											)
		{
			this.maskX = maskX * pxScale;
			this.edgeTexture = edgeTexture;
			this.edgeWidthShift = edgeWidthShift * pxScale;
			bg = new Image(AtlasAsset.CommonAtlas.getTexture(backgroundTexture));
			bg.scale9Grid = new Rectangle(backgroundScale9X * pxScale, 0, backgroundScale9Width * pxScale, bg.texture.frameHeight);
			bg.width = bgWidth* pxScale;
			
			fill = new Image(AtlasAsset.CommonAtlas.getTexture(fillTexture));
			fill.scale9Grid = new Rectangle(fillScale9X * pxScale, 0, fill9Width * pxScale, bg.texture.frameHeight);
			fill.width = bg.width;
			fill.mask = new Quad(fill.width, fill.height);
			addChild(fill);
			addChild(bg);
			
			levelLabel = new XTextField(88*pxScale, 50*pxScale, XTextFieldStyle.ProfileBarXpLevelTextFieldStyle);
			levelLabel.y = 22*pxScale;
			//levelLabel.border = true;
			addChild(levelLabel);
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
			
			fill.mask.width = maskX +(fill.texture.frameWidth - maskX) * _value;
			moveEdge();
		}
		
		public function setValues(progress:Number, level:int):void
		{
			value = progress;
			levelLabel.text = level.toString();
		}
		
		public function animateValues(progress:Number, duration:Number=1.0, delay:Number = 0.0):void
		{
			Starling.juggler.tween(this, duration, {delay:delay, value:progress, transition:Transitions.EASE_OUT});
			
			if (!edge) {
				edge = new Image(AtlasAsset.CommonAtlas.getTexture(edgeTexture));
				edge.alignPivot();
				edge.y = (bg.height - edge.height)/2 + edge.pivotY;
				addChild(edge);
			}
			else {
				Starling.juggler.removeTweens(edge);
			}
			
			moveEdge();
			edge.alpha = 0;
			edge.scaleX = 0;
			
			var tween_0:Tween = new Tween(edge, 0.2*duration, Transitions.EASE_OUT);
			var tween_1:Tween = new Tween(edge, 0.2*duration, Transitions.LINEAR);
			
			tween_0.delay = delay;
			tween_0.animate('alpha', 1);
			tween_0.animate('scaleX', 1);
			tween_0.nextTween = tween_1;
			
			tween_1.delay = 0.55 * duration;
			tween_1.animate('alpha', 0);
			tween_1.animate('scaleX', 0);
			tween_1.onComplete = removeEdge;
			Starling.juggler.add(tween_0);
		}
		
		private function moveEdge():void {
			if (edge) {
				edge.x = fill.scale9Grid.x - edgeWidthShift + (fill.width - fill.scale9Grid.x + edgeWidthShift) * _value;
				edge.scale = Math.min(1, (fill.width - edge.x) / (edge.texture.frameHeight/4));
			}
		}
		
		private function removeEdge():void {
			if (edge) {
				edge.removeFromParent();
				edge = null;
			}
		}
	}
}