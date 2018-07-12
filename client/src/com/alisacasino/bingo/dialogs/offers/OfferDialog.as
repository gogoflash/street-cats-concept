package com.alisacasino.bingo.dialogs.offers 
{
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.commands.ShowNoMoneyPopup;
	import com.alisacasino.bingo.commands.dialogCommands.ShowStore;
	import com.alisacasino.bingo.commands.player.ShowReservedDrops;
	import com.alisacasino.bingo.controls.ImageAssetContainer;
	import com.alisacasino.bingo.controls.LoadingWheel;
	import com.alisacasino.bingo.controls.StarTitle;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.IDialog;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.offers.OfferItem;
	import com.alisacasino.bingo.models.offers.OfferItemsPack;
	import com.alisacasino.bingo.models.offers.OfferManager;
	import com.alisacasino.bingo.models.offers.OfferType;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.storeWindow.StoreScreen;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.StringUtils;
	import com.alisacasino.bingo.utils.TimeService;
	import com.alisacasino.bingo.utils.UIConstructor;
	import com.alisacasino.bingo.utils.UIUtils;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAStoreItemTransactionEvent;
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.utils.Align;
	
	public class OfferDialog extends FeathersControl implements IDialog 
	{
		public static var WIDTH:uint = 1280;
		public static var HEIGHT:uint = 720;
		
		public static var ANIMATION_CAT_AMAZE:String = 'offer_cat_amaze';
		public static var ANIMATION_CAT_SMILE:String = 'offer_cat_smile';
		
		public function OfferDialog(callStoreOnHide:Boolean = false, offer:OfferItem = null) 
		{
			super();
			this.callStoreOnHide = callStoreOnHide;
			this.offer = offer;
			
			if (offer)
			{
				if (offer.type == OfferType.SINGLE_SHOW)
				{
					gameManager.offerManager.handleShowOffer(offer);
			
					if (offer.duration > 0)
						timeEnd = TimeService.serverTime + offer.duration;
					else
						timeEnd = offer.finish;
				
					offer.dialogShowed = true;	
				}
				else if (offer.type == OfferType.EVENT)
				{
					gameManager.offerManager.handleShowOffer(offer);
					timeEnd = offer.finish;
					offer.dialogShowed = true;	
				}
			}
		}
		
		private var offer:OfferItem;
		
		private var starTitle:StarTitle;
		private var titleLabel:XTextField;
		private var timerLabel:XTextField;
		
		private var closeButton:Button;
		
		private var isShowing:Boolean = true;
		private var isHiding:Boolean;
		
		private var timer:Timer;
		private var timeEnd:int;
		private var lastTimeoutValue:int;
		private var isThinRenderers:Boolean;
		
		private var rewardsContainer:Sprite;
		private var lastTimerLabelWidth:int;
		
		private var rendererWidth:int;
		private var rendererHeight:int;
		
		private var animationContainer:AnimationContainer;
		
		private var saleBadgeView:SaleBadgeView;
		
		private var fadeQuad:Quad;
		private var background:Image;
		private var buyButton:OfferGetButton;
		private var priceLabel:XTextField;
		private var oldPriceView:OldPriceView;
		
		private var callStoreOnHide:Boolean;
		
		private var itemPacksGap:uint;
		private var packsPaddingTop:uint;
		private var packDelimetersTop:int;
		
		private var childrenCreated:Boolean;
		
		private var callShowReservedDropsOnClose:Boolean;
		
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
		
			closeButton = UIConstructor.dialogCloseButton();
			closeButton.addEventListener(Event.TRIGGERED, handler_closeButton);
			addChild(closeButton);
			
			gameManager.offerManager.addEventListener(OfferManager.EVENT_UPDATE, handler_offerUpdate);
			handler_offerUpdate(null);
			
			addEventListener(OfferPackRenderer.EVENT_BUY_PACK, handler_buyPack);
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if(!offer)
			{
				//close();
				return;
			}
			
			if (isInvalid(INVALIDATION_FLAG_DATA)) 
			{
				enableTimer = offer.showTimer;
				
				createChildren();
			}
			
			if (isInvalid(INVALIDATION_FLAG_SIZE)) 
				resize();
				
			tweenAppear();
		}
		
		private function createChildren():void
		{
			if (childrenCreated)
				return;
				
			childrenCreated = true;	
			
			if (offer.title && !starTitle) {
				starTitle = new StarTitle(offer.title, XTextFieldStyle.getWalrus(58, 0xffffff), 16, 0, -4, starTitleActivateCallback);
				starTitle.alignPivot();
				addChild(starTitle);
				starTitle.pivotX = starTitle.width / 2;
				starTitle.pivotY = starTitle.height / 2;
			}
			
			if (offer.imageAsset)
			{
				if (offer.imageAsset.loaded)
				{
					createBackgroundImage();
					
					fadeQuad = new Quad(1, 1, 0x0);
					addChildAt(fadeQuad, 0);
				}
				else
				{
					offer.imageAsset.loadForParent(callback_assetLoaded, callback_assetFailed, this);
					return;
				}
			}
			else
			{
				fadeQuad = new Quad(1, 1, 0x0);
				addChildAt(fadeQuad, 0);
					
				var length:int = offer.rewards.length;
				isThinRenderers = length > 2;
				
				rewardsContainer = new Sprite();
				addChild(rewardsContainer);
				
				gameManager.offerManager.resetRewardsAlignIndex();
				
				var rendererBackgroundType:int;
				if (offer.storeItem.price.price > 0 || offer.storeItem.price.isFree) 
				{
					rendererBackgroundType = length > 2 ? OfferPackRenderer.BACKGROUND_SHORT_SLIM : OfferPackRenderer.BACKGROUND_SHORT_FAT;
					itemPacksGap = 80*pxScale;
					packsPaddingTop = 115 * pxScale;
					packDelimetersTop = 296 * pxScale;
				}
				else 
				{
					rendererBackgroundType = OfferPackRenderer.BACKGROUND_TALL_SLIM;
					itemPacksGap = 70*pxScale;
					packsPaddingTop = 137 * pxScale;
					packDelimetersTop = 573 * pxScale;
				}
				
				var i:int;
				var image:Image;
				var offerPackRenderer:OfferPackRenderer;
				for (i = 0; i < length; i++) 
				{
					offerPackRenderer = new OfferPackRenderer(offer.rewards[i], rendererBackgroundType);
					rendererWidth = offerPackRenderer.width;
					rendererHeight = offerPackRenderer.height;
					rewardsContainer.addChild(offerPackRenderer);
				
					if (i < (length - 1)) {
						image = new Image(OfferItem.atlasAsset.getTexture(offerPackRenderer.itemsPack.storeItem ? "offers/icon_or" : "offers/icon_plus"));
						image.alignPivot();
						rewardsContainer.addChild(image);
					}
				}
			}
			
			if (offer.animationAsset && offer.animationAsset.loaded) {
				animationContainer = new AnimationContainer(offer.animationAsset, false, true);
				animationContainer.validate();
				animationContainer.pivotX = (animationContainer.width * pxScale) / 2;
				animationContainer.pivotY = (animationContainer.height * pxScale) / 2;
				//animationContainer.play();
				addChild(animationContainer);
			}
			
			if (!offer.imageAsset && (offer.storeItem.price.price > 0 || offer.storeItem.price.isFree))
			{
				var priceLabelText:String;
				if (offer.storeItem.price.isFree)
					priceLabelText = 'Free!';
				else if (offer.storeItem.price.priceType == Type.REAL)
					priceLabelText = '$' + offer.storeItem.price.price.toString();
				else if(offer.storeItem.price.priceType == Type.CASH)
					priceLabelText = offer.storeItem.price.price.toString() + 'cash';
				else if(offer.storeItem.price.priceType == Type.DUST)
					priceLabelText = offer.storeItem.price.price.toString() + 'dust';
					
				priceLabel = new XTextField(1, 1, XTextFieldStyle.houseHolidaySans(131, 0xFFFF01), priceLabelText);
				priceLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
				priceLabel.alignPivot();
				addChild(priceLabel);
				
				buyButton = new OfferGetButton(XButtonStyle.OfferBuyButton, 'GET NOW!');
				buyButton.addEventListener(Event.TRIGGERED, handler_buyButton);
				buyButton.width = 330 * pxScale;
				buyButton.alignPivot();
				addChild(buyButton);
				
				if (offer.oldPrice > 0)
				{
					oldPriceView = new OldPriceView(offer.oldPrice);
					addChild(oldPriceView);
				}
				
				if (offer.salePercents > 0 || offer.storeItem.price.isFree) {
					saleBadgeView = new SaleBadgeView(SaleBadgeView.TYPE_BIG, offer.badgeTypeTable, offer.salePercents, null, offer.storeItem.price.isFree ? 'free!' : null);
					addChild(saleBadgeView);
				}
			}
			
			addChild(closeButton);
		}
		
		private function callback_assetLoaded():void
		{
			createBackgroundImage();
			childrenCreated = false;
			createChildren();
		}
		
		private function callback_assetFailed():void
		{
			fadeQuad = new Quad(1, 1, 0x0);
			addChildAt(fadeQuad, 0);
		}
		
		public function resize():void
		{
			trace('OFFER DIALOG RESIZE', gameManager.layoutHelper.stageWidth - width, gameManager.layoutHelper.stageHeight - height);
			//if (isShowing)
				//return;
			
			var packsPaddingLeft:int;
			var overHeight:int = this.overHeight;
			
			if (fadeQuad) {
				fadeQuad.x = -overWidth - 2;
				fadeQuad.y = -overHeight -2 ;
				fadeQuad.width = gameManager.layoutHelper.stageWidth/scale + 4;
				fadeQuad.height = gameManager.layoutHelper.stageHeight/scale + 4;
			}
			
			if (background && isShowing) {
				background.x = (width/scale) / 2;
				background.y = (height / scale) / 2;//(height/scale - background.texture.frameHeight) / 2;
			}
			
			//trace(addHeight, addHeight*scale, addHeight/scale);
			
			alignStarTitle();
			
			if (closeButton) {
				closeButton.x = width/scale + overWidth - closeButton.width / 2 + (layoutHelper.isIPhoneX ? 30 : 40) * pxScale/* * closeButton.scale*/;
				if(background)
					closeButton.y = starTitle ? starTitleY : (50 * pxScale - overHeight / 2);
				else
					closeButton.y = (packsPaddingTop - overHeight) / 2; 
			}
			
			if (!offer)
				return;
			
			var packTotalCount:int = offer.rewards ? offer.rewards.length : 0;	
			var packsPivotX:int;
			switch(packTotalCount) {
				case 1: packsPivotX = 747 * pxScale; break;
				case 2: packsPivotX = 807 * pxScale; break;
				case 3: {
					packsPivotX = 833 * pxScale;//(offer.animation == ANIMATION_CAT_AMAZE ? 870 : 833) * pxScale; 
					break;
				}
			}
			
			if (animationContainer) 
			{
				packsPaddingLeft = 440 * pxScale;
				
				if (!isShowing) {
					animationContainer.x = animationFinishX;
					animationContainer.y = animationFinishY;
				}
			}
			else
			{
				packsPaddingLeft = 0;
				packsPivotX = 640 * pxScale;
			}
			
			var i:int;
			var packCounter:int;
			var imageCounter:int;
			var displayObject:DisplayObject;
			var length:int = rewardsContainer ? rewardsContainer.numChildren : 0;
			var packsWidth:int = packTotalCount * rendererWidth + (packTotalCount - 1) * itemPacksGap;
			var rendererBottomY:int = packsPaddingTop + rendererHeight;
			var bottomViewsHeight:int = height / scale - rendererBottomY;
			
			packsPaddingLeft = Math.max(packsPaddingLeft, packsPivotX - packsWidth/2);
			
			for (i = 0; i < length; i++) 
			{
				displayObject = rewardsContainer.getChildAt(i) as DisplayObject;
				if (displayObject is Image) {
					displayObject.x = packsPaddingLeft + packCounter * (rendererWidth + itemPacksGap) - itemPacksGap / 2;
					displayObject.y = packDelimetersTop;
					imageCounter++;
				}
				else if (displayObject is OfferPackRenderer) {
					displayObject.x = packsPaddingLeft + packCounter * (rendererWidth + itemPacksGap) + rendererWidth/2;
					if (!isShowing)
						displayObject.y = packsPaddingTop + rendererHeight/2;
					packCounter++;
				}
			}
			
			/*addChild(UIUtils.drawQuad('1', 0, 0, width/scale, 1, 0.8, 0xFFFFFF));
			addChild(UIUtils.drawQuad('2', 0, 115 * pxScale, width, 1, 0.8, 0x00FF00));
			addChild(UIUtils.drawQuad('center', 0, -(addHeight/scale)/2, width, 1, 0.8, 0xFF0000));
			addChild(UIUtils.drawQuad('4', 0, height / scale, width / scale, 1, 0.8, 0xFFFFFF));
			addChild(UIUtils.drawQuad('5', 0, height/scale +(addHeight/scale)/2 , width/scale, 1, 0.8, 0xFF00FF));*/
			
			if (priceLabel)
			{
				priceLabel.x = 343 * pxScale;
				
				if (oldPriceView)
				{
					priceLabel.y = rendererBottomY + 80*pxScale + overHeight / 2;
					
					oldPriceView.x = priceLabel.x;
					oldPriceView.y = priceLabel.y + 84 * pxScale;
				}
				else
				{
					priceLabel.y = rendererBottomY + (bottomViewsHeight + overHeight)/2;
				}
			}
			
			if (buyButton)  
			{
				var buyButtonMinLeftX:int;
				if(priceLabel)
					buyButtonMinLeftX = priceLabel.x + Math.max(priceLabel.width, oldPriceView ? oldPriceView.expectWidth : 0) / 2 + 60 * pxScale + buyButton.width / 2;
				
				if (offer.showTimer && timerLabel) {
					buyButton.y = rendererBottomY + 94*pxScale + overHeight/2;
					timerLabel.y = buyButton.y + 89 * pxScale - timerLabel.height/2;
				}
				else {
					buyButton.y = rendererBottomY + (bottomViewsHeight)/2 + overHeight/2 + 15*pxScale;
				}	
				
				if (saleBadgeView) 
				{
					buyButton.x = Math.max(buyButtonMinLeftX, (priceLabel ? priceLabel.x : 0) + 400 * pxScale);
					
					saleBadgeView.x = buyButton.x + 350 * pxScale;
					saleBadgeView.y = rendererBottomY + (bottomViewsHeight + overHeight) / 2 + 2*pxScale;
					
					if (packTotalCount == 1 && rewardsContainer.numChildren > 0 && rewardsContainer.getChildAt(0) is OfferPackRenderer) 
						(rewardsContainer.getChildAt(0) as OfferPackRenderer).x = buyButton.x;
				}
				else
				{
					buyButton.x = Math.max(buyButtonMinLeftX, packsPaddingLeft + packsWidth / 2);
					//addChild(UIUtils.drawQuad('h1', leftPadding + packsWidth / 2 - rendererWidth/2, 0, 1, height/scale, 0.8, 0xFFFFFF));
				}
			}
			else
			{
				if (offer.showTimer && timerLabel) 
				{
					if (background) {
						var backgroundBottomY:int = background.y + background.texture.frameHeight / 2;
						timerLabel.y = Math.min(height / scale - 15 * pxScale, backgroundBottomY + (height / scale - backgroundBottomY) / 2) - timerLabel.height/2 + overHeight / 2;
					}
					else {
						timerLabel.y = rendererBottomY + (bottomViewsHeight) / 2 + overHeight / 2 - timerLabel.height / 2;
					}
				}
			}

			//updateTime();
		}
		
		private function tweenAppear():void
		{
			if (!isShowing)
				return;
				
			isShowing = false;
			
			var overHeight:int = this.overHeight;
			var overWidth:int = this.overWidth;
			
			if (fadeQuad) {
				fadeQuad.y = -fadeQuad.height - overHeight;
				Starling.juggler.tween(fadeQuad, 0.23, {y:-overHeight-2});
			}
			
			if (starTitle)
			{
				starTitle.y = -overHeight - starTitle.pivotY - 20 * pxScale;
				
				var tweenTitle_0:Tween = new Tween(starTitle, 0.12, Transitions.EASE_OUT);
				var tweenTitle_1:Tween = new Tween(starTitle, 0.2, Transitions.EASE_OUT_BACK);
				
				tweenTitle_0.delay = 0.4;
				tweenTitle_0.animate('y', starTitleY + 20*pxScale);
				//tweenTitle_0.animate('scaleX', 5);
				tweenTitle_0.nextTween = tweenTitle_1;
				
				//tweenTitle_1.animate('scale', 1);
				tweenTitle_1.animate('y', starTitleY);
				
				Starling.juggler.add(tweenTitle_0);
			}
			
			if (background) 
			{
				var backgroundExtraShiftY:int = -background.texture.frameHeight * 0.2 - 50 * pxScale;
				
				background.x = (width/scale) / 2;
				background.y = -overHeight - background.texture.frameHeight / 2 + backgroundExtraShiftY;
				
				background.alpha = 0;
				background.scaleX = 0.8;
				background.scaleY = 1.2;
				
				Starling.juggler.tween(background, 0.45, {delay:0.0, scaleX:1, alpha:10, scaleY:1, y:(height/scale)/2, transition:Transitions.EASE_OUT_BACK});
			}
			
			if (animationContainer)
			{
				var cycleStartFrame:int;
				
				animationContainer.addClipEventListener("animationEventFinish", handler_animationFramesFinish);
				animationContainer.addEventOnFrame(animationContainer.totalFrames, "animationEventFinish");
				
				if (offer.animation == ANIMATION_CAT_SMILE) 
				{
					cycleStartFrame = 11; //11
					animationContainer.y = height/scale + animationContainer.pivotY +  60 * pxScale + overHeight;
					animationContainer.x = animationFinishX;
					animationContainer.scaleX = 0.86;
					animationContainer.scaleY = 1.1;
					Starling.juggler.tween(animationContainer, 0.25, {delay:0.4, y:animationFinishY, scaleX:1, scaleY:1, transition:Transitions.EASE_OUT_BACK, onComplete:animationContainer.play});
				}
				else if (offer.animation == ANIMATION_CAT_AMAZE) 
				{
					cycleStartFrame = 95; //18
					animationContainer.y = animationFinishY;
					animationContainer.x = -animationContainer.pivotX - 50 * pxScale - overWidth;
					animationContainer.scale = 0.86;
					animationContainer.skewX = Math.PI/8;
					Starling.juggler.tween(animationContainer, 0.25, {delay:0.4, x:animationFinishX, skewX:0, transition:Transitions.EASE_OUT_BACK, onComplete:animationContainer.play});
				}
				else {
					//cycleStartFrame = animationContainer.totalFrames;
					animationContainer.y = -height/scale - animationContainer.pivotY - 60 * pxScale - overHeight;
					animationContainer.x = animationFinishX;
					animationContainer.scaleX = 0.86;
					animationContainer.scaleY = 1.1;
					Starling.juggler.tween(animationContainer, 0.25, {delay:0.4, y:animationFinishY, scaleX:1, scaleY:1, transition:Transitions.EASE_OUT_BACK, onComplete:animationContainer.play});
				}
				
				animationContainer.addAnimationSequence('animation_cycle', cycleStartFrame, animationContainer.totalFrames);
			}
			
			
			var i:int;
			var displayObject:DisplayObject;
			var length:int = rewardsContainer ? rewardsContainer.numChildren : 0;
			for (i = 0; i < length; i++) 
			{
				displayObject = rewardsContainer.getChildAt(i) as DisplayObject;
				if (displayObject is Image) {
					displayObject.alpha = 0;
					displayObject.scale = 0;
					tweenJumpView(displayObject, 0.4 + i*0.08)
				}
				else if (displayObject is OfferPackRenderer) {
					//displayObject.y = PACKS_PADDING_TOP * pxScale + rendererHeight / 2;
					displayObject.y = -overHeight - rendererHeight / 2 - 50 * pxScale;
					(displayObject as OfferPackRenderer).validate();
					(displayObject as OfferPackRenderer).tweenAppear(0.2 + i*0.05);
					tweenDropDown(displayObject, packsPaddingTop + rendererHeight / 2, 0.2 + i*0.05);
				}
			}
			
			if (priceLabel)
			{
				priceLabel.scaleY = 0;
				
				var tweenPrice_0:Tween = new Tween(priceLabel, 0.08, Transitions.EASE_OUT);
				var tweenPrice_1:Tween = new Tween(priceLabel, 0.17, Transitions.EASE_OUT_BACK);
				
				tweenPrice_0.delay = 1.8;
				tweenPrice_0.animate('y', priceLabel.y - 30*pxScale);
				tweenPrice_0.animate('scaleY', 1.68);
				tweenPrice_0.nextTween = tweenPrice_1;
				
				tweenPrice_1.animate('scaleY', 1);
				tweenPrice_1.animate('y', priceLabel.y);
				
				Starling.juggler.add(tweenPrice_0);
				
				if (oldPriceView) 
				{
					oldPriceView.scale = 1.23;
					oldPriceView.tweenShow(0.7);
					Starling.juggler.tween(oldPriceView, 0.15, {delay:1.8, scale:1, y:oldPriceView.y, transition:Transitions.EASE_OUT});
					oldPriceView.y = priceLabel.y;
				}
			}
			
			if (buyButton) {
				buyButton.scale = 0;
				buyButton.showFlareTween(0.55, 3.1);
				EffectsManager.scaleJumpAppearElastic(buyButton, 1, 0.45, 2.15);
			}
			
			if (timerLabel) {
				timerLabel.alpha = 0;
				Starling.juggler.tween(timerLabel, 0.3, {delay:2.3, alpha:1, transition:Transitions.LINEAR});
			}
			
			if (saleBadgeView) {
				saleBadgeView.scale = 0;
				EffectsManager.scaleJumpAppearBase(saleBadgeView, 1, 0.45, 2.25);
			}
			
			closeButton.alpha = 0;
			Starling.juggler.tween(closeButton, 0.4, {delay:2.3, alpha:1, transition:Transitions.LINEAR});
		}
		
		private function tweenHide():void
		{
			if (isHiding)
				return;	
				
			isHiding = true;
			
			var overHeight:int = this.overHeight;
			var overWidth:int = this.overWidth;
			
			if (fadeQuad) 
				Starling.juggler.tween(fadeQuad, 0.2, { delay: 0.27, y:(-fadeQuad.height-overHeight), transition:Transitions.EASE_IN });
			
			
			if (background) {
				Starling.juggler.removeTweens(background); 
				var backgroundExtraShiftY:int = -background.texture.frameHeight * 0.2 - 50 * pxScale;
				Starling.juggler.tween(background, 0.4, {delay:0.0, scaleX:0.8, scaleY:1.2, y:(-overHeight - background.texture.frameHeight / 2 + backgroundExtraShiftY), transition:Transitions.EASE_IN_BACK});
			}
			
			if (closeButton) {
				Starling.juggler.removeTweens(closeButton);
				closeButton.touchable = false;
				EffectsManager.scaleJumpDisappear(closeButton, 0.4);
			}
			
			if (animationContainer) 
			{
				if (offer.animation == ANIMATION_CAT_SMILE) 
				{
					Starling.juggler.tween(animationContainer, 0.4, {transition:Transitions.EASE_IN_BACK, alpha:0, scaleY:1.1, scaleX:0.8, y:(height/scale + overHeight + animationContainer.pivotY + 50 * pxScale), delay:0.0});
				}
				else if (offer.animation == ANIMATION_CAT_AMAZE) 
				{
					Starling.juggler.tween(animationContainer, 0.4, {transition:Transitions.EASE_IN_BACK, alpha:0, skewX:Math.PI/5, /*scaleX:1.1*0.86, scaleY:0.9,*/ x:(overWidth - animationContainer.pivotX - 50 * pxScale), delay:0.0});
				}
				else {
					Starling.juggler.tween(animationContainer, 0.4, {transition:Transitions.EASE_IN_BACK, alpha:0, scaleY:1.1, scaleX:0.8, y:(-height/scale - overHeight - animationContainer.pivotY - 50 * pxScale), delay:0.0});
				}
			}
			
			var i:int;
			var j:int;
			var k:int;
			var displayObject:DisplayObject;
			var length:int = rewardsContainer ? rewardsContainer.numChildren : 0;
			for (i = length-1; i >= 0; i--) 
			{
				displayObject = rewardsContainer.getChildAt(i) as DisplayObject;
				Starling.juggler.removeTweens(displayObject);
				if (displayObject is Image) 
				{
					EffectsManager.scaleJumpDisappear(displayObject, 0.3, 0.0 + k * 0.1);
					k++;
				}
				else if (displayObject is OfferPackRenderer) 
				{
					(displayObject as OfferPackRenderer).tweenHide(0.0 + j * 0.1);
					Starling.juggler.tween(displayObject, 0.2, {transition:Transitions.EASE_IN_BACK, scaleY:1.1, scaleX:0.8, y:(-overHeight - rendererHeight / 2 - 50 * pxScale), delay:0.0 + j * 0.1});
					j++;
				}
			}
			
			if (starTitle)
			{
				Starling.juggler.tween(starTitle, 0.4, {transition:Transitions.EASE_IN_BACK, scaleY:1.1, scaleX:0.8, y:(-overHeight - starTitle.pivotY - 20 * pxScale), delay:0.0});
			}
			
			if (timerLabel) {
				Starling.juggler.tween(timerLabel, 0.3, {delay:0.0, alpha:0, transition:Transitions.LINEAR});
			}
			
			if (buyButton)
				EffectsManager.scaleJumpDisappear(buyButton, 0.4, 0.0);
			
			if (saleBadgeView)
				EffectsManager.scaleJumpDisappear(saleBadgeView, 0.4, 0.1);
				
			if (priceLabel)
				//EffectsManager.scaleJumpDisappear(priceLabel, 0.4, 0.2);	
				Starling.juggler.tween(priceLabel, 0.3, {transition:Transitions.EASE_IN_BACK, alpha:0, scaleX:1.1, scaleY:0.8, x:(overWidth - priceLabel.pivotX - 30 * pxScale), delay:0.05});	
				
			if (oldPriceView) 
				//EffectsManager.scaleJumpDisappear(oldPriceView, 0.4, 0.3);	
				Starling.juggler.tween(oldPriceView, 0.3, {transition:Transitions.EASE_IN_BACK, alpha:0, scaleX:1.1, scaleY:0.8, x:(overWidth - oldPriceView.expectWidth/2 - 30 * pxScale), delay:0.0});	
			
			Starling.juggler.delayCall(removeDialog, 0.75);
			
			if (callStoreOnHide) {
				var showStoreCommand:ShowStore = new ShowStore(StoreScreen.CASH_MODE);
				Starling.juggler.delayCall(showStoreCommand.execute, 0.4);
			}
		}
		
		private function handler_offerUpdate(event:Event):void 
		{
			trace('>> offerdialog handler_offerUpdate');
			
			if (offer && (offer.type == OfferType.SINGLE_SHOW || offer.type == OfferType.EVENT))
			{
				if (gameManager.offerManager.isOfferPurchaseLimitReached(offer)) 
				{
					//if (offer.showTotalDialog && offer.storeItem.price.price == 0 && !offer.storeItem.price.isFree)
						//callShowReservedDropsOnClose = true;
					close();
				}
				else {
					refreshPacks();
				}
				
				return;
			}
			
			if (offer && offer == gameManager.offerManager.currentOffer) {
				// вероятно обновились покупки блоков
				refreshPacks();
				return;
			}
			
			// если активного оффера нет или он не типа первого платежа закрываемся(блочим открытие если оно в данный момент происходит)
			if (!gameManager.offerManager.currentOffer || gameManager.offerManager.currentOffer.type == OfferType.FIRST_PAYMENT) {
				close();
				return;
			}
			
			// если оффер сменился, то тоже закрываемся
			if (offer && offer != gameManager.offerManager.currentOffer) {
				close();
				
				// спорный момент, перепроверить все:
				if(offer.showTotalDialog && offer.storeItem.price.price == 0)
					new ShowReservedDrops(0.7).execute();
				
				return;
			}
			
			offer = gameManager.offerManager.currentOffer;
			
			// в случае если акция отображается в первый раз, то ей выставится время старта:
			gameManager.offerManager.setOfferStart();
			
			timeEnd = gameManager.offerManager.offerActiveFinishTime;
			
			// запоминаем, что окошко по данной акции отобразилось:
			gameManager.offerManager.dialogShowed = true;	

			invalidate();
		}
		
		private function handler_animationFramesFinish(event:Event):void {
			animationContainer.playSequence('animation_cycle');
		}
		
		private function starTitleActivateCallback():void 
		{
			if (starTitle) {
				starTitle.pivotX = starTitle.width / 2;
				starTitle.pivotY = starTitle.height / 2;
				//alignPivot();
				alignStarTitle();
			}
		}
		
		private function alignStarTitle():void
		{
			if (starTitle) {
				starTitle.x = WIDTH*pxScale / 2;
				if (!isShowing) 
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
					
					timerLabel = new XTextField(800, 50, XTextFieldStyle.getWalrus(35, 0xF3B5FE, Align.LEFT), "");
					//timerLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
					timerLabel.x = 0;
					timerLabel.y = HEIGHT - 100;
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
				timerLabel.text = Constants.OFFER_EXPIRES_STRING_SHORT + StringUtils.formatTime(time, "{1}:{2}:{3}", false, false);
			else
				timerLabel.text = Constants.OFFER_EXPIRES_STRING_SHORT + d + " " + "d" + " " + StringUtils.formatTime(time, "{1}:{2}:{3}", false, false);
				
			var newTimerLabelWidth:int = timerLabel.textBounds.width;
			
			//if(timerLabel.x == 0)
				//explicitReposition = true;
				
			if (/*explicitReposition ||*/ (Math.abs(lastTimerLabelWidth - newTimerLabelWidth) > 18*pxScale)) {
				lastTimerLabelWidth = newTimerLabelWidth;
				if(buyButton)
					timerLabel.x = buyButton.x -timerLabel.textBounds.x - timerLabel.textBounds.width / 2;
				else
					timerLabel.x = -timerLabel.textBounds.x / 2 + (width / scale - timerLabel.textBounds.width) / 2;
			}	
		}
		
		private function get animationFinishX():int {
			if (!offer || !offer.animation || !animationContainer)
				return 0;
			
			switch(offer.animation) {
				case ANIMATION_CAT_SMILE: return animationContainer.pivotX;
				case ANIMATION_CAT_AMAZE: return animationContainer.pivotX - 62 * pxScale;
			}
			
			return animationContainer.pivotX + (420*pxScale - animationContainer.width)/2;
		}
		
		private function get animationFinishY():int {
			if (!offer || !offer.animation || !animationContainer)
				return 0;
			
			switch(offer.animation) {
				case ANIMATION_CAT_SMILE: return 375 * pxScale;
				case ANIMATION_CAT_AMAZE: return 357 * pxScale;
			}
			
			return 360 * pxScale;
		}	
		
		private function handler_buyButton(e:Event):void
		{
			if (!offer)
				return;
				
			//gameManager.offerManager.completePayment(offer.id);
			
			if (offer.storeItem.price.priceType == Type.REAL)
			{
				LoadingWheel.show();
				PlatformServices.store.purchaseItem(offer.storeItem);
			}
			else if (offer.storeItem.price.priceType == Type.CASH && Player.current)
			{
				if (Player.current.cashCount < offer.storeItem.price.price)
				{
					new ShowNoMoneyPopup(ShowNoMoneyPopup.PURPLE, this, new Point(buyButton.x, buyButton.y)).execute();
					return;
				}
				
				Player.current.updateCashCount(-offer.storeItem.price.price, "offer:" + offer.type);
				
				gameManager.offerManager.claimBoughtOffer(offer.storeItem);
				
				gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreItemTransactionEvent(offer.storeItem));
			}
			else if (offer.storeItem.price.isFree) 
			{
				gameManager.offerManager.claimBoughtOffer(offer.storeItem);
				gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreItemTransactionEvent(offer.storeItem));
			}
			
			callStoreOnHide = false;
			
			//dispatchEventWith(DIALOG_OK_EVENT);
			close();
		}
		
		private function createBackgroundImage():void 
		{
			if (!background) 
			{
				background = new Image(offer.imageAsset.texture);
				background.alignPivot();//pivotX = background.texture.nativeWidth / 2;
				offer.imageAsset.addParent(this);
				background.addEventListener(TouchEvent.TOUCH, handler_backgroundTouch);	
				addChildAt(background, 0);
			}
		}
		
		private function tweenJumpView(view:DisplayObject, delay:Number = 0):void {
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
			var tween_0:Tween = new Tween(view, 0.17, Transitions.EASE_OUT);
			var tween_1:Tween = new Tween(view, 0.06, Transitions.EASE_IN);
			var tween_2:Tween = new Tween(view, 0.3, Transitions.EASE_OUT_BACK);
			
			view.scaleX = 0.85;
			view.scaleY = 1.1;
			tween_0.delay = delay;
			tween_0.animate('y', finishY);
			tween_0.nextTween = tween_1;
			
			tween_1.animate('scaleX', 1.1);
			tween_1.animate('scaleY', 0.95);
			tween_1.animate('y', finishY + 15 * pxScale);
			tween_1.nextTween = tween_2;
			
			tween_2.animate('scaleX', 1);
			tween_2.animate('scaleY', 1);
			tween_2.animate('y', finishY);
			
			Starling.juggler.add(tween_0);
		}
		
		private function get starTitleY():int
		{
			if (background)
				return Math.max(40 * pxScale, (height/scale - background.y - background.texture.frameHeight/2)/2) - overHeight/2;
				
			return 57*pxScale - overHeight / 2; 
		}
		
		private function get overHeight():int
		{
			return (Math.max(0, gameManager.layoutHelper.stageHeight - height) / 2) / scale;
		}
		
		private function get overWidth():int
		{
			return (Math.max(0, gameManager.layoutHelper.stageWidth - width) / 2) / scale;
		}
		
		private function handler_closeButton(e:Event):void
		{
			SoundManager.instance.playSfx(SoundAsset.ButtonClick, 0, 0, SoundAsset.DEFAULT_BUTTON_CLICK_VOLUME, 0, true);
			close();
		}
		
		private function handler_backgroundTouch(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
		
			var touch:Touch = event.getTouch(background);
			if (touch == null)
				return;
	
			if (touch.phase == TouchPhase.ENDED) 
			{
				if (offer.purchaseTouchRect) 
				{
					if (offer.purchaseTouchRect.containsPoint(touch.getLocation(background))) {
						background.removeEventListener(TouchEvent.TOUCH, handler_backgroundTouch);	
						handler_buyButton(null);
					}
				}
				else {
					background.removeEventListener(TouchEvent.TOUCH, handler_backgroundTouch);	
					handler_buyButton(null);
				}
			}
		}
		
		private function handler_buyPack(e:Event):void
		{
			callStoreOnHide = false;
			
			//if (offer.showTotalDialog)
				//callShowReservedDropsOnClose = true;
			
			close();
		}
		
		private function refreshPacks():void
		{
			if (!rewardsContainer)
				return;
			
			var i:int;
			var offerPackRenderer:OfferPackRenderer;
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
			}
			
			if(allPacksPurchased)	
				enableTimer = false;
		}
		
		private function checkPackPurchased(itemsPack:OfferItemsPack):Boolean {
			if (!itemsPack || !itemsPack.storeItem)
				return false;
				
			return gameManager.offerManager.getFromClientData(itemsPack.offerItem.id, itemsPack.storeItem.itemId, false);
		}
		
		public function close():void
		{
			removeEventListener(OfferPackRenderer.EVENT_BUY_PACK, handler_buyPack);
			gameManager.offerManager.removeEventListener(OfferManager.EVENT_UPDATE, handler_offerUpdate);	
//			dispatchEventWith(DIALOG_CLOSED_EVENT);
			tweenHide();
		}	
		
		private function removeDialog():void 
		{
			removeFromParent();
			
			if(callShowReservedDropsOnClose)
				new ShowReservedDrops(0.5).execute();	
			
			//gameManager.offerManager.debugOffer = null;
			
			//DisposalUtils.destroy(this);
			//dispatchEventWith(DIALOG_REMOVED_EVENT);
		}
	}

}
import com.alisacasino.bingo.assets.AtlasAsset;
import com.alisacasino.bingo.controls.XButton;
import com.alisacasino.bingo.controls.XButtonStyle;
import com.alisacasino.bingo.controls.XTextField;
import com.alisacasino.bingo.controls.XTextFieldStyle;
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextFieldAutoSize;

class OldPriceView extends Sprite 
{
	private var priceLabel:XTextField;
	private var wasLabel:XTextField;
	private var crossImage:Image;
	private var maskQuad:Quad;
	
	private var totalTextWidth:int;
	private var _expectWidth:int;	
	
	public function OldPriceView(priceValue:Number):void 
	{
		wasLabel = new XTextField(1, 1, XTextFieldStyle.houseHolidaySans(84, 0xFFFFFF), 'WAS');
		wasLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
		//wasLabel.border = true;
		wasLabel.alignPivot();
		addChild(wasLabel);
		
		priceLabel = new XTextField(1, 1, XTextFieldStyle.houseHolidaySans(84, 0xFFFFFF), '$' + priceValue.toString());
		priceLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
		//priceLabel.border = true;
		priceLabel.alignPivot();
		addChild(priceLabel);
		
		totalTextWidth = wasLabel.width + priceLabel.width + 7 * pxScale;
		_expectWidth = totalTextWidth + 20*pxScale;
		
		wasLabel.x = -totalTextWidth/2 + wasLabel.pivotX;
		priceLabel.x = wasLabel.x + priceLabel.pivotX + wasLabel.pivotX + 7 * pxScale;
		
		crossImage = new Image(AtlasAsset.ScratchCardAtlas.getTexture('offers/slash_pink'));
		crossImage.width = _expectWidth;
		crossImage.x = -totalTextWidth/2 - 10*pxScale;
		crossImage.y = -crossImage.height / 2;
		addChild(crossImage);
		
		maskQuad = new Quad(1, crossImage.height, 0xFF0000);
		maskQuad.alpha = 0.5;
		addChild(maskQuad);
		maskQuad.x = crossImage.x;
		maskQuad.y = crossImage.y; 
		crossImage.mask = maskQuad;
		
		priceLabel.scaleY =  0;
		wasLabel.scaleY =  0;
	}
	
	public function get expectWidth():Number
	{
		return _expectWidth;
	}
	
	public function tweenShow(delay:Number = 0):void
	{
		Starling.juggler.tween(priceLabel, 0.30, {delay:delay, scaleY:1, x:(priceLabel.x - 35*pxScale), transition:Transitions.EASE_OUT_BACK});
		Starling.juggler.tween(priceLabel, 0.15, {delay:(delay + 0.55), x:priceLabel.x, transition:Transitions.EASE_OUT});
		priceLabel.x -= 130 * pxScale;
		
		Starling.juggler.tween(wasLabel, 0.30, {delay:(delay + 0.4), scaleY:1, x:wasLabel.x, transition:Transitions.EASE_OUT_BACK});
		wasLabel.x -= 130 * pxScale;
		
		Starling.juggler.tween(maskQuad, 0.25, {delay:(delay + 0.9), width:expectWidth, transition:Transitions.EASE_OUT});
	}
}

class OfferGetButton extends XButton 
{
	public function OfferGetButton(style:XButtonStyle, text:String="", disabledText:String="") {
		super(style, text, disabledText);
	}
	
	public function showFlareTween(duration:Number=1.0, delay:Number = 0.0):void
	{
		var flare:Image = new Image(AtlasAsset.CommonAtlas.getTexture("bars/progress_flare"));
		flare.alignPivot();
		flare.x = flare.pivotX;
		flare.y = flare.pivotY + 28 * pxScale;
		flare.alpha = 0;
		flare.scaleY = 2.17 + 0.08;
		flare.scaleX = 1.17;
		flare.skewX = Math.PI / 7;
		addChildAt(flare, mTextField ? getChildIndex(mTextField) : numChildren);
		
		var tween_0:Tween = new Tween(flare, duration/2, Transitions.LINEAR);
		var tween_1:Tween = new Tween(flare, duration/2, Transitions.LINEAR);
		
		tween_0.delay = delay;
		tween_0.animate('scaleX', 2.17);
		tween_0.animate('alpha', 1.7);
		tween_0.animate('x', expectedWidth / 1.7);
		tween_0.animate('skewX', 0);  
		tween_0.nextTween = tween_1;
		
		tween_1.animate('scaleX', 0.9);
		tween_1.animate('alpha', 0);
		tween_1.animate('skewX', -Math.PI/20);  
		tween_1.animate('x', expectedWidth - flare.pivotX/2);
		tween_1.onComplete = flare.removeFromParent;
		
		Starling.juggler.add(tween_0);
	}
}