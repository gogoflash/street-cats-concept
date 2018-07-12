package com.alisacasino.bingo.dialogs.scratchCard.messageContainerClasses 
{
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.utils.Constants;
	import feathers.core.FeathersControl;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.Align;
	;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class TutorialMessage extends FeathersControl
	{
		
		private var label:XTextField;
		private var tween:Tween;
		
		public function TutorialMessage() 
		{
			
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			label = new XTextField(100, 100, XTextFieldStyle.getWalrus(50).addStroke(1, 0x0), "");
			label.autoScale = false;
			label.format.verticalAlign = Align.CENTER;
			addChild(label);
			
			addAlphaTween();
		}
		
		private function addAlphaTween():void 
		{
			if (!label)
				return;
			
			label.text = "SCRATCH & MATCH 3\nTO WIN";
			label.alpha = 0.2;
			
			if (tween)
			{
				Starling.juggler.remove(tween);
			}
			tween = new Tween(label, 0.4, Transitions.EASE_IN_OUT);
			tween.animate("alpha", 1);
			tween.repeatCount = 0;
			tween.reverse = true;
			Starling.juggler.add(tween);
		}
		
		override protected function feathersControl_removedFromStageHandler(event:Event):void 
		{
			super.feathersControl_removedFromStageHandler(event);
			
			if (tween)
				Starling.juggler.remove(tween);
		}
		
		override protected function feathersControl_addedToStageHandler(event:Event):void 
		{
			super.feathersControl_addedToStageHandler(event);
			addAlphaTween();
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_SIZE))
			{
				label.width = actualWidth;
				label.height = actualHeight;
			}
		}
		
	}

}