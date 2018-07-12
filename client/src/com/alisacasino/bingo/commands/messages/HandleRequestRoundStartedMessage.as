package com.alisacasino.bingo.commands.messages 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.protocol.RoundStartedMessage;
	import com.alisacasino.bingo.utils.ConnectionManager;
	import flash.utils.getTimer;
	
	public class HandleRequestRoundStartedMessage extends CommandBase
	{
		private var message:RoundStartedMessage;
		
		public function HandleRequestRoundStartedMessage(message:RoundStartedMessage) 
		{
			this.message = message;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
		
			Room.current.startBallsTimer();
			
			if (Player.IS_DEBUG_ROUND || !gameManager.tutorialManager.tutorialFirstLevelPassed || !gameManager.tutorialManager.tutorialLevelsPassed)
				return;
			
			if (!Room.current || !Player.current)    
				return;
				
			if (Player.current.cards.length > 0)
			{
				Player.current.isActivePlayer = true;
				gameManager.watchdogs.connectionWatchdog.startBallTimer();
			}
			
			//trace('RoundStartedMessage', message.hasRoundId, getTimer());
			
			if (message.hasRoundId)
			{
				Room.current.roundID = message.roundId.toString();
			}
			
			Room.current.numbers = [];
			Room.current.bingoHistory = [];
			Room.current.updateFromRoomMessage(message.room);
			Player.current.clearBadBingoFinishTimes(Room.current.roomType.roomTypeName);
			Game.dispatchEventWith(ConnectionManager.ROUND_STARTED_EVENT, false, message);
			
			finish();
		}
		
	}

}