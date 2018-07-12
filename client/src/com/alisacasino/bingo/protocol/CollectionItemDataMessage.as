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
	import com.alisacasino.bingo.protocol.CardType;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CollectionItemDataMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ITEM_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.alisacasino.bingo.protocol.CollectionItemDataMessage.item_id", "itemId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var itemId:int;

		/**
		 *  @private
		 */
		public static const NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.CollectionItemDataMessage.name", "name", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var name:String;

		/**
		 *  @private
		 */
		public static const IMAGE_PATH:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.CollectionItemDataMessage.image_path", "imagePath", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var imagePath:String;

		/**
		 *  @private
		 */
		public static const ITEM_IDX:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.alisacasino.bingo.protocol.CollectionItemDataMessage.item_idx", "itemIdx", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		public var itemIdx:int;

		/**
		 *  @private
		 */
		public static const WEIGHT:FieldDescriptor$TYPE_FLOAT = new FieldDescriptor$TYPE_FLOAT("com.alisacasino.bingo.protocol.CollectionItemDataMessage.weight", "weight", (5 << 3) | com.netease.protobuf.WireType.FIXED_32_BIT);

		public var weight:Number;

		/**
		 *  @private
		 */
		public static const RARITY:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.alisacasino.bingo.protocol.CollectionItemDataMessage.rarity", "rarity", (6 << 3) | com.netease.protobuf.WireType.VARINT, com.alisacasino.bingo.protocol.CardType);

		public var rarity:int;

		/**
		 *  @private
		 */
		public static const CONVERTION_CHEST_TYPE:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.alisacasino.bingo.protocol.CollectionItemDataMessage.convertion_chest_type", "convertionChestType", (7 << 3) | com.netease.protobuf.WireType.VARINT, com.alisacasino.bingo.protocol.ChestType);

		private var convertion_chest_type$field:int;

		private var hasField$0:uint = 0;

		public function clearConvertionChestType():void {
			hasField$0 &= 0xfffffffe;
			convertion_chest_type$field = new int();
		}

		public function get hasConvertionChestType():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set convertionChestType(value:int):void {
			hasField$0 |= 0x1;
			convertion_chest_type$field = value;
		}

		public function get convertionChestType():int {
			return convertion_chest_type$field;
		}

		/**
		 *  @private
		 */
		public static const NUMBER_TO_CONVERT:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.CollectionItemDataMessage.number_to_convert", "numberToConvert", (8 << 3) | com.netease.protobuf.WireType.VARINT);

		private var number_to_convert$field:uint;

		public function clearNumberToConvert():void {
			hasField$0 &= 0xfffffffd;
			number_to_convert$field = new uint();
		}

		public function get hasNumberToConvert():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set numberToConvert(value:uint):void {
			hasField$0 |= 0x2;
			number_to_convert$field = value;
		}

		public function get numberToConvert():uint {
			return number_to_convert$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.itemId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.name);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.imagePath);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.itemIdx);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_32_BIT, 5);
			com.netease.protobuf.WriteUtils.write$TYPE_FLOAT(output, this.weight);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.rarity);
			if (hasConvertionChestType) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, convertion_chest_type$field);
			}
			if (hasNumberToConvert) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, number_to_convert$field);
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
			var name$count:uint = 0;
			var image_path$count:uint = 0;
			var item_idx$count:uint = 0;
			var weight$count:uint = 0;
			var rarity$count:uint = 0;
			var convertion_chest_type$count:uint = 0;
			var number_to_convert$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 2:
					if (item_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CollectionItemDataMessage.itemId cannot be set twice.');
					}
					++item_id$count;
					this.itemId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 1:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: CollectionItemDataMessage.name cannot be set twice.');
					}
					++name$count;
					this.name = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (image_path$count != 0) {
						throw new flash.errors.IOError('Bad data format: CollectionItemDataMessage.imagePath cannot be set twice.');
					}
					++image_path$count;
					this.imagePath = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (item_idx$count != 0) {
						throw new flash.errors.IOError('Bad data format: CollectionItemDataMessage.itemIdx cannot be set twice.');
					}
					++item_idx$count;
					this.itemIdx = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (weight$count != 0) {
						throw new flash.errors.IOError('Bad data format: CollectionItemDataMessage.weight cannot be set twice.');
					}
					++weight$count;
					this.weight = com.netease.protobuf.ReadUtils.read$TYPE_FLOAT(input);
					break;
				case 6:
					if (rarity$count != 0) {
						throw new flash.errors.IOError('Bad data format: CollectionItemDataMessage.rarity cannot be set twice.');
					}
					++rarity$count;
					this.rarity = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 7:
					if (convertion_chest_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: CollectionItemDataMessage.convertionChestType cannot be set twice.');
					}
					++convertion_chest_type$count;
					this.convertionChestType = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 8:
					if (number_to_convert$count != 0) {
						throw new flash.errors.IOError('Bad data format: CollectionItemDataMessage.numberToConvert cannot be set twice.');
					}
					++number_to_convert$count;
					this.numberToConvert = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
