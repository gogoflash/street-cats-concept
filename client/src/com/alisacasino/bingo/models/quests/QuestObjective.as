package com.alisacasino.bingo.models.quests 
{
	import com.alisacasino.bingo.controls.cardPatternHint.CardPattern;
	import com.alisacasino.bingo.models.chests.ChestsData;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.models.quests.questItems.BurnNCards;
	import com.alisacasino.bingo.models.quests.questItems.CollectNCards;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.utils.StringUtils;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class QuestObjective 
	{
		static public const COLLECT_N_BINGOS:String = "collectNBingos"; // top1-3, patterns, 2x
		static public const N_BINGO_IN_ROUND:String = "nBingoInRound";
		static public const USE_N_POWERUPS:String = "useNPowerups"; //any or specific or rarity
		static public const CLAIM_N_POWERUPS:String = "claimNPowerups"; //any or specific
		static public const OPEN_N_CHESTS:String = "openNChests"; //any or specific
		static public const N_DAUBS:String = "nDaubs"; //any or specific number (cell)
		static public const N_DAUB_STREAKS:String = "nDaubStreaks"; //specific streak length
		static public const COLLECT_N_POINTS:String = "collectNPoints";
		static public const PLAY_N_GAMES:String = "playNGames"; // on any or specific num of cards
		static public const BURN_N_CARDS:String = "burnNCards"; // collection/customizer
		static public const COLLECT_N_CARDS:String = "collectNCards"; // collection/customizer
		static public const WIN_N_CASH_IN_SCRATCH_CARD:String = "winNCashInScratchCard";
		static public const OBTAIN_N_CASH_FROM_CHEST:String = "obtainNCashFromChest"; // any or specific chest
		static public const OBTAIN_N_POWERUPS_FROM_CHEST:String = "obtainNPowerupsFromChest"; // any or specific chest
		static public const OBTAIN_N_CUSTOMIZERS_FROM_CHEST:String = "obtainNCustomizersFromChest"; // any or specific chest
		
		public static function get objectives():Array
		{
			return [
				COLLECT_N_BINGOS,
				N_BINGO_IN_ROUND,
				USE_N_POWERUPS,
				CLAIM_N_POWERUPS,
				OPEN_N_CHESTS,
				N_DAUBS,
				N_DAUB_STREAKS,
				COLLECT_N_POINTS,
				PLAY_N_GAMES,
				BURN_N_CARDS,
				COLLECT_N_CARDS,
				WIN_N_CASH_IN_SCRATCH_CARD,
				OBTAIN_N_CASH_FROM_CHEST,
				OBTAIN_N_POWERUPS_FROM_CHEST,
				OBTAIN_N_CUSTOMIZERS_FROM_CHEST
			]
		}
		
		public static function getTargetStringByType(type:String, quantity:int, targetColor:String = '#FFFFFF', options:Array = null):String
		{
			var option_0:* = (options && options.length > 0) ? options[0] : null;
			var helperString:String;
			
			switch(type) 
			{
				case COLLECT_N_BINGOS: 
				{
					switch(option_0)
					{
						//case "any":
						case "top": return "WIN " + colorOpenTag(targetColor) + numberToAdjectives(int(options[1])) + " PLACE</font> " + '\nIN A ROUND ' + quantity.toString() + stringByCount(' TIME', ' TIMES', quantity);
						case "pattern": return "GET " + colorOpenTag(targetColor) + quantity.toString() + ' ' + CardPattern.getStringName(String(options[1])).toUpperCase() + "</font> BINGO"; 
						case "x2": return "GET " + colorOpenTag(targetColor) + quantity.toString() + stringByCount(' BINGO', ' BINGOS', quantity) + "</font> " + ' DURING ' + "<font color='" + targetColor + "'>2X</font> " + ' POWER-UP BONUS';
						case "card_boost":return "GET " + colorOpenTag(targetColor) + quantity.toString() + stringByCount(' BINGO', ' BINGOS', quantity) + "</font> " + ' IN ' + "<font color='" + targetColor + "'>CARD BOOST X" + String(options[1]) + "</font> MODE";
					}
					
					return "GET " + colorOpenTag(targetColor) + quantity.toString() + "</font> " +  stringByCount('BINGO', 'BINGOS', quantity);
				}
				case N_BINGO_IN_ROUND: return "ACHIEVE " + colorOpenTag(targetColor) + String(int(option_0)) + stringByCount(' BINGO', ' BINGOS', quantity) + "</font> IN ONE ROUND";
				case USE_N_POWERUPS: 
				{
					switch(option_0) {
						case "rarity": return "USE " + colorOpenTag(targetColor) + quantity.toString() + ' ' + String(Powerup.getRarityName(options[1])).toUpperCase() + " </font> " + stringByCount('POWER-UP', 'POWER-UPS', quantity);
						case "powerup": return "USE " + colorOpenTag(targetColor) + ' ' + String(options[1]).toUpperCase() + " " + quantity.toString() + "</font> " + stringByCount('POWER-UP', 'POWER-UPS', quantity);
					}
					return "USE " + colorOpenTag(targetColor) + quantity.toString() + "</font> " + stringByCount('POWER-UP', 'POWER-UPS', quantity);
				}
				case CLAIM_N_POWERUPS: 
				{
					switch(option_0) {
						case "rarity": return "COLLECT " + colorOpenTag(targetColor) + quantity.toString() + ' ' + String(Powerup.getRarityName(options[1])).toUpperCase() + ' POWER-UP ' + stringByCount('BONUS', 'BONUSES', quantity) + "</font> FROM CARDS";
						case "powerup": return "COLLECT " + colorOpenTag(targetColor) + quantity.toString() + ' ' + String(options[1]).toUpperCase() + ' POWER-UP ' + stringByCount('BONUS', 'BONUSES', quantity) + "</font> FROM CARDS";
					}
					return "COLLECT " + colorOpenTag(targetColor) + quantity.toString() + ' POWER-UP ' + stringByCount('BONUS', 'BONUSES', quantity) + "</font> FROM CARDS";
				}
				case OPEN_N_CHESTS: return "OPEN " + colorOpenTag(targetColor) + quantity.toString() + "</font> " + stringByCount('CHEST', 'CHESTS', quantity, option_0 ? ChestsData.chestTypeToString(option_0) : null);
				case N_DAUBS: {
					if (option_0 == "number")
						return "DAUB " + colorOpenTag(targetColor) + 'NUMBER ' + String(options[1]) + ' ' + "</font> " + StringUtils.numberToNounString(quantity).toUpperCase() + stringByCount(' TIME', ' TIMES', quantity);
					
					return "DAUB " + colorOpenTag(targetColor) + StringUtils.numberToNounString(quantity).toUpperCase() + "</font> " + stringByCount('TIME', 'TIMES', quantity);
				}
				//case N_DAUB_STREAKS: return "DAUB " + colorOpenTag(targetColor) + getTargetStringByCount('DAUB STREAK', 'DAUB STREAKS', quantity) + "</font>";
				case COLLECT_N_POINTS: {
					switch(option_0) {
						default:
						case "any": return "ATTAIN " + colorOpenTag(targetColor) + quantity.toString() + "</font> SCORE";
						case "card_boost": return "ATTAIN " + colorOpenTag(targetColor) + quantity.toString() + "</font> SCORE" + ' IN ' + "<font color='" + targetColor + "'>CARD BOOST X" + String(options[1]) + "</font> MODE";
					}
				}
				case PLAY_N_GAMES: 
				{
					var minCards:int = 0;
					
					switch(option_0)
					{
						default:
						case "any":
							minCards = int(options[0]) > 0 ? int(options[0]) : -1;
							break;
						case "min_cards":
							minCards = int(options[1]);
							break;
						case "card_boost":
							//minCardBoostMultiplier = int(options[1]);
							break;
					}
					
					helperString = "PLAY " + colorOpenTag(targetColor) + quantity.toString() +  "</font> " + stringByCount('ROUND', 'ROUNDS', quantity, minCards > 0 ? (StringUtils.numberToNounString(minCards).toUpperCase() + stringByCount(' CARD', ' CARDS', quantity)) : null);
					if(option_0 == "card_boost") 
						helperString += ' IN ' + "<font color='" + targetColor + "'>CARD BOOST X" + String(options[1]) + "</font> MODE";
					
					return helperString;
				}
				case BURN_N_CARDS: {
					switch(option_0) {
						case BurnNCards.COLLECTION: return "BURN " + colorOpenTag(targetColor) + quantity.toString() + ' COLLECTIBLE ' + "</font>" + stringByCount('CARD', 'CARDS', quantity);
						case BurnNCards.CUSTOMIZER: return "BURN " + colorOpenTag(targetColor) +  quantity.toString() + ' INVENTORY ' + "</font>" + stringByCount('ITEM', 'ITEMS', quantity);
					}
					return "BURN " + colorOpenTag(targetColor) + quantity.toString() +  "</font> OF ANYTHING";
				}
				case COLLECT_N_CARDS: {
					switch(option_0) {
						case CollectNCards.COLLECTION: return "GAIN " + colorOpenTag(targetColor) + quantity.toString() + ' COLLECTIBLE ' + "</font>" + stringByCount('CARD', 'CARDS', quantity);
						case CollectNCards.CUSTOMIZER: return "GAIN " + colorOpenTag(targetColor) + quantity.toString() + ' INVENTORY ' + "</font>" + stringByCount('ITEM', 'ITEMS', quantity);
					}
					return "GAIN " + colorOpenTag(targetColor) + ' ' + quantity.toString() + " INVENTORY/COLLECTION "  + "</font>" + stringByCount('ITEM', 'ITEMS', quantity);
				}
				case WIN_N_CASH_IN_SCRATCH_CARD: {
					if (option_0 == "minCash") 
						return "GET " + colorOpenTag(targetColor) + String(int(options[1])) + ' OR MORE </font>CASH FROM ONE SCRATCH';
					
					return "WIN " + colorOpenTag(targetColor) + quantity.toString() + " CASH</font> IN SCRATCH CARD";
				}
				case OBTAIN_N_CASH_FROM_CHEST: {
					if(option_0 == -1 || option_0 == null) 
						return "EARN " + colorOpenTag(targetColor) + quantity.toString() + " CASH</font> FROM " + stringByCount('CHEST', 'CHESTS', quantity);
					else
						return "EARN " + colorOpenTag(targetColor) + quantity.toString() + " CASH</font> FROM " + ChestsData.chestTypeToString(option_0) + stringByCount(' CHEST', ' CHESTS', quantity);
				}
				case OBTAIN_N_POWERUPS_FROM_CHEST: {
					if(option_0 == -1 || option_0 == null) 
						return "GAIN " + colorOpenTag(targetColor) + quantity.toString() + " POWER-UPS</font> FROM " + stringByCount('CHEST', 'CHESTS', quantity);
					else
						return "GAIN " + colorOpenTag(targetColor) + quantity.toString() + " POWER-UPS</font> FROM " + ChestsData.chestTypeToString(option_0) + stringByCount(' CHEST', ' CHESTS', quantity);
				}
				case OBTAIN_N_CUSTOMIZERS_FROM_CHEST: {
					if(option_0 == -1 || option_0 == null) 
						return "GAIN " + colorOpenTag(targetColor) + quantity.toString() + " INVENTORY " + stringByCount('ITEM', 'ITEMS', quantity) + "</font> FROM CHESTS";
					else
						return "GAIN " + colorOpenTag(targetColor) + quantity.toString() + " INVENTORY " + stringByCount('ITEM', 'ITEMS', quantity) + "</font> FROM " + ChestsData.chestTypeToString(option_0) + " CHESTS"; 
				}
			}
			
			return 'UNKNOWN TARGET: ' + type;
		}
		
		private static function getTargetStringByCount(wordSingle:String, wordPlural:String, quantity:int, addWord:String = null):String 
		{
			return quantity + ' ' + (addWord ? (addWord + ' ') : '') + (quantity > 1 ? wordPlural : wordSingle);
		}
		
		private static function stringByCount(wordSingle:String, wordPlural:String, quantity:int, suffixWord:String = null, postfixWord:String = null):String 
		{
			if (!suffixWord && !postfixWord)
				return quantity > 1 ? wordPlural : wordSingle;
			
			return (suffixWord ? (suffixWord + ' ') : '') + (quantity > 1 ? wordPlural : wordSingle) + (postfixWord ? (' ' + postfixWord) : '');
		}

		private static function colorOpenTag(color:String):String 
		{
			return "<font color='" + color + "'>";
		}
		
		private static function numberToAdjectives(number:int):String 
		{
			switch(number) {
				case 0: return '0';
				case 1: return '1ST';
				case 2: return '2ND';
				case 3: return '3RD';
			}
			
			return number.toString() + 'TH';
		}
	}

}