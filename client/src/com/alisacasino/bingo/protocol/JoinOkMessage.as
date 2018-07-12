package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.RoomMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class JoinOkMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ROOM:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.JoinOkMessage.room", "room", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.RoomMessage; });

		public var room:com.alisacasino.bingo.protocol.RoomMessage;

		/**
		 *  @private
		 */
		public static const ROOM_TYPE_NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.JoinOkMessage.room_type_name", "roomTypeName", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var roomTypeName:String;

		/**
		 *  @private
		 */
		public static const LIVE_EVENT_NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.JoinOkMessage.live_event_name", "liveEventName", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var live_event_name$field:String;

		public function clearLiveEventName():void {
			live_event_name$field = null;
		}

		public function get hasLiveEventName():Boolean {
			return live_event_name$field != null;
		}

		public function set liveEventName(value:String):void {
			live_event_name$field = value;
		}

		public function get liveEventName():String {
			return live_event_name$field;
		}

		/**
		 *  @private
		 */
		public static const LIVE_EVENT_SCORE:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.JoinOkMessage.live_event_score", "liveEventScore", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var live_event_score$field:uint;

		private var hasField$0:uint = 0;

		public function clearLiveEventScore():void {
			hasField$0 &= 0xfffffffe;
			live_event_score$field = new uint();
		}

		public function get hasLiveEventScore():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set liveEventScore(value:uint):void {
			hasField$0 |= 0x1;
			live_event_score$field = value;
		}

		public function get liveEventScore():uint {
			return live_event_score$field;
		}

		/**
		 *  @private
		 */
		public static const LIVE_EVENT_RANK:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.JoinOkMessage.live_event_rank", "liveEventRank", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var live_event_rank$field:uint;

		public function clearLiveEventRank():void {
			hasField$0 &= 0xfffffffd;
			live_event_rank$field = new uint();
		}

		public function get hasLiveEventRank():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set liveEventRank(value:uint):void {
			hasField$0 |= 0x2;
			live_event_rank$field = value;
		}

		public function get liveEventRank():uint {
			return live_event_rank$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.room);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.roomTypeName);
			if (hasLiveEventName) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, live_event_name$field);
			}
			if (hasLiveEventScore) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, live_event_score$field);
			}
			if (hasLiveEventRank) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, live_event_rank$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var room$count:uint = 0;
			var room_type_name$count:uint = 0;
			var live_event_name$count:uint = 0;
			var live_event_score$count:uint = 0;
			var live_event_rank$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (room$count != 0) {
						throw new flash.errors.IOError('Bad data format: JoinOkMessage.room cannot be set twice.');
					}
					++room$count;
					this.room = new com.alisacasino.bingo.protocol.RoomMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.room);
					break;
				case 2:
					if (room_type_name$count != 0) {
						throw new flash.errors.IOError('Bad data format: JoinOkMessage.roomTypeName cannot be set twice.');
					}
					++room_type_name$count;
					this.roomTypeName = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (live_event_name$count != 0) {
						throw new flash.errors.IOError('Bad data format: JoinOkMessage.liveEventName cannot be set twice.');
					}
					++live_event_name$count;
					this.liveEventName = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (live_event_score$count != 0) {
						throw new flash.errors.IOError('Bad data format: JoinOkMessage.liveEventScore cannot be set twice.');
					}
					++live_event_score$count;
					this.liveEventScore = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (live_event_rank$count != 0) {
						throw new flash.errors.IOError('Bad data format: JoinOkMessage.liveEventRank cannot be set twice.');
					}
					++live_event_rank$count;
					this.liveEventRank = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
