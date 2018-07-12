package com.alisacasino.bingo.commands.messages 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.protocol.BuyCardsOkMessage;
	import com.alisacasino.bingo.utils.ConnectionManager;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNACardBuyTransactonEvent;
	
	public class HandleRequestBuyCardsOkMessage extends CommandBase
	{
		private var message:BuyCardsOkMessage;
		
		public function HandleRequestBuyCardsOkMessage(message:BuyCardsOkMessage) 
		{
			this.message = message;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			Player.current.parseCardMessages(message.cards);
			Player.current.isActivePlayer = message.isActivePlayer;
			Player.current.clearBadBingoFinishTimes(Room.current.roomType.roomTypeName);
			sosTrace("HandleRequestBuyCardsOkMessage", "Room.current: ", Room.current, message.cards, Player.current.isActivePlayer);
			Room.current.roundID = message.roundId ? message.roundId.toString() : Room.UNKNOWN_ROUND_ID;
			Room.current.numbers = message.numbers;
			Room.current.bingoHistory = message.bingoedHistory;
			Room.current.stakeData = gameManager.gameData.getStakeDataFor(message.stake);
			Game.dispatchEventWith(ConnectionManager.BUY_CARDS_OK_EVENT, false, message);
			var numCards:int = message.cards.length;
			
			
			
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNACardBuyTransactonEvent(gameManager.tournamentData.getCardCost(numCards), numCards, Room.current.roundID));
			
			finish();
		}
		
	}

}