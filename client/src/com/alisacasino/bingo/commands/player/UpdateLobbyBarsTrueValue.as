package com.alisacasino.bingo.commands.player 
{
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.models.Player;
	
	public class UpdateLobbyBarsTrueValue extends CommandBase
	{
		public var delay:Number = 0;
		
		public function UpdateLobbyBarsTrueValue(delay:Number = 0) 
		{
			this.delay = delay;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			if (Player.current && Player.current.reservedCashCount != 0) {
				Player.current.cleanReservedCashCount(delay);
				delay += 0.65;	
			}
			
			if (Player.current && Player.current.reservedDustCount != 0) {
				Player.current.cleanReservedDustCount(delay);
				delay += 0.65;	
			}
			
			gameManager.powerupModel.cleanReservedPowerupsCount(delay);
			
			gameManager.questModel.cleanReservedProgress(delay);
			
			finish();
		}
	}

}