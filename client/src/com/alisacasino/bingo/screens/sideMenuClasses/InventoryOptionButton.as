package com.alisacasino.bingo.screens.sideMenuClasses 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.models.skinning.SkinningData;
	import com.alisacasino.bingo.screens.lobbyScreenClasses.LobbyUI;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class InventoryOptionButton extends OptionButton 
	{
		public function InventoryOptionButton(iconTexture:Texture, labelText:String) 
		{
			super(iconTexture, labelText);
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			gameManager.skinningData.addEventListener(SkinningData.EVENT_NEW_ITEMS_CHANGE, handler_changeNewItemsChange);
			handler_changeNewItemsChange(null);
			
			//setInterval(function():void{ inboxLabelCount = int(15*Math.random()) }, 1000);
		}
		
		private function handler_changeNewItemsChange(event:Event):void 
		{
			/*var lobbyUI:LobbyUI = Game.current.gameScreen.lobbyUI;
			var droppedItemsCount:int = (lobbyUI && lobbyUI.lobbyItemDropsController.customizerDropItems) ? lobbyUI.lobbyItemDropsController.customizerDropItems.length : 0;
			labelCount = gameManager.skinningData.newCustomizerItems.length - droppedItemsCount; */
		}

		override public function dispose():void {
			gameManager.skinningData.removeEventListener(SkinningData.EVENT_NEW_ITEMS_CHANGE, handler_changeNewItemsChange);
			super.dispose();
		}
	}

}