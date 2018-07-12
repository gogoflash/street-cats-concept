package com.alisacasino.bingo.models.quests.questItems 
{
	import com.alisacasino.bingo.protocol.QuestDataMessage;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class OpenNChests extends QuestBase
	{
		private var chestType:int = -1;
		
		public function OpenNChests() 
		{
		}
		
		/*
		schemas:
		[]
		[chestType:ChestType]
		*/
		override public function deserialize(message:QuestDataMessage):void 
		{
			super.deserialize(message);
			var options:Array = parseOptions(message.options);
			if (options.length > 0)
			{
				chestType = int(options[0]);
			}
		}
		
		override public function chestOpened(type:int, rewards:Array):void 
		{
			super.chestOpened(type, rewards);
			
			if (chestType != -1 && chestType != type)
				return;
			
			updateProgress(1);
		}
		
		public function toString():String 
		{
			return "[OpenNChests chestType=" + chestType + "]";
		}
		
	}

}