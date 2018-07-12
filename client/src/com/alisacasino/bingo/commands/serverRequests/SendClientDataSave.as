package com.alisacasino.bingo.commands.serverRequests 
{
	import com.alisacasino.bingo.protocol.SaveClientDataMessage;
	import com.netease.protobuf.Message;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class SendClientDataSave extends SendMessageToServerCommandBase
	{
		private var data:Object;
		
		public function SendClientDataSave(data:Object) 
		{
			this.data = data;
		}
		
		override protected function createMessage():Message 
		{
			var blob:ByteArray = new ByteArray();
			blob.writeObject(data);
			
			var saveClientDataMessage:SaveClientDataMessage = new SaveClientDataMessage();
			saveClientDataMessage.clientData = blob;
			return saveClientDataMessage;
		}
		
	}

}