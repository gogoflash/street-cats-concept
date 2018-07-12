package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.RoomPattern;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class RoomTypeMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ROOM_TYPE_NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.RoomTypeMessage.room_type_name", "roomTypeName", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var roomTypeName:String;

		/**
		 *  @private
		 */
		public static const ROOM_TIER:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.RoomTypeMessage.room_tier", "roomTier", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var roomTier:uint;

		/**
		 *  @private
		 */
		public static const REQUIRED_XP_LEVEL:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.RoomTypeMessage.required_xp_level", "requiredXpLevel", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var requiredXpLevel:uint;

		/**
		 *  @private
		 */
		public static const ROOMPATTERN:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.alisacasino.bingo.protocol.RoomTypeMessage.roomPattern", "roomPattern", (8 << 3) | com.netease.protobuf.WireType.VARINT, com.alisacasino.bingo.protocol.RoomPattern);

		private var roomPattern$field:int;

		private var hasField$0:uint = 0;

		public function clearRoomPattern():void {
			hasField$0 &= 0xfffffffe;
			roomPattern$field = new int();
		}

		public function get hasRoomPattern():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set roomPattern(value:int):void {
			hasField$0 |= 0x1;
			roomPattern$field = value;
		}

		public function get roomPattern():int {
			return roomPattern$field;
		}

		/**
		 *  @private
		 */
		public static const ROOM_START_TIME_MS:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.RoomTypeMessage.room_start_time_ms", "roomStartTimeMs", (10 << 3) | com.netease.protobuf.WireType.VARINT);

		private var room_start_time_ms$field:UInt64;

		public function clearRoomStartTimeMs():void {
			room_start_time_ms$field = null;
		}

		public function get hasRoomStartTimeMs():Boolean {
			return room_start_time_ms$field != null;
		}

		public function set roomStartTimeMs(value:UInt64):void {
			room_start_time_ms$field = value;
		}

		public function get roomStartTimeMs():UInt64 {
			return room_start_time_ms$field;
		}

		/**
		 *  @private
		 */
		public static const ROOM_REMOVE_TIME_MS:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.RoomTypeMessage.room_remove_time_ms", "roomRemoveTimeMs", (12 << 3) | com.netease.protobuf.WireType.VARINT);

		private var room_remove_time_ms$field:UInt64;

		public function clearRoomRemoveTimeMs():void {
			room_remove_time_ms$field = null;
		}

		public function get hasRoomRemoveTimeMs():Boolean {
			return room_remove_time_ms$field != null;
		}

		public function set roomRemoveTimeMs(value:UInt64):void {
			room_remove_time_ms$field = value;
		}

		public function get roomRemoveTimeMs():UInt64 {
			return room_remove_time_ms$field;
		}

		/**
		 *  @private
		 */
		public static const ORDER:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.RoomTypeMessage.order", "order", (14 << 3) | com.netease.protobuf.WireType.VARINT);

		private var order$field:uint;

		public function clearOrder():void {
			hasField$0 &= 0xfffffffd;
			order$field = new uint();
		}

		public function get hasOrder():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set order(value:uint):void {
			hasField$0 |= 0x2;
			order$field = value;
		}

		public function get order():uint {
			if(!hasOrder) {
				return 0;
			}
			return order$field;
		}

		/**
		 *  @private
		 */
		public static const ROUND_WAIT_INTERVAL:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.RoomTypeMessage.round_wait_interval", "roundWaitInterval", (21 << 3) | com.netease.protobuf.WireType.VARINT);

		private var round_wait_interval$field:uint;

		public function clearRoundWaitInterval():void {
			hasField$0 &= 0xfffffffb;
			round_wait_interval$field = new uint();
		}

		public function get hasRoundWaitInterval():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set roundWaitInterval(value:uint):void {
			hasField$0 |= 0x4;
			round_wait_interval$field = value;
		}

		public function get roundWaitInterval():uint {
			return round_wait_interval$field;
		}

		/**
		 *  @private
		 */
		public static const ROOM_ID:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.RoomTypeMessage.room_id", "roomId", (15 << 3) | com.netease.protobuf.WireType.VARINT);

		public var roomId:uint;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.roomTypeName);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.roomTier);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.requiredXpLevel);
			if (hasRoomPattern) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, roomPattern$field);
			}
			if (hasRoomStartTimeMs) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 10);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, room_start_time_ms$field);
			}
			if (hasRoomRemoveTimeMs) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 12);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, room_remove_time_ms$field);
			}
			if (hasOrder) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 14);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, order$field);
			}
			if (hasRoundWaitInterval) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 21);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, round_wait_interval$field);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 15);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.roomId);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var room_type_name$count:uint = 0;
			var room_tier$count:uint = 0;
			var required_xp_level$count:uint = 0;
			var roomPattern$count:uint = 0;
			var room_start_time_ms$count:uint = 0;
			var room_remove_time_ms$count:uint = 0;
			var order$count:uint = 0;
			var round_wait_interval$count:uint = 0;
			var room_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (room_type_name$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomTypeMessage.roomTypeName cannot be set twice.');
					}
					++room_type_name$count;
					this.roomTypeName = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 2:
					if (room_tier$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomTypeMessage.roomTier cannot be set twice.');
					}
					++room_tier$count;
					this.roomTier = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (required_xp_level$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomTypeMessage.requiredXpLevel cannot be set twice.');
					}
					++required_xp_level$count;
					this.requiredXpLevel = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 8:
					if (roomPattern$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomTypeMessage.roomPattern cannot be set twice.');
					}
					++roomPattern$count;
					this.roomPattern = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 10:
					if (room_start_time_ms$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomTypeMessage.roomStartTimeMs cannot be set twice.');
					}
					++room_start_time_ms$count;
					this.roomStartTimeMs = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 12:
					if (room_remove_time_ms$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomTypeMessage.roomRemoveTimeMs cannot be set twice.');
					}
					++room_remove_time_ms$count;
					this.roomRemoveTimeMs = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 14:
					if (order$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomTypeMessage.order cannot be set twice.');
					}
					++order$count;
					this.order = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 21:
					if (round_wait_interval$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomTypeMessage.roundWaitInterval cannot be set twice.');
					}
					++round_wait_interval$count;
					this.roundWaitInterval = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 15:
					if (room_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomTypeMessage.roomId cannot be set twice.');
					}
					++room_id$count;
					this.roomId = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
