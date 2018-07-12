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
	public dynamic final class ClientMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const PLAYER_ID:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.ClientMessage.player_id", "playerId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var player_id$field:UInt64;

		public function clearPlayerId():void {
			player_id$field = null;
		}

		public function get hasPlayerId():Boolean {
			return player_id$field != null;
		}

		public function set playerId(value:UInt64):void {
			player_id$field = value;
		}

		public function get playerId():UInt64 {
			return player_id$field;
		}

		/**
		 *  @private
		 */
		public static const MESSAGE:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.ClientMessage.message", "message", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var message$field:String;

		public function clearMessage():void {
			message$field = null;
		}

		public function get hasMessage():Boolean {
			return message$field != null;
		}

		public function set message(value:String):void {
			message$field = value;
		}

		public function get message():String {
			return message$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasPlayerId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, player_id$field);
			}
			if (hasMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, message$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var player_id$count:uint = 0;
			var message$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (player_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: ClientMessage.playerId cannot be set twice.');
					}
					++player_id$count;
					this.playerId = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 2:
					if (message$count != 0) {
						throw new flash.errors.IOError('Bad data format: ClientMessage.message cannot be set twice.');
					}
					++message$count;
					this.message = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
