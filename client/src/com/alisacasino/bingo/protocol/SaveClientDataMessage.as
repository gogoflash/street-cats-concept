package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import flash.utils.ByteArray;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SaveClientDataMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const CLIENT_DATA:FieldDescriptor$TYPE_BYTES = new FieldDescriptor$TYPE_BYTES("com.alisacasino.bingo.protocol.SaveClientDataMessage.client_data", "clientData", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var client_data$field:flash.utils.ByteArray;

		public function clearClientData():void {
			client_data$field = null;
		}

		public function get hasClientData():Boolean {
			return client_data$field != null;
		}

		public function set clientData(value:flash.utils.ByteArray):void {
			client_data$field = value;
		}

		public function get clientData():flash.utils.ByteArray {
			return client_data$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasClientData) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_BYTES(output, client_data$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var client_data$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (client_data$count != 0) {
						throw new flash.errors.IOError('Bad data format: SaveClientDataMessage.clientData cannot be set twice.');
					}
					++client_data$count;
					this.clientData = com.netease.protobuf.ReadUtils.read$TYPE_BYTES(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
