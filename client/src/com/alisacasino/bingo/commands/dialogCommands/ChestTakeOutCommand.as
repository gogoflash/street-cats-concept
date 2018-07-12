package com.alisacasino.bingo.commands.dialogCommands 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.chests.ChestTakeOutDialog;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.TutorialManager;
	import com.alisacasino.bingo.models.chests.ChestData;
	import com.alisacasino.bingo.models.chests.ChestPowerupPack;
	import com.alisacasino.bingo.models.chests.ChestsData;
	import com.alisacasino.bingo.models.collections.CollectionItem;
	import com.alisacasino.bingo.models.notification.PushData;
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.models.skinning.SkinningData;
	import com.alisacasino.bingo.models.universal.Price;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.screens.lobbyScreenClasses.ChestSlotView;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAChestOpenedEvent;
	
	public class ChestTakeOutCommand extends CommandBase 
	{
		static public const FREE_PREMIUM_CHEST:String = "freePremiumChest";
		static public const BOUGHT_CHEST:String = "boughtChest";
		static public const FIRST_PAYMENT_OFFER_CHEST:String = "firstPaymentOfferChest";
		static public const DUST_CONVERSION:String = "dustConversion";
		static public const UNKNOWN:String = "unknown";
		static public const DEBUG:String = "debug";
		static public const CARD_EXCHANGE:String = "cardExchange";
		static public const TIMED_SLOT:String = "timedSlot";
		static public const RUSHED_SLOT:String = "rushedSlot";
		
		private var chestData:ChestData;
		
		private var needPlayerUpdate:Boolean;
		private var needPowerupUpdate:Boolean;
		
		private var completeCallback:Function;
		private var chestSlotView:ChestSlotView;
		private var dialogCanOpenOverCurrent:Boolean;
		private var chestSource:String;
		private var chestPrice:Price;
		private var handleSoundtrackVolume:Boolean;
		private var callShowReservedDrops:Boolean;
		
		public function ChestTakeOutCommand(chestData:ChestData, completeCallback:Function = null, chestSlotView:ChestSlotView = null, dialogCanOpenOverCurrent:Boolean = false, chestSource:String = UNKNOWN, chestPrice:Price = null, handleSoundtrackVolume:Boolean = true, callShowReservedDrops:Boolean = true) 
		{
			this.chestPrice = chestPrice;
			this.chestSource = chestSource;
			this.chestData = chestData.clone();
			this.chestSlotView = chestSlotView;
			this.completeCallback = completeCallback;
			this.dialogCanOpenOverCurrent = dialogCanOpenOverCurrent;
			this.handleSoundtrackVolume = handleSoundtrackVolume;
			this.callShowReservedDrops = callShowReservedDrops;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();

			if (chestSlotView) {
				PlatformServices.interceptor.cancelLocalNotification(PushData.CHEST_PUSH_ID + chestSlotView.data.id);
				PlatformServices.interceptor.cancelLocalNotification(PushData.CHEST_PUSH_ID + 10 + chestSlotView.data.id)
			}
            
            if (!gameManager.tutorialManager.allTutorialLevelsPassed)
				gameManager.analyticsManager.sendTutorialEvent('tutorialChestOpen', chestData.seed);
			
			chestData.updatePrize();
			
			Player.current.chestsOpened++;
			
			gameManager.questModel.chestOpened(chestData.type, chestData.prizes);
			
			var chestOpenDialog:ChestTakeOutDialog = new ChestTakeOutDialog(chestData, callback_chestTakeOutDialog, chestSlotView, callShowReservedDrops);
			
			var i:int;
			var length:int = chestData.prizes.length;
			var prize:*;
			for (i = 0; i < length; i++) {
				prize = chestData.prizes[i];
				if (prize is CommodityItemMessage) 
					takeOutCommodityItemMessage(prize as CommodityItemMessage);
				else if (prize is CollectionItem) 
					takeOutCollectionItem(prize as CollectionItem);
				else if (prize is ChestPowerupPack) 
					takeOutChestPowerupPack(prize as ChestPowerupPack);
				else if (prize is CustomizerItemBase)
					takeOutCustomizer(prize as CustomizerItemBase);
			}
			
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAChestOpenedEvent(chestData, chestSource, chestPrice));
			
			if(chestSlotView) {
				chestSlotView.data.clean(true);
				needPlayerUpdate = true;
			}
			
			Game.connectionManager.sendPlayerUpdateMessage();
			
			if(handleSoundtrackVolume)
				SoundManager.instance.setSoundtrackVolume(0, 500);
			
			if (chestData.isSuperTypeAssets)
				SoundManager.instance.playSfxLoop(SoundAsset.SuperChestJingleLoopV4, 3.59, 0.05, 0.05, 0.5);
			else	
				SoundManager.instance.playSfxLoop(SoundAsset.OpenChestJingleLoop, 3.15);
			
			DialogsManager.addDialog(chestOpenDialog, dialogCanOpenOverCurrent);	
		}
		
		private function takeOutCustomizer(customizerItemBase:CustomizerItemBase):void 
		{
			var userCustomizerItem:CustomizerItemBase = gameManager.skinningData.getCustomizerItemByTypeAndID(customizerItemBase.type, customizerItemBase.id);
			if (!userCustomizerItem)
			{
				return;
			}
			
			if (userCustomizerItem.quantity <= 0)
			{
				gameManager.skinningData.newCustomizerItems.push(userCustomizerItem);
			}
			
			userCustomizerItem.quantity += 1;
			
			gameManager.questModel.cardCollected(userCustomizerItem);
			
			if(!userCustomizerItem.uiAsset.loaded)
				userCustomizerItem.uiAsset.load(null, null);
		}
		
		private function takeOutCommodityItemMessage(item:CommodityItemMessage):void 
		{
			if (item.type == Type.CASH)
			{
				Player.current.updateCashCount(item.quantity, "chestOpened:" + ChestsData.chestTypeToString(chestData.type));
				Player.current.reservedCashCount += item.quantity;
				needPlayerUpdate = true;
			}
			else {
				sosTrace("ChestTakeOutCommand can't take out unknown CommodityItemMessage. Type: ", item.type, SOSLog.ERROR);
			}
		}
		
		private function takeOutCollectionItem(item:CollectionItem):void 
		{
			var userCollectionItem:CollectionItem = gameManager.collectionsData.getItemByID(item.id);
			gameManager.questModel.cardCollected(userCollectionItem);
			if (userCollectionItem) 
			{
				if (!userCollectionItem.owned)
				{
					gameManager.collectionsData.newCollectionItems.push(userCollectionItem);
				}
				
				userCollectionItem.owned = true;
				userCollectionItem.duplicates += 1;
				needPlayerUpdate = true;
			}
		}
		
		private function takeOutChestPowerupPack(item:ChestPowerupPack):void 
		{
			var key:String;
			for (key in item.powerupData) {
				gameManager.powerupModel.addPowerup(key, int(item.powerupData[key]), "chestOpened:" + ChestsData.chestTypeToString(chestData.type));
				needPlayerUpdate = true;
			}
			
			gameManager.powerupModel.reservedPowerupsCount += item.totalQuantity;
		}
		
		private function callback_chestTakeOutDialog(chestTakeOutDialog:ChestTakeOutDialog):void
		{
			SoundManager.instance.stopSfxLoop(SoundAsset.SuperChestJingleLoopV4, 0.3);
			SoundManager.instance.stopSfxLoop(SoundAsset.OpenChestJingleLoop, 0.3);
			
			if(handleSoundtrackVolume)
				SoundManager.instance.setSoundtrackVolume(SoundManager.BACKGROUND_VOLUME, 500);
			
			if (chestSlotView) {
				chestSlotView.data.clean(false);
				chestTakeOutDialog.chestSlotView.invalidate();
			}
			
			if (completeCallback)
				completeCallback();
		}
		
	}

}