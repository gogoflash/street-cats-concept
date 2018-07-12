package com.alisacasino.bingo.utils
{
	public class NumberUtils
	{
		private static const EPSILON:Number = 0.00001;
		
		public static function equal(n1:Number, n2:Number):Boolean
		{
			return Math.abs(n1 - n2) < EPSILON;
		}
	}
}