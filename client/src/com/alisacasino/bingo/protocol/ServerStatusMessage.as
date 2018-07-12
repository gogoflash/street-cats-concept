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
	public dynamic final class ServerStatusMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ACTIVE:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.alisacasino.bingo.protocol.ServerStatusMessage.active", "active", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var active:Boolean;

		/**
		 *  @private
		 */
		public static const CURRENT_TIMESTAMP:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.ServerStatusMessage.current_timestamp", "currentTimestamp", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var currentTimestamp:uint;

		/**
		 *  @private
		 */
		public static const PLAYERS_ONLINE_COUNT:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.ServerStatusMessage.players_online_count", "playersOnlineCount", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var playersOnlineCount:uint;

		/**
		 *  @private
		 */
		public static const MESSAGE:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.ServerStatusMessage.message", "message", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

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
		public static const MESSAGE_TITLE:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.ServerStatusMessage.message_title", "messageTitle", (5 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var message_title$field:String;

		public function clearMessageTitle():void {
			message_title$field = null;
		}

		public function get hasMessageTitle():Boolean {
			return message_title$field != null;
		}

		public function set messageTitle(value:String):void {
			message_title$field = value;
		}

		public function get messageTitle():String {
			return message_title$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, this.active);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.currentTimestamp);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.playersOnlineCount);
			if (hasMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, message$field);
			}
			if (hasMessageTitle) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, message_title$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var active$count:uint = 0;
			var current_timestamp$count:uint = 0;
			var players_online_count$count:uint = 0;
			var message$count:uint = 0;
			var message_title$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (active$count != 0) {
						throw new flash.errors.IOError('Bad data format: ServerStatusMessage.active cannot be set twice.');
					}
					++active$count;
					this.active = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 2:
					if (current_timestamp$count != 0) {
						throw new flash.errors.IOError('Bad data format: ServerStatusMessage.currentTimestamp cannot be set twice.');
					}
					++current_timestamp$count;
					this.currentTimestamp = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (players_online_count$count != 0) {
						throw new flash.errors.IOError('Bad data format: ServerStatusMessage.playersOnlineCount cannot be set twice.');
					}
					++players_online_count$count;
					this.playersOnlineCount = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (message$count != 0) {
						throw new flash.errors.IOError('Bad data format: ServerStatusMessage.message cannot be set twice.');
					}
					++message$count;
					this.message = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 5:
					if (message_title$count != 0) {
						throw new flash.errors.IOError('Bad data format: ServerStatusMessage.messageTitle cannot be set twice.');
					}
					++message_title$count;
					this.messageTitle = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
