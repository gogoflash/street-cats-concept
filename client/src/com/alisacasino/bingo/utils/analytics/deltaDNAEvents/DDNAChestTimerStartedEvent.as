package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	import com.alisacasino.bingo.models.chests.ChestData;
	import com.alisacasino.bingo.models.chests.ChestsData;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.screens.lobbyScreenClasses.ChestSlotView;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNAChestTimerStartedEvent extends DDNAEvent
	{
		
		public function DDNAChestTimerStartedEvent(chestData:ChestData, chests:Vector.<ChestSlotView>, isFreeTutorialChest:Boolean) 
		{
			addEventType("chestTimerStarted");
			addParamsField("chestType", ChestsData.chestTypeToString(chestData.type));
			addParamsField("chestSeed", chestData.seed);
			addParamsField("isTutorial", isFreeTutorialChest);
			
			var chestsFilled:int = 0;
			for each (var item:ChestSlotView in chests) 
			{
				if (item.data && item.data.type != ChestType.NONE)
				{
					chestsFilled += 1;
				}
			}
			addParamsField("chestSlotsFilled", chestsFilled);
		}
		
	}

}