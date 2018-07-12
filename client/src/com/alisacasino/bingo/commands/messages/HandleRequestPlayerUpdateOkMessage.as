package com.alisacasino.bingo.commands.messages 
{
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.protocol.PlayerUpdateOkMessage;
	
	public class HandleRequestPlayerUpdateOkMessage extends CommandBase
	{
		private var message:PlayerUpdateOkMessage;
		
		public function HandleRequestPlayerUpdateOkMessage(message:PlayerUpdateOkMessage) 
		{
			this.message = message;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			// no handle in old bingo handler
			
			finish();
		}
		
	}

}