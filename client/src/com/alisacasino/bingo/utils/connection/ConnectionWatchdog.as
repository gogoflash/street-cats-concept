package com.alisacasino.bingo.utils.connection
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.dialogCommands.ShowNoConnectionDialog;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.TransferRateWarningDialog;
	import com.alisacasino.bingo.protocol.RequestServerStatusMessage;
	import com.alisacasino.bingo.protocol.ServerStatusMessage;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.screens.LoadingScreen;
	import com.alisacasino.bingo.utils.ConnectionManager;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.ServerConnection;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAReconnectShownEvent;
	import flash.utils.getTimer;
	import starling.events.EnterFrameEvent;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ConnectionWatchdog
	{
		static public const FRAMES_TO_ANALYZE:int = 300;
		static public const WARNING_RATE:Number = 1000;
		static public const BALL_RECONNECT_TIMEOUT:int  = 15000;
		static public const BALL_WARNING_TIMEOUT:int = 5500;
		static private const ACTIVE_FRAME_PERCENT:Number = 0.8;
		private var cumulativeTransferRate:Number = -1;
		private var transferRateHistory:Vector.<Number>;
		private var activeFrames:int;
		private var totalSpeed:Number;
		private var warningSent:Boolean;
		private var needToCheckBallTimeout:Boolean;
		private var lastBallTime:int;
		public var unansweredStatusRequests:int;
		public var pingValue:int;
        private var statusRequestTimestamps:Array;
		private var lastPingTimestamp:int;
		private var hasDisconnect:Boolean;
		
		public function ConnectionWatchdog()
		{
			
		}
		
		public function initialize(game:Game):void
		{
			game.addEventListener(EnterFrameEvent.ENTER_FRAME, game_enterFrameHandler);
			reset();
		}
		
		public function stopBallTimer():void 
		{
			needToCheckBallTimeout = false;
			hideConnectionWarning();
		}
		
		public function reportTransferRate(transferRate:Number):void
		{
			if (transferRate == -1)
				return;
			
			if (cumulativeTransferRate == -1)
			{
				cumulativeTransferRate = transferRate;
			}
			else
			{
				cumulativeTransferRate += transferRate;
			}
		}
		
		public function startBallTimer():void 
		{
			needToCheckBallTimeout = true;
			lastBallTime = getTimer();
		}
		
		public function reportBall():void 
		{
			lastBallTime = getTimer();
		}
		
		public function reset():void 
		{
			transferRateHistory = new Vector.<Number>();
			activeFrames = 0;
			totalSpeed = 0;
			stopBallTimer();
			unansweredStatusRequests = 0;
			statusRequestTimestamps = [];
			lastPingTimestamp = getTimer();
			hasDisconnect = false;
		}
		
		public function reportPing(serverStatusMessage:ServerStatusMessage):void 
		{
			if (statusRequestTimestamps && statusRequestTimestamps.length)
			{
				var ping:int = getTimer() - statusRequestTimestamps.shift();
				pingValue = ping;
			}
			unansweredStatusRequests--;
		}
		
		private function game_enterFrameHandler(e:EnterFrameEvent):void
		{
			//checkTransferRate();
			if (needToCheckBallTimeout)
			{
				checkBallTimeout();
			}
			
			checkPing();
			gameManager.giftsModel.callIncomingItems();
		}
		
		private function checkPing():void 
		{
			if (getTimer() > lastPingTimestamp + Constants.REQUEST_SERVER_STATUS_INTERVAL_MILLIS)
			{
				if (ServerConnection.current && ServerConnection.current.connected)
				{
					ServerConnection.current.sendMessage(new RequestServerStatusMessage());
					
					statusRequestTimestamps.push(getTimer());
					lastPingTimestamp = getTimer();
					
					unansweredStatusRequests++;
				}
			}
			
			if (unansweredStatusRequests > 1)
			{
				hasDisconnect = true;
				showConnectionWarning();
			}
			else
			{
				hideConnectionWarning();
				if (hasDisconnect) {
					gameManager.dispatchEventWith(ConnectionManager.EVENT_CONNECTION_RESTORED);
					hasDisconnect = false;
				}
			}
			
			if (unansweredStatusRequests > 4)
			{
				sosTrace("Too many status requests unanswered, reconnecting", SOSLog.ERROR);
				if (!gameManager.deactivated) 
				{
					new ShowNoConnectionDialog(DDNAReconnectShownEvent.WATCHDOG, "Too many status requests unanswered: " + unansweredStatusRequests.toString()).execute();
					
					if(ServerConnection.current)
						ServerConnection.current.close();
						
					Game.connectionManager.stopTimer();
					unansweredStatusRequests = 0;
				}
			}
		}
		
		private function checkBallTimeout():void 
		{
			if(getTimer() - lastBallTime > BALL_RECONNECT_TIMEOUT)
			{
				new ShowNoConnectionDialog(DDNAReconnectShownEvent.WATCHDOG, 'last ball timeout exceed: ' + (getTimer() - lastBallTime).toString()).execute();
				stopBallTimer();
			}
			else if (getTimer() - lastBallTime > BALL_WARNING_TIMEOUT)
			{
				showConnectionWarning();
			}
			else
			{
				hideConnectionWarning();
			}
		}
		
		private function showConnectionWarning():void 
		{
			if (Game.current && Game.current.gameScreen)
			{
				Game.current.gameScreen.gameScreenController.showConnectionWarning();
			}
		}
		
		private function hideConnectionWarning():void
		{
			if (Game.current && Game.current.gameScreen)
			{
				Game.current.gameScreen.gameScreenController.hideConnectionWarning();
			}
		}
		
		private function checkTransferRate():void 
		{
			if (warningSent)
				return;
			
			transferRateHistory.push(cumulativeTransferRate);
			
			if (cumulativeTransferRate != -1)
			{
				totalSpeed += cumulativeTransferRate;
				activeFrames++;
			}
			
			cumulativeTransferRate = -1;
			
			while (transferRateHistory.length > FRAMES_TO_ANALYZE)
			{
				var oldestSample:Number = transferRateHistory.shift();
				if (oldestSample != -1)
				{
					activeFrames--;
					totalSpeed -= oldestSample;
				}
			}
			
			if (transferRateHistory.length >= FRAMES_TO_ANALYZE)
			{
				if ((activeFrames / FRAMES_TO_ANALYZE) >= ACTIVE_FRAME_PERCENT)
				{
					var averageSpeedOverTime:Number = totalSpeed / activeFrames;
					if (averageSpeedOverTime < WARNING_RATE)
					{
						warningSent = true;
						DialogsManager.addDialog(new TransferRateWarningDialog());
					}
				}
			}
		}
	
	}

}