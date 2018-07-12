package com.alisacasino.bingo.commands.player 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.dialogCommands.ChestTakeOutCommand;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.chests.ChestData;
	import com.alisacasino.bingo.models.chests.WeightedList;
	import com.alisacasino.bingo.models.collections.Collection;
	import com.alisacasino.bingo.models.collections.CollectionItem;
	import com.alisacasino.bingo.models.collections.CollectionPage;
	import com.alisacasino.bingo.models.collections.CollectionsData;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.models.powerups.PowerupDropTable;
	import com.alisacasino.bingo.models.powerups.PowerupModel;
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.models.skinning.CustomizerSet;
	import com.alisacasino.bingo.models.skinning.SkinningData;
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.protocol.CardType;
	import com.alisacasino.bingo.utils.TimeService;
	
	public class CollectCommodityItems extends CommandBase 
	{
		private var commodities:Array;
		private var source:String;
		private var lobbyBarsUpdateDelay:Number = 0;
		private var sendPlayerUpdate:Boolean;
		private var updateLobbyBars:Boolean;
		
		private var _collectionRaritiesWeightedList:WeightedList;
		//private var _collectedCommodities:Array;
		
		public var storeChests:Boolean;
		
		public function CollectCommodityItems(commodities:Array, source:String, sendPlayerUpdate:Boolean = true, updateLobbyBars:Boolean = true, lobbyBarsUpdateDelay:Number = 0) 
		{
			super();
			this.commodities = commodities;
			this.source = source;
			this.sendPlayerUpdate = sendPlayerUpdate;
			this.updateLobbyBars = updateLobbyBars;
			this.lobbyBarsUpdateDelay = lobbyBarsUpdateDelay;
			
			//_collectedCommodities = [];
		}
		
		/*public function get collectedCommodities():Array {
			return _collectedCommodities;
		}*/
		
		public function set collectionRaritiesWeightedList(value:WeightedList):void 
		{
			_collectionRaritiesWeightedList = value;
		}
		
		public function get collectionRaritiesWeightedList():WeightedList 
		{
			if (!_collectionRaritiesWeightedList) 
			{
				// default RaritiesWeightedList for collection. Like the Gold chest;
				_collectionRaritiesWeightedList = new WeightedList();
				_collectionRaritiesWeightedList.addWeightedItem(CardType.NORMAL, 120);
				_collectionRaritiesWeightedList.addWeightedItem(CardType.MAGIC, 8);
				_collectionRaritiesWeightedList.addWeightedItem(CardType.RARE, 1);
			}	
			return _collectionRaritiesWeightedList;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			var item:Object;
			for each (item in commodities) 
			{
				if (item is CommodityItem)
					collectCommodity(item as CommodityItem);
			}
			
			if(updateLobbyBars)
				new UpdateLobbyBarsTrueValue(lobbyBarsUpdateDelay).execute();
			
			if (sendPlayerUpdate)
				Game.connectionManager.sendPlayerUpdateMessage();
			
			finish();
		}
		
		private function collectCommodity(item:CommodityItem):void 
		{
			var player:Player = Player.current;
			var powerUpsRaw:Object;
			var customizerItem:CustomizerItemBase;
			var customizers:Array = [];
			var cards:Array = [];
			var i:int;
			
			switch(item.type)
			{
				case CommodityType.CASH: 
				{
					player.updateCashCount(item.quantity, source);
					player.reservedCashCount += item.quantity; 
					break;
				}
				case CommodityType.POWERUP_CARD: 
				{
					powerUpsRaw = PowerupModel.createByRarityAndCount(item.subType, item.quantity);
					addPowerupsToPlayer(powerUpsRaw)
					item.data = powerUpsRaw;
					break;
				}
				case CommodityType.POWERUP: 
				{
					if (Powerup.allRarities.indexOf(item.subType) != -1) {
						powerUpsRaw = PowerupModel.createByRarityAndCount(item.subType, item.quantity);
					}
					else if (Powerup.allPowerUps.indexOf(item.subType) != -1) {
						powerUpsRaw = {};
						powerUpsRaw[item.subType] = item.quantity;
					}
					
					addPowerupsToPlayer(powerUpsRaw);
					item.data = powerUpsRaw;
					break;
				}
				case CommodityType.COLLECTION: 
				{
					cards = [];
					var currentCollection:Collection = gameManager.tournamentData.collection;
					var page:CollectionPage;
					var card:CollectionItem;
					var userCollectionItem:CollectionItem;
					var predefinedRarity:Boolean = CollectionsData.allRarities.indexOf(parseInt(item.subType)) != -1;
					var rarity:int; 
					for (i = 0; i < item.quantity; i++) 
					{
						var forCurrentPage:Boolean = Math.random() > gameManager.collectionsData.completedPageProbabilty;
						page = currentCollection.getCurrentPage();
						
						if (!forCurrentPage || !page)
						{
							var randomCompletedPage:CollectionPage = currentCollection.getRandomCompletedPage(Math.random());
							if(randomCompletedPage)
								page = randomCompletedPage;
						}
						
						rarity = predefinedRarity ? parseInt(item.subType) : collectionRaritiesWeightedList.getRandomDrop(Math.random());
						
						if (page)
							card = page.getRandomCard(rarity, Math.random());
						
						if (!card)
							card = gameManager.collectionsData.getRandomCollectionItem(rarity);
							
						if (card)
						{
							cards.push(card);	
							
							userCollectionItem = gameManager.collectionsData.getItemByID(card.id);
							if (userCollectionItem) 
							{
								if (!userCollectionItem.owned)
									gameManager.collectionsData.newCollectionItems.push(userCollectionItem);
								
								userCollectionItem.owned = true;
								userCollectionItem.duplicates += 1;
								
								gameManager.collectionsData.collectionDropItems.push(userCollectionItem);
								
								gameManager.analyticsManager.sendCommodityAddedEvent(item.type + ":" + userCollectionItem.id.toString(), 1, source);
							}
						}
					}
					
					item.data = cards;
					
					break;
				}
				case CommodityType.CUSTOMIZER: 
				{
					customizers = [];
					
					for (i = 0; i < item.quantity; i++) 
					{
						if (item.subType == null || item.subType == '')
							customizerItem = gameManager.skinningData.dropList.getRandomDrop(Math.random());
						else if (SkinningData.isCustomizerSubtype(item.subType))
							customizerItem = gameManager.skinningData.dropList.getRandomDrop(Math.random());
						else
							customizerItem = gameManager.skinningData.getCustomizerByUID(item.subType);
							
						if (customizerItem) {
							addCustomizerToPlayer(customizerItem, 1);
							customizers.push(customizerItem);
							
							gameManager.skinningData.customizerDropItems.push(customizerItem);
							
							gameManager.analyticsManager.sendCommodityAddedEvent(item.type + ":" + customizerItem.id.toString(), 1, source);
						}
					}	
					
					item.data = customizers;
					
					break;
				}
				case CommodityType.SCORE: 
				{
					player.currentLiveEventScore += item.quantity;
					break;
				}
				case CommodityType.CUSTOMIZER_SET: 
				{
					customizers = [];
					var customizerSet:CustomizerSet = gameManager.skinningData.getSetByID(parseInt(item.subType));
					if (customizerSet) 
					{
						if (customizerSet.cardBack) {
							addCustomizerToPlayer(customizerSet.cardBack, 1);
							customizers.push(customizerSet.cardBack);
							gameManager.skinningData.customizerDropItems.push(customizerSet.cardBack);
						}
						
						if (customizerSet.dauber) {
							addCustomizerToPlayer(customizerSet.dauber, 1);
							customizers.push(customizerSet.dauber);
							gameManager.skinningData.customizerDropItems.push(customizerSet.dauber);
						}
						
						gameManager.analyticsManager.sendCommodityAddedEvent(item.type + ":" + customizerSet.id.toString(), 1, source);
					}
					
					item.data = customizers;
					
					break;
				}
				case CommodityType.CHEST: 
				{
					//gameManager.analyticsManager.sendCommodityAddedEvent(item.type, item.quantity, source);
					if(storeChests)
					{
						gameManager.chestsData.pushStoredChest(parseInt(item.subType), TimeService.serverTime, source);
					}
					else
					{
						var chestData:ChestData = new ChestData();
						chestData.type = parseInt(item.subType);
						chestData.seed = (Math.random() * (int.MAX_VALUE - 1)) + 1;
						new ChestTakeOutCommand(chestData, null, null, true, source, null).execute();
					}
					
					break;
				}
				case CommodityType.DUST: 
				{
					player.reservedDustCount += item.quantity;
					player.updateDustCount(item.quantity, source);
					break;
				}
				case CommodityType.SLOT_FREE_SPINS: 
				{
					gameManager.slotsModel.freeSpins += item.quantity;
				}
				default: 
				{
					sosTrace("CollectCommodityItems: could not find handler for commodity type " + item.type, SOSLog.ERROR);
					break;
				}
			}
		}
		
		private function addCustomizerToPlayer(customizerItem:CustomizerItemBase, quantity:int):void 
		{
			if (!customizerItem)
				return;
				
			var userCustomizerItem:CustomizerItemBase = gameManager.skinningData.getCustomizerItemByTypeAndID(customizerItem.type, customizerItem.id);
			if (!userCustomizerItem)
				return;
				
			if (userCustomizerItem.quantity <= 0)
				gameManager.skinningData.newCustomizerItems.push(userCustomizerItem);
			
			userCustomizerItem.quantity += quantity;
			
			if(!userCustomizerItem.uiAsset.loaded)
				userCustomizerItem.uiAsset.load(null, null);
		}
		
		private function addPowerupsToPlayer(powerupsRaw:Object):void 
		{
			if (!powerupsRaw)
				return;
				
			var powerupType:String;
			var totalQuantity:int;
			for (powerupType in powerupsRaw)
			{
				gameManager.powerupModel.addPowerup(powerupType, powerupsRaw[powerupType], source);
				totalQuantity += powerupsRaw[powerupType];
			}
			
			gameManager.powerupModel.reservedPowerupsCount += totalQuantity;
		}
	}

}