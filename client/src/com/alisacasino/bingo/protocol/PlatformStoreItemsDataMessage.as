package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.StorePowerupDataMessage;
	import com.alisacasino.bingo.protocol.SignInMessage.Platform;
	import com.alisacasino.bingo.protocol.StoreItemDataMessage;
	import com.alisacasino.bingo.protocol.StoreComboDataMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class PlatformStoreItemsDataMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const PLATFORM:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.alisacasino.bingo.protocol.PlatformStoreItemsDataMessage.platform", "platform", (1 << 3) | com.netease.protobuf.WireType.VARINT, com.alisacasino.bingo.protocol.SignInMessage.Platform);

		public var platform:int;

		/**
		 *  @private
		 */
		public static const ITEMS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.PlatformStoreItemsDataMessage.items", "items", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.StoreItemDataMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.StoreItemDataMessage")]
		public var items:Array = [];

		/**
		 *  @private
		 */
		public static const POWERUPS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.PlatformStoreItemsDataMessage.powerups", "powerups", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.StorePowerupDataMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.StorePowerupDataMessage")]
		public var powerups:Array = [];

		/**
		 *  @private
		 */
		public static const COMBOS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.PlatformStoreItemsDataMessage.combos", "combos", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.StoreComboDataMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.StoreComboDataMessage")]
		public var combos:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.platform);
			for (var items$index:uint = 0; items$index < this.items.length; ++items$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.items[items$index]);
			}
			for (var powerups$index:uint = 0; powerups$index < this.powerups.length; ++powerups$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.powerups[powerups$index]);
			}
			for (var combos$index:uint = 0; combos$index < this.combos.length; ++combos$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.combos[combos$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var platform$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (platform$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlatformStoreItemsDataMessage.platform cannot be set twice.');
					}
					++platform$count;
					this.platform = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 2:
					this.items.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.StoreItemDataMessage()));
					break;
				case 3:
					this.powerups.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.StorePowerupDataMessage()));
					break;
				case 4:
					this.combos.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.StoreComboDataMessage()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
