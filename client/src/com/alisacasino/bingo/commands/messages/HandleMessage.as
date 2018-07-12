package com.alisacasino.bingo.commands.messages 
{
	import com.alisacasino.bingo.commands.ICommand;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.netease.protobuf.Message;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class HandleMessage extends CommandBase
	{
		private var message:Message;
		
		public function HandleMessage(message:Message) 
		{
			this.message = message;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			var concreteCommandToHandleMessage:ICommand = MessageRoutingTable.getHandlingCommand(message);
			if (concreteCommandToHandleMessage)
			{
				concreteCommandToHandleMessage.execute(onExecutionComplete, onExecutionFail);
			}
			else
			{
				//TODO: add warning for unhandled messages
				//fail();
				finish();
			}
		}
		
		private function onExecutionFail():void 
		{
			sosTrace( "HandleMessage.onExecutionFail", SOSLog.WARNING);
			//fail();
			finish();
		}
		
		private function onExecutionComplete():void 
		{
			finish();
		}
		
	}

}