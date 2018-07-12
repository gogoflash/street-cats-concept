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
	public dynamic final class InvitedPlayerMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const INVITE_TIMESTAMP:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.InvitedPlayerMessage.invite_timestamp", "inviteTimestamp", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var inviteTimestamp:UInt64;

		/**
		 *  @private
		 */
		public static const INVITED_FACEBOOK_ID_STRING:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.InvitedPlayerMessage.invited_facebook_id_string", "invitedFacebookIdString", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var invited_facebook_id_string$field:String;

		public function clearInvitedFacebookIdString():void {
			invited_facebook_id_string$field = null;
		}

		public function get hasInvitedFacebookIdString():Boolean {
			return invited_facebook_id_string$field != null;
		}

		public function set invitedFacebookIdString(value:String):void {
			invited_facebook_id_string$field = value;
		}

		public function get invitedFacebookIdString():String {
			return invited_facebook_id_string$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, this.inviteTimestamp);
			if (hasInvitedFacebookIdString) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, invited_facebook_id_string$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var invite_timestamp$count:uint = 0;
			var invited_facebook_id_string$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 2:
					if (invite_timestamp$count != 0) {
						throw new flash.errors.IOError('Bad data format: InvitedPlayerMessage.inviteTimestamp cannot be set twice.');
					}
					++invite_timestamp$count;
					this.inviteTimestamp = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 3:
					if (invited_facebook_id_string$count != 0) {
						throw new flash.errors.IOError('Bad data format: InvitedPlayerMessage.invitedFacebookIdString cannot be set twice.');
					}
					++invited_facebook_id_string$count;
					this.invitedFacebookIdString = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
