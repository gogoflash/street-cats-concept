package com.alisacasino.bingo.models.powerups 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class WeightedPowerupDropList 
	{
		public var weights:Vector.<WeightedPowerup>;
		public var totalWeight:Number = 0;
		
		public function WeightedPowerupDropList() 
		{
			weights = new Vector.<WeightedPowerup>();
			totalWeight = 0;
		}
		
		public function addPowerupWithWeight(type:String, weight:Number):void
		{
			totalWeight += weight;
			weights.push(new WeightedPowerup(type, weight, totalWeight));
		}
		
		public function getRandomDrop(rnd:Number = NaN):String
		{
			if (isNaN(rnd))
			{
				rnd = Math.random() * totalWeight;
			}
			else
			{
				rnd *= totalWeight;
			}
			
			for (var i:int = 0; i < weights.length; i++) 
			{
				if (weights[i].adjustedWeight > rnd)
				{
					return weights[i].type;
				}
			}
			
			sosTrace("Wrong random number was generated", SOSLog.ERROR);
			return Powerup.DAUB;
		}
		
	}

}