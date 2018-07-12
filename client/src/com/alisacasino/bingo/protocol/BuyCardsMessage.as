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
	public dynamic final class BuyCardsMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ROOM_ID:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.BuyCardsMessage.room_id", "roomId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var roomId:uint;

		/**
		 *  @private
		 */
		public static const CARDS_COUNT:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.BuyCardsMessage.cards_count", "cardsCount", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var cardsCount:uint;

		/**
		 *  @private
		 */
		public static const Y:RepeatedFieldDescriptor$TYPE_UINT32 = new RepeatedFieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.BuyCardsMessage.y", "y", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		[ArrayElementType("uint")]
		public var y:Array = [];

		/**
		 *  @private
		 */
		public static const STAKE:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.BuyCardsMessage.stake", "stake", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var stake$field:uint;

		private var hasField$0:uint = 0;

		public function clearStake():void {
			hasField$0 &= 0xfffffffe;
			stake$field = new uint();
		}

		public function get hasStake():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set stake(value:uint):void {
			hasField$0 |= 0x1;
			stake$field = value;
		}

		public function get stake():uint {
			return stake$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.roomId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.cardsCount);
			for (var y$index:uint = 0; y$index < this.y.length; ++y$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.y[y$index]);
			}
			if (hasStake) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, stake$field);
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
			var cards_count$count:uint = 0;
			var stake$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (room_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: BuyCardsMessage.roomId cannot be set twice.');
					}
					++room_id$count;
					this.roomId = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (cards_count$count != 0) {
						throw new flash.errors.IOError('Bad data format: BuyCardsMessage.cardsCount cannot be set twice.');
					}
					++cards_count$count;
					this.cardsCount = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if ((tag & 7) == com.netease.protobuf.WireType.LENGTH_DELIMITED) {
						com.netease.protobuf.ReadUtils.readPackedRepeated(input, com.netease.protobuf.ReadUtils.read$TYPE_UINT32, this.y);
						break;
					}
					this.y.push(com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				case 4:
					if (stake$count != 0) {
						throw new flash.errors.IOError('Bad data format: BuyCardsMessage.stake cannot be set twice.');
					}
					++stake$count;
					this.stake = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
