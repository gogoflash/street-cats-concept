package com.alisacasino.bingo.models.quests.questItems 
{
	import com.alisacasino.bingo.models.game.StakeData;
	import com.alisacasino.bingo.models.quests.QuestObjective;
	import com.alisacasino.bingo.protocol.QuestDataMessage;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CollectNBingosInRound extends QuestBase
	{
		private var bingosInRound:int = 0;
		private var numberNeededInRound:int = 1;
		private var markedCompletionInRound:Boolean;
		
		/*
		schemas:
		[bingosInRound:int]
		*/
		
		public function CollectNBingosInRound() 
		{
		}
		
		override public function deserialize(message:QuestDataMessage):void 
		{
			super.deserialize(message);
			var options:Array = parseOptions(message.options);
			numberNeededInRound = int(options[0]);
		}
		
		override public function bingoClaimed(x2Active:Boolean, placeInRound:int, bingoPatterns:Vector.<String>, stakeData:StakeData):void 
		{
			super.bingoClaimed(x2Active, placeInRound, bingoPatterns, stakeData);
			
			if (markedCompletionInRound)
				return;
			
			bingosInRound++;
			if (bingosInRound >= numberNeededInRound)
			{
				markedCompletionInRound = true;
				updateProgress(1);
			}
		}
		
		override public function roundStart(numCards:int, stakeData:StakeData):void 
		{
			super.roundStart(numCards, stakeData);
			bingosInRound = 0;
			markedCompletionInRound = false;
		}
		
		override public function roundEnd(numCards:int, stakeData:StakeData):void 
		{
			bingosInRound = 0;
			markedCompletionInRound = false;
			super.roundEnd(numCards, stakeData);
		}
		
		public function toString():String 
		{
			return "[CollectNBingosInRound]";
		}
		
	}

}