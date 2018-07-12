package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.roomClasses.Room;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNARoundStartedEvent extends DDNAEvent
	{
		
		public function DDNARoundStartedEvent() 
		{
			super();
			addEventType("roundStarted");
			
			addRoundID();
			
			var cardsPlayed:int = Player.current ? Player.current.cards.length : 0;
			
			addParamsField("isTutorial", !gameManager.tutorialManager.allTutorialLevelsPassed);
			addParamsField("gamesCount", Player.current ? Player.current.gamesCount + 1 : 0);
			addParamsField("cardsPlayed", cardsPlayed);
			addParamsField("stakeMultiplier", Room.current.stakeData.multiplier);
			addParamsField("scoreStakeMultiplier", Room.current.getPointsBonusForCurrentCards());
			
			addParamsField("matchType", "normal");
			addParamsField("matchName", gameManager.tournamentData.collection.name);
		}
		
	}

}