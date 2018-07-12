package com.alisacasino.bingo.utils 
{
	import com.alisacasino.bingo.protocol.Type;
	
	public class TypeParser 
	{
		public function TypeParser()  {
		}
		
		public static const CASH			:String = "CASH";
		public static const ENERGY			:String = "ENERGY";
		public static const SCORE			:String = "SCORE";
		public static const POWERUP			:String = "POWERUP";
		public static const REAL			:String = "REAL";
		public static const POWERUP_NORMAL	:String = "POWERUP_NORMAL";
		public static const POWERUP_MAGIC	:String = "POWERUP_MAGIC";
		public static const POWERUP_RARE	:String = "POWERUP_RARE";
		public static const DUST			:String = "DUST";
		public static const FREE			:String = "FREE";
		
		public static function parseFromString(value:String):int 
		{
			if (value == null || value == '')
				return -1;
				
			switch(value) {
				case CASH: 				return Type.CASH;
				case ENERGY: 			return Type.ENERGY;
				case SCORE: 			return Type.SCORE;
				case POWERUP: 			return Type.POWERUP;
				case REAL: 				return Type.REAL;
				case POWERUP_NORMAL: 	return Type.POWERUP_NORMAL;
				case POWERUP_MAGIC: 	return Type.POWERUP_MAGIC;
				case POWERUP_RARE: 		return Type.POWERUP_RARE;
				case DUST: 				return Type.DUST;
			}
			
			return -1;
		}
		
		public static function parseToString(value:int):String
		{
			switch(value) {
				case Type.CASH: 			return CASH;
				case Type.ENERGY: 			return ENERGY;
				case Type.SCORE: 			return SCORE;
				case Type.POWERUP: 			return POWERUP;
				case Type.REAL: 			return REAL;
				case Type.POWERUP_NORMAL: 	return POWERUP_NORMAL;
				case Type.POWERUP_MAGIC: 	return POWERUP_MAGIC;
				case Type.POWERUP_RARE: 	return POWERUP_RARE;
				case Type.DUST: 			return DUST;
			}
			
			return 'unknown';
		}
	}
}