package com.alisacasino.bingo.models.quests 
{
	import com.alisacasino.bingo.models.game.StakeData;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.ICardData;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public interface IQuestNotifier 
	{
		
		function bingoClaimed(x2Active:Boolean, placeInRound:int, bingoPatterns:Vector.<String>, stakeData:StakeData):void;
		
		function powerupClaimedFromCard(powerup:String):void;
		
		function cardBurned(card:ICardData, quantity:int):void;
		
		function cardCollected(card:ICardData):void;
		
		function cashCollected(quantity:int, source:String):void;
		
		function powerupUsed(powerup:String):void;
		
		function chestOpened(type:int, rewards:Array):void;
		
		function scoreEarned(score:int, stakeData:StakeData):void;
		
		function daubRegistered(number:int):void;
		
		function daubStreakProgress(streak:int):void;
		
		function roundStart(numCards:int, stakeData:StakeData):void;
		
		function roundEnd(numCards:int, stakeData:StakeData):void;
	}
	
}