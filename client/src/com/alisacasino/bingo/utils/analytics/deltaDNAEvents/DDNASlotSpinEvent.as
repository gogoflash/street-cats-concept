package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	import com.alisacasino.bingo.models.chests.ChestData;
	import com.alisacasino.bingo.models.chests.ChestsData;
	import com.alisacasino.bingo.models.slots.SlotMachineRewardType;
	import com.alisacasino.bingo.models.slots.SpinResult;
	import com.alisacasino.bingo.models.universal.Price;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNASlotSpinEvent extends DDNAEvent
	{
		
		public function DDNASlotSpinEvent(spinType:String, stake:int, tutorSpinCount:int, result:SpinResult, acceleratedMode:Boolean) 
		{
			super();
			addEventType("slotSpin");
			addParamsField("reward", createRewardObject("spinReward", [result.reward.commodityItem]));
			addParamsField("price", stake);
			addParamsField("spinAcceleratedMode", acceleratedMode);
			addParamsField("spinType", spinType);
			addParamsField("spinWinningCombo", result.reward.rewardType);
			addParamsField("spinWinType", SlotMachineRewardType.getWinType(result.reward.rewardType));
			addParamsField("step", tutorSpinCount.toString());
			
		}
		
	}

}