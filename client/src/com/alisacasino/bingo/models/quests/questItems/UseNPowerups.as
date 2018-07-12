package com.alisacasino.bingo.models.quests.questItems 
{
	import com.alisacasino.bingo.models.quests.QuestObjective;
	import com.alisacasino.bingo.protocol.QuestDataMessage;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class UseNPowerups extends QuestBase 
	{
		private var requiredRarity:String;
		private var requiredPowerup:String;
		
		public function UseNPowerups() 
		{
		}
		
		/*
		schemas:
		[]
		["rarity", rarity:Powerup.rarity]
		["powerup", powerup:string]
		*/
		override public function deserialize(message:QuestDataMessage):void 
		{
			super.deserialize(message);
			var options:Array = parseOptions(message.options);
			if (options.length > 0)
			{
				parseAdditionalParameters(options);
			}
		}
		
		private function parseAdditionalParameters(options:Array):void 
		{
			switch(options[0])
			{
				case "rarity":
					requiredRarity = options[1];
					break;
				case "powerup":
					requiredPowerup = options[1];
					break;
			}
		}
		
		override public function powerupUsed(powerup:String):void 
		{
			super.powerupUsed(powerup);
			
			if (requiredPowerup && powerup != requiredPowerup)
				return;
			
			if (requiredRarity && gameManager.powerupModel.getRarity(powerup) != requiredRarity)
				return;
				
			updateProgress(1);
		}
		
		public function toString():String 
		{
			return "[UseNPowerups requiredRarity=" + requiredRarity + " requiredPowerup=" + requiredPowerup + "]";
		}
		
	}

}