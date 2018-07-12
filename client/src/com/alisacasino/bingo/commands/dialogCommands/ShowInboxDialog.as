package com.alisacasino.bingo.commands.dialogCommands 
{
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.platform.IFacebookManager;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.FriendsManager;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ShowInboxDialog extends CommandBase
	{
		static public const TYPE_ON_LOBBY_LOAD:String = "typeOnLobbyLoad";
		static public const TYPE_ON_GIFTS_RECEIVED:String = "typeOnGiftsReceived";
		static public const TYPE_ON_BUTTON_PRESS:String = "typeOnButtonPress";
		static public const TYPE_ON_NOTIFY:String = "TYPE_ON_NOTIFY";
		
		private var needToShowSendGifts:Boolean;
		private var needToShowInviteFriends:Boolean;
		private var forceShowInbox:Boolean;
		
		public function ShowInboxDialog(type:String) 
		{
			switch(type)
			{
				/*case TYPE_ON_LOBBY_LOAD:
					needToShowSendGifts = true;
					needToShowInviteFriends = true;
					break;
				case TYPE_ON_GIFTS_RECEIVED:
					needToShowSendGifts = true;
					break;*/
				case TYPE_ON_BUTTON_PRESS:
					//needToShowSendGifts = true;
					forceShowInbox = true;
					break;
				case TYPE_ON_NOTIFY:
					//needToShowSendGifts = true;
					forceShowInbox = true;
					break;
			}
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			if (forceShowInbox)
			{
				FriendsManager.instance.showInboxDialog(onInboxClose);
			}
			else
			{
				//var timeoutPassed:Boolean = gameManager.giftsModel.autoShowTimeoutPassed;
				var facebookIntegrationAvailable:Boolean = checkFacebookIntegrationState();
				var playerHasGifts:Boolean = gameManager.giftsModel.availableToAccept > 0;
				
				/*if (!timeoutPassed)
				{
					finish();
					return;
				}*/
				
				
				//Moved from inbox dialog show routine. This marks that the whole chain should only be shown once during the timeout period except for the cases when the dialog is requested explicitly.
				gameManager.giftsModel.registerInboxDialogShow();
				
				if (facebookIntegrationAvailable && playerHasGifts)
				{
					FriendsManager.instance.showInboxDialog(onInboxClose);
				}
				else
				{
					finish();
				}
			}
		}
		
		private function checkFacebookIntegrationState():Boolean
		{
			var facebookManager:IFacebookManager = PlatformServices.facebookManager;
			
			return Constants.isLocalBuild || 
				(facebookManager.isConnected && facebookManager.hasUserFriendsPermission);
		}
		
		private function onInboxClose():void 
		{
			showGiftSendDialog();
		}
		
		private function showGiftSendDialog():void 
		{
			if (needToShowSendGifts)
			{
				FriendsManager.instance.showSendGiftsDialog(showInviteFriends, false);
			}
			else
			{
				finish();
			}
		}
		
		private function showInviteFriends():void 
		{
			if (needToShowInviteFriends)
			{
				FriendsManager.instance.showInviteFriendsDialog(FriendsManager.DIALOG_MODE_GET_FREE_CASH, false, finish);
			}
			else 
			{
				finish();
			}
		}
		
	}

}