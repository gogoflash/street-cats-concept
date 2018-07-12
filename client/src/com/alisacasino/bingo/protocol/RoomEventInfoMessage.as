package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.RoomEventInfoMessage.DailyEventBadge;
	import com.alisacasino.bingo.protocol.RoomEventInfoMessage.RoomEventPlaceInfoMessage;
	import com.alisacasino.bingo.protocol.RoomPattern;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class RoomEventInfoMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ID:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.RoomEventInfoMessage.id", "id", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var id:uint;

		/**
		 *  @private
		 */
		public static const EVENT_START_TIME_MS:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.RoomEventInfoMessage.event_start_time_ms", "eventStartTimeMs", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var event_start_time_ms$field:UInt64;

		public function clearEventStartTimeMs():void {
			event_start_time_ms$field = null;
		}

		public function get hasEventStartTimeMs():Boolean {
			return event_start_time_ms$field != null;
		}

		public function set eventStartTimeMs(value:UInt64):void {
			event_start_time_ms$field = value;
		}

		public function get eventStartTimeMs():UInt64 {
			return event_start_time_ms$field;
		}

		/**
		 *  @private
		 */
		public static const EVENT_END_TIME_MS:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.RoomEventInfoMessage.event_end_time_ms", "eventEndTimeMs", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var event_end_time_ms$field:UInt64;

		public function clearEventEndTimeMs():void {
			event_end_time_ms$field = null;
		}

		public function get hasEventEndTimeMs():Boolean {
			return event_end_time_ms$field != null;
		}

		public function set eventEndTimeMs(value:UInt64):void {
			event_end_time_ms$field = value;
		}

		public function get eventEndTimeMs():UInt64 {
			return event_end_time_ms$field;
		}

		/**
		 *  @private
		 */
		public static const EVENT_REMOVE_TIME_MS:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.RoomEventInfoMessage.event_remove_time_ms", "eventRemoveTimeMs", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var event_remove_time_ms$field:UInt64;

		public function clearEventRemoveTimeMs():void {
			event_remove_time_ms$field = null;
		}

		public function get hasEventRemoveTimeMs():Boolean {
			return event_remove_time_ms$field != null;
		}

		public function set eventRemoveTimeMs(value:UInt64):void {
			event_remove_time_ms$field = value;
		}

		public function get eventRemoveTimeMs():UInt64 {
			return event_remove_time_ms$field;
		}

		/**
		 *  @private
		 */
		public static const EVENT_NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.RoomEventInfoMessage.event_name", "eventName", (6 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var event_name$field:String;

		public function clearEventName():void {
			event_name$field = null;
		}

		public function get hasEventName():Boolean {
			return event_name$field != null;
		}

		public function set eventName(value:String):void {
			event_name$field = value;
		}

		public function get eventName():String {
			return event_name$field;
		}

		/**
		 *  @private
		 */
		public static const EVENT_TITLE:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.RoomEventInfoMessage.event_title", "eventTitle", (7 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var event_title$field:String;

		public function clearEventTitle():void {
			event_title$field = null;
		}

		public function get hasEventTitle():Boolean {
			return event_title$field != null;
		}

		public function set eventTitle(value:String):void {
			event_title$field = value;
		}

		public function get eventTitle():String {
			return event_title$field;
		}

		/**
		 *  @private
		 */
		public static const EVENT_CREATE_TIME_MS:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.RoomEventInfoMessage.event_create_time_ms", "eventCreateTimeMs", (8 << 3) | com.netease.protobuf.WireType.VARINT);

		private var event_create_time_ms$field:UInt64;

		public function clearEventCreateTimeMs():void {
			event_create_time_ms$field = null;
		}

		public function get hasEventCreateTimeMs():Boolean {
			return event_create_time_ms$field != null;
		}

		public function set eventCreateTimeMs(value:UInt64):void {
			event_create_time_ms$field = value;
		}

		public function get eventCreateTimeMs():UInt64 {
			return event_create_time_ms$field;
		}

		/**
		 *  @private
		 */
		public static const TIER:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.RoomEventInfoMessage.tier", "tier", (9 << 3) | com.netease.protobuf.WireType.VARINT);

		private var tier$field:uint;

		private var hasField$0:uint = 0;

		public function clearTier():void {
			hasField$0 &= 0xfffffffe;
			tier$field = new uint();
		}

		public function get hasTier():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set tier(value:uint):void {
			hasField$0 |= 0x1;
			tier$field = value;
		}

		public function get tier():uint {
			return tier$field;
		}

		/**
		 *  @private
		 */
		public static const LEVEL:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.RoomEventInfoMessage.level", "level", (10 << 3) | com.netease.protobuf.WireType.VARINT);

		private var level$field:uint;

		public function clearLevel():void {
			hasField$0 &= 0xfffffffd;
			level$field = new uint();
		}

		public function get hasLevel():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set level(value:uint):void {
			hasField$0 |= 0x2;
			level$field = value;
		}

		public function get level():uint {
			return level$field;
		}

		/**
		 *  @private
		 */
		public static const ROOM_PATTERN:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.alisacasino.bingo.protocol.RoomEventInfoMessage.room_pattern", "roomPattern", (11 << 3) | com.netease.protobuf.WireType.VARINT, com.alisacasino.bingo.protocol.RoomPattern);

		private var room_pattern$field:int;

		public function clearRoomPattern():void {
			hasField$0 &= 0xfffffffb;
			room_pattern$field = new int();
		}

		public function get hasRoomPattern():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set roomPattern(value:int):void {
			hasField$0 |= 0x4;
			room_pattern$field = value;
		}

		public function get roomPattern():int {
			return room_pattern$field;
		}

		/**
		 *  @private
		 */
		public static const DAILY_TOURNAMENT:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.alisacasino.bingo.protocol.RoomEventInfoMessage.daily_tournament", "dailyTournament", (12 << 3) | com.netease.protobuf.WireType.VARINT);

		private var daily_tournament$field:Boolean;

		public function clearDailyTournament():void {
			hasField$0 &= 0xfffffff7;
			daily_tournament$field = new Boolean();
		}

		public function get hasDailyTournament():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set dailyTournament(value:Boolean):void {
			hasField$0 |= 0x8;
			daily_tournament$field = value;
		}

		public function get dailyTournament():Boolean {
			return daily_tournament$field;
		}

		/**
		 *  @private
		 */
		public static const DAILY_EVENT_BADGE:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.alisacasino.bingo.protocol.RoomEventInfoMessage.daily_event_badge", "dailyEventBadge", (13 << 3) | com.netease.protobuf.WireType.VARINT, com.alisacasino.bingo.protocol.RoomEventInfoMessage.DailyEventBadge);

		private var daily_event_badge$field:int;

		public function clearDailyEventBadge():void {
			hasField$0 &= 0xffffffef;
			daily_event_badge$field = new int();
		}

		public function get hasDailyEventBadge():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set dailyEventBadge(value:int):void {
			hasField$0 |= 0x10;
			daily_event_badge$field = value;
		}

		public function get dailyEventBadge():int {
			return daily_event_badge$field;
		}

		/**
		 *  @private
		 */
		public static const POWERUPS_INFO:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.RoomEventInfoMessage.powerups_info", "powerupsInfo", (14 << 3) | com.netease.protobuf.WireType.VARINT);

		private var powerups_info$field:uint;

		public function clearPowerupsInfo():void {
			hasField$0 &= 0xffffffdf;
			powerups_info$field = new uint();
		}

		public function get hasPowerupsInfo():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set powerupsInfo(value:uint):void {
			hasField$0 |= 0x20;
			powerups_info$field = value;
		}

		public function get powerupsInfo():uint {
			return powerups_info$field;
		}

		/**
		 *  @private
		 */
		public static const ROUND_WAIT_INTERVAL:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.RoomEventInfoMessage.round_wait_interval", "roundWaitInterval", (15 << 3) | com.netease.protobuf.WireType.VARINT);

		private var round_wait_interval$field:uint;

		public function clearRoundWaitInterval():void {
			hasField$0 &= 0xffffffbf;
			round_wait_interval$field = new uint();
		}

		public function get hasRoundWaitInterval():Boolean {
			return (hasField$0 & 0x40) != 0;
		}

		public function set roundWaitInterval(value:uint):void {
			hasField$0 |= 0x40;
			round_wait_interval$field = value;
		}

		public function get roundWaitInterval():uint {
			return round_wait_interval$field;
		}

		/**
		 *  @private
		 */
		public static const PLACESINFO:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.RoomEventInfoMessage.placesInfo", "placesInfo", (5 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.RoomEventInfoMessage.RoomEventPlaceInfoMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.RoomEventInfoMessage.RoomEventPlaceInfoMessage")]
		public var placesInfo:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.id);
			if (hasEventStartTimeMs) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, event_start_time_ms$field);
			}
			if (hasEventEndTimeMs) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, event_end_time_ms$field);
			}
			if (hasEventRemoveTimeMs) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, event_remove_time_ms$field);
			}
			if (hasEventName) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, event_name$field);
			}
			if (hasEventTitle) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, event_title$field);
			}
			if (hasEventCreateTimeMs) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, event_create_time_ms$field);
			}
			if (hasTier) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 9);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, tier$field);
			}
			if (hasLevel) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 10);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, level$field);
			}
			if (hasRoomPattern) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 11);
				com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, room_pattern$field);
			}
			if (hasDailyTournament) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 12);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, daily_tournament$field);
			}
			if (hasDailyEventBadge) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 13);
				com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, daily_event_badge$field);
			}
			if (hasPowerupsInfo) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 14);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, powerups_info$field);
			}
			if (hasRoundWaitInterval) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 15);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, round_wait_interval$field);
			}
			for (var placesInfo$index:uint = 0; placesInfo$index < this.placesInfo.length; ++placesInfo$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.placesInfo[placesInfo$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var id$count:uint = 0;
			var event_start_time_ms$count:uint = 0;
			var event_end_time_ms$count:uint = 0;
			var event_remove_time_ms$count:uint = 0;
			var event_name$count:uint = 0;
			var event_title$count:uint = 0;
			var event_create_time_ms$count:uint = 0;
			var tier$count:uint = 0;
			var level$count:uint = 0;
			var room_pattern$count:uint = 0;
			var daily_tournament$count:uint = 0;
			var daily_event_badge$count:uint = 0;
			var powerups_info$count:uint = 0;
			var round_wait_interval$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomEventInfoMessage.id cannot be set twice.');
					}
					++id$count;
					this.id = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (event_start_time_ms$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomEventInfoMessage.eventStartTimeMs cannot be set twice.');
					}
					++event_start_time_ms$count;
					this.eventStartTimeMs = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 3:
					if (event_end_time_ms$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomEventInfoMessage.eventEndTimeMs cannot be set twice.');
					}
					++event_end_time_ms$count;
					this.eventEndTimeMs = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 4:
					if (event_remove_time_ms$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomEventInfoMessage.eventRemoveTimeMs cannot be set twice.');
					}
					++event_remove_time_ms$count;
					this.eventRemoveTimeMs = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 6:
					if (event_name$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomEventInfoMessage.eventName cannot be set twice.');
					}
					++event_name$count;
					this.eventName = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 7:
					if (event_title$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomEventInfoMessage.eventTitle cannot be set twice.');
					}
					++event_title$count;
					this.eventTitle = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 8:
					if (event_create_time_ms$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomEventInfoMessage.eventCreateTimeMs cannot be set twice.');
					}
					++event_create_time_ms$count;
					this.eventCreateTimeMs = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 9:
					if (tier$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomEventInfoMessage.tier cannot be set twice.');
					}
					++tier$count;
					this.tier = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 10:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomEventInfoMessage.level cannot be set twice.');
					}
					++level$count;
					this.level = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 11:
					if (room_pattern$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomEventInfoMessage.roomPattern cannot be set twice.');
					}
					++room_pattern$count;
					this.roomPattern = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 12:
					if (daily_tournament$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomEventInfoMessage.dailyTournament cannot be set twice.');
					}
					++daily_tournament$count;
					this.dailyTournament = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 13:
					if (daily_event_badge$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomEventInfoMessage.dailyEventBadge cannot be set twice.');
					}
					++daily_event_badge$count;
					this.dailyEventBadge = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 14:
					if (powerups_info$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomEventInfoMessage.powerupsInfo cannot be set twice.');
					}
					++powerups_info$count;
					this.powerupsInfo = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 15:
					if (round_wait_interval$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomEventInfoMessage.roundWaitInterval cannot be set twice.');
					}
					++round_wait_interval$count;
					this.roundWaitInterval = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					this.placesInfo.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.RoomEventInfoMessage.RoomEventPlaceInfoMessage()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
