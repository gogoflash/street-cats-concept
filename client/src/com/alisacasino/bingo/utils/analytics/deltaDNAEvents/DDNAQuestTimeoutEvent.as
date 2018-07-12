package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	import com.alisacasino.bingo.models.quests.questItems.QuestBase;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNAQuestTimeoutEvent extends DDNAQuestBaseEvent
	{
		
		public function DDNAQuestTimeoutEvent(quest:QuestBase) 
		{
			super(quest);
			addEventType("questTimeout");
		}
		
	}

}