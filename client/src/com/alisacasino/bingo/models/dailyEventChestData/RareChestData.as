package com.alisacasino.bingo.models.dailyEventChestData 
{
	import com.alisacasino.bingo.models.gifts.AccumulatedGiftContents;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.protocol.DailyTournamentChestPrizeMessage;
	import com.alisacasino.bingo.protocol.StaticDataMessage;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class RareChestData 
	{
		public var dialogShown:Boolean;
		
		public function get progress():int
		{
			if (!Room.current || !Room.current.hasActiveEvent || !Room.current.activeEvent.dailyEvent)
			{
				return 0;
			}
			
			return gameManager.clientDataManager.getValue(getProgressKey(Room.current.activeEvent.id), 0);
		}
		
		public function set progress(value:int):void
		{
			if (!Room.current || !Room.current.hasActiveEvent || !Room.current.activeEvent.dailyEvent)
			{
				return;
			}
			gameManager.clientDataManager.setValue(getProgressKey(Room.current.activeEvent.id), value);
		}
		
		private function getProgressKey(activeEventID:uint):String
		{
			return "dailyEventChestBingoCounter/" + activeEventID.toString();
		}
		
		private var _targetBingoNumberForChest:int;
		
		public function get targetBingoNumberForChest():int 
		{
			if (Room.current && Room.current.hasActiveEvent && Room.current.activeEvent.dailyEvent)
			{
				if (Room.current.activeEvent.eventChestTarget != -1)
				{
					return Room.current.activeEvent.eventChestTarget;
				}
			}
			return _targetBingoNumberForChest;
		}
		
		private var prizeEntries:Vector.<PrizeEntry>;
		
		private var totalWeight:Number = 0;
		
		public function RareChestData() 
		{
			prizeEntries = new Vector.<PrizeEntry>();
		}
		
		public function deserializeStaticData(staticData:StaticDataMessage):void 
		{
			_targetBingoNumberForChest = staticData.dailyTournamentChestTarget;
			deserializePrizes(staticData.dailyTournamentChestPrizes);
		}
		
		private function deserializePrizes(dailyTournamentChestPrizes:Array):void 
		{
			totalWeight = 0;
			for each (var item:DailyTournamentChestPrizeMessage in dailyTournamentChestPrizes) 
			{
				var prizeEntry:PrizeEntry = new PrizeEntry();
				prizeEntry.weight = item.weight;
				prizeEntry.content = new AccumulatedGiftContents();
				prizeEntry.content.fromCommodityItemMessages(item.items);
				prizeEntries.push(prizeEntry);
				
				totalWeight += prizeEntry.weight;
			}
		}
		
		public function getPrize():AccumulatedGiftContents
		{
			var randomNumber:Number = totalWeight * Math.random();
			for each (var item:PrizeEntry in prizeEntries) 
			{
				randomNumber -= item.weight;
				if (randomNumber < 0)
				{
					return item.content;
				}
			}
			
			return new AccumulatedGiftContents();
		}
		
	}

}

import com.alisacasino.bingo.models.gifts.AccumulatedGiftContents;

class PrizeEntry
{
	public var weight:Number = 0;
	public var content:AccumulatedGiftContents;
}