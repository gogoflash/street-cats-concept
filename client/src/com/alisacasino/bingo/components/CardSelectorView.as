package com.alisacasino.bingo.components 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import flash.geom.Point;
	import flash.utils.setInterval;
	import starling.animation.Transitions;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.utils.TweenHelper;
	
	public class CardSelectorView extends Sprite 
	{
		public static const STATE_HIDE:String = 'STATE_HIDE';
		public static const STATE_SHOW:String = 'STATE_SHOW';
		public static const STATE_SHOW_INSTANT:String = 'STATE_SHOW_INSTANT';
		//public static const STATE_HIDE:String = 'STATE_HIDE';
		
		private var topLeft:Image;
		private var topRight:Image;
		private var bottomLeft:Image;
		private var bottomRight:Image;
		
		private var _state:String;
		private var _previousState:String;
		//private var normalPositionsList:Vector.<Number>;
		private var halfWidth:Number;
		private var halfHeight:Number;
	
		public function CardSelectorView(width:Number, height:Number, state:String = 'STATE_HIDE') 
		{
			halfWidth = width / 2;
			halfHeight = height / 2;
			
			
			topLeft = new Image(AtlasAsset.CommonAtlas.getTexture('cards/corner_selector'));
			topLeft.alignPivot();
			topLeft.x = -halfWidth;
			topLeft.y = -halfHeight;
			addChild(topLeft);
			
			topRight = new Image(AtlasAsset.CommonAtlas.getTexture('cards/corner_selector'));
			topRight.alignPivot();
			topRight.scaleX = -1;
			topRight.x = halfWidth;
			topRight.y = -halfHeight;
			addChild(topRight);
			
			bottomLeft = new Image(AtlasAsset.CommonAtlas.getTexture('cards/corner_selector'));
			bottomLeft.alignPivot();
			bottomLeft.scaleY = -1;
			bottomLeft.x = -halfWidth;
			bottomLeft.y = halfHeight;
			addChild(bottomLeft);
			
			bottomRight = new Image(AtlasAsset.CommonAtlas.getTexture('cards/corner_selector'));
			bottomRight.alignPivot();
			bottomRight.scaleY = -1;
			bottomRight.scaleX = -1;
			bottomRight.x = halfWidth;
			bottomRight.y = halfHeight;
			addChild(bottomRight);
			
			_state = state;
			_previousState = state;
			
			touchable = false;
			//setInterval(jump, 3000, 10);
			
			if (_state == STATE_HIDE)
			{
				topLeft.alpha = 0;
				topRight.alpha = 0;
				bottomLeft.alpha = 0;
				bottomRight.alpha = 0;
			}
		}
		
		public function get state():String
		{
			return _state;
		}
		
		public function set state(value:String):void 
		{
			if (_state == value)
				return;
				
			_previousState = _state;	
			_state = value;
			
			if (_state == STATE_SHOW)
			{
				//topLeft.visible = topRight.visible = bottomLeft.visible = bottomRight.visible = true;
				jumpTweenFromCenter(topLeft, -halfWidth, -halfHeight, 20, 1, 1);
				jumpTweenFromCenter(topRight, halfWidth, -halfHeight, 20, 1, 1);
				jumpTweenFromCenter(bottomLeft, -halfWidth, halfHeight, 20, 1, 1);
				jumpTweenFromCenter(bottomRight, halfWidth, halfHeight, 20, 1, 1);
			}
			else if (_state == STATE_HIDE)
			{
				//topLeft.visible = topRight.visible = bottomLeft.visible = bottomRight.visible = false;
				jumpTweenFromCenter(topLeft, -halfWidth, -halfHeight, -25, 0, 0);
				jumpTweenFromCenter(topRight, halfWidth, -halfHeight, -25, 0, 0);
				jumpTweenFromCenter(bottomLeft, -halfWidth, halfHeight, -25, 0, 0);
				jumpTweenFromCenter(bottomRight, halfWidth, halfHeight, -25, 0, 0);
			}
			else if (_state == STATE_SHOW_INSTANT)
			{
				topLeft.x = -halfWidth;
				topLeft.y = -halfHeight;
				topRight.x = halfWidth;
				topRight.y = -halfHeight;
				bottomLeft.x = -halfWidth;
				bottomLeft.y = halfHeight;
				bottomRight.x = halfWidth;
				bottomRight.y = halfHeight;
			}
		}
		
		public function jump(distance:Number):void 
		{
			jumpTweenFromCenter(topLeft, -halfWidth, -halfHeight, 10);
			jumpTweenFromCenter(topRight, halfWidth, -halfHeight, 10);
			jumpTweenFromCenter(bottomLeft, -halfWidth, halfHeight, 10);
			jumpTweenFromCenter(bottomRight, halfWidth, halfHeight, 10);
		}
		
		private function jumpTweenFromCenter(displayObject:DisplayObject, originalX:Number, originalY:Number, moveDistance:int, alphaIn:Number = 1, alphaTo:Number = 1):void
		{
			var distance:Number = Point.distance(new Point(displayObject.x, displayObject.y), new Point(0, 0));
			var sin:Number = -displayObject.y/distance;
			var cos:Number = -displayObject.x/distance;
			var newDistance:Number = distance - moveDistance * pxScale;
			
			TweenHelper.tween(displayObject, 0.15, {x:(-newDistance * cos), y:(-newDistance * sin), alpha:alphaIn, transition:Transitions.EASE_OUT}).
				chain(displayObject, 0.15, {x:originalX, y:originalY, alpha:alphaTo, transition:Transitions.EASE_OUT_BACK});
		}	
	}

}