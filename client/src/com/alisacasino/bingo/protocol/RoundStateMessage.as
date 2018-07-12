package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.RoundStateType;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class RoundStateMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ROUND_STATE_TYPE:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.alisacasino.bingo.protocol.RoundStateMessage.round_state_type", "roundStateType", (1 << 3) | com.netease.protobuf.WireType.VARINT, com.alisacasino.bingo.protocol.RoundStateType);

		public var roundStateType:int;

		/**
		 *  @private
		 */
		public static const ROUND_STARTS_AT:FieldDescriptor$TYPE_INT64 = new FieldDescriptor$TYPE_INT64("com.alisacasino.bingo.protocol.RoundStateMessage.round_starts_at", "roundStartsAt", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var round_starts_at$field:Int64;

		public function clearRoundStartsAt():void {
			round_starts_at$field = null;
		}

		public function get hasRoundStartsAt():Boolean {
			return round_starts_at$field != null;
		}

		public function set roundStartsAt(value:Int64):void {
			round_starts_at$field = value;
		}

		public function get roundStartsAt():Int64 {
			return round_starts_at$field;
		}

		/**
		 *  @private
		 */
		public static const ROUND_ID:FieldDescriptor$TYPE_INT64 = new FieldDescriptor$TYPE_INT64("com.alisacasino.bingo.protocol.RoundStateMessage.round_id", "roundId", (3 << 3) | com.netease.protobuf.WireType.VARINT);

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
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.roundStateType);
			if (hasRoundStartsAt) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT64(output, round_starts_at$field);
			}
			if (hasRoundId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
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
			var round_state_type$count:uint = 0;
			var round_starts_at$count:uint = 0;
			var round_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (round_state_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoundStateMessage.roundStateType cannot be set twice.');
					}
					++round_state_type$count;
					this.roundStateType = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 2:
					if (round_starts_at$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoundStateMessage.roundStartsAt cannot be set twice.');
					}
					++round_starts_at$count;
					this.roundStartsAt = com.netease.protobuf.ReadUtils.read$TYPE_INT64(input);
					break;
				case 3:
					if (round_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoundStateMessage.roundId cannot be set twice.');
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
