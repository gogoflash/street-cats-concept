package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	import com.alisacasino.bingo.models.quests.questItems.QuestBase;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNAQuestClaimedEvent extends DDNAQuestBaseEvent
	{
		
		public function DDNAQuestClaimedEvent(quest:QuestBase) 
		{
			super(quest);
			addEventType("questClaimed");
			addParamsField("reward", createRewardObject("questReward", [quest.reward]));
		}
		
	}

}