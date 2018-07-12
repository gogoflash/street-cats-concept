package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.ChestItemsDropMessage;
	import com.alisacasino.bingo.protocol.ChestCommonDropMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class ChestDropMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const CASH_DROP:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.ChestDropMessage.cash_drop", "cashDrop", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.ChestCommonDropMessage; });

		private var cash_drop$field:com.alisacasino.bingo.protocol.ChestCommonDropMessage;

		public function clearCashDrop():void {
			cash_drop$field = null;
		}

		public function get hasCashDrop():Boolean {
			return cash_drop$field != null;
		}

		public function set cashDrop(value:com.alisacasino.bingo.protocol.ChestCommonDropMessage):void {
			cash_drop$field = value;
		}

		public function get cashDrop():com.alisacasino.bingo.protocol.ChestCommonDropMessage {
			return cash_drop$field;
		}

		/**
		 *  @private
		 */
		public static const NORMAL_POWERUPS_DROP:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.ChestDropMessage.normal_powerups_drop", "normalPowerupsDrop", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.ChestCommonDropMessage; });

		private var normal_powerups_drop$field:com.alisacasino.bingo.protocol.ChestCommonDropMessage;

		public function clearNormalPowerupsDrop():void {
			normal_powerups_drop$field = null;
		}

		public function get hasNormalPowerupsDrop():Boolean {
			return normal_powerups_drop$field != null;
		}

		public function set normalPowerupsDrop(value:com.alisacasino.bingo.protocol.ChestCommonDropMessage):void {
			normal_powerups_drop$field = value;
		}

		public function get normalPowerupsDrop():com.alisacasino.bingo.protocol.ChestCommonDropMessage {
			return normal_powerups_drop$field;
		}

		/**
		 *  @private
		 */
		public static const MAGIC_POWERUPS_DROP:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.ChestDropMessage.magic_powerups_drop", "magicPowerupsDrop", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.ChestCommonDropMessage; });

		private var magic_powerups_drop$field:com.alisacasino.bingo.protocol.ChestCommonDropMessage;

		public function clearMagicPowerupsDrop():void {
			magic_powerups_drop$field = null;
		}

		public function get hasMagicPowerupsDrop():Boolean {
			return magic_powerups_drop$field != null;
		}

		public function set magicPowerupsDrop(value:com.alisacasino.bingo.protocol.ChestCommonDropMessage):void {
			magic_powerups_drop$field = value;
		}

		public function get magicPowerupsDrop():com.alisacasino.bingo.protocol.ChestCommonDropMessage {
			return magic_powerups_drop$field;
		}

		/**
		 *  @private
		 */
		public static const RARE_POWERUPS_DROP:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.ChestDropMessage.rare_powerups_drop", "rarePowerupsDrop", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.ChestCommonDropMessage; });

		private var rare_powerups_drop$field:com.alisacasino.bingo.protocol.ChestCommonDropMessage;

		public function clearRarePowerupsDrop():void {
			rare_powerups_drop$field = null;
		}

		public function get hasRarePowerupsDrop():Boolean {
			return rare_powerups_drop$field != null;
		}

		public function set rarePowerupsDrop(value:com.alisacasino.bingo.protocol.ChestCommonDropMessage):void {
			rare_powerups_drop$field = value;
		}

		public function get rarePowerupsDrop():com.alisacasino.bingo.protocol.ChestCommonDropMessage {
			return rare_powerups_drop$field;
		}

		/**
		 *  @private
		 */
		public static const ITEMS_DROP:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.ChestDropMessage.items_drop", "itemsDrop", (5 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.ChestItemsDropMessage; });

		private var items_drop$field:com.alisacasino.bingo.protocol.ChestItemsDropMessage;

		public function clearItemsDrop():void {
			items_drop$field = null;
		}

		public function get hasItemsDrop():Boolean {
			return items_drop$field != null;
		}

		public function set itemsDrop(value:com.alisacasino.bingo.protocol.ChestItemsDropMessage):void {
			items_drop$field = value;
		}

		public function get itemsDrop():com.alisacasino.bingo.protocol.ChestItemsDropMessage {
			return items_drop$field;
		}

		/**
		 *  @private
		 */
		public static const CHEST_CUSTOMIZER_DROP:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.ChestDropMessage.chest_customizer_drop", "chestCustomizerDrop", (6 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.ChestCommonDropMessage; });

		private var chest_customizer_drop$field:com.alisacasino.bingo.protocol.ChestCommonDropMessage;

		public function clearChestCustomizerDrop():void {
			chest_customizer_drop$field = null;
		}

		public function get hasChestCustomizerDrop():Boolean {
			return chest_customizer_drop$field != null;
		}

		public function set chestCustomizerDrop(value:com.alisacasino.bingo.protocol.ChestCommonDropMessage):void {
			chest_customizer_drop$field = value;
		}

		public function get chestCustomizerDrop():com.alisacasino.bingo.protocol.ChestCommonDropMessage {
			return chest_customizer_drop$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasCashDrop) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, cash_drop$field);
			}
			if (hasNormalPowerupsDrop) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, normal_powerups_drop$field);
			}
			if (hasMagicPowerupsDrop) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, magic_powerups_drop$field);
			}
			if (hasRarePowerupsDrop) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, rare_powerups_drop$field);
			}
			if (hasItemsDrop) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, items_drop$field);
			}
			if (hasChestCustomizerDrop) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, chest_customizer_drop$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var cash_drop$count:uint = 0;
			var normal_powerups_drop$count:uint = 0;
			var magic_powerups_drop$count:uint = 0;
			var rare_powerups_drop$count:uint = 0;
			var items_drop$count:uint = 0;
			var chest_customizer_drop$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (cash_drop$count != 0) {
						throw new flash.errors.IOError('Bad data format: ChestDropMessage.cashDrop cannot be set twice.');
					}
					++cash_drop$count;
					this.cashDrop = new com.alisacasino.bingo.protocol.ChestCommonDropMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.cashDrop);
					break;
				case 2:
					if (normal_powerups_drop$count != 0) {
						throw new flash.errors.IOError('Bad data format: ChestDropMessage.normalPowerupsDrop cannot be set twice.');
					}
					++normal_powerups_drop$count;
					this.normalPowerupsDrop = new com.alisacasino.bingo.protocol.ChestCommonDropMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.normalPowerupsDrop);
					break;
				case 3:
					if (magic_powerups_drop$count != 0) {
						throw new flash.errors.IOError('Bad data format: ChestDropMessage.magicPowerupsDrop cannot be set twice.');
					}
					++magic_powerups_drop$count;
					this.magicPowerupsDrop = new com.alisacasino.bingo.protocol.ChestCommonDropMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.magicPowerupsDrop);
					break;
				case 4:
					if (rare_powerups_drop$count != 0) {
						throw new flash.errors.IOError('Bad data format: ChestDropMessage.rarePowerupsDrop cannot be set twice.');
					}
					++rare_powerups_drop$count;
					this.rarePowerupsDrop = new com.alisacasino.bingo.protocol.ChestCommonDropMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.rarePowerupsDrop);
					break;
				case 5:
					if (items_drop$count != 0) {
						throw new flash.errors.IOError('Bad data format: ChestDropMessage.itemsDrop cannot be set twice.');
					}
					++items_drop$count;
					this.itemsDrop = new com.alisacasino.bingo.protocol.ChestItemsDropMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.itemsDrop);
					break;
				case 6:
					if (chest_customizer_drop$count != 0) {
						throw new flash.errors.IOError('Bad data format: ChestDropMessage.chestCustomizerDrop cannot be set twice.');
					}
					++chest_customizer_drop$count;
					this.chestCustomizerDrop = new com.alisacasino.bingo.protocol.ChestCommonDropMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.chestCustomizerDrop);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
