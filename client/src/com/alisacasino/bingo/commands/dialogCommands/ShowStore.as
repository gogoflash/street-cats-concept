package com.alisacasino.bingo.commands.dialogCommands 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.screens.storeWindow.StoreScreen;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ShowStore extends CommandBase
	{
		private var mode:int;
		private var overCurrent:Boolean;
		
		public function ShowStore(mode:int = StoreScreen.CASH_MODE, overCurrent:Boolean = true) 
		{
			this.overCurrent = overCurrent;
			this.mode = mode;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			var storeScreen:StoreScreen = DialogsManager.instance.getDialogByClass(StoreScreen) as StoreScreen;
			
			if (storeScreen)
			{
				storeScreen.mode = mode;
			}
			else 
			{
				DialogsManager.addDialog(new StoreScreen(mode), overCurrent);
			}
		}
		
	}

}