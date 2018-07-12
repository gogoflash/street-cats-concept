package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.utils.Constants;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Countdown extends Sprite
	{
		private var mBack:Image;
		private var mDigits:XTextField;
		private var mTimer:Timer;
		private var mValue:Number;
		private var mHasExpiresIn:Boolean;
		private var mExpiresInLabel:XTextField;
		
		public function Countdown(hasExpiresIn:Boolean=false)
		{
			mHasExpiresIn = hasExpiresIn;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			mBack = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/countdown"));
			addChild(mBack);
			if (mHasExpiresIn) {
				mExpiresInLabel = new XTextField(mBack.width * 0.65, mBack.height * 0.3, XTextFieldStyle.BuyCardsClockSmallTextFieldStyle, "Expires in");
				addChild(mExpiresInLabel);				
				mExpiresInLabel.x = mBack.width * 0.95 - mExpiresInLabel.width >> 1;
				mExpiresInLabel.y = mBack.height * 0.15;
				mDigits = new XTextField(mBack.width * 0.82, mBack.height * 0.38, XTextFieldStyle.BuyCardsClockSmallTextFieldStyle);
				addChild(mDigits);
				mDigits.x = mBack.width * 0.95 - mDigits.width >> 1;
				mDigits.y = mBack.height * 0.35;
			} else {
				mDigits = new XTextField(mBack.width * 0.8, mBack.height * 0.8, XTextFieldStyle.BuyCardsClockTextFieldStyle);
				addChild(mDigits);
				mDigits.x = mBack.width - mDigits.width >> 1;
				mDigits.y = mBack.height - mDigits.height >> 1;
			}
		}
		
		public function set value(value:int):void
		{
			mValue = value;
			setLabelValue(mValue);
			if (mTimer)
				mTimer.stop();
			mTimer = new Timer(Constants.ONE_SECOND_INTERVAL_MILLIS, value);
			mTimer.addEventListener(TimerEvent.TIMER, onTimer);
			mTimer.start();
			
			function onTimer(e:TimerEvent):void
			{
				setLabelValue(--mValue);
			}
			
			function setLabelValue(v:int):void
			{
				var hh:int = 0;
				var mm:int = 0;
				var ss:int = 0;
				var str:String = "";
				
				if (v >= 0) {
					ss = v % 60;
					mm = (v / 60) % 60;
					hh = v / 3600;
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
				
				mDigits.text = str;
				
			}
		}
	}
}