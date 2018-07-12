package com.alisacasino.bingo.models.chests 
{
	import com.alisacasino.bingo.models.collections.Collection;
	import com.alisacasino.bingo.models.collections.CollectionItem;
	import com.alisacasino.bingo.models.collections.CollectionPage;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.models.powerups.PowerupModel;
	import com.alisacasino.bingo.models.powerups.WeightedPowerupDropList;
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.protocol.ChestCommonDropMessage;
	import com.alisacasino.bingo.protocol.ChestDropMessage;
	import com.alisacasino.bingo.protocol.ChestDropWeightMessage;
	import com.alisacasino.bingo.protocol.ChestItemsDropMessage;
	import com.alisacasino.bingo.protocol.ChestItemsRarityWeightMessage;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.Type;
	import de.polygonal.math.PM_PRNG;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ChestRewardGenerator 
	{
		
		public function ChestRewardGenerator() 
		{
			
		}
		
		public function getReward(chestType:int, seed:int):Array
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
			
			if (drops.hasChestCustomizerDrop)
			{
				rewardList = rewardList.concat(getCustomizerDrops(drops.chestCustomizerDrop, randomizer))
			}
			
			return rewardList;
		}
		
		private function getCustomizerDrops(chestCustomizerDrop:ChestCommonDropMessage, randomizer:PM_PRNG):Array
		{
			var result:Array = [];
			var totalQuantity:int = getWeightedQuantity(chestCustomizerDrop.weights, randomizer);
			for (var i:int = 0; i < totalQuantity; i++) 
			{
				result.push(getCustomizerDrop(randomizer));
			}
			return result;
		}
		
		private function getPowerupDrops(rarity:String, quantityDropMessage:ChestCommonDropMessage, powerupDropTable:WeightedPowerupDropList, randomizer:PM_PRNG):ChestPowerupPack
		{
			
			var powerupData:Object = {};
			var totalQuantity:int = getWeightedQuantity(quantityDropMessage.weights, randomizer);
			
			for (var i:int = 0; i < totalQuantity; i++) 
			{
				var powerup:String = powerupDropTable.getRandomDrop(randomizer.nextDouble());
				if (!powerupData.hasOwnProperty(powerup))
				{
					powerupData[powerup] = 1;
				}
				else 
				{
					powerupData[powerup] += 1;
				}
			}
			
			return new ChestPowerupPack(rarity, powerupData, totalQuantity);
		}
		
		private function getCardDrops(itemsDrop:ChestItemsDropMessage, randomizer:PM_PRNG):Array
		{
			var totalQuantity:int = getWeightedQuantity(itemsDrop.quantityWeights, randomizer);
			
			var result:Array = [];
			
			var currentCollection:Collection = gameManager.tournamentData.collection;
			
			
			for (var i:int = 0; i < totalQuantity; i++) 
			{
				var rarity:int = getWeightedRarity(itemsDrop.rarityWeights, randomizer);
				
				var forCurrentPage:Boolean = randomizer.nextDouble() > gameManager.collectionsData.completedPageProbabilty;
				var page:CollectionPage = currentCollection.getCurrentPage();
				
				if (!forCurrentPage || !page)
				{
					var randomCompletedPage:CollectionPage = currentCollection.getRandomCompletedPage(randomizer.nextDouble());
					if(randomCompletedPage)
						page = randomCompletedPage;
				}
				
				if (page) {
					var card:CollectionItem = page.getRandomCard(rarity, randomizer.nextDouble());
					if(card)
						result.push(card);
				}
			}
			return result;
		}
		
		private function getWeightedRarity(rarities:Array, randomizer:PM_PRNG):int
		{
			var weightedList:WeightedList = new WeightedList();
			for (var i:int = 0; i < rarities.length; i++) 
			{
				var weight:ChestItemsRarityWeightMessage = rarities[i];
				weightedList.addWeightedItem(weight.type, weight.weight);
			}
			return int(weightedList.getRandomDrop(randomizer.nextDouble()));
		}
		
		private function getWeightedQuantity(weights:Array, randomizer:PM_PRNG):int
		{
			var weightedList:WeightedList = new WeightedList();
			for (var i:int = 0; i < weights.length; i++) 
			{
				var weight:ChestDropWeightMessage = weights[i];
				weightedList.addWeightedItem(weight.quantity, weight.weight);
			}
			return int(weightedList.getRandomDrop(randomizer.nextDouble()));
		}
		
		public function getCardDrop(rarity:int, explicitForCurrentPage:Boolean = false):CollectionItem
		{
			var page:CollectionPage;
			
			if (explicitForCurrentPage || (Math.random() > gameManager.collectionsData.completedPageProbabilty)) 
				page = gameManager.tournamentData.collection.getCurrentPage();
			
			if (!page)
				page = gameManager.tournamentData.collection.getRandomCompletedPage(Math.random());
			
			return page ? page.getRandomCard(rarity, Math.random()) : null;
		}
		
		public function getCustomizerDrop(randomizer:PM_PRNG):CustomizerItemBase
		{
			return gameManager.skinningData.dropList.getRandomDrop(randomizer.nextDouble());
		}
	}

}