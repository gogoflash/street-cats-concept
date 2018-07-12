package com.alisacasino.bingo.models.roomClasses
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.BackgroundAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.models.collections.Collection;
	import com.alisacasino.bingo.protocol.RoomCollectionInfoMessage;
	import com.alisacasino.bingo.protocol.RoomEventInfoMessage;
	import com.alisacasino.bingo.protocol.RoomItemMessage;
	import com.alisacasino.bingo.protocol.RoomResourceBundleMessage;
	import com.alisacasino.bingo.protocol.RoomTypeMessage;
	import com.alisacasino.bingo.protocol.RoomPattern;
	import com.alisacasino.bingo.protocol.VoiceType;
	import com.alisacasino.bingo.utils.TimeService;
	
	import org.as3commons.collections.Set;
	
	public class RoomType
	{
		private static var sAvailableRoomTypes:Array = [];
		
		public static function get availableRoomTypes():Array
		{
			return sAvailableRoomTypes;
		}
		
		
		public function get isBlackout():Boolean
		{
			return roomPattern == RoomPattern.Blackout;
		}
		
		private var _backgroundAsset:BackgroundAsset;
		
		public function get backgroundAsset():BackgroundAsset
		{
			if (_backgroundAsset)
			{
				return _backgroundAsset;
			}
			
			sosTrace("No background for " + roomTypeName, SOSLog.ERROR);
			return gameManager.tournamentData.getBackgroundAsset()
		}
		
		private var _soundtrack:SoundAsset;
		
		public function get soundtrack():SoundAsset
		{
			if (_soundtrack)
			{
				return _soundtrack;
			}
			
			sosTrace("No soundtrack for " + roomTypeName, SOSLog.ERROR);
			return null;
		}
		
		public function get activeEventName():String
		{
			if (hasActiveEvent)
			{
				return activeEvent.name;
			}
			sosTrace("Trying to get event name from room \"" + roomTypeName + "\" with no active event", SOSLog.ERROR);
			return "";
		}
		
		public function get activeEventID():int
		{
			if (hasActiveEvent)
			{
				return activeEvent.id;
			}
			sosTrace("Trying to get event id from room \"" + roomTypeName + "\" with no active event", SOSLog.ERROR);
			return -1;
		}
		
		public function get hasActiveEvent():Boolean
		{
			return activeEvent != null;
		}
		
		private var _cachedActiveEvent:EventInfo;
		
		
		public function get activeEvent():EventInfo
		{
			if (_cachedActiveEvent)
			{
				if (_cachedActiveEvent.removeTime == -1 || _cachedActiveEvent.removeTime > TimeService.serverTimeMs)
					return _cachedActiveEvent;
				else
					_cachedActiveEvent = null;
			}
			
			for each (var item:EventInfo in attachedEvents) 
			{
				if (item.createTime < TimeService.serverTimeMs)
				{
					if (item.removeTime == -1 || item.removeTime > TimeService.serverTimeMs)
					{
						_cachedActiveEvent = item;
						return _cachedActiveEvent;
					}
				}
			}
			return null;
		}
		
		public function getEventByName(eventName:String):EventInfo
		{
			for each (var item:EventInfo in attachedEvents) 
			{
				if (item.name == eventName)
				{
					return item;
				}
			}
			return null;
		}
		
		public var dudeTexture:String;
		public var liveEventIcon:String;
		public var roomStartTimestamp:Number = 0;
		public var roomRemoveTimestamp:Number = -1;
	
		public var roomTypeName:String;
		
		private var _roomTier:uint;
		
		public function get roomTier():uint 
		{
			if (activeEvent && activeEvent.roomTier != -1)
			{
				return activeEvent.roomTier;
			}
			
			return _roomTier;
		}
		
		public function set roomTier(value:uint):void 
		{
			_roomTier = value;
		}
		
		
		private var _roomPattern:int;
		
		public function get roomPattern():int 
		{
			if (activeEvent && activeEvent.roomPattern != -1)
			{
				return activeEvent.roomPattern;
			}
			return _roomPattern;
		}
		
		public function set roomPattern(value:int):void 
		{
			_roomPattern = value;
		}
		
		private var _requiredXpLevel:uint
		
		private var _roundWaitInterval:int;
		
		public function get roundWaitInterval():int 
		{
			if (activeEvent && activeEvent.roundWaitInterval >= 0)
			{
				return activeEvent.roundWaitInterval;
			}
			return _roundWaitInterval;
		}
		
		public function get requiredXpLevel():uint 
		{
			if (activeEvent && activeEvent.roomLevel != -1)
			{
				return activeEvent.roomLevel;
			}
			return _requiredXpLevel;
		}
		
		public function set requiredXpLevel(value:uint):void 
		{
			_requiredXpLevel = value;
		}
		
		public var voiceoverGender:String;
		public var collection:Collection
		public var attachedEvents:Vector.<EventInfo>;
		
		public function RoomType(name:String, voiceoverGender:String = "male", collection:Collection = null, backgroundAsset:BackgroundAsset = null, soundtrack:SoundAsset = null, dudeTexture:String = "", liveEventIcon:String = "")
		{
			this.liveEventIcon = liveEventIcon;
			this.dudeTexture = dudeTexture;
			this.roomTypeName = name;
			this.voiceoverGender = voiceoverGender;
			this.roomIconName = "room_icons/" + name;
			
			this.collection = collection;
			if (collection)
			{
				//collection.room = this;
			}
			
			
			attachedEvents = new Vector.<EventInfo>();
			
			_backgroundAsset = backgroundAsset;
			if (!_backgroundAsset)
			{
				sosTrace( "No background defined for : " + name, SOSLog.ERROR);
			}
			
			_soundtrack = soundtrack;
			if (!_soundtrack)
			{
				sosTrace( "No soundtrack defined for : " + name, SOSLog.ERROR);
			}
		}
		
		public function attachSoundtrack(trackName:String):void
		{
			if (_soundtrack)
			{
				_soundtrack.purge();
			}
			
			_soundtrack = new SoundAsset(trackName, SoundAsset.TYPE_SOUNDTRACK);
		}
		
		public function attachBackground(backgroundName:String):void
		{
			if (_backgroundAsset)
			{
				_backgroundAsset.purge();
			}
			
			_backgroundAsset = new BackgroundAsset(backgroundName);
		}
		
		
		static private function debugAddRoom(roomType:RoomType):void 
		{
			sAvailableRoomTypes.push(roomType);
			
			roomType.roomTier = 1;
			roomType.requiredXpLevel = 1;
			roomType.roomPattern = 0;
		}
		
		public function deserialize(item:RoomTypeMessage):RoomType 
		{
			deserializeResourceBundle(item.roomResourceBundle);
			
			if (item.roomCollectionInfo && item.roomItems.length > 0)
			{
				deserializeItems(item.roomCollectionInfo, item.roomItems);
			}
			
			roomPattern = item.roomPattern;
			
			roomTier = item.roomTier;
			requiredXpLevel = item.requiredXpLevel;
			
			_roundWaitInterval = item.roundWaitInterval * 1000;
			
			roomStartTimestamp = item.hasRoomStartTimeMs ? item.roomStartTimeMs.toNumber() : -1;
			roomRemoveTimestamp = item.hasRoomRemoveTimeMs ? item.roomRemoveTimeMs.toNumber() : -1;
			
			attachedEvents = new Vector.<EventInfo>();
			
			if (item.roomEventInfo && item.roomEventInfo.length)
			{
				for each (var eventInfoMessage:RoomEventInfoMessage in item.roomEventInfo) 
				{
					sosTrace( "eventInfoMessage : " + eventInfoMessage.toString(), SOSLog.INFO);
					if (eventInfoMessage.eventRemoveTimeMs.toNumber() < TimeService.serverTimeMs)
					{
						continue;
					}
					var eventInfo:EventInfo = new EventInfo();
					eventInfo.deserialize(eventInfoMessage);
					attachedEvents.push(eventInfo);
				}
			}
			
			if (sAvailableRoomTypes.indexOf(this) == -1)
			{
				sAvailableRoomTypes.push(this);
			}
			
			return this;
		}
		
		private function deserializeItems(roomCollectionInfo:RoomCollectionInfoMessage, roomItems:Array):void 
		{
			//TODO: Overwrite collection, remove old one from the manager.
			/*
			var needToAddCollection:Boolean = false;
			
			if (!collection)
			{
				collection = new Collection([], roomCollectionInfo.name, roomCollectionInfo.ticketPrize);
				collection.room = this;
				needToAddCollection = true;
			}
			
			for (var i:int = 0; i < roomItems.length; i++) 
			{
				var roomItemMessage:RoomItemMessage = roomItems[i];
				
				if(!collection.hasItem(roomItemMessage.id))
				{
					var item:Item = Item.fromRoomItemMessage(roomItemMessage);
					collection.addItem(item);
				}
			}
			
			if (needToAddCollection)
			{
				ItemsManager.instance.addCollection(collection);
			}
			*/
		}
		
		private function deserializeResourceBundle(roomResourceBundle:RoomResourceBundleMessage):void 
		{
			/*switch(roomResourceBundle.voice)
			{
				case VoiceType.MALE_1:
					voiceoverGender = "male";
					break;
				case VoiceType.FEMALE_1:
					voiceoverGender = "female";
					break;
			}
			
			roomIconName = "room_icons/" + roomResourceBundle.iconAsset;
			
			attachBackground(roomResourceBundle.backgroundAsset);
			attachSoundtrack(roomResourceBundle.soundtrackAsset);
			
			dudeTexture = roomResourceBundle.catAsset;
			liveEventIcon = roomResourceBundle.eventTitleAsset;*/
		}
		
		public function getRoomIconName():String
		{
			return roomIconName;
		}
		

		
		public static const sAllRoomTypes:Array = 
			[
			/*
			NutcrackerBlackoutRoomType,
			NycBlackoutRoomType,
			FashionBlackoutRoomType,
			IndependenceDayRoomType,
			WinterGamesRoomType,
			SantasWorkshopRoomType,
			ChristmasMarketRoomType,
			ChristmasRoomType,
			ThanksgivingRoomType,
			FarmRoomType,
			PyramidsRoomType,
			CasinoRoomType,
			ValentinesDayRoomType,
			FairytaleLandRoomType,
			DiscoBlackoutRoomType,
			RomeoRoomType,
			AztecRoomType,
			WinterRoomType,
			DesertRoomType,
			FantasyWorldRoomType,
			TropicalIslandRoomType,
			RainforestRoomType,
			CircusRoomType,
			CandylandRoomType,
			AliceRoomType,
			OzRoomType,
			BangkokRoomType,
			ParisRoomType,
			BrooklynRoomType,
			MonacoRoomType,
			NewYorkRoomType,
			SanFranciscoRoomType,
			SingaporeRoomType,
			TampaRoomType,
			TorontoRoomType,
			LasVegasRoomType,
			ViennaRoomType,
			JackRoomType,
			StPatricksDayRoomType,
			SnowWhiteBlackoutRoomType,
			EasterRoomType,
			RedHoodRoomType,
			PhantomBlackoutRoomType,
			RapunzelRoomType,
			MommyBlackoutRoomType,
			CatlandRoomType,
			MemorialDayRoomType,
			PetworldRoomType,
			WeddingRoomType,
			FathersDayRoomType,
			MexicoRoomType,
			CatdependenceDay,
			Milano,
			Hollywood,
			DragonWorld,
			Rio,
			DogIsland,
			Spa,
			BackToSchool,
			Nashville,
			Camp,
			FrankensteinRoomType,
			Gym,
			Transylvania,
			HalloweenRoomType,
			Election2016,
			Thanksgiving2016,
			Tokyo,
			Squanto,
			Area51
			*/
		];
		public var roomIconName:String;
		
		public function toString():String 
		{
			return "[RoomType  isBlackout=" + isBlackout + " activeEventName=" + activeEventName + 
						" roomStartTimestamp=" + roomStartTimestamp + " roomRemoveTimestamp=" + roomRemoveTimestamp + 
						" roomTypeName=" + roomTypeName + " roomTier=" + roomTier + 
						" roomPattern=" + roomPattern + " requiredXpLevel=" + requiredXpLevel + "]";
		}
		
		public function deserializeTypeData(roomTypeMessage:RoomTypeMessage):void 
		{
			
		}
		
	}
}
