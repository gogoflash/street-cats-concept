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
	import com.alisacasino.bingo.protocol.PowerupType;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CommodityItemMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const TYPE:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.alisacasino.bingo.protocol.CommodityItemMessage.type", "type", (1 << 3) | com.netease.protobuf.WireType.VARINT, com.alisacasino.bingo.protocol.Type);

		public var type:int;

		/**
		 *  @private
		 */
		public static const QUANTITY:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.CommodityItemMessage.quantity", "quantity", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var quantity:uint;

		/**
		 *  @private
		 */
		public static const POWERUP_TYPE:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.alisacasino.bingo.protocol.CommodityItemMessage.powerup_type", "powerupType", (3 << 3) | com.netease.protobuf.WireType.VARINT, com.alisacasino.bingo.protocol.PowerupType);

		private var powerup_type$field:int;

		private var hasField$0:uint = 0;

		public function clearPowerupType():void {
			hasField$0 &= 0xfffffffe;
			powerup_type$field = new int();
		}

		public function get hasPowerupType():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set powerupType(value:int):void {
			hasField$0 |= 0x1;
			powerup_type$field = value;
		}

		public function get powerupType():int {
			return powerup_type$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.type);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.quantity);
			if (hasPowerupType) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, powerup_type$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var type$count:uint = 0;
			var quantity$count:uint = 0;
			var powerup_type$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (type$count != 0) {
						throw new flash.errors.IOError('Bad data format: CommodityItemMessage.type cannot be set twice.');
					}
					++type$count;
					this.type = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 2:
					if (quantity$count != 0) {
						throw new flash.errors.IOError('Bad data format: CommodityItemMessage.quantity cannot be set twice.');
					}
					++quantity$count;
					this.quantity = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (powerup_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: CommodityItemMessage.powerupType cannot be set twice.');
					}
					++powerup_type$count;
					this.powerupType = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
