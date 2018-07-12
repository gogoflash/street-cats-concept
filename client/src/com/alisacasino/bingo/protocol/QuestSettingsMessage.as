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
	public dynamic final class QuestSettingsMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const TYPE:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.QuestSettingsMessage.type", "type", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var type:String;

		/**
		 *  @private
		 */
		public static const SKIP_MIN_PRICE:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.QuestSettingsMessage.skip_min_price", "skipMinPrice", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var skip_min_price$field:uint;

		private var hasField$0:uint = 0;

		public function clearSkipMinPrice():void {
			hasField$0 &= 0xfffffffe;
			skip_min_price$field = new uint();
		}

		public function get hasSkipMinPrice():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set skipMinPrice(value:uint):void {
			hasField$0 |= 0x1;
			skip_min_price$field = value;
		}

		public function get skipMinPrice():uint {
			return skip_min_price$field;
		}

		/**
		 *  @private
		 */
		public static const SKIP_MAX_PRICE:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.QuestSettingsMessage.skip_max_price", "skipMaxPrice", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var skip_max_price$field:uint;

		public function clearSkipMaxPrice():void {
			hasField$0 &= 0xfffffffd;
			skip_max_price$field = new uint();
		}

		public function get hasSkipMaxPrice():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set skipMaxPrice(value:uint):void {
			hasField$0 |= 0x2;
			skip_max_price$field = value;
		}

		public function get skipMaxPrice():uint {
			return skip_max_price$field;
		}

		/**
		 *  @private
		 */
		public static const SKIP_PRICE_STEP:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.QuestSettingsMessage.skip_price_step", "skipPriceStep", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var skip_price_step$field:uint;

		public function clearSkipPriceStep():void {
			hasField$0 &= 0xfffffffb;
			skip_price_step$field = new uint();
		}

		public function get hasSkipPriceStep():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set skipPriceStep(value:uint):void {
			hasField$0 |= 0x4;
			skip_price_step$field = value;
		}

		public function get skipPriceStep():uint {
			return skip_price_step$field;
		}

		/**
		 *  @private
		 */
		public static const MAX_QUESTS_PER_PERIOD:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.QuestSettingsMessage.max_quests_per_period", "maxQuestsPerPeriod", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var max_quests_per_period$field:uint;

		public function clearMaxQuestsPerPeriod():void {
			hasField$0 &= 0xfffffff7;
			max_quests_per_period$field = new uint();
		}

		public function get hasMaxQuestsPerPeriod():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set maxQuestsPerPeriod(value:uint):void {
			hasField$0 |= 0x8;
			max_quests_per_period$field = value;
		}

		public function get maxQuestsPerPeriod():uint {
			return max_quests_per_period$field;
		}

		/**
		 *  @private
		 */
		public static const RANDOM_OBJECTIVE_SELECT:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.alisacasino.bingo.protocol.QuestSettingsMessage.random_objective_select", "randomObjectiveSelect", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		public var randomObjectiveSelect:Boolean;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.type);
			if (hasSkipMinPrice) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, skip_min_price$field);
			}
			if (hasSkipMaxPrice) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, skip_max_price$field);
			}
			if (hasSkipPriceStep) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, skip_price_step$field);
			}
			if (hasMaxQuestsPerPeriod) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, max_quests_per_period$field);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
			com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, this.randomObjectiveSelect);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var type$count:uint = 0;
			var skip_min_price$count:uint = 0;
			var skip_max_price$count:uint = 0;
			var skip_price_step$count:uint = 0;
			var max_quests_per_period$count:uint = 0;
			var random_objective_select$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (type$count != 0) {
						throw new flash.errors.IOError('Bad data format: QuestSettingsMessage.type cannot be set twice.');
					}
					++type$count;
					this.type = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 2:
					if (skip_min_price$count != 0) {
						throw new flash.errors.IOError('Bad data format: QuestSettingsMessage.skipMinPrice cannot be set twice.');
					}
					++skip_min_price$count;
					this.skipMinPrice = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (skip_max_price$count != 0) {
						throw new flash.errors.IOError('Bad data format: QuestSettingsMessage.skipMaxPrice cannot be set twice.');
					}
					++skip_max_price$count;
					this.skipMaxPrice = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (skip_price_step$count != 0) {
						throw new flash.errors.IOError('Bad data format: QuestSettingsMessage.skipPriceStep cannot be set twice.');
					}
					++skip_price_step$count;
					this.skipPriceStep = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (max_quests_per_period$count != 0) {
						throw new flash.errors.IOError('Bad data format: QuestSettingsMessage.maxQuestsPerPeriod cannot be set twice.');
					}
					++max_quests_per_period$count;
					this.maxQuestsPerPeriod = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (random_objective_select$count != 0) {
						throw new flash.errors.IOError('Bad data format: QuestSettingsMessage.randomObjectiveSelect cannot be set twice.');
					}
					++random_objective_select$count;
					this.randomObjectiveSelect = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
