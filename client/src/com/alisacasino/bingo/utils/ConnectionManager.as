package com.alisacasino.bingo.utils
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.dialogCommands.ShowNoConnectionDialog;
	import com.alisacasino.bingo.commands.messages.HandleMessage;
	import com.alisacasino.bingo.dialogs.BaseDialog;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.ReconnectDialog;
	import com.alisacasino.bingo.logging.SystemInfo;
	import com.alisacasino.bingo.models.Card;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.platform.IFacebookManager;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.platform.mobile.FacebookDialogResponse;
	import com.alisacasino.bingo.protocol.BaseMessage;
	import com.alisacasino.bingo.protocol.BingoMessage;
	import com.alisacasino.bingo.protocol.BuyCardsMessage;
	import com.alisacasino.bingo.protocol.ClaimOfferV2Message;
	import com.alisacasino.bingo.protocol.ClientMessage;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.GiftAcceptedMessage;
	import com.alisacasino.bingo.protocol.GiftMessage;
	import com.alisacasino.bingo.protocol.GiftedPlayerMessage;
	import com.alisacasino.bingo.protocol.InviteMessage;
	import com.alisacasino.bingo.protocol.InvitedPlayerMessage;
	import com.alisacasino.bingo.protocol.ItemType;
	import com.alisacasino.bingo.protocol.JoinMessage;
	import com.alisacasino.bingo.protocol.LeaveMessage;
	import com.alisacasino.bingo.protocol.LiveEventInfoMessage;
	import com.alisacasino.bingo.protocol.LiveEventLeaderboardsMessage;
	import com.alisacasino.bingo.protocol.LiveEventScoreUpdateMessage;
	import com.alisacasino.bingo.protocol.OfferAcceptedMessage;
	import com.alisacasino.bingo.protocol.PlayerCustomizationSettingsMessage;
	import com.alisacasino.bingo.protocol.PlayerMessage;
	import com.alisacasino.bingo.protocol.PlayerUpdateMessage;
	import com.alisacasino.bingo.protocol.PurchaseMessage;
	import com.alisacasino.bingo.protocol.RequestIncomingItemsMessage;
	import com.alisacasino.bingo.protocol.RequestServerStatusMessage;
	import com.alisacasino.bingo.protocol.RoomPattern;
	import com.alisacasino.bingo.protocol.SaveClientDataMessage;
	import com.alisacasino.bingo.protocol.ServerStatusMessage;
	import com.alisacasino.bingo.protocol.SignInMessage.Platform;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.screens.LoadingScreen;
	import com.alisacasino.bingo.store.IStoreItem;
	import com.alisacasino.bingo.store.StoreEvent;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAReconnectShownEvent;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAStoreTransactionStateEvent;
	import com.netease.protobuf.FieldDescriptor;
	import com.netease.protobuf.Message;
	import com.netease.protobuf.UInt64;
	import flash.events.TimerEvent;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	import starling.core.Starling;
	import starling.events.Event;
	
	public class ConnectionManager
	{
		public static var LOGGING_ENABLED:Boolean = true;
		
		public static const BUY_CARDS_OK_EVENT:String = "BuyCardsOkEvent";
		public static const PLAYER_BOUGHT_CARDS_EVENT:String = "PlayerBoughtCardsEvent";
		public static const ROUND_STARTED_EVENT:String = "RoundStartedEvent";
		public static const ROUND_OVER_EVENT:String = "RoundOverEvent";
		public static const BINGO_OK_EVENT:String = "BingoOkEvent";
		public static const BAD_BINGO_EVENT:String = "BadBingoEvent";
		public static const PLAYER_BINGOED_EVENT:String = "PlayerBingoedEvent";
		
		public static const BALL_EVENT:String = "BallEvent";
		public static const LEAVE_OK_EVENT:String = "LeaveOkEvent";
		
		public static const LIVE_EVENT_INFO_OK_EVENT:String = "LiveEventInfoOkEvent";
		public static const LIVE_EVENT_LEADERBOARDS_OK_EVENT:String = "LiveEventLeaderboardsOkEvent";
		public static const LIVE_EVENT_SCORE_UPDATE_OK_EVENT:String = "LiveEventScoreUpdateOkEvent";
		
		public static const MESSAGE_RECEIVED_EVENT:String = "MessageReceivedEvent";
		public static const CONNECTION_ERROR_EVENT:String = "ConnectionErrorEvent";
		public static const CONNECTION_CLOSED_EVENT:String = "ConnectionClosedEvent";
		public static const CONNECTION_ESTABLISHED_EVENT:String = "ConnectionEstablishedEvent";
		
		public static const EVENT_CONNECTION_RESTORED:String = "EVENT_CONNECTION_RESTORED";
		
		public static const SIGN_IN_COMPLETE_EVENT:String = "SignInCompleteEvent";
		public static const SIGN_IN_ERROR_EVENT:String = "SignInErrorEvent";
		
		public var helloReceived:Boolean;
		public var mShallShowRefundDialog:Boolean = false;
		public var hasJoinMessageEverSent:Boolean;
		public var scoreUpdateCompleted:Boolean = true;
		
		private var mCurrentServerTime:Number;
		
		private var mSignInTime:Number;
		private var mTimer:Timer;
		private var mLastClientMessageTimestamp:Number;
		private var game:Game;
		
		private var sendLogsCounter:int;
		
		public function ConnectionManager(game:Game)
		{
			this.game = game;
			//sosTrace( "Game.Game", SOSLog.DEBUG);
			
			//addEventListener(Game.MESSAGE_RECEIVED_EVENT, onMessageReceived);
			
			Game.addEventListener(CONNECTION_CLOSED_EVENT, onClosedConnection);
			
			Game.addEventListener(StoreEvent.PURCHASE_COMPLETED, onPurchaseCompleted);
		}
		
		/**
		 * Server time in milliseconds like 15000, 
		 */
		public function get currentServerTime():Number
		{
			return mCurrentServerTime;
		}
				
		public function get signInTime():Number
		{
			return mSignInTime;
		}
		
		private const messageParsingPriority:Array = ["signInOkMessage", "joinOkMessage"];
		private var delayedUpdateCallID:int = -1;
		private var delayedClientDataSaveCallID:int = -1;
		private var playerUpdateIndex:uint;
		
		public function parseMessage(baseMessage:BaseMessage):void
		{
			if (!ServerConnection.current)
				return;
			
			var fields:Dictionary = ServerConnection.current.getBaseMessageFields();
			
			for (var i:int = 0; i < messageParsingPriority.length; i++)
			{
				handleMessage(baseMessage[messageParsingPriority[i]] as Message);
			}
			
			for each (var item:FieldDescriptor in fields)
			{
				if (messageParsingPriority.indexOf(item.name) != -1)
					continue;
				
				handleMessage(baseMessage[item.name] as Message);
			}
			
			if (baseMessage.hasSentByServerTimestamp)
			{
				var newTimestamp:Number = baseMessage.sentByServerTimestamp.toNumber();
				if (isNaN(mCurrentServerTime) || newTimestamp > mCurrentServerTime)
				{
					mCurrentServerTime = newTimestamp;
				}
				if (baseMessage.hasSignInOkMessage)
					mSignInTime = mCurrentServerTime;
			}
		}
		
		public var sessionId:String;
		
		//public var playerId:String;
		
		public var gameId:int;
		
		
		
		public function parseMessageNew(raw:Object):void 
		{
			if (raw.name == "signInResponse")
			{
				Player.current = new Player(null);
				Player.current.mPlayerId = UInt64.fromNumber(raw.payload.playerId);
				
				Player.current.xpCount = 1;
				
				Room.current = new Room(null);
				
				sessionId = raw.payload.sessionId;
				
				Game.dispatchEventWith(ConnectionManager.SIGN_IN_COMPLETE_EVENT);
				
				var mGameManager:GameManager = GameManager.instance;
				var mFacebookManager:IFacebookManager = PlatformServices.facebookManager;
				if (PlatformServices.isMobile) {
				// first time login as a guest -> we save playerId/pwdHash
				if (mGameManager.playerId == null && mGameManager.pwdHash != null && !mFacebookManager.isConnected) {
						mGameManager.playerId = Player.current.mPlayerId;
					}
						// was a guest, became a Facebook user w/ the same playerId -> remove guest data
					else if (mGameManager.playerId != null && 
						mGameManager.playerId.toNumber() == raw.player.playerId.toNumber() && 
						mGameManager.pwdHash != null && mFacebookManager.isConnected) {
						mGameManager.playerId = null;
						mGameManager.pwdHash = null;
					}
				}
				
				//1 + 1
				//sendJoin();
			}
			
			
			if (raw.name == "joinGameResponse")
			{
				gameId = raw.payload.gameId;
				
				gameManager.pvpUserReady = true;
				if (Game.current && Game.current.gameScreen && Game.current.gameScreen.lobbyUI) {
					Game.current.gameScreen.lobbyUI.showReadyForPvP();
				}
				
				//{"id":0,"name":"joinGameResponse","payload":{"gameId":2},"timeMillis":1532099385399,"clientLocalAddr":null}
			}
			
			if (raw.name == "roundResponse")
			{
				// сеттим котов врага
				var rawCats:Object;
				
				gameManager.catsModel.deserializeCats(raw.payload.firstPlayerInfo, null);
				gameManager.catsModel.deserializeCats(raw.payload.secondPlayerInfo, null);
				
				
				/*for each(rawCats in raw.payload) {
					gameManager.catsModel.deserializeCats(rawCats, null);
				}*/
				
				gameManager.pvpEnemySetted = true;
				Game.current.gameScreen.gameUI.tryStartPvPRound();
			}
			
			
			if (raw.name == "gameOver")
			{
				if (Game.current && Game.current.gameScreen && Game.current.gameScreen.gameUI && !Game.current.gameScreen.gameUI.exitGameSent)
				{
					Game.current.gameScreen.gameUI.handleExit('ENEMY LEAVE THE GAME! WAIT FOR EXIT!');
					
					//gameScreen.backToLobby();
				}
				
				
			}
			
			//<>>>>>  {"id":0,"name":"roundResponse","payload":{"gameId":3,"status":"CLOSED","firstPlayerInfo":{"playerId":5,"gameId":3,"pets":[{"id":0,"catProtoId":3,"health":3,"role":"HARVESTER","targetCatId":-1},{"id":1,"catProtoId":3,"health":3,"role":"DEFENDER","targetCatId":3},{"id":2,"catProtoId":3,"health":3,"role":"FIGHTER","targetCatId":5}]},"secondPlayerInfo":{"playerId":6,"gameId":3,"pets":[{"id":0,"catProtoId":3,"health":3,"role":"HARVESTER","targetCatId":-1},{"id":1,"catProtoId":3,"health":3,"role":"HARVESTER","targetCatId":-1},{"id":2,"catProtoId":3,"health":3,"role":"DEFENDER","targetCatId":5}]}},"timeMillis":1532103837977,"clientLocalAddr":null}

			
		}
		
		public function sendJoin():void
		{
			var json:Object = {
			   id: 0,
			   session: gameManager.connectionManager.sessionId,
			   name: "joinGame",
			   payload: {playerId:Player.current.playerId} 
			}
		
			ServerConnection.current.sendMessageNew(json);
		}
		
		private function handleMessage(message:Message):void
		{
			if (!message)
				return;
			
			try
			{
				//trace('receive message ', getQualifiedClassName(message) );
				if(LOGGING_ENABLED)
					sosTrace("RCV " + getQualifiedClassName(message) + ": " + message.toString(), SOSLog.INFO);
			}
			catch (e:Error)
			{
				sosTrace("Could not print " + getQualifiedClassName(message) + " message", SOSLog.WARNING);
			}
			
			new HandleMessage(message).execute();
		}
		
		public function sendBuyCardsMessage(cardsCount:uint, stake:uint):void
		{
			var buyCardsMessage:BuyCardsMessage = new BuyCardsMessage();
			//trace('sendBuyCardsMessage debug cursor x,y:', Starling.current.nativeStage.mouseX, Starling.current.nativeStage.mouseY);
			buyCardsMessage.cardsCount = cardsCount;
			buyCardsMessage.stake = stake;
			ServerConnection.current.sendMessage(buyCardsMessage);
		}
		
		public function sendReturnFromRoundMessage():void
		{
			if(!Player.current || !Player.current.isActivePlayer)
				return;
			
			var leaveMessage:LeaveMessage = new LeaveMessage();
			
			if(ServerConnection.current)
				ServerConnection.current.sendMessage(leaveMessage);
			
			Player.current.isActivePlayer = false;	
			Player.current.clearCards();
		}
		
		public function sendJoinMessage(roomTypeName:String):void
		{
			var joinMessage:JoinMessage = new JoinMessage();
			joinMessage.roomTypeName = roomTypeName;
			ServerConnection.current.sendMessage(joinMessage);
			hasJoinMessageEverSent = true;
			gameManager.roomsModel.currentRoomTypeName = roomTypeName;
		}
		
		public function sendLeaveMessage():void
		{
			var leaveMessage:LeaveMessage = new LeaveMessage();
			ServerConnection.current.sendMessage(leaveMessage);
		}
		
		public function sendBingoMessage(card:Card):void
		{
			var bingoMessage:BingoMessage = new BingoMessage();
			bingoMessage.cardId = card.cardId;
			bingoMessage.daubedNumbers = card.daubedNumbers;
			bingoMessage.magicDaubs = card.magicDaubs;
			if (card.instantBingoNumber != 0)
				bingoMessage.instantBingoNumber = card.instantBingoNumber;
			ServerConnection.current.sendMessage(bingoMessage);
		}
		
		public function sendInviteMessage(response:FacebookDialogResponse):void
		{
			if (response.isEmpty)
				return;
			
			var inviteMessage:InviteMessage = new InviteMessage();
			inviteMessage.invitedPlayers = [];
			inviteMessage.requestId = response.requestId;
			
			for each (var facebookId:String in response.userIds)
			{
				var invited:InvitedPlayerMessage = new InvitedPlayerMessage();
				invited.invitedFacebookIdString = facebookId;
				invited.inviteTimestamp = UInt64.fromNumber(Game.connectionManager.currentServerTime);
				
				inviteMessage.invitedPlayers.push(invited);
			}
			
			ServerConnection.current.sendMessage(inviteMessage);
		}
		
		public function sendGiftAcceptedMessage(requestId:String):void
		{
			var giftAcceptedMessage:GiftAcceptedMessage = new GiftAcceptedMessage();
			giftAcceptedMessage.requestId = requestId;
			
			ServerConnection.current.sendMessage(giftAcceptedMessage);
		}
		
		public function sendRequestIncomingItemsMessage():void
		{
			var requestIncomingItemsMessage:RequestIncomingItemsMessage = new RequestIncomingItemsMessage();
			if (ServerConnection.current)
			{
				ServerConnection.current.sendMessage(requestIncomingItemsMessage);
			}
		}
		
		public function sendGiftMessage(response:FacebookDialogResponse):void
		{
			if (response.isEmpty)
				return;
			
			var giftMessage:GiftMessage = new GiftMessage();
			giftMessage.giftedPlayers = [];
			giftMessage.requestId = response.requestId;
			
			for each (var facebookId:String in response.userIds)
			{
				var gifted:GiftedPlayerMessage = new GiftedPlayerMessage();
				gifted.receiverFacebookIdString = facebookId;
				gifted.giftTimestamp = UInt64.fromNumber(Game.connectionManager.currentServerTime);
				
				giftMessage.giftedPlayers.push(gifted);
			}
			
			ServerConnection.current.sendMessage(giftMessage);
		}
		
		public function sendClaimOfferMessage(offerName:String):void
		{
			var claimOfferMessage:ClaimOfferV2Message = new ClaimOfferV2Message();
			claimOfferMessage.offerName = offerName;
			ServerConnection.current.sendMessage(claimOfferMessage);
		}
		
		public function sendOfferAcceptedMessage(offerName:String):void
		{
			var offerAcceptedMessage:OfferAcceptedMessage = new OfferAcceptedMessage();
			offerAcceptedMessage.offerName = offerName;
			ServerConnection.current.sendMessage(offerAcceptedMessage);
		}
		
		public function sendPlayerUpdateMessage():void
		{
			if (delayedUpdateCallID == -1)
			{
				delayedUpdateCallID = Starling.juggler.delayCall(sendPlayerUpdateMessageInternal, 0.05);
			}
		}
		
		public function cancelPlayerUpdate():void
		{
			if (delayedUpdateCallID != -1)
			{
				Starling.juggler.removeByID(delayedUpdateCallID);
				delayedUpdateCallID = -1;
			}
		}
		
		private function sendPlayerUpdateMessageInternal():void 
		{
			playerUpdateIndex += 1;
			
			//sendMalformedUpdateMessages();
			
			var playerUpdateMessage:PlayerUpdateMessage = new PlayerUpdateMessage();
			playerUpdateMessage.player = createPlayerMessageFromPlayer(Player.current);
			playerUpdateMessage.version = playerUpdateIndex;
			ServerConnection.current.sendMessage(playerUpdateMessage);
			gameManager.analyticsManager.sendPlayerStateEvent(Player.current);
			delayedUpdateCallID = -1;
		}
		
		private function sendMalformedUpdateMessages():void 
		{
			for (var i:int = 0; i < 3; i++) 
			{
				var playerUpdateMessage:PlayerUpdateMessage = new PlayerUpdateMessage();
				playerUpdateMessage.player = createPlayerMessageFromPlayer(Player.current);
				playerUpdateMessage.player.xpLevel = 0;
				playerUpdateMessage.player.xpCount = 0;
				playerUpdateMessage.player.firstName = "";
				playerUpdateMessage.player.account = [];
				ServerConnection.current.sendMessage(playerUpdateMessage);
			}
		}
		
		public function createPlayerMessageFromPlayer(player:Player):PlayerMessage
		{
			var playerMessage:PlayerMessage = new PlayerMessage();
			playerMessage.playerId = UInt64.fromNumber(player.playerId);
			playerMessage.xpCount = player.xpCount;
			playerMessage.xpLevel = player.xpLevel;
			playerMessage.coinsCount = player.cashCount;
			playerMessage.bingosCount = player.bingosCount;
			playerMessage.daubsCount = player.daubsCount;
			playerMessage.gamesCount = player.gamesCount;
			playerMessage.powerupsUsedCount = player.powerupsUsedCount;
			playerMessage.bingosCount = player.bingosCount;
			playerMessage.magicboxesOpenedCount = player.magicboxesOpenedCount;
			playerMessage.openChestsCount = player.chestsOpened;
		//GameScreen.debugShowTextField('ChestOpened to server: ' + player.chestsOpened.toString(), true);
			playerMessage.completedObjectives = player.completedObjectives;
			playerMessage.items = player.items;
			playerMessage.bonusUsedTimestamp = UInt64.fromNumber(player.bonusUsedTimestamp);
			playerMessage.lifetimeValue = player.lifetimeValue;
			playerMessage.invitesSentCount = player.invitesSentCount;
			playerMessage.checkSum = checkSum(playerMessage);
			playerMessage.periodicBonusTimeMillis = UInt64.fromNumber(player.nextPeriodicTimeValue);
			playerMessage.pushToken = PlatformServices.interceptor.pushToken;
			gameManager.chestsData.fillPlayerMessage(playerMessage);
			gameManager.collectionsData.fillPlayerMessage(playerMessage);
			gameManager.skinningData.fillPlayerMessage(playerMessage);
			
			playerMessage.account = playerMessage.account.concat(gameManager.powerupModel.getPowerupCommodities());
			
			if (gameManager.trackingData)
			{
				playerMessage.installTrackingData = gameManager.trackingData;
			}
			
			if (gameManager.trackingDataAppOpen)
			{
				playerMessage.openTrackingData = gameManager.trackingDataAppOpen;
			}
			
			if (!playerMessage.customizationSettings)
				playerMessage.customizationSettings = new PlayerCustomizationSettingsMessage();
				
			playerMessage.customizationSettings.selectedCardId = player.customizerCardId;
			playerMessage.customizationSettings.selectedDaubIconId = player.customizerDaubId;
			playerMessage.customizationSettings.selectedVoiceOverId = player.customizerVoiceOverId;
			playerMessage.customizationSettings.selectedAvatarId = player.customizerAvatarId;
			
			var playerCash:CommodityItemMessage = new CommodityItemMessage();
			playerCash.type = Type.CASH;
			playerCash.quantity = player.cashCount;
			playerMessage.account.push(playerCash);
			
			var playerDust:CommodityItemMessage = new CommodityItemMessage();
			playerDust.type = Type.DUST;
			playerDust.quantity = player.dustCount;
			playerMessage.account.push(playerDust);
			
			gameManager.scratchCardModel.addBonusScratchesToAccount(playerMessage.account);
			gameManager.slotsModel.fillPlayerMessage(playerMessage);
			
			return playerMessage;
		}
		
		public function sendClientDataSaveMessage():void
		{
			if (delayedClientDataSaveCallID == -1)
			{
				delayedClientDataSaveCallID = Starling.juggler.delayCall(sendClientDataSaveMessageInternal, 0.05);
			}
		}
		
		public function cancelClientDataSave():void
		{
			if (delayedClientDataSaveCallID != -1)
			{
				Starling.juggler.removeByID(delayedClientDataSaveCallID);
				delayedClientDataSaveCallID = -1;
			}
		}
		
		private function sendClientDataSaveMessageInternal():void 
		{
			var saveClientDataMessage:SaveClientDataMessage = new SaveClientDataMessage();
			saveClientDataMessage.clientData = gameManager.clientDataManager.clientDataByteArray;
			ServerConnection.current.sendMessage(saveClientDataMessage);
			delayedClientDataSaveCallID = -1;
		}
		
		private function checkSum(m:PlayerMessage):uint
		{
			var checkSum:uint = 5;
			checkSum += m.playerId.low % 7 + m.playerId.low % 19 + m.playerId.low % 179 + m.playerId.low % 1279;
			checkSum += m.ticketsCount % 7 + m.ticketsCount % 19 + m.ticketsCount % 179 + m.ticketsCount % 1279;
			checkSum += m.coinsCount % 7 + m.coinsCount % 19 + m.coinsCount % 179 + m.coinsCount % 1279;
			checkSum += m.energyCount % 7 + m.energyCount % 19 + m.energyCount % 179 + m.energyCount % 1279;
			checkSum += m.keysCount % 7 + m.keysCount % 19 + m.keysCount % 179 + m.keysCount % 1279;
			checkSum += m.magicboxesOpenedCount % 7 + m.magicboxesOpenedCount % 19 + m.magicboxesOpenedCount % 179 + m.magicboxesOpenedCount % 1279;
			checkSum += m.xpCount % 7 + m.xpCount % 19 + m.xpCount % 179 + m.xpCount % 1279;
			checkSum += m.xpLevel % 7 + m.xpLevel % 19 + m.xpLevel % 179 + m.xpLevel % 1279;
			return checkSum;
		}
		
		public function sendClientMessage(message:String, ignoreLimits:Boolean = false):void
		{
			if(!ignoreLimits && sendLogsCounter >= Constants.MAX_CRASH_LOG_SEND_COUNT)
				return;
				
			var currentTimestamp:Number = getTimer();
			if (!ignoreLimits && currentTimestamp - mLastClientMessageTimestamp < Constants.CLIENT_MESSAGE_MIN_INTERVAL_MILLIS)
			{
				return;
			}
			mLastClientMessageTimestamp = currentTimestamp;
			
			var msg:ClientMessage = new ClientMessage();
			
			if (gameManager.playerId)
			{
				msg.playerId = gameManager.playerId;
			}
			
			msg.message = createSignature() + ", message=" + message;
			//sosTrace('CRASH LOG TEXT:', msg.message);
			ServerConnection.current.sendMessage(msg, true);
			sendLogsCounter++;
		}
		
		public function createSignature():String
		{
			var text:String = "platform=" + PlatformServices.platform + 
				(Player.current ? (", id: " + Player.current.playerId) : '') + 
			 	", time=" + getTimer().toString() +  
				", game version: " + gameManager.getVersionString() + 
				", ui: " + Game.pathHistory +
				", dialogs: " + DialogsManager.logHistory +
				", level:" + (Player.current ? Player.current.xpLevel : '-') +
				", device: " + String(PlatformServices.interceptor.getDeviceModelRaw()) + ", on: " + String(PlatformServices.interceptor.getOS()) +
				", ram: " + Number(System.totalMemory * (1.0 / (1024 * 1024))).toFixed(1) + gpuStringValue() +
				", active=" + String(!gameManager.deactivated) + 	
				", player version: " + Capabilities.version + 
				", player type: " + Capabilities.playerType + 
				", debug player: " + Capabilities.isDebugger.toString() + 
				", OS: " + Capabilities.os + 
				(PlatformServices.isCanvas ? (", browser: " + SystemInfo.getBrowserName()) : '') + 
				", cpu: " + Capabilities.cpuArchitecture;
				//", atf: " + SystemInfo.canUseAtfTextures.toString();
				
				if(gameManager.stage.stage3Ds && gameManager.stage.stage3Ds.length > 0)
					text += ", driver : " + SystemInfo.getDriverInfo(gameManager.stage.stage3Ds[0]);
				else
					text += ", driver : null"
			
			function gpuStringValue():String {
				if (Starling.context && "totalGPUMemory" in Starling.context)
					return ", gpu: " + Number(Starling.context['totalGPUMemory'] * (1.0 / (1024 * 1024))).toFixed(1);
				return '';
			}
					
			return text;
		}
		
		public function sendLiveEventInfoMessage(liveEventName:String):void
		{
			var msg:LiveEventInfoMessage = new LiveEventInfoMessage();
			msg.liveEventName = liveEventName;
			ServerConnection.current.sendMessage(msg);
		}
		
		public function sendLiveEventLeaderboardsMessage(liveEventID:int = -1, fromPositionIndex:int = -1, toPositionIndex:int = -1, centered:Boolean = false):void
		{
			var msg:LiveEventLeaderboardsMessage = new LiveEventLeaderboardsMessage();
			
			msg.liveEventId = liveEventID;
			
			if (fromPositionIndex != -1 && toPositionIndex != -1)
			{
				msg.fromPositionIndex = fromPositionIndex;
				msg.toPositionIndex = toPositionIndex;
			}
			msg.center = centered;
			ServerConnection.current.sendMessage(msg);
		}
		
		public function sendLiveEventScoreUpdateMessage(liveEventScoreEarned:uint, currentTournamentID:uint):void
		{
			scoreUpdateCompleted = false;
			
			var msg:LiveEventScoreUpdateMessage = new LiveEventScoreUpdateMessage();
			msg.liveEventAddScore = UInt64.fromNumber(liveEventScoreEarned);
			msg.liveEventId = UInt64.fromNumber(currentTournamentID);
			ServerConnection.current.sendMessage(msg);
		}
		
		public function startTimer():void
		{
			if (mTimer)
			{
				mTimer.stop();
				mTimer = null;
			}
			
			mTimer = new Timer(Constants.ONE_SECOND_INTERVAL_MILLIS);
			mTimer.addEventListener(TimerEvent.TIMER, handler_onTimer);
			mTimer.start();
		}
		
		private function handler_onTimer(e:TimerEvent):void
		{
			//TODO: fix time sync
			mCurrentServerTime += Constants.ONE_SECOND_INTERVAL_MILLIS;
		}
		
		public function stopTimer():void
		{
			if (mTimer != null)
			{
				mTimer.stop();
				mTimer = null;
			}
		}
		
		public function resetPlayerUpdateIndex():void 
		{
			playerUpdateIndex = 0;
		}
		
		private function onClosedConnection(e:starling.events.Event):void
		{
			sosTrace("Game::onClosedConnection");
			new ShowNoConnectionDialog(DDNAReconnectShownEvent.NO_CONNECTION, e.data ? ('Message: ' + String(e.data)): '').execute();
			
			if(Game.current)
				Game.current.clean();
		}
		
		private function onPurchaseCompleted(e:starling.events.Event):void
		{
			if (Player.current != null && ServerConnection.current != null)
			{
				var purchaseData:Object = e.data;
				if (!purchaseData)
				{
					sosTrace( "No purchase data!", SOSLog.ERROR);
					return;
				}
				
				var item:IStoreItem = purchaseData.item;
				var purchaseMessage:PurchaseMessage = new PurchaseMessage();
				purchaseMessage.itemId = item.itemId;
				purchaseMessage.value = item.value;
				var additionalData:String = "";
				if (PlatformServices.platform == Platform.GOOGLE_PLAY)
				{
					purchaseMessage.googlePlayJsonData = purchaseData.jsonData;
					purchaseMessage.googlePlaySignature = purchaseData.signature;
					additionalData = String(purchaseData.jsonData);
				}
				else if (PlatformServices.platform == Platform.AMAZON_APP_STORE)
				{
					purchaseMessage.amazonUserId = purchaseData.userId;
					purchaseMessage.amazonReceiptId = purchaseData.receiptId;
					additionalData = String(purchaseData.userId);
				}
				else if (PlatformServices.platform == Platform.APPLE_APP_STORE)
				{
					purchaseMessage.iosReceipt = purchaseData.receipt;
				}
				else if (PlatformServices.platform == Platform.FACEBOOK)
				{
					purchaseMessage.facebookPaymentId = purchaseData.facebookPaymentId;
					additionalData = String(purchaseData.facebookPaymentId);
				}
				
				gameManager.analyticsManager.sendDeltaDNAEvent(
					new DDNAStoreTransactionStateEvent(
						DDNAStoreTransactionStateEvent.PURCHASE_DATA_SENT_TO_SERVER, 
						String(item.itemId) + ", " + String(item.value)
							+ (additionalData ? (", " + additionalData) : "")));
						
				ServerConnection.current.sendMessage(purchaseMessage);
			}
		}
	
	}
}
