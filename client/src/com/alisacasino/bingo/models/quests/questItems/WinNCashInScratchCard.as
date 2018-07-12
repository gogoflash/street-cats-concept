package com.alisacasino.bingo.models.quests.questItems 
{
	import com.alisacasino.bingo.models.scratchCard.ScratchCardModel;
	import com.alisacasino.bingo.models.universal.CommoditySource;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.protocol.QuestDataMessage;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class WinNCashInScratchCard extends QuestBase
	{
		private var minCashQuantity:int;
		
		public function WinNCashInScratchCard() 
		{
			
		}
		
		override public function deserialize(message:QuestDataMessage):void 
		{
			super.deserialize(message);
			var options:Array = parseOptions(message.options);
			if (options.length > 0) {
				if (String(options[0]) == "minCash" && options.length > 1)
					minCashQuantity = int(options[1]);
			}
		}
		
		override public function cashCollected(quantity:int, source:String):void 
		{
			super.cashCollected(quantity, source);
			
			var sourceSplitted:Array = source ? source.split(':') : [];
			if (sourceSplitted.length > 0 && sourceSplitted[0] == CommoditySource.SOURCE_SCRATCH_CARD)
			{
				if (minCashQuantity > 0) 
				{
					if(quantity >= minCashQuantity)
						updateProgress(1);
				}
				else 
				{
					updateProgress(quantity);
				}
				
			}
		}
		
	}

}