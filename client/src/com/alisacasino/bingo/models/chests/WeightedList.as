package com.alisacasino.bingo.models.chests 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class WeightedList
	{
		public var weights:Vector.<WeightedItem>;
		public var totalWeight:Number = 0;
		
		public function WeightedList() 
		{
			weights = new Vector.<WeightedItem>();
			totalWeight = 0;
		}
		
		public function addWeightedItem(content:*, weight:Number):void
		{
			totalWeight += weight;
			weights.push(new WeightedItem(content, weight, totalWeight));
		}
		
		public function getRandomDrop(randomNumber:Number = NaN):*
		{
			if (isNaN(randomNumber))
			{
				randomNumber = Math.random() * totalWeight;
			}
			else
			{
				randomNumber *= totalWeight;
			}
			
			for (var i:int = 0; i < weights.length; i++) 
			{
				if (weights[i].adjustedWeight >= randomNumber)
				{
					return weights[i].content;
				}
			}
			
			sosTrace("Wrong random number was generated", SOSLog.ERROR);
			return null;
		}
		
		public function toString():String 
		{
			return "[WeightedList weights=" + weights + " totalWeight=" + totalWeight + "]";
		}
		
	}

}