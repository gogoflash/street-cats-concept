package com.alisacasino.bingo.utils 
{
	public final class DeviceOrientation extends Object
	{
		public static const DEFAULT : 		String = "default";
		public static const ROTATED_LEFT : 	String = "rotatedLeft";
		public static const ROTATED_RIGHT : String = "rotatedRight";
		public static const UNKNOWN : 		String = "unknown";
		public static const UPSIDE_DOWN : 	String = "upsideDown";

		public static function getByString(value:String):String {
			switch(value) {
				case "default": 	return DEFAULT;
				case "rotatedLeft": return ROTATED_LEFT;
				case "rotatedRight":return ROTATED_RIGHT;
				case "unknown": 	return UNKNOWN;
				case "upsideDown": 	return UPSIDE_DOWN;
			}
			
			return UNKNOWN;
		}
	}

}