package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.TournamentResultMessage;
	import com.alisacasino.bingo.protocol.CollectionInfoOkMessage;
	import com.alisacasino.bingo.protocol.LiveEventInfoOkMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class TournamentEndMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const COLLECTION_INFO:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.TournamentEndMessage.collection_info", "collectionInfo", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.CollectionInfoOkMessage; });

		public var collectionInfo:com.alisacasino.bingo.protocol.CollectionInfoOkMessage;

		/**
		 *  @private
		 */
		public static const TOURNAMENT_INFO:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.TournamentEndMessage.tournament_info", "tournamentInfo", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.LiveEventInfoOkMessage; });

		public var tournamentInfo:com.alisacasino.bingo.protocol.LiveEventInfoOkMessage;

		/**
		 *  @private
		 */
		public static const TOURNAMENT_RESULT:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.TournamentEndMessage.tournament_result", "tournamentResult", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.TournamentResultMessage; });

		public var tournamentResult:com.alisacasino.bingo.protocol.TournamentResultMessage;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.collectionInfo);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.tournamentInfo);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.tournamentResult);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var collection_info$count:uint = 0;
			var tournament_info$count:uint = 0;
			var tournament_result$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (collection_info$count != 0) {
						throw new flash.errors.IOError('Bad data format: TournamentEndMessage.collectionInfo cannot be set twice.');
					}
					++collection_info$count;
					this.collectionInfo = new com.alisacasino.bingo.protocol.CollectionInfoOkMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.collectionInfo);
					break;
				case 2:
					if (tournament_info$count != 0) {
						throw new flash.errors.IOError('Bad data format: TournamentEndMessage.tournamentInfo cannot be set twice.');
					}
					++tournament_info$count;
					this.tournamentInfo = new com.alisacasino.bingo.protocol.LiveEventInfoOkMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.tournamentInfo);
					break;
				case 3:
					if (tournament_result$count != 0) {
						throw new flash.errors.IOError('Bad data format: TournamentEndMessage.tournamentResult cannot be set twice.');
					}
					++tournament_result$count;
					this.tournamentResult = new com.alisacasino.bingo.protocol.TournamentResultMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.tournamentResult);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
