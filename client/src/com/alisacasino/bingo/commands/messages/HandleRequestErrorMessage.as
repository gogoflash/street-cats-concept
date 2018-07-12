package com.alisacasino.bingo.commands.messages
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.controls.LoadingWheel;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.InfoDialog;
	import com.alisacasino.bingo.protocol.ErrorMessage;
	import com.alisacasino.bingo.protocol.ErrorMessage.ErrorCode;
	import com.alisacasino.bingo.utils.ConnectionManager;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.GameManager;
	
	public class HandleRequestErrorMessage extends CommandBase
	{
		private var message:ErrorMessage;
		
		public function HandleRequestErrorMessage(message:ErrorMessage)
		{
			this.message = message;
		}
		
		override protected function startExecution():void
		{
			super.startExecution();
			
			LoadingWheel.removeIfAny();
			
			if (message.code == ErrorCode.SignInError)
			{
				Game.dispatchEventWith(ConnectionManager.SIGN_IN_ERROR_EVENT, false, message.description);
				GameManager.instance.playerId = null;
				GameManager.instance.pwdHash = null;
			}
			else if (message.code == ErrorCode.ServerNotActive)
			{
				Game.current.loadGame();
			}
			else if (message.code == ErrorCode.OfferAlreadyClaimedError)
			{
				DialogsManager.addDialog(new InfoDialog(Constants.TITLE_CLAIMED, Constants.TEXT_CLAIMED, Constants.BTN_OK, false, false));
			}
			else if (message.code == ErrorCode.OfferExpiredError)
			{
				DialogsManager.addDialog(new InfoDialog(Constants.TITLE_EXPIRED, Constants.TEXT_EXPIRED, Constants.BTN_OK, false, false));
			}
			else if (message.code == ErrorCode.JoinError)
			{
				
			}
			
			finish();
		}
	
	}

}