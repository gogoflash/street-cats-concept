package com.alisacasino.bingo.commands.messages 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.protocol.LeaveOkMessage;
	import com.alisacasino.bingo.utils.ConnectionManager;
	
	public class HandleRequestLeaveOkMessage extends CommandBase
	{
		private var message:LeaveOkMessage;
		
		public function HandleRequestLeaveOkMessage(message:LeaveOkMessage) 
		{
			this.message = message;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			sosTrace("Game::handleLeaveOkMessage");
			//Room.current = null;
			if (message.hasPlayer) {
				Player.current.deserialize(message.player);
			}
			Game.dispatchEventWith(ConnectionManager.LEAVE_OK_EVENT, false, message);
			
			finish();
		}
		
	}

}