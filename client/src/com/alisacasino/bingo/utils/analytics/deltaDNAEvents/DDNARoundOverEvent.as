package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.chests.ChestsData;
	import com.alisacasino.bingo.models.powerups.PowerupModel;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.protocol.ChestWinMessage;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.RoomMessage;
	import com.alisacasino.bingo.protocol.Type;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNARoundOverEvent extends DDNAEvent
	{
		
		public function DDNARoundOverEvent(gamesCount:uint, bingosInARound:uint, prizes:Array, earnedPowerups:Object, chestWin:ChestWinMessage, liveEventScoreEarned:uint, room:RoomMessage, cellsDaubed:int, cardsPlayed:uint, xpEarned:int, stakeMultiplier:int, scoreStakeMultiplier:Number) 
		{
			super();
			addEventType("roundOver");
			
			addParamsField("bingoNum", bingosInARound);
			
			var wonChestType:int = -1;
			addRoundID();
			if (!gameManager.tutorialManager.allTutorialLevelsPassed)
			{
				wonChestType = gameManager.tutorialManager.getChestParameters()[0];
			}
			else
			{
				wonChestType = chestWin ? chestWin.type : -1;
			}
			
			addParamsField("chestType", ChestsData.chestTypeToString(wonChestType));
			addParamsField("isTutorial", !gameManager.tutorialManager.allTutorialLevelsPassed);
			addParamsField("gamesCount", gamesCount);
			addParamsField("matchType", "normal");
			addParamsField("bingoNum", bingosInARound);
			addParamsField("matchName", gameManager.tournamentData.collection.name);
			addParamsField("scoreEarned", liveEventScoreEarned);
			addParamsField("cellsDaubed", cellsDaubed);
			addParamsField("cardsPlayed", cardsPlayed);
			addParamsField("xpEarned", xpEarned);
			addParamsField("reward", createRewardObject("roundReward", packRewards(prizes, earnedPowerups)));
			addParamsField("stakeMultiplier", stakeMultiplier);
			addParamsField("scoreStakeMultiplier", scoreStakeMultiplier);
		}
		
		private function packRewards(prizes:Array, earnedPowerups:Object):Array
		{
			var pack:Array = [];
			for each (var prizeItem:CommodityItemMessage in prizes) 
			{
				pack.push(prizeItem);
			}
			
			for (var powerupType:String in earnedPowerups) 
			{
				var cim:CommodityItemMessage = new CommodityItemMessage();
				cim.type = Type.POWERUP;
				cim.powerupType = PowerupModel.getMessagePowerupTypeByID(powerupType);
				cim.quantity = earnedPowerups[powerupType];
				pack.push(cim);
			}
			
			return pack;
		}
		
	}

}