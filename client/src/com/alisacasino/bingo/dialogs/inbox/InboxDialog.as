package com.alisacasino.bingo.dialogs.inbox
{
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.assets.loading.GAFClipWrapper;
	import com.alisacasino.bingo.commands.dialogCommands.ShowInboxDialog;
	import com.alisacasino.bingo.commands.player.UpdateLobbyBarsTrueValue;
	import com.alisacasino.bingo.controls.Scale9ProgressBar;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.BaseDialog;
	import com.alisacasino.bingo.dialogs.DialogProperties;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.gifts.GiftsModel;
	import com.alisacasino.bingo.models.gifts.IncomingGiftData;
	import com.alisacasino.bingo.models.offers.OfferTriggers;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.FriendsManager;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.StringUtils;
	import com.alisacasino.bingo.utils.UIUtils;
	import flash.geom.Rectangle;
	import flash.utils.setInterval;
	import starling.animation.Transitions;
	import starling.utils.Align;

	import feathers.controls.renderers.IListItemRenderer;

	import feathers.layout.TiledRowsLayout;

	import starling.display.Image;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class InboxDialog extends BaseDialog
	{
		private var messageContainer:MessageContainer;
		
		private var progress:Scale9ProgressBar;
		
		
		private var giftModel:GiftsModel;
		private var uncollectedGifts:Vector.<IncomingGiftData>;
		private var totalGiftsInThisCollectPhase:int;
		private var opening:Boolean;
		private var toGiftFacebookIDs:Vector.<String>;
		
		private var animationContainer:AnimationContainer;
		private var hintTextField:XTextField;
		private var timerTextField:XTextField;
		
		private var bottomButtonCallback:Function;
		private var onCloseDialogFunction:Function;
		
		private var timerStringFormat:Vector.<String>;
		
		public function InboxDialog()
		{
			super(DialogProperties.INBOX);

			bottomButtonRelativeY = 0.926;

			giftModel = GameManager.instance.giftsModel;
			
			uncollectedGifts = giftModel.getUncollectedGifts();
/*
			uncollectedGifts = new <IncomingGiftData>[
				new IncomingGiftData("123212", "100000531869084"),
				new IncomingGiftData("123213", "100000531869084"),
				new IncomingGiftData("123214", "100000531869084"),
				new IncomingGiftData("123215", "100000531869084"),
				new IncomingGiftData("123216", "100000531869084"),
				new IncomingGiftData("123217", "100000531869084"),
				new IncomingGiftData("123218", "100000531869084")
			];*/

			totalGiftsInThisCollectPhase = uncollectedGifts.length + giftModel.provisionallyAcceptedGifts.length;
			
			timerStringFormat = new < String > ['h', 'min', 'm', 'sec', 'sec', '  ', '  ', '', ''];
		}

		override protected function initialize():void
		{
			super.initialize();

			addBackImage(0.2, 0.65, 0.2);
			
			progress = new Scale9ProgressBar(
				AtlasAsset.CommonAtlas.getTexture('invite/progress_frame'),  new Rectangle(25 * pxScale, 0,  1 * pxScale, 0),
				AtlasAsset.CommonAtlas.getTexture('invite/progress_bar_green'), new Rectangle(13 * pxScale, 0,  1 * pxScale, 0), 
				backImageWidth + 12*pxScale, 9 * pxScale, 8 * pxScale, 8 * pxScale, true);
			
			progress.animateValues(getAcceptedInSessionRatio());
			
			addChild(progress);	
			addToFadeList(progress);
            
			/*setInterval(function():void 
			{
				if (progress.value == 0) {
					progress.animateValues(0.6, 1, 0, Transitions.EASE_OUT_BACK);
				}
				else {
					progress.animateValues(0, 1, 0, Transitions.LINEAR);
				}
			}, 4000);*/
			
			messageContainer = new MessageContainer(backImageWidth, backImage.height);
			messageContainer.uncollectedGifts = uncollectedGifts.concat();
			messageContainer.addEventListener(MessageContainer.GIFT_TRIGGERED, messageContainer_elementTriggeredHandler);
			addToFadeList(messageContainer);
			addChild(messageContainer);

			addChild(bottomButton);
			
		}
		
		override protected function draw():void 
		{
			if (isInvalid(INVALIDATION_FLAG_DATA)) 
			{
				if (GiftsModel.DEBUG_SHOW_TIMER || gameManager.giftsModel.getUncollectedGifts().length <= 0)
				{
					progress.visible = false;
					messageContainer.visible = false;
					backImageAlpha = 0.1;
					
					if (!animationContainer) 
					{
						animationContainer = new AnimationContainer(MovieClipAsset.PackBase, true);
						animationContainer.validate();
						addChild(animationContainer);
						addToFadeList(animationContainer);
					
						animationContainer.playTimeline("cat_idle", true, true);
						
						hintTextField = new XTextField(400 * pxScale, 380 * pxScale, XTextFieldStyle.getChateaudeGarage(32))
						hintTextField.format.leading = 6 * pxScale;
						hintTextField.isHtmlText = true;
						hintTextField.batchable = true;
						//hintTextField.border = true;
						addChild(hintTextField);
						addToFadeList(hintTextField);
					}
						
					if (gameManager.giftsModel.timeToWaitForNextGift > 0 && gameManager.giftsModel.availableToAccept > 0)
					{
						// Гифты есть, но не кончился кулдаун с последнего забора. Показываем таймер.
						addEventListener(Event.ENTER_FRAME, enterFrameHandler);
						
						bottomButtonCallback = FriendsManager.instance.getAllFriendsEligibleForGift().length > 0 ? callShowSendGiftsDialog : close;
						bottomButton.text = Constants.BTN_OK;
						bottomButton.disabledText = Constants.BTN_OK;
						
						hintTextField.text = Constants.INBOX_COME_BACK_LATER;
						
						if (!timerTextField) {
							timerTextField = new XTextField(300*pxScale, 75, XTextFieldStyle.getChateaudeGarage(48, 0xFFFC00/*0x36ff00*/, Align.LEFT))
							timerTextField.batchable = true;
							//hintTextField.border = true;
							addChild(timerTextField);
							addToFadeList(timerTextField);
						}
						
						updateTimer();
					}
					else if(gameManager.giftsModel.availableToAccept <= 0)
					{
						// Гифтов тупо нет:
						
						if (FriendsManager.instance.getAllFriendsEligibleForGift().length > 0)
						{
							// Если есть кому дарить гифты предлагаем подарить:
						
							hintTextField.text = Constants.INBOX_NO_MORE_GIFTS_SEND_GET;
							
							bottomButtonCallback = callShowSendGiftsDialog;
							bottomButton.text = Constants.SEND_GET;
							bottomButton.disabledText = Constants.SEND_GET
						}
						else
						{
							// если некому дарить: 
							if (FriendsManager.instance.getAllFriendsEligibleForInvite().length > 0) 
							{
								// предлагаем пригласить еще друзей если есть такая возможность:
								hintTextField.text = Constants.INBOX_INVITE_MORE_FRIENDS;
							
								bottomButtonCallback = callShowInviteFriendsDialog;
								bottomButton.text = Constants.INVITE_BUTTON_TITLE;
								bottomButton.disabledText = Constants.INVITE_BUTTON_TITLE;
							}
							else
							{
								// иначе просто предлагаем играть дальше:
								hintTextField.text = Constants.INBOX_NO_MORE_GIFTS_PLAY_NOW;
							
								bottomButtonCallback = close;
								bottomButton.text = Constants.PLAY_NOW;
								bottomButton.disabledText = Constants.PLAY_NOW;
							}
						}
					}
				}
				else 
				{
					bottomButton.text = Constants.BTN_OK;
					bottomButton.disabledText = Constants.BTN_OK;
					bottomButtonCallback = close;//callCollectAllButton;
					
					onCloseDialogFunction = showSendGiftsDialog;
					
					progress.visible = true;
					messageContainer.visible = true;
					backImageAlpha = 0.2;
					
					if (animationContainer) {
						animationContainer.removeFromParent();
						animationContainer = null;
						
						hintTextField.removeFromParent();
						hintTextField = null;
					}
					
					if (timerTextField) {
						timerTextField.removeFromParent();
						timerTextField = null;
					}
				}
			}
			
			if (isInvalid(INVALIDATION_FLAG_SIZE)) 
				resize();
				
			tweenAppear();
		}
		
		override public function resize():void
		{
			super.resize();
			
			if (animationContainer) 
			{
				correctBackImageHeight();
				
				animationContainer.x = (backImageWidth - hintTextField.width - animationContainer.width * pxScale) / 2;
				animationContainer.y = (background.height - animationContainer.height* pxScale) / 2 - 20*pxScale + background.y;
				
				hintTextField.x = animationContainer.x + animationContainer.width* pxScale;
				hintTextField.y = (background.height - hintTextField.height) / 2 - 20*pxScale + background.y;
				
				if (timerTextField) {
					timerTextField.x = hintTextField.x + 112*pxScale;
					timerTextField.y = hintTextField.y + hintTextField.textBounds.y + hintTextField.textBounds.height + 0*pxScale;
				}
				
				backImage.y = (background.height - backImage.height) / 2 - 20 * pxScale + background.y;
				
				starTitle.y = (backImage.y - background.y - starTitle.height)/2 + starTitle.pivotY + background.y;
				closeButton.y = starTitle.y;
				
				var backImageBottomY:Number = backImage.y + backImage.height;
				bottomButton.y = backImageBottomY + (background.y + background.height - backImageBottomY - bottomButton.height)/2 + bottomButton.pivotY + 3*pxScale;
				
				//correctBackImageHeight();
				//backImage.y = (background.height - backImage.height) / 2 - 20 * pxScale + background.y;
				
				return;
			}
			
			var layout:TiledRowsLayout = messageContainer.layout as TiledRowsLayout;

			var topViewsTopGap:int = 22 * pxScale;
			var progressY:int = 61 * pxScale;
			var topViewsBottomGap:int = 12 * pxScale;
			
			var bottomButtonGap:int = 12 * pxScale;
			
			var topViewsHeight:Number = topViewsTopGap + progressY + progress.height + topViewsBottomGap;
			var bottomViewsHeight:Number = bottomButton.height + bottomButtonGap * 2;
			
			var freeHeight:Number = background.height - topViewsHeight - bottomViewsHeight;
			var calculatedRowsCount:int = Math.max(5, Math.floor(freeHeight / (layout.typicalItem.height + layout.verticalGap)));
		
			messageContainer.x = backImage.x - messageContainer.width / 2;
			messageContainer.height = calculatedRowsCount * (layout.typicalItem.height + layout.verticalGap) + layout.paddingTop + layout.paddingBottom - 5*pxScale;
			messageContainer.y = background.y + topViewsHeight + (freeHeight - messageContainer.height)/2;
			backImage.height = messageContainer.height + 3*pxScale;
			backImage.y = messageContainer.y - 1.5*pxScale;
			
			starTitle.y = background.y + topViewsTopGap + starTitle.pivotY;
			closeButton.y = starTitle.y;
			
			progress.x = (backgroundWidth - progress.width) / 2;
			progress.y = starTitle.y - starTitle.pivotY + progressY;
			
			var listBottomY:Number = messageContainer.y + messageContainer.height - background.y;
			bottomButton.y = listBottomY + (background.height - listBottomY - bottomButton.height) / 2 + bottomButton.pivotY + 1*pxScale + background.y;
		}

		private function messageContainer_elementTriggeredHandler(e:Event):void
		{
			giftModel.addToProvisionallyAcceptedGifts(e.data as IncomingGiftData);

			progress.animateValues(getAcceptedInSessionRatio());

			if (opening)
				return;

			if (giftModel.provisionallyAcceptedGifts.length >= totalGiftsInThisCollectPhase)
			{
				openGifts(true);
			}
		}

		private function openGifts(callDialogClose:Boolean):void
		{
			opening = true;

			toGiftFacebookIDs = new Vector.<String>();
			for each (var item:IncomingGiftData in giftModel.provisionallyAcceptedGifts)
			{
				if (item.cancelled)
					continue;

				if (FriendsManager.instance.isGoodForGift(item.senderID, false))
				{
					toGiftFacebookIDs.push(item.senderID);
				}
			}

            giftModel.collectAcceptedInSessionGifts();

			sendToFriendsOrClose(callDialogClose);

			//close();
			bottomButton.enabled = false;
		}

        private function sendToFriendsOrClose(callDialogClose:Boolean):void
        {
            if(toGiftFacebookIDs && toGiftFacebookIDs.length > 0)
            {
                var currentList:Vector.<String>;
                if (toGiftFacebookIDs.length > FriendsManager.SINGLE_REQUEST_ID_LIMIT)
                {
                    currentList = toGiftFacebookIDs.splice(0, FriendsManager.SINGLE_REQUEST_ID_LIMIT);
                }
                else
                {
                    currentList = toGiftFacebookIDs;
                    toGiftFacebookIDs = null;
                }
                FriendsManager.instance.sendGiftsToFriends(sendToFriendsOrClose, [callDialogClose], currentList, false);
            }
            else
            {
				
				/*if (giftModel.limitReached && giftModel.availableToAccept > 0)
				{
					PlatformServices.notificationUtils.scheduleLocalNotification(
						giftModel.timeToWaitForNextGift  / 1000,
						Constants.GIFT_COLLECT_NOTIFICATION_BODY,
						Constants.NOTIFICATION_COLLECT_ACTION,
						1);
				}*/
				if(callDialogClose)
					close();
            }
        }

        private function getAcceptedInSessionRatio():Number
        {
            return giftModel.provisionallyAcceptedGifts.length / totalGiftsInThisCollectPhase;
        }

		override protected function get bottomButtonStyle():XButtonStyle {
			return XButtonStyle.InboxBottomGreenButton;
		}
		
		private function enterFrameHandler(e:Event):void
		{
			updateTimer();
		}
		
		private function updateTimer():void
		{
			if (!timerTextField)
				return;
			
			var timeToWaitSeconds:Number = gameManager.giftsModel.timeToWaitForNextGift / 1000;
			
			if (timeToWaitSeconds <= 0)
			{
				close();
				new ShowInboxDialog(ShowInboxDialog.TYPE_ON_BUTTON_PRESS).execute();
				return;
			}
			
			timerTextField.x = hintTextField.x + (timeToWaitSeconds >= 3600 ? 112 : 130) * pxScale;
			
			//timerTextField.text = StringUtils.formatTimeShort(timeToWaitSeconds, timerStringFormat);
			timerTextField.text = StringUtils.formatTime(timeToWaitSeconds, "{1}:{2}:{3}", true, true, true);
		}
		
		override protected function handler_bottomButton(e:Event):void
		{
			handleAcceptedGifts(false);	
			
			if(bottomButtonCallback != null)
				bottomButtonCallback();
		}
		
		override protected function handler_closeButton(e:Event):void
		{
			handleAcceptedGifts(true);	
			//super.handler_closeButton(e);
		}
		
		private function callShowInviteFriendsDialog():void {
			close();
			FriendsManager.instance.showInviteFriendsDialog(FriendsManager.DIALOG_MODE_FROM_SIDE_MENU, false);
		}
		
		private function callShowSendGiftsDialog():void {
			close();
			showSendGiftsDialog();
		}
		
		private function showSendGiftsDialog():void {
			FriendsManager.instance.showSendGiftsDialog(null, false);
		}
		
		/*private function callCollectAllButton():void
		{
			messageContainer.acceptAllGifts();
			bottomButton.enabled = false;
		}*/
		
		private function handleAcceptedGifts(callDialogClose:Boolean):void
		{
			if (giftModel.provisionallyAcceptedGifts.length > 0) {
				openGifts(callDialogClose);
			}
			else {
				close();
			}
		}
		
		override public function close():void
		{
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			super.close();
			
			new UpdateLobbyBarsTrueValue(0.4).execute();
			
			if (onCloseDialogFunction != null)
				onCloseDialogFunction();
		}	
	
	}
}