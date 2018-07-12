package com.alisacasino.bingo.models.game 
{
	import com.alisacasino.bingo.protocol.CollectionInfoMessage;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.protocol.XpLevelDataMessage;
	import com.netease.protobuf.UInt64;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class XPLevel 
	{
		public var rewards:Array;
		public var xpCount:Number;
		public var level:int;
		public var cashReward:uint;
		public var powerupReward:uint;
		
		public function XPLevel(xpLevelData:XpLevelDataMessage) 
		{
			rewards = xpLevelData.rewards;
			xpCount = xpLevelData.xpCount.toNumber();
			level = xpLevelData.xpLevel;
			powerupReward = 0;
			for each (var item:CommodityItemMessage in rewards) 
			{
				if (item.type == Type.CASH)
				{
					cashReward = item.quantity;
				}
				else if (item.type == Type.POWERUP)
				{
					powerupReward += item.quantity;
				}
			}
		}
		
		public function toString():String 
		{
			return "[XPLevel rewards=" + rewards + " xpCount=" + xpCount + " level=" + level + " cashReward=" + cashReward + 
						" powerupReward=" + powerupReward + "]";
		}
		
	}

}