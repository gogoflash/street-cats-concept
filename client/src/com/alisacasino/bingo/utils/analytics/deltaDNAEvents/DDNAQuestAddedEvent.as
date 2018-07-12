package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	import com.alisacasino.bingo.models.quests.questItems.QuestBase;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNAQuestAddedEvent extends DDNAQuestBaseEvent
	{
		
		public function DDNAQuestAddedEvent(quest:QuestBase) 
		{
			super(quest);
			addEventType("questAdded");
		}
		
	}

}