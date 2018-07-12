package com.alisacasino.bingo.models.game 
{
	import com.alisacasino.bingo.protocol.StaticDataMessage;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CardValues 
	{
		public var freeScoreCellScoreMin:uint = 5;
		public var freeScoreCellScoreMax:uint = 15;
		
		public function CardValues() 
		{
			
		}
		
		public function deserializeStaticData(staticData:StaticDataMessage):void 
		{
			if (staticData.hasFreeScoreCellScoreMin)
			{
				freeScoreCellScoreMin = staticData.freeScoreCellScoreMin;
			}
			
			if (staticData.hasFreeScoreCellScoreMax)
			{
				freeScoreCellScoreMax = staticData.freeScoreCellScoreMax;
			}
		}
		
	}

}