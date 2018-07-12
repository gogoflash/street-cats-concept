package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.ChestType;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class ChestSlotMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const TYPE:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.alisacasino.bingo.protocol.ChestSlotMessage.type", "type", (1 << 3) | com.netease.protobuf.WireType.VARINT, com.alisacasino.bingo.protocol.ChestType);

		public var type:int;

		/**
		 *  @private
		 */
		public static const SEED:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.alisacasino.bingo.protocol.ChestSlotMessage.seed", "seed", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var seed:int;

		/**
		 *  @private
		 */
		public static const OPEN_TIME_MILLIS:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.ChestSlotMessage.open_time_millis", "openTimeMillis", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var open_time_millis$field:UInt64;

		public function clearOpenTimeMillis():void {
			open_time_millis$field = null;
		}

		public function get hasOpenTimeMillis():Boolean {
			return open_time_millis$field != null;
		}

		public function set openTimeMillis(value:UInt64):void {
			open_time_millis$field = value;
		}

		public function get openTimeMillis():UInt64 {
			return open_time_millis$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.type);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.seed);
			if (hasOpenTimeMillis) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, open_time_millis$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var type$count:uint = 0;
			var seed$count:uint = 0;
			var open_time_millis$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (type$count != 0) {
						throw new flash.errors.IOError('Bad data format: ChestSlotMessage.type cannot be set twice.');
					}
					++type$count;
					this.type = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 2:
					if (seed$count != 0) {
						throw new flash.errors.IOError('Bad data format: ChestSlotMessage.seed cannot be set twice.');
					}
					++seed$count;
					this.seed = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (open_time_millis$count != 0) {
						throw new flash.errors.IOError('Bad data format: ChestSlotMessage.openTimeMillis cannot be set twice.');
					}
					++open_time_millis$count;
					this.openTimeMillis = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
