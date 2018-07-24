package com.alisacasino.bingo.models
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.models.collections.CollectionItem;
	import com.alisacasino.bingo.models.game.XPLevel;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.models.powerups.PowerupModel;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.models.roomClasses.RoomType;
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.protocol.CardMessage;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.PlayerMessage;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.protocol.XpLevelDataMessage;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.store.IStoreItem;
	import com.alisacasino.bingo.store.items.CashStoreItem;
	import com.alisacasino.bingo.store.items.PowerupPackStoreItem;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.Settings;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNALevelUpEvent;
	import com.netease.protobuf.UInt64;
	import starling.core.Starling;
	import starling.events.EventDispatcher;
	
	public class Player extends EventDispatcher
	{
		static public const PURCHASE_REGISTERED:String = "purchaseRegistered";
		static public const EVENT_LEVEL_CHANGE:String = "EVENT_LEVEL_CHANGE";
		static public const EVENT_LIFE_TIME_VALUE_CHANGE:String = "EVENT_LIFE_TIME_VALUE_CHANGE";
		static public const EVENT_CASH_CHANGE:String = "EVENT_CASH_CHANGE";
		
		static public var IS_DEBUG_ROUND:Boolean;
		
		public var badBingosInARound:int;
		
		public var sequenceRoundLossCount:int;
		public var sequenceRoundWinsCount:int;
		
		public var mPlayerId:UInt64;
		private var mFacebookId:String;
		private var _avatarSource:String;
		private var mFirstName:String;
		private var mLastName:String;
		private var mNickName:String;
		private var mXpCount:uint;
		private var mXpLevel:uint;
		private var mCoinsCount:uint;
		private var _reservedCashCount:int;
		private var mBingosCount:uint;
		private var mDaubsCount:uint;
		private var mGamesCount:uint;
		private var mPowerupsUsedCount:uint;
		private var mMagicboxesOpenedCount:uint;
		private var mCompletedObjectives:Array;
		private var mItems:Array;
		private var mGender:int;
		private var mCountry:String;
		private var mBonusUsedTimestamp:UInt64;
		private var mCards:Array;
		private var mIsActivePlayer:Boolean;
		private var mXpEarned:uint;
		private var mBingosInARound:uint;
		private var mInvitesSentCount:uint;
		private var mItemsFound:Array;
		private var mIsFirstPlaceBingo:Boolean;
		private var mIsInstantBingo:Boolean;
		private var mLifetime:uint;
		private var mLifetimeValue:uint;
		private var mNextPeriodicTimeValue:Number = 0;
		
		//private var mCurrentLiveEventScore:Number = 0;
		//private var mCurrentLiveEventRank:uint;
		private var mLiveEventScoreEarned:uint;
		private var mPlatform:int;
		private var cardsBadBingosData:Object;
		private var _isAdmin:Boolean;
		
		private var _customizerCardId:int;
		private var _customizerDaubId:int;
		private var _customizerVoiceOverId:int;
		private var _customizerAvatarId:int;
		
		private static var sCurrentPlayer:Player = null;

		
		public static function get current():Player
		{
			return sCurrentPlayer;
		}
		
		public static function set current(player:Player):void
		{
			sCurrentPlayer = player;
		}
		
		public function Player(m:PlayerMessage)
		{
			mCards = [];
			deserialize(m);
			cardsBadBingosData = {};
		}
		
		public function deserialize(m:PlayerMessage):void
		{
			if (!m)
			{
				sosTrace("No player message passed to Player.updateFromPlayerMessage", SOSLog.WARNING);
				return;
			}
			mPlayerId = m.playerId;
			mFacebookId = m.facebookIdString;
			mFirstName = m.firstName;
			mLastName = m.lastName;
			mNickName = m.nickName;
			mXpCount = m.xpCount;
			mXpLevel = m.xpLevel;
			mBingosCount = m.bingosCount;
			mDaubsCount = m.daubsCount;
			mGamesCount = m.gamesCount;
			_avatarSource = getAlternativeAvatarURL(m);
			
			for each (var item:CommodityItemMessage in m.account) 
			{
				if (item.type == Type.CASH)
				{
					mCoinsCount = item.quantity;
				}
				if (item.type == Type.DUST)
				{
					_dustCount = item.quantity;
				}
			}
			
			chestsOpened = m.openChestsCount;
	//GameScreen.debugShowTextField('ChestOpened from server: ' + chestsOpened.toString() + " " + m.openChestsCount.toString(), true);
			mPowerupsUsedCount = m.powerupsUsedCount;
			mMagicboxesOpenedCount = m.magicboxesOpenedCount;
			mCompletedObjectives = m.completedObjectives;
			mItems = m.items;
			mGender = m.gender;
			mCountry = m.country;
			mLifetime = m.lifetime;
			mLifetimeValue = m.lifetimeValue;
			tournamentFirstPlaces = m.firstPlaceCount;
			tournamentSecondPlaces = m.secondPlaceCount;
			tournamentThirdPlaces = m.thirdPlaceCount;
			if(m.hasPeriodicBonusTimeMillis)
				mNextPeriodicTimeValue = m.periodicBonusTimeMillis.toNumber();
			mBonusUsedTimestamp = m.bonusUsedTimestamp;
			mInvitesSentCount = m.invitesSentCount;
			mCards = [];
			mItemsFound = [];
			if (m.hasPlatform) {
				mPlatform = m.platform;
			}
			
			_isAdmin = m.accessLevel == 'DEVELOPER';
			
			if (m.hasCustomizationSettings) {
				_customizerCardId = m.customizationSettings.selectedCardId;
				_customizerDaubId = m.customizationSettings.selectedDaubIconId;
				_customizerVoiceOverId = m.customizationSettings.selectedVoiceOverId;
				_customizerAvatarId = m.customizationSettings.selectedAvatarId;
			}
		}
		
		public function get playerId():Number
		{
			return mPlayerId ? mPlayerId.toNumber() : 0;
		}
		
		public static function getAvatarURL(url:String, facebookId:String, width:int = 85, height:int = 85):String
		{
			if (url && url != '')
				return url;
			
			if (facebookId != null && facebookId != "0" && facebookId != '') 
				return Settings.instance.avatarProxyPrefix + "https://graph.facebook.com/v2.7/" + facebookId + "/picture?width=" + width + "&height=" + height;
			
			return null;
		}
		
		public static function getAlternativeAvatarURL(player:PlayerMessage):String
		{
			if (!player || player.avatar == null || player.avatar == '')
				return null;
			
			return Constants.AVATARS_URL + player.avatar;
		}
		
		public function get facebookId():String
		{
			return mFacebookId;
		}	
		
		/** alternative avatar url */
		public function get avatarSource():String
		{
			return _avatarSource;
		}
		
		public function get firstName():String
		{
			return mFirstName;
		}
		
		public function get lastName():String
		{
			return mLastName;
		}
		
		public function get fullName():String
		{
			if(mLastName != null && mLastName != '')
				return (mFirstName || '') + " " + mLastName;
				
			return mFirstName;
		}
		
		public function get xpCount():uint
		{
			return mXpCount;
		}
		
		public function set xpCount(value:uint):void
		{
			if (mXpCount == value)
				return;
				
			mXpCount = value;
		}
		
		public function get xpLevel():uint
		{
			return mXpLevel;
		}
		
		public function set xpLevel(value:uint):void
		{
			var oldLevel:uint = mXpLevel;
			mXpLevel = value;
			if (oldLevel != mXpLevel)
				dispatchEventWith(EVENT_LEVEL_CHANGE);
		}
		
		public function get level():uint
		{
			return gameManager.gameData.getLevelForXp(xpCount);
		}
		
		public function get cashCount():uint
		{
			return mCoinsCount;
		}
		
		public function setCashCount(value:uint, source:String):void
		{
			if (mCoinsCount != value)
			{
				var cashChange:int = value - mCoinsCount;
				mCoinsCount = value;
				gameManager.customOfferManager.triggerCriticalResourceValues();
				gameManager.analyticsManager.sendCommodityAddedEvent(CommodityType.CASH, cashChange, source);
				gameManager.questModel.cashCollected(cashChange, source);
				gameManager.connectionManager.sendPlayerUpdateMessage();
				dispatchEventWith(EVENT_CASH_CHANGE);
			}
		}
		
		public function updateCashCount(value:int, source:String):void 
		{
			setCashCount(cashCount + value, source);
		}
		
		public function set reservedCashCount(value:int):void {
			_reservedCashCount = value;
		}
		
		public function get reservedCashCount():int {
			return _reservedCashCount;
		}
		
		private var cleanReservedCashCountId:int = -1;
		
		public function cleanReservedCashCount(delay:Number = 0):void 
		{
			if (_reservedCashCount == 0)
				return;
				
			if (cleanReservedCashCountId != -1) {
				Starling.juggler.removeByID(cleanReservedCashCountId);
				cleanReservedCashCountId = -1;
			}
			
			if (delay == 0)
				_reservedCashCount = 0;
			else
				cleanReservedCashCountId = Starling.juggler.delayCall(cleanReservedCashCount, delay, 0);
		}
		
		public function get bingosCount():uint
		{
			return mBingosCount;
		}
		
		public function set bingosCount(value:uint):void
		{
			mBingosCount = value;
		}
		
		public function get daubsCount():uint
		{
			return mDaubsCount;
		}
		
		public function set daubsCount(value:uint):void
		{
			mDaubsCount = value;
		}
		
		public function get gamesCount():uint
		{
			return mGamesCount;
		}
		
		public function set gamesCount(value:uint):void
		{
			mGamesCount = value;
		}
		
		public function get powerupsUsedCount():uint
		{
			return mPowerupsUsedCount;
		}
		
		public function set powerupsUsedCount(value:uint):void
		{
			mPowerupsUsedCount = value;
		}
		
		public function get magicboxesOpenedCount():uint
		{
			return mMagicboxesOpenedCount;
		}
		
		public function set magicboxesOpenedCount(value:uint):void
		{
			mMagicboxesOpenedCount = value;
		}

		public function get completedObjectives():Array
		{
			return mCompletedObjectives;
		}

        public function get nextPeriodicTimeValue():Number {
            return mNextPeriodicTimeValue;
        }

        public function set nextPeriodicTimeValue(value:Number):void {
            mNextPeriodicTimeValue = value;
        }

        public function set completedObjectives(value:Array):void
		{
			mCompletedObjectives = value;
		}
		
		public function get items():Array
		{
			return mItems;
		}
		
		public function set items(value:Array):void
		{
			mItems = value;
		}
		
		public function get bonusUsedTimestamp():Number
		{
			return 100000//mBonusUsedTimestamp.toNumber();
		}
		
		public function set bonusUsedTimestamp(value:Number):void
		{
			mBonusUsedTimestamp = UInt64.fromNumber(value);
		}
		
		public function get lifetime():uint
		{
			return mLifetime;
		}
		
		public function get lifetimeValue():uint
		{
			return mLifetimeValue;
		}
		
		public function set lifetimeValue(value:uint):void
		{
			mLifetimeValue = value;
			dispatchEventWith(EVENT_LIFE_TIME_VALUE_CHANGE);
		}
		
		public function get cards():Array
		{
			return mCards;
		}
		
		public function parseCardMessages(cardMessages:Array):void
		{
			mCards = [];
			for each (var cardMessage:CardMessage in cardMessages) {
				mCards.push(new Card(cardMessage));
			}
		}
		
		public function clearCards():void
		{
			mCards = [];
		}
		
		public function get cardsIdsHash():String
		{
			if (!mCards)
				return '';
			
			var ids:String = '';
			for (var i:int = 0; i < mCards.length; i++) {
				ids += (mCards[i] as Card).cardId.toString();
			}
			return ids;
		}
		
		public function clearEarned():void
		{
			xpEarned = 0;
			cashEarnedInRound = 0;
			cashEarnedFromRoundPrizes = 0;
			powerupsUsedInRound = 0;
			liveEventScoreEarned = 0;
		}
		
		public function consumeStoreItem(item:IStoreItem):void
		{
			if (item is CashStoreItem) 
			{
				updateCashCount((item as CashStoreItem).quantity, "storeItem:" + item.itemId);
				_reservedCashCount += (item as CashStoreItem).quantity;
			}
			lifetimeValue += item.value;
			
			dispatchEventWith(PURCHASE_REGISTERED);
		}
		
		/**
		 * 
		 * @return object containing total earned powerups
		 */
		public function consumeEarned():Object
		{
			updateCashCount(cashEarnedFromRoundPrizes, "bingoPrize");
			updateCashCount(cashEarnedInRound, "daubCell");
			reservedCashCount += cashEarned; 
			
			powerupsEarned = PowerupModel.getEarnedPowerup(powerupsUsedInRound);
			var earnedPowerups:Object = gameManager.powerupModel.addPowerupsFromDrop(powerupsEarned, gameManager.powerupModel.roundEndDropTable, "roundEnd");
			gameManager.powerupModel.reservedPowerupsCount += powerupsEarned; 
			currentLiveEventScore += liveEventScoreEarned;
			gameManager.questModel.scoreEarned(liveEventScoreEarned, Room.current.stakeData);
			return earnedPowerups;
		}
		
		public function get isActivePlayer():Boolean
		{
			return mIsActivePlayer;
		}
		
		public function set isActivePlayer(value:Boolean):void
		{
			mIsActivePlayer = value;
		}
		
		public function get xpEarned():uint
		{
			return mXpEarned;
		}
		
		public function set xpEarned(value:uint):void
		{
			mXpEarned = value;
		}
		
		public var powerupsUsedInRound:uint = 0;
		
		public function get cashEarned():uint
		{
			return _cashEarnedInRound + _cashEarnedFromRoundPrizes;
		}
		
		
		public function get invitesSentCount():uint
		{
			return mInvitesSentCount;
		}
		
		public function set invitesSentCount(value:uint):void
		{
			mInvitesSentCount = value;
		}
		
		public function get itemsFound():Array
		{
			return mItemsFound;
		}
		
		public function set itemsFound(value:Array):void
		{
			mItemsFound = value;
		}
		
		public function get bingosInARound():uint
		{
			return mBingosInARound;
		}
		
		public function set bingosInARound(value:uint):void
		{
			mBingosInARound = value;
		}
		
		public function get isFirstPlaceBingo():Boolean
		{
			return mIsFirstPlaceBingo;
		}
		
		public function set isFirstPlaceBingo(value:Boolean):void
		{
			mIsFirstPlaceBingo = value;
		}
		
		public function get isInstantBingo():Boolean
		{
			return mIsInstantBingo;
		}
		
		public function set isInstantBingo(value:Boolean):void
		{
			mIsInstantBingo = value;
		}
		
		public function get luckyness():int
		{
			if (bingosCount < 10)
				return 1;
			
			return 0;
		}
		
		public function get coinsAntiAccumulationPolicyEnabled():Boolean
		{
			if (xpLevel <= Constants.ANTI_ACCUMULATION_POLICY_XP_LEVEL_THRESHOLD)
				return false;
			if (cashCount <= Constants.ANTI_ACCUMULATION_POLICY_COINS_THRESHOLD)
				return false;
			return true;
		}
		
		public function get ticketsAntiAccumulationPolicyEnabled():Boolean
		{
			if (xpLevel <= Constants.ANTI_ACCUMULATION_POLICY_XP_LEVEL_THRESHOLD)
				return false;
			return true;
		}
		
		public function get bingoRatio():Number
		{
			if (gamesCount == 0 || xpLevel <= 5) return 0;
			return bingosCount / gamesCount;
		}
		
		public function get currentLiveEventScore():Number
		{
			return gameManager.tournamentData.currentLiveEventScore;
		}
		
		public function set currentLiveEventScore(value:Number):void
		{
			previousLiveEventScore = gameManager.tournamentData.currentLiveEventScore;
			gameManager.tournamentData.currentLiveEventScore = value;
		}
		
		public var previousLiveEventScore:uint;

		public function get currentLiveEventRank():uint
		{
			return gameManager.tournamentData.currentLiveEventRank;
		}
		
		public function set currentLiveEventRank(value:uint):void
		{
			previousLiveEventRank = gameManager.tournamentData.currentLiveEventRank;
			gameManager.tournamentData.currentLiveEventRank = value;
		}
		
		public var previousLiveEventRank:uint;
		
		public function get liveEventScoreEarned():uint
		{
			return mLiveEventScoreEarned;
		}
		
		public function set liveEventScoreEarned(value:uint):void
		{
			mLiveEventScoreEarned = value;
		}

		public function get platform():int
		{
			return mPlatform;
		}
		
		public function get isAdmin():Boolean
		{
			return _isAdmin;
		}
		
		public function get customizerCardId():int
		{
			return _customizerCardId;
		}
		
		public function get customizerDaubId():int
		{
			return _customizerDaubId;
		}
		
		public function get customizerVoiceOverId():int
		{
			return _customizerVoiceOverId;
		}
		
		public function get customizerAvatarId():int
		{
			return _customizerAvatarId;
		}
		
		public function set customizerCardId(value:int):void
		{
			_customizerCardId = value;
		}
		
		public function set customizerDaubId(value:int):void
		{
			_customizerDaubId = value;
		}
		
		public function set customizerVoiceOverId(value:int):void
		{
			_customizerVoiceOverId = value;
		}
		
		public function set customizerAvatarId(value:int):void
		{
			_customizerAvatarId = value;
		}
		
		public function setBadBingoFinishTime(roomType:String, cardId:uint, timestamp:Number):void 
		{
			var key:String = roomType + cardId.toString() + 'timestamp';
			cardsBadBingosData[key] = timestamp;
		}
		
		public function getBadBingoFinishTime(roomType:String, cardId:int):Number 
		{
			var key:String = roomType + cardId.toString() + 'timestamp';
			return key in cardsBadBingosData ? cardsBadBingosData[key] : 0;
		}
		
		public function setBadBingoTimeCoefficient(roomType:String, cardId:uint, coefficient:int):void 
		{
			var key:String = roomType + /*cardId.toString() + */'coefficient';
			cardsBadBingosData[key] = coefficient;
		}
		
		public function getBadBingoTimeCoefficient(roomType:String, cardId:uint):int
		{
			var key:String = roomType + /*cardId.toString() + */'coefficient';
			return key in cardsBadBingosData ? cardsBadBingosData[key] : 0;
		}
				
		public function clearBadBingoFinishTimes(roomType:String):void 
		{
			var keys:Array = []; 
			for (var key:String in cardsBadBingosData) {
				if (key.indexOf(roomType) != -1)
					keys.push(key);
			}
			
			while (keys.length > 0) {
				delete cardsBadBingosData[keys.shift()];
			}
		}
		
		public function getXpForNextLevel():uint
		{
			return gameManager.gameData.getXpCountForLevel(xpLevel + 1);
		}
		
		public function get isBot():Boolean 
		{
			return (avatarSource != null && avatarSource != '') && (facebookId == '0' || facebookId == null || facebookId == '');
		}
		
		public var tournamentFirstPlaces:uint;
		public var tournamentThirdPlaces:uint;
		public var tournamentSecondPlaces:uint;
		public var powerupsEarned:uint;
		
		private var _dustCount:uint;
		private var _reservedDustCount:int;
		
		public function get dustCount():uint 
		{
			return _dustCount;
		}
		
		public function setDustCount(value:uint, source:String):void
		{
			if (_dustCount != value)
			{
				var dustChange:int = value - _dustCount;
				_dustCount = value;
				gameManager.analyticsManager.sendCommodityAddedEvent(CommodityType.DUST, dustChange, source);
				gameManager.connectionManager.sendPlayerUpdateMessage();
			}
		}
		
		public function updateDustCount(value:int, source:String):void 
		{
			setDustCount(dustCount + value, source);
		}
		
		public function set reservedDustCount(value:int):void {
			_reservedDustCount = value;
		}
		
		public function get reservedDustCount():int {
			return _reservedDustCount;
		}
		
		private var cleanReservedDustCountId:int = -1;
		
		public function cleanReservedDustCount(delay:Number = 0):void 
		{
			if (_reservedDustCount == 0)
				return;
				
			if (cleanReservedDustCountId != -1) {
				Starling.juggler.removeByID(cleanReservedDustCountId);
				cleanReservedDustCountId = -1;
			}
			
			if (delay == 0)
				_reservedDustCount = 0;
			else
				cleanReservedDustCountId = Starling.juggler.delayCall(cleanReservedDustCount, delay, 0);
		}
		
		
		private var _cashEarnedInRound:int;
		
		public function get cashEarnedInRound():int 
		{
			return _cashEarnedInRound;
		}
		
		public function set cashEarnedInRound(value:int):void 
		{
			_cashEarnedInRound = value;
		}
		
		private var _cashEarnedFromRoundPrizes:int;
		
		public function get cashEarnedFromRoundPrizes():int 
		{
			return _cashEarnedFromRoundPrizes;
		}
		
		public function set cashEarnedFromRoundPrizes(value:int):void 
		{
			_cashEarnedFromRoundPrizes = value;
		}
		
		private var _chestsOpened:int = -1;
		
		public function get chestsOpened():int
		{
			return _chestsOpened;
		}
		
		public function set chestsOpened(value:int):void 
		{
			if (_chestsOpened != value)
			{
				//GameScreen.debugShowTextField('chestsOpened ' + value.toString(), true);
				_chestsOpened = value;
				scheduleSave();
			}
		}
		
		private function scheduleSave():void 
		{
			gameManager.connectionManager.sendPlayerUpdateMessage();
		}
		
		public function get hasCards():Boolean
		{
			return cards && cards.length > 0;
		}
		
		public function debugCreateCards(count:int):void
		{
			mCards = [];
			var numbersCount:int;
			while (count-- > 0) 
			{
				numbersCount = 25;
				
				var cardMessage:CardMessage = new CardMessage();
				cardMessage.cardId = count;
				
				var numbers:Array = [];
				var j:int = 1;
				while (j <= 75) {
					numbers.push(j);
					j++;
				}
				
				var allColumnNumbers:Array;
				var columnNumbers:Array = [];
				var index:int;
				while (numbersCount-- > 0) 
				{
					if (columnNumbers.length % 5 == 0)
						allColumnNumbers = numbers.splice(0, 15);	
						
					index = Math.floor(allColumnNumbers.length * Math.random());
					columnNumbers.push(allColumnNumbers[index]);
					
					allColumnNumbers.splice(index, 1);
				}
				
				var i:int;
				var length:int = columnNumbers.length;
				for (i = 0; i < length; i++) {
					index = Math.max(0, i%5*5 /*- 1*/) + int(i/5);
					//trace('>> ', i, i%5, int(i/5), Math.max(0, i%5*5 - 1), Math.max(0, i%5*5 - 1) + int(i/5), index);
					//trace('> ', index, columnNumbers[index]);
					if(i != 12)
						cardMessage.numbers.push(columnNumbers[index]);
				}
				
				
				/*var numbers:Array = [];
				var j:int = 1;
				while (j <= 75) {
					numbers.push(j);
					j++;
				}
				
				numbersCount = 24;
				var columnNumbers:Array;
				while (numbersCount-- > 0) 
				{
					if (!columnNumbers) {
						columnNumbers = numbers.splice(0, 14);
					}
					
					var index:int = Math.floor(columnNumbers.length * Math.random());
					cardMessage.numbers.push(columnNumbers[index]);
					columnNumbers.splice(index, 1);
					
					if (cardMessage.numbers.length % 5 == 0) {
						columnNumbers = numbers.splice(0, 14);
					}
				}*/
				 
				mCards.push(new Card(cardMessage));
			}
		}
		
		public function refundAndClearCards():void 
		{
			updateCashCount(gameManager.tournamentData.getCardCost(cards.length), "cardRefund");
			clearCards();
			Game.connectionManager.sendPlayerUpdateMessage();
		}
		
		public function consumeExp():Array 
		{
			var previousLevel:int = gameManager.gameData.getLevelForXp(xpCount);
			
			if (xpCount + xpEarned > gameManager.gameData.maxXp)
				xpCount = Math.max(gameManager.gameData.maxXp, xpCount);
			else
				xpCount += xpEarned;
				
				
			xpLevel = gameManager.gameData.getLevelForXp(xpCount);
			
			var cashTotal:CommodityItemMessage = new CommodityItemMessage();
			cashTotal.type = Type.CASH;
			cashTotal.quantity = 0;
			
			var powerupTotal:CommodityItemMessage = new CommodityItemMessage();
			powerupTotal.type = Type.POWERUP;
			powerupTotal.quantity = 0;
			
			if (xpLevel > previousLevel)
			{
				for (var i:int = previousLevel + 1; i <= xpLevel; i++) 
				{
					var levelData:XPLevel = gameManager.gameData.getLevelData(i);
					for each (var item:CommodityItemMessage in levelData.rewards) 
					{
						if (item.type == Type.CASH)
						{
							updateCashCount(item.quantity, "levelUp");
							cashTotal.quantity += item.quantity;
						}
						if (item.type == Type.POWERUP)
						{
							gameManager.powerupModel.addPowerupFromMessage(item, "levelUp");
							powerupTotal.quantity += item.quantity;
						}
					}
					gameManager.analyticsManager.sendDeltaDNAEvent(new DDNALevelUpEvent(levelData));
				}
			}
			
			return [cashTotal, powerupTotal];
		}
		
		
		public function cleanAll():void
		{
			xpCount = 0;
			xpLevel = 0;
			bingosCount = 0;
			daubsCount = 0;
			gamesCount = 0;
			
			chestsOpened = 0;
			powerupsUsedCount = 0;
			mLifetime = 0;
			lifetimeValue = 0;
			nextPeriodicTimeValue = 0;
			bonusUsedTimestamp = 0;
			invitesSentCount = 0;
			
			completedObjectives = [];
			items = [];
			tournamentFirstPlaces = 0;
			tournamentSecondPlaces = 0;
			tournamentThirdPlaces = 0;
			
			clearCards();
			
			_isAdmin = false;
			
			customizerCardId = 0;
			customizerDaubId = 0;
			customizerVoiceOverId = 0;
			customizerAvatarId = 0;
			
		}
		
		public static function playerId(emptyString:String = ''):String {
			return Player.current ? String(Player.current.playerId) : emptyString;
		}
		
	}
}