package com.alisacasino.bingo.commands.messages 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.protocol.BingoOkMessage;
	import com.alisacasino.bingo.utils.ConnectionManager;
	
	public class HandleRequestBingoOkMessage extends CommandBase
	{
		private var message:BingoOkMessage;
		
		public function HandleRequestBingoOkMessage(message:BingoOkMessage) 
		{
			this.message = message;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			Game.dispatchEventWith(ConnectionManager.BINGO_OK_EVENT, false, message);
			
			finish();
		}
		
	}

}