/**
 * @author grdy
 * @since 5/31/17
 */
package com.alisacasino.bingo.dialogs.inbox
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.components.FixedSizeSprite;
	import com.alisacasino.bingo.controls.BaseFeathersRenderer;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XImage;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.FacebookFriend;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.gifts.IncomingGiftData;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.utils.FriendsManager;
	
	import flash.geom.Rectangle;
	
	import flash.utils.getTimer;
	
	import starling.core.Starling;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class InboxItemRenderer extends BaseFeathersRenderer
	{
        public static const WIDTH:int = 756;
		public static const HEIGHT:int = 81;

        static public const ROW_ACCEPT_TRIGGER:String = "rowAcceptTrigger";
		static public const ROW_ACCEPT_COMPLETE:String = "rowAcceptComplete";
		static public const ROW_CANCEL_TRIGGER:String = "rowCancelTrigger";

		private var giftData:IncomingGiftData;
		
		private var bg:Sprite;
		private var bgLeft:Image;
		private var bgRight:Image;
		private var bgCenter:Image;
		
		private var trashBtn:XButton;
		private var cashImage:Image;
		private var avatarView:XImage;
		private var nameLabel:XTextField;
		private var sentYouGiftLabel:XTextField;
		private var cashAmount:XTextField;
		private var acceptBtn:XButton;
		
		private var setAvatarLoadTimeout:int;
		
		public function InboxItemRenderer(width:Number, height:Number)
		{
			setSizeInternal(width, height, false);
		}
		
		override public function set data(value:Object):void
		{
			giftData = value as IncomingGiftData;
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
			
			trashBtn = new XButton(XButtonStyle.InboxTrash);
			
			var trashTouchQuad:Quad = new Quad(74*pxScale, 74*pxScale, 0xFF0000);
			trashTouchQuad.alpha = 0.0;
			trashTouchQuad.x = -((74-35)/2) * pxScale;
			trashTouchQuad.y = -((74-40)/2) * pxScale;
			trashBtn.addChild(trashTouchQuad)
			
			trashBtn.addEventListener(Event.TRIGGERED, cancelButton_triggeredHandler);
			trashBtn.alignPivot();
			trashBtn.x = bgLeft.x + bgLeft.width + 10*pxScale;
			trashBtn.y = bgLeft.height / 2 - 4*pxScale;
			bg.addChild(trashBtn);
			
			var AVATAR_WIDTH:Number = 75 * pxScale;
			var FRAME_THICK:Number = 2 * pxScale;
				
			avatarView = new XImage(AtlasAsset.CommonAtlas.getTexture('avatars/default_square'));
			avatarView.x = (bgLeft.x + bgLeft.width + 43*pxScale);
			avatarView.y = 7 * pxScale;
			avatarView.width = avatarView.height = AVATAR_WIDTH;

			var avatarBack:Quad = new Quad(AVATAR_WIDTH + 2*FRAME_THICK, AVATAR_WIDTH + 2*FRAME_THICK);
			avatarBack.x = avatarView.x - FRAME_THICK;
			avatarBack.y = avatarView.y - FRAME_THICK;

            bg.addChild(avatarBack);
			bg.addChild(avatarView);

			nameLabel = new XTextField(283 * pxScale, 40 * pxScale, XTextFieldStyle.InboxPlayerNameStyle);
			//nameLabel.border = true;
			nameLabel.autoScale = true;
			nameLabel.x = avatarBack.x + avatarBack.width + 13 * pxScale;
			nameLabel.y = 10 * pxScale;
			
			sentYouGiftLabel = new XTextField(245, 20 * pxScale, XTextFieldStyle.InboxSentYouGiftStyle, 'HI, I SENT YOU A GIFT', 0);
			sentYouGiftLabel.x = nameLabel.x;
			sentYouGiftLabel.y = 55 * pxScale;
			bg.addChild(sentYouGiftLabel);
			
			cashImage = new Image(AtlasAsset.CommonAtlas.getTexture('bars/cash'));
			cashImage.scale = 0.71;
			cashImage.alignPivot();
			cashImage.x = WIDTH*pxScale - 287 * pxScale;
			cashImage.y = bgLeft.height / 2 - 2 * pxScale;
			bg.addChild(cashImage);
			
			bg.addChild(nameLabel);
			
			cashAmount = new XTextField(60 * pxScale, 50 * pxScale, XTextFieldStyle.InboxPrizeAmount);
			//cashAmount.border = true;
			cashAmount.alignPivot();
			cashAmount.y = cashImage.y;
			bg.addChild(cashAmount);
			
			acceptBtn = new XButton(XButtonStyle.InboxGreenButton, 'ACCEPT');
			acceptBtn.addEventListener(Event.TRIGGERED, button_triggeredHandler);
			acceptBtn.alignPivot();
			acceptBtn.x = WIDTH * pxScale - acceptBtn.width + acceptBtn.pivotX - 13 * pxScale;
			acceptBtn.y = bgLeft.height / 2 - 2 * pxScale;
			bg.addChild(acceptBtn);
			
			addChild(bg);
		}

		override protected function draw():void
		{
			super.draw();
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				if (data)
				{
					var senderID:String = data.senderID;

					avatarView.defaultTexture = AtlasAsset.CommonAtlas.getTexture("avatars/default_square");
					avatarView.imageURL = Player.getAvatarURL("", senderID);

					var nameLabelStyle:XTextFieldStyle;
					var firstName:String;
					var nameLabelBold:Boolean;
					if (giftData.isFirstNameLatinChars) {
						nameLabelStyle = XTextFieldStyle.InboxPlayerNameStyle;
						firstName = (giftData.senderFirstName || '').toUpperCase();
						nameLabelBold = false;
					}
					else {
						nameLabelStyle = XTextFieldStyle.InboxPlayerNameSystemFont;
						firstName = giftData.senderFirstName || '';
						nameLabelBold = true;
					}
					
					/*var name:String = data.senderFirstName;
					var latinMatch:Array = name.match(/[a-zA-Z0-9-\s]+/);
					if(!latinMatch || latinMatch.length <= 0)
					{
						name = "Your friend";
					}*/

                    //name.length > 10 ? name.substr(0, 9) : name;

					nameLabel.textStyle = nameLabelStyle;
					nameLabel.text = firstName; //name.toUpperCase();
					nameLabel.format.bold = nameLabelBold;
					
					cashAmount.text = giftData.cashBonus.toString();
					cashAmount.alignPivot();
					cashAmount.x = cashImage.x + cashImage.width + (giftData.cashBonus < 10 ? 1 : 5) * pxScale;
				}
				else
				{
					
				}
			}
		}
		
		private function cancelButton_triggeredHandler(e:Event):void
		{
			dispatchEventWith(ROW_CANCEL_TRIGGER, true, this);
		}

		private function button_triggeredHandler(e:Event):void
		{
			dispatchEventWith(ROW_ACCEPT_TRIGGER, true, this);
		}
	}
}
