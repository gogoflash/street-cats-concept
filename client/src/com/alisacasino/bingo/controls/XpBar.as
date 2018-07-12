package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.components.MultiCharsLabel;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.screens.profileScreenClasses.ProfileScreen;
	import flash.utils.setInterval;
	import starling.animation.Transitions;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Align;
	
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class XpBar extends Sprite
	{
		private var bg:Image;
		private var progressImage:Image;
		private var xpLevelLabel:XTextField;
		private var userNameLabel:MultiCharsLabel;
		private var mNumValue:uint;
		
		private var userNameButton:XButton;
		
		private var onTriggeredCallback:Function;
		
		public function XpBar(showUsername:Boolean = true, onTriggeredCallback:Function = null)
		{
			this.onTriggeredCallback = onTriggeredCallback;
			
			bg = new Image(AtlasAsset.CommonAtlas.getTexture("bars/score_progress"));
			bg.scale9Grid = new Rectangle(89 * pxScale, 0, 1 * pxScale, bg.texture.frameHeight);
			bg.width = 354* pxScale;
			
			progressImage = new Image(AtlasAsset.CommonAtlas.getTexture("bars/score_progress_fill"));
			progressImage.scale9Grid = new Rectangle(79 * pxScale, 0, 1 * pxScale, bg.texture.frameHeight);
			progressImage.width = bg.width;
			progressImage.mask = new Quad(progressImage.width, progressImage.height);
			addChild(progressImage);
			addChild(bg);
			
			xpLevelLabel = new XTextField(88*pxScale, 50*pxScale, XTextFieldStyle.ProfileBarXpLevelTextFieldStyle);
			xpLevelLabel.y = 22*pxScale;
			//xpLevelLabel.border = true;
			addChild(xpLevelLabel);
			
			if (showUsername)
			{
				userNameLabel = new MultiCharsLabel(XTextFieldStyle.ResourceBarTextFieldStyle, 265 * pxScale, 30 * pxScale, Player.current ? Player.current.firstName : 'no user', true);
				userNameLabel.textField.y = 7 * pxScale;
				//userNameLabel.debugTest(false);
				addChild(userNameLabel.textField);
				
				if (Game.current && Game.current.hasUncaughtError) 
					highlightPlayerName(0xFEDE04);
				
				if (gameManager.deactivated)
					Game.addEventListener(Game.ACTIVATED, handler_gameActivated);
			}
			
			useHandCursor = true;
			addEventListener(TouchEvent.TOUCH, handler_touch);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			resize();
		}
		
		public function onAddedToStage(e:Event):void
		{
			if (Player.current)
			{
				numValue = Player.current.xpCount;
			}
			//trace('CURRENT XP', Player.current.xpCount);
		}
		
		private function handler_gameActivated(e:Event):void 
		{
			Game.removeEventListener(Game.ACTIVATED, handler_gameActivated);
			resize();
		}	
		
		public function get numValue():Number
		{
			return mNumValue;
		}
		
		public function set numValue(value:Number):void
		{
			mNumValue = value;
			
			var xpLevel:uint = gameManager.gameData.getLevelForXp(value);
			xpLevelLabel.numValue = xpLevel;
			
			var ratio:Number = 1.0; 
			
			if (xpLevel < gameManager.gameData.maxLevel) {
				var xpCountThisLevel:uint = gameManager.gameData.getXpCountForLevel(xpLevel);
				var xpCountNextLevel:uint = gameManager.gameData.getXpCountForLevel(xpLevel + 1);
				ratio = (value - xpCountThisLevel) / (xpCountNextLevel - xpCountThisLevel);
				//mXpCountLabel.text = String(value - xpCountThisLevel) + " / " + String(xpCountNextLevel - xpCountThisLevel); 
			} else {
				//mXpCountLabel.text = "Max level";
			}
		
			var maskStartX:uint = 24* pxScale;
			if(progressImage.mask)
				progressImage.mask.width = maskStartX +(progressImage.texture.frameWidth - maskStartX ) * ratio;
		}
		
		public function animateToValue(value:uint, duration:Number=1.0, delay:Number = 0.0):void
		{
			Starling.juggler.tween(this, duration, {delay: delay, numValue: value, transition:Transitions.EASE_OUT});
		}

		public function getImageRect(targetSpace:DisplayObject):Rectangle
		{
			return getBounds(targetSpace);
		}
		
		public function highlightPlayerName(color:uint):void
		{
			if (userNameLabel)
				userNameLabel.textField.format.color = color;
		}
			
		private function resize():void 
		{
			if (gameManager.deactivated)
				return;
			
			if(userNameLabel)
				userNameLabel.textField.x = 90*pxScale - userNameLabel.textField.textBounds.x;
		}
		
		override public function dispose():void {
			Game.removeEventListener(Game.ACTIVATED, handler_gameActivated);
			super.dispose();
		}
		
		private var mDownX:Number;
		private var mIsDown:Boolean = false;
		private static const MAX_DRAG_DIST:Number = 5;
		private function handler_touch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			if (touch == null) {
				return;
			}
			if (touch.phase == TouchPhase.BEGAN && !mIsDown) {
				mIsDown = true;
				mDownX = touch.globalX;
			} else if (touch.phase == TouchPhase.MOVED && mIsDown) {
				var buttonRect:Rectangle = getBounds(stage);
				if (touch.globalX < mDownX - MAX_DRAG_DIST ||
					touch.globalY < buttonRect.y - MAX_DRAG_DIST || 
					touch.globalX > mDownX + MAX_DRAG_DIST ||
					touch.globalY > buttonRect.y + buttonRect.height + MAX_DRAG_DIST)
				{
					mIsDown = false;
				}
			} 
			else if (touch.phase == TouchPhase.ENDED && mIsDown) 
			{
				mIsDown = false;
				
				if (onTriggeredCallback != null)
					onTriggeredCallback();
			}
		}
		
	}
}