package com.alisacasino.bingo.models.game 
{
	import com.alisacasino.bingo.protocol.StakeDataMessage;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class StakeData 
	{
		public var pointsBonus:Array;
		public var graphicsPrefix:String;
		public var label:String;
		public var multiplier:int;
		public var scorePowerupsDropped:int;
		
		
		public function StakeData(multiplier:int, label:String, graphicsPrefix:String, pointsBonus:Array, scorePowerupsDropped:int) 
		{
			this.scorePowerupsDropped = scorePowerupsDropped;
			this.pointsBonus = pointsBonus;
			this.graphicsPrefix = graphicsPrefix;
			this.label = label;
			this.multiplier = multiplier;
		}
		
		static public function fromStakeDataMessage(item:StakeDataMessage):StakeData
		{
			var multipliers:Array = item.pointsBonus.split(",").map(parseNum);
			
			var stake:StakeData = new StakeData(item.multiplier, item.label, item.graphicsPrefix, multipliers, item.scorePowerupsDropped)
			
			return stake;
		}
		
		static private function parseNum(string:String, index:int, array:Array):Number
		{
			return parseFloat(string);
		}
		
		static public function sortFunction(a:StakeData, b:StakeData):int
		{
			if (a.multiplier > b.multiplier)
				return 1;
			if (a.multiplier < b.multiplier)
				return -1;
				
			return 0;
		}
		
		public function toString():String 
		{
			return "[StakeData pointsBonus=" + pointsBonus + " graphicsPrefix=" + graphicsPrefix + " label=" + label + 
						" multiplier=" + multiplier + " scorePowerupsDropped=" + scorePowerupsDropped + "]";
		}
		
		public function getPointsBonusForCardNum(numCards:uint):Number
		{
			if (numCards > pointsBonus.length || numCards < 1)
			{
				sosTrace("Can't find score multiplier for " + numCards + " cards", SOSLog.ERROR);
				return 1;
			}
			var scoreMod:Number = pointsBonus[numCards - 1];
			return scoreMod;
		}
	}

}