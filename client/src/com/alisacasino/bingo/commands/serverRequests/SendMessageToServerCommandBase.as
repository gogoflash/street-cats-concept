package com.alisacasino.bingo.commands.serverRequests 
{
	import avmplus.getQualifiedClassName;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.utils.ServerConnection;
	import com.netease.protobuf.Message;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	internal class SendMessageToServerCommandBase extends CommandBase
	{
		
		public function SendMessageToServerCommandBase() 
		{
			
		}
		
		protected function createMessage():Message
		{
			return null;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			if (ServerConnection.current)
			{
				sendToServer(createMessage());
			}
			else 
			{
				sosTrace("Connection lost", SOSLog.ERROR);
			}
			
			
			finish();
		}
		
		protected function sendToServer(message:Message):void 
		{
			if (!message)
			{
				sosTrace(getQualifiedClassName(this) +  " trying to send null message : " + message, SOSLog.ERROR);
				return;
			}
			ServerConnection.current.sendMessage(message);
		}
		
	}

}