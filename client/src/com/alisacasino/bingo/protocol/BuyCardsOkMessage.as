package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.CardMessage;
	import com.alisacasino.bingo.protocol.PlayerBingoedMessage;
	import com.alisacasino.bingo.protocol.PlayerMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class BuyCardsOkMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ROOM_ID:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.BuyCardsOkMessage.room_id", "roomId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var roomId:uint;

		/**
		 *  @private
		 */
		public static const PLAYER:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BuyCardsOkMessage.player", "player", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PlayerMessage; });

		public var player:com.alisacasino.bingo.protocol.PlayerMessage;

		/**
		 *  @private
		 */
		public static const IS_ACTIVE_PLAYER:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.alisacasino.bingo.protocol.BuyCardsOkMessage.is_active_player", "isActivePlayer", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var isActivePlayer:Boolean;

		/**
		 *  @private
		 */
		public static const CARDS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BuyCardsOkMessage.cards", "cards", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.CardMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.CardMessage")]
		public var cards:Array = [];

		/**
		 *  @private
		 */
		public static const NUMBERS:RepeatedFieldDescriptor$TYPE_UINT32 = new RepeatedFieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.BuyCardsOkMessage.numbers", "numbers", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		[ArrayElementType("uint")]
		public var numbers:Array = [];

		/**
		 *  @private
		 */
		public static const BINGOED_HISTORY:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BuyCardsOkMessage.bingoed_history", "bingoedHistory", (6 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PlayerBingoedMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.PlayerBingoedMessage")]
		public var bingoedHistory:Array = [];

		/**
		 *  @private
		 */
		public static const ROUNDID:FieldDescriptor$TYPE_INT64 = new FieldDescriptor$TYPE_INT64("com.alisacasino.bingo.protocol.BuyCardsOkMessage.roundId", "roundId", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		private var roundId$field:Int64;

		public function clearRoundId():void {
			roundId$field = null;
		}

		public function get hasRoundId():Boolean {
			return roundId$field != null;
		}

		public function set roundId(value:Int64):void {
			roundId$field = value;
		}

		public function get roundId():Int64 {
			return roundId$field;
		}

		/**
		 *  @private
		 */
		public static const STAKE:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.BuyCardsOkMessage.stake", "stake", (8 << 3) | com.netease.protobuf.WireType.VARINT);

		public var stake:uint;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.roomId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.player);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, this.isActivePlayer);
			for (var cards$index:uint = 0; cards$index < this.cards.length; ++cards$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.cards[cards$index]);
			}
			for (var numbers$index:uint = 0; numbers$index < this.numbers.length; ++numbers$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.numbers[numbers$index]);
			}
			for (var bingoedHistory$index:uint = 0; bingoedHistory$index < this.bingoedHistory.length; ++bingoedHistory$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.bingoedHistory[bingoedHistory$index]);
			}
			if (hasRoundId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_INT64(output, roundId$field);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 8);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.stake);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var room_id$count:uint = 0;
			var player$count:uint = 0;
			var is_active_player$count:uint = 0;
			var roundId$count:uint = 0;
			var stake$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (room_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: BuyCardsOkMessage.roomId cannot be set twice.');
					}
					++room_id$count;
					this.roomId = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (player$count != 0) {
						throw new flash.errors.IOError('Bad data format: BuyCardsOkMessage.player cannot be set twice.');
					}
					++player$count;
					this.player = new com.alisacasino.bingo.protocol.PlayerMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.player);
					break;
				case 3:
					if (is_active_player$count != 0) {
						throw new flash.errors.IOError('Bad data format: BuyCardsOkMessage.isActivePlayer cannot be set twice.');
					}
					++is_active_player$count;
					this.isActivePlayer = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 4:
					this.cards.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.CardMessage()));
					break;
				case 5:
					if ((tag & 7) == com.netease.protobuf.WireType.LENGTH_DELIMITED) {
						com.netease.protobuf.ReadUtils.readPackedRepeated(input, com.netease.protobuf.ReadUtils.read$TYPE_UINT32, this.numbers);
						break;
					}
					this.numbers.push(com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				case 6:
					this.bingoedHistory.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.PlayerBingoedMessage()));
					break;
				case 7:
					if (roundId$count != 0) {
						throw new flash.errors.IOError('Bad data format: BuyCardsOkMessage.roundId cannot be set twice.');
					}
					++roundId$count;
					this.roundId = com.netease.protobuf.ReadUtils.read$TYPE_INT64(input);
					break;
				case 8:
					if (stake$count != 0) {
						throw new flash.errors.IOError('Bad data format: BuyCardsOkMessage.stake cannot be set twice.');
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
