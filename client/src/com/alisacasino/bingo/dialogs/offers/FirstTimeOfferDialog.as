package com.alisacasino.bingo.dialogs.offers 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.commands.ShowNoMoneyPopup;
	import com.alisacasino.bingo.commands.dialogCommands.ChestTakeOutCommand;
	import com.alisacasino.bingo.commands.dialogCommands.ShowStore;
	import com.alisacasino.bingo.commands.player.ShowReservedDrops;
	import com.alisacasino.bingo.commands.player.UpdateLobbyBarsTrueValue;
	import com.alisacasino.bingo.controls.LoadingWheel;
	import com.alisacasino.bingo.controls.StarTitle;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.IDialog;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.chests.ChestData;
	import com.alisacasino.bingo.models.offers.OfferItem;
	import com.alisacasino.bingo.models.offers.OfferItemsPack;
	import com.alisacasino.bingo.models.offers.OfferManager;
	import com.alisacasino.bingo.models.offers.OfferType;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.screens.storeWindow.StoreScreen;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.StringUtils;
	import com.alisacasino.bingo.utils.TimeService;
	import com.alisacasino.bingo.utils.UIConstructor;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAStoreItemTransactionEvent;
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextFieldAutoSize;
	import starling.utils.Align;
	
	public class FirstTimeOfferDialog extends FeathersControl implements IDialog 
	{
		public static var WIDTH:uint = 1280;
		public static var HEIGHT:uint = 720;
		
		private const ITEM_PACKS_GAP:uint = 70;
		private const PACKS_PADDING_TOP:uint = 137;
		
		private const AWARD_CHEST_TYPE:int = ChestType.SUPER;
		
		public function FirstTimeOfferDialog(callStoreOnHide:Boolean = false) 
		{
			super();
			this.callStoreOnHide = callStoreOnHide;
		}
		
		private var offer:OfferItem;
		
		private var fadeQuad:Quad;
		private var starTitle:StarTitle;
		private var titleLabel:XTextField;
		private var timerLabel:XTextField;
		
		private var closeButton:Button;
		
		private var isShowing:Boolean = true;
		private var isHiding:Boolean;
		
		private var timer:Timer;
		private var timeEnd:int;
		private var lastTimeoutValue:int;
		
		private var rewardsContainer:Sprite;
		private var lastTimerLabelWidth:int;
		
		private var rendererWidth:int;
		private var rendererHeight:int;
		
		private var callShowReservedDropsOnClose:Boolean = true;
		
		private var callStoreOnHide:Boolean;
		
		public function get fadeStrength():Number 
		{
			return 0.0;
		}
		
		public function get blockerFade():Boolean 
		{
			return true;
		}
		
		public function get fadeClosable():Boolean 
		{
			return false;
		}
		
		public function get align():String 
		{
			return Align.CENTER;
		}
		
		public function get selfScaled():Boolean 
		{
			return false;
		}
		
		public function get baseScale():Number
		{
			return layoutHelper.independentScaleFromEtalonMin;
		}
		
		override public function get width():Number {
			return WIDTH * pxScale * scale;
		}
		
		override public function get height():Number {
			return HEIGHT * pxScale * scale;
		}
		
		override public function set scale(value:Number):void 
		{
			super.scale = value;
			invalidate(INVALIDATION_FLAG_SIZE);
		}
		
		override protected function initialize():void 
		{
			super.initialize();
		
			fadeQuad = new Quad(1, 1, 0x0);
			addChild(fadeQuad);
			
			closeButton = UIConstructor.dialogCloseButton();
			closeButton.addEventListener(Event.TRIGGERED, handler_closeButton);
			addChild(closeButton);
			
			starTitle = new StarTitle('', XTextFieldStyle.getWalrus(58, 0xffffff), 16, 0, -4, starTitleActivateCallback);
			starTitle.alignPivot();
			addChild(starTitle);
			
			rewardsContainer = new Sprite();
			addChild(rewardsContainer);
			
			gameManager.offerManager.addEventListener(OfferManager.EVENT_UPDATE, handler_offerUpdate);
			handler_offerUpdate(null);
			
			addEventListener(OfferPackRenderer.EVENT_BUY_PACK, handler_buyPack);
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if(!offer)
			{
				return;
			}
			
			//trace('PARSED', isInvalid(INVALIDATION_FLAG_SIZE), isInvalid(INVALIDATION_FLAG_DATA));
		
			if (isInvalid(INVALIDATION_FLAG_DATA)) 
			{
				starTitle.text = offer.title;
				starTitle.pivotX = starTitle.width / 2;
                starTitle.pivotY = starTitle.height / 2;

				var length:int = offer.rewards.length;
				
				if (rewardsContainer.numChildren == 0) 
				{
					gameManager.offerManager.resetRewardsAlignIndex();
					
					var i:int;
					var image:Image;
					var offerPackRenderer:OfferPackRenderer;
					var offerItemsPack:OfferItemsPack;
					var allPacksPurchased:Boolean = true;
					for (i = 0; i < length; i++) 
					{
						offerItemsPack = offer.rewards[i];
						offerPackRenderer = new OfferPackRenderer(offerItemsPack, OfferPackRenderer.BACKGROUND_TALL_SLIM, checkPackPurchased(offerItemsPack));
						rendererWidth = offerPackRenderer.width;
						rendererHeight = offerPackRenderer.height;
						rewardsContainer.addChild(offerPackRenderer);
						//trace('asdasd', i, i % 2);
						if (i < (length - 1)) {
							image = new Image(OfferItem.atlasAsset.getTexture("offers/icon_plus"));
							image.alignPivot();
							rewardsContainer.addChild(image);
						}
						
						if (!offerPackRenderer.isPurchased)
							allPacksPurchased = false;
					}
					
					image = new Image(OfferItem.atlasAsset.getTexture("offers/icon_equal"));
					image.alignPivot();
					rewardsContainer.addChild(image);
					rewardsContainer.addChild(new OfferChestPackRenderer(AWARD_CHEST_TYPE, allPacksPurchased, callback_getChest));
					
					enableTimer = offer.showTimer && !allPacksPurchased;
				}
				else
				{
					enableTimer = offer.showTimer;
				}
			}
			
			
			if (isInvalid(INVALIDATION_FLAG_SIZE)) 
				resize();
				
			tweenAppear();
		}
		
		public function resize():void
		{
			var packsPaddingLeft:int;
			var overHeight:int = this.overHeight;
			
			fadeQuad.x = -overWidth - 2;
			fadeQuad.y = -overHeight - 2;
			fadeQuad.width = gameManager.layoutHelper.stageWidth/scale + 4;
			fadeQuad.height = gameManager.layoutHelper.stageHeight/scale + 4;
			
			if (closeButton) {
				closeButton.x = width/scale + overWidth - closeButton.width / 2 + (layoutHelper.isIPhoneX ? 30 : 40) * pxScale/* * closeButton.scale*/;
				closeButton.y = (PACKS_PADDING_TOP * pxScale - overHeight) / 2;
			}
			
			if (timerLabel && !isShowing) 
				timerLabel.y = 650*pxScale + overHeight / 2;
			
			alignStarTitle();
			
			if (!offer)
				return;
			
			var i:int;
			var packCount:int;
			var imageCount:int;
			var offerPackRenderer:OfferPackRenderer;
			var image:Image;
			var displayObject:DisplayObject;
			var length:int = rewardsContainer.numChildren;
			var packTotalCount:int = (offer ? offer.rewards.length : 0) + 1;
			var leftPadding:int = (width/scale - packTotalCount * rendererWidth - (packTotalCount - 1) * ITEM_PACKS_GAP * pxScale)/2 + rendererWidth/2;
			for (i = 0; i < length; i++) 
			{
				displayObject = rewardsContainer.getChildAt(i) as DisplayObject;
				if (displayObject is Image) {
					displayObject.x = leftPadding + packCount * (rendererWidth + ITEM_PACKS_GAP * pxScale) - ITEM_PACKS_GAP * pxScale / 2 - rendererWidth/2;//imageCount * (ITEM_PACKS_GAP); 
					displayObject.y = 573 * pxScale;
					imageCount++;
				}
				else if (displayObject is OfferPackRenderer || displayObject is OfferChestPackRenderer) {
					displayObject.x = leftPadding + packCount * (rendererWidth + ITEM_PACKS_GAP * pxScale)/* + imageCount * (ITEM_PACKS_GAP)*/;
					displayObject.y = PACKS_PADDING_TOP * pxScale + rendererHeight/2;
					packCount++;
				}
			}
			
			if (isShowing)
			{
				
			}
			else
			{
				
			}
		
			//updateTime();
		}
		
		private function handler_offerUpdate(event:Event):void 
		{
			//trace('FirstTimeOfferDialog.handler_offerUpdate');
			
			if (offer && offer == gameManager.offerManager.currentOffer) 
			{
				// вероятно обновились покупки блоков
				refreshPacks();
				return;
			}
			
			// если активного оффера нет или он не типа первого платежа закрываемся(блочим открытие если оно в данный момент происходит)
			if (!gameManager.offerManager.currentOffer || gameManager.offerManager.currentOffer.type != OfferType.FIRST_PAYMENT) {
				close();
				return;
			}
			
			// если оффер сменился, то тоже закрываемся
			if (offer && offer != gameManager.offerManager.currentOffer) {
				close();
				return;
			}
			
			offer = gameManager.offerManager.currentOffer;
			offer.addEventListener(OfferItem.EVENT_PACK_PURCHASED_CHANGE, handler_packPurchasedChange);
			
			// в случае если акция отображается в первый раз, то ей выставится время старта:
			gameManager.offerManager.setOfferStart();
			
			timeEnd = gameManager.offerManager.offerActiveFinishTime;
			
			// запоминаем, что окошко по данной акции отобразилось:
			gameManager.offerManager.dialogShowed = true;	
			
			invalidate();
		}
		
		private function handler_packPurchasedChange(event:Event):void 
		{
			refreshPacks();
		}
		
		protected function tweenAppear():void
		{
			if (!isShowing)
				return;
				
			isShowing = false;
			
			var overHeight:int = this.overHeight;
			var overWidth:int = this.overWidth;
			
			fadeQuad.y = -fadeQuad.height - overHeight;
			fadeQuad.alpha = 0;
			Starling.juggler.tween(fadeQuad, 0.23, {y:-overHeight-2, alpha:1});
			
			var i:int;
			var j:int;
			var k:int;
			var displayObject:DisplayObject;
			var length:int = rewardsContainer.numChildren;
			for (i = 0; i < length; i++) 
			{
				displayObject = rewardsContainer.getChildAt(i) as DisplayObject;
				if (displayObject is Image) 
				{
					//displayObject.y = 296 * pxScale;
					displayObject.alpha = 0;
					displayObject.scale = 0;
					tweenJumpView(displayObject, 1.2 + k * 0.2);
					k++;
				}
				else if (displayObject is OfferPackRenderer) 
				{
					displayObject.y = -overHeight - rendererHeight / 2 - 50 * pxScale;
					(displayObject as OfferPackRenderer).validate();
					(displayObject as OfferPackRenderer).tweenAppear(0.4 + j*0.15);
					tweenDropDown(displayObject, PACKS_PADDING_TOP * pxScale + rendererHeight / 2, 0.4 + j * 0.15);
					j++;
				}
				else if (displayObject is OfferChestPackRenderer) 
				{
					displayObject.y = -overHeight - rendererHeight / 2 - 50 * pxScale;
					(displayObject as OfferChestPackRenderer).validate();
					(displayObject as OfferChestPackRenderer).tweenAppear(0.4 + j*0.15 + 1.1);
					tweenDropDown(displayObject, PACKS_PADDING_TOP * pxScale + rendererHeight / 2, 0.4 + j * 0.15 + 1.1);
					Starling.juggler.delayCall(tweenJumpPacks, 0.4 + j * 0.15 + 1.25);
					j++;
				}
			}
			
			if (starTitle)
			{
				starTitle.y = -overHeight - starTitle.pivotY - 20 * pxScale;
				
				var tweenTitle_0:Tween = new Tween(starTitle, 0.12, Transitions.EASE_OUT);
				var tweenTitle_1:Tween = new Tween(starTitle, 0.2, Transitions.EASE_OUT_BACK);
				
				tweenTitle_0.delay = 0.3;
				tweenTitle_0.animate('y', starTitleY + 25 * pxScale);
				//tweenTitle_0.animate('scaleX', 5);
				tweenTitle_0.nextTween = tweenTitle_1;
				
				//tweenTitle_1.animate('scale', 1);
				tweenTitle_1.animate('y', starTitleY);
				
				Starling.juggler.add(tweenTitle_0);
			}
			
			if (timerLabel) {
				timerLabel.alpha = 0;
				timerLabel.y = 300 * pxScale;
				Starling.juggler.tween(timerLabel, 0.25, {delay:0.1, alpha:1, y:(650*pxScale + overHeight / 2), transition:Transitions.EASE_OUT_BACK});
			}
			
			closeButton.alpha = 0;
			Starling.juggler.tween(closeButton, 0.5, {delay:1.5, alpha:1, transition:Transitions.LINEAR});
		}
		
		protected function tweenHide():void
		{
			if (isHiding)
				return;	
				
			isHiding = true;
			
			var overHeight:int = this.overHeight;
			var overWidth:int = this.overWidth;
			
			Starling.juggler.tween(fadeQuad, 0.2, { delay: 0.27, y:(-fadeQuad.height-overHeight), transition:Transitions.EASE_IN });
			
			
			var i:int;
			var j:int;
			var k:int;
			var displayObject:DisplayObject;
			var length:int = rewardsContainer.numChildren;
			for (i = length-1; i >= 0; i--) 
			{
				displayObject = rewardsContainer.getChildAt(i) as DisplayObject;
				Starling.juggler.removeTweens(displayObject);
				if (displayObject is Image) 
				{
					EffectsManager.scaleJumpDisappear(displayObject, 0.3, 0.0 + k * 0.11);
					k++;
				}
				else if (displayObject is OfferPackRenderer) 
				{
					(displayObject as OfferPackRenderer).tweenHide(0.0 + j * 0.15);
					Starling.juggler.tween(displayObject, 0.2, {transition:Transitions.EASE_IN_BACK, scaleY:1.1, scaleX:0.8, y:(-overHeight - rendererHeight / 2 - 50 * pxScale), delay:0.1 + j * 0.11});
					j++;
				}
				else if (displayObject is OfferChestPackRenderer) 
				{
					Starling.juggler.tween(displayObject, 0.2, {transition:Transitions.EASE_IN_BACK, scaleY:1.1, scaleX:0.8, y:(-overHeight - rendererHeight / 2 - 50 * pxScale), delay:0.1 + j * 0.11});
					j++;
				}
			}
			
			if (starTitle)
			{
				Starling.juggler.tween(starTitle, 0.4, {transition:Transitions.EASE_IN_BACK, scaleY:1.1, scaleX:0.8, y:(-overHeight - starTitle.pivotY - 20 * pxScale), delay:0.0});
			}
			
			if (timerLabel) {
				Starling.juggler.tween(timerLabel, 0.15, {delay:0.3, alpha:0, y:450*pxScale, transition:Transitions.EASE_OUT});
			}
			
			if (closeButton) {
				Starling.juggler.removeTweens(closeButton);
				closeButton.touchable = false;
				EffectsManager.scaleJumpDisappear(closeButton, 0.4);
			}
				
			Starling.juggler.delayCall(removeDialog, 0.9);
			
			if (callStoreOnHide) {
				var showStoreCommand:ShowStore = new ShowStore(StoreScreen.CASH_MODE);
				Starling.juggler.delayCall(showStoreCommand.execute, 0.4);
			}
		}
		
		private function starTitleActivateCallback():void 
		{
			if (starTitle) {
				starTitle.pivotX = starTitle.width / 2;
				starTitle.pivotY = starTitle.height / 2;
				alignStarTitle();
			}
		}
		
		private function alignStarTitle():void
		{
			if (starTitle) {
				starTitle.x = WIDTH*pxScale / 2;
				if(!isShowing)
					starTitle.y = starTitleY; 
			}
		}
		
		private function set enableTimer(value:Boolean):void
		{
			//trace(' enableTimer ', value);
			if (value)
			{
				if (!timer) 
				{
					timer = new Timer(100);
					timer.addEventListener(TimerEvent.TIMER, handler_timer);
					handler_timer(null);
					
					timerLabel = new XTextField(800*pxScale, 50*pxScale, XTextFieldStyle.getWalrus(34, 0xFFFF00, Align.LEFT), "");
					//timerLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
					timerLabel.x = 0;
					timerLabel.y = HEIGHT - 100*pxScale;
					addChild(timerLabel);
			
				}
				
				timer.start();
			}
			else 
			{
				if (timer) {
					timer.removeEventListener(TimerEvent.TIMER, handler_timer);
					timer = null;
					
					timerLabel.removeFromParent();
					timerLabel = null;
				}
			}
		}
		
		private function handler_timer(event:TimerEvent):void
		{
			var timeout:int = timeEnd - TimeService.serverTime;
			
			if (lastTimeoutValue == timeout)
				return;
			
			lastTimeoutValue = timeout;
			
			if (timeout <= 0) 
			{
				updateTime(0);
				timer.stop();
				lastTimeoutValue = int.MIN_VALUE;	
				close();
			}
			else {
				if (!timer.running) 
					timer.start();
				
				updateTime(timeout);
			}
		}	
		
		private function updateTime(time:int):void 
		{
			if (gameManager.deactivated || !parent || !timerLabel)
				return;
			
			var oneDay:uint = 86400;
			var d:int =  Math.floor(time / oneDay);
			if(d < 1)
				timerLabel.text = Constants.OFFER_EXPIRES_STRING + StringUtils.formatTime(time, "{1}:{2}:{3}", false, false, false);
			else
				timerLabel.text = Constants.OFFER_EXPIRES_STRING + d + " " + "day" + " " + StringUtils.formatTime(time, "{1}:{2}:{3}", false, false);
				
			var newTimerLabelWidth:int = timerLabel.textBounds.width;
			
			//if(timerLabel.x == 0)
				//explicitReposition = true;
				
			if (/*explicitReposition ||*/ (Math.abs(lastTimerLabelWidth - newTimerLabelWidth) > 18*pxScale)) {
				lastTimerLabelWidth = newTimerLabelWidth;
				timerLabel.x = -timerLabel.textBounds.x / 2 + (width / scale - timerLabel.textBounds.width) / 2;
			}	
		}
		
		private function tweenJumpView(view:DisplayObject, delay:Number = 0):void 
		{
			var tween_0:Tween = new Tween(view, 0.1, Transitions.EASE_OUT);
			var tween_1:Tween = new Tween(view, 1.0, Transitions.EASE_OUT_ELASTIC);
			
			tween_0.delay = delay;
			tween_0.animate('scale', 1.43);
			tween_0.animate('alpha', 4);
			tween_0.nextTween = tween_1;
			
			tween_1.animate('scale', 1);
			
			Starling.juggler.add(tween_0);
		}
		
		private function tweenDropDown(view:DisplayObject, finishY:int, delay:Number = 0):void 
		{
			var tween_0:Tween = new Tween(view, 0.17*0.7, Transitions.EASE_OUT);
			var tween_1:Tween = new Tween(view, 0.10*0.7, Transitions.EASE_OUT);
			var tween_2:Tween = new Tween(view, 0.45*0.7, Transitions.EASE_OUT_BACK);
			
			tween_0.delay = delay;
			tween_0.animate('y', finishY + 35 * pxScale);
			tween_0.nextTween = tween_1;
			
			tween_1.animate('scaleX', 1.1);
			tween_1.animate('scaleY', 0.95);
			tween_1.animate('y', finishY + 55 * pxScale);
			tween_1.nextTween = tween_2;
			
			tween_2.animate('scaleX', 1);
			tween_2.animate('scaleY', 1);
			tween_2.animate('y', finishY);
			
			view.scaleX = 0.85;
			view.scaleY = 1.1;
			
			Starling.juggler.add(tween_0);
		}
		
		public function tweenJumpPacks(delay:Number = 0):void
		{
			var i:int;
			var j:int;
			var offerPackRenderer:OfferPackRenderer;
			var length:int = rewardsContainer.numChildren;
			var tweenBack:Tween;
			for (i = length-1; i >= 0; i--) 
			{
				offerPackRenderer = rewardsContainer.getChildAt(i) as OfferPackRenderer;
				if (offerPackRenderer) 
				{
					tweenBack = new Tween(offerPackRenderer, 0.11, Transitions.EASE_IN);
					tweenBack.animate('y', offerPackRenderer.y);
					Starling.juggler.tween(offerPackRenderer, 0.06, {y:(offerPackRenderer.y - 15*pxScale), delay:(delay + j*0.04), nextTween:tweenBack, transition:Transitions.EASE_OUT});
					
					offerPackRenderer.tweenJump(delay + j*0.04);
					j++;
				}
			}
		}
		
		private function get overHeight():int
		{
			return (Math.max(0, gameManager.layoutHelper.stageHeight - height) / 2) / scale;
		}
		
		private function get overWidth():int
		{
			return (Math.max(0, gameManager.layoutHelper.stageWidth - width) / 2) / scale;
		}
			
		protected function handler_closeButton(e:Event):void
		{
			SoundManager.instance.playSfx(SoundAsset.ButtonClick, 0, 0, SoundAsset.DEFAULT_BUTTON_CLICK_VOLUME, 0, true);
			close();
		}
		
		private function handler_buyPack(e:Event):void
		{
			callStoreOnHide = false;
		}
		
		public function close():void
		{
			if (offer)
				offer.addEventListener(OfferItem.EVENT_PACK_PURCHASED_CHANGE, handler_packPurchasedChange);
				
			removeEventListener(OfferPackRenderer.EVENT_BUY_PACK, handler_buyPack);
			gameManager.offerManager.removeEventListener(OfferManager.EVENT_UPDATE, handler_offerUpdate);	
//			dispatchEventWith(DIALOG_CLOSED_EVENT);
			tweenHide();
		}	
		
		protected function removeDialog():void 
		{
			removeFromParent();
			//DisposalUtils.destroy(this);
			//dispatchEventWith(DIALOG_REMOVED_EVENT);
			if(callShowReservedDropsOnClose)
				new ShowReservedDrops(0.5).execute();	
		}
		
		private function get starTitleY():int
		{
			return 58 * pxScale - overHeight / 2; 
		}
		
		private function refreshPacks():void
		{
			var i:int;
			var offerPackRenderer:OfferPackRenderer;
			var offerChestPackRenderer:OfferChestPackRenderer;
			var length:int = rewardsContainer.numChildren;
			var allPacksPurchased:Boolean = true;
			for (i = length-1; i >= 0; i--) 
			{
				offerPackRenderer = rewardsContainer.getChildAt(i) as OfferPackRenderer;
				if (offerPackRenderer) 
				{
					offerPackRenderer.isPurchased = checkPackPurchased(offerPackRenderer.itemsPack);
					if (!offerPackRenderer.isPurchased)
						allPacksPurchased = false;
				}
					
				if (rewardsContainer.getChildAt(i) is OfferChestPackRenderer)
					offerChestPackRenderer = rewardsContainer.getChildAt(i) as OfferChestPackRenderer;
			}
			
			if (offerChestPackRenderer)
				offerChestPackRenderer.isComplete = allPacksPurchased;
				
			if(allPacksPurchased)	
				enableTimer = false;
		}
		
		private function checkPackPurchased(itemsPack:OfferItemsPack):Boolean {
			if (!itemsPack || !itemsPack.storeItem)
				return false;
			
			if (itemsPack.purchaseProgress == OfferItemsPack.PURCHASE_PROGRESS_WAIT)
				return false;
				
			return gameManager.offerManager.getFromClientData(itemsPack.offerItem.id, itemsPack.storeItem.itemId, false);	
			
			//return itemsPack.purchaseProgress == OfferItemsPack.PURCHASE_PROGRESS_COMPLETE;// && gameManager.offerManager.getFromClientData(itemsPack.offerItem.id, itemsPack.storeItem.itemId, false);
		}
		
		private function callback_getChest():void 
		{
			callStoreOnHide = false;
			
			gameManager.offerManager.getOfferBonus(offer);
		
			var chestData:ChestData = new ChestData(0);
			chestData.type = AWARD_CHEST_TYPE;
			chestData.seed = (Math.random() * (int.MAX_VALUE - 1)) + 1;
			
			callShowReservedDropsOnClose = false;
			
			DialogsManager.closeAll();
			
			var chestTakeOutCommand:ChestTakeOutCommand = new ChestTakeOutCommand(chestData, null, null, true, ChestTakeOutCommand.FIRST_PAYMENT_OFFER_CHEST, null);
			Starling.juggler.delayCall(chestTakeOutCommand.execute, 0.5);
		}
		
	}

}

import com.alisacasino.bingo.assets.AnimationContainer;
import com.alisacasino.bingo.assets.MovieClipAsset;
import com.alisacasino.bingo.commands.dialogCommands.ChestTakeOutCommand;
import com.alisacasino.bingo.controls.XButton;
import com.alisacasino.bingo.controls.XButtonStyle;
import com.alisacasino.bingo.controls.XTextField;
import com.alisacasino.bingo.controls.XTextFieldStyle;
import com.alisacasino.bingo.dialogs.DialogsManager;
import com.alisacasino.bingo.models.chests.ChestData;
import com.alisacasino.bingo.models.offers.OfferItem;
import com.alisacasino.bingo.protocol.ChestType;
import com.alisacasino.bingo.utils.EffectsManager;
import feathers.core.FeathersControl;
import flash.utils.setInterval;
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.events.Event;
import starling.textures.Texture;

class OfferChestPackRenderer extends FeathersControl 
{
	//public static var WIDTH:uint = 232;
	//public static var HEIGHT:uint = 482;
	
	public function OfferChestPackRenderer(chestType:int, isComplete:Boolean = false, onGetChestCallback:Function = null) 
	{
		this.chestType = chestType;
		_isComplete = isComplete;
		callback_getChest = onGetChestCallback;
		super();
	}
	
	private var chestType:int;
	private var thinBackground:Boolean;
	
	private var background:Image;
	private var chestImage:Image;
	private var labelTop:XTextField;
	private var labelBottom:XTextField;
	private var bottomButton:XButton;
	private var smokeExplosion:AnimationContainer;
	private var chestTitle:String;
	private var _isComplete:Boolean;
	
	private var callback_getChest:Function;
	
	override public function get width():Number {
		return 232*pxScale;
	}
	
	override public function get height():Number {
		return 482*pxScale;
	}
	
	public function set isComplete(value:Boolean):void
	{
		if (_isComplete == value)
			return;
			
		_isComplete = value;
			
		invalidate(INVALIDATION_FLAG_DATA);
	}
	
	public function get isComplete():Boolean 
	{
		return _isComplete;
	}
	
	override protected function initialize():void 
	{
		super.initialize();
	
		background = new Image(OfferItem.atlasAsset.getTexture('offers/pack_bg_thin'));
		background.alpha = 1;
		background.alignPivot();
		addChild(background);
		
		var chestTexture:String;
		switch(chestType) {
			case ChestType.GOLD: 	{
				chestTexture = 'offers/chest_gold';
				chestTitle = 'GOLD CHEST';
				break;
			}
			case ChestType.SILVER: 	{
				chestTexture = 'offers/chest_silver';
				chestTitle = 'SILVER CHEST';
				break;
			}	
			case ChestType.BRONZE: 	{
				chestTexture = 'offers/chest_bronze';
				chestTitle = 'BRONZE CHEST';
				break;
			}
			case ChestType.SUPER: 	{
				chestTexture = 'offers/chest_super';
				chestTitle = 'SUPER CHEST';
				break;
			}
		}
		
		chestImage = new Image(OfferItem.atlasAsset.getTexture(chestTexture));
		chestImage.alpha = 1;
		chestImage.alignPivot();
		chestImage.y = -8*pxScale;
		addChild(chestImage);
		
		handleCompleteViews(false);
		
		smokeExplosion = new AnimationContainer(MovieClipAsset.PackBase, true, true);
		smokeExplosion.dispatchOnCompleteTimeline = true;
		//smokeExplosion.pivotX = 125 * pxScale;
		//smokeExplosion.pivotY = 50 * pxScale;
		smokeExplosion.touchable = false;
		smokeExplosion.scale = 2*1.36;
		smokeExplosion.y = 65*pxScale;
	}
	
	override protected function draw():void 
	{
		super.draw();
		
		handleCompleteViews(true, 0.7);
		
		if (isInvalid(INVALIDATION_FLAG_SIZE)) {
			
			//resize();
		}
	}
	
	public function tweenAppear(delay:Number):void
	{
		tweenDropDown(chestImage, -150 * pxScale, delay);
		
		if(labelTop)
			tweenScale(labelTop, 0, delay + 0.2);
			
		if(labelBottom)	
			tweenScale(labelBottom, -20 * pxScale, delay + 0.25);
	}	
	
	private function tweenDropDown(view:DisplayObject, shiftY:int, delay:Number = 0):void 
	{
		var tween_0:Tween = new Tween(view, 0.1, Transitions.EASE_OUT);
		var tween_1:Tween = new Tween(view, 0.1, Transitions.EASE_OUT);
		var tween_2:Tween = new Tween(view, 1.0, Transitions.EASE_OUT_ELASTIC);
		
		tween_0.delay = delay;
		tween_0.animate('y', view.y);
		tween_0.nextTween = tween_1;
		
		tween_1.animate('y', view.y + 25*pxScale);
		tween_1.animate('scaleX', 1.13);
		tween_1.animate('scaleY', 0.83);
		tween_1.onComplete = showSmokeExplosion;
		tween_1.nextTween = tween_2;
		
		tween_2.animate('y', view.y);
		tween_2.animate('scaleX', 1);
		tween_2.animate('scaleY', 1);
		
		view.y = shiftY;
		view.scaleX = 0.95;
		view.scaleY = 1.07;
		Starling.juggler.add(tween_0);
	}
	
	private function handleCompleteViews(animate:Boolean, delay:Number = 0):void 
	{
		if (_isComplete)
		{
			if (!bottomButton) {
				bottomButton = new XButton(XButtonStyle.GreenButton, 'GET!');
				bottomButton.addEventListener(Event.TRIGGERED, handler_bottomButton);
				addChild(bottomButton);
				bottomButton.alignPivot();
				bottomButton.y = height / 2 - bottomButton.height / 2 - 12 * pxScale;
			}
			
			if (animate)
			{
				EffectsManager.scaleJumpAppearElastic(bottomButton, 1, 0.7, delay + 0.2);
					
				if (labelTop) {
					EffectsManager.scaleJumpDisappear(labelTop, 0.3, delay + 0.1);
					EffectsManager.scaleJumpDisappear(labelBottom, 0.3, delay + 0.1, removeBottomLabels);
				}
			}
			else
			{
				removeBottomLabels();
			}
		}
		else
		{
			if (!labelTop)
			{
				labelTop = new XTextField(width, 82*pxScale, XTextFieldStyle.getWalrus(71), "FREE");
				labelTop.alignPivot();
				//labelTop.border = true;
				labelTop.y = height/2 - 66*pxScale;
				addChild(labelTop);
				
				labelBottom = new XTextField(width, 40*pxScale, XTextFieldStyle.getWalrus(25), chestTitle);
				//labelBottom.border = true;
				labelBottom.alignPivot();
				labelBottom.y = labelTop.y + 41 * pxScale;
				labelBottom.alpha = 0;
				addChild(labelBottom);
			}
			
			if (bottomButton) {
				bottomButton.removeFromParent(true);
				bottomButton = null;
			}
		}
	}
	
	private function removeBottomLabels():void
	{
		if (labelTop) {
			labelTop.removeFromParent(true);
			labelTop = null;
			
			labelBottom.removeFromParent(true);
			labelBottom = null;
		}
	}
	
	private function handler_bottomButton(e:Event):void
	{
		bottomButton.touchable = false;
		
		if (callback_getChest != null)
			callback_getChest();
	}
	
	private function tweenScale(view:DisplayObject, shiftY:int, delay:Number = 0):void 
	{
		var tween_0:Tween = new Tween(view, 0.13, Transitions.EASE_OUT);
		var tween_1:Tween = new Tween(view, 0.2, Transitions.EASE_OUT_BACK);
		
		tween_0.delay = delay;
		tween_0.animate('y', view.y + 15*pxScale);
		tween_0.animate('scaleY', 1.2);
		tween_0.animate('alpha', 2);
		tween_0.nextTween = tween_1;
		
		tween_1.animate('y', view.y);
		tween_1.animate('scaleY', 1);
		
		view.y = shiftY;
		view.scaleY = 0;
		Starling.juggler.add(tween_0);
	}
	
	public function showSmokeExplosion(delay:Number = 0):void
	{
		addChild(smokeExplosion);
		smokeExplosion.playTimeline('smoke_explosion', false, true, 24);
		smokeExplosion.addEventListener(AnimationContainer.EVENT_COMPLETE_TIMELINE, handler_completeSmokeAnimation);
		//Starling.juggler.tween(smokeExplosion, 0.1, {transition:Transitions.LINEAR, delay:(delay + 0.3), scale:0, onComplete:removeSmokeExplosion});
	}
	
	private function handler_completeSmokeAnimation(event:Event):void {
		if (smokeExplosion) {
			smokeExplosion.removeFromParent();
			smokeExplosion = null;
		}
	}
}	
	
