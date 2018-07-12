package com.alisacasino.bingo.commands.messages 
{
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.protocol.RoundStateMessage;
	import com.alisacasino.bingo.protocol.RoundStateType;
	import com.alisacasino.bingo.utils.StringUtils;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class HandleRoundStateMessage extends CommandBase
	{
		private var roundStateMessage:RoundStateMessage;
		
		public function HandleRoundStateMessage(roundStateMessage:RoundStateMessage) 
		{
			this.roundStateMessage = roundStateMessage;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			//trace('HandleRoundStateMessage', roundStateTypeString , roundStateMessage.roundStartsAt.toNumber(), StringUtils.unixTimeToString(int(roundStateMessage.roundStartsAt.toNumber()/1000)));
			if(Room.current)
				Room.current.roundStartTime = roundStateMessage.roundStartsAt.toNumber();
		}
		
		private function get roundStateTypeString():String {
			if (!roundStateMessage)
				return 'null';
				
			switch(roundStateMessage.roundStateType) {
				case RoundStateType.STARTED: return 'STARTED';
				case RoundStateType.ENDED: return 'ENDED';
				case RoundStateType.COUNTDOWN: return 'COUNTDOWN';
			}
			
			return 'null';
		}
	}

}