package com.alisacasino.bingo.models.universal 
{
	import com.alisacasino.bingo.protocol.Type;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CommodityType 
	{
		
		static public const CASH:String = "cash";
		static public const POWERUP:String = "powerup";
		static public const SCORE:String = "eventScore";
		static public const DAUB_ALERT:String = "daubAlert";
		static public const CUSTOMIZER_SET:String = "customizer_set";
		static public const DUST:String = "dust";
		static public const SOURCE_SCRATCH_CARD:String = "scratchCardWin";
		
		static public const CHEST:String = "chest";
		static public const COLLECTION:String = "collection";
		static public const CUSTOMIZER:String = "customizer";
		static public const POWERUP_CARD:String = "powerup_card";
		
		static public const SLOT_FREE_SPINS:String = "slot_free_spins";
		
		static public function getTypeByCommodityItemMessageType(messageType:int):String
		{
			switch(messageType)
			{
				case Type.CASH:
					return CASH;
				case Type.POWERUP:
					return POWERUP;
				case Type.SCORE:
					return SCORE;
				case Type.DUST:
					return DUST;
				default:
					sosTrace("CommodityItemMessage type " + messageType + " is not implemented in client", SOSLog.ERROR);
					return CASH;
			}
		}
	}

}