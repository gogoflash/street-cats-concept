package com.alisacasino.bingo.models.slots 
{
	import com.alisacasino.bingo.models.universal.CommodityItem;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class SpinResult 
	{
		public var reward:SlotMachineReward;
		
		public var spinType:String;
		
		public var spinPattern:String;
		
		public var rewardTypes:Array;
		
		public function SpinResult() 
		{
		
		}
	}

}