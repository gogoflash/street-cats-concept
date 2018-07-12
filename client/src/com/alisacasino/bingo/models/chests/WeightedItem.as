package com.alisacasino.bingo.models.chests 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class WeightedItem 
	{
		public var adjustedWeight:Number;
		public var weight:Number;
		public var content:*;
		
		public function WeightedItem(content:*, weight:Number, adjustedWeight:Number) 
		{
			this.adjustedWeight = adjustedWeight;
			this.weight = weight;
			this.content = content;
		}
		
		public function toString():String 
		{
			return "[WeightedItem adjustedWeight=" + adjustedWeight + " weight=" + weight + " content=" + content + 
						"]";
		}
	}

}