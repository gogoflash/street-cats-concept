package com.alisacasino.bingo.commands.messages 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.TutorialManager;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.protocol.PlayerBingoedMessage;
	import com.alisacasino.bingo.utils.ConnectionManager;
	
	public class HandleRequestPlayerBingoedMessage extends CommandBase
	{
		private var message:PlayerBingoedMessage;
		
		public function HandleRequestPlayerBingoedMessage(message:PlayerBingoedMessage) 
		{
			this.message = message;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			if (Player.IS_DEBUG_ROUND || !gameManager.tutorialManager.tutorialFirstLevelPassed || !gameManager.tutorialManager.tutorialLevelsPassed) {
				TutorialManager.fillPlayerBingoedMessagePool(message);
				return;
			}
			//trace('PlayerBingoedMessage');		
			if(Room.current)
				Room.current.updateFromRoomMessage(message.room);
			
			Game.dispatchEventWith(ConnectionManager.PLAYER_BINGOED_EVENT, false, message);
			
			finish();
		}
		
	}

}