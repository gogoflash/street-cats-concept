package com.alisacasino.bingo.models.quests.questItems 
{
	import com.alisacasino.bingo.protocol.QuestDataMessage;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class NDaubStreaks extends QuestBase
	{
		private var requiredStreakLength:int;
		
		public function NDaubStreaks() 
		{
			
		}
		
		/**
		 schemas:
		 [streakLength:int]
		 */
		override public function deserialize(message:QuestDataMessage):void 
		{
			super.deserialize(message);
			var options:Array = parseOptions(message.options);
			requiredStreakLength = int(options[0]);
		}
		
		override public function daubStreakProgress(streak:int):void 
		{
			super.daubStreakProgress(streak);
			if (streak == requiredStreakLength)
			{
				updateProgress(1);
			}
		}
		
	}

}