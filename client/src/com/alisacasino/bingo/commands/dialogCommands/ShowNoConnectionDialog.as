package com.alisacasino.bingo.commands.dialogCommands 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.ICommand;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.ReconnectDialog;
	import com.alisacasino.bingo.logging.SaveHTMLLog;
	import com.alisacasino.bingo.logging.SendLog;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.ServerConnection;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAReconnectShownEvent;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ShowNoConnectionDialog extends CommandBase
	{
		private var buttonText:String;
		private var text:String;
		private var title:String;
		private var type:String;
		private var ddnaSource:String;
		private var ddnaDescription:String;
		
		public function ShowNoConnectionDialog(ddnaSource:String, ddnaDescription:String, type:String = ReconnectDialog.TYPE_RECONNECT, title:String = Constants.TITLE_UNABLE_TO_CONNECT, text:String = Constants.TEXT_UNABLE_TO_CONNECT, buttonText:String = "RETRY") 
		{
			super();
			this.ddnaSource = ddnaSource;
			this.ddnaDescription = ddnaDescription;
			this.type = type;
			this.title = title;
			this.text = text;
			this.buttonText = buttonText;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			var hasActiveReconnectDialog:Boolean = DialogsManager.instance.getDialogByClass(ReconnectDialog);
			
			if (!hasActiveReconnectDialog && ddnaSource) 
			{
				if (Player.current) {
					gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAReconnectShownEvent(ddnaSource, ddnaDescription));
				}
				else {
					sosTrace();
					var playerId:String = gameManager.playerId ? gameManager.playerId.toString() : '';
					new SendLog('log_reconnect_' + SaveHTMLLog.getDateString(false) + '_' + playerId, 'source: ' + ddnaSource + ', description: ' + String(ddnaDescription), false).execute();	
				}
			}
			
			if(ServerConnection.current)
				ServerConnection.current.close();
			
			if (hasActiveReconnectDialog)
				return;
			
			Game.current.setGameTouchable(true);
			
			DialogsManager.closeAll();
			
			gameManager.tutorialManager.stop();
			
			var reconnectDialog:ReconnectDialog = new ReconnectDialog(type, title.toUpperCase(), text.toUpperCase(), 10, onDialogClose, buttonText);
			DialogsManager.addDialog(reconnectDialog, true, true);
		}
		
		private function onDialogClose():void 
		{
			finish();
		}
		
		override protected function finish():void 
		{
			super.finish();
			Game.current.loadGame();
		}
		
		override protected function fail():void 
		{
			super.fail();
			Game.current.loadGame();
		}
	}

}