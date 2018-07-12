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
	public dynamic final class ScratchWeightMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const PRIZE_QUANTITY:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.ScratchWeightMessage.prize_quantity", "prizeQuantity", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var prizeQuantity:uint;

		/**
		 *  @private
		 */
		public static const MULTIPLIER:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.ScratchWeightMessage.multiplier", "multiplier", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var multiplier$field:uint;

		private var hasField$0:uint = 0;

		public function clearMultiplier():void {
			hasField$0 &= 0xfffffffe;
			multiplier$field = new uint();
		}

		public function get hasMultiplier():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set multiplier(value:uint):void {
			hasField$0 |= 0x1;
			multiplier$field = value;
		}

		public function get multiplier():uint {
			return multiplier$field;
		}

		/**
		 *  @private
		 */
		public static const WEIGHT:FieldDescriptor$TYPE_FLOAT = new FieldDescriptor$TYPE_FLOAT("com.alisacasino.bingo.protocol.ScratchWeightMessage.weight", "weight", (3 << 3) | com.netease.protobuf.WireType.FIXED_32_BIT);

		public var weight:Number;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.prizeQuantity);
			if (hasMultiplier) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, multiplier$field);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_32_BIT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_FLOAT(output, this.weight);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var prize_quantity$count:uint = 0;
			var multiplier$count:uint = 0;
			var weight$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (prize_quantity$count != 0) {
						throw new flash.errors.IOError('Bad data format: ScratchWeightMessage.prizeQuantity cannot be set twice.');
					}
					++prize_quantity$count;
					this.prizeQuantity = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (multiplier$count != 0) {
						throw new flash.errors.IOError('Bad data format: ScratchWeightMessage.multiplier cannot be set twice.');
					}
					++multiplier$count;
					this.multiplier = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (weight$count != 0) {
						throw new flash.errors.IOError('Bad data format: ScratchWeightMessage.weight cannot be set twice.');
					}
					++weight$count;
					this.weight = com.netease.protobuf.ReadUtils.read$TYPE_FLOAT(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
