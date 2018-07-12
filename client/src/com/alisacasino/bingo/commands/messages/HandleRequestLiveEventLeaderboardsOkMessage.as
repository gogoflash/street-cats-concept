package com.alisacasino.bingo.commands.messages 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.protocol.LiveEventLeaderboardsOkMessage;
	import com.alisacasino.bingo.utils.ConnectionManager;
	
	public class HandleRequestLiveEventLeaderboardsOkMessage extends CommandBase
	{
		private var message:LiveEventLeaderboardsOkMessage;
		
		public function HandleRequestLiveEventLeaderboardsOkMessage(message:LiveEventLeaderboardsOkMessage) 
		{
			this.message = message;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			Game.dispatchEventWith(ConnectionManager.LIVE_EVENT_LEADERBOARDS_OK_EVENT, false, message);
			
			finish();
		}
		
	}

}