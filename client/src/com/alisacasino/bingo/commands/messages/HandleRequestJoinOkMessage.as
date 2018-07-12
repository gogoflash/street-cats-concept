package com.alisacasino.bingo.commands.messages 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.models.roomClasses.RoomType;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.JoinOkMessage;
	
	public class HandleRequestJoinOkMessage extends CommandBase
	{
		private var message:JoinOkMessage;
		
		public function HandleRequestJoinOkMessage(message:JoinOkMessage) 
		{
			this.message = message;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			//trace("Game::handleJoinOkMessage");
			var roomType:RoomType = gameManager.roomsModel.getRoomByType(message.roomTypeName);
			if (roomType) 
			{
				Room.current = new Room(message.room);
				Room.current.roomType = roomType;
				
				Room.current.hasActiveEvent = message.hasLiveEventName;
				if (message.hasLiveEventName)
				{
					Room.current.activeEventName = message.liveEventName;
					Room.current.activeEvent = roomType.getEventByName(message.liveEventName);
				}
				
				Room.current.initBallsTimerFromJoinOk(Room.current.roundStartTime);
				
				Game.current.showGameScreen();
			}
			
			finish();
		}
		
	}

}