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
	public dynamic final class ClaimOfferOkMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const OFFER_NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.ClaimOfferOkMessage.offer_name", "offerName", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var offerName:String;

		/**
		 *  @private
		 */
		public static const OFFER_TYPE:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.ClaimOfferOkMessage.offer_type", "offerType", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var offerType:String;

		/**
		 *  @private
		 */
		public static const OFFER_VALUE:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.ClaimOfferOkMessage.offer_value", "offerValue", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var offerValue:uint;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.offerName);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.offerType);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.offerValue);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var offer_name$count:uint = 0;
			var offer_type$count:uint = 0;
			var offer_value$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (offer_name$count != 0) {
						throw new flash.errors.IOError('Bad data format: ClaimOfferOkMessage.offerName cannot be set twice.');
					}
					++offer_name$count;
					this.offerName = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 2:
					if (offer_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: ClaimOfferOkMessage.offerType cannot be set twice.');
					}
					++offer_type$count;
					this.offerType = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (offer_value$count != 0) {
						throw new flash.errors.IOError('Bad data format: ClaimOfferOkMessage.offerValue cannot be set twice.');
					}
					++offer_value$count;
					this.offerValue = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
