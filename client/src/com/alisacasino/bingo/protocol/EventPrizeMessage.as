package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.PrizeItemMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class EventPrizeMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const PRIZE_PAYLOAD:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.EventPrizeMessage.prize_payload", "prizePayload", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PrizeItemMessage; });

		public var prizePayload:com.alisacasino.bingo.protocol.PrizeItemMessage;

		/**
		 *  @private
		 */
		public static const EVENT_ID:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.EventPrizeMessage.event_id", "eventId", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var eventId:uint;

		/**
		 *  @private
		 */
		public static const PLACE:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.EventPrizeMessage.place", "place", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		public var place:uint;

		/**
		 *  @private
		 */
		public static const SCORE:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.EventPrizeMessage.score", "score", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		public var score:uint;

		/**
		 *  @private
		 */
		public static const EVENT_EXISTS:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.alisacasino.bingo.protocol.EventPrizeMessage.event_exists", "eventExists", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		private var event_exists$field:Boolean;

		private var hasField$0:uint = 0;

		public function clearEventExists():void {
			hasField$0 &= 0xfffffffe;
			event_exists$field = new Boolean();
		}

		public function get hasEventExists():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set eventExists(value:Boolean):void {
			hasField$0 |= 0x1;
			event_exists$field = value;
		}

		public function get eventExists():Boolean {
			return event_exists$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.prizePayload);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.eventId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.place);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.score);
			if (hasEventExists) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, event_exists$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var prize_payload$count:uint = 0;
			var event_id$count:uint = 0;
			var place$count:uint = 0;
			var score$count:uint = 0;
			var event_exists$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 2:
					if (prize_payload$count != 0) {
						throw new flash.errors.IOError('Bad data format: EventPrizeMessage.prizePayload cannot be set twice.');
					}
					++prize_payload$count;
					this.prizePayload = new com.alisacasino.bingo.protocol.PrizeItemMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.prizePayload);
					break;
				case 3:
					if (event_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: EventPrizeMessage.eventId cannot be set twice.');
					}
					++event_id$count;
					this.eventId = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (place$count != 0) {
						throw new flash.errors.IOError('Bad data format: EventPrizeMessage.place cannot be set twice.');
					}
					++place$count;
					this.place = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (score$count != 0) {
						throw new flash.errors.IOError('Bad data format: EventPrizeMessage.score cannot be set twice.');
					}
					++score$count;
					this.score = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 7:
					if (event_exists$count != 0) {
						throw new flash.errors.IOError('Bad data format: EventPrizeMessage.eventExists cannot be set twice.');
					}
					++event_exists$count;
					this.eventExists = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
