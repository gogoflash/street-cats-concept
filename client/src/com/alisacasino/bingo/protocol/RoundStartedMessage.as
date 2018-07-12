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
	public dynamic final class RoundStartedMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ROOM:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.RoundStartedMessage.room", "room", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.RoomMessage; });

		public var room:com.alisacasino.bingo.protocol.RoomMessage;

		/**
		 *  @private
		 */
		public static const ROUNDID:FieldDescriptor$TYPE_INT64 = new FieldDescriptor$TYPE_INT64("com.alisacasino.bingo.protocol.RoundStartedMessage.roundId", "roundId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var roundId$field:Int64;

		public function clearRoundId():void {
			roundId$field = null;
		}

		public function get hasRoundId():Boolean {
			return roundId$field != null;
		}

		public function set roundId(value:Int64):void {
			roundId$field = value;
		}

		public function get roundId():Int64 {
			return roundId$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.room);
			if (hasRoundId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT64(output, roundId$field);
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
			var roundId$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (room$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoundStartedMessage.room cannot be set twice.');
					}
					++room$count;
					this.room = new com.alisacasino.bingo.protocol.RoomMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.room);
					break;
				case 2:
					if (roundId$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoundStartedMessage.roundId cannot be set twice.');
					}
					++roundId$count;
					this.roundId = com.netease.protobuf.ReadUtils.read$TYPE_INT64(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
