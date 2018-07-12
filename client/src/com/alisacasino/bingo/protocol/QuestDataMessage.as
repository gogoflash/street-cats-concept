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
	public dynamic final class QuestDataMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ID:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.QuestDataMessage.id", "id", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var id:uint;

		/**
		 *  @private
		 */
		public static const TYPE:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.QuestDataMessage.type", "type", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var type:String;

		/**
		 *  @private
		 */
		public static const OBJECTIVETYPE:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.QuestDataMessage.objectiveType", "objectiveType", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var objectiveType:String;

		/**
		 *  @private
		 */
		public static const TIER:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.QuestDataMessage.tier", "tier", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		public var tier:uint;

		/**
		 *  @private
		 */
		public static const DURATION:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.QuestDataMessage.duration", "duration", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var duration$field:uint;

		private var hasField$0:uint = 0;

		public function clearDuration():void {
			hasField$0 &= 0xfffffffe;
			duration$field = new uint();
		}

		public function get hasDuration():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set duration(value:uint):void {
			hasField$0 |= 0x1;
			duration$field = value;
		}

		public function get duration():uint {
			return duration$field;
		}

		/**
		 *  @private
		 */
		public static const GOAL:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.QuestDataMessage.goal", "goal", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		public var goal:uint;

		/**
		 *  @private
		 */
		public static const REWARDTYPE:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.QuestDataMessage.rewardType", "rewardType", (7 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var rewardType:String;

		/**
		 *  @private
		 */
		public static const REWARDSUBTYPE:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.QuestDataMessage.rewardSubtype", "rewardSubtype", (8 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var rewardSubtype:String;

		/**
		 *  @private
		 */
		public static const REWARDQUANTITY:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.QuestDataMessage.rewardQuantity", "rewardQuantity", (9 << 3) | com.netease.protobuf.WireType.VARINT);

		public var rewardQuantity:uint;

		/**
		 *  @private
		 */
		public static const OPTIONS:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.QuestDataMessage.options", "options", (10 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var options$field:String;

		public function clearOptions():void {
			options$field = null;
		}

		public function get hasOptions():Boolean {
			return options$field != null;
		}

		public function set options(value:String):void {
			options$field = value;
		}

		public function get options():String {
			return options$field;
		}

		/**
		 *  @private
		 */
		public static const MINLEVEL:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.QuestDataMessage.minLevel", "minLevel", (11 << 3) | com.netease.protobuf.WireType.VARINT);

		private var minLevel$field:uint;

		public function clearMinLevel():void {
			hasField$0 &= 0xfffffffd;
			minLevel$field = new uint();
		}

		public function get hasMinLevel():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set minLevel(value:uint):void {
			hasField$0 |= 0x2;
			minLevel$field = value;
		}

		public function get minLevel():uint {
			return minLevel$field;
		}

		/**
		 *  @private
		 */
		public static const MAXLEVEL:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.QuestDataMessage.maxLevel", "maxLevel", (12 << 3) | com.netease.protobuf.WireType.VARINT);

		private var maxLevel$field:uint;

		public function clearMaxLevel():void {
			hasField$0 &= 0xfffffffb;
			maxLevel$field = new uint();
		}

		public function get hasMaxLevel():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set maxLevel(value:uint):void {
			hasField$0 |= 0x4;
			maxLevel$field = value;
		}

		public function get maxLevel():uint {
			return maxLevel$field;
		}

		/**
		 *  @private
		 */
		public static const MINLTV:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.QuestDataMessage.minLtv", "minLtv", (13 << 3) | com.netease.protobuf.WireType.VARINT);

		private var minLtv$field:uint;

		public function clearMinLtv():void {
			hasField$0 &= 0xfffffff7;
			minLtv$field = new uint();
		}

		public function get hasMinLtv():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set minLtv(value:uint):void {
			hasField$0 |= 0x8;
			minLtv$field = value;
		}

		public function get minLtv():uint {
			return minLtv$field;
		}

		/**
		 *  @private
		 */
		public static const MAXLTV:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.QuestDataMessage.maxLtv", "maxLtv", (14 << 3) | com.netease.protobuf.WireType.VARINT);

		private var maxLtv$field:uint;

		public function clearMaxLtv():void {
			hasField$0 &= 0xffffffef;
			maxLtv$field = new uint();
		}

		public function get hasMaxLtv():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set maxLtv(value:uint):void {
			hasField$0 |= 0x10;
			maxLtv$field = value;
		}

		public function get maxLtv():uint {
			return maxLtv$field;
		}

		/**
		 *  @private
		 */
		public static const MINCASH:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.QuestDataMessage.minCash", "minCash", (15 << 3) | com.netease.protobuf.WireType.VARINT);

		private var minCash$field:uint;

		public function clearMinCash():void {
			hasField$0 &= 0xffffffdf;
			minCash$field = new uint();
		}

		public function get hasMinCash():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set minCash(value:uint):void {
			hasField$0 |= 0x20;
			minCash$field = value;
		}

		public function get minCash():uint {
			return minCash$field;
		}

		/**
		 *  @private
		 */
		public static const MAXCASH:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.QuestDataMessage.maxCash", "maxCash", (16 << 3) | com.netease.protobuf.WireType.VARINT);

		private var maxCash$field:uint;

		public function clearMaxCash():void {
			hasField$0 &= 0xffffffbf;
			maxCash$field = new uint();
		}

		public function get hasMaxCash():Boolean {
			return (hasField$0 & 0x40) != 0;
		}

		public function set maxCash(value:uint):void {
			hasField$0 |= 0x40;
			maxCash$field = value;
		}

		public function get maxCash():uint {
			return maxCash$field;
		}

		/**
		 *  @private
		 */
		public static const MINPOWERUPS:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.QuestDataMessage.minPowerups", "minPowerups", (17 << 3) | com.netease.protobuf.WireType.VARINT);

		private var minPowerups$field:uint;

		public function clearMinPowerups():void {
			hasField$0 &= 0xffffff7f;
			minPowerups$field = new uint();
		}

		public function get hasMinPowerups():Boolean {
			return (hasField$0 & 0x80) != 0;
		}

		public function set minPowerups(value:uint):void {
			hasField$0 |= 0x80;
			minPowerups$field = value;
		}

		public function get minPowerups():uint {
			return minPowerups$field;
		}

		/**
		 *  @private
		 */
		public static const MAXPOWERUPS:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.QuestDataMessage.maxPowerups", "maxPowerups", (18 << 3) | com.netease.protobuf.WireType.VARINT);

		private var maxPowerups$field:uint;

		public function clearMaxPowerups():void {
			hasField$0 &= 0xfffffeff;
			maxPowerups$field = new uint();
		}

		public function get hasMaxPowerups():Boolean {
			return (hasField$0 & 0x100) != 0;
		}

		public function set maxPowerups(value:uint):void {
			hasField$0 |= 0x100;
			maxPowerups$field = value;
		}

		public function get maxPowerups():uint {
			return maxPowerups$field;
		}

		/**
		 *  @private
		 */
		public static const WEIGHT:FieldDescriptor$TYPE_DOUBLE = new FieldDescriptor$TYPE_DOUBLE("com.alisacasino.bingo.protocol.QuestDataMessage.weight", "weight", (19 << 3) | com.netease.protobuf.WireType.FIXED_64_BIT);

		public var weight:Number;

		/**
		 *  @private
		 */
		public static const ENABLED:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.alisacasino.bingo.protocol.QuestDataMessage.enabled", "enabled", (20 << 3) | com.netease.protobuf.WireType.VARINT);

		public var enabled:Boolean;

		/**
		 *  @private
		 */
		public static const SHOWTOTALDIALOG:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.alisacasino.bingo.protocol.QuestDataMessage.showTotalDialog", "showTotalDialog", (21 << 3) | com.netease.protobuf.WireType.VARINT);

		public var showTotalDialog:Boolean;

		/**
		 *  @private
		 */
		public static const MINCLIENTVERSION:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.QuestDataMessage.minClientVersion", "minClientVersion", (22 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var minClientVersion$field:String;

		public function clearMinClientVersion():void {
			minClientVersion$field = null;
		}

		public function get hasMinClientVersion():Boolean {
			return minClientVersion$field != null;
		}

		public function set minClientVersion(value:String):void {
			minClientVersion$field = value;
		}

		public function get minClientVersion():String {
			return minClientVersion$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.id);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.type);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.objectiveType);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.tier);
			if (hasDuration) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, duration$field);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.goal);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 7);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.rewardType);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 8);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.rewardSubtype);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 9);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.rewardQuantity);
			if (hasOptions) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 10);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, options$field);
			}
			if (hasMinLevel) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 11);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, minLevel$field);
			}
			if (hasMaxLevel) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 12);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, maxLevel$field);
			}
			if (hasMinLtv) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 13);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, minLtv$field);
			}
			if (hasMaxLtv) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 14);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, maxLtv$field);
			}
			if (hasMinCash) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 15);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, minCash$field);
			}
			if (hasMaxCash) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 16);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, maxCash$field);
			}
			if (hasMinPowerups) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 17);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, minPowerups$field);
			}
			if (hasMaxPowerups) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 18);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, maxPowerups$field);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_64_BIT, 19);
			com.netease.protobuf.WriteUtils.write$TYPE_DOUBLE(output, this.weight);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 20);
			com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, this.enabled);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 21);
			com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, this.showTotalDialog);
			if (hasMinClientVersion) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 22);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, minClientVersion$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var id$count:uint = 0;
			var type$count:uint = 0;
			var objectiveType$count:uint = 0;
			var tier$count:uint = 0;
			var duration$count:uint = 0;
			var goal$count:uint = 0;
			var rewardType$count:uint = 0;
			var rewardSubtype$count:uint = 0;
			var rewardQuantity$count:uint = 0;
			var options$count:uint = 0;
			var minLevel$count:uint = 0;
			var maxLevel$count:uint = 0;
			var minLtv$count:uint = 0;
			var maxLtv$count:uint = 0;
			var minCash$count:uint = 0;
			var maxCash$count:uint = 0;
			var minPowerups$count:uint = 0;
			var maxPowerups$count:uint = 0;
			var weight$count:uint = 0;
			var enabled$count:uint = 0;
			var showTotalDialog$count:uint = 0;
			var minClientVersion$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: QuestDataMessage.id cannot be set twice.');
					}
					++id$count;
					this.id = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (type$count != 0) {
						throw new flash.errors.IOError('Bad data format: QuestDataMessage.type cannot be set twice.');
					}
					++type$count;
					this.type = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (objectiveType$count != 0) {
						throw new flash.errors.IOError('Bad data format: QuestDataMessage.objectiveType cannot be set twice.');
					}
					++objectiveType$count;
					this.objectiveType = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (tier$count != 0) {
						throw new flash.errors.IOError('Bad data format: QuestDataMessage.tier cannot be set twice.');
					}
					++tier$count;
					this.tier = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (duration$count != 0) {
						throw new flash.errors.IOError('Bad data format: QuestDataMessage.duration cannot be set twice.');
					}
					++duration$count;
					this.duration = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (goal$count != 0) {
						throw new flash.errors.IOError('Bad data format: QuestDataMessage.goal cannot be set twice.');
					}
					++goal$count;
					this.goal = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 7:
					if (rewardType$count != 0) {
						throw new flash.errors.IOError('Bad data format: QuestDataMessage.rewardType cannot be set twice.');
					}
					++rewardType$count;
					this.rewardType = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 8:
					if (rewardSubtype$count != 0) {
						throw new flash.errors.IOError('Bad data format: QuestDataMessage.rewardSubtype cannot be set twice.');
					}
					++rewardSubtype$count;
					this.rewardSubtype = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 9:
					if (rewardQuantity$count != 0) {
						throw new flash.errors.IOError('Bad data format: QuestDataMessage.rewardQuantity cannot be set twice.');
					}
					++rewardQuantity$count;
					this.rewardQuantity = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 10:
					if (options$count != 0) {
						throw new flash.errors.IOError('Bad data format: QuestDataMessage.options cannot be set twice.');
					}
					++options$count;
					this.options = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 11:
					if (minLevel$count != 0) {
						throw new flash.errors.IOError('Bad data format: QuestDataMessage.minLevel cannot be set twice.');
					}
					++minLevel$count;
					this.minLevel = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 12:
					if (maxLevel$count != 0) {
						throw new flash.errors.IOError('Bad data format: QuestDataMessage.maxLevel cannot be set twice.');
					}
					++maxLevel$count;
					this.maxLevel = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 13:
					if (minLtv$count != 0) {
						throw new flash.errors.IOError('Bad data format: QuestDataMessage.minLtv cannot be set twice.');
					}
					++minLtv$count;
					this.minLtv = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 14:
					if (maxLtv$count != 0) {
						throw new flash.errors.IOError('Bad data format: QuestDataMessage.maxLtv cannot be set twice.');
					}
					++maxLtv$count;
					this.maxLtv = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 15:
					if (minCash$count != 0) {
						throw new flash.errors.IOError('Bad data format: QuestDataMessage.minCash cannot be set twice.');
					}
					++minCash$count;
					this.minCash = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 16:
					if (maxCash$count != 0) {
						throw new flash.errors.IOError('Bad data format: QuestDataMessage.maxCash cannot be set twice.');
					}
					++maxCash$count;
					this.maxCash = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 17:
					if (minPowerups$count != 0) {
						throw new flash.errors.IOError('Bad data format: QuestDataMessage.minPowerups cannot be set twice.');
					}
					++minPowerups$count;
					this.minPowerups = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 18:
					if (maxPowerups$count != 0) {
						throw new flash.errors.IOError('Bad data format: QuestDataMessage.maxPowerups cannot be set twice.');
					}
					++maxPowerups$count;
					this.maxPowerups = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 19:
					if (weight$count != 0) {
						throw new flash.errors.IOError('Bad data format: QuestDataMessage.weight cannot be set twice.');
					}
					++weight$count;
					this.weight = com.netease.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 20:
					if (enabled$count != 0) {
						throw new flash.errors.IOError('Bad data format: QuestDataMessage.enabled cannot be set twice.');
					}
					++enabled$count;
					this.enabled = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 21:
					if (showTotalDialog$count != 0) {
						throw new flash.errors.IOError('Bad data format: QuestDataMessage.showTotalDialog cannot be set twice.');
					}
					++showTotalDialog$count;
					this.showTotalDialog = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 22:
					if (minClientVersion$count != 0) {
						throw new flash.errors.IOError('Bad data format: QuestDataMessage.minClientVersion cannot be set twice.');
					}
					++minClientVersion$count;
					this.minClientVersion = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
