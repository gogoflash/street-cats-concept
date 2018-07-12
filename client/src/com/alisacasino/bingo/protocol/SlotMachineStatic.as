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
	public dynamic final class SlotMachineStatic extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.alisacasino.bingo.protocol.SlotMachineStatic.id", "id", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var id$field:int;

		private var hasField$0:uint = 0;

		public function clearId():void {
			hasField$0 &= 0xfffffffe;
			id$field = new int();
		}

		public function get hasId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set id(value:int):void {
			hasField$0 |= 0x1;
			id$field = value;
		}

		public function get id():int {
			return id$field;
		}

		/**
		 *  @private
		 */
		public static const STAKE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.alisacasino.bingo.protocol.SlotMachineStatic.stake", "stake", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var stake$field:int;

		public function clearStake():void {
			hasField$0 &= 0xfffffffd;
			stake$field = new int();
		}

		public function get hasStake():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set stake(value:int):void {
			hasField$0 |= 0x2;
			stake$field = value;
		}

		public function get stake():int {
			return stake$field;
		}

		/**
		 *  @private
		 */
		public static const TYPE:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.SlotMachineStatic.type", "type", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var type$field:String;

		public function clearType():void {
			type$field = null;
		}

		public function get hasType():Boolean {
			return type$field != null;
		}

		public function set type(value:String):void {
			type$field = value;
		}

		public function get type():String {
			return type$field;
		}

		/**
		 *  @private
		 */
		public static const WINNINGCOMBO:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.SlotMachineStatic.winningCombo", "winningCombo", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var winningCombo$field:String;

		public function clearWinningCombo():void {
			winningCombo$field = null;
		}

		public function get hasWinningCombo():Boolean {
			return winningCombo$field != null;
		}

		public function set winningCombo(value:String):void {
			winningCombo$field = value;
		}

		public function get winningCombo():String {
			return winningCombo$field;
		}

		/**
		 *  @private
		 */
		public static const WEIGHT:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.alisacasino.bingo.protocol.SlotMachineStatic.weight", "weight", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var weight$field:int;

		public function clearWeight():void {
			hasField$0 &= 0xfffffffb;
			weight$field = new int();
		}

		public function get hasWeight():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set weight(value:int):void {
			hasField$0 |= 0x4;
			weight$field = value;
		}

		public function get weight():int {
			return weight$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, id$field);
			}
			if (hasStake) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, stake$field);
			}
			if (hasType) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, type$field);
			}
			if (hasWinningCombo) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, winningCombo$field);
			}
			if (hasWeight) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, weight$field);
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
			var stake$count:uint = 0;
			var type$count:uint = 0;
			var winningCombo$count:uint = 0;
			var weight$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SlotMachineStatic.id cannot be set twice.');
					}
					++id$count;
					this.id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (stake$count != 0) {
						throw new flash.errors.IOError('Bad data format: SlotMachineStatic.stake cannot be set twice.');
					}
					++stake$count;
					this.stake = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (type$count != 0) {
						throw new flash.errors.IOError('Bad data format: SlotMachineStatic.type cannot be set twice.');
					}
					++type$count;
					this.type = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (winningCombo$count != 0) {
						throw new flash.errors.IOError('Bad data format: SlotMachineStatic.winningCombo cannot be set twice.');
					}
					++winningCombo$count;
					this.winningCombo = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 5:
					if (weight$count != 0) {
						throw new flash.errors.IOError('Bad data format: SlotMachineStatic.weight cannot be set twice.');
					}
					++weight$count;
					this.weight = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
