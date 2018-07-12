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
	public dynamic final class GiftedPlayerMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const GIFT_TIMESTAMP:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.GiftedPlayerMessage.gift_timestamp", "giftTimestamp", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var giftTimestamp:UInt64;

		/**
		 *  @private
		 */
		public static const GIFTS_COUNT:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.GiftedPlayerMessage.gifts_count", "giftsCount", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var gifts_count$field:uint;

		private var hasField$0:uint = 0;

		public function clearGiftsCount():void {
			hasField$0 &= 0xfffffffe;
			gifts_count$field = new uint();
		}

		public function get hasGiftsCount():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set giftsCount(value:uint):void {
			hasField$0 |= 0x1;
			gifts_count$field = value;
		}

		public function get giftsCount():uint {
			return gifts_count$field;
		}

		/**
		 *  @private
		 */
		public static const RECEIVER_FACEBOOK_ID_STRING:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.GiftedPlayerMessage.receiver_facebook_id_string", "receiverFacebookIdString", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var receiver_facebook_id_string$field:String;

		public function clearReceiverFacebookIdString():void {
			receiver_facebook_id_string$field = null;
		}

		public function get hasReceiverFacebookIdString():Boolean {
			return receiver_facebook_id_string$field != null;
		}

		public function set receiverFacebookIdString(value:String):void {
			receiver_facebook_id_string$field = value;
		}

		public function get receiverFacebookIdString():String {
			return receiver_facebook_id_string$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, this.giftTimestamp);
			if (hasGiftsCount) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, gifts_count$field);
			}
			if (hasReceiverFacebookIdString) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, receiver_facebook_id_string$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var gift_timestamp$count:uint = 0;
			var gifts_count$count:uint = 0;
			var receiver_facebook_id_string$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 2:
					if (gift_timestamp$count != 0) {
						throw new flash.errors.IOError('Bad data format: GiftedPlayerMessage.giftTimestamp cannot be set twice.');
					}
					++gift_timestamp$count;
					this.giftTimestamp = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 3:
					if (gifts_count$count != 0) {
						throw new flash.errors.IOError('Bad data format: GiftedPlayerMessage.giftsCount cannot be set twice.');
					}
					++gifts_count$count;
					this.giftsCount = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (receiver_facebook_id_string$count != 0) {
						throw new flash.errors.IOError('Bad data format: GiftedPlayerMessage.receiverFacebookIdString cannot be set twice.');
					}
					++receiver_facebook_id_string$count;
					this.receiverFacebookIdString = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
