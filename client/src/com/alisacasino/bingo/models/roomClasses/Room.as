package com.alisacasino.bingo.models.roomClasses
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.models.game.DaubStreakData;
	import com.alisacasino.bingo.models.game.GameData;
	import com.alisacasino.bingo.protocol.RoomMessage;
	import com.alisacasino.bingo.utils.TimeService;
	import starling.core.Starling;

	import com.alisacasino.bingo.models.game.StakeData;
	import com.alisacasino.bingo.protocol.RoomMessage;
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class Room extends EventDispatcher
	{
		public static const DAUB_STREAKS_ENABLED:Boolean = false;
		static public var UNKNOWN_ROUND_ID:String = "unknown";
		
		public static var EVENT_ROUND_STATE_UPDATE:String = "EVENT_ROUND_STATE_UPDATE";
		
		public var hasActiveEvent:Boolean;
		public var activeEventName:String;
		public var activeEvent:EventInfo;
		public var estimatedRoundEnd:Number = 0;
		public var roundStartTime:Number = 0;
		public var bingoHistory:Array;
		
		public var currentRoundBallsCount:int = -1;
		private var nextBallAddTimestamp:Number = 0;
		
		public function get activeEventID():int
		{
			if (activeEvent)
				return activeEvent.id;
			
			return -1;
		}
		
		private var _stakeData:StakeData;
		
		public function get stakeData():StakeData 
		{
			return _stakeData ? _stakeData : gameManager.gameData.getDefaultStake();
		}
		
		public function set stakeData(value:StakeData):void 
		{
			if (_stakeData != value)
			{
				_stakeData = value;
				dispatchEventWith(Event.CHANGE);
			}
		}
		
		private var mPlayersCount:uint;
		private var _roundCardsCount:uint;
		private var mBingosLeft:uint;
		private var mIsRoundRunning:Boolean;
		private var mAcceptNewPlayers:Boolean;
		private var mRoundStartsIn:uint;
		private var mHasRoundStartsIn:Boolean;
		private var mRoomType:RoomType;
		private var mNumbers:Array;
		private var mLastUpdatedTimestamp:Number;
		
		public function Room(m:RoomMessage)
		{
			mNumbers = [];
			updateFromRoomMessage(m);
		}
		
		public function updateFromRoomMessage(m:RoomMessage, isRoundOverMessage:Boolean = false):void
		{
			if (!m)
				return;
			mIsRoundRunning = m.isRoundRunning;
			mPlayersCount = m.playersCount;
			_roundCardsCount = m.cardsCount;
			mBingosLeft = /*isRoundOverMessage ? 0 : */m.bingosLeft;
			mAcceptNewPlayers = m.acceptNewPlayers;
			mHasRoundStartsIn = m.hasRoundStartsIn;
			mRoundStartsIn = m.roundStartsIn;
			mLastUpdatedTimestamp = Game.connectionManager.currentServerTime;
			estimatedRoundEnd = m.hasRoundEndTime ? m.roundEndTime.toNumber() : 0;
			roundStartTime  = m.hasRoundStartTime ? m.roundStartTime.toNumber() : 0;
			//trace('Room.updateFromRoomMessage ROUND START TIME ', m.hasRoundStartTime, m.hasRoundStartTime ? m.roundStartTime.toNumber() : 0);
			if (m.hasRoundId)
			{
				roundID = m.roundId.toString();
			}
			
			//trace('round start timer:', int((roundStartTime - TimeService.serverTimeMs)/1000), mBingosLeft);
		}
		
		public function resetStake():void 
		{
			stakeData = gameManager.gameData.getDefaultStake();
		}
		
		public function initBallsTimerFromJoinOk(timeRoundStart:Number):void 
		{
			var gameData:GameData = gameManager.gameData;
			var maxCountingBallTime:int = gameData.firstBallInterval + gameData.ballThreshold * gameData.ballInterval;
			var roundElapseTime:Number = Math.round(Math.max(TimeService.serverTimeMs - timeRoundStart, 0));
			
			//trace('initBallsTimerFromJoinOk', TimeService.serverTimeMs - timeRoundStart, timeRoundStart, TimeService.serverTimeMs);
			//sosTrace('initBallsTimerFromJoinOk', TimeService.serverTimeMs - timeRoundStart, timeRoundStart, TimeService.serverTimeMs);
			
			if (timeRoundStart == 0 || (roundElapseTime > maxCountingBallTime))
				return;
				
			Starling.current.stage.addEventListener(Event.ENTER_FRAME, handler_enterFrame);
			currentRoundBallsCount = Math.floor((Math.max(0, roundElapseTime - gameData.firstBallInterval)) / gameData.ballInterval);
			
			var timeToNextBall:int = (currentRoundBallsCount + 1) * gameData.ballInterval - (roundElapseTime - gameData.firstBallInterval);
			
			nextBallAddTimestamp = TimeService.serverTimeMs + timeToNextBall;	
			
			//trace('START BALLS TIMER FROM JOIN OK', currentRoundBallsCount, roundElapseTime, timeToNextBall);
		}
		
		public function startBallsTimer():void 
		{
			Starling.current.stage.addEventListener(Event.ENTER_FRAME, handler_enterFrame);
			currentRoundBallsCount = 0;
			nextBallAddTimestamp = TimeService.serverTimeMs + gameManager.gameData.firstBallInterval;
			
			//trace('START BALLS TIMER');
			//sosTrace('startBallsTimer', TimeService.serverTimeMs);
		}
		
		public function getPointsBonusForCurrentCards():Number
		{
			return stakeData.getPointsBonusForCardNum(cardsPlayed);
		}
		
		private function handler_enterFrame(e:Event):void
		{
			if (TimeService.serverTimeMs >= nextBallAddTimestamp) 
			{
				currentRoundBallsCount++;
				
				if (currentRoundBallsCount >= gameManager.gameData.ballThreshold) 
				{
					Starling.current.stage.removeEventListener(Event.ENTER_FRAME, handler_enterFrame);
					nextBallAddTimestamp = 0;
					currentRoundBallsCount = -1;
				}
				else
				{
					nextBallAddTimestamp = TimeService.serverTimeMs + gameManager.gameData.ballInterval;
				}
				
				//trace('BALLS COUNTER ', currentRoundBallsCount);
				dispatchEventWith(EVENT_ROUND_STATE_UPDATE);
			}
		}	
		
		public function get isRoundRunning():Boolean
		{
			return mIsRoundRunning;
		}
		
		public function get playersCount():uint
		{
			return mPlayersCount;
		}
		
		public function get roundCardsCount():uint
		{
			return _roundCardsCount;
		}
		
		public function get bingosLeft():uint
		{
			return mBingosLeft;
		}
		
		public function get acceptNewPlayers():Boolean
		{
			return mAcceptNewPlayers;
		}
		
		public function get roundStartsIn():uint
		{
			return mRoundStartsIn;
		}
		
		public function get hasRoundStartsIn():Boolean
		{
			return mHasRoundStartsIn;
		}
		
		public function get lastUpdatedTimestamp():Number
		{
			return mLastUpdatedTimestamp;
		}
		
		public function get roomType():RoomType
		{
			return mRoomType;
		}
		
		public function set roomType(value:RoomType):void
		{
			mRoomType = value;
		}
		
		public function get numbers():Array
		{
			return mNumbers;
		}
		
		public function set numbers(value:Array):void
		{
			mNumbers = value;
		}
		
		private static var sCurrent:Room;
		
		public static function get current():Room
		{
			return sCurrent;
		}
		
		public static function set current(room:Room):void
		{
			sCurrent = room;
		}
		
		private var _daubStreak:int;
		
		public function get daubStreak():int 
		{
			return _daubStreak;
		}
		
		public function set daubStreak(value:int):void 
		{
			_daubStreak = value;
		}
		
		public var roundID:String = UNKNOWN_ROUND_ID;
		public var cellsDaubed:int;
		public var collectedPowerupsFromCards:int;
		public var cardsPlayed:uint;

		public function get daubStreakData():DaubStreakData
		{
			return gameManager.gameData.getDataByDaubStreak(daubStreak);
		}
	}
}