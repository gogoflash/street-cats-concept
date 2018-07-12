package com.alisacasino.bingo.dialogs.cardBuy 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.utils.Constants;
	import feathers.core.FeathersControl;
	import starling.display.Image;
	import starling.events.Event;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class WaitDisplay extends FeathersControl
	{
		
		private var _text:String;
		
		public function get text():String 
		{
			return _text;
		}
		
		public function set text(value:String):void 
		{
			if (_text != value)
			{
				_text = value;
				invalidate();
			}
		}
		
		private var background:Image;
		private var label:XTextField;
		
		private var bingosLeftLabel:XTextField;
		private var startTimestamp:Number = -1;
		private var bingosLeftNumberLabel:XTextField;
		
		public function WaitDisplay() 
		{
			
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			background = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/countdown"));
			addChild(background);
			
			width = background.width;
			height = background.height;
			
			label = new XTextField(width * 0.7, height * 0.7, XTextFieldStyle.BuyCardsClockTextFieldStyle);
			label.format.leading = -8 * pxScale;
			addChild(label);
			label.x = (width - label.width) / 2;
			label.y = (height - label.height) / 2 - 2 * pxScale;
			
			bingosLeftNumberLabel = new XTextField(width * 0.7, height * 0.7, XTextFieldStyle.BuyCardsClockTextFieldStyle);
			addChild(bingosLeftNumberLabel);
			bingosLeftNumberLabel.x = (width - bingosLeftNumberLabel.width) / 2;
			bingosLeftNumberLabel.y = (height - bingosLeftNumberLabel.height) / 2 - 14 * pxScale;
			bingosLeftNumberLabel.visible = false;
			
			bingosLeftLabel = new XTextField(width * 0.7, height * 0.3, XTextFieldStyle.BuyCardsClockTextFieldStyle);
			addChild(bingosLeftLabel);
			bingosLeftLabel.x = (width - bingosLeftLabel.width) / 2;
			bingosLeftLabel.y = (height - bingosLeftLabel.height) - 20 * pxScale;
			bingosLeftLabel.visible = false;
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			updateCountdown();
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			updateCountdown();
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			var hasText:Boolean = text && text.length;
			label.visible = hasText;
			if (hasText)
				label.text = text;
		}
		
		public function setTime(time:int):void
		{
			
			setBingoLeftLabelsVisible(false);
			
			var hh:int = 0;
			var mm:int = 0;
			var ss:int = 0;
			var str:String = "";
			
			if (time >= 0) {
				ss = time % 60;
				mm = (time / 60) % 60;
				hh = time / 3600;
			}
			if (hh >= 10)
				str = hh + ":";
			else if (hh > 0)
				str = "0" + hh + ":";
			if (mm >= 10)
				str += mm + ":";
			else if (mm > 0)
				str += "0" + mm + ":";
			else if (mm == 0 && hh > 0)
				str += "00:";
			else
				str = ":";
			
			if (ss >= 10)
				str += String(ss);
			else
				str += "0" + ss;
			
			text = str;
		}
		
		public function setText(value:String):void 
		{
			setBingoLeftLabelsVisible(false);
			label.text = value;
		}
		
		public function resetTimer():void 
		{
			startTimestamp = -1;
		}
		
		private function updateCountdown():void 
		{
			var mRoom:Room = Room.current;
			
			if (!mRoom || !visible)
			{
				return;
			}
			
			if (mRoom.hasRoundStartsIn)
			{
				if (startTimestamp <= 0)
				{
					startTimestamp = mRoom.roundStartsIn * 1000 + mRoom.lastUpdatedTimestamp;
				}
				
				setTime(Math.max((startTimestamp - Game.connectionManager.currentServerTime)  / 1000 , 0 ));
			}
			else if (mRoom.isRoundRunning)
			{
				startTimestamp = -1;
				
				setBingoLeftLabelsVisible(true);
				
				bingosLeftNumberLabel.text = mRoom.bingosLeft > 0 ? mRoom.bingosLeft.toString() : "1";
				bingosLeftLabel.text = mRoom.bingosLeft != 1 ? "bingos" : "bingo";
			}
			else
			{
				startTimestamp = -1;
				
				setText("Waiting\nfor players");
			}
		}
		
		private function setBingoLeftLabelsVisible(value:Boolean):void 
		{
			label.visible = !value;
			bingosLeftNumberLabel.visible = value;
			bingosLeftLabel.visible = value;
		}
		
	}

}