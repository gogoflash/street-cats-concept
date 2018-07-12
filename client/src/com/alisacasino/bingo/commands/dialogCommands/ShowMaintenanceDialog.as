package com.alisacasino.bingo.commands.dialogCommands 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.ReconnectDialog;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.utils.Settings;
	import starling.core.Starling;
	import starling.events.Event;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ShowMaintenanceDialog extends CommandBase
	{
		private var delayedCallID:int;
		private var force:Boolean;
		
		public function ShowMaintenanceDialog(force:Boolean = false) 
		{
			this.force = force;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			if (force)
			{
				forceShowReconnectDialog();
				finish();
				return;
			}
			
			var currentGame:Game = Game.current;
			if (!(currentGame.currentScreen is GameScreen))
			{
				fail();
				return;
			}
			
			
			if (currentGame.gameScreen.state == GameScreen.STATE_IN_GAME)
			{
				fail();
				return;
			}
			
			if (Player.current.cards.length > 0)
			{
				fail();
				return;
			}
			
			if (DialogsManager.instance.getDialogByClass(ReconnectDialog))
			{
				fail();
				return;
			}
			
			DialogsManager.instance.addEventListener(DialogsManager.EVENT_ADD, dialogAddedHandler);
			
			
			DialogsManager.addDialog(createMaintenanceDialog(), false, false);
			
			delayedCallID = Starling.juggler.delayCall(forceShowReconnectDialog, 120);
		}
		
		private function createMaintenanceDialog():ReconnectDialog
		{
			return new ReconnectDialog(ReconnectDialog.TYPE_RECONNECT, Settings.instance.maintenanceTitle.toUpperCase(), Settings.instance.maintenanceText.toUpperCase(), 10, onDialogClose, "RETRY");
		}
		
		private function forceShowReconnectDialog():void 
		{
			DialogsManager.addDialog(createMaintenanceDialog(), true, true);
		}
		
		private function dialogAddedHandler(e:Event):void 
		{
			if (e.data is ReconnectDialog)
			{
				if (delayedCallID)
				{
					Starling.juggler.removeByID(delayedCallID);
				}
			}
		}
		
		private function onDialogClose():void 
		{
			finish();
			Game.current.loadGame();
		}
		
	}

}