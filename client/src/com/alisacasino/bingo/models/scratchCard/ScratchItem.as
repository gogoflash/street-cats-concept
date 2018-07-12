package com.alisacasino.bingo.models.scratchCard 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ScratchItem 
	{
		public var weight:Number;
		public var multiplier:int;
		public var winningQuantity:int;
		/*
		static public const TYPE_COMMODITY:String = "typeCommodity";
		static public const TYPE_SPECIAL_TOP_PRIZE:String = "typeSpecialTopPrize";
		*/
		
		
		public function ScratchItem(winningQuantity:int, multiplier:int, weight:Number) 
		{
			this.winningQuantity = winningQuantity;
			this.multiplier = multiplier;
			this.weight = weight;
		}
		
		public function toString():String 
		{
			return "[ScratchItem weight=" + weight + " multiplier=" + multiplier + " winningQuantity=" + winningQuantity + 
						"]";
		}
		
		
	}

}