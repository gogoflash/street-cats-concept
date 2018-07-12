package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class StoreComboDataMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ITEM_ID:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.StoreComboDataMessage.item_id", "itemId", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var itemId:String;

		/**
		 *  @private
		 */
		public static const PRICE:FieldDescriptor$TYPE_FLOAT = new FieldDescriptor$TYPE_FLOAT("com.alisacasino.bingo.protocol.StoreComboDataMessage.price", "price", (2 << 3) | com.netease.protobuf.WireType.FIXED_32_BIT);

		public var price:Number;

		/**
		 *  @private
		 */
		public static const PRICE_TYPE:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.alisacasino.bingo.protocol.StoreComboDataMessage.price_type", "priceType", (6 << 3) | com.netease.protobuf.WireType.VARINT, com.alisacasino.bingo.protocol.Type);

		public var priceType:int;

		/**
		 *  @private
		 */
		public static const GOODS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.StoreComboDataMessage.goods", "goods", (7 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.CommodityItemMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.CommodityItemMessage")]
		public var goods:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.itemId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_32_BIT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_FLOAT(output, this.price);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.priceType);
			for (var goods$index:uint = 0; goods$index < this.goods.length; ++goods$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.goods[goods$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var item_id$count:uint = 0;
			var price$count:uint = 0;
			var price_type$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (item_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: StoreComboDataMessage.itemId cannot be set twice.');
					}
					++item_id$count;
					this.itemId = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 2:
					if (price$count != 0) {
						throw new flash.errors.IOError('Bad data format: StoreComboDataMessage.price cannot be set twice.');
					}
					++price$count;
					this.price = com.netease.protobuf.ReadUtils.read$TYPE_FLOAT(input);
					break;
				case 6:
					if (price_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: StoreComboDataMessage.priceType cannot be set twice.');
					}
					++price_type$count;
					this.priceType = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 7:
					this.goods.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.CommodityItemMessage()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
