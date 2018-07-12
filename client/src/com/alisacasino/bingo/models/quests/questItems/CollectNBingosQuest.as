package com.alisacasino.bingo.models.quests.questItems 
{
	import com.alisacasino.bingo.models.game.StakeData;
	import com.alisacasino.bingo.models.quests.QuestObjective;
	import com.alisacasino.bingo.protocol.QuestDataMessage;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CollectNBingosQuest extends QuestBase
	{
		private var topN:int = -1;
		private var pattern:String = null;
		private var x2:Boolean = false
		private var minCardBoostMultiplier:int = -1;
		/*
		schemas:
		["any"]
		["top", place:int]
		["pattern", pattern:string]
		["x2"]
		*/
		
		public function CollectNBingosQuest() 
		{
		}
		
		override public function deserialize(message:QuestDataMessage):void 
		{
			super.deserialize(message);
			var options:Array = parseOptions(message.options);
			if (options.length > 0)
			{
				parseAdditionalOptions(options);
			}
		}
		
		private function parseAdditionalOptions(options:Array):void 
		{
			var optionType:String = options[0];
			switch(optionType)
			{
				default:
				case "any":
					break;
				case "top":
					topN = int(options[1]);
					break;
				case "pattern":
					pattern = String(options[1]);
					break;
				case "x2":
					x2 = true;
					break;
				case "card_boost":
					minCardBoostMultiplier = int(options[1]);
					break;
			}
		}
		
		override public function bingoClaimed(x2Active:Boolean, placeInRound:int, bingoPatterns:Vector.<String>, stakeData:StakeData):void 
		{
			super.bingoClaimed(x2Active, placeInRound, bingoPatterns, stakeData);
			if (topN > 0)
			{
				if (placeInRound > topN)
					return;
			}
			
			if (x2 && !x2Active)
				return;
			
			if (pattern && bingoPatterns.indexOf(pattern) == -1)
				return;
			
			if (minCardBoostMultiplier > 0 && stakeData.multiplier < minCardBoostMultiplier)
				return;
				
			updateProgress(1);
		}
		
		public function toString():String 
		{
			return "[CollectNBingosQuest topN=" + topN + " pattern=" + pattern + " x2=" + x2 + "]";
		}
		
	}

}