package com.alisacasino.bingo.models.quests 
{
	import com.alisacasino.bingo.protocol.QuestSettingsMessage;
	public class QuestTypeSettings 
	{
		public var type:String;
		
		public var skipMinPrice:int;
		public var skipMaxPrice:int;
		public var skipPriceStep:int;
		
		public var maxQuestsPerPeriod:int;
		public var randomObjectiveSelect:Boolean;
		
		public var tier:int;
		public var passedQuestsCount:int;
		
		public function QuestTypeSettings(raw:Object) 
		{
			if (!raw) {
				skipMinPrice = 0;
				skipMaxPrice = 0;
				skipPriceStep = 0;
				return;
			}
			
			type = String(raw['type']);
			skipMinPrice = int(raw['skipMinPrice']);
			skipMaxPrice = int(raw['skipMaxPrice']);
			skipPriceStep = int(raw['skipPriceStep']);
			
			maxQuestsPerPeriod = int(raw['maxQuestsPerPeriod']);
			randomObjectiveSelect = Boolean(raw['randomObjectiveSelect']);
		}
		
		public function getPrice():int 
		{
			return Math.min(skipMaxPrice, skipMinPrice + skipPriceStep * tier);	
		}
	}
}