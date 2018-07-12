package com.alisacasino.bingo.components.effects
{
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	
	public class SquareTweenLines
	{
		public function SquareTweenLines(container:DisplayObjectContainer, x:Number, y:Number, startWidth:Number, startHeight:Number, lineThick:uint, distance:uint = 0, time:Number = 0.28, alpha:Number = 0.5) 
		{
			this.distance = distance;
			this.lineThick = lineThick;
			var color:uint = 0x000000;
			
			quadTop = new Quad(startWidth, lineThick, color);
			quadTop.alpha = alpha;
			quadTop.alignPivot();
			quadTop.x = x;
			quadTop.y = startTopY = y - startHeight / 2 - quadTop.pivotY;
			quadTop.touchable = false;
			//quadTop.blendMode = BlendMode.ADD;
			container.addChildAt(quadTop, 0);
			
			quadBottom = new Quad(startWidth, lineThick, color);
			quadBottom.alpha = alpha;
			quadBottom.alignPivot();
			quadBottom.x = x;
			quadBottom.y = startBottomY = y + startHeight / 2 + quadBottom.pivotY;
			quadBottom.touchable = false;
			//quadBottom.blendMode = BlendMode.ADD;
			container.addChildAt(quadBottom, 0);
			
			quadLeft = new Quad(lineThick, startHeight, color);
			quadLeft.alpha = alpha;
			quadLeft.alignPivot();
			quadLeft.x = startLeftX = x - startWidth / 2 - quadLeft.pivotX;
			quadLeft.y = y;
			quadLeft.touchable = false;
			//quadLeft.blendMode = BlendMode.ADD;
			container.addChildAt(quadLeft, 0);
			
			quadRight = new Quad(lineThick, startHeight, color);
			quadRight.alpha = alpha;
			quadRight.alignPivot();
			quadRight.x = startRightX = x + startWidth / 2 + quadLeft.pivotX;
			quadRight.y = y;
			quadRight.touchable = false;
			//quadRight.blendMode = BlendMode.ADD;
			container.addChildAt(quadRight, 0);
			
			Starling.juggler.tween(this, time, {value:distance, transition:Transitions.LINEAR, onComplete:dispose});
		}
		
		private var quadTop:Quad;
		private var quadBottom:Quad;
		private var quadLeft:Quad;
		private var quadRight:Quad;
		
		private var startTopY:Number;
		private var startBottomY:Number;
		private var startLeftX:Number;
		private var startRightX:Number;
		
		private var _value:Number = 0;
		
		private var distance:Number;
		private var lineThick:uint;
		
		public function get value():Number
		{
			return _value;
		}
		
		public function set value(v:Number):void
		{
			if (_value == v)
				return;
			
			_value = v;
			
			quadTop.y = startTopY - _value;
			quadBottom.y = startBottomY + _value;
			quadLeft.x = startLeftX - _value;
			quadRight.x = startRightX + _value;
			
			var size:Number = Math.max(1, lineThick - lineThick*_value / distance);
			quadTop.height = size;
			quadBottom.height = size;
			quadLeft.width = size;
			quadRight.width = size;
		}
		
		public function dispose():void
		{
			quadTop.removeFromParent();
			quadBottom.removeFromParent();
			quadLeft.removeFromParent();
			quadRight.removeFromParent();
			
			quadTop.dispose();
			quadBottom.dispose();
			quadLeft.dispose();
			quadRight.dispose();
			
			quadTop = null;
			quadBottom = null;
			quadLeft = null;
			quadRight = null;
		}
	}
}
