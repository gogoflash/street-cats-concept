package com.alisacasino.bingo.dialogs
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.controls.FriendsPanel;
	import com.alisacasino.bingo.controls.Scale9ProgressBar;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.inbox.SendGiftInviteFriendItemRenderer;
	import com.alisacasino.bingo.models.FacebookFriend;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.gifts.GiftsModel;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.FacebookData;
	import com.alisacasino.bingo.utils.FriendsManager;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.Settings;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import feathers.controls.Button;
	import feathers.controls.IScrollBar;
	import feathers.controls.SimpleScrollBar;
	import feathers.layout.TiledRowsLayout;
	import com.alisacasino.bingo.controls.InviteFriendItemRenderer;
	import feathers.controls.List;
	import feathers.controls.Scroller;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.core.Starling;
	import com.alisacasino.bingo.utils.FeathersUtils;
	import starling.text.TextFieldAutoSize;
	import starling.utils.Align;

	public class SendGiftsDialog extends BaseDialog
	{
		private var friendsManager:FriendsManager = FriendsManager.instance;
		
		private var list:List;
		private var listLayout:TiledRowsLayout;
		
		private var mFriendsEligibleForGift:Vector.<FacebookFriend>;
		private var progress:Scale9ProgressBar;
		private var progressBarTextField:XTextField;
		
		private var hintTextField:XTextField;
		private var hintAwardIcon:Image;
		
		private var selectAllButton:Button;
		private var selectAllLabel:XTextField;
		private var mShouldSelectAll:Boolean;
		
		private var isFirstShow:Boolean = true;
		
		private var allFriendsSelected:Boolean;
		private var friendsCollection:ListCollection;
		
		public function SendGiftsDialog()
		{
			super(DialogProperties.SEND_GIFTS);
			
			bottomButtonRelativeY = 0.926;
		}

		override protected function initialize():void
		{
			super.initialize();
			
			addBackImage(0.27, 0.56, 0.18);
			
			progress = new Scale9ProgressBar(
				AtlasAsset.CommonAtlas.getTexture('invite/progress_frame'),  new Rectangle(25 * pxScale, 0,  1 * pxScale, 0),
				AtlasAsset.CommonAtlas.getTexture('invite/progress_bar_green'), new Rectangle(13 * pxScale, 0,  1 * pxScale, 0), 
				backImageWidth + 12*pxScale, 9 * pxScale, 8 * pxScale, 8 * pxScale, true);
				
			addChild(progress);
			addToFadeList(progress);
			
			progressBarTextField = new XTextField(backgroundWidth, 45 * pxScale, XTextFieldStyle.InviteOutOfStyle);
			progressBarTextField.helperFormat.nativeTextExtraWidth = 9; 
			progressBarTextField.batchable = true;
			addChild(progressBarTextField);
			addToFadeList(progressBarTextField);
			
			initVerticalList();

			allFriendsSelected = Settings.instance.preselectAll;
			friendsManager.selectOrDeselectAllPlayersAvailableForGift(allFriendsSelected);

			var selectAllContent:Sprite = new Sprite();
			var selectAllTouchZoneQuad:Quad = new Quad(240 * pxScale, 95 * pxScale);
			selectAllTouchZoneQuad.alpha = 0;
			selectAllContent.addChild(selectAllTouchZoneQuad);
			
			selectAllLabel = new XTextField(180 * pxScale, 95 * pxScale, XTextFieldStyle.getWalrus(24, 0xa6a5a4, Align.LEFT), allFriendsSelected ? Constants.SELECT_NONE : Constants.SELECT_ALL);
			selectAllLabel.batchable = true;
			selectAllLabel.format.underline = true;
			selectAllLabel.x = 30*pxScale;
			
			selectAllContent.addChild(selectAllLabel);
			
			selectAllButton = new Button();
			selectAllButton.scaleWhenDown = 0.93;
			selectAllButton.useHandCursor = true;
			selectAllButton.defaultSkin = selectAllContent;
			selectAllButton.validate();
			selectAllButton.alignPivot();
			
			selectAllButton.addEventListener(Event.TRIGGERED, handler_selectAll);
			addChild(selectAllButton);
			addToFadeList(selectAllButton);
			
			refresh();
		}
		
		override public function resize():void 
		{
			super.resize();
			
			var topViewsTopGap:int = 22 * pxScale;
			var progressTextfieldY:int = 66 * pxScale;
			var progressY:int = 110 * pxScale;
			var topViewsBottomGap:int = 5 * pxScale;
			
			var listBackgroundTopGap:int = 0//12 * pxScale;
			var listBackgroundBottomGap:int = 0//10 * pxScale;
			
			var bottomButtonGap:int = 15 * pxScale;
			
			var topViewsHeight:Number = topViewsTopGap + progressY + progress.height + topViewsBottomGap;
			var bottomViewsHeight:Number = bottomButton.height + bottomButtonGap * 2;
			
			var freeHeight:Number = background.height - topViewsHeight - bottomViewsHeight;
			var calculatedRowsCount:int = Math.max(4, Math.floor(freeHeight / (listLayout.typicalItem.height + listLayout.verticalGap)));
		
			list.x = backImage.x - backImageWidth / 2;
			list.width = backImageWidth;
			list.height = calculatedRowsCount * (listLayout.typicalItem.height + listLayout.verticalGap) + listLayout.paddingTop + listLayout.paddingBottom - 8*pxScale//9* pxScale//10 * pxScale + 12*pxScale;
			list.y = background.y + topViewsHeight + (freeHeight - list.height)/2;
			backImage.height = list.height + listBackgroundTopGap + listBackgroundBottomGap/*+ 12*pxScale*/;
			backImage.y = list.y - listBackgroundTopGap;
			
			starTitle.y = background.y + topViewsTopGap + starTitle.pivotY;
			closeButton.y = starTitle.y;
			
			progressBarTextField.x = 0//progress.x + (progress.width - progressBarTextField.width)/2;
			progressBarTextField.y = starTitle.y - starTitle.pivotY + progressTextfieldY;// progress.y + 1 * pxScale;
			
			progress.x = (backgroundWidth - progress.width) / 2;
			progress.y = starTitle.y - starTitle.pivotY + progressY;
			
			var listBottomY:Number = list.y + list.height + listBackgroundBottomGap - background.y;
			bottomButton.y = listBottomY + (background.height - listBottomY - bottomButton.height) / 2 + bottomButton.pivotY + 3*pxScale + background.y;
			
			selectAllButton.alignPivot();
			selectAllButton.x = bottomButton.x - 265 * pxScale;
			selectAllButton.y = bottomButton.y;
		}
		
		private function initVerticalList():void
		{
			friendsCollection = new ListCollection();
			list = new List();
			list.elasticity = 0.8;
			
			listLayout = new TiledRowsLayout();
			listLayout.useVirtualLayout = true;
			listLayout.paddingTop = 11* pxScale;
			listLayout.paddingBottom = 11* pxScale;
			listLayout.requestedColumnCount = 2;
			listLayout.useSquareTiles = false;
			listLayout.typicalItem = itemRendererFactory();
			listLayout.horizontalGap = 2 * pxScale;
			listLayout.verticalGap = 16 * pxScale;

			list.layout = listLayout;
			list.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_NONE;
			list.verticalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			list.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			list.itemRendererFactory = itemRendererFactory;
			list.dataProvider = friendsCollection;
			list.addEventListener(SendGiftInviteFriendItemRenderer.EVENT_CHECKBOX_CHANGE, handler_rendererCheckboxChange);

			addChild(list);
			addToFadeList(list);
		}

		private function itemRendererFactory():SendGiftInviteFriendItemRenderer {
			return new SendGiftInviteFriendItemRenderer(SendGiftInviteFriendItemRenderer.WIDTH * pxScale, SendGiftInviteFriendItemRenderer.HEIGHT * pxScale, "SEND GIFT!", true);
		}

		private function refresh():void
		{
			mFriendsEligibleForGift = friendsManager.getAllFriendsEligibleForGift();
			
			if(GiftsModel.SOSTRACE_LOGGING_ENABLE)
				sosTrace('SendGiftsDialog ', mFriendsEligibleForGift.length, SOSLog.DEBUG);

			var alreadyGiftedCount:uint = Math.max(0, bingoInstalledFriendsWithoutFullQueue - mFriendsEligibleForGift.length);
			progressBarTextField.text = alreadyGiftedCount + " OUT OF " + bingoInstalledFriendsWithoutFullQueue;

			var progressPosition:Number = alreadyGiftedCount / bingoInstalledFriendsWithoutFullQueue;
			if (isFirstShow) 
			{
				progress.value = progressPosition;
				isFirstShow = false;
			} 
			else 
			{
				progress.animateValues(progressPosition, 0.7, 0.6, Transitions.EASE_OUT_BACK);
			}
			
			friendsCollection.data = mFriendsEligibleForGift;
/*
			if (!friendsCollection.data || friendsCollection.data.length == 0) {
				hintTextField.text = Constants.SEND_GIFT_FRIENDS_NO_FRIENDS_FOR_GIFT;
				hintTextField.x = (mBack.width - hintTextField.width)/2;
				hintTextField.y = mBack.height * 0.47;
				hintAwardIcon.visible = false;

				mList.visible = false;
				selectAllLabel.visible = false;
			}
			else {
				mList.visible = true;
				selectAllLabel.visible = true;
				hintAwardIcon.visible = true;

				hintTextField.text = Constants.SEND_GIFT_FRIENDS_HINT;
				hintTextField.x = progressBar.x;
				hintTextField.y = mBack.height * 0.29;
			}
*/

			if (alreadyGiftedCount < bingoInstalledFriendsWithoutFullQueue) {
				bottomButton.enabled = !friendsManager.isAllForGiftsFriendsDeselected;
			}
			else {
				bottomButton.enabled = false;
			}
		}

		private function get bingoInstalledFriendsWithoutFullQueue():uint {
			return FacebookData.instance.bingoInstalledFriendsWithoutFullQueue ? FacebookData.instance.bingoInstalledFriendsWithoutFullQueue.length : 0;
		}

		override protected function handler_bottomButton(e:Event):void
		{
			if (friendsCollection.length == 0)
				return;

			var friendsIds:Vector.<String> = new Vector.<String>();
			var length:int = friendsCollection.length;
			var i:int;
			var facebookFriend:FacebookFriend;
			for (i = 0; i < length; i++) {
				facebookFriend = friendsCollection.getItemAt(i) as FacebookFriend;
				if (facebookFriend.selected)
					friendsIds.push(facebookFriend.facebookId);
			}

			if (friendsIds.length == 0)
				return;

			bottomButton.enabled = false;

			friendsManager.sendGiftsToFriends(function(..._):void {
						refresh();
						FeathersUtils.refreshList(list.dataProvider);

						if (mFriendsEligibleForGift.length == 0) 
							Starling.juggler.delayCall(close, 0.7);
					},
					null,
					friendsIds,
					false
			);
		}

		private function handler_selectAll(e:Event):void
		{
			SoundManager.instance.playSfx(SoundAsset.ButtonClick, 0, 0, SoundAsset.DEFAULT_BUTTON_CLICK_VOLUME, 0, true);
			
			allFriendsSelected = !allFriendsSelected;
			
			selectAllLabel.text = allFriendsSelected ? Constants.SELECT_NONE : Constants.SELECT_ALL;
			friendsManager.selectOrDeselectAllPlayersAvailableForGift(allFriendsSelected);
			bottomButton.enabled = allFriendsSelected;
			
			FeathersUtils.refreshList(list.dataProvider);
		}

		private function handler_rendererCheckboxChange(event:Event):void 
		{
			if (!event.data && friendsManager.isAllForGiftsFriendsDeselected) 
			{
				bottomButton.enabled = false;
				allFriendsSelected = false;
				selectAllLabel.text = Constants.SELECT_ALL;
				return;
			}
			
			bottomButton.enabled = true;
		}
	}
}
