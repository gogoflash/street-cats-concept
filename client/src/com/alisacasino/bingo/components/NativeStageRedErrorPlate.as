package com.alisacasino.bingo.components
{
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.utils.Constants;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import starling.animation.Transitions;
	import starling.core.Starling;
	
	public class NativeStageRedErrorPlate
	{
		private static var container:Sprite;
		private static var textField:TextField;
		private static var keepedText:String;
		private static var showCallsCounter:int;
		
		public function NativeStageRedErrorPlate() {
			
		}
		
		public static function show(timeToShow:int, text:String = null, replaceAndKeepTextInThisCall:Boolean = false):void
		{				
			showCallsCounter++;
			
			if (container) {
				Starling.juggler.removeTweens(container);
				container.y = 0;
				
				if (replaceAndKeepTextInThisCall) {
					keepedText = text;
				}
				
				textField.text = showCallsCounter.toString() + ', ' + keepedText;
				container.graphics.clear();
				container.graphics.beginFill(0xFF0000, 1);
				container.graphics.drawRect(0, 0, Math.max(100, Starling.current.nativeStage.stageWidth), textField.y + textField.height + 5);
				container.graphics.endFill();
				
				Starling.juggler.tween(container, 1, {delay:timeToShow, y:-container.height + 5, transition:Transitions.EASE_OUT_BACK});
				
				return;
			}

			keepedText = text;
			
			container = new Sprite();
			container.addEventListener(MouseEvent.CLICK, handler_mouseClick);
			
			if(Starling.current.nativeStage)
				Starling.current.nativeStage.addEventListener(MouseEvent.CLICK, handler_nativeStageMouseClick);
			
			/*if (PlatformServices.isMobile) {
				container.mouseEnabled = false;
				container.mouseChildren = false;
			}*/
			
			textField = new TextField();
			textField.x = 20;
			textField.y = 5;
			//textField.textColor = 0xFFFFFF;
			textField.defaultTextFormat = new TextFormat(null, 18, 0xFFFFFF);
			textField.width = Math.max(100, Starling.current.nativeStage.stageWidth) - 2 * textField.x;
			textField.wordWrap = true;
			//textField.height = 50;
			textField.autoSize = TextFieldAutoSize.LEFT;
			
			textField.text = showCallsCounter.toString() + ', ' + keepedText;
			//timerLabel.border = true;
			
			container.addChild(textField);
			
			container.graphics.beginFill(0xFF0000, 1);
			container.graphics.drawRect(0, 0, Math.max(100, Starling.current.nativeStage.stageWidth), textField.y + textField.height + 5);
			container.graphics.endFill();
			
			if (Constants.isDevFeaturesEnabled)
				Starling.current.nativeStage.addChild(container);
			
			Starling.juggler.tween(container, 1, {delay:timeToShow, y:-container.height + 5, transition:Transitions.EASE_OUT_BACK});
		}
		
		public static function prodShow(timeToShow:int):void
		{
			if (container)
				Starling.current.nativeStage.addChild(container);
		}
		
		public static function get isActivated():Boolean
		{
			return container != null;
		}
		
		public static function appear(timeToShow:int = 5):void
		{				
			if (!container)
				return;
			
			Starling.juggler.removeTweens(container);
			container.y = 0;
			
			Starling.juggler.tween(container, 1, {delay:timeToShow, y:-container.height + 5, transition:Transitions.EASE_OUT_BACK});
		}
		
		private static function handler_nativeStageMouseClick(e:MouseEvent):void 
		{
			if(container && !container.stage)
				return;
				
			if(Starling.current.nativeStage.mouseX > (Starling.current.nativeStage.stageWidth - 200) && Starling.current.nativeStage.mouseY < 120)
				appear(30);
		}
		
		private static function handler_mouseClick(e:MouseEvent):void 
		{
			appear(30);
		}
	}
}