package com.alisacasino.bingo.commands.messages
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.HelloMessage;
	import com.alisacasino.bingo.protocol.SignInMessage;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.ServerConnection;
	import com.netease.protobuf.UInt64;
	
	public class HandleRequestHelloMessage extends CommandBase
	{
		private var message:HelloMessage;
		
		public function HandleRequestHelloMessage(message:HelloMessage)
		{
			this.message = message;
		}
		
		override protected function startExecution():void
		{
			super.startExecution();
			
			if (Game.connectionManager.helloReceived)
			{
				return;
			}
			else
			{
				Game.connectionManager.helloReceived = true;
			}
			
			PlatformServices.interceptor.activatePushwoosh();
			
			gameManager.analyticsManager.resetDDNASessionID();
			
			var signInMessage:SignInMessage = new SignInMessage();
			
			signInMessage.sessionId = gameManager.analyticsManager.ddnaSessionUUID;
			
			gameManager.canBeFirstSession = true;
			
			if (PlatformServices.isMobile)
			{
				var playerId:UInt64 = GameManager.instance.playerId;
				var pwdHash:String = GameManager.instance.pwdHash;
				
				if (pwdHash != null)
				{
					signInMessage.pwdHash = pwdHash;
					if (playerId != null)
					{
						gameManager.canBeFirstSession = false;
						signInMessage.playerId = playerId;
					}
				}
			}
			
			if (PlatformServices.facebookManager.isConnected)
			{
				if (!PlatformServices.isCanvas)
				{
					gameManager.canBeFirstSession = false;
				}
				signInMessage.facebookIdString = PlatformServices.facebookManager.facebookId;
				signInMessage.accessToken = PlatformServices.facebookManager.accessToken;
			}
			else if (pwdHash == null)
			{
				signInMessage.pwdHash = GameManager.instance.createNewPwdHash();
			}
			
			if (Constants.keepLocalUser)
			{
				
			}
			
			signInMessage.platform = PlatformServices.platform;
			signInMessage.deviceId = PlatformServices.interceptor.deviceId;
			
			ServerConnection.current.sendMessage(signInMessage);
			
			finish();
		}
	
	}

}