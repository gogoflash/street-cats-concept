package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	import com.alisacasino.bingo.models.quests.questItems.QuestBase;
	public class DDNAQuestBaseEvent extends DDNAEvent 
	{
		
		public function DDNAQuestBaseEvent(quest:QuestBase) 
		{
			super();
			addParamsField("questType", quest.type);
			addParamsField("questID", quest.id);
			addParamsField("questDuration", quest.currentDuration);
			addParamsField("questTimeToTimeout", quest.currrentTimeout);
		}
	}
} 