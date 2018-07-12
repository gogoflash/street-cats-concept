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
	public dynamic final class BallMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const NUMBER:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.BallMessage.number", "number", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var number:uint;

		/**
		 *  @private
		 */
		public static const ROUND_ID:FieldDescriptor$TYPE_INT64 = new FieldDescriptor$TYPE_INT64("com.alisacasino.bingo.protocol.BallMessage.round_id", "roundId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var round_id$field:Int64;

		public function clearRoundId():void {
			round_id$field = null;
		}

		public function get hasRoundId():Boolean {
			return round_id$field != null;
		}

		public function set roundId(value:Int64):void {
			round_id$field = value;
		}

		public function get roundId():Int64 {
			return round_id$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.number);
			if (hasRoundId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT64(output, round_id$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var number$count:uint = 0;
			var round_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (number$count != 0) {
						throw new flash.errors.IOError('Bad data format: BallMessage.number cannot be set twice.');
					}
					++number$count;
					this.number = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (round_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: BallMessage.roundId cannot be set twice.');
					}
					++round_id$count;
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
