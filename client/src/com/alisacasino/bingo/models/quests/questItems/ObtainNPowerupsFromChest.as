package com.alisacasino.bingo.models.quests.questItems 
{
	import com.alisacasino.bingo.models.chests.ChestPowerupPack;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.protocol.QuestDataMessage;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ObtainNPowerupsFromChest extends QuestBase
	{
		private var requiredChestType:int = -1;
		
		public function ObtainNPowerupsFromChest() 
		{
			
		}
		
		/**
		 schemas:
		 []
		 [chestType:int]
		 */
		override public function deserialize(message:QuestDataMessage):void 
		{
			super.deserialize(message);
			var options:Array = parseOptions(message.options);
			if (options.length > 0)
			{
				parseAdditionalOptions(options);
			}
		}
		
		private function parseAdditionalOptions(options:Array):void 
		{
			requiredChestType = int(options[0]);
		}
		
		override public function chestOpened(type:int, rewards:Array):void 
		{
			super.chestOpened(type, rewards);
			
			if (requiredChestType != -1 && type != requiredChestType)
				return;
			
			for each (var item:* in rewards) 
			{
				if (item is ChestPowerupPack)
				{
					updateProgress((item as ChestPowerupPack).totalQuantity);
				}
			}
		}
		
	}

}