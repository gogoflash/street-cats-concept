package com.alisacasino.bingo.controls
{
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class InvisibleButton extends Quad
	{
		public function InvisibleButton(width:Number, height:Number)
		{
			super(width, height, 0xffffff);
			alpha=0.0;
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			if (touch == null)
				return;
			if (touch.phase == TouchPhase.BEGAN) {
				dispatchEventWith(Event.TRIGGERED);
			}
		}
	}
}