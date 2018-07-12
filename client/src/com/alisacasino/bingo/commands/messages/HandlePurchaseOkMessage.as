package com.alisacasino.bingo.commands.messages 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.player.ClaimBoughtChest;
	import com.alisacasino.bingo.commands.player.UpdateLobbyBarsTrueValue;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.controls.LoadingWheel;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.IDialog;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.chests.ChestData;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.protocol.PurchaseOkMessage;
	import com.alisacasino.bingo.screens.IScreen;
	import com.alisacasino.bingo.screens.storeWindow.StoreScreen;
	import com.alisacasino.bingo.store.IStoreItem;
	import com.alisacasino.bingo.store.items.ChestStoreItem;
	import com.alisacasino.bingo.store.items.OfferStoreItem;
	import com.alisacasino.bingo.store.items.PowerupPackStoreItem;
	import com.alisacasino.bingo.utils.Settings;
	import com.alisacasino.bingo.utils.TimeService;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAStoreItemTransactionEvent;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAStoreTransactionStateEvent;
	
	public class HandlePurchaseOkMessage extends CommandBase
	{
		private var message:PurchaseOkMessage;
		
		public function HandlePurchaseOkMessage(message:PurchaseOkMessage) 
		{
			this.message = message;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			LoadingWheel.removeIfAny();
			
			var item:IStoreItem = gameManager.storeData.findItemByItemId(message.itemId);
			var purchasedPowerups:Object;
			var callUpdateLobbyBarsTrueValue:Boolean = true;
			
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreTransactionStateEvent(DDNAStoreTransactionStateEvent.PURCHASE_SUCCEDED_ON_SERVER, message.itemId));
			
			if (!item) {
				gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreTransactionStateEvent(DDNAStoreTransactionStateEvent.FAILED_TO_FIND_ITEM_FOR_SUCCESSFUL_PURCHASE, message.itemId));
				finish();
				return;
			}
			
			gameManager.lastPaymentTime = TimeService.serverTime;
			
			if (item is PowerupPackStoreItem)
			{
				purchasedPowerups = gameManager.powerupModel.addPowerupsFromPack(item as PowerupPackStoreItem);
				gameManager.powerupModel.reservedPowerupsCount += item.totalQuantity;
				Player.current.lifetimeValue += item.value;
			}
			else if (item is ChestStoreItem)
			{
				new ClaimBoughtChest(false).execute();
				Player.current.lifetimeValue += item.value;
			}
			else if (item is OfferStoreItem)
			{
				callUpdateLobbyBarsTrueValue = false;
				gameManager.offerManager.claimBoughtOffer(item as OfferStoreItem);
				Player.current.lifetimeValue += item.value;
			}
			else if(item)
			{
				Player.current.consumeStoreItem(item);
			}
			
			Game.connectionManager.sendPlayerUpdateMessage();
			
			PlatformServices.store.consumeItem(item);
				
			var storeWindow:StoreScreen = DialogsManager.instance.getDialogByClass(StoreScreen) as StoreScreen;
			if (storeWindow)
			{
				callUpdateLobbyBarsTrueValue = false;
				storeWindow.handlePurchaseCompleted(item, purchasedPowerups);
			}
			
			if(callUpdateLobbyBarsTrueValue)
				new UpdateLobbyBarsTrueValue().execute();
			
			if (!Player.current.isAdmin)
			{
				gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreItemTransactionEvent(item, purchasedPowerups));
			}
			
			
			PlatformServices.interceptor.trackPurchase(item);
			
			finish();
		}
		
	}

}