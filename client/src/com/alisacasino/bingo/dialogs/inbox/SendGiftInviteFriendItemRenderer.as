/**
 * @author grdy
 * @since 5/31/17
 */
package com.alisacasino.bingo.dialogs.inbox
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.BaseFeathersRenderer;
	import com.alisacasino.bingo.controls.XImage;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.FacebookFriend;
	import com.alisacasino.bingo.platform.PlatformServices;

	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	import starling.animation.Transitions;

	import starling.core.Starling;

	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;

	import starling.events.TouchPhase;
	
	public class SendGiftInviteFriendItemRenderer extends BaseFeathersRenderer
	{
		public static const WIDTH:int = 372;
		public static const HEIGHT:int = 81;
		
		static public const EVENT_CHECKBOX_CHANGE:String = "EVENT_CHECKBOX_CHANGE";
		
		private var facebookFriend:FacebookFriend;

		private var bg:Sprite;
		private var bgLeft:Image;
		private var bgRight:Image;
		private var bgCenter:Image;

		private var avatarView:XImage;
		private var nameLabel:XTextField;
		private var inviteMeLabel:XTextField;
		private var checkmark:Image;
		private var infoText:String;

		private var setAvatarLoadTimeout:int;
		private var isSendGifts:Boolean;

		public function SendGiftInviteFriendItemRenderer(width:Number, height:Number, infoText:String, isSendGifts:Boolean = false)
		{
			this.infoText = infoText;
			this.isSendGifts = isSendGifts;
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
			bg = new Sprite();

			bgLeft = new Image(AtlasAsset.CommonAtlas.getTexture('dialogs/cell_lft'));
			bgCenter = new Image(AtlasAsset.CommonAtlas.getTexture('dialogs/cell_center'));
			bgCenter.tileGrid = new Rectangle();
			bgRight = new Image(AtlasAsset.CommonAtlas.getTexture('dialogs/cell_rght'));

			bgCenter.x = (bgLeft.x + bgLeft.width);
			bgCenter.width = (width - bgLeft.width - bgRight.width);
			bgRight.x = (bgCenter.x + bgCenter.width);

			bg.addChild(bgLeft);
			bg.addChild(bgCenter);
			bg.addChild(bgRight);

			inviteMeLabel = new XTextField(160 * pxScale, 30 * pxScale, XTextFieldStyle.InboxSentYouGiftStyle, infoText, 0);
			bg.addChild(inviteMeLabel);

			if (PlatformServices.isCanvas || isSendGifts) {
				var checkboxBack:Image = new Image(AtlasAsset.CommonAtlas.getTexture("controls/check_inbox/check_box"));
				checkboxBack.alignPivot();
				checkboxBack.x = bg.width * 0.89;
				checkboxBack.y = bg.height * 0.5;
				bg.addChild(checkboxBack);
			}

			addChild(bg);
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

			var nameLabelStyle:XTextFieldStyle;
			var firstName:String;
			var nameLabelBold:Boolean;
			if (facebookFriend.isFirstNameLatinChars) {
				nameLabelStyle = XTextFieldStyle.InboxPlayerNameStyle;
				firstName = (facebookFriend.firstName || '').toUpperCase();
				nameLabelBold = false;
			}
			else {
				nameLabelStyle = XTextFieldStyle.InboxPlayerNameSystemFont;
				firstName = facebookFriend.firstName || '';
				nameLabelBold = true;
			}
			
			//firstName = firstName.length > 9 ? firstName.substr(0, 8) : firstName;

			if (!avatarView)
			{
				var AVATAR_WIDTH:Number = 75 * pxScale;
				var FRAME_THICK:Number = 2 * pxScale;
				
				avatarView = new XImage(AtlasAsset.CommonAtlas.getTexture("avatars/default_square"), facebookFriend.pictureURL);
				avatarView.x = bgLeft.x + 22*pxScale;
				avatarView.y = 7 * pxScale;
				avatarView.width = avatarView.height = AVATAR_WIDTH;

                var avatarBack:Quad = new Quad(AVATAR_WIDTH + 2*FRAME_THICK, AVATAR_WIDTH + 2*FRAME_THICK);
                avatarBack.x = avatarView.x - FRAME_THICK;
                avatarBack.y = avatarView.y - FRAME_THICK;

                addChild(avatarBack);
				addChild(avatarView);

				nameLabel = new XTextField(180 * pxScale, 40 * pxScale, nameLabelStyle, firstName, 0, !facebookFriend.isFirstNameLatinChars);
				//nameLabel = new XTextField(180 * pxScale, 40 * pxScale, XTextFieldStyle.InboxPlayerNameSystemFont, firstName, 0, !facebookFriend.isFirstNameLatinChars);
				nameLabel.x = avatarView.x + avatarView.width + 10*pxScale;
				nameLabel.autoScale = true;
				nameLabel.format.bold = nameLabelBold;
				addChild(nameLabel);

				inviteMeLabel.x = nameLabel.x;
			}
			else
			{
				setAvatarImage();

				nameLabel.textStyle = nameLabelStyle;
				nameLabel.text = firstName;
				nameLabel.format.bold = nameLabelBold;
				//nameLabel.redraw();
			}

			nameLabel.y = (bg.height - nameLabel.height) / 2 - 16 * pxScale;
			inviteMeLabel.y = 20 * pxScale + inviteMeLabel.height;

			avatarView.visible = true;

			if (facebookFriend.selected && (PlatformServices.isCanvas || isSendGifts))
			{
				if (!checkmark)
				{
					checkmark = new Image(AtlasAsset.CommonAtlas.getTexture("controls/check_inbox/checkmark"));
					checkmark.alignPivot();
					checkmark.x = bg.width * 0.89;
					checkmark.y = bg.height * 0.5;
					addChild(checkmark);
				}

				checkmark.alpha = 0.0;

				checkmark.scaleY = 0.0;
				Starling.juggler.tween(checkmark, 0.3, {
					transition: Transitions.EASE_OUT_BACK,
					alpha: 1.0,
					scaleY: 1.0
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
				onClick();
			}
		}


		private function onClick():void
		{
			if (facebookFriend) {
				facebookFriend.selected = !facebookFriend.selected;
				invalidate(INVALIDATION_FLAG_DATA);
				
				dispatchEventWith(EVENT_CHECKBOX_CHANGE, true, facebookFriend.selected);
			}
		}

	}
}
