package com.alisacasino.bingo.screens.gameScreenClasses
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.commands.gameScreenCommands.RoundOverCommand;
	import com.alisacasino.bingo.controls.GameCard;
	import com.alisacasino.bingo.controls.GameCardCell;
	import com.alisacasino.bingo.controls.LoadingWheel;
	import com.alisacasino.bingo.models.Card;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.chests.ChestsData;
	import com.alisacasino.bingo.models.game.DaubStreakData;
	import com.alisacasino.bingo.models.powerups.Minigame;
	import com.alisacasino.bingo.models.powerups.Minigame;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.models.powerups.PowerupDropTweenStyle;
	import com.alisacasino.bingo.models.roomClasses.EventInfo;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.platform.IInterceptor;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.BadBingoMessage;
	import com.alisacasino.bingo.protocol.BallMessage;
	import com.alisacasino.bingo.protocol.BingoOkMessage;
	import com.alisacasino.bingo.protocol.PlayerBingoedMessage;
	import com.alisacasino.bingo.protocol.RoundOverMessage;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.screens.lobbyScreenClasses.LobbyUI;
	import com.alisacasino.bingo.utils.ConnectionManager;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.TimeService;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNACardBingoedEvent;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAPowerupCollectedFromCell;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import starling.core.Starling;
	import starling.events.Event;
	
	public class GameScreenController
	{
		private var gameScreen:GameScreen;
		
		private var soundManager:SoundManager = SoundManager.instance;
		private var player:Player = Player.current;
		private var room:Room = Room.current;
		private var platformInterceptor:IInterceptor = PlatformServices.interceptor;
		
		public var debugMultiplier:int = 1;
		
		private var roundStartTimer:Timer;
		private var _roundStartSecondsLeft:int = -1;
		private var _roundStartBingosLeft:int = -1;
		private var _roundStartWait:Boolean;
		
		public function GameScreenController(gameScreen:GameScreen)
		{
			this.gameScreen = gameScreen;
			
		}
		
		public function init():void
		{
			//soundManager.playSoundtrack(gameManager.tournamentData.collection.soundtrackAsset);
			
			platformInterceptor.setSystemIdleModeKeepAwake();
			
			Game.addEventListener(ConnectionManager.BUY_CARDS_OK_EVENT, onBuyCardsOk);
			Game.addEventListener(ConnectionManager.PLAYER_BOUGHT_CARDS_EVENT, onPlayerBoughtCards);
			Game.addEventListener(ConnectionManager.ROUND_STARTED_EVENT, onRoundStarted);
			Game.addEventListener(ConnectionManager.ROUND_OVER_EVENT, onRoundOver);
			Game.addEventListener(ConnectionManager.PLAYER_BINGOED_EVENT, onPlayerBingoed);
			Game.addEventListener(ConnectionManager.BINGO_OK_EVENT, onBingoOk);
			Game.addEventListener(ConnectionManager.BAD_BINGO_EVENT, onBadBingo);
			Game.addEventListener(ConnectionManager.BALL_EVENT, onBall);
			Game.addEventListener(Game.DAUB_EVENT, onDaub);
			Game.addEventListener(Game.DAUB_MISS_EVENT, daubMissEventHandler);
			
			if(!roundStartTimer)
				roundStartTimer = new Timer(100);
				
			roundStartTimer.addEventListener(TimerEvent.TIMER, handler_roundStartTimer);
		}
	
		public function destroy():void
		{
			soundManager.stopSoundtrack();
			platformInterceptor.setSystemIdleModeNormal();
			Game.removeEventListener(ConnectionManager.BUY_CARDS_OK_EVENT, onBuyCardsOk);
			Game.removeEventListener(ConnectionManager.PLAYER_BOUGHT_CARDS_EVENT, onPlayerBoughtCards);
			Game.removeEventListener(ConnectionManager.ROUND_STARTED_EVENT, onRoundStarted);
			Game.removeEventListener(ConnectionManager.ROUND_OVER_EVENT, onRoundOver);
			Game.removeEventListener(ConnectionManager.PLAYER_BINGOED_EVENT, onPlayerBingoed);
			Game.removeEventListener(ConnectionManager.BINGO_OK_EVENT, onBingoOk);
			Game.removeEventListener(ConnectionManager.BAD_BINGO_EVENT, onBadBingo);
			Game.removeEventListener(ConnectionManager.BALL_EVENT, onBall);
			Game.removeEventListener(Game.DAUB_EVENT, onDaub);
			Game.removeEventListener(Game.DAUB_MISS_EVENT, daubMissEventHandler);
			
			TimeService.removeOneSecondCallback(onOneSecondTimer);
			
			resetStartTimer();
		}
		
		private function onPlayerBoughtCards(e:Event):void 
		{
			
		}
		
		private function daubMissEventHandler(e:Event):void 
		{
			if (Room.DAUB_STREAKS_ENABLED) 
			{
				if (Room.current.daubStreak > 1)
				{
					Room.current.daubStreak = 0;
					var cell:GameCardCell = e.data["cell"];
					if (cell)
					{
						cell.showStreakBreak();
					}
				}
				Room.current.daubStreak = 0;
			}	
		}
		
		public function onOneSecondTimer():void
		{
			//sosTrace("GameScreen.onOneSecondTimer");
			
			var hasCardsAndRoundStarts:Boolean = room.hasRoundStartsIn && player.cards.length > 0;
			
			if (hasCardsAndRoundStarts || player.isActivePlayer)
			{
				sosTrace("player.isActivePlayer : " + player.isActivePlayer, SOSLog.DEBUG);
				sosTrace("mRoom.hasRoundStartsIn : " + room.hasRoundStartsIn, SOSLog.DEBUG);
				sosTrace( "player.cards.length : " + player.cards.length, SOSLog.DEBUG);
				TimeService.removeOneSecondCallback(onOneSecondTimer);
				
				return;
			}
			
			if (checkEventStateChange())
			{
				sosTrace("checkEventStateChange() : true", SOSLog.DEBUG);
				TimeService.removeOneSecondCallback(onOneSecondTimer);
				startLeaveProcedure();
			}
		}
		
		public function checkEventStateChange():Boolean
		{
			if (!Room.current)
			{
				return false;
			}
			
			var room:Room = Room.current;
			if (room.hasActiveEvent != room.roomType.hasActiveEvent)
			{
				//If event ended and we are still in event room, or vice versa, need to quit to lobby.
				return true;
			}
			
			var eventStateChanged:Boolean = false;
			
			if (room.hasActiveEvent)
			{
				var eventInfo:EventInfo = room.activeEvent;
				if (eventInfo)
				{
					if (eventInfo.ended)
					{
						eventStateChanged = true;
					}
				}
				else
				{
					sosTrace("Couldn't find eventInfo for " + room.activeEventName, SOSLog.ERROR);
					eventStateChanged = true;
				}
			}
			
			return eventStateChanged;
		}

		private function onBuyCardsOk(e:Event):void
		{
			sosTrace('private function onBuyCardsOk ', player.isActivePlayer);
			
			if (player.isActivePlayer)
			{
				Room.current.daubStreak = 0;
				Room.current.cardsPlayed = player.cards.length;
				gameScreen.showGame();
			}
			else
			{
//				gameScreen.goWaitForRound();
				roundStartTimer.start();
			}
			gameScreen.lobbyUI.cashBar.animateToValue(player.cashCount, 0.3);
		}
		
		private function onRoundStarted(e:Event):void
		{
			
			if (player.isActivePlayer)
			{
				Room.current.daubStreak = 0;
				Room.current.cellsDaubed = 0;
				Room.current.collectedPowerupsFromCards = 0;
				Room.current.cardsPlayed = player.cards.length;
				gameScreen.showGame(true);
			}
			
			resetStartTimer();
		}
		
		private function onRoundOver(e:Event):void
		{
			new RoundOverCommand(gameScreen, e.data as RoundOverMessage).execute();
		}
		
		private function onBingoOk(e:Event):void
		{
			var bingoOkMessage:BingoOkMessage = e.data as BingoOkMessage;
			confirmBingo(bingoOkMessage.cardId, bingoOkMessage.place);
		}
		
		public function confirmBingo(cardId:int, place:int):void
		{
			player.bingosCount++;
			player.bingosInARound++;
			
			
			if (place == 1)
			{
				player.isFirstPlaceBingo = true;
				soundManager.playVoiceover('first_bingo');
			}
			else
				soundManager.playBingo();
			
			var card:GameCard = getCardByID(cardId);
			if (card)
			{
				var matchedPatterns:Vector.<String> = card.checkIsBingo(true, false);
				gameManager.questModel.bingoClaimed(isX2Active(card.index), place, matchedPatterns, Room.current.stakeData);
				
				var ddnaPattern:String = matchedPatterns.length > 0 ? matchedPatterns[0] : "";
				
				gameManager.analyticsManager.sendDeltaDNAEvent(new DDNACardBingoedEvent(place, isX2Active(card.index), ddnaPattern, matchedPatterns.length));
			}
			
			
			
			gameScreen.gameUI.showBingo(cardId);
		}
		
		private function getCardByID(cardId:int):GameCard
		{
			if (gameScreen && gameScreen.gameUI && gameScreen.gameUI.gameCardsView)
			{
				return gameScreen.gameUI.gameCardsView.getCardById(cardId);
			}
			
			return null;
		}
		
		private function onBadBingo(e:Event):void
		{
			soundManager.playBadBingo();
			SoundManager.instance.playSfx(SoundAsset.BadBingoOpen);
			
			gameScreen.gameUI.showBadBingo((e.data as BadBingoMessage).cardId);	
		}
		
		private function onPlayerBingoed(e:Event):void
		{
			if (gameScreen.state == GameScreen.STATE_IN_GAME)
			{
				gameScreen.gameUI.addWinner(e.data as PlayerBingoedMessage);
			}
		}
		
		private function onPlayerUpdateOk(e:Event):void
		{
		}
		
		private function onBall(e:Event):void
		{
			var ballMessage:BallMessage = e.data as BallMessage;
			gameScreen.gameUI.addBall(ballMessage.number);
		}
		
		private function onDaub(e:Event):void
		{
			var cell:GameCardCell = e.data['cell'] as GameCardCell;
			var cardIndex:int = e.data['cardIndex'] as int;
			var x2Multiplier:Number = getX2Multiplier(cardIndex);
			
			gameManager.questModel.daubRegistered(cell.number);
			
			Room.current.cellsDaubed += 1;
			
			if (Room.DAUB_STREAKS_ENABLED) 
			{
				Room.current.daubStreak++;
				var daubStreakData:DaubStreakData= gameManager.gameData.getDataByDaubStreak(Room.current.daubStreak);
				if (daubStreakData && daubStreakData.needToGiveOutPoints)
				{
					Player.current.liveEventScoreEarned += daubStreakData.pointsBonus;
				}
				if (Room.current.daubStreak > 10)
				{
					Room.current.daubStreak = 1;
				}
				
				gameManager.questModel.daubStreakProgress(Room.current.daubStreak);
			}
			
			player.xpEarned += gameManager.gameData.daubXP * x2Multiplier;
			player.liveEventScoreEarned+= gameManager.gameData.daubPoints * x2Multiplier;
			player.daubsCount++;
			
			if (cell.activePowerup)
			{
				gameManager.questModel.powerupClaimedFromCard(cell.activePowerup);
				gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAPowerupCollectedFromCell(cell.activePowerup));
			}
			
			switch(cell.activePowerup)
			{
				case Powerup.SCORE:
					player.liveEventScoreEarned += cell.powerupQuantity * x2Multiplier;
					//addScoreFromCell(powerupQuantity);
					break;
				case Powerup.CASH:
					player.cashEarnedInRound += cell.powerupQuantity * x2Multiplier * debugMultiplier;
					break;
				case Powerup.XP:
					player.xpEarned += cell.powerupQuantity * x2Multiplier;
					break;
				case Powerup.MINIGAME:
					Minigame.routeMinigameDrop(cell.minigameDrop);
					break;
				case Powerup.X2:
					if (!isAnyX2Active) {
						//trace('SoundManager.instance.playSfxLoop(SoundAsset.X2BoostFireLoop');
						SoundManager.instance.playSfxLoop(SoundAsset.X2BoostFireLoop, 2.9, 0.07, 0.05);
					}
						
					addX2Time(cardIndex, gameManager.gameData.x2TimeMs);
					break;
			}
			
			gameScreen.gameUI.advancePowerup();
		}
		
		public function startLeaveProcedure(event:Event = null):void
		{
			if (gameScreen.state == GameScreen.STATE_IN_GAME)
				gameManager.gameHintsManager.useDaubHint(Player.current.cardsIdsHash);
			
			player.isActivePlayer = false;
			player.clearCards();
			player.clearEarned();
			gameManager.watchdogs.connectionWatchdog.stopBallTimer();
		}
		
		public function usePowerup(powerup:String):void 
		{
			gameScreen.gameUI.addPowerupToCards(powerup, PowerupDropTweenStyle.DEFAULT);
		}
		
		private function onLeaveOk(e:Event):void
		{
			Game.removeEventListener(ConnectionManager.LEAVE_OK_EVENT, onLeaveOk);
			resetStartTimer();
			//Game.current.showLobbyScreen();
		}
		
		private function resetStartTimer():void
		{
			if(roundStartTimer)
				roundStartTimer.stop();
				
			_roundStartBingosLeft = -1;
			_roundStartSecondsLeft = -1;
			_roundStartWait = false;
		}
		
		private function handler_roundStartTimer(event:TimerEvent):void
		{
			//trace('round start timer:', int((Room.current.roundStartTime - TimeService.serverTimeMs)/1000), Room.current.bingosLeft);
			
			
			if (!Room.current || isNaN(Room.current.estimatedRoundEnd))
				return;
			
			var bingosLeft:int = Room.current.bingosLeft;
			
			if (Room.current.roundStartTime != 0 || (Player.current && Player.current.isActivePlayer))
			{
				var roundStartsIn:Number = Math.max(0, Room.current.roundStartTime - TimeService.serverTimeMs);
				var secondsLeft:Number = int((roundStartsIn / 1000) % 60);
				
				if (_roundStartSecondsLeft != secondsLeft)
				{
					//trace('handler_roundStartTimer secondsLeft:', secondsLeft);
					_roundStartSecondsLeft = secondsLeft;
					
					Game.dispatchEventWith(Game.EVENT_ROUND_START_TIMEOUT, false, _roundStartSecondsLeft);
					gameManager.chestsData.dispatchEventWith(ChestsData.EVENT_ACCELERATE_CHEST_TAKE_OUT_DIALOG);
				}
			}
			else if (bingosLeft > 0)
			{
				if (_roundStartBingosLeft != bingosLeft)
				{
					//trace('handler_roundStartTimer bingosLeft:', bingosLeft);
					_roundStartBingosLeft = bingosLeft;
				}
			}
			else 
			{
				if (!_roundStartWait) {
					//trace('handler_roundStartTimer WAIT...');
					_roundStartWait = true;
				}
			}
		}	
		
		
		/*********************************************************************************************************************
		 *
		 * X2 powerup. time in milliseconds
		 * 
		 *********************************************************************************************************************/		
		 
		private var x2CardsTimings:Object = {}; 
		
		public function addX2Time(cardIndex:int, time:int):void
		{
			x2CardsTimings[cardIndex] = getTimer() + time;
		}
		
		public function getX2Multiplier(cardIndex:int):Number 
		{
			if (cardIndex in x2CardsTimings) 
				return (x2CardsTimings[cardIndex] - getTimer()) > 0 ? 2 : 1;
			
			return 1;
		}
		
		public function getX2Timeout(cardIndex:int):int
		{
			if (cardIndex in x2CardsTimings) 
				return x2CardsTimings[cardIndex] - getTimer();
			
			return 0;
		}
		
		public function getX2FinishTime(cardIndex:int):int
		{
			if (cardIndex in x2CardsTimings) 
				return x2CardsTimings[cardIndex];
			
			return 0;
		}
		
		public function isX2Active(cardIndex:int):Boolean
		{
			if (cardIndex in x2CardsTimings) 
				return x2CardsTimings[cardIndex] - getTimer() > 0;
			
			return false;
		}
		
		public function getCardIndexByID(id:int):int
		{
			for each (var item:Card in player.cards) 
			{
				if (item.cardId == id)
				{
					return player.cards.indexOf(item);
				}
			}
			
			return -1;
		}
		
		public function get isAnyX2Active():Boolean
		{
			var cardTimeout:int;
			for each(cardTimeout in x2CardsTimings) {
				if (cardTimeout - getTimer() > 0) 
					return true;
			}
			
			return false;
		}
		
		public function x2Clean(cardIndex:int = -1):void
		{
			if (cardIndex == -1) {
				x2CardsTimings = {}; 
				return;
			}
			
			if (cardIndex in x2CardsTimings) 
				delete x2CardsTimings[cardIndex];
		}
		
		public function hideConnectionWarning():void 
		{
			if (gameScreen && gameScreen.gameUI && gameScreen.gameUI.gameCardsView && gameScreen.gameUI.gameCardsView.connectionProblemIndicator)
			{
				gameScreen.gameUI.gameCardsView.connectionProblemIndicator.hide();
			}
			if (gameScreen && gameScreen.lobbyUI && gameScreen.lobbyUI.connectionProblemIndicator)
			{
				gameScreen.lobbyUI.connectionProblemIndicator.hide();
			}
		}
		
		private function showInGameConnectionWarning():void 
		{
			if (gameScreen.gameUI && gameScreen.gameUI.gameCardsView && gameScreen.gameUI.gameCardsView.connectionProblemIndicator)
			{
				gameScreen.gameUI.gameCardsView.connectionProblemIndicator.show();
			}
		}
		
		public function showConnectionWarning():void 
		{
			if (gameScreen)
			{
				if (gameScreen.state == GameScreen.STATE_IN_GAME)
				{
					showInGameConnectionWarning();
				}
				else
				{
					showLobbyConnectionWarning();
				}
			}
		}
		
		public function dropScores(scorePowerupsDropped:int, delay:Number = 0):void 
		{
			for (var i:int = 0; i < scorePowerupsDropped; i++) 
			{
				Starling.juggler.delayCall(gameScreen.gameUI.addPowerupToCards, delay + 0.05 * i, Powerup.SCORE, PowerupDropTweenStyle.STAKES);
			}
		}
		
		private function showLobbyConnectionWarning():void 
		{
			if (gameScreen && gameScreen.lobbyUI && gameScreen.lobbyUI.connectionProblemIndicator)
			{
				gameScreen.lobbyUI.connectionProblemIndicator.show();
			}
		}
	}
}