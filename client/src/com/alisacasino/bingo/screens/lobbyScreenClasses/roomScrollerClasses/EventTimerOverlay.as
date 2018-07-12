package com.alisacasino.bingo.screens.lobbyScreenClasses.roomScrollerClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.roomClasses.EventInfo;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.utils.TimeService;
	import feathers.core.FeathersControl;
	import flash.geom.Rectangle;
	import flash.globalization.DateTimeFormatter;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class EventTimerOverlay extends FeathersControl
	{
		
		private var _event:EventInfo;
		
		public function get event():EventInfo 
		{
			return _event;
		}
		
		public function set event(value:EventInfo):void 
		{
			if (_event != value)
			{
				_event = value;
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		private var textLabel:XTextField;
		private var timeLabel:XTextField;
		private var formatter:DateTimeFormatter;
		
		public function EventTimerOverlay() 
		{
			formatter = new DateTimeFormatter("en_US");
			formatter.setDateTimePattern("HH:mm:ss");
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			var background:Image = new Image(AtlasAsset.CommonAtlas.getTexture("black_rounded_background"));
			background.scale9Grid = ResizeUtils.scaleRect(new Rectangle(12, 12, 5, 4));
			
			background.alpha = 0.7;
			background.x = 56 * pxScale;
			background.width = 390 * pxScale - background.x * 2;
			
			background.y = 190 * pxScale;
			background.height = 55 * pxScale;
			addChild(background);
			
			textLabel = new XTextField(110 * pxScale, 54 * pxScale, XTextFieldStyle.White70R, "");
			textLabel.x = background.x + 10 * pxScale;
			textLabel.y = background.y;
			addChild(textLabel);
			
			timeLabel = new XTextField(150 * pxScale, 54 * pxScale, XTextFieldStyle.White40L, "");
			timeLabel.autoScale = false;
			timeLabel.x = background.x + 124 * pxScale;
			timeLabel.y = background.y;
			addChild(timeLabel);
			
			updateTimer();
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			updateTimer();
		}
		
		private function updateTimer():void
		{
			if (event)
			{
				
				var timeLeft:Number;
				
				switch(event.eventState)
				{
					case EventInfo.EVENT_STATE_PREVIEW:
						textLabel.text = "Starts in:";
						timeLabel.textStyle = XTextFieldStyle.Green40L;
						timeLeft = event.startTime - TimeService.serverTimeMs;
						break;
					case EventInfo.EVENT_STATE_ACTIVE:
						textLabel.text = "Ends in:";
						if (event.timeToEnd > 60 * 60 * 1000)
						{
							timeLabel.textStyle = XTextFieldStyle.Yellow40L;
						}
						else 
						{
							timeLabel.textStyle = XTextFieldStyle.Red40L;
						}
						timeLeft = event.endTime - TimeService.serverTimeMs;
						break;
					case EventInfo.EVENT_STATE_ENDED:
						textLabel.text = "Back in:";
						timeLabel.textStyle = XTextFieldStyle.White40L;
						timeLeft = event.removeTime - TimeService.serverTimeMs;
						break;
				}
				
				timeLabel.autoScale = false;
				
				timeLabel.text = formatter.formatUTC(new Date(timeLeft));
			}
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				commitData();
			}
		}
		
		private function commitData():void 
		{
			if (event)
			{
				addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
			else
			{
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
		
	}

}