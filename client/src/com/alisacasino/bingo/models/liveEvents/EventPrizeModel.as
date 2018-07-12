package com.alisacasino.bingo.models.liveEvents 
{
	import com.alisacasino.bingo.protocol.EventPrizeMessage;
	import starling.events.EventDispatcher;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class EventPrizeModel extends EventDispatcher
	{
		static public const PRIZE_AVAILABLE:String = "prizeAvailable";
		
		private var registeredEventIdsForPrizes:Object;
		private var uncollectedPrizes:Vector.<EventPrizeMessage>;
		
		public function EventPrizeModel() 
		{
			registeredEventIdsForPrizes = {};
			uncollectedPrizes = new Vector.<EventPrizeMessage>();
		}
		
		public function storeEventPrizes(eventPrizes:Array):void 
		{
			for each (var item:EventPrizeMessage in eventPrizes) 
			{
				if (registeredEventIdsForPrizes.hasOwnProperty(item.eventId) && (registeredEventIdsForPrizes[item.eventId] == true))
				{
					continue;
				}
				
				registeredEventIdsForPrizes[item.eventId] = true;
				uncollectedPrizes.push(item);
			}
			
			if (uncollectedPrizes.length > 0)
			{
				dispatchEventWith(PRIZE_AVAILABLE);
			}
		}
		
		public function getUncollectedPrizes():Vector.<EventPrizeMessage>
		{
			return uncollectedPrizes;
		}
		
	}

}