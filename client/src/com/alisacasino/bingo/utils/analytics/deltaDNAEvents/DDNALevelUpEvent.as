package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	import com.alisacasino.bingo.models.game.XPLevel;
	import com.alisacasino.bingo.models.powerups.PowerupModel;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.Type;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNALevelUpEvent extends DDNAEvent
	{
		
		public function DDNALevelUpEvent(levelData:XPLevel) 
		{
			super();
			addEventType("levelUp");
			
			addParamsField("levelUpName", levelData.level.toString());
			addParamsField("reward", createRewardObject("level_" + levelData.level.toString + "_reward", levelData.rewards));
		}
		
	}

}