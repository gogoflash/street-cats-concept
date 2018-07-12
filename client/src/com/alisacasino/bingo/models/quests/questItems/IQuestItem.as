package com.alisacasino.bingo.models.quests.questItems 
{
	import com.alisacasino.bingo.models.quests.IQuestNotifier;
	import com.alisacasino.bingo.protocol.QuestDataMessage;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public interface IQuestItem extends IQuestNotifier
	{
		
		function getDescription():String;
		
		function deserialize(message:QuestDataMessage):void;
		
		function getProgress():int;
	}
	
}