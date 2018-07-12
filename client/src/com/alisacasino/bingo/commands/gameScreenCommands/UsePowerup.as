package com.alisacasino.bingo.commands.gameScreenCommands 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.screens.GameScreen;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class UsePowerup extends CommandBase
	{
		private var powerup:String;
		
		public function UsePowerup(powerup:String) 
		{
			this.powerup = powerup;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			var gameScreen:GameScreen = Game.current.currentScreen as GameScreen;
			if (!gameScreen)
			{
				sosTrace("No game screen to use powerup!", SOSLog.ERROR);
				fail();
			}
			
			var powerUpCountDecrement:int = (gameManager.powerupModel.getPowerupCount(powerup) > 0 && gameManager.tutorialManager.allTutorialLevelsPassed) ?  -1 : 0;
			
			Player.current.powerupsUsedCount++;
			Player.current.powerupsUsedInRound++;
			gameManager.powerupModel.addPowerup(powerup, powerUpCountDecrement, "roundUse");
			gameManager.questModel.powerupUsed(powerup);
			gameScreen.gameScreenController.usePowerup(powerup);
			Game.connectionManager.sendPlayerUpdateMessage();
		}
		
	}

}