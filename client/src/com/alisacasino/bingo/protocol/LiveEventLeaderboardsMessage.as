package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class LiveEventLeaderboardsMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const FROM_POSITION_INDEX:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.LiveEventLeaderboardsMessage.from_position_index", "fromPositionIndex", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var from_position_index$field:uint;

		private var hasField$0:uint = 0;

		public function clearFromPositionIndex():void {
			hasField$0 &= 0xfffffffe;
			from_position_index$field = new uint();
		}

		public function get hasFromPositionIndex():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set fromPositionIndex(value:uint):void {
			hasField$0 |= 0x1;
			from_position_index$field = value;
		}

		public function get fromPositionIndex():uint {
			return from_position_index$field;
		}

		/**
		 *  @private
		 */
		public static const TO_POSITION_INDEX:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.LiveEventLeaderboardsMessage.to_position_index", "toPositionIndex", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var to_position_index$field:uint;

		public function clearToPositionIndex():void {
			hasField$0 &= 0xfffffffd;
			to_position_index$field = new uint();
		}

		public function get hasToPositionIndex():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set toPositionIndex(value:uint):void {
			hasField$0 |= 0x2;
			to_position_index$field = value;
		}

		public function get toPositionIndex():uint {
			return to_position_index$field;
		}

		/**
		 *  @private
		 */
		public static const CENTER:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.alisacasino.bingo.protocol.LiveEventLeaderboardsMessage.center", "center", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var center$field:Boolean;

		public function clearCenter():void {
			hasField$0 &= 0xfffffffb;
			center$field = new Boolean();
		}

		public function get hasCenter():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set center(value:Boolean):void {
			hasField$0 |= 0x4;
			center$field = value;
		}

		public function get center():Boolean {
			return center$field;
		}

		/**
		 *  @private
		 */
		public static const LIVE_EVENT_ID:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.LiveEventLeaderboardsMessage.live_event_id", "liveEventId", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var live_event_id$field:uint;

		public function clearLiveEventId():void {
			hasField$0 &= 0xfffffff7;
			live_event_id$field = new uint();
		}

		public function get hasLiveEventId():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set liveEventId(value:uint):void {
			hasField$0 |= 0x8;
			live_event_id$field = value;
		}

		public function get liveEventId():uint {
			return live_event_id$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasFromPositionIndex) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, from_position_index$field);
			}
			if (hasToPositionIndex) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, to_position_index$field);
			}
			if (hasCenter) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, center$field);
			}
			if (hasLiveEventId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, live_event_id$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var from_position_index$count:uint = 0;
			var to_position_index$count:uint = 0;
			var center$count:uint = 0;
			var live_event_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 2:
					if (from_position_index$count != 0) {
						throw new flash.errors.IOError('Bad data format: LiveEventLeaderboardsMessage.fromPositionIndex cannot be set twice.');
					}
					++from_position_index$count;
					this.fromPositionIndex = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (to_position_index$count != 0) {
						throw new flash.errors.IOError('Bad data format: LiveEventLeaderboardsMessage.toPositionIndex cannot be set twice.');
					}
					++to_position_index$count;
					this.toPositionIndex = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (center$count != 0) {
						throw new flash.errors.IOError('Bad data format: LiveEventLeaderboardsMessage.center cannot be set twice.');
					}
					++center$count;
					this.center = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 5:
					if (live_event_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: LiveEventLeaderboardsMessage.liveEventId cannot be set twice.');
					}
					++live_event_id$count;
					this.liveEventId = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
