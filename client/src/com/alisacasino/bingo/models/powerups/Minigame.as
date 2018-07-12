package com.alisacasino.bingo.models.powerups 
{
	import com.alisacasino.bingo.models.scratchCard.ScratchCardModel;
	import com.alisacasino.bingo.protocol.PowerupType;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class Minigame 
	{
		public var type:int;
		public var quantity:int;
		
		public function Minigame(type:int, quantity:int) 
		{
			this.type = type;
			this.quantity = quantity;
			
		}
		
		public function getDropString():String
		{
			return Minigame.getDropString(type);
		}
		
		static public function getDropString(type:int):String
		{
			switch(type)
			{
				case PowerupType.SCRATCH_LOW:
				case PowerupType.SCRATCH_HIGH: return "Scratch card";
				case PowerupType.SPIN_5: 
				case PowerupType.SPIN_10:
				case PowerupType.SPIN_25:
				case PowerupType.SPIN_50: return "Free spin";
			}
			
			sosTrace("Could not find text for minigame type " + type, SOSLog.ERROR);
			return "MINI-GAME";
		}
		
		static public function routeMinigameDrop(minigameDrop:Minigame):void 
		{
			switch(minigameDrop.type)
			{
				case PowerupType.SCRATCH_LOW: 
					gameManager.scratchCardModel.addBonusScratch(ScratchCardModel.X20_CARD_TYPE, minigameDrop.quantity);
					break;
				case PowerupType.SCRATCH_HIGH:
					gameManager.scratchCardModel.addBonusScratch(ScratchCardModel.X50_CARD_TYPE, minigameDrop.quantity);
					break;
				case PowerupType.SPIN_5:
				case PowerupType.SPIN_10:
				case PowerupType.SPIN_25:
				case PowerupType.SPIN_50:
					gameManager.slotsModel.addBonusSpin(minigameDrop);
					break;
			}
		}
		
		static public function minigameFromWeightTable(dropTableEntry:String):Minigame
		{
			var split:Array = dropTableEntry.split(":");
			if (split.length < 2)
			{
				sosTrace("Could not parse minigame drop entry", SOSLog.ERROR);
				return new Minigame(PowerupType.SPIN_5, 1);
			}
			
			
			var powerupType:int;
			switch(split[0])
			{
				default:
				case "spin5": powerupType = PowerupType.SPIN_5; break;
				case "spin10": powerupType = PowerupType.SPIN_10; break;
				case "spin25": powerupType = PowerupType.SPIN_25; break;
				case "spin50": powerupType = PowerupType.SPIN_50; break;
				case "scratchLow": powerupType = PowerupType.SCRATCH_LOW; break;
				case "scratchHigh": powerupType = PowerupType.SCRATCH_HIGH; break;
			}
			
			
			
			return new Minigame(powerupType, int(split[1]));
		}
		
		public function toString():String 
		{
			return "[Minigame type=" + type + " quantity=" + quantity + "]";
		}
		
		public function getBet():int
		{
			switch(type)
			{
				default:
				case PowerupType.SPIN_5:
					return 5;
				case PowerupType.SPIN_10:
					return 10;
				case PowerupType.SPIN_25:
					return 25;
				case PowerupType.SPIN_50:
					return 50;
			}
		}
		
	}

}