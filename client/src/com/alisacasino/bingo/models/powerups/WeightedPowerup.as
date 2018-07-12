package com.alisacasino.bingo.models.powerups 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class WeightedPowerup
	{
		public var adjustedWeight:Number;
		public var weight:Number;
		public var type:String;
		
		public function WeightedPowerup(type:String, weight:Number, adjustedWeight:Number) 
		{
			super();
			this.type = type;
			this.weight = weight;
			this.adjustedWeight = adjustedWeight;
		}
		
		public function toString():String 
		{
			return "[WeightedPowerup weight=" + weight + " type=" + type + "]";
		}
	}

}