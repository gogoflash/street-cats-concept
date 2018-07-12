package com.alisacasino.bingo.models.quests.questItems 
{
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.QuestDataMessage;
	import com.alisacasino.bingo.protocol.Type;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ObtainNCashFromChest extends QuestBase
	{
		private var requiredChestType:int = -1;
		
		public function ObtainNCashFromChest() 
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
				if (item is CommodityItemMessage)
				{
					var cim:CommodityItemMessage = item as CommodityItemMessage;
					if (cim.type == Type.CASH)
					{
						updateProgress(cim.quantity);
					}
				}
			}
		}
		
	}

}