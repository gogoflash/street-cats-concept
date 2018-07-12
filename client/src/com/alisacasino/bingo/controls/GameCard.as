package com.alisacasino.bingo.controls
{
	import air.update.states.HSM;
	import by.blooddy.crypto.image.palette.IPalette;
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.assets.loading.GAFClipWrapper;
	import com.alisacasino.bingo.components.FadeQuad;
	import com.alisacasino.bingo.components.effects.SquareTweenLines;
	import com.alisacasino.bingo.controls.cardPatternHint.CardPattern;
	import com.alisacasino.bingo.models.Card;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.models.roomClasses.RoomType;
	import com.alisacasino.bingo.models.skinning.SkinningCardData;
	import com.alisacasino.bingo.models.skinning.SkinningDauberData;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.screens.gameScreenClasses.GameCardsViewNew;
	import com.alisacasino.bingo.screens.gameScreenClasses.GameScreenController;
	import com.alisacasino.bingo.screens.gameScreenClasses.GameUI;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.RelativePixelMovingHelper;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import feathers.core.FeathersControl;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.globalization.DateTimeFormatter;
	import flash.globalization.DateTimeStyle;
	import flash.utils.getTimer;
	import starling.animation.Tween;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.MeshBatch;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.utils.TweenHelper;
	
	import flash.utils.setTimeout;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class GameCard extends FeathersControl
	{
		private static const MAX_NEW_BALLS_COUNT:uint = 99;
		private static const BAD_BINGO_TIMER_INCREMENT:uint = 5000;
		
		private var TUTORIAL_HINT_BINGO_BUTTON_DELAY_CALL_ID:uint;
		
		public var gameCardsContainer:GameCardsViewNew;
		public var index:int;
		public var isCardInViewArea:Boolean = true;
		
		private var _baseScale:Number;
		
		private var mGameManager:GameManager = GameManager.instance;
		private var mSoundManager:SoundManager = SoundManager.instance;
		private var mGameAtlas:AtlasAsset = AtlasAsset.CommonAtlas;

		private var mPlayer:Player = Player.current;
		private var mRoom:Room = Room.current;
		public var gameScreenController:GameScreenController;
		
		public var container:Sprite;
		
		private var titleImage:Image;
		public var background:Image;
		private var bingoButton:XButton;
		
		private var _enabled:Boolean = true;
		private var mBingoBtnHintAnimation:AnimationContainer;
		private var badBingoAnimationContainer:AnimationContainer;
		private var bingoImage:Image;
		private var mCells:Vector.<GameCardCell>;
		private var mCard:Card;
		private var centralCell:Image;
		private var badBingoLayer:Sprite;
		private var fadeImage:Image;
		
		private var cellsTotalHorisontal:uint = 5;
		private var cellsTotalVertical:uint = 5;
		
		private var cellWidth:Number = 0;
		private var cellHeight:Number = 0;
		private var cellStartX:Number = 0;
		private var cellStartY:Number = 0;
		private var cellFinishX:Number = 0;
		private var cellFinishY:Number = 0;
		private var cellNumberShiftX:Number = 0;
		private var cellNumberShiftY:Number = 0;
		
		public var cellLayerBottom:Sprite;
		public var cellLayerIcons:Sprite;
		public var cellLayerTextFields:Sprite;
		public var cellLayerAnimations:Sprite;
		public var topLayerAnimations:Sprite;
		
		private var cardPatterns:Vector.<CardPattern>;
		
		private var badBingoTimer:XTextField;
		private var formatter:DateTimeFormatter;
		
		private var cellsByBallNumbersCache:Object;
		private var cellsMagicDaubsNumbersCache:Object;
		private var daubMarkCache:Object = {};
		private var _bingoComplete:Boolean;
		private var _localCheckBingo:Boolean;
		
		private var isTabletLayout:Boolean;
		
		private var x2Plate:Image;
		private var x2Progress:GameCardX2Progress;
		private var x2EdgeGlowImages:Vector.<Image> = new <Image>[];
		private var isX2Mode:Boolean;
		
		private var debugBGQuad:Quad;
		private var debugButton:XButton;
		private var cardSkin:SkinningCardData;
		private var dauberSkin:SkinningDauberData;
		
		private var bingoButtonStyle:XButtonStyle;
		private var bingoButtonStyleX2:XButtonStyle;
		
		public function GameCard(card:Card, index:int)
		{
			gameScreenController = Game.current.gameScreen.gameScreenController;
			cardSkin = gameManager.skinningData.cardSkin;
			dauberSkin = gameManager.skinningData.dauberSkin;
			
			bingoButtonStyle = new XButtonStyle({upState:"bingo_button", atlas:cardSkin.atlas});
			bingoButtonStyleX2 = new XButtonStyle({upState:"bingo_button", atlas:gameManager.skinningData.cardSkinX2.atlas});
			
			isTabletLayout = gameManager.layoutHelper.isLargeScreen;
			
			container = new Sprite();
			addChild(container);
			
			cardPatterns = CardPattern.getCardPatternByRoomPattern(mRoom.roomType.roomPattern);
			
			background = new Image(cardSkin.getTexture('card_background', false));
			//background.touchable = false
			
			centralCell = new Image(dauberSkin.getTexture("magicdaub"));
			
			container.addChild(background);
			//container.addChild(centralCell);
			
			titleImage = new Image(cardSkin.getTexture("title"));
			titleImage.alignPivot();
			titleImage.touchable = false;
			//titleImage.x = (background.width - titleImage.width) / 2;
			titleImage.y = 39*pxScale;
			container.addChild(titleImage);
			
			bingoButton = new XButton(bingoButtonStyle);
			bingoButton.addEventListener(Event.TRIGGERED, onBingoBtnClick);
			
			mCells = new Vector.<GameCardCell>(24, true);
			mCard = card;
			this.index = index;
			
			x2Progress = new GameCardX2Progress(this, index);
			
			cellLayerBottom = new Sprite();
			cellLayerBottom.touchable = false;
			
			cellLayerIcons = new Sprite();
			cellLayerIcons.touchable = false;
			
			cellLayerTextFields = new Sprite();
			cellLayerTextFields.touchable = false;
			
			cellLayerAnimations = new Sprite();
			cellLayerAnimations.touchable = false;
			
			topLayerAnimations = new Sprite();
			topLayerAnimations.touchable = false;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(TouchEvent.TOUCH, onTouch);
			
			resize();
			
			cellsByBallNumbersCache = {};
			for (var i:int = 0; i < card.numbers.length; i++)
			{
				mCells[i] = new GameCardCell(i, card.numbers[i], this, new Point(xOfIndex(i), yOfIndex(i)), cellWidth, cellHeight, cellNumberShiftX, cellNumberShiftY);
				cellsByBallNumbersCache[card.numbers[i]] = mCells[i];
			}
			
			cellsMagicDaubsNumbersCache = {};
		}
		
		public function refreshLayout():void
		{
			if (isTabletLayout == gameManager.layoutHelper.isLargeScreen)
				return;
			
			isTabletLayout = gameManager.layoutHelper.isLargeScreen;
			
			resize();
			
			var i:int;
			var length:int = mCells.length;
			for (i = 0; i < length; i++)
			{
				mCells[i].setCellSize(new Point(xOfIndex(i), yOfIndex(i)), cellWidth, cellHeight, cellNumberShiftX, cellNumberShiftY);
			}
		
			//			redrawDaubsQuadBatch();
		
			   /*if (!debugBGQuad) {
			   debugBGQuad = new Quad(width, height, Math.random() * 0xFF00FF);
			   debugBGQuad.alpha = 0.6;
			   addChild(debugBGQuad);
			   }
			   else {
			   debugBGQuad.width = width;
			   debugBGQuad.height = height;
			   addChild(debugBGQuad);
			   }*/
		}
		
		/*Базовое значение скейла. Карта может скейлится эффектами как угодно, но в итоге должна вернуться к базовому скейлу.*/
		public function get baseScale():Number { 
			return _baseScale; 
		}
        
		public function set baseScale(value:Number):void { 
			_baseScale = value; 
		}
		
		public function refreshSkinTextures():void
		{
			var isX2Powerup:Boolean = gameScreenController.isX2Active(index);
			
			cardSkin = gameManager.skinningData.cardSkin;
			dauberSkin = gameManager.skinningData.dauberSkin;
			
			bingoButtonStyle = new XButtonStyle({upState:"bingo_button", atlas:cardSkin.atlas});
			bingoButtonStyleX2 = new XButtonStyle({upState:"bingo_button", atlas:gameManager.skinningData.cardSkinX2.atlas});
			
			centralCell.texture = dauberSkin.getTexture(isX2Powerup ? "magicdaub_2x" : "magicdaub");
			
			resize();
			
			var cellIndex:int;
			var mark:Image;
			for (cellIndex in daubMarkCache)
			{
				mark = daubMarkCache[cellIndex] as Image;
				mark.texture = dauberSkin.getDaubTexture(isX2Powerup);
			}
			
			
			var i:int;
			var length:int = mCells.length;
			for (i = 0; i < length; i++)
			{
				mCells[i].refreshSkinTextures();
			}
		}
		
		private function resize():void
		{
			var isX2Powerup:Boolean = gameScreenController.isX2Active(index);
			
			background.texture = cardSkin.getTexture('card_background', isX2Powerup);
			background.readjustSize();
			
			cellWidth = (isTabletLayout ? 101 : 88) * pxScale;
			cellHeight = 88 * pxScale;
			cellStartX = (isTabletLayout ? 15 : 13) * pxScale;
			cellStartY = (isTabletLayout ? 85 : 85) * pxScale;
			cellFinishX = cellStartX + cellWidth * 5;
			cellFinishY = cellStartY + cellHeight * 5;
			cellNumberShiftX = (isTabletLayout ? -1 : -1) * pxScale;
			cellNumberShiftY = (isTabletLayout ? -8 : -8) * pxScale;
			//trace(' > ', cellStartX, cellStartY, cellFinishX, cellFinishY);
			
			width = baseWidth//background.width;
			height = baseHeight//background.height;
			
			
			background.x = (baseWidth - background.width) / 2;
			background.y = baseHeight - background.height;
			
			
			container.pivotX = width / 2;
			container.pivotY = height / 2;
			container.x = container.pivotX;
			container.y = container.pivotY;
			
			centralCell.x = baseWidth - centralCell.width >> 1;
			centralCell.y = (baseHeight - centralCell.height >> 1) + 4 * pxScale;
			
			titleImage.texture = cardSkin.getTexture("title", isX2Powerup);
			titleImage.readjustSize();
			titleImage.alignPivot();
			titleImage.x = baseWidth / 2;
			titleImage.y = 39*pxScale;
			
			bingoButton.setStyle(isX2Powerup ? bingoButtonStyleX2 : bingoButtonStyle, '', '', true);
			bingoButton.alignPivot();
			alignBingoButton();
			
			alignFadeImage();
			
			if (bingoImage)
				alignBingoImage();
				
			// refresh daubs positions
			var cellIndex:int;
			var mark:Image;
			for (cellIndex in daubMarkCache)
			{
				mark = daubMarkCache[cellIndex] as Image;
				mark.x = mark.pivotX + xOfIndex(cellIndex) + (cellWidth - mark.width) / 2;
				mark.y = mark.pivotY + yOfIndex(cellIndex);
			}
			
			x2Progress.refresh();
		}
		
		public override function dispose():void
		{
			tutorialStepHideHandOnBingoButton();
			
			onRemovedFromStage(null);
			removeBingoButtonHint();
			cellsByBallNumbersCache = null;
			cellsMagicDaubsNumbersCache = {};
			
			Starling.current.stage.removeEventListener(Event.ENTER_FRAME, handler_badBingoEnterFrame);
			
			if (badBingoAnimationContainer)
			{
				badBingoAnimationContainer.removeFromParent();
				badBingoAnimationContainer.removeClipEventListener("animationBadBingoFreeze", handler_animationBadBingoFreeze);
				badBingoAnimationContainer.removeClipEventListener("animationBadBingoFinish", handler_animationBadBingoFinish);
			}
			
			if (badBingoLayer)
			{
				badBingoLayer.removeFromParent();
				badBingoLayer = null;
			}
			
			Starling.juggler.removeTweens(x2Plate);
			removeX2Plate();
			
			super.dispose();
		}
		
		private function xOfIndex(index:uint):Number
		{
			if (index >= 12)
			{
				index += 1;
			}
			
			return ((index % 5) * cellWidth + cellStartX);
		}
		
		private function yOfIndex(index:uint):Number
		{
			if (index >= 12)
			{
				index += 1;
			}
			return (Math.floor(index / 5) * cellHeight + cellStartY);
		}
		
		private function onAddedToStage(e:Event):void
		{
			centralCell.x = (baseWidth - centralCell.width >> 1) - 0 * pxScale;
			centralCell.y = (baseHeight - centralCell.height >> 1) + 4 * pxScale;
			
			//container.addChild(bingoButton);
			alignBingoButton();
			
			if (!GameManager.instance.deactivated) {
				addCellLayers();
				createCellNumbers();
				markFirstBalls();
			}
			else {
				Game.addEventListener(Game.ACTIVATED, game_activatedHandler);
			}
			
			//addPowerupCells();
			
			if (Player.current.getBadBingoFinishTime(mRoom.roomType.roomTypeName, mCard.cardId) > Game.connectionManager.currentServerTime)
			{
				enabled = false;
				showBadBingoTimer();
			}
		
			/*debugButton = new XButton(XButtonStyle.MiniGamesSwitchBack, Constants.BUTTON_BINGO);
		   debugButton.addEventListener(Event.TRIGGERED, debugButtonClick);
		   debugButton.width = 70;
		   debugButton.height = 70;
		   debugButton.y = bingoButton.y;
		   container.addChild(debugButton);*/
		}
		
		private function game_activatedHandler(e:Event):void
		{
			Game.removeEventListener(Game.ACTIVATED, game_activatedHandler);
			addCellLayers();
			createCellNumbers();
			markFirstBalls();
		}
		
		private function createCellNumbers():void
		{
			var length:int = mCard.numbers.length;
			for (var i:int = 0; i < length; i++) {
				mCells[i].createCellNumber(false, mCells[i].marked);
			}
		}
		
		private function addCellLayers():void
		{
			if (!contains(cellLayerBottom))
			{
				var startIndex:int = container.getChildIndex(background) + 1;
				
				container.addChildAt(cellLayerBottom, startIndex++);
				container.addChildAt(bingoButton, startIndex++);
				container.addChildAt(centralCell, startIndex++);
				container.addChildAt(cellLayerIcons, startIndex++);
				container.addChildAt(cellLayerTextFields, startIndex++);
				container.addChildAt(cellLayerAnimations, startIndex++);
			}
		}
		
		/*
		   private function addPowerupCells():void
		   {
		   var minPowerupCellsCount:int = 0;
		   var maxPowerupCellsCount:int = 0;
		   if (mPlayer.coinsAntiAccumulationPolicyEnabled || mPlayer.bingoRatio >= Constants.BINGO_RATIO_TOO_HIGH)
		   {
		   minPowerupCellsCount = 0;
		   maxPowerupCellsCount = 2;
		   }
		   else
		   {
		   minPowerupCellsCount = 1;
		   maxPowerupCellsCount = (mPlayer.cards.length <= 2) ? 5 : 3;
		   }
		   var powerupCellsCount:int = int(Math.random() * (maxPowerupCellsCount - minPowerupCellsCount + 1)) + minPowerupCellsCount;
		
		   var isPlayerRunningOutOfCoins:Boolean = mPlayer.coinsCount <= Constants.ANTI_ACCUMULATION_POLICY_COINS_THRESHOLD && (mPlayer.energyCount == 0 || mPlayer.keysCount == 0);
		   if (isPlayerRunningOutOfCoins)
		   {
		   powerupCellsCount += (mPlayer.cards.length <= 2) ? 2 : 1;
		   }
		
		   if (mRoom.hasActiveEvent && mRoom.activeEvent.dailyEvent)
		   {
		   powerupCellsCount = 0;
		   }
		
		   for (var i:int = 0; i < powerupCellsCount; i++)
		   {
		   var cell:GameCardCell = getRandomNotDaubedCellWithoutPowerup();
		   if (cell)
		   {
		   var rnd:Number = Math.random();
		   if (isPlayerRunningOutOfCoins && i < 2)
		   {
		   cell.addFreeCoin(false);
		   }
		   else if (rnd < 0.5)
		   {
		   cell.addMagicBox(false);
		   }
		   else if (rnd < 0.75)
		   {
		   if (mPlayer.luckyness >= 0 && !mPlayer.ticketsAntiAccumulationPolicyEnabled)
		   {
		   cell.addFreeTicket(false);
		   }
		   }
		   else
		   {
		   if (mPlayer.luckyness >= 0 && !mPlayer.coinsAntiAccumulationPolicyEnabled)
		   {
		   cell.addFreeCoin(false);
		   }
		   }
		   }
		   }
		
		   if (mRoom.hasActiveEvent)
		   {
		   var freeScoreCellsCount:int = int(Math.random() * (mPlayer.cards.length <= 2 ? 3 : 2)) + 1;
		   for (var j:int = 0; j < freeScoreCellsCount; j++)
		   {
		   var cell = getRandomNotDaubedCellWithoutPowerup();
		   if (cell)
		   {
		   cell.addFreeScore();
		   }
		   }
		   }
		
		   }
		 */
		
		private function onRemovedFromStage(e:Event):void
		{
			if (badBingoAnimationContainer)
			{
				//Starling.juggler.remove(badBingoAnimationContainer);
				badBingoAnimationContainer.removeFromParent();
				//badBingoMovieClip.putToPool(badBingoAnimationContainer);
			}
			
			if (bingoImage)
				Starling.juggler.removeTweens(bingoImage)
		}
		
		private function markFirstBalls():void
		{
			if (mRoom.numbers.length == 0 || mRoom.numbers.length > MAX_NEW_BALLS_COUNT)
			{
				return;
			}
			
			var i:int;
			var length:int = mCells.length;
			var cell:GameCardCell;
			for (i = 0; i < length; i++)
			{
				cell = mCells[i];
				if (mRoom.numbers.indexOf(cell.number) != -1)
				{
					cell.marked = true;
					cell.daubed = true;
					mCard.daubedNumbers.push(cell.number);
				}
			}
			
			showBingoButtonHint();
		}
		
		public function onBingo():void
		{
			gameScreenController.x2Clean(index);
			
			for each (var cell:GameCardCell in mCells) {
				cell.x2Clean();
				cell.removeDaubHintAnimation();
			}
			
			_bingoComplete = true;
			setFadeImage(true, 0, 0.55);
		}
		
		public function blinkFadeImage(delay:Number = 0, time:Number = 0.2):void
		{
			if (!fadeImage)
				return;
			TweenHelper.tween(fadeImage, time/2, {transition:Transitions.LINEAR, delay:delay, alpha:0}).chain(fadeImage, time/2, {transition:Transitions.LINEAR, alpha:1});
		}
		
		public function showBingoImage():void
		{
			bingoImage = new Image(AtlasAsset.CommonAtlas.getTexture("card/bingo/bingo"));
			bingoImage.alignPivot();
			container.addChild(bingoImage);
			alignBingoImage();
			
			var tween_0:Tween = new Tween(bingoImage, 0.12, Transitions.LINEAR);
			var tween_1:Tween = new Tween(bingoImage, 0.1, Transitions.LINEAR);
			var tween_2:Tween = new Tween(bingoImage, 0.11, Transitions.LINEAR);
			
			tween_0.delay = 0.04;
			tween_0.animate('scaleX', bingoImage.scale * 1.05);
			tween_0.animate('scaleY', bingoImage.scale * 1.37);
			tween_0.nextTween = tween_1;
			
			tween_1.animate('scaleX', bingoImage.scale * 1.02);
			tween_1.animate('scaleY', bingoImage.scale * 0.93);
			tween_1.nextTween = tween_2;
		
			tween_2.animate('scale', bingoImage.scale);
			Starling.juggler.add(tween_0);
		}
		
		private function alignBingoImage():void
		{
			bingoImage.scale = isTabletLayout ? 1.146 : 1;
			bingoImage.x = baseWidth / 2 + 3 * bingoImage.scale * pxScale;
			bingoImage.y = baseHeight / 2 - 12.85 * bingoImage.scale * pxScale;
		}
		
		public function addBallNumber(ballNumber:int):void
		{
			if (!gameManager.gameHintsManager.isEnabled 
				|| !stage 
				|| !(ballNumber in cellsByBallNumbersCache) 
				|| _bingoComplete 
				|| (!_enabled && gameManager.tutorialManager.tutorialFirstLevelPassed && gameManager.tutorialManager.tutorialLevelsPassed) 
				)
				return;
			
			if (mCard.magicDaubs.indexOf(ballNumber) != -1)
				return;
			
			var cell:GameCardCell = cellsByBallNumbersCache[ballNumber] as GameCardCell;
			cell.playDaubHintAnimation();
		}
		
		public function hasUndaubedNumber(ballNumber:int):Boolean
		{
			// возможно учесть, что номер может быть ложнозадаублен. то есть выбран раньше и это бэд
			
			if (!(ballNumber in cellsByBallNumbersCache) || _bingoComplete || !_enabled)
				return false;
			
			if (mCard.magicDaubs.indexOf(ballNumber) != -1)
				return false;
			
			return true;	
		}
		
		private function onBingoBtnClick(e:Event):void
		{
			//(Game.current.currentScreen as GameScreen).gameUI.showBingo(card.cardId);//debugShowBingoOnRandomCard();
			//(Game.current.currentScreen as GameScreen).gameUI.showBingo(0); (Game.current.currentScreen as GameScreen).gameUI.showBingo(1); //(Game.current.currentScreen as GameScreen).gameUI.showBingo(2); (Game.current.currentScreen as GameScreen).gameUI.showBingo(3);
			//enabled = false;
			//return;
			
			//debugShowBadBingo();
			//return;
			
			enabled = false;
			
			if (gameManager.tutorialManager.tutorialFirstLevelPassed)
				removeDaubHintAnimations();
			
			_localCheckBingo = checkIsBingo().length > 0;
			
			var badBingoTimeCoefficient:int;
			if (!gameManager.tutorialManager.tutorialFirstLevelPassed)
				badBingoTimeCoefficient = 0;
			else 
				badBingoTimeCoefficient = Player.current.getBadBingoTimeCoefficient(mRoom.roomType.roomTypeName, mCard.cardId);
			
			if (_localCheckBingo || badBingoTimeCoefficient >= gameManager.gameData.badBingoTimerAttempts)
			{
				//trace('onBingoBtnClick > bingo OK');
				
				if (!gameManager.tutorialManager.tutorialFirstLevelPassed || !gameManager.tutorialManager.tutorialLevelsPassed)
				{
					if (_localCheckBingo)
					{
						handleTutorialBingo();
					}
					else
					{
						Player.current.badBingosInARound++;
						
						SoundManager.instance.playBadBingo();
						SoundManager.instance.playSfx(SoundAsset.BadBingoOpen);
						onBadBingo();
						
						if(Player.current.badBingosInARound >= Player.current.cards.length)
							gameManager.tutorialManager.finishTutorialRound(false);
					}
				}
				else
				{
					if (Player.IS_DEBUG_ROUND) 
					{
						if (_localCheckBingo)
							gameScreenController.confirmBingo(mCard.cardId, Math.random() > 0.5 ? 1 : int(1 + Math.random() * 10));
						else
							Game.current.gameScreen.gameUI.showBadBingo(mCard.cardId);	
					}
					else 
					{
						Game.connectionManager.sendBingoMessage(mCard);
					}
				}
				
				removeBingoButtonHint();
			}
			else
			{
				//trace('onBingoBtnClick > bingo BAD');
				
				badBingoTimeCoefficient++;
				Player.current.setBadBingoTimeCoefficient(mRoom.roomType.roomTypeName, mCard.cardId, badBingoTimeCoefficient);
				
				Player.current.setBadBingoFinishTime(mRoom.roomType.roomTypeName, mCard.cardId, Game.connectionManager.currentServerTime + BAD_BINGO_TIMER_INCREMENT * badBingoTimeCoefficient + 999);
				showBadBingoTimer();
				
				mSoundManager.playBadBingo();
				SoundManager.instance.playSfx(SoundAsset.BadBingoOpen);
			}
		}
		
		/**
		 * checkDaubs:Boolean = true - проверять на предмет бинго только отмеченные клетки. 
		 * При false можно проверить, что комбинация для бинги существует, но юзер забыл или еще не успел отметить необходимые клетки.
		 * */
		public function checkIsBingo(checkDaubs:Boolean = true, returnOnFirstCompleted:Boolean = true):Vector.<String>
		{
			var cardPattern:CardPattern;
			
			var i:int;
			var j:int;
			var length:int;
			var patternsLength:int = cardPatterns.length;
			var point:Point;
			var cellId:int;
			var cellNumber:int;
			var filledPatternIds:Vector.<String> = new Vector.<String>();
			for (i = 0; i < patternsLength; i++)
			{
				cardPattern = cardPatterns[i];
				length = cardPattern.filledPositions.length;
				for (j = 0; j < length; j++)
				{
					point = cardPattern.filledPositions[j];
					cellId = point.y * 5 + point.x;
					
					// cellId == 12 is center always daubed cell 
					if (cellId != 12)
					{
						if (cellId > 11)
							cellId--;
						cellNumber = mCard.numbers[cellId];
						if (mCard.magicDaubs.indexOf(cellNumber) == -1 && (mRoom.numbers.indexOf(cellNumber) == -1 || (checkDaubs && mCard.daubedNumbers.indexOf(cellNumber) == -1)))
							break;
					}
					
					if (j == length - 1) 
					{
						filledPatternIds.push(cardPattern.id);
						
						if(returnOnFirstCompleted)
							return filledPatternIds;
					}
				}
			}
			
			return filledPatternIds;
		}
		
		private function setFadeImage(value:Boolean, delay:Number = 0, time:Number = 0.2):void
		{
			if (value)
			{
				if (!fadeImage)
				{
					fadeImage = new Image(mGameAtlas.getTexture("card/card_fade"));
					fadeImage.touchable = false;
					fadeImage.alignPivot();
				}
				
				alignFadeImage();
				fadeImage.alpha = 0;
				container.addChild(fadeImage);
				Starling.juggler.tween(fadeImage, time, {transition: Transitions.LINEAR, delay: delay, alpha: 1});
				
			}
			else
			{
				Starling.juggler.tween(fadeImage, time, {transition: Transitions.LINEAR, delay: delay, alpha: 0, onComplete: completeRemoveFadeImage});
			}
		}
		
		private function completeRemoveFadeImage():void
		{
			if (fadeImage)
				fadeImage.removeFromParent();
		}
		
		public function set enabled(value:Boolean):void
		{
			if (_enabled == value)
				return;
			
			_enabled = value;
			bingoButton.enabled = _enabled;
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function get bingoComplete():Boolean
		{
			return _bingoComplete;
		}
		
		/*********************************************************************************************************
		 *
		 * BAD BINGO
		 *
		 * ******************************************************************************************************/
		
		public function onBadBingo(createTimer:Boolean = false):void
		{
			//trace('onBadBingo', createTimer);
			
			if (!badBingoLayer)
			{
				setFadeImage(true);
				
				badBingoLayer = new Sprite();
				badBingoLayer.touchable = false;
				topLayerAnimations.addChild(badBingoLayer);
				
				badBingoLayer.x = baseWidth >> 1;
				badBingoLayer.y = baseHeight >> 1;
				
				badBingoAnimationContainer = new AnimationContainer(MovieClipAsset.PackBase, false, false, 'bad_bingo');
				badBingoLayer.addChild(badBingoAnimationContainer);
				//badBingoAnimationContainer.pivotX = 264 * pxScale;
				//badBingoAnimationContainer.pivotY = 300 * pxScale;
				badBingoAnimationContainer.y = 1*pxScale;
				badBingoAnimationContainer.goToAndPlay(isTabletLayout ? 178 : 0);
				
				badBingoAnimationContainer.addClipEventListener("animationBadBingoFreeze", handler_animationBadBingoFreeze);
				badBingoAnimationContainer.addEventOnFrame(isTabletLayout ? 322 : 145, "animationBadBingoFreeze");
			}
			
			if (createTimer)
			{
				badBingoTimer = new XTextField(300 * pxScale, 256 * pxScale, XTextFieldStyle.BadBingoTimerTextFieldStyle, badBingoFormattedTime);
				badBingoTimer.pivotX = ((badBingoTimer.textBounds.width) >> 1) + badBingoTimer.textBounds.x;
				badBingoTimer.pivotY = badBingoTimer.height >> 1;
				badBingoTimer.x = 45 * pxScale;
				badBingoTimer.y = 125 * pxScale;
				badBingoLayer.addChild(badBingoTimer);
				
				EffectsManager.scaleJumpAppearElastic(badBingoTimer, 1, 0.7, 0.4);
			}
		}
		
		private function handler_animationBadBingoFreeze(event:Event):void
		{
			badBingoAnimationContainer.removeClipEventListener("animationBadBingoFreeze", handler_animationBadBingoFreeze);
			badBingoAnimationContainer.stop();
		}
		
		private function showBadBingoTimer():void
		{
			onBadBingo(true);
			
			handler_badBingoEnterFrame(null);
			Starling.current.stage.addEventListener(Event.ENTER_FRAME, handler_badBingoEnterFrame);
		}
		
		private function handler_badBingoEnterFrame(e:Event):void
		{
			if (Player.current.getBadBingoFinishTime(mRoom.roomType.roomTypeName, mCard.cardId) > Game.connectionManager.currentServerTime)
			{
				if (badBingoTimer.text != badBingoFormattedTime)
					SoundManager.instance.playSfx(SoundAsset.BadBingoTimer, 0, 0, 1, 0, true);
				
				badBingoTimer.text = badBingoFormattedTime;
			}
			else
			{
				badBingoAnimationContainer.addClipEventListener("animationBadBingoFinish", handler_animationBadBingoFinish);
				badBingoAnimationContainer.addEventOnFrame(isTabletLayout ? badBingoAnimationContainer.totalFrames : 177, "animationBadBingoFinish");
				badBingoAnimationContainer.goToAndPlay(isTabletLayout ? 323 : 146);
				
				Starling.current.stage.removeEventListener(Event.ENTER_FRAME, handler_badBingoEnterFrame);
				
				EffectsManager.scaleJumpDisappear(badBingoTimer, 0.3);
				
				SoundManager.instance.playSfx(SoundAsset.BadBingoClose);
				//Starling.juggler.tween(badBingoLayer, 0.3, {transition: Transitions.EASE_IN_BACK, onComplete: completeRemoveBadBingoTimer, scaleX: 0, scaleY: 0});
			}
		}
		
		private function handler_animationBadBingoFinish(event:Event):void
		{
			badBingoAnimationContainer.removeClipEventListener("animationBadBingoFinish", handler_animationBadBingoFinish);
			badBingoAnimationContainer.stop();
			
			badBingoAnimationContainer.removeFromParent();
			badBingoAnimationContainer.scaleX = 1;
			
			completeRemoveBadBingoTimer();
		}
		
		private function get badBingoFormattedTime():String
		{
			if (!formatter)
			{
				formatter = new DateTimeFormatter("en_US", "long", DateTimeStyle.SHORT);
				formatter.setDateTimePattern("m:ss");
			}
			
			return formatter.formatUTC(new Date(Math.max(0, Player.current.getBadBingoFinishTime(mRoom.roomType.roomTypeName, mCard.cardId) - Game.connectionManager.currentServerTime)));
		}
		
		private function completeRemoveBadBingoTimer():void
		{
			if (badBingoLayer)
			{
				badBingoLayer.removeFromParent();
				badBingoLayer = null;
			}
			
			setFadeImage(false);
			
			badBingoTimer = null;
			
			enabled = true;
		}
		
		public function get isUnderBadBingoTimeout():Boolean {
			return (Player.current.getBadBingoTimeCoefficient(mRoom.roomType.roomTypeName, mCard.cardId) <= gameManager.gameData.badBingoTimerAttempts) &&
			(Player.current.getBadBingoFinishTime(mRoom.roomType.roomTypeName, mCard.cardId) > Game.connectionManager.currentServerTime);
		}
		
		public function get isCardFullyBlocked():Boolean 
		{
			if (enabled)
				return false;
			
			return _bingoComplete || (badBingoLayer && !badBingoTimer);
		}
		
		/*********************************************************************************************************
		 *
		 *
		 *
		 * ******************************************************************************************************/
		
		public function get card():Card
		{
			return mCard;
		}
		
		public function get baseWidth():Number
		{
			return (isTabletLayout ? 535 : 467)*pxScale;
			
			/*if (background)
			{
				return background.width;
			}
			return 1;*/
		}
		
		public function get baseHeight():Number
		{
			return (isTabletLayout ? 600 : 601)*pxScale;
			
			/*if (background)
				return background.height;
			
			return 1;*/
		}
		
		public function onScroll():void
		{
			mIsDown = false;
		}
		
		private var mIsDown:Boolean;
		private static const MAX_DRAG_DIST:Number = 20;
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			if (!touch || !_enabled)
				return;
			
			var rect:Rectangle = getBounds(stage);
			if (touch.phase == TouchPhase.BEGAN && !mIsDown)
			{
				mIsDown = true;
			}
			else if (touch.phase == TouchPhase.MOVED && mIsDown)
			{
				
				if (touch.globalX < rect.x - MAX_DRAG_DIST || touch.globalY < rect.y - MAX_DRAG_DIST || touch.globalX > rect.x + rect.width + MAX_DRAG_DIST || touch.globalY > rect.y + rect.height + MAX_DRAG_DIST)
				{
					mIsDown = false;
				}
			}
			else if (touch.phase == TouchPhase.ENDED && mIsDown)
			{
				mIsDown = false;
				
				var normalizedTouchX:Number = (touch.globalX - rect.x) * (1 / scaleX);
				var normalizedTouchY:Number = (touch.globalY - rect.y) * (1 / scaleY);
				
				/*var quad:Quad = new Quad(1, 1, 0xFF0000);
				   quad.alpha = 0.5;
				   addChild(quad);
				   quad.width = cellWidth;
				   quad.height = cellHeight;
				   quad.x = normalizedTouchX;
				   quad.y = normalizedTouchY;
				   quad.touchable = false;*/
				
				if (normalizedTouchX > cellStartX && normalizedTouchX < cellFinishX && normalizedTouchY > cellStartY && normalizedTouchY < cellFinishY)
				{
					//trace("> ", Math.floor((normalizedTouchX - cellStartX)/(cellSize)), Math.floor((normalizedTouchY - cellStartY)/(cellSize*pxScale)) );
					cellTriggered(Math.floor((normalizedTouchX - cellStartX) / cellWidth), Math.floor((normalizedTouchY - cellStartY) / cellHeight));
				}
			}
		}
		
		private function cellTriggered(cellHorisontalId:int, cellVerticalId:int):void
		{
			if (!_enabled)
				return;
			
			if (cellHorisontalId == 2 && cellVerticalId == 2)
				return;
			
			var cellId:int = cellVerticalId * 5 + cellHorisontalId;
			
			if (cellId > 11)
				cellId--;
			
			//trace("triggered ", cellHorisontalId, cellVerticalId, cellId);	
			
			var cell:GameCardCell = mCells[cellId];
			
			/*cell.playDaubHintAnimation();
			   showBingoButtonHint();
			   return;*/
			
			if (cell.daubed)
				return;
			
			cell.marked = !cell.marked;
			
			//tweenCellsJumpApart(cellHorisontalId, cellVerticalId );
			//new SquareTweenLines(gameCard.cellLayerBottom, position.x + cellWidth / 2, position.y + cellHeight / 2, cellWidth, cellHeight, 12 * pxScale, cellHeight / 2, 0.27, 0.4);		
			
			//cell.daub();		
			
			SoundManager.instance.playSfx(SoundAsset.NumberMarkV3, 0, 0, 0.5, 0, true);			

			if (cell.marked)
			{
				if (mRoom.numbers.indexOf(cell.number) != -1)
				{
					mCard.daubedNumbers.push(cell.number);
					Game.dispatchEventWith(Game.DAUB_EVENT, false, {cell:cell, cardIndex:index});
					
					cell.daub();
					
					if (cell.activePowerup == Powerup.INSTABINGO)
					{
						mCard.instantBingoNumber = cell.number;
						enabled = false;
						removeBingoButtonHint();
						
						if (!gameManager.tutorialManager.tutorialFirstLevelPassed || !gameManager.tutorialManager.tutorialLevelsPassed)
							handleTutorialBingo();
						else
							Game.connectionManager.sendBingoMessage(mCard);
						
						return;
					}
					else if (cell.activePowerup == Powerup.MINIGAME)
					{
						
					}
					else if (cell.activePowerup == Powerup.X2)
					{
						SoundManager.instance.playSfx(SoundAsset.X2BoostStart, 0, 0, 0.7, 0, true);
						if (gameScreenController.isX2Active(index) && !isX2Mode) {
							isX2Mode = true;
							addEventListener(Event.ENTER_FRAME, handler_x2EnterFrame);
							//SoundManager.instance.playSfx(SoundAsset.X2BoostStart, 0, 0, 0.7, 0, true);
							tweenCardToX2();
						}
					}
					
					tutorialTryShowHandOnBingoButton();
				}
				else
				{
					Game.dispatchEventWith(Game.DAUB_MISS_EVENT, false, {cell:cell, cardIndex:index});
				}
			}
			
			if (!gameManager.tutorialManager.tutorialFirstLevelPassed && cell.marked && !cell.daubed)
				cell.disableMarked();
			
			showBingoButtonHint();
		}
		
		private function tutorialTryShowHandOnBingoButton():void {
			if (!gameManager.tutorialManager.tutorialFirstLevelPassed && checkIsBingo().length > 0 && TUTORIAL_HINT_BINGO_BUTTON_DELAY_CALL_ID == 0) {
				Starling.juggler.removeByID(TUTORIAL_HINT_BINGO_BUTTON_DELAY_CALL_ID);
				TUTORIAL_HINT_BINGO_BUTTON_DELAY_CALL_ID = Starling.juggler.delayCall(tutorialStepShowHandOnBingoButton, 3);
			}
		}
		
		private function tutorialStepShowHandOnBingoButton():void
		{
			var gameUI:GameUI = Game.current.gameScreen.gameUI;
			gameUI.topLayer.touchable = true;
			FadeQuad.show(gameUI.topLayer, 0.2, 0.8, true, tutorialStepHideHandOnBingoButton, 2000);
			
			var point:Point = localToGlobal(new Point(bingoButton.x, bingoButton.y));
			
			EffectsManager.removeJump(bingoButton);	
			
			gameUI.topLayer.addChild(bingoButton);
			bingoButton.scale = scale;
			bingoButton.x = point.x;
			bingoButton.y = point.y;
			
			EffectsManager.jump(bingoButton, 1000, scale, 1.3*scale, 0.12, 0.12, 1.3, 2, 0, 1.8, true);	
			
			gameManager.tutorialManager.showHand(gameUI.topLayer, bingoButton.x - (bingoButton.width/2) + 15*scale, bingoButton.y, 0.5, 0, scale, scale);
		}
		
		private function tutorialStepHideHandOnBingoButton():void
		{
			Starling.juggler.removeByID(TUTORIAL_HINT_BINGO_BUTTON_DELAY_CALL_ID);
			
			var gameUI:GameUI = Game.current.gameScreen.gameUI;
			gameUI.topLayer.touchable = false;
			FadeQuad.hide();
			
			gameManager.tutorialManager.hideHand();
			
			addChild(bingoButton);
			
			EffectsManager.removeJump(bingoButton);	
			bingoButton.scale = 1;
			showBingoButtonHint();
			
			alignBingoButton();
		}
		
		private function showBingoButtonHint():void
		{
			//trace((Player.current.gamesCount > Constants.BINGO_BUTTON_HIGHLIGHT_HINT_GAMES_COUNT || !checkIsBingo().length > 0), checkIsBingo());
			
			if ((!gameManager.gameHintsManager.isEnabled && !gameManager.skinningData.isUseCompleteSet) || _bingoComplete || !checkIsBingo().length > 0 || Room.current.roomType.isBlackout)
				return;
				
			EffectsManager.jump(bingoButton, 1000, 1, 1.3, 0.12, 0.12, 1.3, 2, 0, 1.8, true);	
		}
		
		private function handler_bingoButtonHintAnimationComplete(e:Event):void
		{
			if (!mBingoBtnHintAnimation)
				return;
			//mBingoBtnHintAnimation.removeEventListener(Event.COMPLETE, handler_bingoButtonHintAnimationComplete);
			mBingoBtnHintAnimation.removeFromParent();
			mBingoBtnHintAnimation.stop();
			mBingoBtnHintAnimation = null;
		}
		
		private function removeBingoButtonHint():void
		{
			handler_bingoButtonHintAnimationComplete(null);
			EffectsManager.removeJump(bingoButton);
		}
		
		public function refreshDaubMark(cell:GameCardCell, value:Boolean, animate:Boolean = true):void
		{
			var i:int = cell.index;
			
			if (value)
			{
				if (i in daubMarkCache)
					return;
			
				var mark:Image = new Image(dauberSkin.getDaubTexture(gameScreenController.isX2Active(index)));
				mark.alignPivot();
				//cellLayerTextFields.addChildAt(mark, 0);
				var shiftX:Number = (cellWidth - mark.width) / 2;
				mark.x = mark.pivotX + xOfIndex(i) + shiftX;
				mark.y = mark.pivotY + yOfIndex(i);
				daubMarkCache[i] = mark;
				
				if (animate)
				{
					cellLayerTextFields.addChild(mark);
					
					mark.scaleX = 0;
					mark.scaleY = 0.68;
					
					var tween_0:Tween = new Tween(mark, 0.09, Transitions.EASE_OUT);
					var tween_1:Tween = new Tween(mark, 0.07, Transitions.EASE_IN);
					var tween_2:Tween = new Tween(mark, 0.06, Transitions.EASE_IN);
					var tween_3:Tween = new Tween(mark, 0.06, Transitions.EASE_OUT);
					
					//tween_0.delay = nextDelay * i;
					tween_0.animate('scaleX', 1.82);
					tween_0.animate('scaleY', 1.32);
					tween_0.onComplete = function():void
					{
						cellLayerTextFields.addChildAt(mark, 0)
					};
					tween_0.nextTween = tween_1;
					
					tween_1.animate('scaleX', 0.87);
					tween_1.animate('scaleY', 1.36);
					tween_1.nextTween = tween_2;
					
					tween_2.animate('scaleX', 1.22);
					tween_2.animate('scaleY', 0.81);
					tween_2.nextTween = tween_3;
					
					tween_3.animate('scaleX', 1);
					tween_3.animate('scaleY', 1);
					
					Starling.juggler.add(tween_0);
					
					cell.numberLabel.scaleX = 1.49;
					
					var tweenNumber_0:Tween = new Tween(cell.numberLabel, 0.09, Transitions.EASE_IN);
					var tweenNumber_1:Tween = new Tween(cell.numberLabel, 0.07, Transitions.EASE_OUT);
					var tweenNumber_2:Tween = new Tween(cell.numberLabel, 0.06, Transitions.EASE_IN);
					
					tweenNumber_0.delay = 0.06;
					tweenNumber_0.animate('scaleX', 0.57);
					tweenNumber_0.animate('scaleY', 1.66);
					tweenNumber_0.nextTween = tweenNumber_1;
					
					tweenNumber_1.animate('scaleX', 1.1);
					tweenNumber_1.animate('scaleY', 1.1);
					tweenNumber_1.nextTween = tweenNumber_2;
					
					tweenNumber_2.animate('scaleX', 1);
					tweenNumber_2.animate('scaleY', 1);
					
					Starling.juggler.add(tweenNumber_0);
				}
				else
				{
					cellLayerTextFields.addChildAt(mark, 0);
				}
			}
			else
			{
				if (i in daubMarkCache)
				{
					Starling.juggler.removeTweens(daubMarkCache[i] as Image);
					(daubMarkCache[i] as Image).removeFromParent();
					delete daubMarkCache[i];
				}
			}
		}
		
		/*****************************************************************************************************************
		 *
		 *
		 *
		 ******************************************************************************************************************/
		 
		public function addPowerUp(powerup:String, holdUpDelay:Number = 0, tweenStyle:String = null):void
		{
			if (!_enabled && !isUnderBadBingoTimeout)
				return;
			
			var cell:GameCardCell = getRandomNotDaubedCellWithoutPowerup();
			if (!cell)
				return;
				
			switch (powerup)
			{
			case Powerup.CASH: 
				cell.addCash(holdUpDelay, tweenStyle);
				break;
			case Powerup.SCORE: 
				cell.addPoints(holdUpDelay, tweenStyle);
				break;
			case Powerup.X2: 
				cell.addX2(holdUpDelay, tweenStyle);
				break;
			case Powerup.XP: 
				cell.addXP(holdUpDelay, tweenStyle);
				break;
			case Powerup.DAUB: 
				addMagicDaub();
				break;
			case Powerup.DOUBLE_DAUB: 
				addDoubleDaub();
				break;
			case Powerup.TRIPLE_DAUB: 
				addTripleDaub();
				break;
			case Powerup.INSTABINGO: 
				cell.addInstantBingo(holdUpDelay, tweenStyle);
				break;
			case Powerup.MINIGAME: 
				cell.addMinigame(holdUpDelay, tweenStyle, gameManager.powerupModel.getRandomMinigameDrop());
				break;
			}
		}
		
		public function addMagicDaub():void
		{
			var cell:GameCardCell = getRandomNotDaubedCellWithoutPowerup();
			if (!cell)
				return;
			
			cell.addMagicDaub();
			card.magicDaubs.push(cell.number);
			cellsMagicDaubsNumbersCache[cell.number] = cell;
			
			tutorialTryShowHandOnBingoButton();
			showBingoButtonHint();
		}
		
		public function addDoubleDaub():void
		{
			addMagicDaub();
			//setTimeout(addMagicDaub, 300);
			Starling.juggler.delayCall(addMagicDaub, 0.1 * 2);
		}
		
		public function addTripleDaub():void
		{
			addMagicDaub();
			//Starling.juggler.delayCall(addMagicDaub, 0.3);
			//Starling.juggler.delayCall(addMagicDaub, 0.6);
			Starling.juggler.delayCall(addMagicDaub, 0.1 * 2);
			Starling.juggler.delayCall(addMagicDaub, 0.2 * 2);
		}
		
		private function getRandomNotDaubedCellWithoutPowerup():GameCardCell
		{
			var notDaubedCellsWithoutPowerup:Array = [];
			for each (var cell:GameCardCell in mCells)
			{
				if (cell.daubed == false && !cell.activePowerup)
					notDaubedCellsWithoutPowerup.push(cell);
			}
			
			if (notDaubedCellsWithoutPowerup.length > 0)
			{
				var randomIndex:int = Math.random() * notDaubedCellsWithoutPowerup.length;
				cell = notDaubedCellsWithoutPowerup[randomIndex];
				if (cell.marked)
					cell.marked = false;
				
				return cell;
			}
			
			return null;
		}
		
		public function getPowerupCellNumbers(powerup:String = null):Vector.<int>
		{
			var list:Vector.<int> = new Vector.<int>();
			for each (var cell:GameCardCell in mCells)
			{
				if (/*!cell.marked && */cell.daubed || !cell.activePowerup)
					continue;
				
				if ((!powerup || cell.activePowerup == powerup) && cell.activePowerup != Powerup.DAUB && cell.activePowerup != Powerup.DOUBLE_DAUB && cell.activePowerup != Powerup.TRIPLE_DAUB)
					list.push(cell.number);
			}
			
			return list;
		}
		
		/*****************************************************************************************************************
		 *
		 *
		 *
		 ******************************************************************************************************************/
		
		/*public function animateAppear(delay:Number = 0):void
		   {
		   container.alpha = 0;
		   container.scale = 1.5;
		   //Transitions.register("cardBounce", cardBounceFunction);
		   Starling.juggler.tween(container, 0.3, {"scale#":1, transition:Transitions.EASE_OUT_BACK, delay: delay})
		   Starling.juggler.tween(container, 0.1, {"alpha#":1, transition:Transitions.EASE_IN, delay: delay})
		   }
		
		   private function cardBounceFunction(ratio:Number):Number
		   {
		   var s:Number = 7.5625;
		   var p:Number = 2.75;
		   var l:Number;
		   if (ratio < (1.0/p))
		   {
		   l = s * Math.pow(ratio, 2);
		   }
		   else
		   {
		   if (ratio < (2.0/p))
		   {
		   ratio -= 1.5/p;
		   l = s * Math.pow(ratio, 2) + 0.75;
		   }
		   else
		   {
		   if (ratio < 2.5/p)
		   {
		   ratio -= 2.25/p;
		   l = s * Math.pow(ratio, 2) + 0.9375;
		   }
		   else
		   {
		   ratio -= 2.625/p;
		   l =  s * Math.pow(ratio, 2) + 0.984375;
		   }
		   }
		   }
		   return l;
		   }*/
		
		private function removeDaubHintAnimations():void
		{
			for each (var cell:GameCardCell in mCells)
			{
				cell.removeDaubHintAnimation();
			}
		}
		
		/*******************************************************************************************
		 *
		 * Effects
		 *
		 ******************************************************************************************/
		
		public function tweenCellsJumpApart(cellHorisontalId:int, cellVerticalId:int):void
		{
			if (!_enabled)
				return;
			
			var distance:Number = 5 * pxScale;
			var cellStartHorisontalId:int = cellHorisontalId;
			while (cellStartHorisontalId > 0)
			{
				cellStartHorisontalId--;
				tweenCellAndBack(cellStartHorisontalId, cellVerticalId, (cellStartHorisontalId - cellHorisontalId) * distance, 0);
					//break;
			}
			
			cellStartHorisontalId = cellHorisontalId;
			while (cellStartHorisontalId < (cellsTotalHorisontal - 1))
			{
				cellStartHorisontalId++;
				tweenCellAndBack(cellStartHorisontalId, cellVerticalId, (cellStartHorisontalId - cellHorisontalId) * distance, 0);
					//break;
			}
			
			var cellStartVerticalId:int = cellVerticalId;
			while (cellStartVerticalId > 0)
			{
				cellStartVerticalId--;
				tweenCellAndBack(cellHorisontalId, cellStartVerticalId, 0, (cellStartVerticalId - cellVerticalId) * distance);
					//break;
			}
			
			cellStartVerticalId = cellVerticalId;
			while (cellStartVerticalId < (cellsTotalVertical - 1))
			{
				cellStartVerticalId++;
				tweenCellAndBack(cellHorisontalId, cellStartVerticalId, 0, (cellStartVerticalId - cellVerticalId) * distance);
					//break;
			}
		}
		
		private function tweenCellAndBack(cellHorisontalId:int, cellVerticalId:int, valueX:Number = 0, valueY:Number = 0):void
		{
			var view:DisplayObject;
			var startValueX:Number = 0;
			var startValueY:Number = 0;
			if (cellHorisontalId == 2 && cellVerticalId == 2)
			{
				view = centralCell;
				if (valueX != 0)
					startValueX = baseWidth - centralCell.width >> 1;
				
				if (valueY != 0)
					startValueY = (baseHeight - centralCell.height >> 1) + 4 * pxScale;
			}
			else
			{
				var cellId:int = cellVerticalId * 5 + cellHorisontalId;
				
				if (cellId > 11)
					cellId--;
				
				var cell:GameCardCell = mCells[cellId];
				
				view = cell.numberLabel;
				
				if (valueX != 0)
					startValueX = cell.numberLabelPositionX;
				
				if (valueY != 0)
					startValueY = cell.numberLabelPositionY;
			}
			
			var tween_0:Tween = new Tween(view, 0.06, Transitions.EASE_OUT);
			var tween_1:Tween = new Tween(view, 0.1, Transitions.EASE_OUT_BACK);
			tween_0.nextTween = tween_1;
			
			if (valueX != 0)
			{
				tween_0.animate('x', view.x + valueX);
				tween_1.animate('x', startValueX);
			}
			
			if (valueY != 0)
			{
				tween_0.animate('y', view.y + valueY);
				tween_1.animate('y', startValueY);
			}
			
			Starling.juggler.add(tween_0);
		}
		
		public function tweenShake(delay:Number = 0, strength:int = 0):void
		{
			if (gameCardsContainer.isScrolling) {
				scale = _baseScale;
				return;
			}
			
			if (Starling.juggler.containsTweens(this))
				Starling.juggler.removeTweens(this);
			
			var tween_0:Tween = new Tween(this, 0.03, Transitions.EASE_OUT);
			var tween_1:Tween = new Tween(this, 0.08, Transitions.EASE_IN);
			
			tween_0.delay = delay;
			
			tween_0.animate('scaleX', (strength == 0 ? 1.03 : 1.09)*_baseScale);
			tween_0.animate('scaleY', (strength == 0 ? 0.91 : 0.975)*_baseScale);
			
			tween_0.nextTween = tween_1;
			
			tween_1.animate('scaleX', _baseScale);
			tween_1.animate('scaleY', _baseScale);
			tween_1.onComplete = setScale;
			tween_1.onCompleteArgs = [this, _baseScale];
			
			Starling.juggler.add(tween_0);
		}
		
		/* used to shake when bingo */
		public function shake(delay:Number = 0):void
		{
			if (gameCardsContainer.isScrolling) {
				container.scale = 1;
				return;
			}
			
			if (Starling.juggler.containsTweens(container))
				Starling.juggler.removeTweens(container);
			
			var tween_0:Tween = new Tween(container, 0.04, Transitions.LINEAR);
			var tween_1:Tween = new Tween(container, 0.15, Transitions.EASE_OUT_BACK);
			
			tween_0.delay = delay;
			tween_0.animate('scaleX', 1.09);
			tween_0.animate('scaleY', 0.91);
			tween_0.nextTween = tween_1;
			
			tween_1.animate('scaleX', 1);
			tween_1.animate('scaleY', 1);
			tween_1.onComplete = setScale;
			tween_1.onCompleteArgs = [container, 1];
			
			Starling.juggler.add(tween_0);
		}
		
		public function stopScalingTweens():void
		{
			if (Starling.juggler.containsTweens(this))
				Starling.juggler.removeTweens(this);
			
			if (Starling.juggler.containsTweens(container))
				Starling.juggler.removeTweens(container);
				
			scale = _baseScale;
			container.scale = 1;
		}
		
		private function setScale(displayObject:DisplayObject, value:Number):void
		{
			displayObject.scale = value;
		}
		
		private function removeView(view:DisplayObject):void
		{
			view.removeFromParent();
		}
		
		override public function set scale(value:Number):void
		{
			super.scale = value;
			topLayerAnimations.scale = value;
		}
		
		override public function set x(value:Number):void
		{
			super.x = value;
			topLayerAnimations.x = value;
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
			topLayerAnimations.y = value;
		}
		
		private function alignBingoButton():void
		{
			bingoButton.x = baseWidth / 2;
			bingoButton.y = baseHeight - bingoButton.height - 5 * pxScale + bingoButton.pivotY;
		}
		
		
		/**
		 * Минимальное количество необходимых шаров для сбора паттерна.
		 * Если не указать паттерны, то будут смотреться текущие для текущего раунда.
		 * */
		public function minBallsToMatchPattern(patterns:Vector.<CardPattern> = null, checkOnlyMarked:Boolean = false):int
		{
			if (!patterns)
				patterns = cardPatterns;
			
			var cardPattern:CardPattern;
			
			var minBalls:int = -1;
			
			var i:int;
			var j:int;
			var filledCount:int;
			var length:int;
			var patternsLength:int = patterns.length;
			var point:Point;
			var cellId:int;
			var cellNumber:int;
			for (i = 0; i < patternsLength; i++)
			{
				cardPattern = patterns[i];
				length = cardPattern.filledPositions.length;
				filledCount = 0;
				for (j = 0; j < length; j++)
				{
					point = cardPattern.filledPositions[j];
					cellId = point.y * 5 + point.x;
					
					// cellId == 12 is center always daubed cell 
					if (cellId != 12)
					{
						if (cellId > 11)
							cellId--;
						cellNumber = mCard.numbers[cellId];
						
						if (mCard.magicDaubs.indexOf(cellNumber) != -1 || (mRoom.numbers.indexOf(cellNumber) != -1 && (!checkOnlyMarked || mCard.daubedNumbers.indexOf(cellNumber) != -1)) /*&& (checkDaubs && mCard.daubedNumbers.indexOf(cellNumber) == -1))*/)
							filledCount++;	
					}
					else {
						filledCount++;
					}
				}
				
				if (minBalls == -1)
					minBalls = length - filledCount;
				else
					minBalls = Math.min(length - filledCount, minBalls);	
			}
			
			return Math.max(0, minBalls);
		}
		
		private function alignFadeImage():void 
		{
			if (!fadeImage)
				return;
			
			fadeImage.x = baseWidth / 2;
			fadeImage.y = baseHeight / 2;
			fadeImage.scaleX = 2 * (isTabletLayout ? 1.148 : 1);
			fadeImage.scaleY = 2;	
		}
		
		/*******************************************************************************************
		 *
		 * X2
		 *
		 ******************************************************************************************/
		 
		private function handler_x2EnterFrame(e:Event):void
		{
			var timeout:int = gameScreenController.getX2Timeout(index);
			
			x2Progress.position = timeout/gameManager.gameData.x2TimeMs;
			
			if (timeout <= 0) 
			{
				SoundManager.instance.playSfx(SoundAsset.X2BoostEnd, 0, 0, 1, 0, true);
				removeEventListener(Event.ENTER_FRAME, handler_x2EnterFrame);
				tweenCardFromX2ToNormal();
				isX2Mode = false;
				
				if (!gameScreenController.isAnyX2Active) {
					//trace('SoundManager.instance.stopSfxLoop(');
					SoundManager.instance.stopSfxLoop(SoundAsset.X2BoostFireLoop);
				}
			}
			
			//trace('ratio ', ratio, timeout);
		}
		
		private function tweenCardToX2():void 
		{
			EffectsManager.showFullscreenSplash(Game.current.gameScreen.frontLayer, 0.5);
			
			tweenShake(0.1);
			
			Starling.juggler.removeTweens(titleImage);
			
			var tweenTitle_1:Tween = new Tween(titleImage, 0.2, Transitions.EASE_IN);
			var tweenTitle_2:Tween = new Tween(titleImage, 0.2, Transitions.EASE_OUT_BACK);
			
			tweenTitle_1.delay = 0.2;
			tweenTitle_1.animate('scaleX', 1.07);
			tweenTitle_1.animate('scaleY', 0);
			tweenTitle_1.onComplete = changeTitleTexture;
			tweenTitle_1.onCompleteArgs = [true, 2.27, 2*pxScale];
			tweenTitle_1.nextTween = tweenTitle_2;
			
			tweenTitle_2.animate('scaleX', 1);
			tweenTitle_2.animate('scaleY', 1);
			tweenTitle_2.onComplete = cycleJumpTitleTexture;
			
			Starling.juggler.add(tweenTitle_1);	
			
			x2Progress.show(0.4);
			
			hideX2GlowEdges(true);
			showX2GlowEdges(3*pxScale, 0.2);
			
			Starling.juggler.delayCall(changeStyleTextures, 0.2, true);
			
			
			x2Plate = new Image(mGameAtlas.getTexture("card/card_plate"));
			x2Plate.scale9Grid = new Rectangle(29 * pxScale, 30 * pxScale, 13 * pxScale, 11 * pxScale);
			x2Plate.color = 0xFFFF00;
			x2Plate.width = baseWidth;
			x2Plate.height = baseHeight;
			x2Plate.x = background.x;
			x2Plate.y = background.y;
			x2Plate.alpha = 0.0;
			//x2Plate.blendMode = BlendMode.MULTIPLY;
			x2Plate.touchable = false;
			//container.addChildAt(image, container.getChildIndex(bingoButton) + 1);
			container.addChild(x2Plate);
			
			TweenHelper.tween(x2Plate, 0.07, {alpha:0.9, delay:0.2}).chain(x2Plate, 0.5, {alpha:0, transition:Transitions.LINEAR, onComplete:removeX2Plate}); 
		}
		
		private function cycleJumpTitleTexture():void {
			Starling.juggler.tween(titleImage, 0.2, {scale:1.07, repeatCount:0, reverse:true});	
		}
		
		private function tweenCardFromX2ToNormal():void 
		{
			var cellIndex:int;
			var mark:Image;
			for (cellIndex in daubMarkCache)
			{
				mark = daubMarkCache[cellIndex] as Image;
				mark.texture = dauberSkin.getDaubTexture(false);
			}
			
			Starling.juggler.removeTweens(titleImage);
			
			var tweenTitle_1:Tween = new Tween(titleImage, 0.15, Transitions.EASE_IN);
			var tweenTitle_2:Tween = new Tween(titleImage, 0.07, Transitions.EASE_IN);
			var tweenTitle_3:Tween = new Tween(titleImage, 0.08, Transitions.EASE_OUT);
			
			//tweenTitle_1.delay = delay;
			tweenTitle_1.animate('scaleX', 4.15);
			tweenTitle_1.animate('scaleY', 0);
			tweenTitle_1.onComplete = changeTitleTexture;
			tweenTitle_1.onCompleteArgs = [false, 1.07, 0];
			tweenTitle_1.nextTween = tweenTitle_2;
			
			tweenTitle_2.animate('scaleX', 1);
			tweenTitle_2.animate('scaleY', 1.42);
			tweenTitle_2.nextTween = tweenTitle_3;
			
			tweenTitle_3.animate('scaleX', 1);
			tweenTitle_3.animate('scaleY', 1);
			
			Starling.juggler.add(tweenTitle_1);	
			
			changeStyleTextures(false);
			
			x2Progress.hide();
			
			hideX2GlowEdges();
		}
		
		public function changeStyleTextures(toX2:Boolean):void 
		{
			var cellIndex:int;
			var mark:Image;
			for (cellIndex in daubMarkCache)
			{
				mark = daubMarkCache[cellIndex] as Image;
				mark.texture = dauberSkin.getDaubTexture(toX2);
			}
			
			if (toX2) {
				background.texture = cardSkin.getTexture('card_background', true);
				bingoButton.setStyle(bingoButtonStyleX2, '', '', true);
				centralCell.texture = dauberSkin.getTexture("magicdaub_2x");
			}
			else {
				background.texture = cardSkin.getTexture('card_background', false);
				bingoButton.setStyle(bingoButtonStyle, '', '', true);
				centralCell.texture = dauberSkin.getTexture("magicdaub");
			}
			
			// recoloring magic daubs:
			var i:int;
			var length:int = mRoom.numbers.length;
			var cell:GameCardCell;
			for (i = 0; i < length; i++)
			{
				cell = cellsByBallNumbersCache[mRoom.numbers[i]];
				if (cell && cell.daubed)
					cell.changeStyleTextures(toX2);
			}
			
			for each(cell in cellsMagicDaubsNumbersCache) {
				cell.changeStyleTextures(toX2);
			}
			 
			/*
			// for debug
			for each(cell in cellsByBallNumbersCache) {
				if (cell.daubed)
					cell.changeStyleTextures(toX2);
			}*/
		}
		
		private function showX2GlowEdges(shiftToCenter:int, delay:Number = 0):void 
		{
			var childIndex:int = container.getChildIndex(background) + 1;
			var image:Image;
			
			image = new Image(AtlasAsset.CommonAtlas.getTexture("card/2x_glow"));
			image.alignPivot();
			image.scaleX = 0.8;
			image.scaleY = 1.2;
			image.x = shiftToCenter;
			image.y = (baseHeight - image.texture.frameHeight)/2 + image.pivotY;
			container.addChildAt(image, childIndex);
			x2EdgeGlowImages[0] = image;
			
			Starling.juggler.tween(image, 0.2, {scaleX:1.7, scaleY:1.4, repeatCount:0, reverse:true, onUpdate:refreshX2EdgeGlowVertical});	
			
			image = new Image(AtlasAsset.CommonAtlas.getTexture("card/2x_glow"));
			image.alignPivot();
			image.scaleX = 0.8;
			image.scaleY = 1.2;
			image.x = baseWidth - shiftToCenter;
			image.y = (baseHeight - image.texture.frameHeight)/2 + image.pivotY;
			container.addChildAt(image, childIndex);
			x2EdgeGlowImages[1] = image;
			
			////
			
			image = new Image(AtlasAsset.CommonAtlas.getTexture("card/2x_glow"));
			image.alignPivot();
			image.scaleX = 0.9;
			image.scaleY = 0.8;
			image.rotation = Math.PI / 2;
			image.x = baseWidth / 2;
			image.y = shiftToCenter;
			container.addChildAt(image, childIndex);
			x2EdgeGlowImages[2] = image;
			
			Starling.juggler.tween(image, 0.2, {scaleX:1.7, scaleY:(isTabletLayout ? 1.3 : 0.99), repeatCount:0, reverse:true, onUpdate:refreshX2EdgeGlowHorisontal});
			
			image = new Image(AtlasAsset.CommonAtlas.getTexture("card/2x_glow"));
			image.alignPivot();
			image.scaleX = 0.9;
			image.scaleY = 0.8;
			image.rotation = Math.PI / 2;
			image.x = baseWidth / 2;
			image.y = baseHeight - shiftToCenter;
			container.addChildAt(image, container.getChildIndex(bingoButton) + 1);
			x2EdgeGlowImages[3] = image;
		}
		
		private function refreshX2EdgeGlowVertical():void 
		{
			x2EdgeGlowImages[1].scaleX = x2EdgeGlowImages[0].scaleX;
			x2EdgeGlowImages[1].scaleY = x2EdgeGlowImages[0].scaleY;
		}
		
		private function refreshX2EdgeGlowHorisontal():void 
		{
			x2EdgeGlowImages[3].scaleX = x2EdgeGlowImages[2].scaleX;
			x2EdgeGlowImages[3].scaleY = x2EdgeGlowImages[2].scaleY;
		}
		
		private function hideX2GlowEdges(immediate:Boolean = false):void 
		{
			var image:Image;
			while (x2EdgeGlowImages.length > 0) {
				image = x2EdgeGlowImages.shift();
				Starling.juggler.removeTweens(image);
				if (immediate)
					image.visible = false;
				else	
					Starling.juggler.tween(image, 0.2, {alpha:0});	
			}
		}
		
		private function changeTitleTexture(x2:Boolean, scaleX:Number, shiftX:Number = 0):void {
			titleImage.texture = cardSkin.getTexture('title', x2);
			titleImage.readjustSize();
			titleImage.alignPivot();
			titleImage.scaleX = scaleX;
			titleImage.x = baseWidth/2 + shiftX;
		}
		
		private function removeX2Plate():void {
			if (x2Plate) {
				x2Plate.removeFromParent();
				x2Plate = null;
			}
		}
		
		/*******************************************************************************************
		*
		* 
		*
		******************************************************************************************/
		
		private function handleTutorialBingo():void 
		{
			
			if (Game.current.gameScreen)
			{
				Game.current.gameScreen.gameScreenController.confirmBingo(card.cardId, gameManager.tutorialManager.winnersCount)
			}
			
			gameManager.tutorialManager.addAwardsForBingo(index);
			gameManager.tutorialManager.addPlayerToWinners();
			
			Game.current.gameScreen.gameUI.tutorialStepHidePowerupBall();
			
			tutorialStepHideHandOnBingoButton();
			
			if(Player.current.bingosInARound >= Player.current.cards.length)
				gameManager.tutorialManager.finishTutorialRound(true);
		}
		
		override public function hitTest(localPoint:Point):DisplayObject
		{
			//trace(localPoint.x, localPoint.y);
			if (localPoint.y < 0)
				return null;
			
			return super.hitTest(localPoint);
		}
		
		/*******************************************************************************************
		 *
		 * DEBUG
		 *
		 ******************************************************************************************/
		
		private function debugDrawQuadCell(i:int):void
		{
			var quad:Quad = new Quad(1, 1, Math.random() * 0xFF00FF);
			var j:int = i > 11 ? (i + 1) : i;
			quad.alpha = 0.6;
			container.addChild(quad);
			quad.width = cellWidth;
			quad.height = cellHeight;
			quad.x = cellStartX + j % 5 * cellWidth;
			quad.y = cellStartY + Math.floor(j / 5) * cellHeight;
			quad.touchable = false;
		}
		
		private function debugShowBadBingo():void
		{
			//badBingoTimeCoefficient++;
			//Player.current.setBadBingoTimeCoefficient(mRoom.roomType.roomTypeName, mCard.cardId, badBingoTimeCoefficient);
			
			//Player.current.setBadBingoFinishTime(mRoom.roomType.roomTypeName, mCard.cardId, Game.connectionManager.currentServerTime + BAD_BINGO_TIMER_INCREMENT * 1 + 999);
			Player.current.setBadBingoFinishTime(mRoom.roomType.roomTypeName, mCard.cardId, Game.connectionManager.currentServerTime + 1999);
			
			showBadBingoTimer();
			mSoundManager.playBadBingo();
		}
		
		private function debugButtonClick(... args):void
		{
			debugShowBadBingo();
		}
		
		public function debugShowX2Powerup(time:int):void {
			gameScreenController.addX2Time(index, time);
			
			if (!hasEventListener(Event.ENTER_FRAME, handler_x2EnterFrame)) {
				addEventListener(Event.ENTER_FRAME, handler_x2EnterFrame);
				tweenCardToX2();
			}
		}
	
	}
}