package com.alisacasino.bingo.commands.messages 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.protocol.BallMessage;
	import com.alisacasino.bingo.utils.ConnectionManager;
	import com.alisacasino.bingo.utils.TimeService;
	import flash.utils.getTimer;
	
	public class HandleBallMessage extends CommandBase
	{
		private var message:BallMessage;
		
		public function HandleBallMessage(message:BallMessage) 
		{
			this.message = message;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			if (Player.IS_DEBUG_ROUND || !gameManager.tutorialManager.tutorialFirstLevelPassed || !gameManager.tutorialManager.tutorialLevelsPassed)
				return;
				
			if (Player.current && Player.current.isActivePlayer) {
				// XXX: ever possible to receive ball message when room.current==null ?
				if (Room.current != null)
				{
					Room.current.numbers.push(message.number);
				}
				
				Game.dispatchEventWith(ConnectionManager.BALL_EVENT, false, message);
			}
			
			gameManager.watchdogs.connectionWatchdog.reportBall();
			
			finish();
		}
		
	}

}