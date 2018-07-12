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
	public dynamic final class StakeDataMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const MULTIPLIER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.alisacasino.bingo.protocol.StakeDataMessage.multiplier", "multiplier", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var multiplier:int;

		/**
		 *  @private
		 */
		public static const LABEL:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.StakeDataMessage.label", "label", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var label:String;

		/**
		 *  @private
		 */
		public static const GRAPHICSPREFIX:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.StakeDataMessage.graphicsPrefix", "graphicsPrefix", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var graphicsPrefix:String;

		/**
		 *  @private
		 */
		public static const POINTSBONUS:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.StakeDataMessage.pointsBonus", "pointsBonus", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var pointsBonus:String;

		/**
		 *  @private
		 */
		public static const SCOREPOWERUPSDROPPED:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.alisacasino.bingo.protocol.StakeDataMessage.scorePowerupsDropped", "scorePowerupsDropped", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		public var scorePowerupsDropped:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.multiplier);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.label);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.graphicsPrefix);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.pointsBonus);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.scorePowerupsDropped);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var multiplier$count:uint = 0;
			var label$count:uint = 0;
			var graphicsPrefix$count:uint = 0;
			var pointsBonus$count:uint = 0;
			var scorePowerupsDropped$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (multiplier$count != 0) {
						throw new flash.errors.IOError('Bad data format: StakeDataMessage.multiplier cannot be set twice.');
					}
					++multiplier$count;
					this.multiplier = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (label$count != 0) {
						throw new flash.errors.IOError('Bad data format: StakeDataMessage.label cannot be set twice.');
					}
					++label$count;
					this.label = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (graphicsPrefix$count != 0) {
						throw new flash.errors.IOError('Bad data format: StakeDataMessage.graphicsPrefix cannot be set twice.');
					}
					++graphicsPrefix$count;
					this.graphicsPrefix = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (pointsBonus$count != 0) {
						throw new flash.errors.IOError('Bad data format: StakeDataMessage.pointsBonus cannot be set twice.');
					}
					++pointsBonus$count;
					this.pointsBonus = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 5:
					if (scorePowerupsDropped$count != 0) {
						throw new flash.errors.IOError('Bad data format: StakeDataMessage.scorePowerupsDropped cannot be set twice.');
					}
					++scorePowerupsDropped$count;
					this.scorePowerupsDropped = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
