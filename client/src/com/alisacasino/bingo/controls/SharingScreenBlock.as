package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.resize.IResizable;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.utils.GameManager;
	import starling.utils.Align;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class SharingScreenBlock extends Sprite implements IResizable
	{
		private var mGameManager:GameManager = GameManager.instance;
		private var mBlackout:Blackout;
		private static var instance:SharingScreenBlock;
		private var sharingText:XTextField;
		private var skipTween:Boolean;
		
		public function SharingScreenBlock()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		public function onAddedToStage(e:Event):void
		{
			mBlackout = new Blackout(0.9, skipTween ? 0 : 0.3);
			mBlackout.addEventListener(Event.COMPLETE, mBlackout_completeHandler);
			mBlackout.ignoreTopLevel = true;
			addChild(mBlackout);
			
			sharingText = new XTextField(200 * pxScale, 100 * pxScale, XTextFieldStyle.getChateaudeGarage(20, 0xFFFFFF, Align.CENTER, Align.CENTER), "Sharing...");
			addChild(sharingText);
			sharingText.alignPivot();
			
			
			resize();
		}
		
		private function mBlackout_completeHandler(e:Event):void 
		{
			dispatchEventWith(Event.COMPLETE);
		}
		
		public function onRemovedFromStage(e:Event):void
		{
		}
		
		public function resize():void {
			mBlackout.resize();
			ResizeUtils.resize(sharingText);
			sharingText.x = mGameManager.layoutHelper.stageWidth / 2;
			sharingText.y = mGameManager.layoutHelper.stageHeight / 2;
		}
		
		private function show(frontLayer:Sprite, skipTween:Boolean):SharingScreenBlock
		{
			this.skipTween = skipTween;
			frontLayer.addChild(this);
			return this;
		}
		
		public static function show(skipTween:Boolean = false):SharingScreenBlock
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
					instance = new SharingScreenBlock().show(gameScreen.frontLayer, skipTween);
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