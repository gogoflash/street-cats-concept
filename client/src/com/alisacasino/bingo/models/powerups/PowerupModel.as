package com.alisacasino.bingo.models.powerups 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.ReconnectDialog;
	import com.alisacasino.bingo.models.chests.WeightedList;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.GenericDropDataMessage;
	import com.alisacasino.bingo.protocol.PlatformShopPowerupDropMessage;
	import com.alisacasino.bingo.protocol.PowerupInfoMessage;
	import com.alisacasino.bingo.protocol.PowerupType;
	import com.alisacasino.bingo.protocol.PowerupWeightMessage;
	import com.alisacasino.bingo.protocol.SignInMessage.Platform;
	import com.alisacasino.bingo.protocol.StaticDataMessage;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.store.items.PowerupPackStoreItem;
	import com.alisacasino.bingo.utils.Settings;
	import com.alisacasino.bingo.utils.analytics.AnalyticsManager;
	import starling.core.Starling;
	import starling.events.EventDispatcher;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class PowerupModel extends EventDispatcher
	{
		public static const EVENT_UPDATE:String = 'POWERUP_UPDATE';
		
		public static var DEBUG:Boolean = false;
		
		private var powerupTableByID:Object;
		private var commonPowerups:Vector.<String>;
		private var magicPowerups:Vector.<String>;
		private var rarePowerups:Vector.<String>;
		private var rarePowerupsMinigameDisabled:Vector.<String>;
		private var defaultTable:Array;
		private var rarityByPowerup:Object = { };
		
		public var roundEndDropTable:PowerupDropTable;
		public var tournamentEndDropTable:PowerupDropTable;
		
		public var powerupCount:Object;
		public var storeDropTable:StoreDropTable;
		public var chestDropTable:PowerupDropTable;
		public var collectionPageDropTable:PowerupDropTable;
		
		private var freePowerupType:String;
		
		private static var debugIndex:int;
		private var total:int;
		private var _reservedPowerupsCount:int; 
		private var cleanReservedPowerupsCountId:int = -1;
		private var minigameDropTable:WeightedList;
		
		public function PowerupModel() 
		{
			powerupTableByID = { };
			powerupCount = { };
			
			commonPowerups = new <String>[Powerup.DAUB, Powerup.XP, Powerup.CASH];
			magicPowerups = new <String>[Powerup.DOUBLE_DAUB, Powerup.SCORE, Powerup.X2];
			rarePowerups = new <String>[Powerup.TRIPLE_DAUB, Powerup.INSTABINGO, Powerup.MINIGAME];
			rarePowerupsMinigameDisabled = new <String>[Powerup.TRIPLE_DAUB, Powerup.INSTABINGO];
			
			setRarities(commonPowerups, Powerup.RARITY_NORMAL);
			setRarities(magicPowerups, Powerup.RARITY_MAGIC);
			setRarities(rarePowerups, Powerup.RARITY_RARE);
			
			/*
			var cap:int = 0;
			
			powerupCount[Powerup.CASH] = int(Math.random() * cap);
			powerupCount[Powerup.DAUB] = int(Math.random() * cap);
			powerupCount[Powerup.DOUBLE_DAUB] = int(Math.random() * cap);
			powerupCount[Powerup.INSTABINGO] = int(Math.random() * cap);
			powerupCount[Powerup.MINIGAME] = int(Math.random() * cap);
			powerupCount[Powerup.SCORE] = int(Math.random() * cap);
			powerupCount[Powerup.TRIPLE_DAUB] = int(Math.random() * cap);
			powerupCount[Powerup.X2] = int(Math.random() * cap);
			powerupCount[Powerup.XP] = int(Math.random() * cap);
			*/
			//freePowerupType = Powerup.DAUB;
		}
		
		private function setRarities(list:Vector.<String>, rarity:String):void 
		{
			for each (var item:String in list) 
			{
				rarityByPowerup[item] = rarity;
			}
		}
		
		public function getRarity(powerup:String):String
		{
			return rarityByPowerup[powerup];
		}
	
		public function getCommonPowerups():Vector.<String>
		{
			return commonPowerups;
		}
		
		public function getMagicPowerups():Vector.<String>
		{
			return magicPowerups;
		}
		
		public function getRarePowerups():Vector.<String>
		{
			if (Settings.instance.minigamePowerupsEnabled)
			{
				return rarePowerups;
			}
			return rarePowerupsMinigameDisabled;
		}
		
		public function deserializeStaticData(staticData:StaticDataMessage):void
		{
			var powerupDataList:Array = staticData.powerupsInfo;
			for each (var item:PowerupInfoMessage in powerupDataList) 
			{
				var table:Array = [];
				for each (var weightMessage:PowerupWeightMessage in item.weights) 
				{
					var powerup:String = getPowerupByID(weightMessage.type);
					table[powerup] = weightMessage.weight;
				}
				powerupTableByID[item.id] = table;
				
				//TODO: define table IDs
				defaultTable = table;
			}
			
			roundEndDropTable = new PowerupDropTable().deserialize(staticData.powerupDrop.roundPowerupDrop);
			tournamentEndDropTable = new PowerupDropTable().deserialize(staticData.powerupDrop.tournamentPowerupDrop);
			chestDropTable = new PowerupDropTable().deserialize(staticData.powerupDrop.chestPowerupDrop);
			collectionPageDropTable = new PowerupDropTable().deserialize(staticData.powerupDrop.collectionPagePowerupDrop);
			
			for each (var platformDrop:PlatformShopPowerupDropMessage in staticData.powerupDrop.shopPowerupDrop) 
			{
				if (platformDrop.platform == PlatformServices.platform)
				{
					storeDropTable = new StoreDropTable().deserialize(platformDrop);
				}
			}
			
			
			parseMinigameDropTable(staticData.genericDropData);
		}
		
		private function parseMinigameDropTable(genericDropData:Array):void 
		{
			minigameDropTable = new WeightedList();
			for each (var item:GenericDropDataMessage in genericDropData) 
			{
				if (item.type == "minigameDrop")
				{
					minigameDropTable.addWeightedItem(Minigame.minigameFromWeightTable(item.entry), item.weight);
				}
			}
		}
		
		static public function getPowerupByID(type:int):String
		{
			switch(type)
			{
				case PowerupType.POWERUP_CASH:
					return Powerup.CASH;
				case PowerupType.POWERUP_DAUB:
					return Powerup.DAUB;
				case PowerupType.POWERUP_DOUBLE_DAUB:
					return Powerup.DOUBLE_DAUB;
				case PowerupType.POWERUP_INSTABINGO:
					return Powerup.INSTABINGO;
				case PowerupType.POWERUP_MINIGAME:
					return Powerup.MINIGAME;
				case PowerupType.POWERUP_SCORE:
					return Powerup.SCORE;
				case PowerupType.POWERUP_TRIPLE_DAUB:
					return Powerup.TRIPLE_DAUB;
				case PowerupType.POWERUP_X2:
					return Powerup.X2;
				case PowerupType.POWERUP_XP:
					return Powerup.XP;
			}
			
			sosTrace("Could not find powerup type for id " + type, SOSLog.ERROR);
			return Powerup.DAUB;
		}
		
		public function getTableByID(id:int):Object
		{
			return powerupTableByID[id];
		}
		
		public function getRandomPowerup():String
		{
			if (DEBUG) {
				var types:Vector.<String> = Powerup.allPowerUps;
				if (debugIndex > types.length -1 )
					debugIndex = 0;
				
				return Powerup.allPowerUps[debugIndex++];
			}
			
			var availablePowerups:Array = [];
			var totalWeight:Number = 0;
			
			for (var powerupType:String in powerupCount) 
			{
				if (powerupCount[powerupType] > 0)
				{
					totalWeight += powerupCount[powerupType];
					availablePowerups.push({powerupType:powerupType, weight:totalWeight});
				}
			}
			
			var weightedRandom:Number = Math.random() * totalWeight;
			
			while (availablePowerups.length)
			{
				var weightedPowerup:Object = availablePowerups.shift();
				if (weightedPowerup.weight >= weightedRandom)
				{
					return weightedPowerup.powerupType;
				}
			}
			
			return null;
		}
		
		public function getPowerupCount(powerupType:String):int
		{
			return powerupCount[powerupType];
		}
		
		public function addPowerup(powerup:String, quantity:int, source:String):void 
		{
			if (powerupCount.hasOwnProperty(powerup))
				powerupCount[powerup] += quantity;
			else
				powerupCount[powerup] = quantity;
			
			total += quantity;
			sendUpdate();
			gameManager.analyticsManager.sendCommodityAddedEvent(CommodityType.POWERUP + ":" + powerup, quantity, source);
		}
		
		public function sendUpdate():void 
		{
			dispatchEventWith(EVENT_UPDATE);
			gameManager.connectionManager.sendPlayerUpdateMessage();
		}
		
		public function deserializePlayerPowerups(account:Array):void 
		{
			total = 0;
			powerupCount = { };
			
			for each (var item:CommodityItemMessage in account) 
			{
				if (item.type != Type.POWERUP)
					continue;
					
				var powerupType:String = "";
					
				powerupType = getPowerupByID(item.powerupType);
				
				if (powerupType.length > 0)
				{
					//item.quantity = 1;
					
					powerupCount[powerupType] = item.quantity;
					total += item.quantity;
				}
			}
			
			dispatchEventWith(EVENT_UPDATE);
		}
		
		public function getPowerupCommodities():Array
		{
			var commodityItemMessages:Array = [];
			for (var powerupType:String in powerupCount) 
			{
				
				var message:CommodityItemMessage = new CommodityItemMessage();
				message.type = Type.POWERUP;
				message.powerupType = getMessagePowerupTypeByID(powerupType);
				
				if (message.powerupType == -1 || powerupCount[powerupType] <= 0)
				{
					continue;
				}
				
				message.quantity = powerupCount[powerupType];
				
				commodityItemMessages.push(message);
			}
			
			var duplicateCheck:Array = [];
			for each (var item:CommodityItemMessage in commodityItemMessages) 
			{
				if (duplicateCheck.indexOf(item.powerupType) != -1)
				{
					throw new Error("Duplicate powerup detected");
				}
				duplicateCheck.push(item.powerupType);
			}
			
			return commodityItemMessages;
		}
		
		public static function getMessagePowerupTypeByID(powerupType:String):int 
		{
			switch(powerupType)
			{
				case Powerup.CASH:
					return PowerupType.POWERUP_CASH;
					break;
				case Powerup.DAUB:
					return PowerupType.POWERUP_DAUB;
					break;
				case Powerup.DOUBLE_DAUB:
					return PowerupType.POWERUP_DOUBLE_DAUB;
					break;
				case Powerup.INSTABINGO:
					return PowerupType.POWERUP_INSTABINGO;
					break;
				case Powerup.SCORE:
					return PowerupType.POWERUP_SCORE;
					break;
				case Powerup.TRIPLE_DAUB:
					return PowerupType.POWERUP_TRIPLE_DAUB;
					break;
				case Powerup.X2:
					return PowerupType.POWERUP_X2;
					break;
				case Powerup.XP:
					return PowerupType.POWERUP_XP;
					break;
				case Powerup.MINIGAME:
					return PowerupType.POWERUP_MINIGAME;
					break;
				default:
					return -1;
					break;
			}
		}
		
		public function isFreePowerup(type:String):Boolean
		{
			return freePowerupType == type;
		}
		
		public function addPowerupsFromPack(powerupPackStoreItem:PowerupPackStoreItem):Object 
		{
			var purchasedPowerupList:Object = { };
			var storeDropTable:PowerupDropTable = gameManager.powerupModel.storeDropTable.getDropTableForItem(powerupPackStoreItem.dropTableItemID);
			var purchaseSource:String = "storeItem:" + powerupPackStoreItem.itemId;
			
			if (!storeDropTable) {
				var errorDialog:ReconnectDialog = new ReconnectDialog(ReconnectDialog.TYPE_ERORR, 'ERROR', "Can't found drop table for dropTableItemID: " + String(powerupPackStoreItem.dropTableItemID) + ', itemID: ' + String(powerupPackStoreItem.itemID));
				DialogsManager.addDialog(errorDialog, true, true);
				return {};
			}
			
			addBoughtPowerups(powerupPackStoreItem.normalQuantity, storeDropTable.normalDrop, purchasedPowerupList, purchaseSource);
			addBoughtPowerups(powerupPackStoreItem.magicQuantity, storeDropTable.magicDrop, purchasedPowerupList, purchaseSource);
			addBoughtPowerups(powerupPackStoreItem.rareQuantity, storeDropTable.rareDrop, purchasedPowerupList, purchaseSource, true);
			Game.connectionManager.sendPlayerUpdateMessage();
			return purchasedPowerupList;
		}
		
		public function addPowerupsFromDrop(quantity:Number, powerupDropTable:PowerupDropTable, source:String):Object 
		{
			var totalGivenOut:Object = { };
			if (!powerupDropTable)
			{
				sosTrace("No drop table specified for drop!", new Error().getStackTrace(), SOSLog.ERROR);
				return totalGivenOut;
			}
			for (var i:int = 0; i < quantity; i++) 
			{
				var powerupToDrop:String = powerupDropTable.getRandomDrop();
				if (totalGivenOut.hasOwnProperty(powerupToDrop))
				{
					totalGivenOut[powerupToDrop] += 1;
				}
				else
				{
					totalGivenOut[powerupToDrop] = 1;
				}
			}
			
			for (var powerup:String in totalGivenOut)
			{
				addPowerup(powerup, totalGivenOut[powerup], source);
				
			}
			
			return totalGivenOut;
		}
		
		private function addBoughtPowerups(quantity:int, dropTable:WeightedPowerupDropList, purchaseTotal:Object, source:String, guaranteeAtLeastOne:Boolean = false):void 
		{
			var rarityPurchaseTotal:Object = { };
			
			if (guaranteeAtLeastOne && quantity >= dropTable.weights.length)
			{
				for each (var item:WeightedPowerup in dropTable.weights) 
				{
					if (rarityPurchaseTotal.hasOwnProperty(item.type))
					{
						rarityPurchaseTotal[item.type] += 1;
					}
					else
					{
						rarityPurchaseTotal[item.type] = 1;
					}
					quantity--;
				}
			}
			
			
			for (var i:int = 0; i < quantity; i++) 
			{
				var powerup:String = dropTable.getRandomDrop();
				if (rarityPurchaseTotal)
				{
					if (rarityPurchaseTotal.hasOwnProperty(powerup))
					{
						rarityPurchaseTotal[powerup] += 1;
					}
					else
					{
						rarityPurchaseTotal[powerup] = 1;
					}
				}
			}
			
			for (powerup in rarityPurchaseTotal) 
			{
				addPowerup(powerup, rarityPurchaseTotal[powerup], source);
				if (purchaseTotal.hasOwnProperty(powerup))
				{
					purchaseTotal[powerup] += rarityPurchaseTotal[powerup];
				}
				else
				{
					purchaseTotal[powerup] = rarityPurchaseTotal[powerup];
				}
			}
			
			sendUpdate();
		}
		
		public function get powerupsTotal():int
		{
			return total;
		}
		
		public function set reservedPowerupsCount(value:int):void {
			_reservedPowerupsCount = value;
		}
		
		public function get reservedPowerupsCount():int {
			return _reservedPowerupsCount;
		}
		
		public function cleanReservedPowerupsCount(delay:Number = 0):void 
		{
			if (_reservedPowerupsCount == 0)
				return;
				
			if (cleanReservedPowerupsCountId != -1) {
				Starling.juggler.removeByID(cleanReservedPowerupsCountId);
				cleanReservedPowerupsCountId = -1;
			}
			
			if (delay == 0)
				_reservedPowerupsCount = 0;
			else
				cleanReservedPowerupsCountId = Starling.juggler.delayCall(cleanReservedPowerupsCount, delay, 0);
		}
		
		public function addPowerupFromMessage(item:CommodityItemMessage, source:String):void 
		{
			if (item.type != Type.POWERUP)
				return;
			
			addPowerup(getPowerupByID(item.powerupType), item.quantity, source);
		}
		
		public static function getEarnedPowerup(usedCount:int):int 
		{
			return Math.floor(Math.sqrt(usedCount - 2));
		}
		
		public static function createByRarityAndCount(rarity:String, count:int):Object
		{
			var raw:Object = {};
			
			var sourceVector:Vector.<String>;
			switch(rarity) {
				case Powerup.RARITY_NORMAL: 
					sourceVector = gameManager.powerupModel.getCommonPowerups();
					break;
				case Powerup.RARITY_MAGIC: 
					sourceVector = gameManager.powerupModel.getMagicPowerups();
					break;
				case Powerup.RARITY_RARE: 
					sourceVector = gameManager.powerupModel.getRarePowerups();
					break;	
				
				default	: break;	
			}
			
			if (!sourceVector || sourceVector.length == 0)
				return null;
			
			var randomPowerup:String;
			
			while (count > 0) 
			{
				randomPowerup = sourceVector[Math.floor(Math.random() * sourceVector.length)];
				
				if (randomPowerup in raw)
					raw[randomPowerup]++;
				else
					raw[randomPowerup] = 1;
				
				count--;
			}
			
			return raw;
		}
		
		public function debugRemovePowerup():void 
		{
			for (var powerupType:String in powerupCount) 
			{
				if (powerupCount[powerupType] > 0)
				{
					powerupCount[powerupType]--;
					total--;
				}
			}
		}
		
		public function getRandomMinigameDrop():Minigame
		{
			var minigameDrop:Minigame = minigameDropTable.getRandomDrop() as Minigame;
			if (!minigameDrop || minigameDrop.quantity < 1)
			{
				return new Minigame(PowerupType.SPIN_5, 1);
			}
			return minigameDrop;
		}
	}

}