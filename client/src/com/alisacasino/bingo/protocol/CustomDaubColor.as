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
	public dynamic final class CustomDaubColor extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ID:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.CustomDaubColor.id", "id", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var id:uint;

		/**
		 *  @private
		 */
		public static const UID:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.CustomDaubColor.uid", "uid", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var uid:String;

		/**
		 *  @private
		 */
		public static const NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.CustomDaubColor.name", "name", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var name:String;

		/**
		 *  @private
		 */
		public static const COLORCODE:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.CustomDaubColor.colorCode", "colorCode", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var colorCode:String;

		/**
		 *  @private
		 */
		public static const IMAGEURL:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.CustomDaubColor.imageUrl", "imageUrl", (5 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var imageUrl:String;

		/**
		 *  @private
		 */
		public static const WEIGHT:FieldDescriptor$TYPE_DOUBLE = new FieldDescriptor$TYPE_DOUBLE("com.alisacasino.bingo.protocol.CustomDaubColor.weight", "weight", (6 << 3) | com.netease.protobuf.WireType.FIXED_64_BIT);

		public var weight:Number;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.id);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.uid);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.name);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.colorCode);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 5);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.imageUrl);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_64_BIT, 6);
			com.netease.protobuf.WriteUtils.write$TYPE_DOUBLE(output, this.weight);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var id$count:uint = 0;
			var uid$count:uint = 0;
			var name$count:uint = 0;
			var colorCode$count:uint = 0;
			var imageUrl$count:uint = 0;
			var weight$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomDaubColor.id cannot be set twice.');
					}
					++id$count;
					this.id = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (uid$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomDaubColor.uid cannot be set twice.');
					}
					++uid$count;
					this.uid = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomDaubColor.name cannot be set twice.');
					}
					++name$count;
					this.name = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (colorCode$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomDaubColor.colorCode cannot be set twice.');
					}
					++colorCode$count;
					this.colorCode = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 5:
					if (imageUrl$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomDaubColor.imageUrl cannot be set twice.');
					}
					++imageUrl$count;
					this.imageUrl = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 6:
					if (weight$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomDaubColor.weight cannot be set twice.');
					}
					++weight$count;
					this.weight = com.netease.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
