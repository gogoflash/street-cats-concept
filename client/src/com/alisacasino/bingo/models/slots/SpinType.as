package com.alisacasino.bingo.models.slots 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class SpinType 
	{
		static public const FREE_SPIN:String = "freeSpin"; //spin_0
		static public const HAPPY_SPIN:String = "happySpin"; //spin_1
		static public const VALUE_SPIN:String = "valueSpin"; //spin_2
		static public const PREMIUM_SPIN:String = "premiumSpin"; //spin_3
		static public const GIFT_SPIN:String = "giftSpin"; //spin_4
		
		// FOR ARENA SLOT MACHINE:
		static public const DEFAULT:String = "normal";
		static public const FREE:String = "free";
		static public const BONUS_MINIGAME:String = "bonus_minigame";
		static public const GIFT:String = "gift";
	}

}