package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.RoomMessage;
	import com.alisacasino.bingo.protocol.PlayerMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class PlayerBingoedMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ROOM:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.PlayerBingoedMessage.room", "room", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.RoomMessage; });

		public var room:com.alisacasino.bingo.protocol.RoomMessage;

		/**
		 *  @private
		 */
		public static const PLAYER:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.PlayerBingoedMessage.player", "player", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PlayerMessage; });

		public var player:com.alisacasino.bingo.protocol.PlayerMessage;

		/**
		 *  @private
		 */
		public static const PLACE:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.PlayerBingoedMessage.place", "place", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var place:uint;

		/**
		 *  @private
		 */
		public static const PRIZES:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.PlayerBingoedMessage.prizes", "prizes", (8 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.CommodityItemMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.CommodityItemMessage")]
		public var prizes:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.room);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.player);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.place);
			for (var prizes$index:uint = 0; prizes$index < this.prizes.length; ++prizes$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.prizes[prizes$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var room$count:uint = 0;
			var player$count:uint = 0;
			var place$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (room$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerBingoedMessage.room cannot be set twice.');
					}
					++room$count;
					this.room = new com.alisacasino.bingo.protocol.RoomMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.room);
					break;
				case 2:
					if (player$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerBingoedMessage.player cannot be set twice.');
					}
					++player$count;
					this.player = new com.alisacasino.bingo.protocol.PlayerMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.player);
					break;
				case 3:
					if (place$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerBingoedMessage.place cannot be set twice.');
					}
					++place$count;
					this.place = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 8:
					this.prizes.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.CommodityItemMessage()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
