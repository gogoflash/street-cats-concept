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
	public dynamic final class BingoMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ROOM_ID:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.BingoMessage.room_id", "roomId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var roomId:uint;

		/**
		 *  @private
		 */
		public static const CARD_ID:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.BingoMessage.card_id", "cardId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var cardId:uint;

		/**
		 *  @private
		 */
		public static const DAUBED_NUMBERS:RepeatedFieldDescriptor$TYPE_UINT32 = new RepeatedFieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.BingoMessage.daubed_numbers", "daubedNumbers", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		[ArrayElementType("uint")]
		public var daubedNumbers:Array = [];

		/**
		 *  @private
		 */
		public static const MAGIC_DAUBS:RepeatedFieldDescriptor$TYPE_UINT32 = new RepeatedFieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.BingoMessage.magic_daubs", "magicDaubs", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		[ArrayElementType("uint")]
		public var magicDaubs:Array = [];

		/**
		 *  @private
		 */
		public static const INSTANT_BINGO_NUMBER:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.BingoMessage.instant_bingo_number", "instantBingoNumber", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var instant_bingo_number$field:uint;

		private var hasField$0:uint = 0;

		public function clearInstantBingoNumber():void {
			hasField$0 &= 0xfffffffe;
			instant_bingo_number$field = new uint();
		}

		public function get hasInstantBingoNumber():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set instantBingoNumber(value:uint):void {
			hasField$0 |= 0x1;
			instant_bingo_number$field = value;
		}

		public function get instantBingoNumber():uint {
			return instant_bingo_number$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.roomId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.cardId);
			for (var daubedNumbers$index:uint = 0; daubedNumbers$index < this.daubedNumbers.length; ++daubedNumbers$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.daubedNumbers[daubedNumbers$index]);
			}
			for (var magicDaubs$index:uint = 0; magicDaubs$index < this.magicDaubs.length; ++magicDaubs$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.magicDaubs[magicDaubs$index]);
			}
			if (hasInstantBingoNumber) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, instant_bingo_number$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var room_id$count:uint = 0;
			var card_id$count:uint = 0;
			var instant_bingo_number$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (room_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: BingoMessage.roomId cannot be set twice.');
					}
					++room_id$count;
					this.roomId = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (card_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: BingoMessage.cardId cannot be set twice.');
					}
					++card_id$count;
					this.cardId = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if ((tag & 7) == com.netease.protobuf.WireType.LENGTH_DELIMITED) {
						com.netease.protobuf.ReadUtils.readPackedRepeated(input, com.netease.protobuf.ReadUtils.read$TYPE_UINT32, this.daubedNumbers);
						break;
					}
					this.daubedNumbers.push(com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				case 4:
					if ((tag & 7) == com.netease.protobuf.WireType.LENGTH_DELIMITED) {
						com.netease.protobuf.ReadUtils.readPackedRepeated(input, com.netease.protobuf.ReadUtils.read$TYPE_UINT32, this.magicDaubs);
						break;
					}
					this.magicDaubs.push(com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				case 5:
					if (instant_bingo_number$count != 0) {
						throw new flash.errors.IOError('Bad data format: BingoMessage.instantBingoNumber cannot be set twice.');
					}
					++instant_bingo_number$count;
					this.instantBingoNumber = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
