package com.alisacasino.bingo.protocol.RoomEventInfoMessage {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class RoomEventPlaceInfoMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const PLACE_FROM:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.RoomEventInfoMessage.RoomEventPlaceInfoMessage.place_from", "placeFrom", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var placeFrom:uint;

		/**
		 *  @private
		 */
		public static const PLACE_TO:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.RoomEventInfoMessage.RoomEventPlaceInfoMessage.place_to", "placeTo", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var place_to$field:uint;

		private var hasField$0:uint = 0;

		public function clearPlaceTo():void {
			hasField$0 &= 0xfffffffe;
			place_to$field = new uint();
		}

		public function get hasPlaceTo():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set placeTo(value:uint):void {
			hasField$0 |= 0x1;
			place_to$field = value;
		}

		public function get placeTo():uint {
			return place_to$field;
		}

		/**
		 *  @private
		 */
		public static const PRIZES:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.RoomEventInfoMessage.RoomEventPlaceInfoMessage.prizes", "prizes", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.CommodityItemMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.CommodityItemMessage")]
		public var prizes:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.placeFrom);
			if (hasPlaceTo) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, place_to$field);
			}
			for (var prizes$index:uint = 0; prizes$index < this.prizes.length; ++prizes$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
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
			var place_from$count:uint = 0;
			var place_to$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (place_from$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomEventPlaceInfoMessage.placeFrom cannot be set twice.');
					}
					++place_from$count;
					this.placeFrom = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (place_to$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomEventPlaceInfoMessage.placeTo cannot be set twice.');
					}
					++place_to$count;
					this.placeTo = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
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
