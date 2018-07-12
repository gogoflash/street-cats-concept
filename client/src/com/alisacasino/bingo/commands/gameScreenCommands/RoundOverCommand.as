package com.alisacasino.bingo.commands.gameScreenCommands
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.controls.DaubHintAnimationSynchronizer;
	import com.alisacasino.bingo.controls.RoundOver;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.LiveEventScoreUpdateOkMessage;
	import com.alisacasino.bingo.protocol.RoundOverMessage;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.utils.ConnectionManager;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNARoundOverEvent;
	import com.alisacasino.bingo.utils.sharedObjects.SharedObjectManager;
	import starling.core.Starling;
	import starling.events.Event;
	
	public class RoundOverCommand extends CommandBase
	{
		private var gameScreen:GameScreen;
		private var roundOverMessage:RoundOverMessage;
		private var scoreUpdateOKMessage:LiveEventScoreUpdateOkMessage;
		private var xpEarned:int;
		
		private var debugMode:Boolean;
		private var levelRewards:Array;
		
		public function RoundOverCommand(gameScreen:GameScreen, roundOverMessage:RoundOverMessage, debugMode:Boolean = false)
		{
			this.gameScreen = gameScreen;
			this.roundOverMessage = roundOverMessage;
			this.debugMode = debugMode;
		}
		
		private function get player():Player
		{
			return Player.current;
		}
		
		override protected function startExecution():void
		{
			super.startExecution();
			
			if(!SharedObjectManager.instance.getSharedProperty(Constants.SHARED_PROPERTY_FIRST_START))
				SharedObjectManager.instance.setSharedProperty(Constants.SHARED_PROPERTY_FIRST_START, true);		
			
			if (!gameManager.tutorialManager.tutorialFirstLevelPassed) 
				gameManager.tournamentData.tutorialForceChangeTournamentData();
			
			gameManager.gameHintsManager.useDaubHint(player.cardsIdsHash);
			
			if (!player.isActivePlayer && !debugMode)
				return;
			
			Game.current.gameScreen.closeSideMenu();	
				
			player.gamesCount++;
			
			for each (var item:CommodityItemMessage in roundOverMessage.prizes)
			{
				if (item.type == Type.SCORE)
				{
					player.liveEventScoreEarned += item.quantity;
				}
				else if(item.type == Type.CASH)
				{
					player.cashEarnedFromRoundPrizes += item.quantity;
				}
			}
			
			//Applying modifiers
			
			var scoreEarned:Number = player.liveEventScoreEarned * gameManager.tournamentData.collectionEffects.scoreMod; //Score mod from trophies
			scoreEarned = scoreEarned * Room.current.getPointsBonusForCurrentCards(); //Score mod from stakes
			
			player.liveEventScoreEarned = Math.ceil(scoreEarned);
			
			player.xpEarned = Math.ceil(player.xpEarned * gameManager.tournamentData.collectionEffects.xpMod);
			
			gameManager.xpModifier.modifyPlayerXp();
			gameManager.tutorialManager.modifyPlayerXp();
			
			xpEarned = player.xpEarned;
			
			gameScreen.roundOverHandle();
			
			var earnedPowerups:Object = player.consumeEarned();
			levelRewards = player.consumeExp();
			
			DaubHintAnimationSynchronizer.clean();
			
			Game.addEventListener(ConnectionManager.LIVE_EVENT_SCORE_UPDATE_OK_EVENT, liveEventScoreUpdateOkEventHandler);
			
			//Starling.juggler.delayCall(Game.connectionManager.sendLiveEventScoreUpdateMessage, 11,  Player.current.liveEventScoreEarned, gameManager.tournamentData.currentTournamentID);
			Game.connectionManager.sendLiveEventScoreUpdateMessage(Player.current.liveEventScoreEarned, gameManager.tournamentData.currentTournamentID);
			
			SoundManager.instance.stopSfxLoop(SoundAsset.X2BoostFireLoop, 1);
			
			gameManager.questModel.roundEnd(Player.current.cards.length, Room.current.stakeData);
			
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNARoundOverEvent(player.gamesCount, player.bingosInARound, roundOverMessage.prizes, earnedPowerups, roundOverMessage.chestWin, Player.current.liveEventScoreEarned, roundOverMessage.room, Room.current.cellsDaubed, Room.current.cardsPlayed, xpEarned, Room.current.stakeData.multiplier, Room.current.getPointsBonusForCurrentCards()));
			
			if (player.bingosInARound > 0) {
				player.sequenceRoundWinsCount++;
				player.sequenceRoundLossCount = 0;
			}
			else {
				player.sequenceRoundLossCount++;
				player.sequenceRoundWinsCount = 0;
			}
			
			Starling.juggler.delayCall(showRoundOver, 1);//0.8);
			Starling.juggler.delayCall(showRoundResults, 2);//1.5);
			
			//setTimeout(showRoundOver, 1000);
			//setTimeout(showRoundResults, 2000);
			
			
		}
		
		private function showRoundOver():void
		{
			//new RoundOver().show();
			
			if (player.bingosInARound == 0)
				SoundManager.instance.playVoiceover('round_over');
			else if (player.bingosInARound == 1)
				SoundManager.instance.playVoiceover('great_game');
			else
				SoundManager.instance.playVoiceover('awesome_game');
		}
		
		private function showRoundResults():void
		{
			Game.current.gameScreen.closeSideMenu();

			Starling.juggler.delayCall(gameScreen.gameUI.forceFinishBingoAnimations, 0.33);
			
			finish();
		}
		
		private function liveEventScoreUpdateOkEventHandler(e:Event):void 
		{
			scoreUpdateOKMessage = e.data as LiveEventScoreUpdateOkMessage;
			Game.removeEventListener(ConnectionManager.LIVE_EVENT_SCORE_UPDATE_OK_EVENT, liveEventScoreUpdateOkEventHandler);
		}
	
	}

}