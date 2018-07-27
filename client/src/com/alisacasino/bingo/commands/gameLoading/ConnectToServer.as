package com.alisacasino.bingo.commands.gameLoading 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.dialogCommands.ShowNoConnectionDialog;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.protocol.RequestServerStatusMessage;
	import com.alisacasino.bingo.utils.ConnectionManager;
	import com.alisacasino.bingo.utils.Server;
	import com.alisacasino.bingo.utils.ServerConnection;
	import com.alisacasino.bingo.utils.Settings;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAReconnectShownEvent;
	import com.netease.protobuf.UInt64;
	import starling.events.Event;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ConnectToServer extends CommandBase
	{
		private var id:String;
		
		public static var DEBUG:Boolean = false
		
		public function ConnectToServer() 
		{
			id = int(Math.random() * int.MAX_VALUE).toString(36);
		}
		
		override protected function startExecution():void 
		{
			sosTrace(id + " ConnectToServer.startExecution" );
			super.startExecution();
			
			Game.addEventListener(ConnectionManager.CONNECTION_CLOSED_EVENT, connectionClosedEventHandler);
			Game.addEventListener(ConnectionManager.CONNECTION_ERROR_EVENT, connectionErrorEventHandler);
			Game.addEventListener(ConnectionManager.SIGN_IN_COMPLETE_EVENT, signInCompleteEventHandler);
			Game.addEventListener(ConnectionManager.SIGN_IN_ERROR_EVENT, signInErrorEventHandler);
			
			var serverSettings:Server = Settings.instance.getPreferredOrRandomServer();
			
			if (serverSettings == null)
			{
				showNoConnectionDialog(DDNAReconnectShownEvent.NO_CONNECTION, 'serverSettings is null');
				return;
			}
			
			ServerConnection.current = new ServerConnection(serverSettings.host, serverSettings.port, serverSettings.useSSL);
			ServerConnection.current.connect();
			
			if (DEBUG)
			{
				Player.current = new Player(null);
				Player.current.mPlayerId = UInt64.fromNumber(5678);
				
				Player.current.xpCount = 1;
				
				Room.current = new Room(null);
				finish();
			}
			else
			{
				ServerConnection.current.sendMessage(new RequestServerStatusMessage());
			}
			
			
		}
		
		private function showNoConnectionDialog(ddnaSource:String, ddnaDescription:String):void
		{
			new ShowNoConnectionDialog(ddnaSource, ddnaDescription).execute(fail, fail);
		}
		
		private function signInErrorEventHandler(e:Event):void 
		{
			sosTrace(id + " ConnectToServer.signInErrorEventHandler > e : " + e );
			showNoConnectionDialog(DDNAReconnectShownEvent.NO_CONNECTION, 'Sign in error.' + (e.data ? (' Message:' + String(e.data)) : ''));
		}
		
		private function signInCompleteEventHandler(e:Event):void 
		{
			sosTrace(id + " ConnectToServer.signInCompleteEventHandler > e : " + e );
			finish();
		}
		
		private function connectionErrorEventHandler(e:Event):void 
		{
			sosTrace(id + " ConnectToServer.connectionErrorEventHandler > e : " + e );
			showNoConnectionDialog(DDNAReconnectShownEvent.NO_CONNECTION, 'ConnectionError.' + (e.data ? (' Message:' + String(e.data)) : ''));
		}
		
		private function connectionClosedEventHandler(e:Event):void 
		{
			sosTrace(id + " ConnectToServer.connectionClosedEventHandler > e : " + e );
			fail();
		}
		
		override protected function stopInternal():void 
		{
			sosTrace( "ConnectToServer.stopInternal" );
			super.stopInternal();
			removeGameListeners();
		}
		
		override protected function fail():void 
		{
			sosTrace( "ConnectToServer.fail" );
			removeGameListeners();
			super.fail();
		}
		
		override protected function finish():void 
		{
			sosTrace( "ConnectToServer.finish" );
			removeGameListeners();
			super.finish();
		}
		
		private function removeGameListeners():void 
		{
			Game.removeEventListener(ConnectionManager.CONNECTION_CLOSED_EVENT, connectionClosedEventHandler);
			Game.removeEventListener(ConnectionManager.CONNECTION_ERROR_EVENT, connectionErrorEventHandler);
			Game.removeEventListener(ConnectionManager.SIGN_IN_COMPLETE_EVENT, signInCompleteEventHandler);
			Game.removeEventListener(ConnectionManager.SIGN_IN_ERROR_EVENT, signInErrorEventHandler);
		}
		
	}

}