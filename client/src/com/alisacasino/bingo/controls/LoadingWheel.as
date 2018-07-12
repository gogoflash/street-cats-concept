package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.assets.loading.GAFClipWrapper;
	import com.alisacasino.bingo.resize.IResizable;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.utils.GameManager;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class LoadingWheel extends Sprite implements IResizable
	{
		private var mGameManager:GameManager = GameManager.instance;
		private var mLoadingWheelMovieClip:MovieClipAsset = MovieClipAsset.PackBase;
		private var mConvertedMovieClip:GAFClipWrapper;
		private var mBlackout:Blackout;
		private static var instance:LoadingWheel;
		
		public function LoadingWheel()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		public function onAddedToStage(e:Event):void
		{
			mBlackout = new Blackout(0.8);
			mBlackout.ignoreTopLevel = true;
			addChild(mBlackout);
			
			mConvertedMovieClip = mLoadingWheelMovieClip.getFromPool('loading_white');
			mConvertedMovieClip.loop = true;
			addChild(mConvertedMovieClip);
			
			mConvertedMovieClip.pivotX = 42 * pxScale;
			mConvertedMovieClip.pivotY = 42 * pxScale;
			mConvertedMovieClip.fps = 24;
			mConvertedMovieClip.play();
			Starling.juggler.add(mConvertedMovieClip);
			resize();
		}
		
		public function onRemovedFromStage(e:Event):void
		{
			Starling.juggler.remove(mConvertedMovieClip);
			mConvertedMovieClip.removeFromParent();
			mLoadingWheelMovieClip.putToPool(mConvertedMovieClip);
		}
		
		public function resize():void {
			mBlackout.resize();
			ResizeUtils.resize(mConvertedMovieClip);
			mConvertedMovieClip.x = mGameManager.layoutHelper.stageWidth / 2;
			mConvertedMovieClip.y = mGameManager.layoutHelper.stageHeight / 2;
		}
		
		private function show(frontLayer:Sprite):LoadingWheel
		{
			frontLayer.addChild(this);
			return this;
		}
		
		public static function show():LoadingWheel
		{
			var currentScreen:DisplayObjectContainer = Game.current.currentScreen as DisplayObjectContainer;
			if (currentScreen && currentScreen is GameScreen)
			{
				var gameScreen:GameScreen = currentScreen as GameScreen;
				if (gameScreen.frontLayer)
				{
					if (instance && instance.parent == gameScreen.frontLayer)
						return instance;
					
					removeIfAny();
					instance = new LoadingWheel().show(gameScreen.frontLayer);
					return instance;
				}
			}
			
			return null;
		}
		
		public static function removeIfAny():void
		{
			if (instance)
			{
				instance.removeFromParent();
				instance = null;
			}
		}
	}
}