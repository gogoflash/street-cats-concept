package com.alisacasino.bingo.commands.player 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	
	public class ShowReservedDrops extends CommandBase 
	{
		public var delay:Number = 0;
		public var callUpdateLobbyBarsTrueValue:Boolean;
		
		public function ShowReservedDrops(delay:Number = 0, callUpdateLobbyBarsTrueValue:Boolean = true) 
		{
			this.delay = delay;
			this.callUpdateLobbyBarsTrueValue = callUpdateLobbyBarsTrueValue;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			new UpdateLobbyBarsTrueValue(delay + gameManager.collectionsData.collectionDropItems.length * 0.6).execute();
			
			// визуализировать выдачу коллекции и кастомайзеровъ
			//if(Game.current.gameScreen.lobbyUI)
				//Game.current.gameScreen.lobbyUI.lobbyItemDropsController.showDrops(gameManager.collectionsData.collectionDropItems, gameManager.skinningData.customizerDropItems);
			
			finish();
		}
	}

}