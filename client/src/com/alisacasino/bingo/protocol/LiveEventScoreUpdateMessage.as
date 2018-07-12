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
	public dynamic final class LiveEventScoreUpdateMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const LIVE_EVENT_ADD_SCORE:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.LiveEventScoreUpdateMessage.live_event_add_score", "liveEventAddScore", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var liveEventAddScore:UInt64;

		/**
		 *  @private
		 */
		public static const LIVE_EVENT_ID:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.LiveEventScoreUpdateMessage.live_event_id", "liveEventId", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var liveEventId:UInt64;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, this.liveEventAddScore);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, this.liveEventId);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var live_event_add_score$count:uint = 0;
			var live_event_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 2:
					if (live_event_add_score$count != 0) {
						throw new flash.errors.IOError('Bad data format: LiveEventScoreUpdateMessage.liveEventAddScore cannot be set twice.');
					}
					++live_event_add_score$count;
					this.liveEventAddScore = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 3:
					if (live_event_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: LiveEventScoreUpdateMessage.liveEventId cannot be set twice.');
					}
					++live_event_id$count;
					this.liveEventId = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
