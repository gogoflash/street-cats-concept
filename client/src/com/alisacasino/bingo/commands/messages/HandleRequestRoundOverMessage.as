package com.alisacasino.bingo.commands.messages 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.protocol.RoundOverMessage;
	import com.alisacasino.bingo.utils.ConnectionManager;
	
	public class HandleRequestRoundOverMessage extends CommandBase
	{
		private var message:RoundOverMessage;
		
		public function HandleRequestRoundOverMessage(message:RoundOverMessage) 
		{
			this.message = message;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			if (Player.IS_DEBUG_ROUND || !gameManager.tutorialManager.tutorialFirstLevelPassed || !gameManager.tutorialManager.tutorialLevelsPassed)
				return;
			
			if (!Room.current || !Player.current)	
				return;
			//trace('RoundOverMessage', message.hasRoundId);	
			Room.current.updateFromRoomMessage(message.room, true);
			
			Game.dispatchEventWith(ConnectionManager.ROUND_OVER_EVENT, false, message);
			
			if (Player.current.isActivePlayer) {
				Player.current.isActivePlayer = false;
				Player.current.clearCards();
				Room.current.numbers = [];
			}
			
			gameManager.watchdogs.connectionWatchdog.stopBallTimer();
			
			finish();
		}
		
	}

}