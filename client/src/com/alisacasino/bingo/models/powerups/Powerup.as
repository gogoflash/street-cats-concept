package com.alisacasino.bingo.models.powerups 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class Powerup 
	{
		static public const RARITY_NORMAL:String = "rarityNormal";
		static public const RARITY_MAGIC:String = "rarityMagic";
		static public const RARITY_RARE:String = "rarityRare";
		
		public static const X2:String = "x2"
		public static const DAUB:String = "daub";
		public static const DOUBLE_DAUB:String = "doubleDaub";
		public static const TRIPLE_DAUB:String = "tripleDaub";
		public static const CASH:String = "cash";
		public static const XP:String = "xp";
		public static const INSTABINGO:String = "instabingo";
		public static const MINIGAME:String = "minigame";
		public static const SCORE:String = "score";
		
		public static function getCellTexture(type:String, isGray:Boolean = false):String 
		{
			var folderPath:String = isGray ? "card/powerups_gray/" : "card/powerups/";
			switch(type) {
				case CASH: 		return folderPath + "cash";
				case INSTABINGO:return "card/powerups/instabingo";
				case MINIGAME: 	return folderPath + "minigame";
				case SCORE: 	return folderPath + "score";
				case X2:		return folderPath + "x2";
				case XP:		return folderPath + "xp";
			}
			return folderPath + "cash";
		}
		
		public static function getTexture(type:String):String {
			switch(type) {
				case CASH: 		return "powerup/icons/cash";
				case INSTABINGO:return "powerup/icons/instabingo";
				case MINIGAME: 	return "powerup/icons/minigame";
				case SCORE: 	return "powerup/icons/score";
				case X2:		return "powerup/icons/2x";
				case XP:		return "powerup/icons/xp";
				case DAUB:		return "powerup/icons/daub";
				case DOUBLE_DAUB:		return "powerup/icons/double_daub";
				case TRIPLE_DAUB:		return "powerup/icons/triple_daub";
			}
			
			//return "powerup/icons/daub";
			return "";
		}
		
		public static function getCardTexture(rarity:String):String 
		{
			switch(rarity) {
				case RARITY_NORMAL: return 'cards/energy_green';
				case RARITY_MAGIC: return 'cards/energy_blue';
				case RARITY_RARE: return 'cards/energy_orange';
			}
			return '';
		}
		
		public static function getRarityName(rarity:String):String 
		{
			switch(rarity) {
				case RARITY_NORMAL: return 'NORMAL';
				case RARITY_MAGIC: return 'MAGIC';
				case RARITY_RARE: return 'RARE';
			}
			return 'unknown ' + String(rarity);
		}
		
		public static function debugGetRandom():String {
			//return X2;
			//return DAUB;
			//return DOUBLE_DAUB;
			//return TRIPLE_DAUB;
			//var types:Vector.<String> = new <String> [X2, DAUB, DOUBLE_DAUB, TRIPLE_DAUB, CASH, XP, INSTABINGO, MINIGAME, SCORE];
			//var types:Vector.<String> = new <String> [DAUB, DOUBLE_DAUB, TRIPLE_DAUB];
			//var types:Vector.<String> = new <String> [DOUBLE_DAUB, TRIPLE_DAUB];
			//var types:Vector.<String> = new <String> [X2, CASH, XP, INSTABINGO, MINIGAME, SCORE];
			//var types:Vector.<String> = new <String> [X2, CASH, XP, SCORE];
			var types:Vector.<String> = new <String> [X2, X2, X2, DAUB, DAUB];
			//var types:Vector.<String> = new <String> [CASH, XP, SCORE];
			//var types:Vector.<String> = new <String> [X2, CASH, XP, INSTABINGO, /*MINIGAME,*/ SCORE];
			return types[Math.floor(Math.random()*types.length)];
		}
		
		static public function getHintForPowerup(type:String):String
		{
			/*c42de7
			ff9f00*/
			switch(type) {
				case CASH: 		return "<font color=\"#c42de7\">EXTRA CASH</font> - adds bonus cash\nonto your cards!";
				case INSTABINGO:return "<font color=\"#c42de7\">InstaBingo</font> - marks a number,\nDAUB IT TO GET A BINGO!";
				case MINIGAME: 	return "<font color=\"#ff9f00\">Minigame Pass</font> - adds a free scratch\nor spin for you to claim on cards!";
				case SCORE: 	return "<font color=\"#c42de7\">EXTRA SCORE</font> - adds bonus score\npoints onto your cards!";
				case X2:		return "<font color=\"#ff9f00\">2X</font> - doubles all payouts from\nyour cards for a limited time!";
				case XP:		return "<font color=\"#009dff\">EXTRA XP</font> - adds bonus\nexperience onto your cards!";
				case DAUB:		return "<font color=\"#009dff\">Single Daub</font> - marks 1 number\noff of each of your cards!";
				case DOUBLE_DAUB:		return "<font color=\"#009dff\">DOUBLE Daub</font> - marks 2 number\noff of each of your cards!";
				case TRIPLE_DAUB:		return "<font color=\"#009dff\">TRIPLE Daub</font> - marks 3 number\noff of each of your cards!";
			}
			
			return "";
		}
		
		public static function get allPowerUps():Vector.<String> {
			return new <String> [X2, DAUB, CASH, XP, INSTABINGO, MINIGAME, SCORE, DOUBLE_DAUB, TRIPLE_DAUB];
		}
		
		public static function get allRarities():Vector.<String> {
			return new <String> [RARITY_NORMAL, RARITY_MAGIC, RARITY_RARE];
		}
	}
}