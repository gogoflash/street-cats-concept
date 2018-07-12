package com.alisacasino.bingo.models.quests.questItems 
{
	import com.alisacasino.bingo.models.game.StakeData;
	import com.alisacasino.bingo.protocol.QuestDataMessage;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CollectNPoints extends QuestBase
	{
		private var minCardBoostMultiplier:int = -1;
		
		public function CollectNPoints() 
		{
			
		}
		
		override public function deserialize(message:QuestDataMessage):void 
		{
			super.deserialize(message);
			var options:Array = parseOptions(message.options);
			if (options.length > 0)
			{
				var optionType:String = options[0];
				switch(optionType)
				{
					default:
					case "any":
						break;
					case "card_boost":
						minCardBoostMultiplier = int(options[1]);
						break;
				}
			}
		}
		
		override public function scoreEarned(score:int, stakeData:StakeData):void 
		{
			super.scoreEarned(score, stakeData);
			
			if (minCardBoostMultiplier > 0 && stakeData.multiplier < minCardBoostMultiplier)
				return;
			
			updateProgress(score);
		}
		
	}

}