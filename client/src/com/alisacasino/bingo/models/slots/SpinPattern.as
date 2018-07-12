package com.alisacasino.bingo.models.slots 
{
	import com.alisacasino.bingo.models.chests.WeightedList;
	import com.alisacasino.bingo.models.universal.CommodityItem;
	
	public class SpinPattern 
	{
		public static const SIMPLE:String = "SIMPLE";
		public static const LONG:String = "LONG";
		public static const SHORT:String = "SHORT";
		public static const TWISTING:String = "TWISTING";
		public static const TWISTING_SHORT:String = "TWISTING_SHORT";
		
		private static var _spinPatternsWeightedList:WeightedList;
		
		public function SpinPattern() 
		{
			
		}
		
		public static function getStopDelays(pattern:String, reelsCount:int, stubDelay:int = 100):Array 
		{
			var result:Array = [];
			
			switch(pattern)
			{
				case SIMPLE: {
					result = [0, 100, 200];
					break;
				}
				case SHORT: {
					result = [0, 50, 100];
					break;
				}
				case LONG: {
					result = [0, 200, 400];
					break;
				}
				case TWISTING: {
					result = [0, 300, 1500];
					break;
				}
				case TWISTING_SHORT: {
					result = [0, 50, 1500];
					break;
				}
			}
			
			while (result.length < reelsCount) {
				result.push((result.length)*stubDelay);
			}
			
			return result;
		}
		
		public static function getSpinTime(pattern:String):Number
		{
			switch(pattern)
			{
				case SHORT: return 0.65;
				case SIMPLE: return 1;
				case LONG: return 2;
				case TWISTING: return 2;
				case TWISTING_SHORT: return 0.65;
			}
			
			return 1;
		}
		
		public static function getRandom():String {
			var types:Vector.<String> = new <String> [SIMPLE, LONG, TWISTING];
			return types[Math.floor(Math.random()*types.length)];
		}
		
		public static function getWeightedSpinPattern():String 
		{
			if (!_spinPatternsWeightedList) {
				_spinPatternsWeightedList = new WeightedList();
				_spinPatternsWeightedList.addWeightedItem(SIMPLE, 75);
				_spinPatternsWeightedList.addWeightedItem(LONG, 10);
				_spinPatternsWeightedList.addWeightedItem(TWISTING, 15);
			}
			
			return _spinPatternsWeightedList.getRandomDrop() as String;
		}
		
		public static function getForSpeedSpin():String {
			return Math.random() > 0.15 ? /*SIMPLE*/SHORT : TWISTING_SHORT;
		}
	}
}