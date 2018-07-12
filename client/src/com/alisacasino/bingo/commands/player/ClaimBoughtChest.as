package com.alisacasino.bingo.commands.player 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.dialogCommands.ChestTakeOutCommand;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.IDialog;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.chests.ChestData;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.screens.storeWindow.StoreScreen;
	import com.alisacasino.bingo.store.items.ChestStoreItem;
	import com.alisacasino.bingo.utils.analytics.events.BuyInGameItemEvent;
	import starling.events.Event;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ClaimBoughtChest extends CommandBase
	{
		private var free:Boolean;
		
		public function ClaimBoughtChest(free:Boolean) 
		{
			this.free = free;
			
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			if (gameManager.deactivated && PlatformServices.isIOS)
			{
				Game.addEventListener(Game.ACTIVATED, current_activatedHandler);
			}
			else
			{
				claimChest();
			}
		}
		
		private function claimChest():void 
		{
			var chestStoreItem:ChestStoreItem = gameManager.getChestItem();
			if (chestStoreItem && !free)
			{
				gameManager.analyticsManager.sendEvent(new BuyInGameItemEvent("premiumChest", 1, priceTypeToString(chestStoreItem.priceType), chestStoreItem.price));
			}
			
			var storeDialog:IDialog = DialogsManager.instance.getDialogByClassInDialogList(StoreScreen);
			if (storeDialog)
				storeDialog.close();
			
			var chestData:ChestData = new ChestData(0);
			chestData.type = ChestType.PREMIUM;
			
			if (free)
				chestData.fillFreePremiumChest();
			else	
				chestData.seed = (Math.random() * (int.MAX_VALUE - 1)) + 1;
				
			new ChestTakeOutCommand(chestData, null, null, true, free ? ChestTakeOutCommand.FREE_PREMIUM_CHEST : ChestTakeOutCommand.BOUGHT_CHEST, free ? null : chestStoreItem.priceObject).execute();
		}
		
		private function priceTypeToString(priceType:int):String 
		{
			switch(priceType)
			{
				case Type.CASH:
					return "cash";
				case Type.REAL:
					return "real";
				default:
					return "unknown";
			}
		}
		
		private function current_activatedHandler(e:Event):void 
		{
			Game.removeEventListener(Game.ACTIVATED, current_activatedHandler);
			claimChest();
		}
		
	}

}