package com.alisacasino.bingo.models.quests.questItems 
{
	import com.alisacasino.bingo.protocol.QuestDataMessage;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class NDaubs extends QuestBase
	{
		private var numberToDaub:int = -1;
		
		public function NDaubs() 
		{
			
		}
		
		/*
		schemas:
		["any"]
		["number", numberToDaub:int]
		*/
		override public function deserialize(message:QuestDataMessage):void 
		{
			super.deserialize(message);
			var options:Array = parseOptions(message.options);
			if (options.length > 0)
			{
				if (options[0] == "number")
					numberToDaub = int(options[1]);
			}
		}
		
		override public function daubRegistered(number:int):void 
		{
			super.daubRegistered(number);
			if (numberToDaub != -1 && numberToDaub != number)
				return;
			
			updateProgress(1);
		}
		
		public function toString():String 
		{
			return "[NDaubs numberToDaub=" + numberToDaub + "]";
		}
		
	}

}