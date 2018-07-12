package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.protocol.ChestDropMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class ChestDropDataMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const TYPE:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.alisacasino.bingo.protocol.ChestDropDataMessage.type", "type", (1 << 3) | com.netease.protobuf.WireType.VARINT, com.alisacasino.bingo.protocol.ChestType);

		public var type:int;

		/**
		 *  @private
		 */
		public static const DROPS:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.ChestDropDataMessage.drops", "drops", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.ChestDropMessage; });

		public var drops:com.alisacasino.bingo.protocol.ChestDropMessage;

		/**
		 *  @private
		 */
		public static const MILLIS_TO_OPEN:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.ChestDropDataMessage.millis_to_open", "millisToOpen", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var millisToOpen:uint;

		/**
		 *  @private
		 */
		public static const OPEN_PRICE:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.ChestDropDataMessage.open_price", "openPrice", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		public var openPrice:uint;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.type);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.drops);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.millisToOpen);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.openPrice);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var type$count:uint = 0;
			var drops$count:uint = 0;
			var millis_to_open$count:uint = 0;
			var open_price$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (type$count != 0) {
						throw new flash.errors.IOError('Bad data format: ChestDropDataMessage.type cannot be set twice.');
					}
					++type$count;
					this.type = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 2:
					if (drops$count != 0) {
						throw new flash.errors.IOError('Bad data format: ChestDropDataMessage.drops cannot be set twice.');
					}
					++drops$count;
					this.drops = new com.alisacasino.bingo.protocol.ChestDropMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.drops);
					break;
				case 3:
					if (millis_to_open$count != 0) {
						throw new flash.errors.IOError('Bad data format: ChestDropDataMessage.millisToOpen cannot be set twice.');
					}
					++millis_to_open$count;
					this.millisToOpen = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (open_price$count != 0) {
						throw new flash.errors.IOError('Bad data format: ChestDropDataMessage.openPrice cannot be set twice.');
					}
					++open_price$count;
					this.openPrice = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
