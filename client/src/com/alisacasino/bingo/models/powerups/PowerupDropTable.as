package com.alisacasino.bingo.models.powerups 
{
	import com.alisacasino.bingo.protocol.PowerupDropDataMessage;
	import com.alisacasino.bingo.protocol.PowerupDropTableMessage;
	import com.alisacasino.bingo.protocol.PowerupWeightMessage;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class PowerupDropTable extends WeightedPowerupDropList
	{
		public var normalDrop:WeightedPowerupDropList;
		public var magicDrop:WeightedPowerupDropList;
		public var rareDrop:WeightedPowerupDropList;
		
		public function PowerupDropTable() 
		{
			
		}
		
		public function deserialize(dropTableSource:PowerupDropDataMessage):PowerupDropTable
		{
			normalDrop = new WeightedPowerupDropList();
			magicDrop = new WeightedPowerupDropList();
			rareDrop = new WeightedPowerupDropList();
			weights = new Vector.<WeightedPowerup>();
			totalWeight = 0;
			addPowerupsFromSourceList(dropTableSource.normalDropWeights, normalDrop);
			addPowerupsFromSourceList(dropTableSource.magicDropWeights, magicDrop);
			addPowerupsFromSourceList(dropTableSource.rareDropWeights, rareDrop);
			return this;
		}
		
		private function addPowerupsFromSourceList(list:Array, additionalTable:WeightedPowerupDropList):void 
		{
			for each (var powerupWeightMessage:PowerupWeightMessage in list) 
			{
				var type:String = PowerupModel.getPowerupByID(powerupWeightMessage.type);
				addPowerupWithWeight(type, powerupWeightMessage.weight);
				additionalTable.addPowerupWithWeight(type, powerupWeightMessage.weight);
			}
		}
		
		public function getRandomNormalPowerup():String
		{
			return normalDrop.getRandomDrop();
		}
		
		public function toString():String 
		{
			return "[PowerupDropTable " + weights + 
						"]";
		}
	}

}