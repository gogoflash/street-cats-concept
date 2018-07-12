package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.SignInMessage.Platform;
	import com.alisacasino.bingo.protocol.ShopPowerupDropMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class PlatformShopPowerupDropMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const PLATFORM:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.alisacasino.bingo.protocol.PlatformShopPowerupDropMessage.platform", "platform", (1 << 3) | com.netease.protobuf.WireType.VARINT, com.alisacasino.bingo.protocol.SignInMessage.Platform);

		public var platform:int;

		/**
		 *  @private
		 */
		public static const SHOP_POWERUP_DROPS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.PlatformShopPowerupDropMessage.shop_powerup_drops", "shopPowerupDrops", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.ShopPowerupDropMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.ShopPowerupDropMessage")]
		public var shopPowerupDrops:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.platform);
			for (var shopPowerupDrops$index:uint = 0; shopPowerupDrops$index < this.shopPowerupDrops.length; ++shopPowerupDrops$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.shopPowerupDrops[shopPowerupDrops$index]);
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
						throw new flash.errors.IOError('Bad data format: PlatformShopPowerupDropMessage.platform cannot be set twice.');
					}
					++platform$count;
					this.platform = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 2:
					this.shopPowerupDrops.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.ShopPowerupDropMessage()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
