package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNACardBingoedEvent extends DDNAEvent
	{
		
		public function DDNACardBingoedEvent(placeInRound:int, x2:Boolean, pattern:String, matchedPatterns:int) 
		{
			addEventType("cardBingoed");
			addParamsField("placeInRound", placeInRound);
			addParamsField("x2Active", x2);
			addParamsField("bingoPattern", pattern);
			addParamsField("bingoPatternsMatched", matchedPatterns);
			addRoundID();
		}
		
	}

}