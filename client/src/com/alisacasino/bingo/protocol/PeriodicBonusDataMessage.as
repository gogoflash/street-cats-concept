package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class PeriodicBonusDataMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ID:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.PeriodicBonusDataMessage.id", "id", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var id:uint;

		/**
		 *  @private
		 */
		public static const TYPE:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.PeriodicBonusDataMessage.type", "type", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var type:String;

		/**
		 *  @private
		 */
		public static const PERIOD_MS:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.PeriodicBonusDataMessage.period_ms", "periodMs", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var periodMs:UInt64;

		/**
		 *  @private
		 */
		public static const PRIZES:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.PeriodicBonusDataMessage.prizes", "prizes", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.CommodityItemMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.CommodityItemMessage")]
		public var prizes:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.id);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.type);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, this.periodMs);
			for (var prizes$index:uint = 0; prizes$index < this.prizes.length; ++prizes$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.prizes[prizes$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var id$count:uint = 0;
			var type$count:uint = 0;
			var period_ms$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: PeriodicBonusDataMessage.id cannot be set twice.');
					}
					++id$count;
					this.id = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (type$count != 0) {
						throw new flash.errors.IOError('Bad data format: PeriodicBonusDataMessage.type cannot be set twice.');
					}
					++type$count;
					this.type = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (period_ms$count != 0) {
						throw new flash.errors.IOError('Bad data format: PeriodicBonusDataMessage.periodMs cannot be set twice.');
					}
					++period_ms$count;
					this.periodMs = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 4:
					this.prizes.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.CommodityItemMessage()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
