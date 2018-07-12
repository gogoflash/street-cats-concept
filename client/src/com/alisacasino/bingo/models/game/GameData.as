package com.alisacasino.bingo.models.game 
{
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.protocol.CardType;
	import com.alisacasino.bingo.protocol.CurrencyConverter;
	import com.alisacasino.bingo.protocol.StakeDataMessage;
	import com.alisacasino.bingo.protocol.StaticDataMessage;
	import com.alisacasino.bingo.protocol.XpLevelDataMessage;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class GameData 
	{
		private var _opengraphBasePath:String;
		
		public function get opengraphBasePath():String 
		{
			return _opengraphBasePath;
		}
		
		private var _cardValues:CardValues;
		
		public function get cardValues():CardValues 
		{
			return _cardValues;
		}
		
		private var _badBingoTimerAttempts:int = 0;
		private var playerLevels:Vector.<XPLevel>;
		
		public var daubPoints:uint;
		public var daubXP:uint;
		public var pointPowerupQuantity:uint;
		public var xpPowerupQuantity:uint;
		public var cashPowerupQuantity:uint;
		
		public var x2TimeMs:uint = 30000;
		
		private var _maxLevel:int;
		private var _maxXp:int;
		
		public var stakes:Vector.<StakeData>;
		
		public var firstBallInterval:int;
		public var ballInterval:int;
		public var ballThreshold:int;
		
		public function get badBingoTimerAttempts():int 
		{
			return _badBingoTimerAttempts;
		}
		
		public var inviteFriendsShareOpengraphURL:String;
		
		private var currencyConverter:CurrencyConverter;
		
		public function GameData() 
		{
			_cardValues = new CardValues();
			playerLevels = new Vector.<XPLevel>();
			stakes = new Vector.<StakeData>();
		}
		
		
		public function deserializeStaticData(staticData:StaticDataMessage):void 
		{
			cardValues.deserializeStaticData(staticData);
			_badBingoTimerAttempts = staticData.badBingoTimerAttempts;
			_opengraphBasePath = staticData.opengraphPath;
			daubPoints = staticData.daubPoints;
			daubXP = staticData.daubXP;
			pointPowerupQuantity = staticData.pointPowerupQuantity;
			xpPowerupQuantity = staticData.xpPowerupQuantity;
			cashPowerupQuantity = staticData.cashPowerupQuantity;
			var xpLevel:XPLevel;
			for (var i:int = 0; i < staticData.levels.length; i++) 
			{
				xpLevel = new XPLevel(staticData.levels[i]);
				_maxLevel = Math.max(_maxLevel, xpLevel.level);
				_maxXp = Math.max(_maxXp, xpLevel.xpCount);
				playerLevels.push(xpLevel);
			}
			
			inviteFriendsShareOpengraphURL = staticData.inviteShareUrl;
			
			currencyConverter = staticData.currencyConverter;
			
			firstBallInterval = staticData.startBallInterval;
			ballInterval = staticData.ballInterval;
			ballThreshold = staticData.ballThreshold;
			
			deserializeStakes(staticData.stakes);
		}
		
		private function deserializeStakes(rawStakes:Array):void 
		{
			stakes.splice(0, stakes.length);
			for each (var item:StakeDataMessage in rawStakes) 
			{
				stakes.push(StakeData.fromStakeDataMessage(item));
			}
			stakes = stakes.sort(StakeData.sortFunction);
		}
		
		public function getLevelForXp(xpValue:uint):uint
		{
			if (playerLevels.length == 0)
				return 0;
			
			var level:XPLevel = playerLevels[0];
			for (var i:int = 0; i < playerLevels.length; i++) 
			{
				if (playerLevels[i].xpCount > xpValue)
					break;
				level = playerLevels[i];
			}
			
			return level.level;
		}
		
		public function getRewardTicketsForLevel(xpLevel:uint):uint 
		{
			return getLevelData(xpLevel).cashReward;
		}
		
		public function getRewardPowerups(xpLevel:uint):uint
		{
			return getLevelData(xpLevel).powerupReward;
		}
		
		public function getLevelData(xpLevel:uint):XPLevel
		{
			if (playerLevels.length > xpLevel)
			{
				return playerLevels[Math.max(0, xpLevel - 1)];
			}
			else 
			{
				return playerLevels[playerLevels.length - 1];
			}
		}
		
		public function getXpCountForLevel(xpLevel:int):Number
		{
			return getLevelData(xpLevel).xpCount;
		}
		
		public function get maxLevel():int 
		{
			return _maxLevel;
		}
		
		public function get maxXp():int 
		{
			return _maxXp;
		}
		
		public function getCollectionDustGain(rarity:int):Number 
		{
			if (!currencyConverter)
				return 0;
				
			switch(rarity) {
				case CardType.NORMAL: 	return currencyConverter.dustGainCollectionNormal;
				case CardType.RARE: 	return currencyConverter.dustGainCollectionRare;
				case CardType.MAGIC: 	return currencyConverter.dustGainCollectionMagic;
			}
			
			return 0;
		}
		
		public function getCustomizerDustGain(rarity:int):Number 
		{
			if (!currencyConverter)
				return 0;
				
			switch(rarity) {
				case CardType.NORMAL: 	return currencyConverter.dustGainCustomizerNormal;
				case CardType.RARE: 	return currencyConverter.dustGainCustomizerRare;
				case CardType.MAGIC: 	return currencyConverter.dustGainCustomizerMagic;
			}
			
			return 0;
		}
		
		public function getDataByDaubStreak(daubStreak:int):DaubStreakData
		{
			switch(daubStreak)
			{
				case 0: return null;
				case 1: return null;
				case 2: return new DaubStreakData(XTextFieldStyle.CellDaubFlyUpXP, 10, -32);
				case 5: return new DaubStreakData(XTextFieldStyle.CellDaubFlyUpXP_X2, 50, -32);
				case 10: return new DaubStreakData(XTextFieldStyle.Streak10x, 50, -36);
				default: return new DaubStreakData(XTextFieldStyle.CellDaubFlyUpXP, 0, -32);
			}
		}
		
		public function getStakeDataFor(stake:uint):StakeData 
		{
			for each (var item:StakeData in stakes) 
			{
				if (item.multiplier == stake)
					return item;
			}
			return stakes[0];
		}
		
		public function getDefaultStake():StakeData
		{
			return stakes[0];
		}
		
		public function get dustCostChestConversion():Number 
		{
			if (!currencyConverter)
				return 0;
				
			return currencyConverter.dustCostChestConversion;
		}	
		
	}

}