package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.PowerupWeightMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class PowerupDropDataMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const NORMAL_DROP_WEIGHTS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.PowerupDropDataMessage.normal_drop_weights", "normalDropWeights", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PowerupWeightMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.PowerupWeightMessage")]
		public var normalDropWeights:Array = [];

		/**
		 *  @private
		 */
		public static const MAGIC_DROP_WEIGHTS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.PowerupDropDataMessage.magic_drop_weights", "magicDropWeights", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PowerupWeightMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.PowerupWeightMessage")]
		public var magicDropWeights:Array = [];

		/**
		 *  @private
		 */
		public static const RARE_DROP_WEIGHTS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.PowerupDropDataMessage.rare_drop_weights", "rareDropWeights", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PowerupWeightMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.PowerupWeightMessage")]
		public var rareDropWeights:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			for (var normalDropWeights$index:uint = 0; normalDropWeights$index < this.normalDropWeights.length; ++normalDropWeights$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.normalDropWeights[normalDropWeights$index]);
			}
			for (var magicDropWeights$index:uint = 0; magicDropWeights$index < this.magicDropWeights.length; ++magicDropWeights$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.magicDropWeights[magicDropWeights$index]);
			}
			for (var rareDropWeights$index:uint = 0; rareDropWeights$index < this.rareDropWeights.length; ++rareDropWeights$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.rareDropWeights[rareDropWeights$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					this.normalDropWeights.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.PowerupWeightMessage()));
					break;
				case 2:
					this.magicDropWeights.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.PowerupWeightMessage()));
					break;
				case 3:
					this.rareDropWeights.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.PowerupWeightMessage()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
