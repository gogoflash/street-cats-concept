package com.alisacasino.bingo.commands.messages 
{
	import avmplus.getQualifiedClassName;
	import com.alisacasino.bingo.commands.ICommand;
	import com.alisacasino.bingo.protocol.BadBingoMessage;
	import com.alisacasino.bingo.protocol.BallMessage;
	import com.alisacasino.bingo.protocol.BingoOkMessage;
	import com.alisacasino.bingo.protocol.BuyCardsOkMessage;
	import com.alisacasino.bingo.protocol.ClaimOfferOkMessage;
	import com.alisacasino.bingo.protocol.ErrorMessage;
	import com.alisacasino.bingo.protocol.HelloMessage;
	import com.alisacasino.bingo.protocol.JoinOkMessage;
	import com.alisacasino.bingo.protocol.LeaveOkMessage;
	import com.alisacasino.bingo.protocol.LiveEventInfoOkMessage;
	import com.alisacasino.bingo.protocol.LiveEventLeaderboardsOkMessage;
	import com.alisacasino.bingo.protocol.LiveEventScoreUpdateOkMessage;
	import com.alisacasino.bingo.protocol.PlayerBingoedMessage;
	import com.alisacasino.bingo.protocol.PlayerBoughtCardsMessage;
	import com.alisacasino.bingo.protocol.PlayerUpdateOkMessage;
	import com.alisacasino.bingo.protocol.PurchaseFailedMessage;
	import com.alisacasino.bingo.protocol.PurchaseOkMessage;
	import com.alisacasino.bingo.protocol.RequestIncomingItemsOkMessage;
	import com.alisacasino.bingo.protocol.RoundOverMessage;
	import com.alisacasino.bingo.protocol.RoundStartedMessage;
	import com.alisacasino.bingo.protocol.RoundStateMessage;
	import com.alisacasino.bingo.protocol.ServerStatusMessage;
	import com.alisacasino.bingo.protocol.SignInOkMessage;
	import com.alisacasino.bingo.protocol.TournamentEndMessage;
	import com.alisacasino.bingo.utils.ConnectionManager;
	import com.netease.protobuf.Message;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class MessageRoutingTable 
	{
		private static var routingTable:Dictionary;
		
		public static function getHandlingCommand(message:Message):ICommand
		{
			if (!routingTable)
			{
				createRoutingTable();
			}
			
			var messageClass:Class = Object(message).constructor;
			
			var commandClass:Class = routingTable[messageClass] as Class;
			
			if (commandClass == null)
			{
				if(ConnectionManager.LOGGING_ENABLED)
					sosTrace("No command found in routing table for " + getQualifiedClassName(messageClass), SOSLog.WARNING);
				return null;
			}
			
			return new commandClass(message);
		}
		
		static private function createRoutingTable():void 
		{
			routingTable = new Dictionary();
			
			addToTable(RequestIncomingItemsOkMessage, 	HandleRequestIncomingItemsOkMessage);
			addToTable(BallMessage, 					HandleBallMessage);
			addToTable(PlayerBoughtCardsMessage, 		HandleRequestPlayerBoughtCardsMessage);
			addToTable(BuyCardsOkMessage, 				HandleRequestBuyCardsOkMessage);
			addToTable(PlayerBingoedMessage, 			HandleRequestPlayerBingoedMessage);
			addToTable(BingoOkMessage, 					HandleRequestBingoOkMessage);
			addToTable(PlayerUpdateOkMessage, 			HandleRequestPlayerUpdateOkMessage);
			addToTable(JoinOkMessage, 					HandleRequestJoinOkMessage);
			addToTable(LeaveOkMessage, 					HandleRequestLeaveOkMessage);
			addToTable(RoundStartedMessage, 			HandleRequestRoundStartedMessage);
			addToTable(RoundOverMessage, 				HandleRequestRoundOverMessage);
			addToTable(BadBingoMessage, 				HandleRequestBadBingoMessage);
			addToTable(HelloMessage, 					HandleRequestHelloMessage);
			addToTable(SignInOkMessage, 				HandleSignInOkMessage);
			addToTable(PurchaseOkMessage, 				HandlePurchaseOkMessage);
			addToTable(LiveEventLeaderboardsOkMessage, 	HandleRequestLiveEventLeaderboardsOkMessage);
			addToTable(LiveEventScoreUpdateOkMessage, 	HandleRequestLiveEventScoreUpdateOkMessage);
			addToTable(PurchaseFailedMessage, 			HandleRequestPurchaseFailedMessage);
			addToTable(ErrorMessage, 					HandleRequestErrorMessage);
			addToTable(ClaimOfferOkMessage, 			HandleRequestClaimOfferOkMessage);
			addToTable(TournamentEndMessage, 			HandleTournamentEndMessage);
			addToTable(RoundStateMessage, 				HandleRoundStateMessage);
			addToTable(ServerStatusMessage, 			HandleServerStatusMessage);
		}
		
		static private function addToTable(messageClass:Class, handlingCommandClass:Class):void 
		{
			routingTable[messageClass] = handlingCommandClass;
		}
		
	}

}