package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.resize.IResizable;
	import com.alisacasino.bingo.utils.GameManager;
	import starling.animation.Tween;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Blackout extends Sprite implements IResizable
	{
		public static const BLACKOUT_ALPHA:Number = 0.5;
		
		private var mGameManager:GameManager = GameManager.instance;
		private var mQuad:Quad;
		private var blackoutAlpha:Number;
		private var tweenTime:Number;
		
		public var ignoreTopLevel:Boolean;
		
		public function Blackout(blackoutAlpha:Number = BLACKOUT_ALPHA, tweenTime:Number = 0.3)
		{
			this.tweenTime = tweenTime;
			this.blackoutAlpha = blackoutAlpha;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onAddedToStage(e:Event):void
		{
			mQuad = new Quad(1, 1, 0x0);
			mQuad.alpha = 0;
			addChild(mQuad);
			if (tweenTime <= 0)
			{
				mQuad.alpha = blackoutAlpha;
			}
			else
			{
				Starling.juggler.tween(mQuad, tweenTime, { alpha: blackoutAlpha, onComplete:onTweenComplete});
			}
			resize();
		}
		
		private function onTweenComplete():void 
		{
			dispatchEventWith(Event.COMPLETE);
		}
		
		public function resize():void {
			mQuad.width = mGameManager.layoutHelper.stageWidth;
			mQuad.height = mGameManager.layoutHelper.stageHeight;
		}
		
		private function onEnterFrame(e:Event):void
		{
			var parentScreen:DisplayObjectContainer = parent.parent;
			var isTopLevel:Boolean = false;
			
			if (parentScreen)
				isTopLevel = parentScreen.getChildIndex(parent) == parentScreen.numChildren - 1;
			
			if (!ignoreTopLevel)
			{
				mQuad.alpha = isTopLevel ? blackoutAlpha : 0;
			}
		}
	}
}