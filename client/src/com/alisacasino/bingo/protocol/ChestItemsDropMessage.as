package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.ChestDropWeightMessage;
	import com.alisacasino.bingo.protocol.ChestItemsRarityWeightMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class ChestItemsDropMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const QUANTITY_FROM:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.ChestItemsDropMessage.quantity_from", "quantityFrom", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var quantity_from$field:uint;

		private var hasField$0:uint = 0;

		public function clearQuantityFrom():void {
			hasField$0 &= 0xfffffffe;
			quantity_from$field = new uint();
		}

		public function get hasQuantityFrom():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set quantityFrom(value:uint):void {
			hasField$0 |= 0x1;
			quantity_from$field = value;
		}

		public function get quantityFrom():uint {
			return quantity_from$field;
		}

		/**
		 *  @private
		 */
		public static const QUANTITY_TO:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.ChestItemsDropMessage.quantity_to", "quantityTo", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var quantity_to$field:uint;

		public function clearQuantityTo():void {
			hasField$0 &= 0xfffffffd;
			quantity_to$field = new uint();
		}

		public function get hasQuantityTo():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set quantityTo(value:uint):void {
			hasField$0 |= 0x2;
			quantity_to$field = value;
		}

		public function get quantityTo():uint {
			return quantity_to$field;
		}

		/**
		 *  @private
		 */
		public static const QUANTITY_WEIGHTS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.ChestItemsDropMessage.quantity_weights", "quantityWeights", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.ChestDropWeightMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.ChestDropWeightMessage")]
		public var quantityWeights:Array = [];

		/**
		 *  @private
		 */
		public static const RARITY_WEIGHTS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.ChestItemsDropMessage.rarity_weights", "rarityWeights", (5 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.ChestItemsRarityWeightMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.ChestItemsRarityWeightMessage")]
		public var rarityWeights:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasQuantityFrom) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, quantity_from$field);
			}
			if (hasQuantityTo) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, quantity_to$field);
			}
			for (var quantityWeights$index:uint = 0; quantityWeights$index < this.quantityWeights.length; ++quantityWeights$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.quantityWeights[quantityWeights$index]);
			}
			for (var rarityWeights$index:uint = 0; rarityWeights$index < this.rarityWeights.length; ++rarityWeights$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.rarityWeights[rarityWeights$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var quantity_from$count:uint = 0;
			var quantity_to$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 2:
					if (quantity_from$count != 0) {
						throw new flash.errors.IOError('Bad data format: ChestItemsDropMessage.quantityFrom cannot be set twice.');
					}
					++quantity_from$count;
					this.quantityFrom = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (quantity_to$count != 0) {
						throw new flash.errors.IOError('Bad data format: ChestItemsDropMessage.quantityTo cannot be set twice.');
					}
					++quantity_to$count;
					this.quantityTo = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					this.quantityWeights.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.ChestDropWeightMessage()));
					break;
				case 5:
					this.rarityWeights.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.ChestItemsRarityWeightMessage()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
