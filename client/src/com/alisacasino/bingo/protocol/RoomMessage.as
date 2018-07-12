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
	public dynamic final class RoomMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ROOM_ID:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.RoomMessage.room_id", "roomId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var roomId:uint;

		/**
		 *  @private
		 */
		public static const IS_ROUND_RUNNING:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.alisacasino.bingo.protocol.RoomMessage.is_round_running", "isRoundRunning", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var isRoundRunning:Boolean;

		/**
		 *  @private
		 */
		public static const PLAYERS_COUNT:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.RoomMessage.players_count", "playersCount", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var playersCount:uint;

		/**
		 *  @private
		 */
		public static const CARDS_COUNT:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.RoomMessage.cards_count", "cardsCount", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		public var cardsCount:uint;

		/**
		 *  @private
		 */
		public static const BINGOS_LEFT:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.RoomMessage.bingos_left", "bingosLeft", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		public var bingosLeft:uint;

		/**
		 *  @private
		 */
		public static const ACCEPT_NEW_PLAYERS:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.alisacasino.bingo.protocol.RoomMessage.accept_new_players", "acceptNewPlayers", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		private var accept_new_players$field:Boolean;

		private var hasField$0:uint = 0;

		public function clearAcceptNewPlayers():void {
			hasField$0 &= 0xfffffffe;
			accept_new_players$field = new Boolean();
		}

		public function get hasAcceptNewPlayers():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set acceptNewPlayers(value:Boolean):void {
			hasField$0 |= 0x1;
			accept_new_players$field = value;
		}

		public function get acceptNewPlayers():Boolean {
			return accept_new_players$field;
		}

		/**
		 *  @private
		 */
		public static const ROUND_STARTS_IN:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.RoomMessage.round_starts_in", "roundStartsIn", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		private var round_starts_in$field:uint;

		public function clearRoundStartsIn():void {
			hasField$0 &= 0xfffffffd;
			round_starts_in$field = new uint();
		}

		public function get hasRoundStartsIn():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set roundStartsIn(value:uint):void {
			hasField$0 |= 0x2;
			round_starts_in$field = value;
		}

		public function get roundStartsIn():uint {
			return round_starts_in$field;
		}

		/**
		 *  @private
		 */
		public static const ROUND_START_TIME:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.RoomMessage.round_start_time", "roundStartTime", (8 << 3) | com.netease.protobuf.WireType.VARINT);

		private var round_start_time$field:UInt64;

		public function clearRoundStartTime():void {
			round_start_time$field = null;
		}

		public function get hasRoundStartTime():Boolean {
			return round_start_time$field != null;
		}

		public function set roundStartTime(value:UInt64):void {
			round_start_time$field = value;
		}

		public function get roundStartTime():UInt64 {
			return round_start_time$field;
		}

		/**
		 *  @private
		 */
		public static const ROUND_END_TIME:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.RoomMessage.round_end_time", "roundEndTime", (9 << 3) | com.netease.protobuf.WireType.VARINT);

		private var round_end_time$field:UInt64;

		public function clearRoundEndTime():void {
			round_end_time$field = null;
		}

		public function get hasRoundEndTime():Boolean {
			return round_end_time$field != null;
		}

		public function set roundEndTime(value:UInt64):void {
			round_end_time$field = value;
		}

		public function get roundEndTime():UInt64 {
			return round_end_time$field;
		}

		/**
		 *  @private
		 */
		public static const ROUND_ID:FieldDescriptor$TYPE_INT64 = new FieldDescriptor$TYPE_INT64("com.alisacasino.bingo.protocol.RoomMessage.round_id", "roundId", (10 << 3) | com.netease.protobuf.WireType.VARINT);

		private var round_id$field:Int64;

		public function clearRoundId():void {
			round_id$field = null;
		}

		public function get hasRoundId():Boolean {
			return round_id$field != null;
		}

		public function set roundId(value:Int64):void {
			round_id$field = value;
		}

		public function get roundId():Int64 {
			return round_id$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.roomId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, this.isRoundRunning);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.playersCount);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.cardsCount);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.bingosLeft);
			if (hasAcceptNewPlayers) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, accept_new_players$field);
			}
			if (hasRoundStartsIn) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, round_starts_in$field);
			}
			if (hasRoundStartTime) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, round_start_time$field);
			}
			if (hasRoundEndTime) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 9);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, round_end_time$field);
			}
			if (hasRoundId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 10);
				com.netease.protobuf.WriteUtils.write$TYPE_INT64(output, round_id$field);
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
			var is_round_running$count:uint = 0;
			var players_count$count:uint = 0;
			var cards_count$count:uint = 0;
			var bingos_left$count:uint = 0;
			var accept_new_players$count:uint = 0;
			var round_starts_in$count:uint = 0;
			var round_start_time$count:uint = 0;
			var round_end_time$count:uint = 0;
			var round_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (room_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomMessage.roomId cannot be set twice.');
					}
					++room_id$count;
					this.roomId = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (is_round_running$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomMessage.isRoundRunning cannot be set twice.');
					}
					++is_round_running$count;
					this.isRoundRunning = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 3:
					if (players_count$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomMessage.playersCount cannot be set twice.');
					}
					++players_count$count;
					this.playersCount = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (cards_count$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomMessage.cardsCount cannot be set twice.');
					}
					++cards_count$count;
					this.cardsCount = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (bingos_left$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomMessage.bingosLeft cannot be set twice.');
					}
					++bingos_left$count;
					this.bingosLeft = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (accept_new_players$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomMessage.acceptNewPlayers cannot be set twice.');
					}
					++accept_new_players$count;
					this.acceptNewPlayers = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 7:
					if (round_starts_in$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomMessage.roundStartsIn cannot be set twice.');
					}
					++round_starts_in$count;
					this.roundStartsIn = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 8:
					if (round_start_time$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomMessage.roundStartTime cannot be set twice.');
					}
					++round_start_time$count;
					this.roundStartTime = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 9:
					if (round_end_time$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomMessage.roundEndTime cannot be set twice.');
					}
					++round_end_time$count;
					this.roundEndTime = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 10:
					if (round_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomMessage.roundId cannot be set twice.');
					}
					++round_id$count;
					this.roundId = com.netease.protobuf.ReadUtils.read$TYPE_INT64(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
