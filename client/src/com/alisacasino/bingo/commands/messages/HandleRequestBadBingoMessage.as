package com.alisacasino.bingo.commands.messages 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.protocol.BadBingoMessage;
	import com.alisacasino.bingo.utils.ConnectionManager;
	
	public class HandleRequestBadBingoMessage extends CommandBase
	{
		private var message:BadBingoMessage;
		
		public function HandleRequestBadBingoMessage(message:BadBingoMessage) 
		{
			this.message = message;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			Game.dispatchEventWith(ConnectionManager.BAD_BINGO_EVENT, false, message);
			
			finish();
		}
		
	}

}