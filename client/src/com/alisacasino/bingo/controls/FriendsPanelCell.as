package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.models.FacebookFriend;
	
	import flash.geom.Rectangle;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class FriendsPanelCell extends Sprite
	{
		public static const EMPTY:uint = 1;
		public static const ON:uint = 2;
		public static const OFF:uint = 3;
		
		private var mFriend:FacebookFriend;
		
		private var mBack:Image;
		private var mAvatar:XImage;
		private var mNameLabel:XTextField;
		private var mCheckmark:Image;
		
		public function FriendsPanelCell(friend:FacebookFriend)
		{
			mFriend = friend;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.TRIGGERED, friendCellTriggered);
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onAddedToStage(e:Event):void
		{
			if(mode == OFF) {
				mBack = new Image(AtlasAsset.CommonAtlas.getTexture("invite/fr_off"));
			} else if (mode == ON) {
				mBack = new Image(AtlasAsset.CommonAtlas.getTexture("invite/fr_on"));
			} else {
				mBack = new Image(AtlasAsset.CommonAtlas.getTexture("invite/fr_empty"));
			}
			addChild(mBack);
			
			mBack.x = mBack.width * 0.03;
			mBack.y = mBack.height * 0.1;
			
			if(mode != EMPTY) {
				mAvatar = new XImage(AtlasAsset.CommonAtlas.getTexture("avatars/"+mFriend.avatarIndex()), mFriend.pictureURL);
				mAvatar.x = mBack.height * 0.167;
				mAvatar.y = mBack.height * 0.192;
				mAvatar.width = mBack.height * 0.782;
				mAvatar.height = mBack.height * 0.782;
				addChild(mAvatar);
				if(mode == ON)
					mNameLabel = new XTextField(mBack.width * 0.6, mBack.height * 0.8, XTextFieldStyle.InviteFriendItemOnTextFieldStyle);
				else
					mNameLabel = new XTextField(mBack.width * 0.6, mBack.height * 0.8, XTextFieldStyle.InviteFriendItemOffTextFieldStyle);
				mNameLabel.x = mBack.width * 0.4;
				mNameLabel.y = mBack.height * 0.2;
				mNameLabel.text = mFriend.firstName;
				addChild(mNameLabel);
			}
			
			if(mode == ON) {
				mCheckmark = new Image(AtlasAsset.CommonAtlas.getTexture("invite/check"));
				mCheckmark.pivotX = mCheckmark.width >> 1;
				mCheckmark.pivotY = mCheckmark.height >> 1;
				mCheckmark.x = mBack.width * 0.33;
				mCheckmark.y = mBack.height * 0.89;
				addChild(mCheckmark);
				
				mCheckmark.alpha = 0.0;
				mCheckmark.scaleY = 0.0;
				Starling.juggler.tween(mCheckmark, 0.3, {
					transition: Transitions.EASE_OUT_BACK,
					alpha: 1.0,
					scaleY: 1.0
				});
			}
		}
		
		private function redraw():void
		{
			removeChildren(0, -1, true);
			onAddedToStage(null);
		}
		
		private function friendCellTriggered(e:Event):void
		{
			if(mode == FriendsPanelCell.ON) {
				mFriend.selected = false;
				redraw();
			} else if(mode == FriendsPanelCell.OFF) {
				mFriend.selected = true;
				redraw();
			}
		}
		
		private function get mode():uint
		{
			if(mFriend == null) {
				return EMPTY;
			} else if(mFriend.selected) {
				return ON;
			} else {
				return OFF;
			}
		}
		
		private var mDownX:Number;
		private var mIsDown:Boolean = false;
		private static const MAX_DRAG_DIST:Number = 5;
		private function onTouch(event:TouchEvent):void
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
			} else if (touch.phase == TouchPhase.ENDED && mIsDown) {
				mIsDown = false;
				dispatchEventWith(Event.TRIGGERED);
			}
		}
	}
}
