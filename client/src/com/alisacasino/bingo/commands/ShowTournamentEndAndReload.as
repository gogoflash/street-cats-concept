package com.alisacasino.bingo.commands 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.serverRequests.SendEventPrizeClaim;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.tournamentResultDialogClasses.TournamentResultDialog;
	import com.alisacasino.bingo.models.Player;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ShowTournamentEndAndReload extends CommandBase
	{
		public function ShowTournamentEndAndReload() 
		{
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			if (gameManager.tournamentData.tournamentResultToShow)
			{
				DialogsManager.addDialog(new TournamentResultDialog(gameManager.tournamentData.tournamentResultToShow, onPrizesGivenOut));
			}
			else
			{
				onPrizesGivenOut();
			}
		}
		
		private function onPrizesGivenOut():void 
		{
			if (gameManager.tournamentData.pendingTournamentChange)
			{
				Player.current.refundAndClearCards();
				gameManager.tournamentData.setDataToPending();
				gameManager.tutorialManager.clearOnTournamentChange();
				Game.current.showGameScreen();
			}
			finish();
		}
		
	}

}