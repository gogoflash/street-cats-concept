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
	public dynamic final class DailyTournamentChestPrizeMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const WEIGHT:FieldDescriptor$TYPE_FLOAT = new FieldDescriptor$TYPE_FLOAT("com.alisacasino.bingo.protocol.DailyTournamentChestPrizeMessage.weight", "weight", (1 << 3) | com.netease.protobuf.WireType.FIXED_32_BIT);

		public var weight:Number;

		/**
		 *  @private
		 */
		public static const ITEMS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.DailyTournamentChestPrizeMessage.items", "items", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.CommodityItemMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.CommodityItemMessage")]
		public var items:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_32_BIT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_FLOAT(output, this.weight);
			for (var items$index:uint = 0; items$index < this.items.length; ++items$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.items[items$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var weight$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (weight$count != 0) {
						throw new flash.errors.IOError('Bad data format: DailyTournamentChestPrizeMessage.weight cannot be set twice.');
					}
					++weight$count;
					this.weight = com.netease.protobuf.ReadUtils.read$TYPE_FLOAT(input);
					break;
				case 2:
					this.items.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.CommodityItemMessage()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
