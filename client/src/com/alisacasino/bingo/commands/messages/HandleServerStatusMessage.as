package com.alisacasino.bingo.commands.messages 
{
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.protocol.ServerStatusMessage;
	import com.alisacasino.bingo.utils.Settings;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class HandleServerStatusMessage extends CommandBase
	{
		private var message:ServerStatusMessage;
		
		public function HandleServerStatusMessage(message:ServerStatusMessage) 
		{
			this.message = message;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			if (message.active != true)
			{
				Settings.instance.maintenanceText = message.message;
				Settings.instance.maintenanceTitle = message.messageTitle;
				Settings.instance.maintenance = true;
			}
			gameManager.watchdogs.connectionWatchdog.reportPing(message);
			finish();
		}
		
	}

}