package com.alisacasino.bingo.commands.messages 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.protocol.LiveEventScoreUpdateOkMessage;
	import com.alisacasino.bingo.utils.ConnectionManager;
	
	public class HandleRequestLiveEventScoreUpdateOkMessage extends CommandBase
	{
		private var message:LiveEventScoreUpdateOkMessage;
		
		public function HandleRequestLiveEventScoreUpdateOkMessage(message:LiveEventScoreUpdateOkMessage) 
		{
			this.message = message;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			Game.connectionManager.scoreUpdateCompleted = true;
			
			Player.current.currentLiveEventScore = message.currentPosition.liveEventScore.toNumber();
			Player.current.currentLiveEventRank = message.currentPosition.liveEventRank;
			Game.dispatchEventWith(ConnectionManager.LIVE_EVENT_SCORE_UPDATE_OK_EVENT, false, message);
			
			finish();
		}
		
	}

}