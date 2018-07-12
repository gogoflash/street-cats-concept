package com.alisacasino.bingo.components
{
	import com.alisacasino.bingo.Game;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class FadeQuad
	{
		private static var _quad:Quad;
		
		private static var touchCallback:Function;
		
		private static var showInitTime:int;
		
		private static var touchLockTimeout:int;
		
		private static var _lastTouchPoint:Point;
		
		public function FadeQuad() {
		}
		
		public static function show(layer:DisplayObjectContainer, time:Number = 0.2, alpha:Number = 0.6, touchable:Boolean = false, touchCallback:Function = null, touchLockTimeout:int = 0):void
		{
			if (!_quad) {
				_quad = new Quad(1, 1, 0x000000);
				_quad.width = layoutHelper.stageWidth;
				_quad.height = layoutHelper.stageHeight;
				_quad.alpha = 0;
			}
			
			FadeQuad.touchCallback = touchCallback;
			FadeQuad.touchLockTimeout = touchLockTimeout;
			
			showInitTime = getTimer();
			
			if (touchable) 
				_quad.addEventListener(TouchEvent.TOUCH, handler_touch);
			else
				_quad.removeEventListener(TouchEvent.TOUCH, handler_touch);
			
			if(!Game.hasEventListener(Game.STAGE_RESIZE, stageResizeHandler))
				Game.addEventListener(Game.STAGE_RESIZE, stageResizeHandler);
			
			_quad.touchable = touchable;
			layer.addChild(_quad);
			
			Starling.juggler.removeTweens(_quad);
			
			if (time > 0) {
				Starling.juggler.tween(_quad, time, {alpha:alpha, transition:Transitions.EASE_OUT});
			}
			else {
				_quad.alpha = alpha;
			}
		}
		
		public static function hide(time:Number=0.2):void
		{
			if(Game.hasEventListener(Game.STAGE_RESIZE, stageResizeHandler))
				Game.removeEventListener(Game.STAGE_RESIZE, stageResizeHandler);
			
			if (!_quad)
				return;
			
			Starling.juggler.removeTweens(_quad);	
				
			if (time > 0) 
				Starling.juggler.tween(_quad, time, {alpha:0, transition:Transitions.EASE_OUT, onComplete:removeQuad});
			else 
				removeQuad();
		}
		
		public static function get quad():Quad
		{
			return _quad;
		}
		
		public static function get lastTouchPoint():Point
		{
			return _lastTouchPoint || new Point();
		}
		
		private static function removeQuad():void {
			if (_quad) {
				_quad.removeEventListener(TouchEvent.TOUCH, handler_touch);
				_quad.removeFromParent(true);
				_quad = null;
			}
		}
		
		private static function stageResizeHandler(e:Event):void 
		{
			if (_quad) {
				_quad.width = layoutHelper.stageWidth;
				_quad.height = layoutHelper.stageHeight;
			}
		}
		
		private static function handler_touch(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
		
			var touch:Touch = event.getTouch(_quad);
			if (touch == null)
				return;

			if ((touchLockTimeout > 0) && (getTimer() - showInitTime < touchLockTimeout))	
				return;
				
			if (touch.phase == TouchPhase.ENDED) 
			{
				trace(touch.globalX, touch.globalY);
				_lastTouchPoint = new Point(touch.globalX, touch.globalY);
				
				if (touchCallback != null) {
					touchCallback();
					touchCallback = null;
				}
			}
		}
	}
}