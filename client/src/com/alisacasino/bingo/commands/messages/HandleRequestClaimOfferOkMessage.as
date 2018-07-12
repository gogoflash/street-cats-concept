package com.alisacasino.bingo.commands.messages 
{
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.controls.LoadingWheel;
	import com.alisacasino.bingo.protocol.ClaimOfferOkMessage;
	import com.alisacasino.bingo.utils.FriendsManager;
	
	public class HandleRequestClaimOfferOkMessage extends CommandBase
	{
		private var message:ClaimOfferOkMessage;
		
		public function HandleRequestClaimOfferOkMessage(message:ClaimOfferOkMessage) 
		{
			this.message = message;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			gameManager.freebiesManager.parseClaimOfferOk(message);
			finish();
		}
		
	}

}