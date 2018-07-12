package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.PlaceRewardType;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class TournamentPlaceRewardDataMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ID:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.TournamentPlaceRewardDataMessage.id", "id", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var id:uint;

		/**
		 *  @private
		 */
		public static const TYPE:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.alisacasino.bingo.protocol.TournamentPlaceRewardDataMessage.type", "type", (2 << 3) | com.netease.protobuf.WireType.VARINT, com.alisacasino.bingo.protocol.PlaceRewardType);

		public var type:int;

		/**
		 *  @private
		 */
		public static const LEAGUE:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.TournamentPlaceRewardDataMessage.league", "league", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var league:String;

		/**
		 *  @private
		 */
		public static const FROM:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.TournamentPlaceRewardDataMessage.from", "from", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		public var from:uint;

		/**
		 *  @private
		 */
		public static const TO:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.TournamentPlaceRewardDataMessage.to", "__to", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		public var __to:uint;

		/**
		 *  @private
		 */
		public static const ORDER:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.TournamentPlaceRewardDataMessage.order", "order", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		public var order:uint;

		/**
		 *  @private
		 */
		public static const PRIZES:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.TournamentPlaceRewardDataMessage.prizes", "prizes", (7 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.CommodityItemMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.CommodityItemMessage")]
		public var prizes:Array = [];

		/**
		 *  @private
		 */
		public static const DESCRIPTION:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.TournamentPlaceRewardDataMessage.description", "description", (8 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var description:String;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.id);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.type);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.league);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.from);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.__to);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.order);
			for (var prizes$index:uint = 0; prizes$index < this.prizes.length; ++prizes$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.prizes[prizes$index]);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 8);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.description);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var id$count:uint = 0;
			var type$count:uint = 0;
			var league$count:uint = 0;
			var from$count:uint = 0;
			var to$count:uint = 0;
			var order$count:uint = 0;
			var description$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: TournamentPlaceRewardDataMessage.id cannot be set twice.');
					}
					++id$count;
					this.id = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (type$count != 0) {
						throw new flash.errors.IOError('Bad data format: TournamentPlaceRewardDataMessage.type cannot be set twice.');
					}
					++type$count;
					this.type = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 3:
					if (league$count != 0) {
						throw new flash.errors.IOError('Bad data format: TournamentPlaceRewardDataMessage.league cannot be set twice.');
					}
					++league$count;
					this.league = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (from$count != 0) {
						throw new flash.errors.IOError('Bad data format: TournamentPlaceRewardDataMessage.from cannot be set twice.');
					}
					++from$count;
					this.from = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (to$count != 0) {
						throw new flash.errors.IOError('Bad data format: TournamentPlaceRewardDataMessage.__to cannot be set twice.');
					}
					++to$count;
					this.__to = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (order$count != 0) {
						throw new flash.errors.IOError('Bad data format: TournamentPlaceRewardDataMessage.order cannot be set twice.');
					}
					++order$count;
					this.order = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 7:
					this.prizes.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.CommodityItemMessage()));
					break;
				case 8:
					if (description$count != 0) {
						throw new flash.errors.IOError('Bad data format: TournamentPlaceRewardDataMessage.description cannot be set twice.');
					}
					++description$count;
					this.description = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
