package com.alisacasino.bingo.screens.gameScreenClasses
{
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.GameCard;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.models.Card;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.models.powerups.PowerupDropTweenStyle;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.disposal.DisposalUtils;
	import feathers.core.FeathersControl;
	import feathers.events.FeathersEventType;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import mx.core.MovieClipAsset;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class GameCardsViewNew extends FeathersControl
	{
		private static var DEBUG_MODE:Boolean = false;
		
		private var HORISONTAL_GAP	:int = 6;
		private var VERTICAL_GAP	:int = 3;
		
		private const SWIPE_VELOCITY_MEASUREMENT_INTERVAL:int = 50;
		private const SWIPE_THRESHOLD_VALUE:int = 7;
		private const SWIPE_FORCE_VELOCITY:Number = 0.3;
		
		private const CARD_VERTICAL_PADDING:Number = 18;
		
		private var cards:Vector.<GameCard>;
		public var isScrolling:Boolean;
		public var connectionProblemIndicator:ConnectionProblemIndicator;
		private var gameScreen:GameScreen;
		private var storedIsLargeScreen:Boolean;
		
		private var gameManager:GameManager = GameManager.instance;
		private var player:Player = Player.current;
		private var touchQuad:Quad;
		private var gameUI:GameUI;
		
		private var containerRect:Rectangle;
		private var maskQuad:Quad;
		
		private var isMasked:Boolean;
		private var isAnimating:Boolean;
		
		private var cardHeightAndGap:Number;
		private var cardCenterY:Number;
		private var cardScale:Number = 1;
		
		private var minScrollPosition:Number;
		private var maxScrollPosition:Number;
		
		private var HELPER_POINT:Point = new Point();
		private var touchPointID:int = -1;
		private var previousVelocityTouchTime:int = -1;
		private var velocityPointTouchY:Number = 0;
		private var startTouchY:int;
		private var startVerticalScrollPosition:Number = 0;
		private var targetVerticalScrollPosition:Number = 0;
		private var instantScrollVelocity:Number = 0;
		
		private var cardVerticalPadding:Number = 0;
		
		public function GameCardsViewNew(gameScreen:GameScreen, gameUI:GameUI)
		{
			this.gameScreen = gameScreen;
			this.gameUI = gameUI;
			init();
		}
		
		public function init():void
		{
			cards = new Vector.<GameCard> ();
			containerRect = new Rectangle();
			
			touchQuad = new Quad(1, 1, 0xFF00FF);
			touchQuad.alpha = DEBUG_MODE ? 0.4 : 0;
			//touchQuad.touchable = false;
			addChild(touchQuad);
			
			maskQuad = new Quad(1, 1);
			
			connectionProblemIndicator = new ConnectionProblemIndicator();
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_SIZE))
			{
				resize();
			}
		}

		public function resize(forceResize:Boolean = false):void
		{
			var sizeChanged:Boolean = width != gameManager.layoutHelper.stageWidth || height != gameManager.layoutHelper.stageHeight || storedIsLargeScreen != gameManager.layoutHelper.isLargeScreen;
			
			if (!sizeChanged && !forceResize)
				return;
			
			storedIsLargeScreen = gameManager.layoutHelper.isLargeScreen;	
				
			if (isAnimating) 
				removeTweens();
			
			setSizeInternal(gameManager.layoutHelper.stageWidth, gameManager.layoutHelper.stageHeight, false);
			
			//trace('resize', width, height);
			
			isMasked = false;
			
			var topPadding:Number = (storedIsLargeScreen ? 105 : 120) * gameUILayoutScale;
			var leftPadding:Number = (storedIsLargeScreen ? 183 : 170) * gameUILayoutScale;
			var rightPadding:Number = storedIsLargeScreen ? 260 * gameUILayoutScale : containerRect.x;
			
			containerRect.x = leftPadding;
			containerRect.y = topPadding;
			containerRect.width = width - containerRect.x - rightPadding;
			containerRect.height = height - containerRect.y;
			
			var i:int;
			var totalCards:int = cards.length;
			if (totalCards == 0) {
				return;
			}
			else {
				for (i = 0; i < totalCards; i++) {
					cards[i].refreshLayout();
				}
			}
			
			cardScale = 1;
			
			var horisontalGap:Number = HORISONTAL_GAP * pxScale;
			var verticalGap:Number = VERTICAL_GAP * pxScale;
			var totalWidth:Number;
				
			var cardWidth:Number = cards[0].baseWidth;
			var cardHeight:Number = cards[0].baseHeight;
			
			var rows:int = (totalCards - 1) / 2 + 1;
			var cardsPerRow:int = totalCards > 1 ? 2 : 1;
			var columns:int = totalCards > 2 ? 2 : 1;
			
			var minTotalCardWidth:Number = cardsPerRow * cardWidth + verticalGap * (cardsPerRow - 1);
			var totalCardsHeight:Number = columns * cardHeight + verticalGap * (columns - 1);
			
			cardScale = Math.min(containerRect.width / minTotalCardWidth, containerRect.height / cardHeight);
			
			if (storedIsLargeScreen)
			{
				mask = null;
				scrollEnabled = false;
				
				if (totalCards == 1)
				{
					cardScale = (gameManager.layoutHelper.stageHeight * 0.63) / cardHeight;
					//	containerRect.y = 180 * gameUILayoutScale;
				}
				else if (totalCards == 2) 
				{
					// max by cards width
					// containerRect.y = 245 * gameUILayoutScale;
					cardScale = Math.min(containerRect.height/totalCardsHeight, containerRect.width/minTotalCardWidth);
				}
				else
				{
					// max by cards width
					cardScale = Math.min(containerRect.height/totalCardsHeight, containerRect.width/minTotalCardWidth);
				}
				
				containerRect.height = totalCardsHeight * cardScale;
			}
			else
			{
				cardScale = Math.min(containerRect.height / cardHeight, containerRect.width / minTotalCardWidth);
				
				// max by cards height:
				containerRect.height = Math.min(height - containerRect.y, cardHeight * cardScale);
				
				if (totalCards > 2) 
				{
					isMasked = true;
					mask = maskQuad;
					
					if(!isAnimating)
						scrollEnabled = true;
					
					cardsScrollComplete();	
				}
				else
				{
					mask = null;
					scrollEnabled = false;
				}
			}
			
			containerRect.y = topPadding + Math.max(0, (height - containerRect.height - topPadding)/2);
		
			if (mask) {
				maskQuad.x = containerRect.x - 100*pxScale;
				maskQuad.y = containerRect.y - cardVerticalPadding;
				maskQuad.width = containerRect.width + 200*pxScale; 
				maskQuad.height = containerRect.height + cardVerticalPadding;
			}
			
			touchQuad.x = containerRect.x;
			touchQuad.y = containerRect.y;
			touchQuad.width = containerRect.width;
			touchQuad.height = containerRect.height;
			addChildAt(touchQuad, 0);
			
			for (i = 0; i < totalCards; i++) 
			{
				var card:GameCard = cards[i];
				//card.refreshLayout();
				card.baseScale = cardScale;
				card.scale = cardScale;
				
				if (!storedIsLargeScreen && totalCards == 3 && i == 2) 
					card.x = card.pivotX  * cardScale + containerRect.x + (containerRect.width - cardWidth * cardScale) / 2;
				else
					card.x = card.pivotX  * cardScale + containerRect.x + (containerRect.width - minTotalCardWidth * cardScale) / 2 + (i % 2) * (cardWidth * cardScale + horisontalGap * cardScale);
					
				card.y = card.pivotY* cardScale + containerRect.y + int(i / 2) * (cardHeight * cardScale + verticalGap * cardScale);
			
				//card.pivotX cardWidth * cardScale
				//trace(' crad ', i, card.x, card.y);
			}
			
			connectionProblemIndicator.x = containerRect.x + containerRect.width / 2;
			connectionProblemIndicator.y = containerRect.y + containerRect.height / 2;
			
			cardHeightAndGap = (cards[0].baseHeight + VERTICAL_GAP * pxScale) * cards[0].baseScale;
			cardCenterY = cards[0].pivotY * cards[0].baseScale
			
			minScrollPosition = -cardHeightAndGap + cardCenterY + containerRect.y;
			maxScrollPosition = cardCenterY + containerRect.y;
			
			handler_enterFrameScrollerHandleEdges(null);
		}
		
		public function refreshSkinTextures():void
		{
			var length:int = cards.length;
			for (var i:int = 0; i < length; i++) {
				cards[i].refreshSkinTextures();
			}
		}
		
		public function get topY():Number
		{
			return containerRect.y;
		}
		
		public function createCards(animate:Boolean, delay:Number = 0):void
		{
			//trace(' createCards ');
			
			cardVerticalPadding = gameManager.skinningData.cardSkin.hasOverhangTopEdge ? (CARD_VERTICAL_PADDING * pxScale) : 0;
			
			isAnimating = animate;
			
			removeChildren();
			
			cards = new Vector.<GameCard>();
			var maxCardsCount:int = 4;
			var card:GameCard;
			var i:int;
			for (i = 0; i < Math.min(player.cards.length, maxCardsCount); i++)
			{
				card = new GameCard(player.cards[i], i);
				card.gameCardsContainer = this;
				card.pivotX = card.baseWidth / 2;
				card.pivotY = card.baseHeight / 2;
				card.topLayerAnimations.pivotX = card.pivotX;
				card.topLayerAnimations.pivotY = card.pivotY;
				addChild(card);
				cards.push(card);
			}
			
			for (i = 0; i < cards.length; i++)
			{
				addChild(cards[i].topLayerAnimations);
			}	
			
			resize(true);
			
			
			tweenAppearFromBottom(delay);
			
			/*if (Math.random() > 0.5)
				tweenAppearDropDown(delay);
			else
				tweenAppearScaleUp(delay);*/
				
				
			addChild(connectionProblemIndicator);
		}
		
		public function getCard(index:int):GameCard
		{
			if (index < 0 || index >= cards.length)
				return null;
			
			return cards[index];
		}
		
		private function enableMaskAndScroll():void
		{
			mask = maskQuad;
			var i:int;
			for (i = 2; i < cards.length; i++) {
				cards[i].alpha = 1;
			}
			
			scrollEnabled = true;
			isAnimating = false;
			
			handler_enterFrameScrollerHandleEdges(null);
			
			cardsScrollComplete();
		}
		
		private function completeAppearAnimation():void
		{
			isAnimating = false;
		}
		
		public function destroy():void
		{
			while (cards && cards.length > 0) {
				(cards.shift() as GameCard).dispose();
				//DisposalUtils.destroy((cards.shift() as DisplayObjectContainer));
			}
		}
		
		public function cleanCardsContainer():void
		{
			removeChildren();
		}
		
		public function toggleScrollCards():void
		{
			cleanScrollToNonBlockedCards();
			scrollCards((cardsScrollY - cardCenterY) < 0, 0.3, Transitions.EASE_IN_OUT_BACK, true);
		}
		
		public function scrollCards(toBottomCards:Boolean, time:Number = 0.5, transition:String = "easeInOutBack", stopTweens:Boolean = false):void
		{
			if (cards.length == 0)
				return;
		
			var i:int;
			var cardY:Number;	
			var gameCard:GameCard;
			for (i = 0; i < cards.length; i++)
			{
				gameCard = cards[i];
				gameCard.stopScalingTweens();
				
				cardY = getCardY(i, toBottomCards);//gameCard.pivotY*gameCard.baseScale + containerRect.y + int(i / 2) * cardHeightAndGap - (toBottomCards ? 0 : cardHeightAndGap);
				
				if (stopTweens)
					Starling.juggler.removeTweens(gameCard);
					
				Starling.juggler.tween(gameCard, time, {"y": cardY, transition:transition, onComplete:(i == (cards.length - 1) ? cardsScrollComplete : null)});	
				gameCard.onScroll();
				
				//trace('> ', (-gameCard.height*gameCard.scale - VERTICAL_GAP*gameUILayoutScale), gameCard.height, gameCard.scale);	
			}
			
			/*for (i = 0; i < numChildren; i++)
			{
				if (getChildAt(i) is AnimationContainer) {
					
				}
			}*/
			
			isScrolling = true;
			
			if (gameManager.skinningData.cardSkin.hasOverhangTopEdge)
				addEventListener(Event.ENTER_FRAME, handler_enterFrameScrollerHandleEdges);
		}
		
		private function getCardY(cardIndex:int, toBottomCards:Boolean):Number {
			return cards[0].pivotY*cards[0].baseScale + containerRect.y + int(cardIndex / 2) * cardHeightAndGap - (toBottomCards ? 0 : cardHeightAndGap);
		}
		
		private function cardsScrollComplete():void
		{
			isScrolling = false;
			var length:int = cards.length;
			for (var i:int = 0; i < length; i++) {
				cards[i].isCardInViewArea = isCardInViewArea(cards[i]);
			}
			
			removeEventListener(Event.ENTER_FRAME, handler_enterFrameScrollerHandleEdges);
			
			gameUI.gameUIPanel.setCardScrollButtonStyle((cardsScrollY - cardCenterY) < 0);
			
			commitScrollToNonBlockedCards(0.3);
		}
		
		public function set scrollEnabled(value:Boolean):void
		{
			if (value) {
				if(!hasEventListener(TouchEvent.TOUCH, handler_scrollTouch))
					addEventListener(TouchEvent.TOUCH, handler_scrollTouch);
			}
			else {
				if(hasEventListener(TouchEvent.TOUCH, handler_scrollTouch))
					removeEventListener(TouchEvent.TOUCH, handler_scrollTouch);
			}
				
			gameUI.gameUIPanel.scrollButtonEnabled = value;	
		}
		
		public function getCardById(cardId:uint):GameCard
		{
			for (var i:int = 0; i < cards.length; i++)
			{
				if (cards[i].card.cardId == cardId)
					return cards[i];
			}
			return null;
		}
		
		public function getCardByCardModel(card:Card):GameCard
		{
			for (var i:int = 0; i < cards.length; i++)
			{
				if (cards[i].card == card)
					return cards[i];
			}
			return null;
		}
		
		public function isCardInViewArea(card:GameCard):Boolean
		{
			if (!mask)
				return true;
			
			return card.y > mask.y && card.y < (mask.y + mask.height);
		}
		
		
		/*******************************************************************************************************
		 * 
		 * CARDS TWEENS
		 * 
		 * *****************************************************************************************************/
		
		private function tweenAppearDropDown(delay:Number = 0):void
		{
			var i:int;
			var appearDelay:Number = delay;
			
			if (cards.length == 1) {
				tweenCardAppearDropDown(cards[0], appearDelay, completeAppearAnimation);
			}
			else if (cards.length == 2) {
				tweenCardAppearDropDown(cards[0], appearDelay);
				tweenCardAppearDropDown(cards[1], appearDelay, completeAppearAnimation);
			}
			else 
			{
				if (isMasked) {
					mask = null;
					for (i = 2; i < cards.length; i++) {
						cards[i].alpha = 0;
					}
				}
				else {
					tweenCardAppearDropDown(cards[2], appearDelay, cards.length == 3 ? completeAppearAnimation : null);
					if (cards.length > 3)
						tweenCardAppearDropDown(cards[3], appearDelay, completeAppearAnimation);
					
					appearDelay += 0.3;
				}
				
				tweenCardAppearDropDown(cards[0], appearDelay);
				tweenCardAppearDropDown(cards[1], appearDelay, isMasked ? enableMaskAndScroll : null);	
			}
		}
		
		private function tweenAppearScaleUp(delay:Number = 0):void
		{
			if (isMasked) {
				mask = null;
				for (i = 2; i < cards.length; i++) {
					cards[i].alpha = 0;
				}
			}
			
			var i:int;
			var card:GameCard;
			var completeFunction:Function;
			for (i = 0; i < cards.length; i++)
			{
				card = cards[i];
				
				if (isMasked && i < 2) 
				{
					if (i == 1)
						completeFunction = enableMaskAndScroll;
					
					Starling.juggler.tween(card, 0.3, {scale:card.baseScale, delay:(delay + i*0.05), transition:Transitions.EASE_OUT_BACK, onComplete:completeFunction});	
					Starling.juggler.delayCall(gameScreen.shakeBackground, delay + 0.15 + i*0.05, ResizeUtils.SHAKE_X_Y_SHRINK);
					card.scale = 0;
				}
				else
				{
					Starling.juggler.tween(card, 0.3, {scale:card.baseScale, delay:(delay + i * 0.05), transition:Transitions.EASE_OUT_BACK, onComplete:(i == (cards.length - 1) ? completeAppearAnimation : null)});	
			
					Starling.juggler.delayCall(gameScreen.shakeBackground, delay + 0.15 + i*0.05, ResizeUtils.SHAKE_X_Y_SHRINK);
					
					card.scale = 0;
				}
				
				//card.alpha = 0;
			}
			
		}
		
		private function tweenCardAppearDropDown(card:GameCard, delay:Number=0, onComplete:Function = null):void
		{
			var cardScale:Number = card.baseScale;
			
			var tween_0:Tween = new Tween(card, 0.2, Transitions.EASE_IN);
			var tween_1:Tween = new Tween(card, 0.08, Transitions.EASE_OUT);
			var tween_2:Tween = new Tween(card, 0.2, Transitions.EASE_IN_OUT_BACK);
			
			tween_0.delay = delay;
			tween_0.animate('y', card.y + ((1 - 1.7)*cardScale*card.baseHeight)/2 );
			tween_0.nextTween = tween_1;
			tween_0.onComplete = gameScreen.shakeBackground;
			tween_0.onCompleteArgs = [ResizeUtils.SHAKE_X_Y_DOWN];
			
			tween_1.animate('scaleX', 1.17*card.baseScale);
			tween_1.animate('scaleY', 0.74*card.baseScale);
			tween_1.animate('y', card.y + ((1 - 0.74)*cardScale*card.baseHeight)/2);
			tween_1.nextTween = tween_2;
			
			tween_2.animate('scaleX', card.baseScale);
			tween_2.animate('scaleY', card.baseScale);
			tween_2.animate('y', card.y);
			tween_2.onComplete = onComplete;
			
			Starling.juggler.add(tween_0);
			
			card.scaleX = 0.86*cardScale;
			card.scaleY = 1.7*cardScale;
			card.y = -card.height;
		}
		
		private function removeTweens():void
		{
			var i:int;
			for (i = 0; i < cards.length; i++) {
				Starling.juggler.removeTweens(cards[i]);
			}
			
			isAnimating = false;
		}
		
		private function tweenAppearFromBottom(delay:Number = 0):void
		{
			if (isMasked) {
				mask = null;
				for (i = 2; i < cards.length; i++) {
					cards[i].alpha = 0;
				}
			}
			
			handler_enterFrameScrollerHandleEdges(null);
			
			var i:int;
			var card:GameCard;
			var completeFunction:Function;
			for (i = 0; i < cards.length; i++)
			{
				card = cards[i];
				
				if (isMasked) 
				{
					if (i < 2) {
						if (i == 1) {
							completeFunction = enableMaskAndScroll;
						}
						Starling.juggler.tween(card, 0.6, { y:card.y, delay:(delay + i * 0.17), transition:Transitions.EASE_IN_OUT_BACK, onComplete:completeFunction});	
						//Starling.juggler.delayCall(gameScreen.shakeBackground, delay + 0.4 + i*0.17, ResizeUtils.SHAKE_X_Y_SHRINK);
						card.y = gameManager.layoutHelper.stageHeight + card.baseHeight*card.baseScale;
					}
				}
				else
				{
					Starling.juggler.tween(card, 0.6, { y:card.y, delay:(delay + i * 0.17), transition:Transitions.EASE_IN_OUT_BACK, onComplete:(i == (cards.length - 1) ? completeAppearAnimation : null)});	
					//Starling.juggler.delayCall(gameScreen.shakeBackground, delay + 0.4 + i*0.17, ResizeUtils.SHAKE_X_Y_SHRINK);
					card.y = gameManager.layoutHelper.stageHeight + card.baseHeight*card.baseScale;
				}
				
			}
		}
		
		public function tweenShake(delay:Number = 0):void
		{
			var i:int;
			for (i = 0; i < cards.length; i++) {
				//cards[i].shake();
				cards[i].tweenShake();
			}
		}
		
		/*******************************************************************************************************
		 * 
		 * CARDS METHODS
		 * 
		 * *****************************************************************************************************/
		
		public function showBingo(cardId:uint):void
		{
			for (var i:int = 0; i < cards.length; i++)
			{
				var gameCard:GameCard = cards[i];
				if (gameCard.card.cardId == cardId)
				{
					gameCard.onBingo();
					if (gameCard.card.instantBingoNumber != 0)
					{
						player.isInstantBingo = true;
					}
					
					//commitScrollToNonBlockedCards(1.5);
					return;
				}
			}
		}
		
		public function showBadBingo(cardId:uint):void
		{
			for (var i:int = 0; i < cards.length; i++)
			{
				var gameCard:GameCard = cards[i];
				if (gameCard.card.cardId == cardId)
				{
					gameCard.onBadBingo();
					commitScrollToNonBlockedCards(0.9);
					return;
				}
			}
		}
		
		public function addBall(ballNumber:uint):void
		{
			var length:int = cards ? cards.length : 0;	
			for (var i:int = 0; i < length; i++) {
				(cards[i] as GameCard).addBallNumber(ballNumber);
			}
		}
		
		private var scrollToNonBlockedCardsDelayId:uint;
		
		public function cleanScrollToNonBlockedCards():void {
			if (scrollToNonBlockedCardsDelayId != 0) {
				Starling.juggler.removeByID(scrollToNonBlockedCardsDelayId);
				scrollToNonBlockedCardsDelayId = 0;
			}	
		}
		
		public function commitScrollToNonBlockedCards(delay:Number):void 
		{
			// триггеры скролла:
			// 1. бэд бинго финальный
			// 2. бинго после анимации
			// 3. скролл на заблокированные карты
			
			cleanScrollToNonBlockedCards();
			
			if (delay != 0) {
				scrollToNonBlockedCardsDelayId = Starling.juggler.delayCall(commitScrollToNonBlockedCards, delay, 0);
				return;
			}
			
			if (!isMasked || isAnimating || gameUI.hasBingoAnimations) 
				return;
				
				
			var length:int = cards ? cards.length : 0;	
			var card:GameCard;
			var allCardsAreBlocked:Boolean = true;
			for (var i:int = 0; i < length; i++) {
				card = cards[i] as GameCard;
				//trace('DD >>> ', card.index, isCardInViewArea(card), card.isCardFullyBlocked);
				if (!isCardInViewArea(card)) {
					if(!card.isCardFullyBlocked)
						allCardsAreBlocked = false;
					continue;
				}
				
				if (!card.isCardFullyBlocked)
					return;
			}		
			
			//EffectsManager.removeJump(cardScrollButton);
			if(!allCardsAreBlocked)
				toggleScrollCards();
		}
		
		public function hasUndaubedNumbersInScrolledCards(ballNumber:uint):Boolean
		{
			var length:int = cards ? cards.length : 0;	
			var card:GameCard;
			for (var i:int = 0; i < length; i++) {
				card = cards[i] as GameCard;
				if(!isCardInViewArea(card) && card.hasUndaubedNumber(ballNumber))
					return true;
			}	
			
			return false;
		}
		
		public function roundOverHandle():void
		{
			for each (var gameCard:GameCard in cards)
			{
				gameCard.touchable = false;
			}
		}
		
		public function addPowerUp(powerup:String, tweenStyle:String = null):void 
		{
			var i:int;
			var length:int = cards.length;
			var card:GameCard;
			var powerUpDelay:Number = length < 4? 0.15 : 0.08;
			for (i = 0; i < length; i++) 
			{
				card = cards[i];
				if(powerup == Powerup.DAUB) 
				{
					Starling.juggler.delayCall(card.addPowerUp, i * 0.25, powerup);
					///card.addPowerUp(powerup);
				}
				else if(powerup == Powerup.DOUBLE_DAUB) 
				{
					Starling.juggler.delayCall(card.addPowerUp, (i % 2 == 0) ? 0 : 0.4, powerup);
					///card.addPowerUp(powerup);
				}
				else if(powerup == Powerup.TRIPLE_DAUB) 
				{
					Starling.juggler.delayCall(card.addPowerUp, (i % 2 == 0) ? 0 : 0.6, powerup);
					///card.addPowerUp(powerup);
				}
				else {
					//card.addPowerUp(powerup);
					if (tweenStyle == PowerupDropTweenStyle.STAKES)
						card.addPowerUp(powerup, 0, tweenStyle);
					else
						Starling.juggler.delayCall(card.addPowerUp, i * powerUpDelay, powerup, (length - i - 1) * powerUpDelay);
				}
			}
		}
		
		/*******************************************************************************************************
		* 
		* swipe scroll 
		* 
		******************************************************************************************************/ 
		
		/*override public function hitTest(localPoint:Point):DisplayObject
		{
			if(!this.visible || !this.touchable)
				return null;
				
			return containerRect.containsPoint(localPoint) ? this : null;
		}*/
		
		private function handler_scrollTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(this);
			if (!touch)
				return;
		
			//trace(' TICH ', touch);	
				
			if(touchPointID >= 0)
				return;
				
			if (touch.phase == TouchPhase.BEGAN)
			{
				touchPointID = touch.id;
				previousVelocityTouchTime = getTimer();
				
				touch.getLocation(this, HELPER_POINT);
				
				stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);
			}
			else if (touch.phase == TouchPhase.ENDED)
			{
				touchPointID = -1;
			}
			
			startTouchY = velocityPointTouchY = HELPER_POINT.y;
			startVerticalScrollPosition =  cardsScrollY;
		}
		
		protected function stage_touchHandler(event:TouchEvent):void
		{
			if(touchPointID < 0)
				return;
			
			var touch:Touch = event.getTouch(stage, null, touchPointID);
			if(touch === null)
				return;
			
			if(touch.phase === TouchPhase.MOVED)
			{
				touch.getLocation(this, HELPER_POINT);
				
				var offset:Number =  HELPER_POINT.y - startTouchY;
			
				if(Math.abs(offset) >= SWIPE_THRESHOLD_VALUE*pxScale)
				{
					if (!isScrolling) 
					{
						isScrolling = true;
						if (gameManager.skinningData.cardSkin.hasOverhangTopEdge)
							addEventListener(Event.ENTER_FRAME, handler_enterFrameScrollerHandleEdges);
						
						markCardsScroll();
						addEventListener(Event.ENTER_FRAME, scroller_enterFrameHandler);
						
						gameUI.forceFinishBingoAnimations();
						
						cleanScrollToNonBlockedCards();
					}
				
					//trace('>> position ', offset, position);
	
					var newScrollPosition:Number = startVerticalScrollPosition + offset; 
					//targetVerticalScrollPosition = Math.max(-cardHeightAndGap + cardCenterY + containerRect.y, Math.min(cardCenterY + containerRect.y, newScrollPosition));
					
					if (newScrollPosition > maxScrollPosition)
						targetVerticalScrollPosition = maxScrollPosition + (newScrollPosition - maxScrollPosition)/4;
					else if (newScrollPosition < minScrollPosition) 
						targetVerticalScrollPosition = minScrollPosition - (minScrollPosition - newScrollPosition) / 4;
					else	
						targetVerticalScrollPosition = newScrollPosition;
						
					//cardsScrollY = targetVerticalScrollPosition;	
				}
			}
			else if(touch.phase === TouchPhase.ENDED)
			{
				removeEventListener(Event.ENTER_FRAME, scroller_enterFrameHandler);
				
				stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
				
				touchPointID = -1;
				
				// принимаем решение о заканчивании скролла в ту или иную сторону
			
				if (isScrolling)
				{
					var cardsYCrossCardCenterY:Boolean = (cardsScrollY - cardCenterY - containerRect.y) > -cardHeightAndGap / 2;
					var scrollVelocity:Number = instantScrollVelocity == 0 ? ((HELPER_POINT.y - velocityPointTouchY) / (getTimer() - previousVelocityTouchTime)) : instantScrollVelocity;
					var isFastScrollVelocity:Boolean = Math.abs(scrollVelocity) > SWIPE_FORCE_VELOCITY;
					
					//trace(' >> ', /*(scrollVelocity > 0 && isFastScrollVelocity),*/ scrollVelocity, isFastScrollVelocity);
					
					if (cardsScrollY > maxScrollPosition) {
						scrollCards(true, 0.3, Transitions.EASE_OUT);
					}
					else if(cardsScrollY < minScrollPosition) {
						scrollCards(false, 0.3, Transitions.EASE_OUT);
					}
					else if (isFastScrollVelocity) 
					{
						scrollCards(scrollVelocity > 0, 0.4, Transitions.EASE_OUT_BACK);
					}
					else
					{
						scrollCards(cardsYCrossCardCenterY, 0.4, Transitions.EASE_OUT_BACK);
					}
					
					//targetVerticalScrollPosition = Math.max(-cardHeightAndGap + cardCenterY + containerRect.y, Math.min(cardCenterY + containerRect.y, newScrollPosition));
				}
			}
		}
		
		protected function scroller_enterFrameHandler(event:Event):void
		{
			cardsScrollY = cardsScrollY + (targetVerticalScrollPosition - cardsScrollY) * 0.8;
			
			if ((getTimer() - previousVelocityTouchTime) > SWIPE_VELOCITY_MEASUREMENT_INTERVAL) {
				instantScrollVelocity = (HELPER_POINT.y - velocityPointTouchY) / (getTimer() - previousVelocityTouchTime);
				previousVelocityTouchTime = getTimer();
				velocityPointTouchY = HELPER_POINT.y;
				//trace('instant velocity: ', instantScrollVelocity);
			}
			
			//cardsScrollY = targetVerticalScrollPosition;
		}
		
		private function handler_enterFrameScrollerHandleEdges(event:Event):void
		{
			if(isMasked && cardVerticalPadding > 0 && cards.length > 2)
			{
				var topCardsY:Number = getCardY(2, true);
				var bottomCardsY:Number = getCardY(2, false);
				
				cards[0].alpha = (cards[2].y - bottomCardsY) / cardVerticalPadding;
				cards[1].alpha = cards[0].alpha;
				
				cards[2].alpha = (topCardsY - cards[2].y) / cardVerticalPadding;
				if(cards.length > 3)
					cards[3].alpha = cards[2].alpha;
			}
		}
		
		private function set cardsScrollY(value:Number):void
		{
			var length:int = cards.length;
			for (var i:int = 0; i < length; i++) {
				cards[i].y = value + int(i / 2) * cardHeightAndGap;
			}
		}
		
		private function get cardsScrollY():Number
		{
			return cards.length > 0 ? cards[0].y : 0;
		}
		
		private function markCardsScroll():void
		{
			var length:int = cards.length;
			var card:GameCard;
			for (var i:int = 0; i < length; i++) 
			{
				card = cards[i];
				card.isCardInViewArea = true;
				card.onScroll();
				card.stopScalingTweens();
			}
		}
		 
		/*******************************************************************************************************
		* 
		* Debug:
		* 
		******************************************************************************************************/  
		
		public function debugGetRandomCard():GameCard
		{
			return cards[ Math.floor( cards.length * Math.random())];
		} 
		 
		public function debugCardVisible():void
		{
			for (var i:int = 0; i < cards.length; i++) {
				trace(' > ', isCardInViewArea(cards[i]));
			}
		}
		
		
		
		
		
		
		
		
	}
}