package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.PlatformShopPowerupDropMessage;
	import com.alisacasino.bingo.protocol.PowerupDropDataMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class PowerupDropTableMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ROUND_POWERUP_DROP:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.PowerupDropTableMessage.round_powerup_drop", "roundPowerupDrop", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PowerupDropDataMessage; });

		public var roundPowerupDrop:com.alisacasino.bingo.protocol.PowerupDropDataMessage;

		/**
		 *  @private
		 */
		public static const TOURNAMENT_POWERUP_DROP:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.PowerupDropTableMessage.tournament_powerup_drop", "tournamentPowerupDrop", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PowerupDropDataMessage; });

		public var tournamentPowerupDrop:com.alisacasino.bingo.protocol.PowerupDropDataMessage;

		/**
		 *  @private
		 */
		public static const CHEST_POWERUP_DROP:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.PowerupDropTableMessage.chest_powerup_drop", "chestPowerupDrop", (5 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PowerupDropDataMessage; });

		public var chestPowerupDrop:com.alisacasino.bingo.protocol.PowerupDropDataMessage;

		/**
		 *  @private
		 */
		public static const COLLECTION_PAGE_POWERUP_DROP:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.PowerupDropTableMessage.collection_page_powerup_drop", "collectionPagePowerupDrop", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PowerupDropDataMessage; });

		private var collection_page_powerup_drop$field:com.alisacasino.bingo.protocol.PowerupDropDataMessage;

		public function clearCollectionPagePowerupDrop():void {
			collection_page_powerup_drop$field = null;
		}

		public function get hasCollectionPagePowerupDrop():Boolean {
			return collection_page_powerup_drop$field != null;
		}

		public function set collectionPagePowerupDrop(value:com.alisacasino.bingo.protocol.PowerupDropDataMessage):void {
			collection_page_powerup_drop$field = value;
		}

		public function get collectionPagePowerupDrop():com.alisacasino.bingo.protocol.PowerupDropDataMessage {
			return collection_page_powerup_drop$field;
		}

		/**
		 *  @private
		 */
		public static const SHOP_POWERUP_DROP:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.PowerupDropTableMessage.shop_powerup_drop", "shopPowerupDrop", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PlatformShopPowerupDropMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.PlatformShopPowerupDropMessage")]
		public var shopPowerupDrop:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.roundPowerupDrop);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.tournamentPowerupDrop);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 5);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.chestPowerupDrop);
			if (hasCollectionPagePowerupDrop) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, collection_page_powerup_drop$field);
			}
			for (var shopPowerupDrop$index:uint = 0; shopPowerupDrop$index < this.shopPowerupDrop.length; ++shopPowerupDrop$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.shopPowerupDrop[shopPowerupDrop$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var round_powerup_drop$count:uint = 0;
			var tournament_powerup_drop$count:uint = 0;
			var chest_powerup_drop$count:uint = 0;
			var collection_page_powerup_drop$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (round_powerup_drop$count != 0) {
						throw new flash.errors.IOError('Bad data format: PowerupDropTableMessage.roundPowerupDrop cannot be set twice.');
					}
					++round_powerup_drop$count;
					this.roundPowerupDrop = new com.alisacasino.bingo.protocol.PowerupDropDataMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.roundPowerupDrop);
					break;
				case 2:
					if (tournament_powerup_drop$count != 0) {
						throw new flash.errors.IOError('Bad data format: PowerupDropTableMessage.tournamentPowerupDrop cannot be set twice.');
					}
					++tournament_powerup_drop$count;
					this.tournamentPowerupDrop = new com.alisacasino.bingo.protocol.PowerupDropDataMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.tournamentPowerupDrop);
					break;
				case 5:
					if (chest_powerup_drop$count != 0) {
						throw new flash.errors.IOError('Bad data format: PowerupDropTableMessage.chestPowerupDrop cannot be set twice.');
					}
					++chest_powerup_drop$count;
					this.chestPowerupDrop = new com.alisacasino.bingo.protocol.PowerupDropDataMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.chestPowerupDrop);
					break;
				case 3:
					if (collection_page_powerup_drop$count != 0) {
						throw new flash.errors.IOError('Bad data format: PowerupDropTableMessage.collectionPagePowerupDrop cannot be set twice.');
					}
					++collection_page_powerup_drop$count;
					this.collectionPagePowerupDrop = new com.alisacasino.bingo.protocol.PowerupDropDataMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.collectionPagePowerupDrop);
					break;
				case 4:
					this.shopPowerupDrop.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.PlatformShopPowerupDropMessage()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
