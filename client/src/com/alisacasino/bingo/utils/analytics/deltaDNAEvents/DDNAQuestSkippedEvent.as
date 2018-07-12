package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	import com.alisacasino.bingo.models.quests.questItems.QuestBase;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNAQuestSkippedEvent extends DDNAQuestBaseEvent
	{
		
		public function DDNAQuestSkippedEvent(quest:QuestBase) 
		{
			super(quest);
			addEventType("questSkipped");
			addParamsField("price", quest.skipPrice);
		}
		
	}

}