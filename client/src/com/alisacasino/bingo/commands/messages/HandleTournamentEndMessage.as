package com.alisacasino.bingo.commands.messages 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.ShowTournamentEndAndReload;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.protocol.TournamentEndMessage;
	import com.alisacasino.bingo.screens.GameScreen;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class HandleTournamentEndMessage extends CommandBase
	{
		private var tournamentEndMessage:TournamentEndMessage;
		
		public function HandleTournamentEndMessage(tournamentEndMessage:TournamentEndMessage) 
		{
			this.tournamentEndMessage = tournamentEndMessage;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			gameManager.tournamentData.tournamentResultToShow = tournamentEndMessage.tournamentResult;
			gameManager.tournamentData.setPendingData(tournamentEndMessage.tournamentInfo, tournamentEndMessage.collectionInfo);
			
			gameManager.questModel.dropDailyQuestPassedCount();
			//gameManager.eventPrizeModel.storeEventPrizes(tournamentEndMessage.eventPrizes);
			
			if (Game.current.currentScreen is GameScreen)
			{
				if (Game.current.gameScreen.state == GameScreen.STATE_IN_GAME || !gameManager.tutorialManager.tutorialFirstLevelPassed)
				{
					finish();
					return;
				}
				
				new ShowTournamentEndAndReload().execute();
			}
			finish();
		}
		
	}

}