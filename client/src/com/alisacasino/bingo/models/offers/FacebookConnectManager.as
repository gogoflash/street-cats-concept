package com.alisacasino.bingo.models.offers 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.dialogs.ClaimBonusDialog;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.ClaimOfferOkMessage;
	import com.alisacasino.bingo.utils.Constants;
	
	public class FacebookConnectManager 
	{
		public function FacebookConnectManager() 
		{
			
		}
		
		private var KEY_CONNECT_FACEBOOK_BONUS:String = 'KEY_CONNECT_FACEBOOK_BONUS';
		
		private var claimedFacebookBonusIds:Array;
		
		public function handleConnectFacebookBonus():void
		{
			if (PlatformServices.isMobile && PlatformServices.facebookManager.isConnected)
			{
				claimedFacebookBonusIds = gameManager.clientDataManager.getValue(KEY_CONNECT_FACEBOOK_BONUS, []);
				
				if (claimedFacebookBonusIds.indexOf(Player.current.facebookId) == -1) {
					var claimOfferOkMessage:ClaimOfferOkMessage = new ClaimOfferOkMessage();
					claimOfferOkMessage.offerType = 'coins';
					claimOfferOkMessage.offerValue = Constants.CONNECT_FACEBOOK_BONUS_CASH;
					
					DialogsManager.addDialog(new ClaimBonusDialog(ClaimBonusDialog.TYPE_FACEBOOK_BONUS, claimOfferOkMessage, null));
				}
			}
		}
		
		public function сlaimConnectFacebookBonus():void
		{
			if (!claimedFacebookBonusIds || claimedFacebookBonusIds.indexOf(Player.current.facebookId) != -1) 
				return;
			
			claimedFacebookBonusIds.push(Player.current.facebookId);
			gameManager.clientDataManager.setValue(KEY_CONNECT_FACEBOOK_BONUS, claimedFacebookBonusIds);
			
			Player.current.updateCashCount(Constants.CONNECT_FACEBOOK_BONUS_CASH, "facebookConnect");
			Game.connectionManager.sendPlayerUpdateMessage();
		}
	}

}
