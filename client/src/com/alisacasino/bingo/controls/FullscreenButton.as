package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAUIInteractionEvent;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class FullscreenButton extends XButton
	{
		public function FullscreenButton()
		{
			super(XButtonStyle.FullScreenButtonStyle);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage():void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removeEventListener(TouchEvent.TOUCH, onTouch);
			removeEventListener(Event.TRIGGERED, onTriggered);
		}
		
		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(TouchEvent.TOUCH, onTouch);
			addEventListener(Event.TRIGGERED, onTriggered);
			updateState();
		}
		
		private function updateState():void
		{
			if (Starling.current.nativeStage.displayState == StageDisplayState.FULL_SCREEN || Starling.current.nativeStage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)
			{
				upState = AtlasAsset.CommonAtlas.getTexture("side_menu/full_screen_icon_exit");
			}
			else
			{
				upState = AtlasAsset.CommonAtlas.getTexture("side_menu/full_screen_icon");
			}
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if (touch && touch.phase == TouchPhase.BEGAN)
			{
				Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				
				function onMouseUp(e:MouseEvent):void
				{
					Starling.current.nativeStage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					
					var boundsRect:Rectangle = getBounds(Starling.current.stage);
					// when the button is pressed, it gets smaller, so we increase bounds using a factor
					var deltaFactor:Number = 1 - scaleWhenDown;
					var deltaX:Number = boundsRect.width * deltaFactor;
					var deltaY:Number = boundsRect.height * deltaFactor;
					if (e.stageX >= boundsRect.left - deltaX && e.stageX <= boundsRect.right + deltaX && e.stageY >= +boundsRect.top - deltaY && e.stageY <= boundsRect.bottom + deltaY)
					{
						toggleFullScreen();
					}
				}
			}
		}
		
		private function toggleFullScreen():void
		{
			if (Starling.current.nativeStage.displayState == StageDisplayState.NORMAL)
			{
				Starling.current.nativeStage.displayState = StageDisplayState.FULL_SCREEN;
			}
			else
			{
				Starling.current.nativeStage.displayState = StageDisplayState.NORMAL;
			}
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAUIInteractionEvent(DDNAUIInteractionEvent.ACTION_TRIGGERED, DDNAUIInteractionEvent.LOCATION_SIDE_MENU, "fullscreenButton", DDNAUIInteractionEvent.TYPE_BUTTON));
			updateState();
		}
		
		/* зачем нужно обрабатывать это событие: если у кнопки downState будет отличаться по размерам (ширина, высота) от upState,
		   втч если downState не передавать - тогда после нажатия на кнопку, ее размеры могут рассчитываться неверно.
		   Так как событие onResize м возникнуть до отжатия кнопки.
		   В таком случае ее размеры будут соответствовать downState, и рассчет при onResize будет выполняться исходя из downState,
		   а этот downState скоро заменится на upState а нового onResize не будет.
		
		   Этот медот делает так чтобы новый onResize был.
		 */
		private function onTriggered():void
		{
			dispatchEventWith(starling.events.Event.RESIZE, true);
		}
	}
}