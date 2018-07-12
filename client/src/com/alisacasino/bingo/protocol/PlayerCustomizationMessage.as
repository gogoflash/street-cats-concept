package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.CustomizationType;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class PlayerCustomizationMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const CUSTOMIZATIONID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.alisacasino.bingo.protocol.PlayerCustomizationMessage.customizationId", "customizationId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var customizationId:int;

		/**
		 *  @private
		 */
		public static const TYPE:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.alisacasino.bingo.protocol.PlayerCustomizationMessage.type", "type", (3 << 3) | com.netease.protobuf.WireType.VARINT, com.alisacasino.bingo.protocol.CustomizationType);

		public var type:int;

		/**
		 *  @private
		 */
		public static const QUANTITY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.alisacasino.bingo.protocol.PlayerCustomizationMessage.quantity", "quantity", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var quantity$field:int;

		private var hasField$0:uint = 0;

		public function clearQuantity():void {
			hasField$0 &= 0xfffffffe;
			quantity$field = new int();
		}

		public function get hasQuantity():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set quantity(value:int):void {
			hasField$0 |= 0x1;
			quantity$field = value;
		}

		public function get quantity():int {
			return quantity$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.customizationId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.type);
			if (hasQuantity) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, quantity$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var customizationId$count:uint = 0;
			var type$count:uint = 0;
			var quantity$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 2:
					if (customizationId$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerCustomizationMessage.customizationId cannot be set twice.');
					}
					++customizationId$count;
					this.customizationId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (type$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerCustomizationMessage.type cannot be set twice.');
					}
					++type$count;
					this.type = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 4:
					if (quantity$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerCustomizationMessage.quantity cannot be set twice.');
					}
					++quantity$count;
					this.quantity = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
