package com.alisacasino.bingo.commands.messages 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.player.UpdateLobbyBarsTrueValue;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.models.FacebookIdAndTimestamp;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.RateDialogManager;
	import com.alisacasino.bingo.platform.IFacebookManager;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.GiftedPlayerMessage;
	import com.alisacasino.bingo.protocol.InvitedPlayerMessage;
import com.alisacasino.bingo.protocol.PlayerMessage;
import com.alisacasino.bingo.protocol.SignInOkMessage;
import com.alisacasino.bingo.protocol.StaticDataMessage;
import com.alisacasino.bingo.screens.GameScreen;
import com.alisacasino.bingo.utils.ConnectionManager;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.DevUtils;
	import com.alisacasino.bingo.utils.FacebookData;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.TimeService;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAClientDeviceEvent;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNANewPlayerEvent;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNANotificationServicesEvent;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAStartGameEvent;
	import org.as3commons.collections.Set;
	
	public class HandleSignInOkMessage extends CommandBase
	{
		private var message:SignInOkMessage;
		private var mGameManager:GameManager = GameManager.instance;
		private var mFacebookManager:IFacebookManager = PlatformServices.facebookManager;
		
		public function HandleSignInOkMessage(message:SignInOkMessage) 
		{
			this.message = message;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			gameManager.connectionManager.resetPlayerUpdateIndex();
			gameManager.clientDataManager.deserialize(message.clientData);
			gameManager.lastSignInTime = TimeService.serverTime;
			
			if(message.hasIsRefunded){
				Game.connectionManager.mShallShowRefundDialog = message.isRefunded;
			}
			if (PlatformServices.isMobile) {
				// first time login as a guest -> we save playerId/pwdHash
				if (mGameManager.playerId == null && mGameManager.pwdHash != null && !mFacebookManager.isConnected) {
					mGameManager.playerId = message.player.playerId;
				}
					// was a guest, became a Facebook user w/ the same playerId -> remove guest data
				else if (mGameManager.playerId != null && 
					mGameManager.playerId.toNumber() == message.player.playerId.toNumber() && 
					mGameManager.pwdHash != null && mFacebookManager.isConnected) {
					mGameManager.playerId = null;
					mGameManager.pwdHash = null;
				}
			}
			if (mFacebookManager.isConnected) 
			{
				FacebookData.instance.parseSignInMessage(message);
				GameManager.instance.giftsModel.parseSignInMessage(message); 
			}
			
			gameManager.gameData.deserializeStaticData(message.staticData);
			
			
			Player.current = new Player(message.player);
			
			gameManager.connectionManager.cancelPlayerUpdate(); // No need to save player right away
			
			gameManager.collectionsData.deserializeStaticData(message.staticData);
			gameManager.collectionsData.deserializePlayerInventory(message.player.items);
			
			gameManager.skinningData.deserializeStaticData(message.staticData);
			gameManager.skinningData.deserializePlayerCustomizers(message.player.customizationSettings);
			
			gameManager.tournamentData.deserialize(message);
			
			gameManager.offerManager.deserializeStaticData(message.staticData);
			gameManager.questModel.deserializeStaticData(message.staticData);
			gameManager.slotsModel.deserializeStaticData(message.staticData);
			gameManager.slotsModel.deserializeBonusSpins(message.player.account);
			
			gameManager.customOfferManager.deserializeStaticData(message.staticData);
			gameManager.customOfferManager.triggerCriticalResourceValues();
			
			gameManager.powerupModel.deserializeStaticData(message.staticData);
			gameManager.powerupModel.deserializePlayerPowerups(message.player.account);
			
			
			gameManager.gameHintsManager.deserializeStaticData(message.staticData);
			
			gameManager.periodicBonusManager.deserializeStaticData(message.staticData);
			gameManager.periodicBonusManager.updateTakeTime(message.player);
			
			gameManager.chestsData.deserializePrizeData(message.staticData.chestDrop);
			gameManager.chestsData.deserialize(message.player);
			gameManager.scratchCardModel.deserializeConfig(message.staticData.scratchLotteries, message.staticData.scratchMinCashPlay);
			gameManager.scratchCardModel.deserializeBonusScratches(message.player.account);
			
			gameManager.tutorialManager.handleSignInOkMessage(message);
			
			gameManager.xpModifier.deserializeStaticData(message.staticData);
			
			gameManager.facebookConnectManager.handleConnectFacebookBonus();
		
			RateDialogManager.instance.deserializeStaticData(message.staticData);
			
			gameManager.firstSession = false;
			if (!(
				Player.current.lifetime > 0 || 
				Player.current.xpCount > 0 || 
				Player.current.daubsCount > 0
				))
			{
				if (gameManager.canBeFirstSession && gameManager.clientDataManager.getValue("firstSessionMarked", false) != true)
				{
					gameManager.clientDataManager.setValue("firstSessionMarked", true)
					gameManager.firstSession = true;
				}
			}
			
			
			if (gameManager.firstSession && Player.current.cashCount == 200) 
			{
				Player.current.updateCashCount(0, "debug");
				Game.connectionManager.sendPlayerUpdateMessage();	
				new UpdateLobbyBarsTrueValue().execute();
			}
			
			
			Game.connectionManager.hasJoinMessageEverSent = false;
			
			PlatformServices.store.init();
			
			Game.connectionManager.startTimer();
			
			PlatformServices.interceptor.registerForPushNotifications();
			PlatformServices.interceptor.trackOpen();
			
			SoundManager.instance.resume();
			
			if (Constants.isDevFeaturesEnabled)
			{
				new DevUtils(Game.current).runChecks();
				//new DevUtils(Game.current).listRoomsAndItems();
			}
			
			Game.dispatchEventWith(ConnectionManager.SIGN_IN_COMPLETE_EVENT);
			
			gameManager.offerManager.init();
			gameManager.questModel.init();
			
			if (message.isFirstSignin)
			{
				gameManager.analyticsManager.sendDeltaDNAEvent(new DDNANewPlayerEvent());
			}
			
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStartGameEvent());
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAClientDeviceEvent());
			
			if (PlatformServices.interceptor.pushToken)
			{
				gameManager.analyticsManager.sendDeltaDNAEvent(new DDNANotificationServicesEvent(PlatformServices.interceptor.pushToken));
			}
			
			
			if(gameManager.trackingData)
				gameManager.analyticsManager.sendInstallConversationData(gameManager.trackingData);
				
			finish();
		}
		
	}

}