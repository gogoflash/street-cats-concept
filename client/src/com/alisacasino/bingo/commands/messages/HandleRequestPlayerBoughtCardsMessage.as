package com.alisacasino.bingo.commands.messages 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.protocol.PlayerBoughtCardsMessage;
	import com.alisacasino.bingo.utils.ConnectionManager;
	
	public class HandleRequestPlayerBoughtCardsMessage extends CommandBase
	{
		private var message:PlayerBoughtCardsMessage;
		
		public function HandleRequestPlayerBoughtCardsMessage(message:PlayerBoughtCardsMessage) 
		{
			this.message = message;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			//trace('BoughtCardsMessage');
			if (Room.current)
			{
				Room.current.updateFromRoomMessage(message.room);
			}
			Game.dispatchEventWith(ConnectionManager.PLAYER_BOUGHT_CARDS_EVENT, false, message);
			
			finish();
		}
		
	}

}