package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.GiftedPlayerMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class GiftMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const REQUEST_ID:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.GiftMessage.request_id", "requestId", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var requestId:String;

		/**
		 *  @private
		 */
		public static const GIFTED_PLAYERS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.GiftMessage.gifted_players", "giftedPlayers", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.GiftedPlayerMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.GiftedPlayerMessage")]
		public var giftedPlayers:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.requestId);
			for (var giftedPlayers$index:uint = 0; giftedPlayers$index < this.giftedPlayers.length; ++giftedPlayers$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.giftedPlayers[giftedPlayers$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var request_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (request_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: GiftMessage.requestId cannot be set twice.');
					}
					++request_id$count;
					this.requestId = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 2:
					this.giftedPlayers.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.GiftedPlayerMessage()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
