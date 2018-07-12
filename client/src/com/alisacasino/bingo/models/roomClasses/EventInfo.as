package com.alisacasino.bingo.models.roomClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.protocol.RoomEventInfoMessage;
	import com.alisacasino.bingo.protocol.RoomEventInfoMessage.DailyEventBadge;
	import com.alisacasino.bingo.utils.TimeService;
	import flash.globalization.DateTimeFormatter;
	import flash.globalization.LocaleID;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class EventInfo 
	{
		static public const EVENT_STATE_SCHEDULED:String = "eventStateScheduled";
		static public const EVENT_STATE_PREVIEW:String = "eventStatePreview";
		static public const EVENT_STATE_ACTIVE:String = "eventStateActive";
		static public const EVENT_STATE_ENDED:String = "eventStateEnded";
		static public const EVENT_STATE_REMOVED:String = "eventStateRemoved";
		
		private var formatter:DateTimeFormatter;
		
		
		public var id:uint;
		public var badgeType:int;
		public var roomPattern:int = -1;
		public var roomTier:int = -1;
		public var createTime:Number = -1;
		public var startTime:Number = 0;
		public var endTime:Number = -1;
		public var removeTime:Number = -1;
		public var name:String;
		public var dailyEvent:Boolean = false;
		public var roomLevel:int = -1;
		public var powerupTableID:int = -1;
		public var eventChestTarget:int = -1;
		public var roundWaitInterval:int;
		
		public function get timeToEnd():Number
		{
			if (endTime == -1)
			{
				//TODO: think of ramifications
				return -1;
			}
			return endTime - TimeService.serverTimeMs;
		}
		
		public function get ended():Boolean
		{
			if (endTime == -1)
				return false
			
			return endTime < TimeService.serverTimeMs;
		}
		
		public function EventInfo() 
		{
			formatter = new DateTimeFormatter("en_US");
			formatter.setDateTimePattern("MMM dd");
		}
		
		public function deserialize(eventInfoMessage:RoomEventInfoMessage):void 
		{
			id = eventInfoMessage.id;
			
			startTime = eventInfoMessage.hasEventStartTimeMs ? eventInfoMessage.eventStartTimeMs.toNumber() : 0;
			
			createTime = eventInfoMessage.hasEventCreateTimeMs ? eventInfoMessage.eventCreateTimeMs.toNumber() : startTime;
			
			endTime = eventInfoMessage.hasEventEndTimeMs ? eventInfoMessage.eventEndTimeMs.toNumber() : -1;
			removeTime = eventInfoMessage.hasEventRemoveTimeMs ? eventInfoMessage.eventRemoveTimeMs.toNumber() : -1;
			name = eventInfoMessage.hasEventName ? eventInfoMessage.eventName : "";
			dailyEvent = eventInfoMessage.hasDailyTournament ? eventInfoMessage.dailyTournament : false;
			roomPattern = eventInfoMessage.hasRoomPattern ? eventInfoMessage.roomPattern : -1;
			roomTier = eventInfoMessage.hasTier ? eventInfoMessage.tier : -1;
			roomLevel = eventInfoMessage.hasLevel? eventInfoMessage.level : -1;
			badgeType = eventInfoMessage.hasDailyEventBadge ? eventInfoMessage.dailyEventBadge : -1;
			powerupTableID = eventInfoMessage.hasPowerupsInfo ? eventInfoMessage.powerupsInfo : -1;
			roundWaitInterval = eventInfoMessage.roundWaitInterval * 1000;
			
			eventChestTarget = eventInfoMessage.hasEventChestTarget ? eventInfoMessage.eventChestTarget : -1;
		}
		
		public function getEventEndDateString():String 
		{
			if (endTime == -1)
			{
				return "";
			}
			return "ends on " + formatTimeString(new Date(endTime));
		}
		
		private function formatTimeString(date:Date):String
		{
			return formatter.format(date);
		}
		
		public function get eventState():String
		{
			var currentTime:Number = TimeService.serverTimeMs;
			if (currentTime < createTime)
			{
				return EVENT_STATE_SCHEDULED;
			}
			if (currentTime < startTime)
			{
				return EVENT_STATE_PREVIEW;
			}
			if (currentTime < endTime)
			{
				return EVENT_STATE_ACTIVE;
			}
			if (currentTime < removeTime)
			{
				return EVENT_STATE_ENDED;
			}
			return EVENT_STATE_REMOVED;
		}
		
		public function get dailyEventBadgeTexture():Texture
		{
			if (badgeType == -1)
			{
				return null;
			}
			
			var eventBadgeName:String = "pink";
			switch(badgeType)
			{
				case DailyEventBadge.Blue:
					eventBadgeName = "blue";
					break;
				case DailyEventBadge.Green:
					eventBadgeName = "green";
					break;
				case DailyEventBadge.Pink:
					eventBadgeName = "pink";
					break;
				case DailyEventBadge.Purple:
					eventBadgeName = "purple";
					break;
				case DailyEventBadge.Red:
					eventBadgeName = "red";
					break;
			}
			
			
			return AtlasAsset.CommonAtlas.getTexture("daily_event_badges/" + eventBadgeName);
		}
		
		public function toString():String 
		{
			return "[EventInfo roomPattern=" + roomPattern + " roomTier=" + roomTier + " createTime=" + createTime + 
						" startTime=" + startTime + " endTime=" + endTime + " removeTime=" + removeTime + " name=" + name + 
						" dailyEvent=" + dailyEvent + " roomLevel=" + roomLevel + " ended=" + ended + "]";
		}
		
	}

}