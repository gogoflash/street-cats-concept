package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.StaticDataMessage;
	import com.alisacasino.bingo.protocol.LiveEventInfoOkMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class HelloMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const STATIC_DATA:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.HelloMessage.static_data", "staticData", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.StaticDataMessage; });

		private var static_data$field:com.alisacasino.bingo.protocol.StaticDataMessage;

		public function clearStaticData():void {
			static_data$field = null;
		}

		public function get hasStaticData():Boolean {
			return static_data$field != null;
		}

		public function set staticData(value:com.alisacasino.bingo.protocol.StaticDataMessage):void {
			static_data$field = value;
		}

		public function get staticData():com.alisacasino.bingo.protocol.StaticDataMessage {
			return static_data$field;
		}

		/**
		 *  @private
		 */
		public static const TOURNAMENT_INFO:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.HelloMessage.tournament_info", "tournamentInfo", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.LiveEventInfoOkMessage; });

		private var tournament_info$field:com.alisacasino.bingo.protocol.LiveEventInfoOkMessage;

		public function clearTournamentInfo():void {
			tournament_info$field = null;
		}

		public function get hasTournamentInfo():Boolean {
			return tournament_info$field != null;
		}

		public function set tournamentInfo(value:com.alisacasino.bingo.protocol.LiveEventInfoOkMessage):void {
			tournament_info$field = value;
		}

		public function get tournamentInfo():com.alisacasino.bingo.protocol.LiveEventInfoOkMessage {
			return tournament_info$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasStaticData) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, static_data$field);
			}
			if (hasTournamentInfo) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, tournament_info$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var static_data$count:uint = 0;
			var tournament_info$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (static_data$count != 0) {
						throw new flash.errors.IOError('Bad data format: HelloMessage.staticData cannot be set twice.');
					}
					++static_data$count;
					this.staticData = new com.alisacasino.bingo.protocol.StaticDataMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.staticData);
					break;
				case 2:
					if (tournament_info$count != 0) {
						throw new flash.errors.IOError('Bad data format: HelloMessage.tournamentInfo cannot be set twice.');
					}
					++tournament_info$count;
					this.tournamentInfo = new com.alisacasino.bingo.protocol.LiveEventInfoOkMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.tournamentInfo);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
