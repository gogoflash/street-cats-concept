package com.alisacasino.bingo.models.tournament 
{
	import com.alisacasino.bingo.protocol.TournamentPlaceRewardDataMessage;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class LeagueData 
	{
		public var name:String;
		public var rewards:Array;
		public var description:String;
		
		public function LeagueData() 
		{
			
		}
		
		static public function fromTournamentPlaceRewardDataMessage(item:TournamentPlaceRewardDataMessage):LeagueData
		{
			var leagueData:LeagueData = new LeagueData();
			leagueData.name = item.league;
			leagueData.rewards = item.prizes;
			leagueData.description = item.description;
			return leagueData;
		}
		
	}

}