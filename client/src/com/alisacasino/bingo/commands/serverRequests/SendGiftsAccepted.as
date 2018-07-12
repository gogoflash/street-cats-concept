package com.alisacasino.bingo.commands.serverRequests 
{
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.protocol.GiftsAcceptedMessage;
	import com.alisacasino.bingo.utils.ServerConnection;
	import com.netease.protobuf.Message;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class SendGiftsAccepted extends SendMessageToServerCommandBase
	{
		private var requestIDList:Array;
		
		public function SendGiftsAccepted(requestIDList:Array) 
		{
			this.requestIDList = requestIDList;
		}
		
		override protected function createMessage():Message 
		{
			var giftsAcceptedMessage:GiftsAcceptedMessage = new GiftsAcceptedMessage ();
			giftsAcceptedMessage.requestIds = requestIDList;
			return giftsAcceptedMessage;
		}
		
	}

}