package com.alisacasino.bingo.dialogs
{
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.controls.FriendsPanel;
	import com.alisacasino.bingo.controls.Scale9ProgressBar;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.inbox.SendGiftInviteFriendItemRenderer;
	import com.alisacasino.bingo.models.FacebookFriend;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.SignInMessage.Platform;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.FacebookData;
	import com.alisacasino.bingo.utils.FriendsManager;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.RelativePixelMovingHelper;
	import com.alisacasino.bingo.utils.Settings;
	import com.alisacasino.bingo.utils.UIUtils;
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
	import flash.utils.setInterval;
	import starling.animation.Transitions;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.core.Starling;
	import com.alisacasino.bingo.utils.FeathersUtils;
	import starling.text.TextFieldAutoSize;
	import starling.utils.Align;

	public class InviteFriendsDialog extends BaseDialog
	{
		private var friendsManager:FriendsManager = FriendsManager.instance;
		private var mode:int;
		
		private var progress:Scale9ProgressBar;
		private var progressBarTextField:XTextField;
		private var progressEndImage:Image;
		
		private var hintTextField:XTextField;
		private var hintAwardIcon:Image;
		
		private var list:List;
		private var listLayout:TiledRowsLayout;
		
		private var animationContainer:AnimationContainer;
		
		private var selectAllButton:Button;
		private var selectAllLabel:XTextField;
		
		private var isFirstShow:Boolean = true;
		private var allFriendsSelected:Boolean;
		private var friendsCollection:ListCollection;
		private var friendsEligibleForInvite:Vector.<FacebookFriend>;
		
		private var checkMarkImage:Image;
		
		public function InviteFriendsDialog(mode:int = 0)
		{
			this.mode = mode;
			super(DialogProperties.INVITE_FRIENDS);
		}

		override protected function get dialogTitle():String
		{
			switch(mode) {
				case FriendsManager.DIALOG_MODE_FROM_SIDE_MENU: return 'INVITE FRIENDS';
				case FriendsManager.DIALOG_MODE_GET_FREE_CASH: return 'GET FREE CASH';
			}
			
			return super.dialogTitle;
		}
		
		override protected function get bottomButtonTitle():String
		{
			switch(mode) {
				case FriendsManager.DIALOG_MODE_FROM_SIDE_MENU: return isFacebook ? 'OK' : 'SHARE';
				case FriendsManager.DIALOG_MODE_GET_FREE_CASH: return 'GET NOW!';
			}
			
			return super.bottomButtonTitle;
		}
		
		override protected function initialize():void
		{
			super.initialize();

			addBackImage(0.27, 0.56, 0.18);
			
			progress = new Scale9ProgressBar(
				AtlasAsset.CommonAtlas.getTexture('invite/progress_frame'),  new Rectangle(25 * pxScale, 0,  1 * pxScale, 0),
				AtlasAsset.CommonAtlas.getTexture(mode == FriendsManager.DIALOG_MODE_GET_FREE_CASH ? 'invite/progress_bar_purple' : 'invite/progress_bar_green'), new Rectangle(13 * pxScale, 0,  1 * pxScale, 0), 
				backImageWidth + 12*pxScale, 9 * pxScale, 8 * pxScale, 8 * pxScale, true);
				
			addChild(progress);
			addToFadeList(progress);
			
			/*setInterval(function():void {
				var r:Number = Math.random();
				trace(r);
				if (Math.random() > 0.5) {
					progress.animateValues(r, 1);
				}
				else {
					progress.value = r;
				}
				
			}, 3000);*/
			//Starling.juggler.delayCall()
			
			progressBarTextField = new XTextField(250 * pxScale, 45 * pxScale, XTextFieldStyle.InviteOutOfStyle);
			progressBarTextField.helperFormat.nativeTextExtraWidth = 9; 
			progressBarTextField.batchable = true;
			addChild(progressBarTextField);
			addToFadeList(progressBarTextField);
			
			if(mode == FriendsManager.DIALOG_MODE_GET_FREE_CASH) {
				progressEndImage = new Image(AtlasAsset.CommonAtlas.getTexture("bars/cash"));
				progressEndImage.alignPivot();
				addChild(progressEndImage);
				addToFadeList(progressEndImage);
			}
			
			hintTextField = new XTextField(width, 40, XTextFieldStyle.getWalrus(24))
			//hintTextField.text = Constants.INVITE_FRIENDS_HINT.toUpperCase();
			hintTextField.isHtmlText = true;
			hintTextField.x = 0//(layoutHelper.stageWidth - hintTextField.width) / 2;
			hintTextField.batchable = true;
			//hintTextField.border = true;
			addChild(hintTextField);
			addToFadeList(hintTextField);
			
			
			hintAwardIcon = new Image(AtlasAsset.CommonAtlas.getTexture("bars/cash"));
			hintAwardIcon.scale = 0.71;
			hintAwardIcon.alignPivot();
			hintAwardIcon.touchable = false;
			addChild(hintAwardIcon);
			addToFadeList(hintAwardIcon);
			
			initVerticalList();
			
			allFriendsSelected = Settings.instance.preselectAll;
			friendsManager.selectOrDeselectAllPlayersAvailableForInvite(allFriendsSelected);
			
			var selectAllContent:Sprite = new Sprite();
			var selectAllTouchZoneQuad:Quad = new Quad(240 * pxScale, 95 * pxScale);
			selectAllTouchZoneQuad.alpha = 0;
			selectAllContent.addChild(selectAllTouchZoneQuad);
			
			selectAllLabel = new XTextField(180 * pxScale, 95 * pxScale, XTextFieldStyle.getWalrus(24, 0xa6a5a4, Align.LEFT),	allFriendsSelected ? Constants.SELECT_NONE : Constants.SELECT_ALL);
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

		override public function resize():void 
		{
			super.resize();
			resizeInternal();
		}
		
		private function resizeInternal(withTweens:Boolean = false):void 
		{
			var topViewsTopGap:int = 22 * pxScale;
			var progressY:int = 72 * pxScale;
			var hintTextfieldY:int = 131 * pxScale;
			var topViewsBottomGap:int = 15 * pxScale;
			var rendererHeight:Number = SendGiftInviteFriendItemRenderer.HEIGHT * pxScale;
			
			var listBackgroundTopGap:int = 0//12 * pxScale;
			var listBackgroundBottomGap:int = 0//10 * pxScale;
			
			var bottomButtonGap:int = 15 * pxScale;
			
			var topViewsHeight:Number = topViewsTopGap + hintTextfieldY + hintTextField.height + topViewsBottomGap;
			var bottomViewsHeight:Number = bottomButton.height + bottomButtonGap * 2;
			
			var freeHeight:Number = background.height - topViewsHeight - bottomViewsHeight;
			var calculatedRowsCount:int = Math.max(4, Math.floor(freeHeight / (rendererHeight + listLayout.verticalGap)));
		
			if (animationContainer && animationContainer.visible) 
			{
				correctBackImageHeight();
			
				//hintTextField.border = true;
				hintTextField.width = 400 * pxScale;
				hintTextField.height = 300 * pxScale;
				
				animationContainer.x = (backImageWidth - hintTextField.width - animationContainer.width * pxScale) / 2;
				hintTextField.x = animationContainer.x + animationContainer.width * pxScale;
				
				animationContainer.y = (background.height - animationContainer.height * pxScale) / 2 + background.y;
				hintTextField.y = (background.height - hintTextField.height) / 2 + background.y;
				
				if (checkMarkImage) {
					hintTextField.x += checkMarkImage.width / 2; 
					animationContainer.x -= checkMarkImage.width / 2; 
					checkMarkImage.y = hintTextField.y + hintTextField.textBounds.y - 10*pxScale;
					checkMarkImage.x = hintTextField.x + hintTextField.textBounds.x - checkMarkImage.width - 10 * pxScale;
				}
				
				if (withTweens) 
				{
					Starling.juggler.tween(backImage, 0.4, {y:((background.height - backImage.height) / 2 - 20 * pxScale + background.y), delay:0.35, transition:Transitions.EASE_IN_OUT});
					Starling.juggler.tween(starTitle, 0.5, {y:((backImage.y - background.y - starTitle.height) / 2 + starTitle.pivotY + background.y), delay:0.35, transition:Transitions.EASE_IN_OUT});
					//closeButton.y = (backImage.y - background.y - starTitle.height)/2 + starTitle.pivotY + background.y//starTitle.y;
				}
				else 
				{
					backImage.y = (background.height - backImage.height) / 2 - 20 * pxScale + background.y;
					starTitle.y = (backImage.y - background.y - starTitle.height) / 2 + starTitle.pivotY + background.y;
					closeButton.y = starTitle.y;
				}
				
				var backImageBottomY:Number = backImage.y + backImage.height;
				bottomButton.y = backImageBottomY + (background.y + background.height - backImageBottomY - bottomButton.height)/2 + bottomButton.pivotY + 3*pxScale;
			}
			else
			{
				list.x = backImage.x - backImageWidth / 2;
				list.width = backImageWidth;
				list.height = calculatedRowsCount * (rendererHeight + listLayout.verticalGap) + listLayout.paddingTop + listLayout.paddingBottom - 8*pxScale//9* pxScale//10 * pxScale + 12*pxScale;
				list.y = background.y + topViewsHeight + (freeHeight - list.height)/2;
				backImage.height = list.height + listBackgroundTopGap + listBackgroundBottomGap/*+ 12*pxScale*/;
				backImage.y = list.y - listBackgroundTopGap;
				
				starTitle.y = background.y + topViewsTopGap + starTitle.pivotY;
				closeButton.y = starTitle.y;
				
				progress.x = (backgroundWidth - progress.width) / 2;
				progress.y = starTitle.y - starTitle.pivotY + progressY;
				
				progressBarTextField.x = progress.x + (progress.width - progressBarTextField.width)/2;
				progressBarTextField.y = progress.y + 1 * pxScale;
				
				if (progressEndImage) {
					progressEndImage.x = progress.x + progress.width - progressEndImage.pivotX + 2*pxScale;
					progressEndImage.y = progress.y + progress.height/2;
				}
				
				hintTextField.y = starTitle.y - starTitle.pivotY + hintTextfieldY;
				hintAwardIcon.x = hintTextField.x + hintTextField.textBounds.x + hintTextField.textBounds.width * (273/574);
				hintAwardIcon.y = hintTextField.y + hintTextField.textBounds.y + hintTextField.textBounds.height/2;
				
				var listBottomY:Number = list.y + list.height + listBackgroundBottomGap - background.y;
				bottomButton.y = listBottomY + (background.height - listBottomY - bottomButton.height) / 2 + bottomButton.pivotY + 3*pxScale + background.y;
			}
			
			selectAllButton.alignPivot();
			selectAllButton.x = bottomButton.x - 265 * pxScale;
			selectAllButton.y = bottomButton.y;
			/*trace('>> ', bottomButton.y, background.height, freeHeight, calculatedRowsCount, listLayout.typicalItem.height + listLayout.verticalGap, listLayout.typicalItem.height, listLayout.verticalGap, scale);
			
			if (!UIUtils.getDrawQuad('top')) 
				addChild(UIUtils.drawQuad('top', 0, 0, width, topViewsHeight, 0.4, 0xFF0000));
			
			UIUtils.getDrawQuad('top').touchable = false;
			UIUtils.getDrawQuad('top').height = topViewsHeight;
			UIUtils.getDrawQuad('top').y = background.y;
			
			if (!UIUtils.getDrawQuad('center')) 
				addChild(UIUtils.drawQuad('center', 0, 0, width, freeHeight, 0.4, 0x00FF00));
			
			UIUtils.getDrawQuad('center').touchable = false;
			UIUtils.getDrawQuad('center').y = background.y + topViewsHeight;
			UIUtils.getDrawQuad('center').height = freeHeight;
			
			if (!UIUtils.getDrawQuad('bottom')) 
				addChild(UIUtils.drawQuad('bottom', 0, 0, width, freeHeight, 0.4, 0x0000FF));
			
			UIUtils.getDrawQuad('bottom').touchable = false;
			UIUtils.getDrawQuad('bottom').y = background.y + topViewsHeight + freeHeight;
			UIUtils.getDrawQuad('bottom').height = bottomViewsHeight;*/
		}

		private function itemRendererFactory():SendGiftInviteFriendItemRenderer {
			return new SendGiftInviteFriendItemRenderer(SendGiftInviteFriendItemRenderer.WIDTH * pxScale, SendGiftInviteFriendItemRenderer.HEIGHT * pxScale, "INVITE ME!");
		}

		private function refresh(withTweens:Boolean = false):void
		{
			var allFriendsCount:int;
			var alreadyInvitedCount:uint;
			
			if (isFacebook)
			{
				friendsEligibleForInvite = friendsManager.getAllFriendsEligibleForInvite();
				allFriendsCount = FacebookData.instance.inviteableFriends ? FacebookData.instance.inviteableFriends.length : 0;
				alreadyInvitedCount = Math.max(0, allFriendsCount - friendsEligibleForInvite.length);
			}
			else
			{
				if (FacebookData.instance.inviteSharingPosted) {
					friendsEligibleForInvite = new Vector.<FacebookFriend>();
					allFriendsCount = FacebookData.instance.inviteableFriends ? FacebookData.instance.inviteableFriends.length : 0;
					alreadyInvitedCount = allFriendsCount;
				}
				else {
					friendsEligibleForInvite = friendsManager.getAllFriendsEligibleForInvite();
					allFriendsCount = FacebookData.instance.inviteableFriends ? FacebookData.instance.inviteableFriends.length : 0;
					alreadyInvitedCount = 0;
				}
			}
			
			progressBarTextField.text = alreadyInvitedCount + "  OUT  OF  " + allFriendsCount;

			var progressPosition:Number = alreadyInvitedCount / allFriendsCount;
			progress.animateValues(progressPosition, 0.7, 0, Transitions.EASE_OUT_BACK);
			/*if(isFirstShow) {
				progress.value = progressPosition;
				isFirstShow = false;
			} else {
				progress.animateValues(progressPosition, 0.7, 0.3, Transitions.EASE_OUT_BACK);
			}*/

			friendsCollection.data = friendsEligibleForInvite;
			//friendsCollection.data = [];
			
			if (!animationContainer) {
				animationContainer = new AnimationContainer(MovieClipAsset.PackBase, true);
				animationContainer.validate();
				addChild(animationContainer);
				addToFadeList(animationContainer);
				animationContainer.visible = false;
			}
				
			if (FacebookData.instance.hasAnyFriends && !checkMarkImage) {
				checkMarkImage = new Image(AtlasAsset.CommonAtlas.getTexture("buy_cards/checkmark"));
				checkMarkImage.scale = 0.46;
				checkMarkImage.touchable = false;
				checkMarkImage.visible = false;
				addChild(checkMarkImage);
				addToFadeList(checkMarkImage);
			}
			
			if (!friendsCollection.data || friendsCollection.data.length == 0) 
			{
				bottomButton.enabled = false;
				
				hintAwardIcon.visible = false;
				hintTextField.textStyle = XTextFieldStyle.getChateaudeGarage(32);
				hintTextField.text = FacebookData.instance.hasAnyFriends ? Constants.INVITE_FRIENDS_NO_FRIENDS_FOR_INVITE : Constants.INVITE_FRIENDS_NO_FRIENDS_HINT;
				//hintTextField.text = Constants.INVITE_FRIENDS_NO_FRIENDS_HINT;
				
				if(checkMarkImage)
					checkMarkImage.visible = true;
					
				animationContainer.visible = true;
				animationContainer.playTimeline("cat_idle", true, true);
				
				if (withTweens) 
				{
					hintTextField.alpha = 0;
					checkMarkImage.alpha = 0;
					animationContainer.alpha = 0;
					
					groupTweenAlpha(0.3, 0, 0.5, setViewVisibleFalse, progress, progressBarTextField);
					groupTweenAlpha(0.3, 0, 0.4, setViewVisibleFalse, list, selectAllLabel);
					groupTweenAlpha(0.5, 1, 0.3, null, checkMarkImage, animationContainer, hintTextField);
				}
				else
				{
					list.visible = false;
					selectAllLabel.visible = false;
					progress.visible = false;
					progressBarTextField.visible = false;
					if(progressEndImage)
						progressEndImage.visible = false;
				}
			}
			else 
			{
				list.visible = true;
				selectAllLabel.visible = isFacebook;
				progress.visible = true;
				progressBarTextField.visible = true;
				if(progressEndImage)
					progressEndImage.visible = true;
				//backImage.visible = true;
				//hintAwardIcon.visible = true;
				
				bottomButton.enabled = alreadyInvitedCount != allFriendsCount;
				
				if (animationContainer) {
					animationContainer.stop();
					animationContainer.visible = false;
				}
				
				if(checkMarkImage)
					checkMarkImage.visible = false;
				
				//hintAwardIcon.visible = true;
				hintTextField.text = Constants.INVITE_FRIENDS_HINT.toUpperCase();
			}
		}

		private function groupTweenAlpha(duration:Number, value:Number, delay:Number, onComplete:Function, ...views):void {
			var view:DisplayObject;
			while (views.length > 0) {
				view = views.shift() as DisplayObject;
				if(view)
					Starling.juggler.tween(view, duration, {delay:delay, alpha:value, onComplete:onComplete, onCompleteArgs:[view]});
			}
		}
		
		private function setViewVisibleFalse(view:DisplayObject):void {
			if(view)
				view.visible = false;
		}
		
		override protected function handler_bottomButton(e:Event):void
		{
			bottomButton.enabled = false;
			
			if (isFacebook)
			{
				friendsManager.inviteFriends(inviteComplete)//callback_invite);
			}
			else
			{
				PlatformServices.facebookManager.share(gameManager.gameData.inviteFriendsShareOpengraphURL);
				FacebookData.instance.inviteSharingPosted = true;
				inviteComplete();
			}
			
			//callback_invite();
		}
		
		private function callback_invite():void
		{
			Starling.juggler.delayCall(inviteComplete, 0.4);
		}
		
		private function inviteComplete():void
		{
			refresh(true);
			FeathersUtils.refreshList(list.dataProvider);
			
			super.resize();
			resizeInternal(true);
			
			if (friendsEligibleForInvite.length == 0) 
				Starling.juggler.delayCall(close, 1.8);
		}

		private function handler_selectAll(e:Event):void
		{
			allFriendsSelected = !allFriendsSelected;
			
			selectAllLabel.text = allFriendsSelected ? Constants.SELECT_NONE : Constants.SELECT_ALL;
			friendsManager.selectOrDeselectAllPlayersAvailableForInvite(allFriendsSelected);
			bottomButton.enabled = allFriendsSelected;
			
			FeathersUtils.refreshList(list.dataProvider);
		}
		
		private function handler_rendererCheckboxChange(event:Event):void 
		{
			if (!event.data && friendsManager.isAllInviteFriendsDeselected) 
			{
				bottomButton.enabled = false;
				allFriendsSelected = false;
				selectAllLabel.text = Constants.SELECT_ALL;
				return;
			}
			
			bottomButton.enabled = true;
		}
		
		private function get isFacebook():Boolean {
			if (Constants.isLocalBuild)
				return false;
			
			return PlatformServices.isCanvas;
		}
	}
}
