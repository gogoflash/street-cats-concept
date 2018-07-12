package com.alisacasino.bingo.dialogs.chests
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.commands.player.ShowReservedDrops;
	import com.alisacasino.bingo.commands.player.UpdateLobbyBarsTrueValue;
	import com.alisacasino.bingo.components.AwardImageAssetContainer;
	import com.alisacasino.bingo.components.SimpleProgressBar;
	import com.alisacasino.bingo.components.effects.ParticleExplosion;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.IDialog;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.chests.ChestData;
	import com.alisacasino.bingo.models.chests.ChestPowerupPack;
	import com.alisacasino.bingo.models.chests.ChestsData;
	import com.alisacasino.bingo.models.collections.Collection;
	import com.alisacasino.bingo.models.collections.CollectionItem;
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.screens.lobbyScreenClasses.ChestSlotView;
	import com.alisacasino.bingo.utils.DelayCallUtils;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.tweens.BezierTween;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Align;
	
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.display.Image;
	
	public class ChestTakeOutDialog extends Sprite implements IDialog
	{
		public static var WIDTH:uint = 1280;
		public static var HEIGHT:uint = 720;
		
		private var DELAY_CALLS_BUNDLE:String = 'ChestTakeOutDialog';
		
		private var APPEAR_CHEST_CYCLE_SEQUENCE:String = 'APPEAR_CHEST_CYCLE_SEQUENCE';
		private var FIRST_GOOD_BLINK_CYCLE_SEQUENCE:String = 'FIRST_GOOD_BLINK_CYCLE_SEQUENCE';
		private var NEXT_GOOD_BLINK_CYCLE_SEQUENCE:String = 'NEXT_GOOD_BLINK_CYCLE_SEQUENCE';
		
		private const TAP_DELAY_TIMEOUT:int = 1300;
		
		private var DESCRIPTIONS_TWEEN_X:int = 80 * pxScale;
		
		private var CARD_START_ROTATION:Number = -(47 * Math.PI) / 180;
		
		private var chestAnimation:AnimationContainer;
		private var animationParams:Vector.<int>;
		
		private var puffImage:Image;
		
		private var cardsIcon:Image;
		private var cardsLabel:XTextField;
		
		private var shineImage:Image;
		private var particleEffect:ParticleExplosion;
		
		private var awardImage:AwardImageAssetContainer;
		private var titleLabel:XTextField;	
		private var typeTitleLabel:XTextField;
		private var descriptionTitle:XTextField;
		private var resourceProgressView:ChestGoodView;
		private var dustView:ChestDustIndicator;
		
		private var rareAnimationMagicFx:AnimationContainer;
		private var rareAnimationMagicSlash:AnimationContainer;
		
		private var nextButton:XButton;
		
		private var completeCallback:Function;
		
		private var isHiding:Boolean;
		
		private var currentItemIndex:int = 0;
		
		private var clickCount:int = 0;
		
		private var _chestData:ChestData;
		private var _chestSlotView:ChestSlotView;
		
		private var lastTapTimeout:int;
		
		private var commodityItemMessage:CommodityItemMessage; 
		private var collectionItem:CollectionItem; 
		private var chestPowerupPack:ChestPowerupPack;
		
		private var startPowerupValue:int;
		private var startCashValue:int;
		private var collectionStartValues:Object;
		
		private var powerupViews:Vector.<PowerUpView>;
		private var cardsSources:Array;
		private var cardsNumberLabelValuesSources:Array;
		private var cardsGlowSources:Array;
		private var cardsTypesIsCollection:Array;
		
		private var totalCardsShows:Boolean;
		private var allCardViews:Vector.<AwardImageAssetContainer>;
		
		private var acceleratedAutoTakeOut:Boolean;
		private var startAccelerateTime:int;
		private var isTakeOutNextItemInProgress:Boolean;
		
		private var accelerateAdvanceTime:Number = 0.01;
		private var customizerCard:CustomizerItemBase;
		
		private var callShowReservedDrops:Boolean;
		
		public function ChestTakeOutDialog(chestData:ChestData, completeCallback:Function = null, chestSlotView:ChestSlotView = null, callShowReservedDrops:Boolean = true) 
		{
			_chestSlotView = chestSlotView;
			_chestData = chestData;
			this.completeCallback = completeCallback;
			this.callShowReservedDrops = callShowReservedDrops;
			animationParams = _chestData.openAnimationParams;
			
			initialize();
		
			addEventListener(Event.REMOVED_FROM_STAGE, handler_removedFromStage);
			
			startCashValue = Player.current.cashCount;
			startPowerupValue = gameManager.powerupModel.powerupsTotal;
			collectionStartValues = {};
			
			powerupViews = new <PowerUpView>[];
			cardsSources = [];
			cardsNumberLabelValuesSources = [];
			cardsGlowSources = [];
			cardsTypesIsCollection = [];
			allCardViews = new <AwardImageAssetContainer>[];
			
			accountForCollectionItemDrop();
			
			gameManager.chestsData.addEventListener(ChestsData.EVENT_ACCELERATE_CHEST_TAKE_OUT_DIALOG, handler_accelerateTakeOut);
		}
		
		private function accountForCollectionItemDrop():void 
		{
			//We are assuming that collection items were already added to the player inventory
			var prizes:Array = chestData.prizes;
			if (prizes)
			{
				for each (var item:* in prizes) 
				{
					if (item is CollectionItem)
					{
						var collectionItem:CollectionItem = item as CollectionItem;
						if (!collectionStartValues.hasOwnProperty(collectionItem.id))
						{
							var playerItem:CollectionItem = gameManager.collectionsData.getItemByID(collectionItem.id);
							if (!playerItem)
							{
								continue;
							}
							
							collectionStartValues[collectionItem.id] = playerItem.duplicates;
						}
						
						collectionStartValues[collectionItem.id] -= collectionItem.duplicates;
					}
					
				}
			}
		}
		
		public function get fadeStrength():Number {
			return 0.95;
		}
		
		public function get blockerFade():Boolean {
			return true;
		}
		
		public function get fadeClosable():Boolean {
			return true;
		}
		
		public function get chestSlotView():ChestSlotView {
			return _chestSlotView;
		}
		
		public function get chestData():ChestData {
			return _chestData;
		}
		
		public function get align():String {
			return Align.CENTER;
		}
		
		override public function get width():Number {
			return WIDTH * pxScale * scale;
		}
		
		override public function get height():Number {
			return HEIGHT * pxScale * scale;
		}
		
		protected function initialize():void 
		{
			chestAnimation = new AnimationContainer(MovieClipAsset.PackCommon, true/*, _chestData.openAnimationTimeline*/);
			chestAnimation.pivotX = 16 * pxScale;
			chestAnimation.pivotY = 72 * pxScale;
			chestAnimation.x = 325 * pxScale;
			chestAnimation.y = 432 * pxScale;
			chestAnimation.playTimeline(_chestData.openAnimationTimeline, true, true);
			addChild(chestAnimation);
			
			chestAnimation.addClipEventListener("animationEventAppear", handler_animationFrameAppearFinish);
			chestAnimation.addEventOnFrame(animationParams[0], "animationEventAppear");
			
			chestAnimation.addClipEventListener("animationEventOpened", handler_animationFrameOpenedFinish);
			chestAnimation.addEventOnFrame(animationParams[1], "animationEventOpened");
			
			chestAnimation.addClipEventListener("animationEventFinish", handler_animationFramesFinish);
			chestAnimation.addEventOnFrame(chestAnimation.totalFrames, "animationEventFinish");
			
			chestAnimation.addAnimationSequence(APPEAR_CHEST_CYCLE_SEQUENCE, animationParams[2], animationParams[3]);
			chestAnimation.addAnimationSequence(FIRST_GOOD_BLINK_CYCLE_SEQUENCE, animationParams[4], animationParams[5]);
			chestAnimation.addAnimationSequence(NEXT_GOOD_BLINK_CYCLE_SEQUENCE, animationParams[6], animationParams[7]);
			
			puffImage = new Image(AtlasAsset.CommonAtlas.getTexture("effects/puff_ball"));
			puffImage.alignPivot();
			puffImage.alpha = 0;
			puffImage.y = 335* pxScale;
			puffImage.x = 336 * pxScale;
			puffImage.scale = 1.2;
			addChild(puffImage);
			
			cardsIcon = new Image(AtlasAsset.CommonAtlas.getTexture("icons/cards_empty"));
			cardsIcon.alignPivot();
			cardsIcon.scaleY = 0;
			cardsIcon.y = 351* pxScale;
			cardsIcon.x = (_chestData.isSuperTypeAssets ? 474 : 447) * pxScale;
			addChild(cardsIcon);
			
			var showItemIndex:int = _chestData.prizes.length-1;
			cardsLabel = new XTextField(70 * pxScale, 75 * pxScale, showItemIndex < 10 ? XTextFieldStyle.ChestOpenCardCountNormal : XTextFieldStyle.ChestOpenCardCountSmall, showItemIndex.toString());
			cardsLabel.alignPivot();
			cardsLabel.x = cardsIcon.x + 9*pxScale;
			cardsLabel.y = cardsIcon.y - 2*pxScale;
			cardsLabel.scaleY = 0;
			addChild(cardsLabel);
			
			
			shineImage = new Image(AtlasAsset.CommonAtlas.getTexture("effects/shine_rays"));
			shineImage.pivotX = 99*pxScale;
			shineImage.pivotY = 96*pxScale;
			shineImage.scale = 0;
			shineImage.x = 633 * pxScale;
			shineImage.y = 240 * pxScale;
			shineImage.color = 0x66FFCD;
			shineImage.blendMode = BlendMode.ADD;
			addChild(shineImage);
			
			particleEffect = new ParticleExplosion(AtlasAsset.CommonAtlas, "effects/puff_ball", new <uint> [0x98FFFE]);
			particleEffect.x = 643 * pxScale;
			particleEffect.y = 240 * pxScale;
			particleEffect.setProperties(0, 130*pxScale, 2.8, -0.012, 0, 0, 0.3);
			particleEffect.setFineProperties(0.5, 0.4, 0.1, 2, 0, 0);
			particleEffect.setDirectionAngleProperties(0.03, 18, 0);
			addChild(particleEffect);
			//particleEffect.play(0, 30, 0);
			
			awardImage = new AwardImageAssetContainer();
			//awardImage.alignPivot();
			awardImage.scale = 0;
			awardImage.rotation = CARD_START_ROTATION;
			awardImage.x = 500 * pxScale;
			awardImage.y = 227 * pxScale;
			addChild(awardImage);
			
			var cardDescriptionX:int = cardFinishX + awardImage.pivotX + 41 * pxScale;
			var cardDescriptionY:int = awardImage.y - awardImage.pivotY;
			
			titleLabel = new XTextField(300 * pxScale, 65 * pxScale, XTextFieldStyle.getWalrus(62, 0x98FFFE, Align.LEFT).setStroke(), "RARE");
			//titleLabel.alignPivot();
			titleLabel.x = cardDescriptionX - 1*pxScale + DESCRIPTIONS_TWEEN_X;
			titleLabel.y = cardDescriptionY + 38 * pxScale;
			titleLabel.alpha = 0;
			addChild(titleLabel);
			
			typeTitleLabel = new XTextField(500 * pxScale, 44 * pxScale, XTextFieldStyle.getWalrus(37, 0xFFFFFF, Align.LEFT).setStroke(), "RED DRAGON");
			//typeTitleLabel.alignPivot();
			typeTitleLabel.x = cardDescriptionX + DESCRIPTIONS_TWEEN_X;
			typeTitleLabel.y = cardDescriptionY + 98 * pxScale;
			typeTitleLabel.alpha = 0;
			addChild(typeTitleLabel);
			
			descriptionTitle = new XTextField(500 * pxScale, 30 * pxScale, XTextFieldStyle.getWalrus(24, 0xFFFFFF, Align.LEFT).setStroke(), "COLLECTION 2");
			//descriptionTitle.alignPivot();
			descriptionTitle.x = cardDescriptionX + 2*pxScale + DESCRIPTIONS_TWEEN_X;
			descriptionTitle.y = cardDescriptionY + 138 * pxScale;
			descriptionTitle.alpha = 0;
			addChild(descriptionTitle);
			
			
			resourceProgressView = new ChestGoodView(AtlasAsset.CommonAtlas, "bars/base_glow", null, 0, 'bars/energy', XTextFieldStyle.getWalrus(33, 0xFFFFFF).setShadow(), ChestGoodView.TWEEN_TYPE_VALUE, '189');
			resourceProgressView.setProperties(15*pxScale, -2, 0, 3);
			resourceProgressView.x = cardDescriptionX + 8*pxScale + DESCRIPTIONS_TWEEN_X;
			resourceProgressView.y = cardDescriptionY + 209 * pxScale;
			resourceProgressView.visible = false;
			resourceProgressView.alpha = 0;
			addChild(resourceProgressView);
			
			dustView = new ChestDustIndicator();
			dustView.x = cardDescriptionX + 8*pxScale + DESCRIPTIONS_TWEEN_X;
			dustView.y = cardDescriptionY + (209) * pxScale;
			dustView.visible = false;
			dustView.alpha = 0;
			dustView.setProperties(24*pxScale, 3*pxScale);
			addChild(dustView);
			
			
			var i:int = numChildren-1;
			while (i>=0) {
				getChildAt(i--).touchable = false;
			}
			
			//tweenFirstOpen();
			chestAnimation.play();
			
			///lastTapTimeout = getTimer();
		}
		
		public function resize():void
		{
			
		}
		
		// открывает сразу 1 айтем
		/*private function tweenFirstOpen():void
		{
			chestAnimation.play();
			
			var delay:Number = 2.17;
			
			showPuffTween(0.3 + delay);
			
			Starling.juggler.add(getTweensCardAppear(0.22 + 0.25 + delay));
			
			EffectsManager.showFullscreenSplash(Game.current.currentScreen as DisplayObjectContainer, 0.4, 0.1 + delay);
			
			DelayCallUtils.add(Starling.juggler.delayCall(tweenShowItem, 0.61 + delay), DELAY_CALLS_BUNDLE);
			
			refreshCurrentCardTexture();
		}*/
			
		private function tweenHide():void
		{
			if (isHiding)
				return;
			
			removeEventListener(Event.ENTER_FRAME, handler_advanceTimeEnterFrame);
			
			//trace('total accelerated hide time:', ((getTimer() - startAccelerateTime)/1000 + 0.7).toFixed(2));	
				
			isHiding = true;
			
			gameManager.chestsData.removeEventListener(ChestsData.EVENT_ACCELERATE_CHEST_TAKE_OUT_DIALOG, handler_accelerateTakeOut);
			
			//tweenHideItem();
			
			Starling.juggler.tween(chestAnimation, 0.6, {transition:Transitions.EASE_IN_BACK, scale:0});
			
			while (allCardViews.length > 0) {
				//Starling.juggler.tween(allCardViews.pop(), 0.3, {x:(layoutHelper.stageWidth/2), y:layoutHelper.stageHeight, scale:0, delay:(allCardViews.length*0.05), transition:Transitions.EASE_IN_BACK});
				Starling.juggler.tween(allCardViews.pop(), 0.3, {scale:0, delay:(allCardViews.length*0.05), transition:Transitions.EASE_IN_BACK});
			}
			
			if(nextButton)
				Starling.juggler.tween(nextButton, 0.35, {x:(nextButton.x + 100*pxScale), alpha:0, transition:Transitions.EASE_IN});
			
			Starling.juggler.delayCall(callCallbackAndRemove, 0.7);
			
			Starling.juggler.tween(titleLabel, 0.2, {transition:Transitions.EASE_IN, delay:0.1, alpha:0, x:(titleLabel.x + 100*pxScale)});
		}
		
		private function callCallbackAndRemove():void
		{
			if (completeCallback != null) {
				completeCallback(this);
				completeCallback = null;
			}
			
			removeFromParent();
			
			// update players cash and powerups values:
			if(callShowReservedDrops)
				new ShowReservedDrops(0.5).execute();
		}
		
		private function handler_nextButtonClick(e:Event):void 
		{
			nextButton.touchable = false;
			takeOutNextItemOrClose(true);
		}
		
		public function close():void 
		{
			takeOutNextItemOrClose();
			clickCount++;
		}
		
		/* INTERFACE com.alisacasino.bingo.dialogs.IDialog */
		
		public function get selfScaled():Boolean 
		{
			return false;
		}
		
		public function get baseScale():Number
		{
			return layoutHelper.independentScaleFromEtalonMin;
		}
		
		private function takeOutNextItemOrClose(ingnoreTimeout:Boolean = false):void 
		{
			if (isHiding)
				return;
			
			var tapDelayTimeout:Number = TAP_DELAY_TIMEOUT + ((_chestData.isSuperTypeAssets && currentItemIndex == 0) ? 2100 : 0);	
			
			if (isTakeOutNextItemInProgress) {
				accelerateTweens();
				if (!ingnoreTimeout && (getTimer() - lastTapTimeout) < tapDelayTimeout) {
					return;
				}
			}
			
			DelayCallUtils.cleanBundle(DELAY_CALLS_BUNDLE);	
			removeTweens();
			
			isTakeOutNextItemInProgress = true;
				
			lastTapTimeout = getTimer();
			
			if (clickCount != 0)
				currentItemIndex++;
			
			if (currentItemIndex < _chestData.prizes.length) 
			{
				takeOutNextItem();
				return;
			}
			
			if (!totalCardsShows) {
				totalCardsShows = true;
				showAllCards();
				
				if (acceleratedAutoTakeOut)
					Starling.juggler.delayCall(takeOutNextItemOrClose, 1.2, true);
					
				return;
			}
			/*else {
				if (acceleratedAutoTakeOut)
					Starling.juggler.delayCall(takeOutNextItemOrClose, 1.2, true);
			}*/
			
			tweenHide();
		}
		
		private function takeOutNextItem():void 
		{
			var delay:Number = _chestData.openAnimationDelayShift;
			
			commodityItemMessage = null;
			collectionItem = null;
			chestPowerupPack = null;
			customizerCard = null;
			
			var prize:* = _chestData.prizes[currentItemIndex];
			var tweenOpenSoundAsset:SoundAsset;
			
			if (prize is CommodityItemMessage) {
				commodityItemMessage = prize as CommodityItemMessage;
				tweenOpenSoundAsset = SoundAsset.OpenChestResourcesCard;
			}
			else if (prize is CollectionItem) {
				collectionItem = prize as CollectionItem;
				tweenOpenSoundAsset = SoundAsset.OpenChestCollectionCard;
			}
			else if (prize is ChestPowerupPack) {
				chestPowerupPack = prize as ChestPowerupPack;
				tweenOpenSoundAsset = SoundAsset.OpenChestResourcesCard;
			}
			else if (prize is CustomizerItemBase)
			{
				customizerCard = prize as CustomizerItemBase;
				tweenOpenSoundAsset = SoundAsset.OpenChestCollectionCard;
			}
			
			//allPrizes.push();	
				
			if (currentItemIndex == 0 && !acceleratedAutoTakeOut)
			{
				// первый айтем выдается немного по-другому:
				chestAnimation.clearSequence(APPEAR_CHEST_CYCLE_SEQUENCE);
				
				chestAnimation.goToAndPlay(animationParams[8]);
				
				delay += 0.17;
			
				showPuffTween(0.3 + delay);
				
				Starling.juggler.add(getTweensCardAppear(0.47 + delay));
				
				EffectsManager.showFullscreenSplash((Game.current.currentScreen as GameScreen).frontLayer, 0.4, 0.1 + delay);
				
				DelayCallUtils.add(Starling.juggler.delayCall(tweenShowItem, 0.61 + delay), DELAY_CALLS_BUNDLE);
				
				if (_chestData.isSuperTypeAssets) {
					SoundManager.instance.playSfx(SoundAsset.SuperChestRattleV2);
					SoundManager.instance.playSfx(SoundAsset.OpenChestChestOpen, 2);
				}
				else {
					SoundManager.instance.playSfx(SoundAsset.OpenChestChestOpen);
				}
				
				//refreshCurrentCardTexture();
			}
			else
			{
				//currentItemIndex++;
				chestAnimation.clearSequence(APPEAR_CHEST_CYCLE_SEQUENCE);
				
				chestAnimation.clearSequence(FIRST_GOOD_BLINK_CYCLE_SEQUENCE);
				chestAnimation.goToAndPlay(animationParams[9]);
				
				// alarm: следующий айтем начинает появляться уже в tweenHideItem, а продолжает в tweenShowItem.
				tweenHideItem(true);
				
				SoundManager.instance.playSfx(tweenOpenSoundAsset);
				DelayCallUtils.add(Starling.juggler.delayCall(tweenShowItem, 0.61), DELAY_CALLS_BUNDLE);
			}
		}
		
		private function tweenHideItem(isExpectNextItem:Boolean = false):void 
		{
			// некоторые твины появления следующего айтема должны начаться еще до конца всех анимации скрытия предыщего:
			var tweenCardAppear:Tween;
			if (isExpectNextItem) 
			{
				showPuffTween(0.3);
				tweenCardAppear = getTweensCardAppear(0.22);
			}
			
			var tweenCard_0:Tween = new Tween(awardImage, 0.1, Transitions.LINEAR);
			var tweenCard_1:Tween = new Tween(awardImage, 0.15, Transitions.EASE_IN);
			
			tweenCard_0.animate('rotation', -(4 * Math.PI) / 180);
			tweenCard_0.animate('scale', 1.1);
			tweenCard_0.nextTween = tweenCard_1;
			
			tweenCard_1.animate('scale', 0);
			tweenCard_1.animate('rotation', (4 * Math.PI) / 180);
			tweenCard_1.nextTween = tweenCardAppear;
			Starling.juggler.add(tweenCard_0);
	
			Starling.juggler.removeTweens(shineImage);
			
			Starling.juggler.tween(shineImage, 0.2, {transition:Transitions.EASE_IN, delay:0.1, scale:0});
			
			Starling.juggler.tween(titleLabel, 0.2, {transition:Transitions.EASE_IN_BACK, delay:0.1, alpha:0, x:(titleLabel.x + DESCRIPTIONS_TWEEN_X)});
			Starling.juggler.tween(typeTitleLabel, 0.2, {transition:Transitions.EASE_IN_BACK, delay:0.13, alpha:0, x:(typeTitleLabel.x + DESCRIPTIONS_TWEEN_X)});
			Starling.juggler.tween(descriptionTitle, 0.2, {transition:Transitions.EASE_IN_BACK, delay:0.16, alpha:0, x:(descriptionTitle.x + DESCRIPTIONS_TWEEN_X)});
			var progressViewObject:DisplayObject = resourceProgressView.visible ? resourceProgressView : dustView;
			Starling.juggler.tween(progressViewObject, 0.2, {transition:Transitions.EASE_IN_BACK, delay:0.19, alpha:0, x:(progressViewObject.x + DESCRIPTIONS_TWEEN_X)});
			
			Starling.juggler.tween(cardsIcon, 0.3, {transition:Transitions.EASE_IN_BACK, delay:0.3, scaleY:0});
			Starling.juggler.tween(cardsLabel, 0.3, {transition:Transitions.EASE_IN_BACK, delay:0.3, scaleY:0});
			
			resourceProgressView.hide(0.22);
			dustView.hide(0.22);
			
			particleEffect.stop();
			
			showRareAnimation(false);
			
			var powerupView:PowerUpView;
			while (powerupViews.length > 0) {
				powerupView = powerupViews.pop();
				Starling.juggler.tween(powerupView, 0.15, {x:(powerupView.x + 150*pxScale), delay:(powerupViews.length * 0.1), alpha:0, onComplete:removeView, onCompleteArgs:[powerupView], transition:Transitions.EASE_IN});
			}
			
			if (nextButton) 
				Starling.juggler.tween(nextButton, 0.35, {x:(nextButton.x + 100 * pxScale), delay:0.2, alpha:0, transition:Transitions.EASE_OUT_BACK});
				
			SoundManager.instance.playSfx(SoundAsset.OpenChestChestReopen);	
		}
		
		// твины параметров(имя, описание, прогресс) айтема 
		private function tweenShowItem(delay:Number = 0):void 
		{
			var numberLabelValue:String = '';
			var progressValue:Number = 0;
			
			var powerupView:PowerUpView;
			while (powerupViews.length > 0) {
				powerupView = powerupViews.pop();
				Starling.juggler.removeTweens(powerupView);
				powerupView.removeFromParent();
			}
			
			if (_chestData.prizes) {
				var showItemIndex:int = _chestData.prizes.length - currentItemIndex - 1;
				cardsLabel.textStyle = showItemIndex < 10 ? XTextFieldStyle.ChestOpenCardCountNormal : XTextFieldStyle.ChestOpenCardCountSmall;
				cardsLabel.text = showItemIndex.toString();
			}
			
			var isRareAssets:Boolean =  _chestData.isSuperTypeAssets;	
			
			if (commodityItemMessage) 
			{
				resourceProgressView.visible = true;
				dustView.visible = false;
				
				// кэш
				if (commodityItemMessage.type == Type.CASH)
				{
					startCashValue += commodityItemMessage.quantity; 
				
					titleLabel.textStyle = XTextFieldStyle.ChestCardTitlePurple// getWalrus(62, 0xE78BFF, Align.LEFT).setStroke();
					titleLabel.text = "+" + commodityItemMessage.quantity.toString();
					typeTitleLabel.textStyle = XTextFieldStyle.ChestCardTypeWhite;//XTextFieldStyle.ChestCardTypePurple;
					typeTitleLabel.text = "CASH";
					descriptionTitle.text = "RESOURCE CARD";
					
					resourceProgressView.reInit(AtlasAsset.CommonAtlas, "bars/base_glow", 'bars/cash', XTextFieldStyle.getWalrus(33, 0xFFFFFF).setShadow(), ChestGoodView.TWEEN_TYPE_VALUE);
					resourceProgressView.setProperties(-5*pxScale, -2*pxScale, 36*pxScale, 3*pxScale);
					resourceProgressView.value = startCashValue.toString();
					numberLabelValue = commodityItemMessage.quantity.toString();
				}
				else {
					titleLabel.text = "UNKNOWN COMMODITY TYPE ITEM";
					typeTitleLabel.text = "TYPE: " + commodityItemMessage.type.toString();
					descriptionTitle.text = "COUNT: " + commodityItemMessage.quantity.toString();
					
				}
			}
			else if (chestPowerupPack)  
			{
				startPowerupValue += chestPowerupPack.totalQuantity;
				
				resourceProgressView.visible = true;
				dustView.visible = false;
				
				titleLabel.textStyle = chestPowerupPack.titleTextStyle; //XTextFieldStyle.getWalrus(62, 0x98FFFE, Align.LEFT).setStroke();
				titleLabel.text = "+" + chestPowerupPack.totalQuantity.toString();
				typeTitleLabel.textStyle = XTextFieldStyle.ChestCardTypeWhite;
				typeTitleLabel.text = "POWER-UP" + (chestPowerupPack.totalQuantity <= 1 ? "" : "S");//"ENERGY";
				descriptionTitle.text = "RESOURCE CARD";
				
				resourceProgressView.reInit(AtlasAsset.CommonAtlas, "bars/base_glow", 'bars/energy', XTextFieldStyle.getWalrus(33, 0xFFFFFF).setShadow(), ChestGoodView.TWEEN_TYPE_VALUE);
				resourceProgressView.setProperties(-5*pxScale, -2*pxScale, 36*pxScale, 3*pxScale);
				resourceProgressView.value = startPowerupValue.toString();
				
				showPowerupsItems(chestPowerupPack);
				
				numberLabelValue = chestPowerupPack.totalQuantity.toString();
			}
			else if (collectionItem) 
			{
				// коллекции
				
				gameManager.collectionsData.collectionDropItems.push(collectionItem);
				
				var userCollectionItem:CollectionItem = gameManager.collectionsData.getItemByID(collectionItem.id);
				var userCollection:Collection = gameManager.collectionsData.getCollectionByID(collectionItem.id);
				
				titleLabel.textStyle = XTextFieldStyle.getWalrus(62, 0x98FFFE, Align.LEFT).setStroke();
				titleLabel.text = collectionItem.rarityString;// Math.random() > 0.5 ? "RARE" : "BASIC";
				typeTitleLabel.textStyle = XTextFieldStyle.ChestCardTypeWhite;
				typeTitleLabel.text = collectionItem.name;
				descriptionTitle.text = collectionItem.collection.name;
				
				collectionStartValues[collectionItem.id] += Math.max(1, collectionItem.duplicates);	
					
				resourceProgressView.visible = false;
				dustView.visible = true;
				
				dustView.numberValue = collectionItem.dustGain * Math.max(1, collectionItem.duplicates);
				//TODO: here
				//numberLabelValue = '1';
			}
			else if (customizerCard)
			{
				// customizers
				
				gameManager.skinningData.customizerDropItems.push(customizerCard);
				
				titleLabel.textStyle = XTextFieldStyle.getWalrus(62, 0x98FFFE, Align.LEFT).setStroke();
				titleLabel.text = customizerCard.rarityString;// Math.random() > 0.5 ? "RARE" : "BASIC";
				typeTitleLabel.textStyle = XTextFieldStyle.ChestCardTypeWhite;
				typeTitleLabel.text = customizerCard.name;
				descriptionTitle.text = customizerCard.getTypeLabel();
				
				resourceProgressView.visible = false;
				dustView.visible = true;	
				
				dustView.numberValue = customizerCard.quantity * customizerCard.dustGain;
			}
			else 
			{
				titleLabel.text = "UNKNOWN ITEM";
				typeTitleLabel.text = "UNKNOWN ITEM";
				descriptionTitle.text = "UNKNOWN ITEM";
				
				resourceProgressView.visible = false;
			}
			
			cardsNumberLabelValuesSources.push(numberLabelValue);
			
			// tweens:
			
			DelayCallUtils.add(Starling.juggler.delayCall(particleEffect.play, 0.3, 0, 30), DELAY_CALLS_BUNDLE);
			
			Starling.juggler.tween(cardsIcon, 0.3, {transition:Transitions.EASE_OUT_BACK, delay:delay, scaleY:1});
			Starling.juggler.tween(cardsLabel, 0.3, {transition:Transitions.EASE_OUT_BACK, delay:delay, scaleY:1});
			
			
			if (isRareAssets) {
				shineImage.texture = AtlasAsset.CommonAtlas.getTexture("effects/rays_0");
				shineImage.readjustSize();
				shineImage.alignPivot();
			}
			else {
				shineImage.texture = AtlasAsset.CommonAtlas.getTexture("effects/shine_rays");
				shineImage.readjustSize();
				shineImage.pivotX = 99*pxScale;
				shineImage.pivotY = 96*pxScale;
			}
			
			Starling.juggler.tween(shineImage, 0.2, {
				transition:Transitions.EASE_OUT_BACK, 
				delay:0, 
				scale:isRareAssets ? 2 : 2.7, 
				onComplete:cycleRotateShineImage, 
				onCompleteArgs:[shineImage.rotation + 5]});
			
			var cardDescriptionX:int = cardFinishX + awardImage.pivotX + 41 * pxScale;
			
			titleLabel.x = cardDescriptionX - 1*pxScale + DESCRIPTIONS_TWEEN_X;
			typeTitleLabel.x = cardDescriptionX + DESCRIPTIONS_TWEEN_X;
			descriptionTitle.x = cardDescriptionX + 2*pxScale + DESCRIPTIONS_TWEEN_X;
			
			
			Starling.juggler.tween(titleLabel, 0.2, {transition:Transitions.EASE_OUT_BACK, delay:0.1, alpha:1, x:(cardDescriptionX - 1*pxScale)});
			Starling.juggler.tween(typeTitleLabel, 0.2, {transition:Transitions.EASE_OUT_BACK, delay:0.13, alpha:1, x:(cardDescriptionX)});
			Starling.juggler.tween(descriptionTitle, 0.2, {transition:Transitions.EASE_OUT_BACK, delay:0.16, alpha:1, x:(cardDescriptionX + 2*pxScale), onComplete:setTakeOutNextItemInProgress, onCompleteArgs:[false]});
			
			if (resourceProgressView.visible) {
				resourceProgressView.x = cardDescriptionX + 8*pxScale + DESCRIPTIONS_TWEEN_X;
				Starling.juggler.tween(resourceProgressView, 0.2, {transition:Transitions.EASE_OUT_BACK, delay:0.19, alpha:1, x:(cardDescriptionX + 8*pxScale)});
				resourceProgressView.show(0.3);
			}
			else
			{
				dustView.x = cardDescriptionX + 8*pxScale + DESCRIPTIONS_TWEEN_X;
				Starling.juggler.tween(dustView, 0.2, {transition:Transitions.EASE_OUT_BACK, delay:0.19, alpha:1, x:(cardDescriptionX + 3*pxScale)});
				dustView.show(0.3);
			}
			
			if(isRareAssets)
				showRareAnimation(true);

			if (currentItemIndex >= (_chestData.prizes.length - 1) && !acceleratedAutoTakeOut) 
			{
				createNextButton();
				Starling.juggler.tween(nextButton, 0.35, {x:nextButtonFinishX, delay:0.4, alpha:2, transition:Transitions.EASE_OUT_BACK, onStart:setNextButtonTouchable, onStartArgs:[true]});
			}
		}
		
		private function showPowerupsItems(pack:ChestPowerupPack):void
		{
			var powerupView:PowerUpView;
			var key:String;
			for (key in pack.powerupData) {
				powerupView = new PowerUpView(key, int(pack.powerupData[key]));
				powerupViews.push(powerupView);
			}
			
			var i:int;
			var length:int = powerupViews.length;
			var gap:int = 180*pxScale//Math.min(190*pxScale ,(layoutHelper.stageWidth - cardFinishX)/powerupViews.length);
			for (i = 0; i < length; i++) {
				powerupView = powerupViews[i];
				powerupView.x = cardFinishX + i * gap - 150 * pxScale;
				powerupView.y = cardFinishY + 240 * pxScale;
				powerupView.alpha = 0;
				addChild(powerupView);
				
				Starling.juggler.tween(powerupView, 0.25, {x:(cardFinishX + i*gap), delay:(0.2 + (length - i - 1) * 0.1), alpha:2, transition:Transitions.EASE_OUT});
			}
		}
		
		private function cycleRotateShineImage(angle:Number):void
		{
			Starling.juggler.tween(shineImage, 8, {transition:Transitions.LINEAR, rotation:(shineImage.rotation + angle), onComplete:cycleRotateShineImage, onCompleteArgs:[angle]});
		}
		
		private function getTweensCardAppear(delay:Number):Tween
		{
			var tweenCardPrepare:Tween = new Tween(awardImage, 0.001, Transitions.LINEAR);
			var tweenCard_0:Tween = new Tween(awardImage, 0.25, Transitions.EASE_OUT);
			var tweenCard_1:Tween = new Tween(awardImage, 0.13, Transitions.EASE_IN);
			var tweenCard_2:Tween = new Tween(awardImage, 0.18, Transitions.EASE_OUT_BACK);
			
			tweenCardPrepare.delay = delay;
			tweenCardPrepare.animate('scale', 0.32);
			tweenCardPrepare.animate('rotation', CARD_START_ROTATION);
			tweenCardPrepare.moveTo(500 * pxScale, 227 * pxScale);
			tweenCardPrepare.onStart = refreshCurrentCardTextureAndSettings;
			tweenCardPrepare.nextTween = tweenCard_0;
			
			tweenCard_0.animate('rotation', (16 * Math.PI) / 180);
			tweenCard_0.animate('scaleX', 0.86);
			tweenCard_0.animate('scaleY', 1.03);
			tweenCard_0.moveTo(658*pxScale, 250*pxScale);
			tweenCard_0.nextTween = tweenCard_1;
			
			tweenCard_1.animate('rotation', -(4 * Math.PI) / 180);
			tweenCard_1.animate('scaleX', 1.02);
			tweenCard_1.animate('scaleY', 0.92);
			tweenCard_1.moveTo(618*pxScale, 243*pxScale);
			tweenCard_1.nextTween = tweenCard_2;
			
			tweenCard_2.animate('rotation', 0);
			tweenCard_2.animate('scaleX', 1);
			tweenCard_2.animate('scaleY', 1);
			tweenCard_2.moveTo(cardFinishX, cardFinishY);
		
			//Starling.juggler.add(tweenCardPrepare);
			return tweenCardPrepare;
		}
		
		private function showPuffTween(delay:Number):void 
		{
			puffImage.alpha = 0;
			puffImage.y = 335* pxScale;
			puffImage.x = 336 * pxScale;
			puffImage.scale = 1.2;
			
			var puffTween_0:BezierTween = new BezierTween(puffImage, 0.34, new <Point>[new Point(335* pxScale, 336 * pxScale),new Point(410 * pxScale, 162 * pxScale), new Point(cardFinishX, cardFinishY)], BezierTween.SPEED_DEFAULT, BezierTween.ACCURACY_FINE, Transitions.LINEAR);
			var puffTween_1:Tween = new Tween(puffImage, 2 + 0.01, Transitions.LINEAR);
			
			puffTween_0.delay = delay;
			puffTween_0.animate('alpha', 20);
			puffTween_0.animate('scale', 5);
			puffTween_0.nextTween = puffTween_1;
			
			puffTween_1.animate('alpha', 0);
			
			Starling.juggler.add(puffTween_0);
		}
		
		private function refreshCurrentCardTextureAndSettings():void 
		{
			var cardSource:*;
			var glowSource:*;
			var isCollection:Boolean;
			
			if (commodityItemMessage) 
			{
				if (commodityItemMessage.type == Type.CASH)
					cardSource = AtlasAsset.CommonAtlas.getTexture("cards/cash");
				else
					cardSource = AtlasAsset.CommonAtlas.getTexture("cards/gold_bg");
					
				glowSource = "cards/card_glow_cian";
			}
			else if (collectionItem) 
			{
				cardSource = collectionItem.image;
				glowSource = collectionItem.rarityGlowBg;
				isCollection = true;
			}
			else if (chestPowerupPack) 
			{
				cardSource = AtlasAsset.CommonAtlas.getTexture(chestPowerupPack.cardTexture);
				glowSource = "cards/card_glow_cian";
			}
			else if (customizerCard)
			{
				cardSource = customizerCard.uiAsset;
				glowSource = customizerCard.rarityGlowBg;
				isCollection = true;
			}
			else 
			{
				cardSource = AtlasAsset.CommonAtlas.getTexture("cards/gold_bg");
				glowSource = "cards/card_glow_cian";
			}
			
			awardImage.texture = cardSource;
			cardsSources.push(cardSource);
			cardsGlowSources.push(glowSource);
			cardsTypesIsCollection.push(isCollection);
		}
		
		private function removeTweens():void 
		{
			Starling.juggler.removeTweens(shineImage);
			Starling.juggler.removeTweens(puffImage);
			puffImage.alpha = 0;
			
			Starling.juggler.removeTweens(titleLabel);
			Starling.juggler.removeTweens(typeTitleLabel);
			Starling.juggler.removeTweens(descriptionTitle);
			
			Starling.juggler.removeTweens(resourceProgressView);
			resourceProgressView.hide(0, true);
			
			Starling.juggler.removeTweens(dustView);
			dustView.hide(0, true);
			
			Starling.juggler.removeTweens(awardImage);
			
			if (rareAnimationMagicFx) {
				Starling.juggler.removeTweens(rareAnimationMagicFx);
				Starling.juggler.removeTweens(rareAnimationMagicSlash);
			}
			
			DelayCallUtils.cleanBundle(DELAY_CALLS_BUNDLE);
			
			EffectsManager.clearFullscreenSplash();
			
			isTakeOutNextItemInProgress = false;
			
			/*var powerupView:PowerUpView;
			while (powerupViews.length > 0) {
				powerupView = powerupViews.pop();
				Starling.juggler.removeTweens(powerupView);
				powerupView.removeFromParent();
				trace('3remove ', getTimer());
			}*/
		}
		
		private function get cardFinishX():int {
			return 636 * pxScale;
		}
		
		private function get cardFinishY():int {
			return 249 * pxScale;
		}
		
		private function handler_animationFrameAppearFinish(event:Event):void {
			//chestAnimation.removeClipEventListener("animationEventOpened", handler_animationFrameOpenedFinish);
			chestAnimation.playSequence(APPEAR_CHEST_CYCLE_SEQUENCE);
		}
		
		private function handler_animationFrameOpenedFinish(event:Event):void {
			//chestAnimation.removeClipEventListener("animationEventOpened", handler_animationFrameOpenedFinish);
			chestAnimation.playSequence(FIRST_GOOD_BLINK_CYCLE_SEQUENCE);
		}
		
		private function handler_animationFramesFinish(event:Event):void {
			//chestAnimation.removeClipEventListener("animationEventFinish", handler_animationFramesFinish);
			chestAnimation.playSequence(NEXT_GOOD_BLINK_CYCLE_SEQUENCE);
		}
		
		private function handler_removedFromStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, handler_removedFromStage);
			if (completeCallback != null)
				completeCallback(this);
		}
		
		private function showRareAnimation(value:Boolean):void
		{
			if (value)
			{
				if (!rareAnimationMagicFx) {
					rareAnimationMagicFx = new AnimationContainer(MovieClipAsset.PackCommon, true, true);
					rareAnimationMagicFx.scale = 0;
					rareAnimationMagicFx.x = cardFinishX;
					rareAnimationMagicFx.y = cardFinishY;
					rareAnimationMagicFx.touchable = false;
					addChildAt(rareAnimationMagicFx, getChildIndex(particleEffect) + 1);	
					//addChild(rareAnimationMagicFx);	
			
					rareAnimationMagicSlash = new AnimationContainer(MovieClipAsset.PackCommon, false, true);
					//rareAnimationMagicSlash.alignPivot();
					rareAnimationMagicSlash.x = cardFinishX;
					rareAnimationMagicSlash.y = cardFinishY;
					rareAnimationMagicSlash.scale = 0;
					rareAnimationMagicSlash.blendMode = BlendMode.ADD;
					rareAnimationMagicSlash.touchable = false;
					addChild(rareAnimationMagicSlash);
				}
				
				//rareAnimationMagicFx.scale = 1.2;
				
				rareAnimationMagicSlash.scale = 5;
				rareAnimationMagicSlash.x = cardFinishX;
				rareAnimationMagicSlash.y = cardFinishY;
				
				Starling.juggler.tween(rareAnimationMagicFx, 0.05, {transition:Transitions.LINEAR, scale:4});
				rareAnimationMagicFx.playTimeline('magic_fx', true, true);
				
				rareAnimationMagicSlash.playTimeline('magic_slash', true);
				rareAnimationMagicSlash.goToAndPlay(0);
				Starling.juggler.tween(rareAnimationMagicSlash, 0.05, {transition:Transitions.LINEAR, scale:4});
			}
			else
			{
				if (rareAnimationMagicFx) {
					Starling.juggler.tween(rareAnimationMagicFx, 0.05, {transition:Transitions.LINEAR, scale:0, x:cardFinishX, y:cardFinishY});
					Starling.juggler.tween(rareAnimationMagicSlash, 0.05, {transition:Transitions.LINEAR, scale:0, x:cardFinishX, y:cardFinishY});
				}
			}
			
		}
		
		private function showAllCards():void
		{
			tweenHideItem();
			DelayCallUtils.add(Starling.juggler.delayCall(tweenShowAllCards, 0.35), DELAY_CALLS_BUNDLE);
		}
		
		private function tweenShowAllCards(delay:Number = 0):void
		{
			var length:int = cardsSources.length;
			var cardsAlignSettings:AllCardsAlignSettings = AllCardsAlignSettings.getCardsSettings(length);
			var cardY:int = cardFinishY + cardsAlignSettings.cardsShiftY;
			
			var i:int;
			var cardView:AwardImageAssetContainer;
			var cardScale:Number = cardsAlignSettings.scale;
			var onComplete:Function;
			var onCompleteArgs:Array;
			
			for (i = 0; i < length; i++) 
			{
				cardView = new AwardImageAssetContainer(cardsSources[i], cardsGlowSources[i], cardsNumberLabelValuesSources[i], cardsTypesIsCollection[i]);
				cardView.x = cardsAlignSettings.commonShiftX + cardFinishX + (i%cardsAlignSettings.columns) * cardsAlignSettings.gapHorisontal - 150 * pxScale;
				cardView.y = cardY + Math.floor(i/cardsAlignSettings.columns) * cardsAlignSettings.gapVertical;
				cardView.alpha = 0;
				cardView.scale = cardScale;
				addChild(cardView);
				allCardViews.push(cardView);
				
				if (i == (length - 1)) {
					onComplete = setTakeOutNextItemInProgress;
					onCompleteArgs = [false];
				}
				
				Starling.juggler.tween(cardView, 0.35, {x:(cardsAlignSettings.commonShiftX + cardFinishX + (i % cardsAlignSettings.columns) * cardsAlignSettings.gapHorisontal), delay:(delay + i * Math.floor(i / cardsAlignSettings.columns) * cardsAlignSettings.delayPerCard),
														alpha:2, transition:Transitions.EASE_OUT, onComplete:onComplete, onCompleteArgs:onCompleteArgs});
				//EffectsManager.scaleJumpAppearElastic(cardView, cardScale, 0.3, i * 0.05);
			}
			
			var titleLabelFinishX:Number = cardsAlignSettings.commonShiftX + cardFinishX - (AwardImageAssetContainer.WIDTH / 2) * pxScale * cardScale;
			titleLabel.textStyle = XTextFieldStyle.getWalrus(41, 0x00FFB9, Align.LEFT);//.setStroke();
			titleLabel.text = "YOU GOT:";
			titleLabel.y = cardY + cardsAlignSettings.titleLabelShiftY;
			titleLabel.x = cardsAlignSettings.commonShiftX + titleLabelFinishX - 100*pxScale;
			Starling.juggler.tween(titleLabel, 0.2, {transition:Transitions.EASE_OUT_BACK, delay:(delay + 0.1), alpha:1, x:titleLabelFinishX});
			
			// случай затапывания без включенного ускорения самооткрытия:
			if (startAccelerateTime == 0 && acceleratedAutoTakeOut)
				createNextButton();
			
			if (nextButton) {
				var newNextButtonFinishX:Number = cardsAlignSettings.commonShiftX + cardFinishX - (AwardImageAssetContainer.WIDTH/2)*pxScale*cardScale + nextButton.width/2;
				nextButton.alpha = 0;
				nextButton.x = cardsAlignSettings.commonShiftX + newNextButtonFinishX - 100*pxScale;
				nextButton.y = cardY + (AwardImageAssetContainer.HEIGHT/2)*pxScale*cardScale + nextButton.height/2 + cardsAlignSettings.buttonShiftY//(isMoreThanThreeItems ? 275 : 75) * pxScale;
				
				//trace(nextButton.y, cardY, Math.floor(length/3),  (AwardImageAssetContainer.HEIGHT/2)*pxScale*cardScale , nextButton.height/2 , (isMoreThanThreeItems ? 40 : 75) * pxScale, isMoreThanThreeItems , cardFinishY);
				addChild(nextButton);
				Starling.juggler.tween(nextButton, 0.35, {x:newNextButtonFinishX, delay:(delay + 0.2), alpha:2, transition:Transitions.EASE_OUT_BACK, onStart:setNextButtonTouchable, onStartArgs:[true]});
			}
			
			if (cardsAlignSettings.commonShiftX != 0)
				Starling.juggler.tween(chestAnimation, 0.45, {x:(chestAnimation.x + cardsAlignSettings.commonShiftX), delay:(delay + 0.2), transition:Transitions.EASE_OUT_BACK});
		}
		
		private function createNextButton():void 
		{
			nextButton = new XButton(XButtonStyle.DialogBigGreenButtonStyle);
			nextButton.maxDragDist = 0;
			nextButton.addEventListener(Event.TRIGGERED, handler_nextButtonClick);
			nextButton.alignPivot()//Align.CENTER, Align.BOTTOM);
			nextButton.text = 'NEXT';
			nextButton.alpha = 0;
			nextButton.touchable = false;
			nextButton.x = nextButtonFinishX - 100 * pxScale
			nextButton.y = Math.min(cardFinishY + (AwardImageAssetContainer.HEIGHT/2)*pxScale + nextButton.height/2 + 235 * pxScale, /* layoutHelper.stageHeight*/HEIGHT - nextButton.height/2 - 35*pxScale);
			addChild(nextButton);
		}
		
		private function get nextButtonFinishX():Number {
			if (!nextButton)
				return 400;
				
			return cardFinishX - (AwardImageAssetContainer.WIDTH / 2) * pxScale + nextButton.width / 2;
		}
		
		private function removeView(view:DisplayObject):void {
			view.removeFromParent();
		}
		
		private function setNextButtonTouchable(value:Boolean):void {
			if (nextButton)
				nextButton.touchable = value;
		}
		
		private function handler_accelerateTakeOut(event:Event):void 
		{
			gameManager.chestsData.removeEventListener(ChestsData.EVENT_ACCELERATE_CHEST_TAKE_OUT_DIALOG, handler_accelerateTakeOut);
				
			startAccelerateTime = getTimer();
			
			acceleratedAutoTakeOut = true;
			
			if (!isTakeOutNextItemInProgress) {
				takeOutNextItemOrClose(true);
				clickCount++;
			}
				
			// случай когда окно только открыли
			// случай когда в середине выдачи
			// случай когда в конце выдачи в списке отображений
		}
		
		private function setTakeOutNextItemInProgress(value:Boolean):void {
			isTakeOutNextItemInProgress = value
			//trace('setTakeOutNextItemInProgress ', isTakeOutNextItemInProgress);
			if (!isTakeOutNextItemInProgress && acceleratedAutoTakeOut) 
			{
				if(currentItemIndex < _chestData.prizes.length)	
					takeOutNextItemOrClose(true);
				else
					Starling.juggler.delayCall(takeOutNextItemOrClose, 1.2, true);		
					
				clickCount++;
			}
		}	
		
		private function accelerateTweens():void 
		{
			if (accelerateAdvanceTime >= 0) 
				accelerateAdvanceTime = Math.min(0.05, accelerateAdvanceTime + 0.01);
			else 
				accelerateAdvanceTime += 0.02;
			
			if(!hasEventListener(Event.ENTER_FRAME, handler_advanceTimeEnterFrame))
				addEventListener(Event.ENTER_FRAME, handler_advanceTimeEnterFrame);
			
			acceleratedAutoTakeOut = true;	
		}
		
		private function handler_advanceTimeEnterFrame(e:Event):void
		{
			Starling.juggler.advanceTime(accelerateAdvanceTime);
			
			accelerateAdvanceTime -= 0.003;
		
			if (accelerateAdvanceTime <= 0) {
				accelerateAdvanceTime = 0;
				
				if(startAccelerateTime == 0)
					acceleratedAutoTakeOut = false;
				removeEventListener(Event.ENTER_FRAME, handler_advanceTimeEnterFrame);
			}
		}
	}	
}
import com.alisacasino.bingo.assets.AtlasAsset;
import com.alisacasino.bingo.controls.XTextField;
import com.alisacasino.bingo.controls.XTextFieldStyle;
import com.alisacasino.bingo.models.powerups.Powerup;
import starling.display.Image;
import starling.display.Sprite;

final class PowerUpView extends Sprite 
{
	private var powerUpImage:Image;
	private var countBg:Image;
	private var titleLabel:XTextField;
	
	public function PowerUpView(powerupType:String, count:int) 
	{
		touchable = false;
		powerUpImage = new Image(AtlasAsset.CommonAtlas.getTexture(Powerup.getTexture(powerupType)));
		powerUpImage.alignPivot();
		addChild(powerUpImage);
		
		countBg = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/red_circle_white_outline"));
		countBg.alignPivot();
		addChild(countBg);
		
		countBg.x = powerUpImage.width / 2 - 5*pxScale;
		countBg.y = powerUpImage.height / 2 - 12 * pxScale;
		
		titleLabel = new XTextField(52 * pxScale, 33 * pxScale, XTextFieldStyle.getWalrus(26, 0xFFFFFF), count.toString());
		titleLabel.alignPivot();
		titleLabel.x = countBg.x - 1*pxScale;
		titleLabel.y = countBg.y + 2*pxScale;
		//titleLabel.border = true;
		addChild(titleLabel);
	}
}

final class AllCardsAlignSettings
{
	public var scale:Number;
	public var gapHorisontal:int;
	public var gapVertical:int;
	public var columns:int;
	public var cardsShiftY:int;
	public var titleLabelShiftY:int;
	public var buttonShiftY:int;
	public var commonShiftX:int;
	public var delayPerCard:Number;
	
	public function AllCardsAlignSettings(scale:Number, gapHorisontal:int, gapVertical:int, columns:int, cardsShiftY:int, titleLabelShiftY:int, buttonShiftY:int, commonShiftX:int, delayPerCard:Number = 0.05) 
	{
		this.scale = scale;
		this.gapHorisontal = gapHorisontal;
		this.gapVertical = gapVertical;
		this.columns = columns;
		this.cardsShiftY = cardsShiftY;
		this.titleLabelShiftY = titleLabelShiftY;
		this.buttonShiftY = buttonShiftY;
		this.commonShiftX = commonShiftX;
		this.delayPerCard = delayPerCard;
	}
	
	public static function getCardsSettings(cardsCount:int):AllCardsAlignSettings
	{
		if (cardsCount <= 3)
			return new AllCardsAlignSettings(0.912, 240 * pxScale, 235 * pxScale, 3, 44 * pxScale, 	-240 * pxScale, 75 * pxScale, 0);
		else if (cardsCount <= 6)
			return new AllCardsAlignSettings(0.788, 205 * pxScale, 235 * pxScale, 3, 0, 			-185 * pxScale, 275 * pxScale, 0);
		else if (cardsCount <= 8)
			return new AllCardsAlignSettings(0.738, 180 * pxScale, 205 * pxScale, 4, 0, 			-185 * pxScale, 253 * pxScale, -50 * pxScale, 0.03);
		else if (cardsCount <= 12)
			return new AllCardsAlignSettings(0.668, 160 * pxScale, 185 * pxScale, 4, -90 * pxScale, -150 * pxScale, 385 * pxScale, 0, 0.03);	
		else 
			return new AllCardsAlignSettings(0.668, 155 * pxScale, 185 * pxScale, 5, -90 * pxScale, -150 * pxScale, 385 * pxScale, -65 * pxScale, 0.02);	
		
		return 	   new AllCardsAlignSettings(0.912, 180 * pxScale, 205 * pxScale, 3, 0, 			-240 * pxScale, 75 * pxScale, 0);
	}
}	