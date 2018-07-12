package com.alisacasino.bingo.models.chests 
{
	import com.alisacasino.bingo.protocol.ChestDropMessage;
	import com.alisacasino.bingo.protocol.ChestDropWeightMessage;
	
	public class ChestDropCounts
	{
		private var _powerupsMinCount:int;
		private var _powerupsMaxCount:int;
		private var _powerupsAverageCount:Number = 0;
		
		private var _cashMinCount:int;
		private var _cashMaxCount:int;
		private var _cashAverageCount:int;
		
		private var _collectionMinCount:int;
		private var _collectionMaxCount:int;
		private var _collectionAverageCount:int;
		
		private var _customizerMinCount:int;
		private var _customizerMaxCount:int;
		private var _customizerAverageCount:int;
		
		public function ChestDropCounts(dropMessage:ChestDropMessage = null) 
		{
			if (!dropMessage)
				return;
			
			var minMax:Array;
			var powerupsAveragePreciseCount:Number = 0;
				
			if (dropMessage.hasCashDrop && dropMessage.cashDrop.weights.length > 0)
			{
				minMax = getMinMaxValues(dropMessage.cashDrop.weights);
				_cashMinCount = minMax[0];
				_cashMaxCount = minMax[1];
				_cashAverageCount = Math.round(minMax[2]);
			}
			
			if (dropMessage.hasNormalPowerupsDrop && dropMessage.normalPowerupsDrop.weights.length > 0)
			{
				minMax = getMinMaxValues(dropMessage.normalPowerupsDrop.weights);
				_powerupsMinCount += minMax[0];
				_powerupsMaxCount += minMax[1];
				powerupsAveragePreciseCount += minMax[2];
			}
			
			if (dropMessage.hasMagicPowerupsDrop && dropMessage.magicPowerupsDrop.weights.length > 0)
			{
				minMax = getMinMaxValues(dropMessage.magicPowerupsDrop.weights);
				_powerupsMinCount += minMax[0];
				_powerupsMaxCount += minMax[1];
				powerupsAveragePreciseCount += minMax[2];
			}
			
			if (dropMessage.hasRarePowerupsDrop && dropMessage.rarePowerupsDrop.weights.length > 0)
			{
				minMax = getMinMaxValues(dropMessage.rarePowerupsDrop.weights);
				_powerupsMinCount += minMax[0];
				_powerupsMaxCount += minMax[1];
				powerupsAveragePreciseCount += minMax[2];
			}
			
			_powerupsAverageCount = powerupsAveragePreciseCount;//Math.round(powerupsAveragePreciseCount);
			
			if (dropMessage.hasItemsDrop && dropMessage.itemsDrop.quantityWeights.length > 0)
			{
				minMax = getMinMaxValues(dropMessage.itemsDrop.quantityWeights);
				_collectionMinCount = minMax[0];
				_collectionMaxCount = minMax[1];
				_collectionAverageCount = Math.round(minMax[2]);
			}
			
			if (dropMessage.hasChestCustomizerDrop && dropMessage.chestCustomizerDrop.weights.length > 0)
			{
				minMax = getMinMaxValues(dropMessage.chestCustomizerDrop.weights);
				_customizerMinCount = minMax[0];
				_customizerMaxCount = minMax[1];
				_customizerAverageCount = Math.round(minMax[2]);
			}
		}
		
		public function get cashAndCollectionsFromToString():String {
			return getMinMaxString((_cashMinCount <= 0 ? 0 : 1) + _collectionMinCount, (_cashMaxCount <=  0 ? 0 : 1) + _collectionMaxCount);
		}
		
		public function cashFromToString(spacers:Boolean = false):String {
			return getMinMaxString(_cashMinCount, _cashMaxCount, spacers);
		}
		
		public function сollectionsFromToString(spacers:Boolean = false):String {
			return getMinMaxString(_collectionMinCount, _collectionMaxCount, spacers);
		}
		
		public function powerupsFromToString(spacers:Boolean = false):String {
			return getMinMaxString(_powerupsMinCount, _powerupsMaxCount, spacers);
		}
		
		public function сustomizersFromToString(spacers:Boolean = false):String {
			return getMinMaxString(_customizerMinCount, _customizerMaxCount, spacers);
		}
		
		public function getMinMaxString(min:int, max:int, spacers:Boolean = false):String {
			if (min == max)
				return min.toString();
			
			return min.toString() + (spacers ? ' - ' : '-') + max.toString();
		}
		
		private function getMinMaxValues(weights:Array):Array 
		{
			var i:int;
			var dropWeight:ChestDropWeightMessage;	
			var length:int = weights ? weights.length : 0;
			
			if (length == 0)
				return [0, 0];
			
			var totalWeight:int;
				
			var minZeroWeight:int;
			var maxZeroWeight:int;
			var min:int;
			var max:int;
			var average:Number = 0;
			
			var allWeightsZero:Boolean = true;
			
			if (length == 1)
			{
				dropWeight = weights[i] as ChestDropWeightMessage;
				minZeroWeight = dropWeight.quantity;
				maxZeroWeight = dropWeight.quantity;
				
				average = dropWeight.quantity * dropWeight.weight;
			}
			else
			{
				for (i = 0; i < length; i++) 
				{
					dropWeight = weights[i] as ChestDropWeightMessage;
					allWeightsZero &&= (dropWeight.weight == 0);
					
					if (i == 0) {
						min = minZeroWeight = dropWeight.quantity;
						max = maxZeroWeight = dropWeight.quantity;
					}	
					
					minZeroWeight = Math.min(minZeroWeight, dropWeight.quantity);
					maxZeroWeight = Math.max(maxZeroWeight, dropWeight.quantity);
					
					if (dropWeight.weight != 0) {
						min = Math.min(min, dropWeight.quantity);
						max = Math.max(max, dropWeight.quantity);
					}
					
					totalWeight += dropWeight.weight;
				}
				
				for (i = 0; i < length; i++) {
					dropWeight = weights[i] as ChestDropWeightMessage;
					average += dropWeight.quantity * (dropWeight.weight / totalWeight);
				}
			}
			
			if (allWeightsZero) 
				return [minZeroWeight, maxZeroWeight, 0];
			
			return [min, max, average];
		}
		
		public function get powerupsMinCount():int {
			return _powerupsMinCount;
		}
		
		public function get powerupsMaxCount():int {
			return _powerupsMaxCount;
		}
		
		public function get powerupsAverageCount():Number {
			return _powerupsAverageCount;
		}
		
		public function get cashMinCount():int {
			return _cashMinCount;
		}
		
		public function get cashMaxCount():int {
			return _cashMaxCount;
		}
		
		public function get cashAverageCount():int {
			return _cashAverageCount;
		}
		
		public function get collectionMinCount():int {
			return _collectionMinCount;
		}
		
		public function get collectionMaxCount():int {
			return _collectionMaxCount;
		}
		
		public function get collectionAverageCount():int {
			return _collectionAverageCount;
		}
		
		public function get customizerMinCount():int {
			return _customizerMinCount;
		}
		
		public function get customizerMaxCount():int {
			return _customizerMaxCount;
		}
		
		public function get customizerAverageCount():int {
			return _customizerAverageCount;
		}
	}	
}	