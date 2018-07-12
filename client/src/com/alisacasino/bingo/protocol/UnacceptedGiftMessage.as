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
	public dynamic final class UnacceptedGiftMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const REQUEST_ID:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.UnacceptedGiftMessage.request_id", "requestId", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var requestId:String;

		/**
		 *  @private
		 */
		public static const SENDER_FACEBOOK_ID_STRING:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.UnacceptedGiftMessage.sender_facebook_id_string", "senderFacebookIdString", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var sender_facebook_id_string$field:String;

		public function clearSenderFacebookIdString():void {
			sender_facebook_id_string$field = null;
		}

		public function get hasSenderFacebookIdString():Boolean {
			return sender_facebook_id_string$field != null;
		}

		public function set senderFacebookIdString(value:String):void {
			sender_facebook_id_string$field = value;
		}

		public function get senderFacebookIdString():String {
			return sender_facebook_id_string$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.requestId);
			if (hasSenderFacebookIdString) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, sender_facebook_id_string$field);
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
			var sender_facebook_id_string$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (request_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: UnacceptedGiftMessage.requestId cannot be set twice.');
					}
					++request_id$count;
					this.requestId = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (sender_facebook_id_string$count != 0) {
						throw new flash.errors.IOError('Bad data format: UnacceptedGiftMessage.senderFacebookIdString cannot be set twice.');
					}
					++sender_facebook_id_string$count;
					this.senderFacebookIdString = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
