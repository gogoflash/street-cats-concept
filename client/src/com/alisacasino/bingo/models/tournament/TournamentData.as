package com.alisacasino.bingo.models.tournament 
{
	import com.alisacasino.bingo.assets.BackgroundAsset;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.tournamentResultDialogClasses.TournamentResultDialog;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.collections.Collection;
	import com.alisacasino.bingo.models.collections.CollectionEffects;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.protocol.CollectionInfoOkMessage;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.EventPrizeMessage;
	import com.alisacasino.bingo.protocol.LiveEventInfoOkMessage;
	import com.alisacasino.bingo.protocol.PlayerMessage;
	import com.alisacasino.bingo.protocol.PrizeItemMessage;
	import com.alisacasino.bingo.protocol.SignInOkMessage;
	import com.alisacasino.bingo.protocol.TournamentPlaceRewardDataMessage;
	import com.alisacasino.bingo.protocol.TournamentResultMessage;
	import com.alisacasino.bingo.protocol.TournamentTopPlayer;
	import com.alisacasino.bingo.utils.TimeService;
	import com.netease.protobuf.UInt64;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class TournamentData 
	{
		public var collection:Collection;
		public var currentTournamentID:uint;
		public var currentLiveEventScore:Number = 0;
		public var currentLiveEventRank:uint;
		public var currentTournamentName:String;
		public var endsAt:Number = 0;
		public var duration:Number = 0;
		
		public var pendingTournamentChange:Boolean;
		public var pendingCollection:Collection;
		public var pendingTournametInfo:LiveEventInfoOkMessage;
		public var tournamentResultToShow:TournamentResultMessage;
		public var currentTier:uint;
		
		private var leaguesByName:Object;
		private var noLeague:LeagueData;
		
		public function TournamentData() 
		{
			leaguesByName = { };
			noLeague = new LeagueData();
			noLeague.name = "No league";
			noLeague.description = "-";
			noLeague.rewards = [];
		}
		
		public function deserialize(message:SignInOkMessage):void
		{
			collection = gameManager.collectionsData.getCollectionByID(message.collectionInfo.collectionId);
			if (!collection)
			{
				sosTrace("No collection set for tournament! Selecting a random one.", SOSLog.ERROR);
				if (gameManager.collectionsData.collectionList.length)
				{
					collection = gameManager.collectionsData.collectionList[0];
				}
				else
				{
					sosTrace("No collections deserialized!", SOSLog.FATAL);
				}
			}
			
			deserializeLeagues(message.staticData.tournamentPlaceRewards);
			
			updateFromTournamentInfo(message.tournamentInfo);
			
			tournamentResultToShow = message.tournamentResult;
			//debugCreateTournamentResultToShow();
			if (tournamentResultToShow) {
				DialogsManager.addDialog(new TournamentResultDialog(tournamentResultToShow));
			}
		}
		
		private function deserializeLeagues(tournamentPlaceRewards:Array):void 
		{
			for each (var item:TournamentPlaceRewardDataMessage in tournamentPlaceRewards) 
			{
				var leagueData:LeagueData = LeagueData.fromTournamentPlaceRewardDataMessage(item);
				leaguesByName[leagueData.name] = leagueData;
			}
		}
		
		public function getLeagueByName(name:String):LeagueData
		{
			if (leaguesByName.hasOwnProperty(name))
			{
				return leaguesByName[name];
			}
			
			sosTrace("No league data with name \"" + name + "\"", SOSLog.ERROR);
			
			return noLeague;
		}
		
		public function getBackgroundAsset():BackgroundAsset
		{
			return collection ? collection.backgroundAsset : null;
		}
		
		public function setPendingData(tournamentInfo:LiveEventInfoOkMessage, collectionInfo:CollectionInfoOkMessage):void 
		{
			pendingCollection = gameManager.collectionsData.getCollectionByID(collectionInfo.collectionId);
			pendingTournametInfo = tournamentInfo;
			pendingTournamentChange = true;
		}
		
		public function setDataToPending(cleanLiveEventScoreEarned:Boolean = true):void 
		{
			collection = pendingCollection;
			pendingCollection = null;
			
			updateFromTournamentInfo(pendingTournametInfo, cleanLiveEventScoreEarned);
			pendingTournametInfo = null;
			
			pendingTournamentChange = false;
		}
		
		public function clearResultToShow():void 
		{
			tournamentResultToShow = null;
		}
		
		public function getCardCost(cardsCount:Number):Number 
		{
			return cardsCount * Math.floor(gameManager.tournamentData.currentTier * gameManager.tournamentData.collectionEffects.cardDiscountMod) * Room.current.stakeData.multiplier;
		}
		
		private function updateFromTournamentInfo(liveEventInfoOkMessage:LiveEventInfoOkMessage, cleanLiveEventScoreEarned:Boolean = true):void 
		{
			if (liveEventInfoOkMessage) {
				endsAt = liveEventInfoOkMessage.liveEventEndsAt.toNumber();
				currentLiveEventScore = liveEventInfoOkMessage.hasLiveEventScore ? liveEventInfoOkMessage.liveEventScore.toNumber() : 0;
				currentLiveEventRank = liveEventInfoOkMessage.liveEventRank;
				currentTournamentName = liveEventInfoOkMessage.liveEventName;
				currentTournamentID = uint(liveEventInfoOkMessage.liveEventId.toNumber());
				currentTier = liveEventInfoOkMessage.liveEventTier;
				duration = Math.max(0, endsAt - liveEventInfoOkMessage.liveEventStartsAt.toNumber());
			}
			
			if(Player.current && cleanLiveEventScoreEarned)
				Player.current.liveEventScoreEarned = 0;
		}
		
		public function get collectionEffects():CollectionEffects
		{
			return collection ? collection.collectionEffects : null;
		}
		
		
		public function tutorialForceChangeTournamentData(clearTournamentResultToShow:Boolean = false):void 
		{
			if (gameManager.tournamentData.pendingTournamentChange)
			{
				gameManager.tournamentData.setDataToPending(false);
				//Game.current.showGameScreen();
			}
			
			if(clearTournamentResultToShow)
				clearResultToShow();
		}
		
		public function debugCreateTournamentResultToShow():void 
		{
			tournamentResultToShow = debugCreateEventTournamentResultMessage();
			pendingTournametInfo = new LiveEventInfoOkMessage();
			pendingTournametInfo.liveEventEndsAt = UInt64.fromNumber(Math.random() * int.MAX_VALUE);
			pendingTournametInfo.liveEventId = new UInt64(1, 2);
			pendingTournametInfo.liveEventStartsAt = UInt64.fromNumber(Math.random() * int.MAX_VALUE);
			
			while (!pendingCollection || pendingCollection ==  collection)
			{
				pendingCollection = gameManager.collectionsData.collectionList[int(Math.random() * gameManager.collectionsData.collectionList.length)];
			}
			pendingTournamentChange = true;
			
			//new ShowTournamentEndAndReload().execute();
		}
		
		private function debugCreateEventTournamentResultMessage():TournamentResultMessage
		{
			var message:TournamentResultMessage = new TournamentResultMessage();
			var top:Array = []
			for (var i:int = 0; i < 3; i++) 
			{
				var ttp:TournamentTopPlayer = new TournamentTopPlayer();
				ttp.player = new PlayerMessage();
				
				ttp.player.playerId = UInt64.fromNumber(int(Math.random() * int.MAX_VALUE));
				ttp.player.firstName = ttp.player.playerId.toString(36);
				top.push(ttp);
			}
			message.top = top;
			
			message.eventPrizes = [debugCreateEventPrizeMessage()];
			
			return message;
		}
		
		private function debugCreateEventPrizeMessage():EventPrizeMessage
		{
			var eventPrizeMessage:EventPrizeMessage = new EventPrizeMessage();
			eventPrizeMessage.eventId = Math.random() * int.MAX_VALUE;
			//eventPrizeMessage.roomType = RoomType.FarmRoomType.roomTypeName;
			eventPrizeMessage.score = Math.random() * 1000 + 1000;
			eventPrizeMessage.place = Math.random() * 100;
			
			
			var prizePayload:PrizeItemMessage = new PrizeItemMessage();
			var commodity:CommodityItemMessage = new CommodityItemMessage();
			commodity.type = 0;
			commodity.quantity = 100;
			prizePayload.payload.push(commodity);
			
			eventPrizeMessage.prizePayload  = prizePayload;
			
			return eventPrizeMessage;
		}
	}

}