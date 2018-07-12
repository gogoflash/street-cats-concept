package com.alisacasino.bingo.models.quests.questItems 
{
	import com.alisacasino.bingo.models.game.StakeData;
	import com.alisacasino.bingo.protocol.QuestDataMessage;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class PlayNGames extends QuestBase
	{
		private var minCards:int = -1;
		
		private var minCardBoostMultiplier:int = -1;
		
		public function PlayNGames() 
		{
			
		}
		
		
		/*
		schemas:
		[minCards:int]
		*/
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
						minCards = int(options[0]) > 0 ? int(options[0]) : -1;
						break;
					case "min_cards":
						minCards = int(options[1]);
						break;
					case "card_boost":
						minCardBoostMultiplier = int(options[1]);
						break;
				}
			}
		}
		
		/*override public function roundStart(numCards:int, stakeData:StakeData):void 
		{
			super.roundStart(numCards, stakeData);
			if (minCards != -1 && numCards < minCards)
			{
				return;
			}
			
			if (minCardBoostMultiplier > 0 && stakeData.multiplier < minCardBoostMultiplier)
				return;
			
			updateProgress(1);
		}*/
		
		override public function roundEnd(numCards:int, stakeData:StakeData):void
		{
			super.roundEnd(numCards, stakeData);

			if (minCards != -1 && numCards < minCards)
			{
				return;
			}
			
			if (minCardBoostMultiplier > 0 && stakeData.multiplier < minCardBoostMultiplier)
				return;
			
			updateProgress(1);
		}
	}

}