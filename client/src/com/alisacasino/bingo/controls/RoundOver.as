package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.utils.GameManager;
	
	import flash.utils.setTimeout;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class RoundOver extends Sprite
	{
		private var mGameManager:GameManager = GameManager.instance;
		private var mGameAtlas:AtlasAsset = AtlasAsset.CommonAtlas;
		private var mRoundOver:Image;
		
		private static const ROUND_OVER_DURATION_SECS:Number = 1.0;
		
		public function RoundOver()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			addChild(new Blackout());
			
			mRoundOver = new Image(mGameAtlas.getTexture("titles/round_over"));
			addChild(mRoundOver);
			mRoundOver.pivotX = mRoundOver.width >> 1;
			mRoundOver.pivotY = mRoundOver.height >> 1;
			mRoundOver.x = mGameManager.layoutHelper.stageWidth >> 1;
			mRoundOver.y = mGameManager.layoutHelper.stageHeight >> 1;
			mRoundOver.alpha = 0;
			mRoundOver.scaleX = mRoundOver.scaleY = 0;
			Starling.juggler.tween(mRoundOver, 0.3, {
				transition: Transitions.EASE_OUT_BACK,
				scaleX: mGameManager.layoutHelper.scaleFromEtalonMin,
				scaleY: mGameManager.layoutHelper.scaleFromEtalonMin,
				alpha: 1.0
			});
			
			setTimeout(removeFromParent, ROUND_OVER_DURATION_SECS * 1000); 
		}
		
		public function show():void
		{
			var currentScreen:DisplayObjectContainer = Game.current.currentScreen as DisplayObjectContainer;
			currentScreen.addChild(this);
		}
		
	}
}