package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.PlayerMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class LiveEventLeaderboardPositionMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const PLAYER:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.LiveEventLeaderboardPositionMessage.player", "player", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PlayerMessage; });

		public var player:com.alisacasino.bingo.protocol.PlayerMessage;

		/**
		 *  @private
		 */
		public static const LIVE_EVENT_SCORE:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.LiveEventLeaderboardPositionMessage.live_event_score", "liveEventScore", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var liveEventScore:UInt64;

		/**
		 *  @private
		 */
		public static const LIVE_EVENT_RANK:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.LiveEventLeaderboardPositionMessage.live_event_rank", "liveEventRank", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var liveEventRank:uint;

		/**
		 *  @private
		 */
		public static const LIVE_EVENT_LEAGUE:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.LiveEventLeaderboardPositionMessage.live_event_league", "liveEventLeague", (6 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var live_event_league$field:String;

		public function clearLiveEventLeague():void {
			live_event_league$field = null;
		}

		public function get hasLiveEventLeague():Boolean {
			return live_event_league$field != null;
		}

		public function set liveEventLeague(value:String):void {
			live_event_league$field = value;
		}

		public function get liveEventLeague():String {
			return live_event_league$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.player);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, this.liveEventScore);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.liveEventRank);
			if (hasLiveEventLeague) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, live_event_league$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var player$count:uint = 0;
			var live_event_score$count:uint = 0;
			var live_event_rank$count:uint = 0;
			var live_event_league$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (player$count != 0) {
						throw new flash.errors.IOError('Bad data format: LiveEventLeaderboardPositionMessage.player cannot be set twice.');
					}
					++player$count;
					this.player = new com.alisacasino.bingo.protocol.PlayerMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.player);
					break;
				case 2:
					if (live_event_score$count != 0) {
						throw new flash.errors.IOError('Bad data format: LiveEventLeaderboardPositionMessage.liveEventScore cannot be set twice.');
					}
					++live_event_score$count;
					this.liveEventScore = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 3:
					if (live_event_rank$count != 0) {
						throw new flash.errors.IOError('Bad data format: LiveEventLeaderboardPositionMessage.liveEventRank cannot be set twice.');
					}
					++live_event_rank$count;
					this.liveEventRank = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (live_event_league$count != 0) {
						throw new flash.errors.IOError('Bad data format: LiveEventLeaderboardPositionMessage.liveEventLeague cannot be set twice.');
					}
					++live_event_league$count;
					this.liveEventLeague = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
