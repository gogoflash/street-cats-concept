package com.alisacasino.bingo.utils
{
	public class AbsoluteVersion
	{
		public static function fromString(version:String):Number
		{
			if (!version)
				return 0;
			var value:Number = 0;
			var parts:Array = version.split(".");
			for each (var part:String in parts) {
				value *= 1000;
				value += Number(part);
			}
			return value;
		}
	}
}