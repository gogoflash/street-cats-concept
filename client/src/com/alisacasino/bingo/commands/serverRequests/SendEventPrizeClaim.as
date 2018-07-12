package com.alisacasino.bingo.commands.serverRequests 
{
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.protocol.ClaimEventPrizeMessage;
	import com.alisacasino.bingo.utils.ServerConnection;
	import com.netease.protobuf.Message;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class SendEventPrizeClaim extends SendMessageToServerCommandBase
	{
		private var eventId:uint;
		
		public function SendEventPrizeClaim(eventId:uint) 
		{
			this.eventId = eventId;
		}
		
		override protected function createMessage():Message 
		{
			var message:ClaimEventPrizeMessage = new ClaimEventPrizeMessage();
			message.eventId = [eventId];
			
			return message;
		}
		
	}

}