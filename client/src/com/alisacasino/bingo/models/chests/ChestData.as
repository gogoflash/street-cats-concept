package com.alisacasino.bingo.models.chests 
{
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.models.collections.CollectionItem;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.models.skinning.SkinningData;
	import com.alisacasino.bingo.protocol.CardType;
	import com.alisacasino.bingo.protocol.ChestSlotMessage;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.protocol.ChestWinMessage;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.CustomizationType;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.utils.TimeService;
	import com.netease.protobuf.UInt64;
	import flash.geom.Point;
	public class ChestData
	{
		public function ChestData(index:int = 0) {
			_type = ChestType.NONE;
			_openTimeout = 0;
			prizes = [];
			this.index = index;
		}
		
		public var id:int;
		
		public var index:int;
		
		public var seed:int;
		
		public var openTimestamp:int;
		
		public var prizes:Array;
		
		public var isNew:Boolean;
		public var isTakeOuting:Boolean;
		
		private var _openTimeout:int;
		
		private var _type:int;
		
		private var customPrizes:Array;
		
		
		public function get type():int {
			return _type;
		}
		
		public function set type(value:int):void {
			if (_type == value)
				return;
				
			_type = value;	
			_openTimeout = gameManager.chestsData.getOpenTimeout(_type);
			//_openTimeout = 10
		}
		
		public function get isSuperTypeAssets():Boolean {
			return _type == ChestType.SUPER || _type == ChestType.PREMIUM;
		}
		
		// insteade use ChestPartsView
		/*public function get texture():String {
			return getTexture(type);
		}
		
		public static function getTexture(type:int):String {
			switch(type) {
				case ChestType.GOLD: return 'controls/chest/chest_gold';
				case ChestType.SILVER: return 'controls/chest/chest_silver';
				case ChestType.BRONZE: return 'controls/chest/chest_bronze';
				case ChestType.SUPER: return 'controls/chest/chest_super';
			}
			return '';
		}*/
		
		public function get openTimeout():int {
			return _openTimeout; 
		}
		
		public function get remainTime():int {
			return Math.max(0, Math.floor(openTimestamp + openTimeout - TimeService.serverTime));
		}
		
		public function getPrice(remainTime:int = 0):int {
			return gameManager.chestsData.getOpenPrice(type, remainTime);
		}
		
		public function get title():String {
			switch(type) {
				case ChestType.BRONZE: return "BRONZE CHEST";
				case ChestType.SILVER: return "SILVER CHEST";
				case ChestType.GOLD: return "GOLD CHEST";
				case ChestType.SUPER: return "SUPER CHEST";
				case ChestType.PREMIUM: return "PREMIUM CHEST";
			}
			
			return "NONE";
		}
		
		public function get openAnimationParams():Vector.<int> {
			switch(type) {
				case ChestType.BRONZE:
				case ChestType.SILVER:
				case ChestType.GOLD: return new <int> [120, 280, 60, 120, 220, 279, 380, 440, 121, 282];
				case ChestType.SUPER:
				case ChestType.PREMIUM: return new <int> [120, 396, 60, 120, 336, 396, 496, 556, 121, 397];
			}
			
			return new <int> [120, 280, 60, 120, 220, 279, 380, 440, 121, 282];
		}
		
		public function get openAnimationDelayShift():Number {
			switch(type) {
				case ChestType.BRONZE:
				case ChestType.SILVER:
				case ChestType.GOLD: return 0;
				case ChestType.SUPER:
				case ChestType.PREMIUM: return 1.9;
			}
			
			return 0;
		}
		
		public function get chestIconShiftY():Number
		{
			switch(type) {
				case ChestType.BRONZE: 	return 2 * pxScale;
				case ChestType.SUPER:
				case ChestType.PREMIUM: return -4 * pxScale;
				case ChestType.SILVER:
				case ChestType.GOLD: 	return 0;
			}
			
			return 0;
		}
		
		public function get dropChestIconShiftY():Number
		{
			switch(type) {
				case ChestType.BRONZE: 	return 1 * pxScale;
				case ChestType.SUPER:
				case ChestType.PREMIUM: return 3 * pxScale;
				case ChestType.SILVER:
				case ChestType.GOLD: 	return 0;
			}
			
			return 0;
		}
		
		public function get isReadyToOpen():Boolean {
			return openTimestamp > 0 && (Math.floor(openTimestamp + openTimeout - TimeService.serverTime) <= 0);
		}
		
		/*public function get openAnimation():MovieClipAsset {
			switch(type) {
				case ChestType.BRONZE: return MovieClipAsset.ChestBronzeOpen;
				case ChestType.SILVER: return MovieClipAsset.ChestSilverOpen;
				case ChestType.GOLD: return MovieClipAsset.ChestGoldOpen;
				case ChestType.SUPER: return MovieClipAsset.ChestSuperOpen;
				case ChestType.PREMIUM: return MovieClipAsset.ChestSuperOpen;
			}
			
			return MovieClipAsset.ChestBronzeOpen;
		}*/
		
		public function get openAnimationTimeline():String {
			switch(type) {
				case ChestType.BRONZE: return 'chest_open_bronze';
				case ChestType.SILVER: return 'chest_open_silver';
				case ChestType.GOLD: return 'chest_open_gold';
				case ChestType.SUPER: return 'chest_open_super';
				case ChestType.PREMIUM: return 'chest_open_super';
			}
			
			return 'chest_open_bronze';
		}
		
		public function forceReady():void 
		{
			openTimestamp = 1;
		}
		
		public function clean(makeReady:Boolean = false):void 
		{
			id = 0;
			seed = 0;
			type = ChestType.NONE;
			openTimestamp = makeReady ? 1 : 0;
			isNew = false;
			isTakeOuting = false;
			prizes = [];
			customPrizes = null;
		}
		
		public function clone():ChestData
		{
			var clone:ChestData = new ChestData(index);
			clone.id = id;
			clone.seed = seed;
			clone.type = type;
			clone.openTimestamp = openTimestamp;
			clone.isNew = isNew;
			clone.isTakeOuting = isTakeOuting;
			
			if(customPrizes)
				clone.fillChest.apply(null, customPrizes);
			
			// alert: prizes не копируются
			return clone;
		}
		
		public function deserialize(message:ChestSlotMessage):void 
		{
			clean();
			
			if (!message)
				return;
			
			type = message.type;	
			
			if (type != ChestType.NONE) 
			{
				seed = message.seed;
			
				if (message.hasOpenTimeMillis)
					openTimestamp = Math.round(message.openTimeMillis.toNumber() / 1000);
			}
			
			//prizes = gameManager.chestsData.getRewardsForChest(type, seed);	
		}
		
		public function deserializeWinChest(message:ChestWinMessage):void 
		{
			clean();
			
			if (!message || message.type == ChestType.NONE)
				return;
				
			type = message.type;
			seed = message.seed;
			isNew = true;
			//prizes = gameManager.chestsData.getRewardsForChest(type, seed);
		}
		
		public function fillChestSlotMessage(message:ChestSlotMessage):void 
		{
			message.type = type;
			message.seed = seed;
			if(openTimestamp > 0)
				message.openTimeMillis = UInt64.fromNumber(openTimestamp * 1000);
		}
		
		public function setData(data:ChestData):void 
		{
			id = data.id;
			type = data.type;
			openTimestamp = data.openTimestamp;
			prizes = data.prizes;
		}
		
		public function fillChest(type:int, isNew:Boolean, seed:int, openTimestamp:int, cashCards:Vector.<uint> = null, collectionCards:Vector.<int> = null, powerUpsPacks:Vector.<ChestPowerupPack> = null, customizers:Vector.<CustomizerItemBase> = null):void 
		{
			clean();
				
			customPrizes = arguments;
			this.type = type;
			this.seed = seed;
			
			var i:int;
			var l:int;
			var commodityItemMessage:CommodityItemMessage; 
			var collectionItem:CollectionItem; 
			var chestPowerupPack:ChestPowerupPack;
		
			l = cashCards ? cashCards.length : 0;
			for (i = 0; i < l; i++) 
			{
				commodityItemMessage = new CommodityItemMessage();
				commodityItemMessage.type = Type.CASH;
				commodityItemMessage.quantity = cashCards[i];
				prizes.push(commodityItemMessage);
			}
			
			l = powerUpsPacks ? powerUpsPacks.length : 0;
			for (i = 0; i < l; i++) 
			{
				prizes.push(powerUpsPacks[i]);
			}
			
			l = collectionCards ? collectionCards.length : 0;
			for (i = 0; i < l; i++) 
			{
				//collectionItem = new CollectionItem();
				prizes.push(gameManager.chestsData.chestRewardGenerator.getCardDrop(collectionCards[i], true));
			}
			
			l = customizers ? customizers.length : 0;
			for (i = 0; i < l; i++) 
			{
				prizes.push(customizers[i]);
			}
			
			this.isNew = isNew;
			this.openTimestamp = openTimestamp;
		}
		
		public function foundChest(type:int, isNew:Boolean, openTimestamp:int, passNumbers:int, cashCountMin:int, cashCountMax:int, collectionCount:int, collectionRarity:int, powerUpsPackCount:int):void 
		{
			clean();
				
			this.type = type;
			
			generatePrizes(type, passNumbers, cashCountMin, cashCountMax, collectionCount, collectionRarity, powerUpsPackCount);
			
			// защита если ничего не нашли создаем рэндомные призы
			if (seed == 0 || prizes.length == 0) {
				seed = Math.random() * (int.MAX_VALUE - 1) + 1;
				updatePrize();
			}
			
			this.isNew = isNew;
			this.openTimestamp = openTimestamp;
		}
		
		public function generatePrizes(chestType:int, passNumbers:int, cashCountMin:int, cashCountMax:int, collectionCount:int, collectionRarity:int, powerUpsPackCount:int, powerupsMin:int = 0, powerupsMax:int = int.MAX_VALUE):void
		{
			var cashTotalQuantity:int;
			var powerupPackTotalQuantity:int;
			var powerupTotalQuantity:int;
			var collectionsFoundQuantity:int;
			var found:Boolean;
			var i:int;
			var l:int;
			//trace('Chest type ', chestType);
			while (passNumbers-- > 0) 
			{
				seed = Math.random() * (int.MAX_VALUE - 1) + 1;
				prizes = gameManager.chestsData.getRewardsForChest(chestType, seed);
				
				cashTotalQuantity = 0;
				powerupPackTotalQuantity = 0;
				collectionsFoundQuantity = 0;
				powerupTotalQuantity = 0;
				
				l = prizes.length;
				for (i = 0; i < l; i++) 
				{
					if (prizes[i] is CommodityItemMessage)
					{
						cashTotalQuantity += (prizes[i] as CommodityItemMessage).quantity;
					}
					else if (prizes[i] is CollectionItem) {
						if ((prizes[i] as CollectionItem).rarity == collectionRarity)
							collectionsFoundQuantity++;
					}
					else if (prizes[i] is ChestPowerupPack) {
						powerupPackTotalQuantity++;
						powerupTotalQuantity += (prizes[i] as ChestPowerupPack).totalQuantity;
					}
				}
				
				//trace(passNumbers, seed, ' cash:', cashTotalQuantity, ', powerups:', powerupTotalQuantity, ', collections:', collectionsFoundQuantity);
				
				if (cashTotalQuantity >= cashCountMin && cashTotalQuantity <= cashCountMax && 
					collectionsFoundQuantity >= collectionCount && 
					powerupPackTotalQuantity >= powerUpsPackCount && powerupTotalQuantity >= powerupsMin && powerupTotalQuantity <= powerupsMax)
				{
					found = true;
				//	trace('FOUND');
					//trace();
					break;
				}
			}
			
			if (!found) {
				seed = 0;
				prizes = [];
			}
			
			//CardType.NORMAL
		}
		
		public function fillFreePremiumChest():void 
		{
			var cashCards:Vector.<uint> = new < uint > [50];
			var collectionCards:Vector.<int> = Math.random()> 0.5 ? new < int > [CardType.NORMAL] : new < int > [CardType.NORMAL, CardType.NORMAL];
			var powerUpsPacks:Vector.<ChestPowerupPack> = new < ChestPowerupPack > 
			[
				ChestPowerupPack.createByRarityAndCount(Powerup.RARITY_MAGIC, 3),
				ChestPowerupPack.createByRarityAndCount(Powerup.RARITY_RARE, 1)
			];
			
			var customizers:Vector.<CustomizerItemBase> = new < CustomizerItemBase > [];
			
			var cardsCustomizersWeightedAssets:Object = {
				classic_black:10,
				classic_green:10,
				classic_pink:10,
				classic_purple:10,
				classic_red:10
			}
		
			var daubersCustomizersWeightedAssets:Object = {
				classic_black:10,
				classic_green:10,
				classic_pink:10,
				classic_purple:10
			}
			
			var customizer:CustomizerItemBase;
			
			customizer = gameManager.skinningData.getRandomCustomizerByAssets(CustomizationType.CARD, cardsCustomizersWeightedAssets);
			if (customizer)
				customizers.push(customizer);
				
			customizer = gameManager.skinningData.getRandomCustomizerByAssets(CustomizationType.DAUB_ICON, daubersCustomizersWeightedAssets);
			if (customizer)
				customizers.push(customizer);
			
			fillChest(ChestType.PREMIUM, false, 99, 1, cashCards, collectionCards, powerUpsPacks, customizers);
		}
		
		public static function debugGetRandom(chestForRandomize:ChestData = null):ChestData
		{
			var chest:ChestData = chestForRandomize || (new ChestData(0));
			//chest.id = 3;
			chest.type = getRandomType();
			chest.seed = Math.random() * (int.MAX_VALUE - 1) + 1;
			//chest.updatePrize();
			return chest;
		}
		
		public function updatePrize():void 
		{
			if (customPrizes)
				fillChest.apply(null, customPrizes);
			else
				prizes = getRewards();
		}
		
		public static function getRandomType():int {
			var types:Vector.<int> = new <int> [ChestType.GOLD, ChestType.SILVER, ChestType.BRONZE, ChestType.SUPER];
			//return ChestType.SUPER
			return types[Math.floor(Math.random()*types.length)];
		}
		
		public function getRewards():Array
		{
			return gameManager.chestsData.getRewardsForChest(type, seed);
		}
		
		public function getCurrentOpenPrice():int
		{
			return getPrice(remainTime);
		}
	}

}