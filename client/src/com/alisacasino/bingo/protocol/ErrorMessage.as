package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.ErrorMessage.ErrorCode;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class ErrorMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const CODE:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.alisacasino.bingo.protocol.ErrorMessage.code", "code", (1 << 3) | com.netease.protobuf.WireType.VARINT, com.alisacasino.bingo.protocol.ErrorMessage.ErrorCode);

		public var code:int = com.alisacasino.bingo.protocol.ErrorMessage.ErrorCode.DefaultError;

		/**
		 *  @private
		 */
		public static const DESCRIPTION:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.ErrorMessage.description", "description", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var description$field:String;

		public function clearDescription():void {
			description$field = null;
		}

		public function get hasDescription():Boolean {
			return description$field != null;
		}

		public function set description(value:String):void {
			description$field = value;
		}

		public function get description():String {
			return description$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.code);
			if (hasDescription) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, description$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var code$count:uint = 0;
			var description$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (code$count != 0) {
						throw new flash.errors.IOError('Bad data format: ErrorMessage.code cannot be set twice.');
					}
					++code$count;
					this.code = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 2:
					if (description$count != 0) {
						throw new flash.errors.IOError('Bad data format: ErrorMessage.description cannot be set twice.');
					}
					++description$count;
					this.description = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
