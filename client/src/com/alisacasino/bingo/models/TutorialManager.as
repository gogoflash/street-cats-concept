package com.alisacasino.bingo.models
{
	import adobe.utils.CustomActions;
	import air.update.states.HSM;
	import by.blooddy.crypto.image.palette.IPalette;
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.commands.gameScreenCommands.RoundOverCommand;
	import com.alisacasino.bingo.components.FadeQuad;
	import com.alisacasino.bingo.controls.GameCard;
	import com.alisacasino.bingo.controls.cardPatternHint.CardPattern;
	import com.alisacasino.bingo.dialogs.ServiceDialog;
	import com.alisacasino.bingo.models.cats.CatModel;
	import com.alisacasino.bingo.models.cats.CatRole;
	import com.alisacasino.bingo.models.chests.ChestData;
	import com.alisacasino.bingo.models.chests.ChestDropCounts;
	import com.alisacasino.bingo.models.chests.ChestPowerupPack;
	import com.alisacasino.bingo.models.game.XPLevel;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.models.powerups.PowerupModel;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.models.slots.SlotMachineChanceTable;
	import com.alisacasino.bingo.models.slots.SlotMachineReward;
	import com.alisacasino.bingo.models.slots.SlotMachineRewardType;
	import com.alisacasino.bingo.models.slots.SpinResult;
	import com.alisacasino.bingo.models.slots.SpinType;
	import com.alisacasino.bingo.protocol.CardType;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.protocol.ChestWinMessage;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.PlayerBingoedMessage;
	import com.alisacasino.bingo.protocol.PlayerMessage;
	import com.alisacasino.bingo.protocol.RoomMessage;
	import com.alisacasino.bingo.protocol.RoundOverMessage;
	import com.alisacasino.bingo.protocol.SignInOkMessage;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.screens.gameScreenClasses.CatView;
	import com.alisacasino.bingo.screens.gameScreenClasses.WinnersPane;
	import com.alisacasino.bingo.screens.lobbyScreenClasses.ChestSlotView;
	import com.alisacasino.bingo.store.items.PowerupPackStoreItem;
	import com.alisacasino.bingo.utils.DelayCallUtils;
	import com.alisacasino.bingo.utils.Settings;
	import com.alisacasino.bingo.utils.TimeService;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNARoundStartedEvent;
	import com.alisacasino.bingo.utils.sharedObjects.SharedObjectManager;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.netease.protobuf.UInt64;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.EventDispatcher;
	
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.SignInMessage.Platform;
	import com.alisacasino.bingo.protocol.StaticDataMessage;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.GameManager;
	import starling.events.Event;
	
	public class TutorialManager extends EventDispatcher
	{
		public function TutorialManager() 
		{
			//x2, daub, doubleDaub, tripleDaub, cash, xp, instabingo, minigame, score
			
			tutorialChestsPowerupPacks =
			[
				new <ChestPowerupPack> [ChestPowerupPack.create(Powerup.RARITY_NORMAL, {daub:1})],
				new <ChestPowerupPack> [ChestPowerupPack.create(Powerup.RARITY_NORMAL, {score:1}), ChestPowerupPack.create(Powerup.RARITY_MAGIC, {doubleDaub:1})],
				new <ChestPowerupPack> [ChestPowerupPack.create(Powerup.RARITY_NORMAL, {daub:1, score:1})],
				new <ChestPowerupPack> [ChestPowerupPack.create(Powerup.RARITY_MAGIC, {daub:1, x2:1, xp:2})],
				new <ChestPowerupPack> [ChestPowerupPack.create(Powerup.RARITY_RARE, {tripleDaub:1, cash:2, x2:2})]
			];
			
			tutorialChestsParameters = 
			[
				[ChestType.BRONZE, true, 1, TUTORIAL_FIRST_CHEST_OPEN_TIMEOUT, new <uint>[5], new <int>[CardType.NORMAL]], // first tutor round
				[ChestType.SILVER, true, 2, 0, new <uint>[10], new <int>[]], // second round
				[ChestType.BRONZE, true, 3, 0, new <uint>[5], new <int>[]],
				[ChestType.SILVER, true, 4, 0, new <uint>[10], new <int>[CardType.NORMAL]],
				[ChestType.GOLD,   true, 5, 0, new <uint>[50], new <int>[CardType.NORMAL]]
			]
			
			var i:int;
			for (i = 0; i < tutorialChestsPowerupPacks.length; i++) 
			{
				if(i < tutorialChestsParameters.length)
					tutorialChestsParameters[i].push(tutorialChestsPowerupPacks[i]);
			}
			
			/*tutorialChestsParameters = 
			[
				[ChestType.BRONZE, true, 1, 50, 1, 26, 1, CardType.NORMAL, 1], // first tutor round
				[ChestType.SILVER, true, 0, 50, 1, 80, 0, 0, 2], // second round
				[ChestType.BRONZE, true, 0, 50, 1, 26, 0, 0, 1],
				[ChestType.SILVER, true, 0, 50, 1, 80, 1, CardType.NORMAL, 2],
				[ChestType.GOLD,   true, 0, 50, 1, 300, 1, CardType.NORMAL, 2]
			]*/
			
			//type:int, isNew:Boolean, openTimestamp:int, passNumbers:int, cashCountMin:int, cashCountMax:int, collectionCount:int, collectionRarity:int, powerUpsPackCount:int):void 
		}
		
		public function getPowerup(index:int = 0):String
		{
			switch(Player.current.gamesCount) {
				case 0: return Powerup.DAUB; // first tutor round
				case 1: return getStringFromArray([Powerup.CASH], index, Powerup.DAUB); // second round
				case 2: return getStringFromArray([Powerup.DOUBLE_DAUB, Powerup.XP], index, Powerup.DAUB);
				case 3: return getStringFromArray([Powerup.SCORE, Powerup.INSTABINGO], index, Powerup.DAUB);
				case 4: return getStringFromArray([Powerup.XP, Powerup.X2, Powerup.SCORE, Powerup.XP], index, Powerup.DAUB);
			}
			
			return Powerup.DAUB;
		}
	
		public static var TUTORIAL_SHOW_FREE_OPEN_CHEST_DELAY_CALL_ID:int;
		public static var TUTORIAL_HINT_COLLECTIONS_BUTTON_DELAY_CALL_ID:int;
		
		private var KEY_TUTORIAL_COMPLETE:String = "KEY_TUTORIAL_COMPLETE";
		
		private var KEY_TUTORIAL_FREE_OPEN_CHEST_COMPLETE:String = "KEY_TUTORIAL_FREE_OPEN_CHEST_COMPLETE";
		
		// количество туториальных боев. Включительно.
		public static var TUTORIAL_GAMES_COUNT:int = 5;
		
		public static var TUTORIAL_HINTS_ROUNDS_COUNT:int = 8//6; // на этом раунде альфа хинта уже равна 0
		
		public static var TUTORIAL_HINTS_FULL_ALPHA_ROUNDS_COUNT:int = 3; // на этом раунде альфа хинта будет единица. шаг: 1/(ROUNDS_COUNT - FULL_ALPHA_ROUNDS_COUNT)
		
		private var TUTORIAL_MIN_BALLS_BINGO_COUNT:int = 10;
		
		private var TAKE_MATCH_BALL_RELATIVE_LAST_BALL_RATIO:Number = 0.3; 					
		
		private var TAKE_MATCH_BALL_RATIO:Number = 0.5; 
		
		public static var TUTORIAL_ROUND_TO_SECOND_LEVEL:int = 2;
		
		public static var TUTORIAL_FIRST_CHEST_OPEN_TIMEOUT:int = 1;
		
		public static var FIRST_START_TUTOR_NONE:String = '';
		public static var FIRST_START_TUTOR_WITHOUT_BLOCK:String = 'FIRST_START_TUTOR_WITHOUT_BLOCK';
		public static var FIRST_START_TUTOR_WIDTH_BLOCK:String = 'FIRST_START_TUTOR_WIDTH_BLOCK';
		
		private var _roundStartTime:Number; 					
		
		private var roundStartDelayId:int; 					
		
		private var _playerGamesCountAtStart:int;
		
		private var stopAddBallInteraction:Boolean;
		
		private var tutorialChestsParameters:Array;
		private var tutorialChestsPowerupPacks:Array;
		
		private var _tutorialFirstLevelPassed:Boolean;
		private var _tutorialLevelsPassed:Boolean;
		private var _isPowerupStepPassed:Boolean;
		private var _isCollectionStepPassed:Boolean;
		private var _isChestTakeOutStepPassed:Boolean;
		private var _isTourneyResultsHandleStepPassed:Boolean;
		
		private var _isChestFreeOpenStepPassed:Boolean;
		public var chestFreeOpenId:int = -1;
		
		private var _tutorialFirstPowerUpTaked:Boolean;
		
		private var _bingosTimerCount:int;
		private var secondsTimerCount:int;
		
		private var matchedBallCount:int;
		
		private var unMatchedBallCount:int;
		
		private var handAnimation:AnimationContainer;
		
		private var handPlayTimelineDelay:Number;
		
		private var lastHandDelayCallId:uint;
		
		private var _isEnabledOnServer:Boolean = true;
		
		public var tutorLevelBingosLeft:int;
		public var tutorLevelPlayersCount:int;
		public var tutorLevelCardsCount:int;
		
		private var roundMatchPatterns:Vector.<CardPattern>;
		
		private var realRoundBallsBingoCount:int;
		private var tutorLevelBallsBingoCount:int;
		private var finishRoundBallsCount:int;
		
		private var _winnersCount:int;
		
		public function get winnersCount():int 
		{
			return _winnersCount;
		}
		
		private var isLastBallMatched:Boolean;
		
		private var minimalBingoBallsCount:int;
		
		private static var infoPanelAverageBingosLeft:int = 25;
		private static var infoPanelAveragePlayersCount:int = 70;
		private static var infoPanelAverageCardsCount:int = 190;
		
		private var bingosLeftDecrementStep:int;
		
		private var roundBingosCount:int;
		
		private var alphaMaskContainer:Sprite;
		private var alphaMaskImage:Image;
		private var alphaMaskQuads:Vector.<Quad>;
		
		/**
		 * - уменьшать и вовремя вырубать хинты на бинго-кнопке
		 * 
		 * ГОТОВО:
		 * - защитить вызовы маркера тутора от рефреша турнира(чест, колекшен)
		 * 
		 * - полностью решить проблему с непрогрузом аватарок
		 * - не забыть вставить скролл кнопки
		 * - защита от дурака -> если тапнуть заранее, то нужно перетапывать при выпадении шара. Защитить от этого.
		 * 
		 * */
		
		public function handleSignInOkMessage(message:SignInOkMessage):void
		{
			_playerGamesCountAtStart = Player.current.gamesCount;
			realRoundBallsBingoCount = message.staticData.initialBallToBingo;
			
			_isChestFreeOpenStepPassed = gameManager.clientDataManager.getValue(KEY_TUTORIAL_FREE_OPEN_CHEST_COMPLETE, false);
			
			//calculateTutorRoundValues();
		}
		
		/*public function get isActive():Boolean
		{
			if (!_isEnabledOnServer)
				return false;
			
			if(_playerGamesCountAtStart > 0)
				return false;
				
			return !gameManager.clientDataManager.getValue(KEY_TUTORIAL_COMPLETE, false);
				
			///trace('asdasd ', Player.current.gamesCount, gameManager.clientDataManager.getValue(KEY_TUTORIAL_COMPLETE, false));
		}*/

		public function get tutorialFirstLevelPassed():Boolean
		{
			if (!_isEnabledOnServer)
				return true;
			
			if (_tutorialFirstLevelPassed)
				return true;
				
			return _playerGamesCountAtStart > 0;
		}

		public function get tutorialLevelsPassed():Boolean
		{
			if (!_isEnabledOnServer)
				return true;
			
			if (_tutorialLevelsPassed)
				return true;
				
			return _playerGamesCountAtStart >= TUTORIAL_GAMES_COUNT;
		}
		
		public function get allTutorialLevelsPassed():Boolean
		{
			return tutorialFirstLevelPassed && tutorialLevelsPassed;
		}
		
		public function get isPowerupStepPassed():Boolean
		{
			if (!_isEnabledOnServer)
				return true;
			
			if (_isPowerupStepPassed || Player.current.gamesCount >= 3)
				return true;
			
			return _playerGamesCountAtStart > 0;
		}
		
		public function get isCollectionStepPassed():Boolean
		{
			return true;
			
			if (!_isEnabledOnServer)
				return true;
			
			if (_isCollectionStepPassed)
				return true;
			
			return _playerGamesCountAtStart > 0;
		}
		
		public function get isChestTakeOutStepPassed():Boolean
		{
			if (!_isEnabledOnServer)
				return true;
			
			if (_isChestTakeOutStepPassed)
				return true;
			
			return _playerGamesCountAtStart >= TUTORIAL_GAMES_COUNT;
		}
		
		public function get isRoundResultsUIStepPassed():Boolean
		{
			if (!_isEnabledOnServer)
				return true;
			
			return Player.current.gamesCount > TUTORIAL_GAMES_COUNT;
		}
		
		public function get isTourneyResultsHandleStepPassed():Boolean
		{
			if (!_isEnabledOnServer)
				return true;
			
			if (_isTourneyResultsHandleStepPassed)
				return true;
			
			return _playerGamesCountAtStart > 0;
		}
		
		public function get isChestFreeOpenStepPassed():Boolean
		{
			if (!_isEnabledOnServer)
				return true;
			
			if (_isChestFreeOpenStepPassed)
				return true;
			
			return _playerGamesCountAtStart >= TUTORIAL_GAMES_COUNT;
		}
		
		public function completeChestFreeOpenStep():void
		{
			_isChestFreeOpenStepPassed = true;
			chestFreeOpenId = -1;
			gameManager.clientDataManager.setValue(KEY_TUTORIAL_FREE_OPEN_CHEST_COMPLETE, true);
		}
		
		public function completeChestTakeOutStep():void
		{
			_isChestTakeOutStepPassed = true;
		}
		
		public function get tutorialFirstPowerUpTaked():Boolean
		{
			return _tutorialFirstPowerUpTaked;
		}	
		
		public function set tutorialFirstPowerUpTaked(value:Boolean):void
		{
			_tutorialFirstPowerUpTaked = value;
		}	
		
		public function completePowerupStep():void
		{
			_isPowerupStepPassed = true;
			//gameManager.analyticsManager.sendTutorialEvent('completePowerupStep');
		}
		
		public function completeCollectionStep():void
		{
			_isCollectionStepPassed = true;
			gameManager.analyticsManager.sendTutorialEvent('completeCollectionStep');
		}
		
		public function completeTourneyResultsHandleStep():void
		{
			_isTourneyResultsHandleStepPassed = true;
		}
		
		public function get roundStartTime():Number
		{
			return _roundStartTime;
		}	
		
		public function get bingosTimerCount():Number
		{
			return _bingosTimerCount;
		}	
		
		public function get playerGamesCountAtStart():int
		{
			return _playerGamesCountAtStart;
		}
		
		public function get isEnabledOnServer():Boolean
		{
			return _isEnabledOnServer;
		}
		
		public function get allStepsIsDone():Boolean
		{
			return tutorialLevelsPassed && isChestTakeOutStepPassed && isCollectionStepPassed && isRoundResultsUIStepPassed && isTourneyResultsHandleStepPassed;
		}
		
		public static function get isFirstStartTutorEnabled():Boolean
		{
			//return true;
			
			if(!Player.current || Player.current.gamesCount != 0)
				return false;
				
			if (Settings.instance.firstStartTutorABEven && Player.current.playerId % 2 != 0)
				return false;
				
			return Settings.instance.firstStartTutorType != TutorialManager.FIRST_START_TUTOR_NONE; 
		}
		
		public function buyTutorialCard(cardsToPlay:int = 1):void 
		{
			if(SoundManager.instance.soundLoadQueue)
				SoundManager.instance.soundLoadQueue.prioritizeRoundSounds();
				
			Player.current.debugCreateCards(cardsToPlay);
			Room.current.cardsPlayed = cardsToPlay;
			
			secondsTimerCount = 5;
			_bingosTimerCount = 0;
			roundMatchPatterns = null;
			_winnersCount = 0;
			
			// tutorLevelBallsBingoCount - количество шаров до гарантированного бинго. Количество линейно приближается от TUTORIAL_MIN_BALLS_BINGO_COUNT к реальному игровому realRoundBallsBingoCount
			calculateBallsCount(Player.current.gamesCount);
			
			// trace('balls count values ', tutorLevelBallsBingoCount, realRoundBallsBingoCount, ratio);
			
			switch(Player.current.gamesCount) 
			{
				case 0: { // первый туториальный уровень
					secondsTimerCount = 6;
					roundMatchPatterns = CardPattern.generateTutorialList();
					break;
				}
				case 1: {
					secondsTimerCount = 7;
					roundMatchPatterns = CardPattern.generateRowsList(true);
					break;
				}
				case 2: {
					secondsTimerCount = 8;
					roundMatchPatterns = CardPattern.generateColumnsList(true);
					break;
				}
				case 3: {
					secondsTimerCount = 10; // 
					roundMatchPatterns = null;
					break;
				}
				case 4: {
					secondsTimerCount = 6;
					_bingosTimerCount = 5;
					roundMatchPatterns = CardPattern.generateCornersList();
					break;
				}
				/*case 5: {
					secondsTimerCount = 15;
					_bingosTimerCount = 10;
					roundMatchPatterns = null;
					break;
				}*/
			}
			
			if (_bingosTimerCount == 0) {
				_roundStartTime = TimeService.serverTimeMs + secondsTimerCount*1000 - 1;
				roundStartDelayId = Starling.juggler.delayCall(startTutorialRound, secondsTimerCount + 0.001);
			}
			else {
				_roundStartTime = 0;
				roundStartDelayId = Starling.juggler.delayCall(decreaseBingosTimerCount, 1.5);
			}
			
//			Game.current.gameScreen.goWaitForRound();
			Game.current.gameScreen.lobbyUI.cashBar.animateToValue(Player.current.cashCount, 0.3);
		}
	
		private function decreaseBingosTimerCount():void 
		{
			_bingosTimerCount--;
			
			if(_bingosTimerCount <= 0) {
				_roundStartTime = TimeService.serverTimeMs + secondsTimerCount*1000 - 1;
				roundStartDelayId = Starling.juggler.delayCall(startTutorialRound, secondsTimerCount + 0.001);
			}	
			else {
				roundStartDelayId = Starling.juggler.delayCall(decreaseBingosTimerCount, 0.7 + 1*Math.random());
			}
		}
		
		private function startTutorialRound():void 
		{
			Room.current.numbers = [];
			Room.current.roundID = "tutorial" + (Player.current.gamesCount + 1).toString();
			Room.current.bingoHistory = [];
			stopAddBallInteraction = false;
			
			if (Player.current.gamesCount == 0) {
				tutorLevelBingosLeft = 16 + Math.round(10*Math.random());
				tutorLevelPlayersCount = Math.round(2.55 * tutorLevelBingosLeft);
				tutorLevelCardsCount = Math.round(1.95 * tutorLevelPlayersCount);
			}
			else {
				tutorLevelBingosLeft = infoPanelAverageBingosLeft - 5*Math.random();
				tutorLevelPlayersCount = infoPanelAveragePlayersCount - 5*Math.random();
				tutorLevelCardsCount = infoPanelAverageCardsCount - 5 * Math.random();
				
				bingosLeftDecrementStep = Math.round(tutorLevelBingosLeft/(finishRoundBallsCount - tutorLevelBallsBingoCount));
			}
			
			matchedBallCount = 0;
			unMatchedBallCount = 0;
			minimalBingoBallsCount = 0;
			roundBingosCount = 0;
			DelayCallUtils.cleanBundle(WinnersPane.DELAY_CALLS_BUNDLE);
			_tutorialFirstPowerUpTaked = false;
			
			//Room.current.updateFromRoomMessage(message.room);
			
			Player.current.clearBadBingoFinishTimes(Room.current.roomType.roomTypeName);
			
			Game.current.gameScreen.showGame(true);
			
			if(Player.current.gamesCount == 0)
				Starling.juggler.delayCall(addFirstRoundBallIteration, 2.0);
			else
				Starling.juggler.delayCall(addBallIteration, 3.0);
		}
		
		private function addFirstRoundBallIteration():void 
		{
			if (stopAddBallInteraction || !Player.current)
				return;
			
			// оцениваем успехи. Кидаем шарик нужный или не очень.
			// там где создаются условия для бинги начинаем выдавать левые шары! чтобы основные не отвлекали
			
			var card:Card;
			var gameCard:GameCard;
			var i:int;
			var takeMatchNumberBall:Boolean = true;
			for (i = 0; i < Player.current.cards.length; i++)
			{
				card = Player.current.cards[i];
				gameCard  = Game.current.gameScreen.gameUI.getCardByCardModel(card);
				
				if (gameCard) {
					if (gameCard.bingoComplete || gameCard.checkIsBingo().length > 0)
						takeMatchNumberBall = false;
				}
			}	
			
			var totalBallsCount:int = matchedBallCount + unMatchedBallCount;
			
			if (takeMatchNumberBall && (totalBallsCount == 3 || matchedBallCount >= 5))
				takeMatchNumberBall = false;
			
			
			addBallToGame(takeMatchNumberBall, true, CardPattern.generateTutorialList(), false);
			
			if(takeMatchNumberBall)
				matchedBallCount++
			else	
				unMatchedBallCount++;
			
			// этих же победителей примешать в round results?
			
			totalBallsCount = matchedBallCount + unMatchedBallCount;
			/*if (totalBallsCount == 4) {
				Game.current.gameScreen.gameUI.gameUIPanel.winnersPane.addTutorialPlayer(0.8, null, '1785802438299679', 'Maria', 'avatars/random/00376.jpg');
				Starling.juggler.delayCall(changeInfoPanelData, 0.8, -1, -1);
				
				Game.current.gameScreen.gameUI.gameUIPanel.winnersPane.addTutorialPlayer(2.5, null, null, 'Guest ' + int(1000 + Math.random() * 999).toString());
				Starling.juggler.delayCall(changeInfoPanelData, 2.5, -1, -1);
			}	
			else if (totalBallsCount == 5) {
				Game.current.gameScreen.gameUI.gameUIPanel.winnersPane.addTutorialPlayer(1, null, 'lifestreamcos', 'John', 'avatars/random/00373.jpg');
				Starling.juggler.delayCall(changeInfoPanelData, 1, -1, -1, -1);
				
			}	
			else if (totalBallsCount >= 6) {
				if (tutorLevelBingosLeft > 1) 
				{
					Game.current.gameScreen.gameUI.gameUIPanel.winnersPane.addTutorialPlayer(1.1, null, '', 'Guest ' + int(1000 + Math.random() * 999).toString());
					Starling.juggler.delayCall(changeInfoPanelData, 1.1, -1, -1);
				}
			}	*/
			
			Starling.juggler.delayCall(addFirstRoundBallIteration, 4.6);
		}
		
		private function addBallIteration():void 
		{
			if (stopAddBallInteraction || !Player.current)
				return;
			
			var card:Card;
			var gameCard:GameCard;
			var i:int;
			var takeMatchNumberBall:Boolean = true;
			
			var totalBallsCount:int = matchedBallCount + unMatchedBallCount;
			var matchPatterns:Vector.<CardPattern> = roundMatchPatterns;
			
			/*switch(Player.current.gamesCount) 
			{
				case 2: { // second round
					
					break; 
				}
				case 3: {
					
					break;
				}
				case 4: {
					
					break;
				}
				case 5: {
					
					break;
				}
			}*/
				
			var minBallsToBingoCombination:int;
			
			if (matchedBallCount <= 2)
			{
				// первые 3 шара всегда есть на карте:
				takeMatchNumberBall = true;
				
				// но ведем сборку по паттерну только с некоторой вероятностью:
				if (Math.random() > 0.65)
					matchPatterns = null;
			}
			else 
			{
				if (matchedBallCount >= tutorLevelBallsBingoCount) 
				{
					// после выдачи шаров, давших гарантированную комбинацию выдаем 50/50
					takeMatchNumberBall = !isLastBallMatched;//Math.random() > 0.5;
					matchPatterns = null;
					//trace('1 > ', matchedBallCount, tutorLevelBallsBingoCount, takeMatchNumberBall);
				}
				else
				{
					// сколько шаров можно отдать от балды(не приведуших к бинго):
					var canTakeUnmatchedBallCount:int = tutorLevelBallsBingoCount - minBallsToMatchPattern(matchPatterns) - totalBallsCount;
					//trace('2 > ', canTakeUnmatchedBallCount, matchedBallCount, tutorLevelBallsBingoCount, takeMatchNumberBall);
					
					/*if (totalBallsCount == 4) {
						// 5 шар пусть будет левый пока собирается поверап
						takeMatchNumberBall = false;
					}*/
					/*else */
					if (canTakeUnmatchedBallCount > 0) {
						matchPatterns = null;
						takeMatchNumberBall = Math.random() > TAKE_MATCH_BALL_RELATIVE_LAST_BALL_RATIO ? (!isLastBallMatched) : (Math.random() > TAKE_MATCH_BALL_RATIO); 
						trace('случайный шар, случайных еще: ', canTakeUnmatchedBallCount, 'выигрышный шар: ', tutorLevelBallsBingoCount, '|',minBallsToMatchPattern(matchPatterns), 'всего шаров: ', totalBallsCount);
					}
					else {
						trace('шар по паттерну');
						takeMatchNumberBall = true;
					}
				}
			}
				
			var ballTaked:Boolean;	
			if (matchedBallCount >= 3)
				ballTaked = addPowerUpBallToGame();
			
			if(!ballTaked)	
				addBallToGame(takeMatchNumberBall, false, matchPatterns, true);
			else
				takeMatchNumberBall = true;
				
			isLastBallMatched = takeMatchNumberBall;
			
			if(takeMatchNumberBall)
				matchedBallCount++
			else	
				unMatchedBallCount++;
			
			totalBallsCount = matchedBallCount + unMatchedBallCount;
			
			var winnerFacebookRatio:Number;
			if (winnersCount == 0)
				winnerFacebookRatio = 1;
			else if (winnersCount < 4)
				winnerFacebookRatio = 0.8;
			else
				winnerFacebookRatio = 0.5;
			
			trace('> taked balls: ', totalBallsCount, 'finish balls count: ', finishRoundBallsCount, 'min balls to bingo: ', tutorLevelBallsBingoCount);	
				
			if (totalBallsCount < tutorLevelBallsBingoCount) {
				
			}
			else if (totalBallsCount < finishRoundBallsCount) 
			{
				/*Game.current.gameScreen.gameUI.gameUIPanel.winnersPane.addTutorialPlayer(1.1, getFromPlayerBingoedMessagePool(winnerFacebookRatio));
				_winnersCount++;
				//Game.current.gameScreen.gameUI.gameUIPanel.winnersPane.addTutorialPlayer(1, 'lifestreamcos', 'Vasiliy');
				if (tutorLevelBingosLeft > 1) 
				{
					Starling.juggler.delayCall(autoChangeInfoPanelData, 1.1, Math.max(1 - tutorLevelBingosLeft, -bingosLeftDecrementStep), -bingosLeftDecrementStep, -bingosLeftDecrementStep);
					//Starling.juggler.delayCall(changeInfoPanelData, 1.1, -bingosLeftDecrementStep, -bingosLeftDecrementStep, -bingosLeftDecrementStep);
				}
				else {
					Starling.juggler.delayCall(changeInfoPanelData, 1, 0, -bingosLeftDecrementStep, -bingosLeftDecrementStep);
				}*/
			}	
			else
			{
				/*Game.current.gameScreen.gameUI.gameUIPanel.winnersPane.addTutorialPlayer(1.1, getFromPlayerBingoedMessagePool(winnerFacebookRatio));
				_winnersCount++;
				Starling.juggler.delayCall(changeInfoPanelData, 1.1, -bingosLeftDecrementStep, -bingosLeftDecrementStep, -bingosLeftDecrementStep);
				stopAddBallInteraction = true;
				
				// завершаем левел:
				finishTutorialRound(Player.current.bingosInARound > 0);
				*/
				return;
			}
			
			for (i = 0; i < Player.current.cards.length; i++)
			{
				gameCard = Game.current.gameScreen.gameUI.getCardByCardModel(Player.current.cards[i]);
				
				if (gameCard && !gameCard.bingoComplete && gameCard.checkIsBingo(false).length > 0 && minimalBingoBallsCount == 0) 
					minimalBingoBallsCount = totalBallsCount;
			}
			//trace('minimalBingoBallsCount: ', minimalBingoBallsCount);
			
			Starling.juggler.delayCall(addBallIteration, 4.6);
		}
		
		
		public function handleBackFromMenu():void 
		{
			stopAddBallInteraction = true;
			
			_roundStartTime = 0;
			
			Starling.juggler.removeByID(roundStartDelayId);
			
			DelayCallUtils.cleanBundle(WinnersPane.DELAY_CALLS_BUNDLE);
			
			if(!allStepsIsDone)
				Game.current.gameScreen.gameUI.tutorialStepHidePowerupBall();
		}
		
		public function addAwardsForBingo(cardIndex:int):void 
		{
			var bingoSkippedBalls:int = minimalBingoBallsCount > 0 ? (matchedBallCount + unMatchedBallCount - minimalBingoBallsCount) : 0;
			Player.current.liveEventScoreEarned += getScoreForBingo(bingoSkippedBalls, Game.current.gameScreen.gameScreenController.getX2Multiplier(cardIndex));
			
			Player.current.cashEarnedFromRoundPrizes += getCashForBingo(Player.current.bingosInARound, roundBingosCount); //x2Multiplier
			
			roundBingosCount++;
		}
		
		private function getScoreForBingo(surplusBalls:int, coeffcient:Number = 1):int {
			return coeffcient * 200 - Math.min(160, surplusBalls * 20);
		}
		
		public function addPlayerToWinners():void 
		{
//			Game.current.gameScreen.gameUI.gameUIPanel.winnersPane.addTutorialPlayer(0, null, Player.current.facebookId, Player.current.firstName ? Player.current.firstName : 'YOU!');
			tutorLevelBingosLeft = Math.max(0, tutorLevelBingosLeft-1);
			tutorLevelCardsCount--;
		}
		
		public function finishTutorialRound(win:Boolean = false):void 
		{
			gameManager.analyticsManager.sendTutorialEvent('roundFinish_' + (Player.current.gamesCount + 1).toString(), win);
			
			stopAddBallInteraction = true;
			
			DelayCallUtils.cleanBundle(WinnersPane.DELAY_CALLS_BUNDLE);
			
			Player.current.clearCards();
			Room.current.numbers = [];
			
			var roundOverMessage:RoundOverMessage = new RoundOverMessage();
			roundOverMessage.chestWin = win ? (new ChestWinMessage()) : null;
			new RoundOverCommand(Game.current.gameScreen, roundOverMessage, true).execute();
			
			
			//кеш за первую, вторую третью бингу 30-20-15-10
	
			_tutorialFirstLevelPassed = true;
			_tutorialLevelsPassed = Player.current.gamesCount >= TUTORIAL_GAMES_COUNT; 
			//_isCollectionStepPassed = false;
			//completeTutor();
		}
		
		public function showHand(layer:DisplayObjectContainer, x:Number, y:Number, playDelay:Number = 1, rotation:Number = 0, scaleX:Number = 1, scaleY:Number = 1):AnimationContainer
		{
			if (!handAnimation) {
				handAnimation = new AnimationContainer(MovieClipAsset.PackBase, false);
				handAnimation.dispatchOnCompleteTimeline = true;
				handAnimation.addEventListener(AnimationContainer.EVENT_COMPLETE_TIMELINE, handler_handAnimationComplete);
				handAnimation.repeatCount = 1000;
			}
		
			handPlayTimelineDelay = playDelay;
			handAnimation.touchable = false;
			
			//handAnimation.scale = gameUILayoutScale;
			handAnimation.pivotX = 118 * pxScale;
			handAnimation.pivotY = 47 * pxScale;
			handAnimation.rotation = rotation;
			handAnimation.scaleX = scaleX * layoutHelper.independentScaleFromEtalonMin;
			handAnimation.scaleY = scaleY * layoutHelper.independentScaleFromEtalonMin;
			handAnimation.x = x;
			handAnimation.y = y;
			handAnimation.touchable = false;
			layer.addChild(handAnimation);
			handAnimation.playTimeline('tutor_hand', true, false, -1, 1000);
			
			return handAnimation;
		}
		
		public function hideHand():void
		{
			Starling.juggler.removeByID(lastHandDelayCallId);
			if (handAnimation) {
				handAnimation.stop();
				handAnimation.removeEventListener(AnimationContainer.EVENT_COMPLETE_TIMELINE, handler_handAnimationComplete);
				//handAnimation.removeEventListener(Event.COMPLETE, handler_handAnimationComplete);
				handAnimation.removeFromParent();
				handAnimation = null;
			}
		}
		
		public function showAlphaMask(layer:DisplayObjectContainer, x:Number, y:Number, width:Number, height:Number, startWidth:Number, startHeight:Number, time:Number = 0.3, delay:Number = 0, callHideOnStart:Boolean = true, onlyMaskUntouchable:Boolean = false):void
		{
			if(callHideOnStart)
				hideAlphaMask(true);
			
			alphaMaskContainer = new Sprite();
			alphaMaskContainer.alpha = 0;
			layer.addChild(alphaMaskContainer);
			
			var alpha:Number = 0.8;
			
			alphaMaskImage = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/mask_hole_round"));
			alphaMaskImage.scale9Grid = new Rectangle(37 * pxScale, 37 * pxScale, 2 * pxScale, 2 * pxScale);
			alphaMaskImage.alignPivot();
			alphaMaskImage.x = x;
			alphaMaskImage.y = y;
			alphaMaskImage.width = startWidth;
			alphaMaskImage.height = startHeight;
			alphaMaskImage.touchable = false;
			alphaMaskContainer.addChild(alphaMaskImage);
			
			alphaMaskQuads = new <Quad>[];
			var quad:Quad = new Quad(1, 1, 0x000000);
			quad.touchable = onlyMaskUntouchable;
			quad.width = layoutHelper.stageWidth;
			alphaMaskContainer.addChild(quad);
			alphaMaskQuads.push(quad);
			
			quad = new Quad(1, 1, 0x000000);
			quad.width = layoutHelper.stageWidth;
			quad.touchable = onlyMaskUntouchable;
			alphaMaskContainer.addChild(quad);
			alphaMaskQuads.push(quad);
			
			quad = new Quad(1, 1, 0x000000);
			quad.touchable = onlyMaskUntouchable;
			alphaMaskContainer.addChild(quad);
			alphaMaskQuads.push(quad);
			
			quad = new Quad(1, 1, 0x000000);
			quad.touchable = onlyMaskUntouchable;
			alphaMaskContainer.addChild(quad);
			alphaMaskQuads.push(quad);
			
			alphaMaskContainer.addChild(alphaMaskImage);
			
			alignAlphaMask();
			
			Starling.juggler.tween(alphaMaskContainer, time, {alpha:alpha, delay:delay});
			Starling.juggler.tween(alphaMaskImage, time, {width:width, height:height, delay:delay, onUpdate:alignAlphaMask, transition:Transitions.EASE_OUT});
		}
		
		public function tweenAlphaMask(x:Number, y:Number, width:Number, height:Number, time:Number = 0.3, delay:Number = 0, removeTweens:Boolean = true, transition:String = "easeOut"):void
		{
			if (!alphaMaskContainer)
				return;
		
			if (removeTweens) {
				Starling.juggler.removeTweens(alphaMaskContainer);
				Starling.juggler.removeTweens(alphaMaskImage);
			}
			
			Starling.juggler.tween(alphaMaskContainer, time, {alpha:0.8, delay:delay});
			Starling.juggler.tween(alphaMaskImage, time, {x:x, y:y, width:width, height:height, delay:delay, onUpdate:alignAlphaMask, alpha:1, transition:transition});
		}
		
		public function hideAlphaMask(instant:Boolean = false, alphaTime:Number = 0.2, tweenTime:Number = 0.2, delay:Number = 0, toWidth:Number = NaN, toHeight:Number = NaN):void
		{
			if (!alphaMaskContainer) 
				return;
			
			if (instant) {
				Starling.juggler.removeTweens(alphaMaskContainer);
				Starling.juggler.removeTweens(alphaMaskImage);
				removeAlphaMask();
			}	
			else {
				Starling.juggler.tween(alphaMaskContainer, alphaTime, {alpha:0, delay:delay});
				Starling.juggler.tween(alphaMaskImage, tweenTime, {width:(isNaN(toWidth) ? alphaMaskImage.width : toWidth), height:(isNaN(toHeight) ? alphaMaskImage.height : toHeight), delay:delay, onUpdate:alignAlphaMask, transition:Transitions.EASE_OUT, onComplete:removeAlphaMask});
			}
		}
		
		public function get hasAlphaMask():Boolean
		{
			return alphaMaskContainer != null;
		}
		
		private function alignAlphaMask():void
		{
			if (!alphaMaskContainer)
				return;
		
			var halfImageHeight:Number = alphaMaskImage.height / 2;
			var halfImageWidth:Number = alphaMaskImage.width / 2;
			
			var quad:Quad;
			
			alphaMaskQuads[0].height = alphaMaskImage.y - halfImageHeight;
			alphaMaskQuads[0].width = layoutHelper.stageWidth;
			
			alphaMaskQuads[1].y = alphaMaskImage.y + halfImageHeight;
			alphaMaskQuads[1].height = layoutHelper.stageHeight - alphaMaskQuads[1].y;
			alphaMaskQuads[1].width = layoutHelper.stageWidth;
			
			quad = alphaMaskQuads[2];
			quad.y = alphaMaskQuads[0].height;
			quad.height = alphaMaskQuads[1].y - quad.y;
			quad.width = alphaMaskImage.x - halfImageWidth;
			
			quad = alphaMaskQuads[3];
			quad.y = alphaMaskQuads[0].height;
			quad.height = alphaMaskQuads[2].height;
			quad.x = alphaMaskImage.x + halfImageWidth;
			quad.width = layoutHelper.stageWidth - quad.x;
		}
		
		private function removeAlphaMask():void
		{
			if (!alphaMaskContainer) 
				return;
				
			alphaMaskContainer.removeFromParent();
			alphaMaskContainer = null;
			alphaMaskImage = null;
			
			var quad:Quad;
			while (alphaMaskQuads.length > 0) {
				quad = alphaMaskQuads.shift();
				quad.removeFromParent(true);
			}
			alphaMaskQuads = null;
			alphaMaskContainer = null;
		}
		
		
		public function createNewChest():Boolean
		{
			var chestData:ChestData = gameManager.chestsData.getEmptySlot(Math.floor((gameManager.chestsData.chests.length - 1) / 2));
			if (!chestData)
				return false;
			
			var chestParameters:Array = getChestParameters();
				
			chestData.fillChest.apply(null, chestParameters);
			
			return true;
			//createChest(type:int, isNew:Boolean, openTimestamp:int, passNumbers:int, cashCountMin:int, cashCountMax:int, collectionCount:int, collectionRarity:int, powerUpsPackCount:int):void 
		}
		
		public function getChestParameters():Array
		{
			var chestParameterIndex:int = Math.max(0, Player.current.gamesCount - 1);
			if (chestParameterIndex < tutorialChestsParameters.length)
				return tutorialChestsParameters[chestParameterIndex];
			
			return tutorialChestsParameters[0];
		}
		
		public function getCashForBingo(bingosCount:int = 0, startIndex:int = 0):int
		{
			return 5;
			/*var cashTable:Array = ([10, 10, 10, 10] as Array).splice(startIndex, 5);
			var cashValue:int;
			while(bingosCount > 0) {
				cashValue += cashTable.length > 0 ? cashTable.shift() : 0;
				bingosCount--;
			}
			
			return cashValue;*/
		}
		
		private function getStringFromArray(list:Array, index:int, stubValue:String):String {
			if (index >= list.length)
				return stubValue;
			
			return String(list[index]);	
		}
		
		private function handler_handAnimationComplete(e:Event):void 
		{
			handAnimation.stop();
			lastHandDelayCallId = Starling.juggler.delayCall(handAnimation.playTimeline, handPlayTimelineDelay, 'tutor_hand', true, false, -1, 1000);
		}
		
		private function changeInfoPanelData(addLevelBingosLeft:int, addLevelCardsCount:int = 0, addLevelPlayersCount:int = 0):void {
			tutorLevelBingosLeft = Math.max(0, addLevelBingosLeft + tutorLevelBingosLeft);
			tutorLevelCardsCount = Math.max(0, addLevelCardsCount + tutorLevelCardsCount);
			tutorLevelPlayersCount = Math.max(0, addLevelPlayersCount + tutorLevelPlayersCount);
		}
		
		private function autoChangeInfoPanelData(addLevelBingosLeft:int, addLevelCardsCount:int = 0, addLevelPlayersCount:int = 0):void 
		{
			//trace(tutorLevelBingosLeft, addLevelBingosLeft);
				
			if (addLevelBingosLeft == 0) {
				changeInfoPanelData(bingosLeftDecrementStep, addLevelCardsCount, addLevelPlayersCount);
				return;
			}	
			
			var maxTime:Number = 4;
			var timeStep:Number = Math.abs(maxTime / addLevelBingosLeft);
			var totalDelay:Number = 0;
			addLevelBingosLeft = Math.abs(addLevelBingosLeft);
			while (addLevelBingosLeft > 0) {
				totalDelay += timeStep * Math.random(); 
				Starling.juggler.delayCall(changeInfoPanelData, totalDelay, -1, -1, -1);
				addLevelBingosLeft--;
			}
		}
		
		public function skipTutor():void 
		{
			_isEnabledOnServer = false;
			
			completeChestFreeOpenStep();
			completeChestTakeOutStep();
			completePowerupStep();
			gameManager.chestsData.freeChestClaimed = true;
			
			Player.current.gamesCount = TUTORIAL_GAMES_COUNT + 1;	
			
			Game.connectionManager.sendPlayerUpdateMessage();
		}
		
		public function skipTutorFirstLevel():void 
		{
			_tutorialFirstLevelPassed = true;
			_isChestTakeOutStepPassed = true;
			_isTourneyResultsHandleStepPassed = true;
			SharedObjectManager.instance.setSharedProperty(Constants.SHARED_PROPERTY_FIRST_START, true);
		}
		
		public function resetTutor():void 
		{
			_tutorialFirstLevelPassed = false;
			_tutorialLevelsPassed = false;
			_isCollectionStepPassed = false;
			_isChestTakeOutStepPassed = false;
			_isTourneyResultsHandleStepPassed = false;
			_isEnabledOnServer = true;
		}
		
		public function clearOnTournamentChange():void 
		{
			if (Game.current.gameScreen.lobbyUI) {
	//			Game.current.gameScreen.lobbyUI.tutorialStepHideHandOnCollectionButton();
		//		Game.current.gameScreen.lobbyUI.chestsView.tutorialClean();
			}
			else {
				FadeQuad.hide();
				gameManager.tutorialManager.hideHand();
			}
		}
		
		public function minBallsToMatchPattern(patterns:Vector.<CardPattern> = null):int
		{
			var minBallsToMatchPattern:int;
			var i:int;
			var gameCard:GameCard;
			for (i = 0; i < Player.current.cards.length; i++) {
				gameCard = Game.current.gameScreen.gameUI.getCardByCardModel(Player.current.cards[i]);
				if (!gameCard || gameCard.bingoComplete)
					break;
				
				if(minBallsToMatchPattern == 0)	
					minBallsToMatchPattern = gameCard.minBallsToMatchPattern(patterns);
				else
					minBallsToMatchPattern = Math.min(minBallsToMatchPattern, gameCard.minBallsToMatchPattern(patterns));
			}
			return minBallsToMatchPattern;
		}
		
		/** помощь/довыдача хр */
		public function modifyPlayerXp():void
		{
			if (tutorialLevelsPassed)
				return;
			
			var expectLevel:int = gameManager.gameData.getLevelForXp(Player.current.xpCount + Player.current.xpEarned);
			//trace('modifyPlayerXp ', Player.current.gamesCount, expectLevel, Player.current.xpLevel , Player.current.xpCount, Player.current.xpEarned, gameManager.gameData.getXpCountForLevel(2), gameManager.gameData.getXpCountForLevel(3) );
			
			if (Player.current.gamesCount == TUTORIAL_ROUND_TO_SECOND_LEVEL && expectLevel < 2) {
				Player.current.xpEarned += (getAddXpForLevel(2, 0.4 + Math.random()*0.35));
			}
			else if (Player.current.gamesCount == 3 && expectLevel < 3) {
				Player.current.xpEarned += (getAddXpForLevel(3, 0.05 + Math.random()*0.25));
			}
			else if (Player.current.gamesCount == 4) {
				Player.current.xpEarned += (getAddXpForLevel(3, 0.7 + Math.random()*0.25));
			}
			else if (Player.current.gamesCount == 5 && expectLevel < 4) {
				Player.current.xpEarned += (getAddXpForLevel(4, 0.00 + Math.random()*0.2));
			}
		
			//trace('add xp',  addXp, Player.current.xpCount, Player.current.xpEarned + gameManager.gameData.getXpCountForLevel(2) - Player.current.xpCount - Player.current.xpEarned + addXp);
		}

		private function getAddXpForLevel(level:int, valueToNextLevel:Number):int 
		{
			var xpValue:int;
			var expectLevel:int = gameManager.gameData.getLevelForXp(Player.current.xpCount + Player.current.xpEarned);
			
			var targetLevelXp:int = gameManager.gameData.getXpCountForLevel(level);
			var nextAfterTargetLevelXp:int = gameManager.gameData.getXpCountForLevel(level + 1);
			
			if (expectLevel > level) {
				xpValue = 0;
			}
			else if (expectLevel == level) 
			{
				//((Player.current.xpCount + Player.current.xpEarned) - targetLevelXp) / (afterTargetLevelXp - targetLevelXp);
				
				xpValue = Math.max(0, (targetLevelXp + (nextAfterTargetLevelXp - targetLevelXp) * valueToNextLevel) - (Player.current.xpCount + Player.current.xpEarned));
				
				//gameManager.gameData.getXpCountForLevel(level + 1) - gameManager.gameData.getXpCountForLevel(level);
				
			}
			else if(expectLevel < level) {
				xpValue = targetLevelXp + (nextAfterTargetLevelXp - targetLevelXp) * valueToNextLevel - Player.current.xpCount - Player.current.xpEarned;
			}
			
			return xpValue;
			
			//	addXp = Math.max(1, (gameManager.gameData.getXpCountForLevel(TUTORIAL_ROUND_TO_SECOND_LEVEL) - gameManager.gameData.getXpCountForLevel(2)) * 0.1 * Math.random());	
				//Player.current.xpEarned += gameManager.gameData.getXpCountForLevel(2) - Player.current.xpCount - Player.current.xpEarned + addXp;
			

		}
		
		private function calculateBallsCount(roundsCount:int):void 
		{
			var ratio:Number = Math.min(1, (roundsCount / (TUTORIAL_GAMES_COUNT - 1)));
			tutorLevelBallsBingoCount = Math.min(realRoundBallsBingoCount, TUTORIAL_MIN_BALLS_BINGO_COUNT + Math.max(0, realRoundBallsBingoCount - TUTORIAL_MIN_BALLS_BINGO_COUNT) * ratio);
			finishRoundBallsCount = Math.min(tutorLevelBallsBingoCount * 2, tutorLevelBallsBingoCount + 7);
		}
		
		public function stop():void
		{
			stopAddBallInteraction = true;
			
			_roundStartTime = 0;
			
			Starling.juggler.removeByID(roundStartDelayId);
			
			DelayCallUtils.cleanBundle(WinnersPane.DELAY_CALLS_BUNDLE);
			
			FadeQuad.hide();
			
			gameManager.tutorialManager.hideHand();
			
			hideAlphaMask(true);
		}
		
		/*********************************************************************************************************************
		 *
		 * 
		 * 
		 *********************************************************************************************************************/		
		
		public static function addBallToGame(matchNumberInAnyCard:Boolean = true, addToCardWidthBadBingo:Boolean = false, cardPatterns:Vector.<CardPattern> = null, takeAnyBallIfPreviousConditionsFailed:Boolean = true):Boolean
		{
			if (!Player.current.cards || Player.current.cards.length == 0) 
				return false;
			
			//var emptyNumbers:Array = [];
			
			var allNumbers:Array = []; // служит тока для наполнения номеров, которых на карточках и уже среди выпавших нет
			var matchingNumbers:Array = []; // служит тока для наполнения номеров, которые на карточках есть
			var cardPatternNumbers:Array = [];
			var j:int = 1;
			while (j <= 75) {
				allNumbers.push(j);
				j++;
			}
			
			var ballNumber:int;
			var card:Card;
			var gameCard:GameCard;
			var i:int;
			var k:int;
			var l:int;
			var length:int;
			var numberIndex:int;
			for (i = 0; i < Player.current.cards.length; i++)
			{
				card = Player.current.cards[i];
				
				gameCard  = Game.current.gameScreen.gameUI.getCardByCardModel(card);
				if (gameCard) {
					if (gameCard.bingoComplete)
						continue;
						
					if (!addToCardWidthBadBingo && !gameCard.enabled)
						continue;
				}
				
				// попытка найти по паттерну:
				var cardPattern:CardPattern;
				length = (cardPatterns && matchNumberInAnyCard) ? cardPatterns.length : 0;
				for (j = 0; j < length; j++)
				{
					cardPattern = cardPatterns[j];
					l = cardPattern.filledPositions.length;
					for (k = 0; k < l; k++)
					{
						var point:Point = cardPattern.filledPositions[k];
						var cellId:int = point.y * 5 + point.x;
						
						// cellId == 12 is center always daubed cell 
						if (cellId != 12)
						{
							if (cellId > 11)
								cellId--;
							
							if (Room.current.numbers.indexOf(card.numbers[cellId]) == -1) 	
								cardPatternNumbers.push(card.numbers[cellId]);	
						}
					}
					
					if (cardPatternNumbers.length != 0) 
					{
						ballNumber = cardPatternNumbers[Math.floor(Math.random()*cardPatternNumbers.length)];
						addBall(ballNumber);
						return true;
					}
				}
				
				
				for (j = 0; j < card.numbers.length; j++)
				{
					if (matchNumberInAnyCard)
					{
						if (Room.current.numbers.indexOf(card.numbers[j]) == -1) 
						{
							matchingNumbers.push(card.numbers[j]);
							
							/*Room.current.numbers.push(card.numbers[j]);	
							Game.current.gameScreen.gameUI.addBall(card.numbers[j]);
							return true;*/
						}
					}
					else
					{
						numberIndex = allNumbers.indexOf(card.numbers[j]);
						if(numberIndex != -1)
							allNumbers.splice(numberIndex, 1);
					}
				}
			}
			
			if (matchNumberInAnyCard)
			{
				if (matchingNumbers.length > 0) {
					// если номера для выдачи есть, то все ок выдаем
					ballNumber = matchingNumbers[Math.floor(Math.random()*matchingNumbers.length)];
					//trace('add matching number ', ballNumber);
					addBall(ballNumber);
					return true;
				}
				else if (takeAnyBallIfPreviousConditionsFailed) {
					// если даубных номеров для выдачи нет, но стоит флажок выдавать насильно шар, то выдаем номер которого на карте нет
					return addBallToGame(false, addToCardWidthBadBingo, null, false);
				}
				else {
					return false;
				}	
			}				
			
			length = Room.current.numbers.length;
			for (i = 0; i < length; i++) {
				numberIndex = allNumbers.indexOf(Room.current.numbers[i]);
				if(numberIndex != -1)
					allNumbers.splice(numberIndex, 1);
			}
			
			if (allNumbers.length == 0) 
			{
				if (!matchNumberInAnyCard && takeAnyBallIfPreviousConditionsFailed) {
					return addBallToGame(true, addToCardWidthBadBingo, cardPatterns);
				}
				
				return false;
			}
			
			//var ballNumber:int = Math.max(1, int(Math.random() * 75));
			ballNumber = allNumbers[Math.floor(Math.random()*allNumbers.length)];// Math.max(1, int(Math.random() * 75));
			addBall(ballNumber);	
			
			return true;
		}
	
		public static function addPowerUpBallToGame():Boolean
		{
			if (!Player.current.cards || Player.current.cards.length == 0) 
				return false;
			
			var powerUpNumbers:Vector.<int> = new Vector.<int>();
			var ballNumber:int;
			var gameCard:GameCard;
			var i:int;
			var j:int;
			
			for (i = 0; i < Player.current.cards.length; i++)
			{
				gameCard  = Game.current.gameScreen.gameUI.getCardByCardModel(Player.current.cards[i]);
				if (gameCard) 
				{
					if (gameCard.bingoComplete || !gameCard.enabled)
						continue;
						
					powerUpNumbers = gameCard.getPowerupCellNumbers();	
					
					j = 0;
					while (j < powerUpNumbers.length) {
						if (Room.current.numbers.indexOf(powerUpNumbers[j]) != -1) 
							powerUpNumbers.splice(j, 1);
						else
							j++;
					}
					
					if (powerUpNumbers.length > 0) 
					{
						ballNumber = powerUpNumbers[Math.floor(Math.random()*powerUpNumbers.length)];
						//trace('add matching number to powerup cell', ballNumber);
						addBall(ballNumber);
						return true;
					}
				}
			}
			
			return false;
		}
		
		private static function addBall(ballNumber:uint):void {
			//trace('ball number ', ballNumber);
			Game.current.gameScreen.gameUI.addBall(ballNumber);
			Room.current.numbers.push(ballNumber);	
		}
		
		public static function addWinnerToGame():void 
		{
			//Room.current.bingoHistory.push(WinnersPane.debugGetPlayerBingoedMessage(count % 2 == 0, place++));
//			Game.current.gameScreen.gameUI.gameUIPanel.winnersPane.debugAddPlayer();
		}
		
		private static var poolBingoedFacebookUsers:Vector.<PlayerBingoedMessage> = new Vector.<PlayerBingoedMessage>();
		private static var poolBingoedGuestUsers:Vector.<PlayerBingoedMessage> = new Vector.<PlayerBingoedMessage>();
		private static var poolBingoedUsersIdsCash:Object = {};
		
		public static function fillPlayerBingoedMessagePool(message:PlayerBingoedMessage):void 
		{
			if (!message) 
				return;
			
			if (message.room) 
			{
				infoPanelAverageBingosLeft = Math.max(infoPanelAverageBingosLeft, message.room.bingosLeft);
				infoPanelAveragePlayersCount = Math.max(infoPanelAveragePlayersCount, message.room.playersCount);
				infoPanelAverageCardsCount = Math.max(infoPanelAverageCardsCount, message.room.cardsCount);
			}
			
			if(!Player.current || !message.player || !message.player.playerId || (Player.current.playerId == message.player.playerId.toNumber()))
				return;
			
			if (message.player.playerId.toNumber() in poolBingoedUsersIdsCash)
				return;
				
			//if(message.player.avatar != null)	
				//trace('player avatar ',  message.player.avatar);	
				
			if (message.player.hasFacebookIdString)
				poolBingoedFacebookUsers.push(message);
			else 
				poolBingoedGuestUsers.push(message);
			
			poolBingoedUsersIdsCash[message.player.playerId.toNumber()] = true;	
		}
		
		public static function getFromPlayerBingoedMessagePool(facebookUserRatio:Number = 0.8):PlayerBingoedMessage
		{
			var message:PlayerBingoedMessage;
			var random:Number = Math.random();
			
			if (random < facebookUserRatio) 
				message = poolBingoedFacebookUsers.length > 0 ? poolBingoedFacebookUsers.shift() : null;
			
			if (!message)
				message = poolBingoedGuestUsers.length > 0 ? poolBingoedGuestUsers.shift() : null;
			
			if (!message) 
			{
				message = new PlayerBingoedMessage();
				
				var playerMessage:PlayerMessage = new PlayerMessage();
				playerMessage.playerId = UInt64.fromNumber(1000 + Math.random() * 1125);
				playerMessage.firstName = "Guest " + playerMessage.playerId.toNumber().toString();
				message.player = playerMessage;
			}
			else {
				delete poolBingoedUsersIdsCash[message.player.playerId.toNumber()];
			}
				
			//message.place = place;
			
			return message;
		}		
		
		/*********************************************************************************************************************
		*
		* SLOT MACHINE TUTORIAL
		* 
		*********************************************************************************************************************/		
		
		public static var SLOT_MACHINE_TUTOR_MAX_SPIN_COUNT:int = 7;
		
		public static function handleSpinResult(stakeValue:int, spinCount:int, spinResult:SpinResult, rewardsChanceTable:SlotMachineChanceTable):void
		{
			if(spinCount > SLOT_MACHINE_TUTOR_MAX_SPIN_COUNT || spinResult.spinType != SpinType.DEFAULT)
				return;
			
			if (stakeValue <= 50)
			{
				switch(spinCount)
				{
					case 0: spinResult.reward = rewardsChanceTable.getRewardByType(SlotMachineRewardType.CASH_1);
						break;
					case 1: spinResult.reward = rewardsChanceTable.getRewardByType(SlotMachineRewardType.DUST);
						break;
					case 2: spinResult.reward = rewardsChanceTable.getRewardByType(SlotMachineRewardType.NO_WIN);
						break;
					case 3: spinResult.reward = rewardsChanceTable.getRewardByType(SlotMachineRewardType.CASH_1);
						break;
					case 4: spinResult.reward = rewardsChanceTable.getRewardByType(SlotMachineRewardType.FREE_SPINS);
						break;
					case 5: spinResult.reward = rewardsChanceTable.getRewardByType(SlotMachineRewardType.GOLD_CHEST);
						break;
					case 6: spinResult.reward = rewardsChanceTable.getRewardByType(SlotMachineRewardType.NO_WIN);
						break;
					case 7: spinResult.reward = rewardsChanceTable.getRewardByType(SlotMachineRewardType.CASH_1);
						break;
				}
			}
			else
			{
				switch(spinCount)
				{
					case 0: {
						if(spinResult.reward.rewardType == SlotMachineRewardType.NO_WIN)
							spinResult.reward = rewardsChanceTable.getRewardByType(SlotMachineRewardType.CASH_1);
						break;
					}
					case 1: spinResult.reward = rewardsChanceTable.getRewardByType(SlotMachineRewardType.CASH_1);
						break;
					case 2: spinResult.reward = rewardsChanceTable.getRewardByType(SlotMachineRewardType.NO_WIN);
						break;
					case 3: {
						if(spinResult.reward.rewardType == SlotMachineRewardType.NO_WIN)
							spinResult.reward = rewardsChanceTable.getRewardByType(SlotMachineRewardType.THREE_DAUBS);
						break;
					}
					case 4: spinResult.reward = rewardsChanceTable.getRewardByType(SlotMachineRewardType.FREE_SPINS);
						break;
					case 5: spinResult.reward = rewardsChanceTable.getRewardByType(SlotMachineRewardType.GOLD_CHEST);
						break;
					case 6: spinResult.reward = rewardsChanceTable.getRewardByType(SlotMachineRewardType.NO_WIN);
						break;
					case 7: {
						if(spinResult.reward.rewardType == SlotMachineRewardType.NO_WIN)
							spinResult.reward = rewardsChanceTable.getRewardByType(SlotMachineRewardType.DUST);
						break;
					}
				}
			}
		}
		
		/*********************************************************************************************************************
		*
		* VALUES CALCULATOR
		* 
		*********************************************************************************************************************/	
		
		public function calculateTutorRoundValues(considerTwoCardsMode:Boolean = true, twoCardsBuyProbability:Number = 0.5):void
		{
			var TWO_CARDS_ROUND:int = TUTORIAL_ROUND_TO_SECOND_LEVEL;
			var maxCardsCount:Number = 1;
			var cardsCount:Number = 1;
			
			var i:int;
			var j:int;
			var roundMinScore:int;
			var roundMaxScore:int;
			var roundAverageScore:int;
			var roundMinXp:int;
			var roundMaxXp:int;
			var roundAverageXp:int;
			
			var minBallsToFinishList:Array = [5,4,3,4,4];
			
			var minMatchBallsToFinishRound:int;
			var maxMatchBallsInRound:int;
			var averageMatchBallsInRound:int;
			
			var minCashForRound:int;
			var maxCashForRound:int;
			
			var summaryMinScore:int;
			var summaryMaxScore:int;
			var summaryAverageScore:int;
			var summaryMinXp:int;
			var summaryMaxXp:int;
			var summaryAverageXp:int;
			var summaryMinCash:int;
			var summaryMaxCash:int;
			
			var powerUpsRoundUsesAverageCount:int;
			var powerUpsRoundUsesMaxCount:int;
			var powerUpsRoundWinAverageCount:int;
			var powerUpsRoundWinMaxCount:int;
			
			var cashUsesAverage:int;
			
			trace('');
			
			for (i = 0; i < TUTORIAL_GAMES_COUNT; i++) 
			{
				trace('ROUND ' + (i + 1).toString());
				calculateBallsCount(i);
				
				minMatchBallsToFinishRound = i < minBallsToFinishList.length ? minBallsToFinishList[i] : 4;
				
				cardsCount = considerTwoCardsMode ? (i < TWO_CARDS_ROUND ? 1 : (1 + 1 * twoCardsBuyProbability)) : 1;
				maxCardsCount = considerTwoCardsMode ? (i < TWO_CARDS_ROUND ? 1 : 2) : 1;
				
				if (i == 0) 
				{
					maxMatchBallsInRound = 5;
					averageMatchBallsInRound = 4;
					
					
					roundMinScore = minMatchBallsToFinishRound * 10 + getScoreForBingo(0, 1);
					roundMaxScore = maxMatchBallsInRound * 10 + getScoreForBingo(0, 1);
					roundAverageScore = averageMatchBallsInRound * 10 + getScoreForBingo(0, 1);
					
					roundMinXp = minMatchBallsToFinishRound * 10;
					roundMaxXp = maxMatchBallsInRound * 10;
					roundAverageXp = averageMatchBallsInRound * 10;
					
					minCashForRound = maxCashForRound = getCashForBingo(1);
					
					
					powerUpsRoundUsesAverageCount++;
					powerUpsRoundUsesMaxCount++;
				}
				else 
				{
					maxMatchBallsInRound = 4; // гарантированные 3 + 1(поверапный) шара в начале раунда
					var ballsToGuarantyBingoCount:int = tutorLevelBallsBingoCount - maxMatchBallsInRound;
					maxMatchBallsInRound += ballsToGuarantyBingoCount;
					maxMatchBallsInRound += Math.floor(finishRoundBallsCount - tutorLevelBallsBingoCount)/2
					
					var matchedBallsMidValue:int = Math.round(ballsToGuarantyBingoCount * (((1 - TAKE_MATCH_BALL_RELATIVE_LAST_BALL_RATIO) * 0.5) + TAKE_MATCH_BALL_RELATIVE_LAST_BALL_RATIO * TAKE_MATCH_BALL_RATIO));
					averageMatchBallsInRound = 4 + matchedBallsMidValue + Math.floor(finishRoundBallsCount - tutorLevelBallsBingoCount) / 2;
					
					roundMinScore = cardsCount * minMatchBallsToFinishRound * 10;
					roundMaxScore = cardsCount * (maxMatchBallsInRound * 10 + getScoreForBingo(0, 1));
					roundAverageScore = cardsCount * (averageMatchBallsInRound * 10 + getScoreForBingo(0, 1));
					
					roundMinXp = cardsCount * minMatchBallsToFinishRound * 10;
					roundMaxXp = cardsCount * maxMatchBallsInRound * 10;
					roundAverageXp = cardsCount * averageMatchBallsInRound * 10;
					
					minCashForRound = 0;
					maxCashForRound = getCashForBingo(maxCardsCount) + cardsCount * (i == 1 ? gameManager.gameData.cashPowerupQuantity : 0); // учли, что в 4-5 раундах уже может быть 2 карточки и поверап кеша во 2 раунде
					
					
					//trace('powerups average and max ', Math.round(cardsCount * (Math.floor(averageMatchBallsInRound/3) - (averageMatchBallsInRound%3 > 0 ? 0 : 1))), Math.round(cardsCount * (Math.floor(maxMatchBallsInRound/3) - (maxMatchBallsInRound%3 > 0 ? 0 : 1))));
					if (i == 3) {
						powerUpsRoundUsesAverageCount += 1;//Math.round(cardsCount * 2);
						powerUpsRoundUsesMaxCount += 1;//Math.round(cardsCount * 2);
					}
					else {
						powerUpsRoundUsesAverageCount += Math.round(/*cardsCount **/ (Math.floor(averageMatchBallsInRound/3) - (averageMatchBallsInRound%3 > 0 ? 0 : 1)));
						powerUpsRoundUsesMaxCount += Math.round(/*cardsCount **/ (Math.floor(maxMatchBallsInRound/3) - (maxMatchBallsInRound%3 > 0 ? 0 : 1)));
					}
				}
				
				// траты денег за карты
				cashUsesAverage += gameManager.tournamentData.getCardCost(cardsCount);
				
				// TUTORIAL_ROUND_TO_SECOND_LEVEL round:
				if (i == (TUTORIAL_ROUND_TO_SECOND_LEVEL-1)) 
				{
					// Учитываем доброс экспы в TUTORIAL_ROUND_TO_SECOND_LEVEL раунде для перехода на 2 уровень:
					var addXpMax:int = Math.max(1, (gameManager.gameData.getXpCountForLevel(3) - gameManager.gameData.getXpCountForLevel(2)) * 0.1);	
					var minXpForLevel_2:int = gameManager.gameData.getXpCountForLevel(2);
			
					roundMinXp += Math.max(0, minXpForLevel_2 - summaryMinXp - roundMinXp);
					roundMaxXp += (summaryMaxXp + roundMaxXp) >= minXpForLevel_2 ? 0 : (Math.max(0, minXpForLevel_2 - summaryMaxXp - roundMaxXp) + addXpMax);
					roundAverageXp += (summaryAverageXp + roundAverageXp) >= minXpForLevel_2 ? 0 : (Math.max(0, minXpForLevel_2 - summaryAverageXp - roundAverageXp) + addXpMax*0.5);
				}
				
				// 4 round:
				if (i == 3) 
				{
					// учет поверапов 
					roundMaxScore += cardsCount * 50;
					roundAverageScore += cardsCount * 50;
				}
				
				// 5 round:
				if (i == 4) {
					// учет поверапов (с учетом х2):
					roundMaxXp += cardsCount * (100 + 2 * 100);
					roundMaxScore += cardsCount * 2 * 50;
					
					// учет х2: (за 30 секунд работы максимум 6 шаров. Берем 4 т.к. 6 совсем нереально.)
					roundMaxScore += cardsCount * 4 * 10;
					roundAverageScore += cardsCount * 4 * 10;
					roundMaxXp += cardsCount * 4 * 10;
					roundAverageXp += cardsCount * 4 * 10;
				}
				
				// учесть с 3 уровня может быть 2 карты
				
				summaryMinScore += roundMinScore;
				summaryMaxScore += roundMaxScore;
				summaryAverageScore += roundAverageScore;
				summaryMinXp += roundMinXp;
				summaryMaxXp += roundMaxXp;
				summaryAverageXp += roundAverageXp;
				summaryMinCash += minCashForRound;
				summaryMaxCash += maxCashForRound;
				
				
				trace('balls to finish min:', minMatchBallsToFinishRound, ', max:', maxMatchBallsInRound, ', average:', averageMatchBallsInRound, ', to bingo: ', tutorLevelBallsBingoCount, ' to finish round: ', finishRoundBallsCount);
				trace('scores min:', roundMinScore, ', max:', roundMaxScore, ', average:', roundAverageScore);//, ', | (score for bingo min: 40 max:200)')
				trace('xp min:', roundMinXp, ', max:', roundMaxXp, ', average:', roundAverageXp)
				trace('cash min:', minCashForRound, ', max:', maxCashForRound);
				
				trace();
				//Player.current.liveEventScoreEarned += Game.current.gameScreen.gameScreenController.getX2Multiplier(cardIndex) * 200 - Math.min(160, bingoSkippedBalls*20);
				//powerupsEarned = Math.ceil(powerupsUsedInRound * 0.2);
			}
			
			trace('SUMMARY:');
			trace('scores min:', summaryMinScore, ', max:', summaryMaxScore, ', average:', summaryAverageScore);
			trace('xp min:', summaryMinXp, ', max:', summaryMaxXp, ', average:', summaryAverageXp);
			trace('cash min:', summaryMinCash, ', max:', summaryMaxCash);
			
			trace();
			
			
			// CHESTS:
			
			var cashChest:int;
			var chestPowerups:int;
				
			var summaryCashChest:int;
			var summaryChestPowerups:int;
			
			var chestParameters:Array;
			var chestType:int;
			var cashCards:Vector.<uint>;
			var powerUpsPacks:Vector.<ChestPowerupPack>;
			for (i = 0; i < Math.min(TUTORIAL_GAMES_COUNT, tutorialChestsParameters.length); i++) 
			{
				cashChest = 0;
				chestPowerups = 0;
				chestParameters = tutorialChestsParameters[i];
				
				cashCards = chestParameters[4];
				for (j = 0; j < (cashCards ? cashCards.length : 0); j++) {
					cashChest += cashCards[j];
				}
			
				powerUpsPacks = chestParameters[6];
				for (j = 0; j < (powerUpsPacks ? powerUpsPacks.length : 0); j++) {
					chestPowerups += powerUpsPacks[j].totalQuantity;
				}
				
				summaryCashChest += cashChest;
				summaryChestPowerups += chestPowerups;
				
				trace('Chest ' + (i + 1).toString(), ' cash:', cashChest, ', powerups:', chestPowerups);
			}
			
			trace();
			trace('SUMMARY CHESTS:');
			trace('cash:', summaryCashChest, ', powerups:' , summaryChestPowerups);
			
			trace();
			
			powerUpsRoundWinAverageCount = PowerupModel.getEarnedPowerup(powerUpsRoundUsesAverageCount);
			powerUpsRoundWinMaxCount = PowerupModel.getEarnedPowerup(powerUpsRoundUsesMaxCount);
			
			/*var a:int;
			while (a < 26) {
				trace('poweups ' , a, ' got: ',PowerupModel.getEarnedPowerup(a));
				a++;
			}*/
			
			// траты и выигрыши поверапов за тутор
			trace('powerups uses average:', powerUpsRoundUsesAverageCount, ', max:', powerUpsRoundUsesMaxCount);
			trace('powerups wins average:', powerUpsRoundWinAverageCount, ', max:', powerUpsRoundWinMaxCount);
			trace();
			
			// деньги за покупку карт и за выигрыши
			trace('cash uses average:', cashUsesAverage);
			
			trace();
			
			
			// учесть выдаваемые поверапы и деньги в левелапе
			
			var levelData:XPLevel = gameManager.gameData.getLevelData(2);
			var levelAwardTotalCash:int;
			var levelAwardTotalPowerups:int;
			for each (var item:CommodityItemMessage in levelData.rewards) 
			{
				if (item.type == Type.CASH)
					levelAwardTotalCash += item.quantity;
				if (item.type == Type.POWERUP)
					levelAwardTotalPowerups += item.quantity;
			}
			
			trace('new level awards cash:', levelAwardTotalCash, ', powerups: ', levelAwardTotalPowerups);
			
			trace();
			
			trace('PLAYER SUMMARY:');
			
			
			trace('scores min:', summaryMinScore, ', max:', summaryMaxScore, ', average:', summaryAverageScore);
			trace('xp min:', summaryMinXp, ', max:', summaryMaxXp, ', average:', summaryAverageXp);
			
			// кеш: траты за покупки карт, выигрыш раунда, сундуки, левелап
			trace('cash min:', summaryMinCash - cashUsesAverage + levelAwardTotalCash + summaryCashChest, 
			', average:', summaryMinCash + (summaryMaxCash - summaryMinCash)/2 - cashUsesAverage + levelAwardTotalCash + summaryCashChest, 
			', max:', summaryMaxCash - cashUsesAverage + levelAwardTotalCash + summaryCashChest);
			
			// поверапы: использованные, выигрыш раунда, сундуки, левелап
			trace('powerups min:', -powerUpsRoundUsesAverageCount + summaryChestPowerups + levelAwardTotalPowerups,
				  ', average:', -powerUpsRoundUsesAverageCount + powerUpsRoundWinAverageCount + summaryChestPowerups + levelAwardTotalPowerups,
			      ', max:', -powerUpsRoundUsesMaxCount + powerUpsRoundWinMaxCount + summaryChestPowerups + levelAwardTotalPowerups );
			
			trace();	  
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		public static function fillCats(list:Array):void
		{
			list.splice(0, list.length);
			
			while (list.length < gameManager.CAT_SLOTS_MAX) 
			{
				var cat:CatModel = new CatModel();
				cat.id = gameManager.catsModel.getNextCatID();
				cat.health = 3;//Math.ceil(Math.random()*3);
				cat.catUID = gameManager.catsModel.getRandomCatUID();
				
				cat.role = CatRole.getRandom();
				cat.targetCat = Math.floor(Math.random()*3);
				
				//cat.role = CatRole.FIGHTER;
				//cat.role = CatRole.HARVESTER;
				//cat.targetCat = 0;
				
				list.push(cat);
			}
		}
		
		public static function refreshCatTargets(list:Array, opponents:Array):void
		{
			var i:int;
			var cat:CatModel;
			var targetCat:CatModel;
			for (i = 0; i < list.length; i++) 
			{
				cat = list[i] as CatModel;
				
				cat.role = CatRole.getRandom();
				if (cat.role == CatRole.FIGHTER)
				{
					targetCat = opponents[Math.floor(Math.random() * opponents.length)] as CatModel;
					cat.targetCat = targetCat.id;
				}
				else
				{
					cat.targetCat = -1;
				}
				
				//cat.role = CatRole.FIGHTER;
				cat.role = CatRole.HARVESTER;
				//cat.targetCat = (opponents[0] as CatModel).id;
			}
		}
		
		
	}
}
