package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.LiveEventLeaderboardPositionMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class LiveEventScoreUpdateOkMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const CURRENT_POSITION:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.LiveEventScoreUpdateOkMessage.current_position", "currentPosition", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.LiveEventLeaderboardPositionMessage; });

		public var currentPosition:com.alisacasino.bingo.protocol.LiveEventLeaderboardPositionMessage;

		/**
		 *  @private
		 */
		public static const OLD_POSITION:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.LiveEventScoreUpdateOkMessage.old_position", "oldPosition", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.LiveEventLeaderboardPositionMessage; });

		public var oldPosition:com.alisacasino.bingo.protocol.LiveEventLeaderboardPositionMessage;

		/**
		 *  @private
		 */
		public static const CURRENT_NEIGHBOURS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.LiveEventScoreUpdateOkMessage.current_neighbours", "currentNeighbours", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.LiveEventLeaderboardPositionMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.LiveEventLeaderboardPositionMessage")]
		public var currentNeighbours:Array = [];

		/**
		 *  @private
		 */
		public static const OLD_NEIGHBOURS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.LiveEventScoreUpdateOkMessage.old_neighbours", "oldNeighbours", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.LiveEventLeaderboardPositionMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.LiveEventLeaderboardPositionMessage")]
		public var oldNeighbours:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.currentPosition);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.oldPosition);
			for (var currentNeighbours$index:uint = 0; currentNeighbours$index < this.currentNeighbours.length; ++currentNeighbours$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.currentNeighbours[currentNeighbours$index]);
			}
			for (var oldNeighbours$index:uint = 0; oldNeighbours$index < this.oldNeighbours.length; ++oldNeighbours$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.oldNeighbours[oldNeighbours$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var current_position$count:uint = 0;
			var old_position$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (current_position$count != 0) {
						throw new flash.errors.IOError('Bad data format: LiveEventScoreUpdateOkMessage.currentPosition cannot be set twice.');
					}
					++current_position$count;
					this.currentPosition = new com.alisacasino.bingo.protocol.LiveEventLeaderboardPositionMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.currentPosition);
					break;
				case 2:
					if (old_position$count != 0) {
						throw new flash.errors.IOError('Bad data format: LiveEventScoreUpdateOkMessage.oldPosition cannot be set twice.');
					}
					++old_position$count;
					this.oldPosition = new com.alisacasino.bingo.protocol.LiveEventLeaderboardPositionMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.oldPosition);
					break;
				case 3:
					this.currentNeighbours.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.LiveEventLeaderboardPositionMessage()));
					break;
				case 4:
					this.oldNeighbours.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.LiveEventLeaderboardPositionMessage()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
