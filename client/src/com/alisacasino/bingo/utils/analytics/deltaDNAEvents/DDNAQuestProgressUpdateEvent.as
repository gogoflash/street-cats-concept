package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	import com.alisacasino.bingo.models.quests.questItems.QuestBase;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNAQuestProgressUpdateEvent extends DDNAQuestBaseEvent
	{
		
		public function DDNAQuestProgressUpdateEvent(quest:QuestBase) 
		{
			super(quest);
			addEventType("questProgressUpdate");
			addParamsField("progress", quest.getProgress());
		}
		
	}

}