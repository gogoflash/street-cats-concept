package com.alisacasino.bingo.utils.analytics.events 
{
	import com.alisacasino.bingo.models.Player;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class PlayerStateEvent extends AnalyticsEvent
	{
		
		public function PlayerStateEvent(player:Player) 
		{
			addEventType("playerStateEvent");
			addField("coins", player.cashCount);
			addField("energy", gameManager.powerupModel.powerupsTotal);
		}
		
	}

}