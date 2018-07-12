package com.alisacasino.bingo.models.chests 
{
	import adobe.utils.CustomActions;
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.collections.CollectionItem;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.protocol.CardType;
	import com.alisacasino.bingo.protocol.ChestDropDataMessage;
	import com.alisacasino.bingo.protocol.ChestDropMessage;
	import com.alisacasino.bingo.protocol.ChestSlotMessage;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.protocol.ChestWinMessage;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.PlayerMessage;
	import com.alisacasino.bingo.protocol.StaticDataMessage;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.utils.Constants;
	import starling.core.Starling;
	import starling.events.EventDispatcher;
	
	public class ChestsData extends EventDispatcher
	{
		private var dropByType:Object;
		
		public var chestRewardGenerator:ChestRewardGenerator;
		
		public static var DEBUG_MODE:Boolean = false;
		
		public static const EVENT_REMOVE_AWARD_GIVE_OUT_CHEST:String = "EVENT_REMOVE_AWARD_GIVE_OUT_CHEST";
		
		public static const EVENT_CLOSE_CHEST_OPEN_DIALOG:String = "EVENT_CLOSE_CHEST_OPEN_DIALOG";
		
		public static const EVENT_ACCELERATE_CHEST_TAKE_OUT_DIALOG:String = "EVENT_ACCELERATE_CHEST_TAKE_OUT_DIALOG";
		
		public static const EVENT_FREE_CHEST_CLAIM:String = "EVENT_FREE_CHEST_CLAIM";
		
		private static const KEY_STORED_CHESTS:String = "STORED_CHESTS";
		
		public static var CHESTS_COUNT:Number = 4;
		
		public static var STORE_CHEST_UNLOCK_LEVEL:Number = 4;
		
		public var chests:Vector.<ChestData>;
		
		private var dropCountsByType:Object;
		
		private var staticDataByType:Object;
		
		private var _storedChests:Vector.<StoredChest>;
		
		//public var awardGiveOutChest:ChestData;
		
		
		public function ChestsData() {
			chests = new Vector.<ChestData>();
			chestRewardGenerator = new ChestRewardGenerator();
			
			dropCountsByType = {};
			staticDataByType = {};
			
			var i:int;
			while(chests.length < CHESTS_COUNT) {
				chests.push(new ChestData(i++));
			}
		}
		
		public function deserialize(message:PlayerMessage):void 
		{
			if (!message) {
				return;
			}
			
			//sosTrace('ChestsData.deserialize', message.chestSlots.length, SOSLog.DEBUG);
			//trace('ChestsData.deserialize', message.chestSlots.length);
			
			var i:int;
			var length:int = message.chestSlots.length;
			for (i = 0; i < length; i++) {
				if (i < chests.length)
					chests[i].deserialize(message.chestSlots[i] as ChestSlotMessage);
				
				//sosTrace('ChestsData.deserialize 1', (message.chestSlots[i] as ChestSlotMessage).type, SOSLog.DEBUG);	
				//trace('ChestsData.deserialize type', i, (message.chestSlots[i] as ChestSlotMessage).type);
			}
	
			/*chests[1].type = ChestType.BRONZE;
			chests[1].openTimestamp = 1502181791 - 60 * 60 * 2;
			chests[1].seed = Math.random() * (int.MAX_VALUE - 1) + 1;
			chests[1].prizes = chests[1].getRewards();// [1, 2, 3];
			
			chests[2].type = ChestType.SUPER;
			chests[2].openTimestamp = 1529598605 + 200;
			chests[2].seed = Math.random() * (int.MAX_VALUE - 1) + 1;
			chests[2].prizes = chests[2].getRewards();*/
			
			/*chests[0].type = ChestType.GOLD;
			//chests[0].openTimestamp = 1509573645;
			chests[0].seed = Math.random() * (int.MAX_VALUE - 1) + 1;
			chests[0].prizes = chests[0].getRewards();
			
			chests[3].type = ChestType.SILVER;
			chests[3].openTimestamp = 1502181791;
			chests[3].seed = Math.random() * (int.MAX_VALUE - 1) + 1;
			chests[3].prizes = chests[3].getRewards();*/
			
			//chests[3].fillChest(ChestType.GOLD, false, 7, 0, new < uint > [1], new < int > [CardType.NORMAL, CardType.MAGIC, CardType.RARE], new < ChestPowerupPack > [ChestPowerupPack.create(Powerup.RARITY_NORMAL, {daub:1, cash:1})]);
			
			//chests[0].fillChest(ChestType.SUPER, false, 7, 0, new < uint > [1, 2], new < int > [CardType.NORMAL, CardType.MAGIC, CardType.RARE], new < ChestPowerupPack > [ChestPowerupPack.create(Powerup.RARITY_NORMAL, {daub:1, cash:1})]);
			/*chests[1].fillChest(ChestType.SUPER, false, 7, 0, new < uint > [1, 4], new < int > [CardType.NORMAL, CardType.MAGIC, CardType.RARE, CardType.MAGIC, CardType.RARE], new < ChestPowerupPack > [ChestPowerupPack.create(Powerup.RARITY_NORMAL, {daub:1, cash:1})]);
			chests[2].fillChest(ChestType.SUPER, false, 7, 0, new < uint > [1, 5, 6], new < int > [CardType.NORMAL, CardType.MAGIC, CardType.RARE, CardType.MAGIC, CardType.RARE, CardType.NORMAL], new < ChestPowerupPack > [ChestPowerupPack.create(Powerup.RARITY_NORMAL, {daub:1, cash:1})]);
			chests[3].fillChest(ChestType.SUPER, false, 7, 0, new < uint > [1, 5, 4, 5, 3], new < int > [CardType.NORMAL, CardType.MAGIC, CardType.RARE, CardType.MAGIC, CardType.RARE, CardType.NORMAL], new < ChestPowerupPack > [ChestPowerupPack.create(Powerup.RARITY_NORMAL, {daub:1, cash:1})]);
			chests[0].fillChest(ChestType.SUPER, false, 7, 0, new < uint > [1, 5, 4, 5, 3, 4], new < int > [CardType.NORMAL, CardType.MAGIC, CardType.RARE, CardType.MAGIC, CardType.RARE, CardType.NORMAL], new < ChestPowerupPack > [ChestPowerupPack.create(Powerup.RARITY_NORMAL, {daub:1, cash:1}), ChestPowerupPack.create(Powerup.RARITY_RARE, {daub:1, cash:1}), ChestPowerupPack.create(Powerup.RARITY_MAGIC, {daub:1, cash:1})]);*/
			//chests[3].fillChest(ChestType.GOLD, false, 7, 0, new < uint > [1], new < int > [CardType.NORMAL], new < ChestPowerupPack > [ChestPowerupPack.create(Powerup.RARITY_NORMAL, {daub:1, cash:1})]);
			
			if(DEBUG_MODE)
				debugCreateChests();
		}
		
		public function fillPlayerMessage(playerMessage:PlayerMessage):void 
		{
			var i:int;
			var length:int = chests.length;
			var message:ChestSlotMessage;
			for (i = 0; i < length; i++) {
				message = new ChestSlotMessage();
				//if (chests[i].type == ChestType.NONE)
					//continue;
					
				chests[i].fillChestSlotMessage(message);
				playerMessage.chestSlots[i] = message;
				//playerMessage.chestSlots.push(message);
				//trace('ChestsData.fillPlayerMessage ', playerMessage.chestSlots.length);
			}
		}
		
		public function parseAwardChest(message:ChestWinMessage):Boolean
		{
			var chestData:ChestData = getEmptySlot(Math.floor((chests.length - 1) / 2));
			if (!chestData)
				return false;
			
			chestData.deserializeWinChest(message);
			
			return true;
		}
		
		public function get freeChestClaimed():Boolean
		{
			return gameManager.clientDataManager.getValue("freeChestClaimed", false);
		}
		
		public function set freeChestClaimed(value:Boolean):void
		{
			gameManager.clientDataManager.setValue("freeChestClaimed", value);
			dispatchEventWith(EVENT_FREE_CHEST_CLAIM);
		}
		
		public function get isAvailableFreePremiumChestByLevel():Boolean
		{
			if (!Player.current)
				return false;
				
			return gameManager.gameData.getLevelForXp(Player.current.xpCount) >= ChestsData.STORE_CHEST_UNLOCK_LEVEL;
		}
		
		public function get hasNewChests():Boolean
		{
			var i:int;
			var length:int = chests.length;
			for (i = 0; i < length; i++) {
				if (chests[i].isNew)
					return true;
			}
			
			return false;
		}
		
		public function get emptySlotsCount():int
		{
			var length:int = chests.length;
			var i:int;
			var count:int;
			for (i = 0; i < length; i++) {
				if (chests[i].type == ChestType.NONE)
					count++;
			}
			
			return count;
		}
		
		public function get newChests():Vector.<ChestData>
		{
			var newChests:Vector.<ChestData> = new Vector.<ChestData>();
			var i:int;
			var length:int = chests.length;
			for (i = 0; i < length; i++) {
				if (chests[i].isNew)
					newChests.push(chests[i]);
			}
			
			return newChests;
		}
		
		public function get hasChestUnderTimeout():Boolean
		{
			//return false;
			
			var length:int = chests.length;
			var i:int;
			for (i = 0; i < length; i++) {
				if (chests[i].openTimestamp > 0 && !chests[i].isReadyToOpen)
					return true;
			}
			
			return false;
		}
		
		public function cleanNewChest(index:int):void 
		{
			dispatchEventWith(EVENT_REMOVE_AWARD_GIVE_OUT_CHEST, false, index);
		}
		
		public function sendDataToServer():void 
		{
			Game.connectionManager.sendPlayerUpdateMessage();
		}
		
		public function getEmptySlot(startIndex:int):ChestData
		{
			// поиск в обе стороны от стартового индекса
			var i:int;
			var length:int = chests.length;
			while ((startIndex - i) >=0 || (startIndex + i) < length) {
				if ((startIndex - i) >=0 && chests[startIndex - i].type == ChestType.NONE)
					return chests[startIndex - i];
				
				i++;
				
				if ((startIndex + i) < length && chests[startIndex + i].type == ChestType.NONE)
					return chests[startIndex + i];
			}
			
			return null;
		}
		
		public function debugCreateChests():void
		{
			var chestData:ChestData;
			var i:int;
			var length:int = chests.length;
			for (i = 0; i < length; i++) {
				chestData = chests[i];
				if (false || Math.random() > 0.7) {
					ChestData.debugGetRandom(chestData);
				}
			}
		}
		
		public function debugCreateNewAwardChests(count:int = 1):void
		{
			while (count-- > 0) {
				var chestData:ChestData = getEmptySlot(Math.floor((chests.length - 1) / 2));
				if (!chestData)
					return;
					
				ChestData.debugGetRandom(chestData);
				chestData.isNew = true;
			}
		}
		
		public function debugCreateNewAwardChest(type:int = 1):void
		{
			var chestData:ChestData = getEmptySlot(Math.floor((chests.length - 1) / 2));
			
			if (!chestData || type == ChestType.NONE)
				return;
				
			chestData.type = type;
			chestData.seed = Math.random() * (int.MAX_VALUE - 1) + 1;
			//chestData.updatePrize();
			chestData.isNew = true;
		}
		
		public function deserializePrizeData(chestDrop:Array):void 
		{
			dropByType = { };
			dropCountsByType = {};
			for each (var item:ChestDropDataMessage in chestDrop) 
			{
				dropByType[item.type] = item.drops;
				dropCountsByType[item.type] = new ChestDropCounts(item.drops);
				staticDataByType[item.type] = new ChestStaticData(item);
			}
		}
		
		public function getDropByType(type:int):ChestDropMessage
		{
			return dropByType[type];
		}
		
		public function getRewardsForChest(type:int, seed:int):Array
		{
			return chestRewardGenerator.getReward(type, seed);
		}
		
		public function getChestDropCount(type:int):ChestDropCounts
		{
			return dropCountsByType[type];
		}
		
		public function getOpenPrice(type:int, remainTime:int = 0):int 
		{
			if (!(type in staticDataByType))
				return 0;
			
			var staticData:ChestStaticData = staticDataByType[type] as ChestStaticData;
			
			if (remainTime <= 0)
				return staticData.price;
				
			return Math.ceil(staticData.price * (remainTime / staticData.openTimeout));
		}
		
		public function getOpenTimeout(type:int):int 
		{
			if (!(type in staticDataByType))
				return 0;
			//return 5;	
			return (staticDataByType[type] as ChestStaticData).openTimeout;
		}
		
		public function closeOpenAndTakeOutDialogs(delay:Number = 0):void
		{
			if (delay == 0) {
				dispatchEventWith(EVENT_CLOSE_CHEST_OPEN_DIALOG);
				dispatchEventWith(EVENT_ACCELERATE_CHEST_TAKE_OUT_DIALOG);
			}
			else {
				Starling.juggler.delayCall(dispatchEventWith, delay, EVENT_CLOSE_CHEST_OPEN_DIALOG);
				Starling.juggler.delayCall(dispatchEventWith, delay, EVENT_ACCELERATE_CHEST_TAKE_OUT_DIALOG);
			}
		}
		
		public function cleanChests():void 
		{
			var i:int;
			var length:int = chests.length;
			for (i = 0; i < length; i++) {
				chests[i].clean();
			}
		}
		
		public function pushStoredChest(type:int, time:uint, source:String):void 
		{
			if (!_storedChests)
				_storedChests = new <StoredChest> [];
				
			_storedChests.push(new StoredChest(type, time, source));
			
			gameManager.clientDataManager.setValue(KEY_STORED_CHESTS, StoredChest.parseToRaw(_storedChests), true);
		}
		
		public function removeStoredChest(storedChest:StoredChest):void 
		{
			if (!_storedChests)
				return;
				
			var index:int = _storedChests.indexOf(storedChest);	
			if (index != -1) {
				_storedChests.splice(index, 1);
			}
			
			gameManager.clientDataManager.setValue(KEY_STORED_CHESTS, StoredChest.parseToRaw(_storedChests), true);
		}
		
		public function removeStoredChestBySourceAndType(source:String, type:int, count:int = 1):void 
		{
			if (!_storedChests)
				return;
			
			var i:int;
			var storedChest:StoredChest;
			var removedCount:int;
			while (i < _storedChests.length) 
			{
				storedChest = _storedChests[i];
				if (storedChest.source == source && storedChest.type == type) {
					_storedChests.splice(i, 1);
					removedCount++;
					if (removedCount >= count)
						break;
				}
				else {
					i++
				}
			}	
			
			if(removedCount > 0)
				gameManager.clientDataManager.setValue(KEY_STORED_CHESTS, StoredChest.parseToRaw(_storedChests), true);
		}		
		
		public function get storedChests():Vector.<StoredChest>
		{
			if (!_storedChests) {
				_storedChests = StoredChest.parseFromRaw(gameManager.clientDataManager.getValue(KEY_STORED_CHESTS, []));
				//_storedChests = gameManager.clientDataManager.getValue(KEY_STORED_CHESTS, new <StoredChest> []);
			}
			
			return _storedChests;
		}
		
		/*public function getReward(chestType:int, seed:int):Array
		{
			var rewardList:Array = [];
			
			var drops:ChestDropMessage = gameManager.chestsData.getDropByType(chestType);
			if (!drops)
			{
				return [];
			}
			
			var randomizer:PM_PRNG = new PM_PRNG();
			randomizer.seed = seed;
			
			if (drops.hasCashDrop)
			{
				var cashQuantity:int = getWeightedQuantity(drops.cashDrop.weights, randomizer);
				if (cashQuantity > 0)
				{
					var cashDrop:CommodityItemMessage = new CommodityItemMessage();
					cashDrop.type = Type.CASH;
					cashDrop.quantity = cashQuantity;
					rewardList.push(cashDrop);
				}
			}
			
			if (drops.hasNormalPowerupsDrop)
			{
				var normalPowerupDrop:ChestPowerupPack = getPowerupDrops(Powerup.RARITY_NORMAL, drops.normalPowerupsDrop, gameManager.powerupModel.chestDropTable.normalDrop, randomizer);
				if (normalPowerupDrop.totalQuantity > 0)
					rewardList.push(normalPowerupDrop);
			}
			
			if (drops.hasMagicPowerupsDrop)
			{
				var magicPowerupDrop:ChestPowerupPack = getPowerupDrops(Powerup.RARITY_MAGIC, drops.magicPowerupsDrop, gameManager.powerupModel.chestDropTable.magicDrop, randomizer);
				if (magicPowerupDrop.totalQuantity > 0)
					rewardList.push(magicPowerupDrop);
			}
			
			if (drops.hasRarePowerupsDrop)
			{
				var rarePowerupDrop:ChestPowerupPack = getPowerupDrops(Powerup.RARITY_RARE, drops.rarePowerupsDrop, gameManager.powerupModel.chestDropTable.rareDrop, randomizer);
				if (rarePowerupDrop.totalQuantity > 0)
					rewardList.push(rarePowerupDrop);
			}
			
			if (drops.hasItemsDrop)
			{
				rewardList = rewardList.concat(getCardDrops(drops.itemsDrop, randomizer));
			}
			
			return rewardList;
		}*/
			
		public function debugSelectPrizes():void 
		{
			var i:int = 500;
			var a:Array = [];
			var b:Object = {};
			var hasCash:Boolean;
			var hasCollection:Boolean;
			while (i-- > 0) 
			{
				var seed:int = int.MAX_VALUE * Math.random();
				var g:Array = gameManager.chestsData.getRewardsForChest(ChestType.BRONZE, seed);
				hasCash = false;
				hasCollection = false;
				
				for (var j:int = 0; j < g.length; j++) {
					hasCash ||= g[j] is CommodityItemMessage;
					hasCollection ||= g[j] is CollectionItem;
				}
				
				if(g.length >= 3 && hasCash && hasCollection)
					b[seed] = g;
			}
		}
		
		public function debugTraceState():void 
		{
			var chestData:ChestData;
			var i:int;
			var length:int = chests.length;
			var string:String = '';
			for (i = 0; i < length; i++) 
			{
				chestData = chests[i];
				string = '> ' + chestData.index + ', type ' + chestData.type + ', id ' + chestData.id + ', openTimestamp ' + chestData.openTimestamp + ', isNew ' + chestData.isNew + ', seed ' + chestData.seed + ', isTakeOuting ' + chestData.isTakeOuting;
				GameScreen.debugShowTextField(string, true);
			}
		}
		
		public static function chestTypeToString(type:int):String
		{
			switch(type)
			{
				default:
					return "UNKNOWN";
				case ChestType.NONE:
					return "NONE";
				case ChestType.GOLD:
					return "GOLD";
				case ChestType.BRONZE:
					return "BRONZE";
				case ChestType.SILVER:
					return "SILVER";
				case ChestType.SUPER:
					return "SUPER";
				case ChestType.PREMIUM:
					return "PREMIUM";
			}
		}
		
		public function debugSetManyAwardsChests():void 
		{
			chests[0].fillChest(ChestType.SUPER, false, 7, 0, new < uint > [1, 4], new < int > [CardType.NORMAL, CardType.MAGIC, CardType.RARE, CardType.MAGIC, CardType.RARE], new < ChestPowerupPack > [ChestPowerupPack.create(Powerup.RARITY_NORMAL, {daub:1, cash:1})]);
			chests[1].fillChest(ChestType.SUPER, false, 7, 0, new < uint > [1, 5, 6], new < int > [CardType.NORMAL, CardType.MAGIC, CardType.RARE, CardType.MAGIC, CardType.RARE, CardType.NORMAL], new < ChestPowerupPack > [ChestPowerupPack.create(Powerup.RARITY_NORMAL, {daub:1, cash:1})]);
			chests[2].fillChest(ChestType.SUPER, false, 7, 0, new < uint > [1, 5, 4, 5, 3], new < int > [CardType.NORMAL, CardType.MAGIC, CardType.RARE, CardType.MAGIC, CardType.RARE, CardType.NORMAL], new < ChestPowerupPack > [ChestPowerupPack.create(Powerup.RARITY_NORMAL, {daub:1, cash:1})]);
			chests[3].fillChest(ChestType.SUPER, false, 7, 0, new < uint > [1, 5, 4, 5, 3, 4], new < int > [CardType.NORMAL, CardType.MAGIC, CardType.RARE, CardType.MAGIC, CardType.RARE, CardType.NORMAL], new < ChestPowerupPack > [ChestPowerupPack.create(Powerup.RARITY_NORMAL, {daub:1, cash:1}), ChestPowerupPack.create(Powerup.RARITY_RARE, {daub:1, cash:1}), ChestPowerupPack.create(Powerup.RARITY_MAGIC, {daub:1, cash:1})]);
		}
		
	}

}
import com.alisacasino.bingo.protocol.ChestDropDataMessage;

final class ChestStaticData 
{
	public function ChestStaticData(raw:ChestDropDataMessage) 
	{
		_price = raw.openPrice;
		_openTimeout = Math.ceil(raw.millisToOpen/1000);
	}
	
	private var _price:uint;
	private var _openTimeout:uint;
	
	public function get price():uint {
		return _price;
	}
	
	public function get openTimeout():uint {
		return _openTimeout;
	}
}