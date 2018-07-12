package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.models.FacebookFriend;
	import com.alisacasino.bingo.utils.RelativePixelMovingHelper;
	import com.alisacasino.bingo.utils.TruncateTextField;
	import com.alisacasino.bingo.utils.UIUtils;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	import flash.geom.Rectangle;
	import starling.animation.DelayedCall;
	import starling.animation.IAnimatable;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextFieldAutoSize;
	;
	import flash.utils.getTimer;
	
	public class InviteFriendItemRenderer extends BaseFeathersRenderer
	{
		private var facebookFriend:FacebookFriend;
		
		private var bg:Image;
		private var avatarView:XImage;
		private var nameLabel:XTextField;
		private var checkmark:Image;
		
		private var setAvatarLoadTimeout:int;
		
		public function InviteFriendItemRenderer(width:Number, height:Number)
		{
			setSizeInternal(width, height, false);
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
				
		override public function set data(value:Object):void
		{
			facebookFriend = value as FacebookFriend;
			super.data = value;
		}
				
		override protected function initialize():void
		{
			bg = new Image(AtlasAsset.CommonAtlas.getTexture('dialogs/cell'));
			addChild(bg);
			
			//addChild(new Quad(width, height, 0xFF000000));
		}
		
		override protected function draw():void
		{
			if (!isInvalid(INVALIDATION_FLAG_DATA))
				return;
			
			if (!facebookFriend) {
				if (avatarView) {
					nameLabel.text = '';
					avatarView.visible = false;
				}
				
				if (checkmark)
					checkmark.alpha = 0; 
					
				return;	
			}
			
			var firstName:String = facebookFriend.firstName || '';
			
			var nameTextStyle:XTextFieldStyle;
			var nameLabelCorrectionY:Number = 0;
			if (facebookFriend.isFirstNameLatinChars) {
				nameTextStyle = facebookFriend.selected ? XTextFieldStyle.InviteFriendItemOnTextureTextFieldStyle : XTextFieldStyle.InviteFriendItemOffTextureTextFieldStyle;
				nameLabelCorrectionY = -2;
			}
			else {
				nameTextStyle = facebookFriend.selected ? XTextFieldStyle.InviteFriendItemOnTextFieldStyle : XTextFieldStyle.InviteFriendItemOffTextFieldStyle;
				nameLabelCorrectionY = -9;
			}
			
			if (!avatarView) 
			{
				avatarView = new XImage(AtlasAsset.CommonAtlas.getTexture("avatars/"+facebookFriend.avatarIndex()), facebookFriend.pictureURL);
				avatarView.x = bg.height * 0.167;
				avatarView.y = bg.height * 0.105;
				avatarView.width = avatarView.height = bg.height * 0.64;
				addChild(avatarView);
				
				nameLabel = new XTextField(bg.width * 0.42, bg.height * 0.5, nameTextStyle, firstName, 0, !facebookFriend.isFirstNameLatinChars);
				//nameLabel.debugMode = true;
				nameLabel.format.leading = -bg.height * 0.1;
				nameLabel.x = (bg.width - nameLabel.width) / 2 + bg.width * 0.03;
				addChild(nameLabel);
			}
			else 
			{
				setAvatarImage();
				
				nameLabel.autoSizeNativeTextField = !facebookFriend.isFirstNameLatinChars;
				nameLabel.text = firstName;
				//nameLabel.appendStyle(nameTextStyle);
			}
						
			nameLabel.y = (bg.height - nameLabel.height) / 2;
			nameLabel.y += nameLabelCorrectionY * pxScale;
			
			avatarView.visible = true;
			
			if (facebookFriend.selected) 
			{
				if (!checkmark)
				{
					checkmark = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/objectives/v"));
					checkmark.pivotX = checkmark.width >> 1;
					checkmark.pivotY = checkmark.height >> 1;
					checkmark.x = bg.width * 0.854;
					checkmark.y = bg.height * 0.436;
					checkmark.scaleX = 0.36;
					addChild(checkmark);
				}
				
				checkmark.alpha = 0.0;
				
				checkmark.scaleY = 0.0;
				Starling.juggler.tween(checkmark, 0.3, {
					transition: Transitions.EASE_OUT_BACK,
					alpha: 1.0,
					scaleY: 0.36
				});
			}
			else 
			{
				if (checkmark)
				{
					Starling.juggler.tween(checkmark, 0.3, {
						transition: Transitions.EASE_OUT_BACK,
						alpha: 0.0,
						scaleY: 0.0
					});
				}
			}
			
			//RelativePixelMovingHelper.add(checkmark, bg.width, bg.height );
			//RelativePixelMovingHelper.add(nameLabel, bg.width, bg.height );
			//UIUtils.addBoundQuad(this, bounds, 0xFFFF00 * Math.random());
		}
		
		private function setAvatarImage():void {
			
			if (!avatarView || !facebookFriend || avatarView.imageURL == facebookFriend.pictureURL) {
				return;
			}
			
			if (avatarView.hasInCache(facebookFriend.pictureURL)) {
				avatarView.imageURL = facebookFriend.pictureURL;
				return;
			}	
			
			if ((getTimer() - setAvatarLoadTimeout) >= 500) {
				avatarView.imageURL = facebookFriend.pictureURL;
				Starling.juggler.delayCall(setAvatarImage, 0.51);
				setAvatarLoadTimeout = getTimer();
				return;
			}
			else {
				avatarView.imageURL = null;
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
				//dispatchEventWith(Event.TRIGGERED);
				onClick();
			}
		}
		
		
		private function onClick():void
		{
			if (facebookFriend) {
				facebookFriend.selected = !facebookFriend.selected;
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
	}
	
}