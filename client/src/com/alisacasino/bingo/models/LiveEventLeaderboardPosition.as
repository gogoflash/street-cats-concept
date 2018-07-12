package com.alisacasino.bingo.models
{
	import com.alisacasino.bingo.protocol.LiveEventLeaderboardPositionMessage;
	import com.alisacasino.bingo.screens.resultsUIClasses.LeaderboardItemRenderer;
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class LiveEventLeaderboardPosition extends EventDispatcher
	{
		public var forceShowArrow:Boolean;
		
		private var _hidden:Boolean;
		
		public function get hidden():Boolean 
		{
			return _hidden;
		}
		
		public function set hidden(value:Boolean):void 
		{
			if (_hidden != value)
			{
				_hidden = value;
				dispatchEventWith(Event.CHANGE);
			}
		}
		
		public var playerId:Number = 0;
		public var facebookId:String;
		public var firstName:String;
		public var lastName:String;
		public var xpLevel:int;
		public var avatarUrl:String;
		
		public var currentRenderer:LeaderboardItemRenderer;
		
		public function get fullUserName():String
		{
			if (lastName != null && lastName.length > 0)
				return (firstName || '') + " " + lastName;
			
			return firstName || '';
		}
		
		private var _score:Number = 0;
		
		public function get score():Number
		{
			return _score;
		}
		
		public function set score(value:Number):void 
		{
			_score = value;
		}
		
		private var _rank:int;
		
		public function get rank():int 
		{
			return _rank;
		}
		
		public function set rank(value:int):void 
		{
			_rank = value;
		}
		
		private var _dummyPosition:Boolean;
		public var league:String;
		
		public function get dummyPosition():Boolean 
		{
			return _dummyPosition;
		}
		
		public function get hasAvatarSources():Boolean 
		{
			return (facebookId != null && facebookId != '' && facebookId != '0') || (avatarUrl != null && avatarUrl != '');
		}
		
		public function get isBot():Boolean 
		{
			return (avatarUrl != null && avatarUrl != '') && (facebookId == '0' || facebookId == null || facebookId == '');
		}
		
		public function LiveEventLeaderboardPosition(m:LiveEventLeaderboardPositionMessage)
		{
			if (!m)
			{
				_dummyPosition = true;
				return;
			}
			
			//_player = new Player(m.player);
			_score = m.liveEventScore.toNumber();
			_rank = m.liveEventRank;
			league = m.liveEventLeague;
			
			if (m.player) {
				playerId = m.player.playerId.toNumber();
				facebookId = m.player.facebookIdString;
				firstName = m.player.firstName;
				lastName = m.player.lastName;
				xpLevel = m.player.xpLevel;
				avatarUrl = Player.getAlternativeAvatarURL(m.player);
			}
			else {
				playerId = 0;
			}
			
		}
		
		public function get ownPosition():Boolean
		{
			return playerId == Player.current.playerId;
		}
		
		public function toString():String
		{
			return "[LiveEventLeaderboardPosition player_id: "+ playerId.toString() + ", score: "+score+", rank: "+rank+"]";
		}
		
		public function copy():LiveEventLeaderboardPosition
		{
			var copy:LiveEventLeaderboardPosition = new LiveEventLeaderboardPosition(null);
			copy._dummyPosition = dummyPosition;
			//copy.player = player;
			
			copy.playerId = playerId;
			copy.facebookId = facebookId;
			copy.firstName = firstName;
			copy.lastName = lastName;
			
			copy.score = score;
			copy.rank = rank;
			copy.avatarUrl = avatarUrl;
			
			return copy;
		}
	}
}