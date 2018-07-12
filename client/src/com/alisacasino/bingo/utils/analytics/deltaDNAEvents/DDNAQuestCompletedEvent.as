package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	import com.alisacasino.bingo.models.quests.questItems.QuestBase;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNAQuestCompletedEvent extends DDNAQuestBaseEvent
	{
		
		public function DDNAQuestCompletedEvent(quest:QuestBase) 
		{
			super(quest);
			addEventType("questCompleted");
		}
		
	}

}