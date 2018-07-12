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
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class StorePowerupDataMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ITEM_ID:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.StorePowerupDataMessage.item_id", "itemId", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var itemId:String;

		/**
		 *  @private
		 */
		public static const PRICE:FieldDescriptor$TYPE_FLOAT = new FieldDescriptor$TYPE_FLOAT("com.alisacasino.bingo.protocol.StorePowerupDataMessage.price", "price", (2 << 3) | com.netease.protobuf.WireType.FIXED_32_BIT);

		public var price:Number;

		/**
		 *  @private
		 */
		public static const PRICE_TYPE:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.alisacasino.bingo.protocol.StorePowerupDataMessage.price_type", "priceType", (6 << 3) | com.netease.protobuf.WireType.VARINT, com.alisacasino.bingo.protocol.Type);

		public var priceType:int;

		/**
		 *  @private
		 */
		public static const NORMAL_QUANTITY:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.StorePowerupDataMessage.normal_quantity", "normalQuantity", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var normal_quantity$field:uint;

		private var hasField$0:uint = 0;

		public function clearNormalQuantity():void {
			hasField$0 &= 0xfffffffe;
			normal_quantity$field = new uint();
		}

		public function get hasNormalQuantity():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set normalQuantity(value:uint):void {
			hasField$0 |= 0x1;
			normal_quantity$field = value;
		}

		public function get normalQuantity():uint {
			return normal_quantity$field;
		}

		/**
		 *  @private
		 */
		public static const MAGIC_QUANTITY:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.StorePowerupDataMessage.magic_quantity", "magicQuantity", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var magic_quantity$field:uint;

		public function clearMagicQuantity():void {
			hasField$0 &= 0xfffffffd;
			magic_quantity$field = new uint();
		}

		public function get hasMagicQuantity():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set magicQuantity(value:uint):void {
			hasField$0 |= 0x2;
			magic_quantity$field = value;
		}

		public function get magicQuantity():uint {
			return magic_quantity$field;
		}

		/**
		 *  @private
		 */
		public static const RARE_QUANTITY:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.StorePowerupDataMessage.rare_quantity", "rareQuantity", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var rare_quantity$field:uint;

		public function clearRareQuantity():void {
			hasField$0 &= 0xfffffffb;
			rare_quantity$field = new uint();
		}

		public function get hasRareQuantity():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set rareQuantity(value:uint):void {
			hasField$0 |= 0x4;
			rare_quantity$field = value;
		}

		public function get rareQuantity():uint {
			return rare_quantity$field;
		}

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
			if (hasNormalQuantity) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, normal_quantity$field);
			}
			if (hasMagicQuantity) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, magic_quantity$field);
			}
			if (hasRareQuantity) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, rare_quantity$field);
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
			var normal_quantity$count:uint = 0;
			var magic_quantity$count:uint = 0;
			var rare_quantity$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (item_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: StorePowerupDataMessage.itemId cannot be set twice.');
					}
					++item_id$count;
					this.itemId = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 2:
					if (price$count != 0) {
						throw new flash.errors.IOError('Bad data format: StorePowerupDataMessage.price cannot be set twice.');
					}
					++price$count;
					this.price = com.netease.protobuf.ReadUtils.read$TYPE_FLOAT(input);
					break;
				case 6:
					if (price_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: StorePowerupDataMessage.priceType cannot be set twice.');
					}
					++price_type$count;
					this.priceType = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 3:
					if (normal_quantity$count != 0) {
						throw new flash.errors.IOError('Bad data format: StorePowerupDataMessage.normalQuantity cannot be set twice.');
					}
					++normal_quantity$count;
					this.normalQuantity = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (magic_quantity$count != 0) {
						throw new flash.errors.IOError('Bad data format: StorePowerupDataMessage.magicQuantity cannot be set twice.');
					}
					++magic_quantity$count;
					this.magicQuantity = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (rare_quantity$count != 0) {
						throw new flash.errors.IOError('Bad data format: StorePowerupDataMessage.rareQuantity cannot be set twice.');
					}
					++rare_quantity$count;
					this.rareQuantity = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
