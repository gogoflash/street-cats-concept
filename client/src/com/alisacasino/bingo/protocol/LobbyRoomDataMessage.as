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
	public dynamic final class LobbyRoomDataMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ROOM_ID:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.LobbyRoomDataMessage.room_id", "roomId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var roomId:uint;

		/**
		 *  @private
		 */
		public static const ORDER:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.LobbyRoomDataMessage.order", "order", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var order:uint;

		/**
		 *  @private
		 */
		public static const EVENT_ORDER:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.LobbyRoomDataMessage.event_order", "eventOrder", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var event_order$field:uint;

		private var hasField$0:uint = 0;

		public function clearEventOrder():void {
			hasField$0 &= 0xfffffffe;
			event_order$field = new uint();
		}

		public function get hasEventOrder():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set eventOrder(value:uint):void {
			hasField$0 |= 0x1;
			event_order$field = value;
		}

		public function get eventOrder():uint {
			return event_order$field;
		}

		/**
		 *  @private
		 */
		public static const COMMON_LOBBY_EVENT_ORDER:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.LobbyRoomDataMessage.common_lobby_event_order", "commonLobbyEventOrder", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var common_lobby_event_order$field:uint;

		public function clearCommonLobbyEventOrder():void {
			hasField$0 &= 0xfffffffd;
			common_lobby_event_order$field = new uint();
		}

		public function get hasCommonLobbyEventOrder():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set commonLobbyEventOrder(value:uint):void {
			hasField$0 |= 0x2;
			common_lobby_event_order$field = value;
		}

		public function get commonLobbyEventOrder():uint {
			return common_lobby_event_order$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.roomId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.order);
			if (hasEventOrder) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, event_order$field);
			}
			if (hasCommonLobbyEventOrder) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, common_lobby_event_order$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var room_id$count:uint = 0;
			var order$count:uint = 0;
			var event_order$count:uint = 0;
			var common_lobby_event_order$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (room_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: LobbyRoomDataMessage.roomId cannot be set twice.');
					}
					++room_id$count;
					this.roomId = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (order$count != 0) {
						throw new flash.errors.IOError('Bad data format: LobbyRoomDataMessage.order cannot be set twice.');
					}
					++order$count;
					this.order = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (event_order$count != 0) {
						throw new flash.errors.IOError('Bad data format: LobbyRoomDataMessage.eventOrder cannot be set twice.');
					}
					++event_order$count;
					this.eventOrder = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (common_lobby_event_order$count != 0) {
						throw new flash.errors.IOError('Bad data format: LobbyRoomDataMessage.commonLobbyEventOrder cannot be set twice.');
					}
					++common_lobby_event_order$count;
					this.commonLobbyEventOrder = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
