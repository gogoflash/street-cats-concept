package com.alisacasino.bingo.models.slots 
{
	import com.alisacasino.bingo.models.chests.WeightedList;
	
	public class SlotMachineChanceTable 
	{
		public var weightedList:WeightedList;
		
		public var spinType:String; // normal, free spins, tutor, gift, lucky 
		
		//public var multiplier:int;
		
		public var stake:int;
		
		public var themeColor:uint;
		
		public var themeTexts:Array;
		
		public var themeSymbols:Array;
		
		
		public function SlotMachineChanceTable() 
		{
			weightedList = new WeightedList();
		}
		
		public function getResult():SlotMachineReward
		{
			var randomNumber:Number = Math.random();
			//sosTrace( "randomNumber : " + randomNumber );
			
			return weightedList.getRandomDrop(randomNumber);
		}
		
		public function getRewardByType(type:String):SlotMachineReward
		{
			var i:int;
			var length:int = weightedList.weights.length;
			for (i = 0; i < length; i++)
			{
				if ((weightedList.weights[i].content as SlotMachineReward).rewardType == type)
					return weightedList.weights[i].content as SlotMachineReward;
			}
			
			return null;
		}
	}

}