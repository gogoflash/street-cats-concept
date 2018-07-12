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
	public dynamic final class LiveEventInfoOkMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const LIVE_EVENT_ID:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.LiveEventInfoOkMessage.live_event_id", "liveEventId", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		public var liveEventId:UInt64;

		/**
		 *  @private
		 */
		public static const LIVE_EVENT_NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.LiveEventInfoOkMessage.live_event_name", "liveEventName", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var liveEventName:String;

		/**
		 *  @private
		 */
		public static const LIVE_EVENT_TIER:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.LiveEventInfoOkMessage.live_event_tier", "liveEventTier", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		public var liveEventTier:uint;

		/**
		 *  @private
		 */
		public static const LIVE_EVENT_STARTS_AT:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.LiveEventInfoOkMessage.live_event_starts_at", "liveEventStartsAt", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		public var liveEventStartsAt:UInt64;

		/**
		 *  @private
		 */
		public static const LIVE_EVENT_ENDS_AT:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.LiveEventInfoOkMessage.live_event_ends_at", "liveEventEndsAt", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		public var liveEventEndsAt:UInt64;

		/**
		 *  @private
		 */
		public static const LIVE_EVENT_SCORE:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.LiveEventInfoOkMessage.live_event_score", "liveEventScore", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var live_event_score$field:UInt64;

		public function clearLiveEventScore():void {
			live_event_score$field = null;
		}

		public function get hasLiveEventScore():Boolean {
			return live_event_score$field != null;
		}

		public function set liveEventScore(value:UInt64):void {
			live_event_score$field = value;
		}

		public function get liveEventScore():UInt64 {
			return live_event_score$field;
		}

		/**
		 *  @private
		 */
		public static const LIVE_EVENT_RANK:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.LiveEventInfoOkMessage.live_event_rank", "liveEventRank", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var live_event_rank$field:uint;

		private var hasField$0:uint = 0;

		public function clearLiveEventRank():void {
			hasField$0 &= 0xfffffffe;
			live_event_rank$field = new uint();
		}

		public function get hasLiveEventRank():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set liveEventRank(value:uint):void {
			hasField$0 |= 0x1;
			live_event_rank$field = value;
		}

		public function get liveEventRank():uint {
			return live_event_rank$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, this.liveEventId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.liveEventName);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.liveEventTier);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, this.liveEventStartsAt);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, this.liveEventEndsAt);
			if (hasLiveEventScore) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, live_event_score$field);
			}
			if (hasLiveEventRank) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
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
			var live_event_id$count:uint = 0;
			var live_event_name$count:uint = 0;
			var live_event_tier$count:uint = 0;
			var live_event_starts_at$count:uint = 0;
			var live_event_ends_at$count:uint = 0;
			var live_event_score$count:uint = 0;
			var live_event_rank$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 7:
					if (live_event_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: LiveEventInfoOkMessage.liveEventId cannot be set twice.');
					}
					++live_event_id$count;
					this.liveEventId = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 1:
					if (live_event_name$count != 0) {
						throw new flash.errors.IOError('Bad data format: LiveEventInfoOkMessage.liveEventName cannot be set twice.');
					}
					++live_event_name$count;
					this.liveEventName = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 6:
					if (live_event_tier$count != 0) {
						throw new flash.errors.IOError('Bad data format: LiveEventInfoOkMessage.liveEventTier cannot be set twice.');
					}
					++live_event_tier$count;
					this.liveEventTier = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (live_event_starts_at$count != 0) {
						throw new flash.errors.IOError('Bad data format: LiveEventInfoOkMessage.liveEventStartsAt cannot be set twice.');
					}
					++live_event_starts_at$count;
					this.liveEventStartsAt = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 5:
					if (live_event_ends_at$count != 0) {
						throw new flash.errors.IOError('Bad data format: LiveEventInfoOkMessage.liveEventEndsAt cannot be set twice.');
					}
					++live_event_ends_at$count;
					this.liveEventEndsAt = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 2:
					if (live_event_score$count != 0) {
						throw new flash.errors.IOError('Bad data format: LiveEventInfoOkMessage.liveEventScore cannot be set twice.');
					}
					++live_event_score$count;
					this.liveEventScore = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 3:
					if (live_event_rank$count != 0) {
						throw new flash.errors.IOError('Bad data format: LiveEventInfoOkMessage.liveEventRank cannot be set twice.');
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
