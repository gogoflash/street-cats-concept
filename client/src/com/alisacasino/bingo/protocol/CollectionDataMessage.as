package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.CollectionPageDataMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CollectionDataMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const COLLECTION_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.alisacasino.bingo.protocol.CollectionDataMessage.collection_id", "collectionId", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		public var collectionId:int;

		/**
		 *  @private
		 */
		public static const NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.CollectionDataMessage.name", "name", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var name:String;

		/**
		 *  @private
		 */
		public static const BACKGROUND_PATH:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.CollectionDataMessage.background_path", "backgroundPath", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var backgroundPath:String;

		/**
		 *  @private
		 */
		public static const SOUNDTRACK_PATH:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.CollectionDataMessage.soundtrack_path", "soundtrackPath", (6 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var soundtrackPath:String;

		/**
		 *  @private
		 */
		public static const SHIRT_PATH:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.CollectionDataMessage.shirt_path", "shirtPath", (8 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var shirtPath:String;

		/**
		 *  @private
		 */
		public static const POWERUP_TYPES_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.alisacasino.bingo.protocol.CollectionDataMessage.powerup_types_id", "powerupTypesId", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		public var powerupTypesId:int;

		/**
		 *  @private
		 */
		public static const PAGES:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.CollectionDataMessage.pages", "pages", (7 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.CollectionPageDataMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.CollectionPageDataMessage")]
		public var pages:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.collectionId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.name);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.backgroundPath);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 6);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.soundtrackPath);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 8);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.shirtPath);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.powerupTypesId);
			for (var pages$index:uint = 0; pages$index < this.pages.length; ++pages$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.pages[pages$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var collection_id$count:uint = 0;
			var name$count:uint = 0;
			var background_path$count:uint = 0;
			var soundtrack_path$count:uint = 0;
			var shirt_path$count:uint = 0;
			var powerup_types_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 4:
					if (collection_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CollectionDataMessage.collectionId cannot be set twice.');
					}
					++collection_id$count;
					this.collectionId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 1:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: CollectionDataMessage.name cannot be set twice.');
					}
					++name$count;
					this.name = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 2:
					if (background_path$count != 0) {
						throw new flash.errors.IOError('Bad data format: CollectionDataMessage.backgroundPath cannot be set twice.');
					}
					++background_path$count;
					this.backgroundPath = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 6:
					if (soundtrack_path$count != 0) {
						throw new flash.errors.IOError('Bad data format: CollectionDataMessage.soundtrackPath cannot be set twice.');
					}
					++soundtrack_path$count;
					this.soundtrackPath = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 8:
					if (shirt_path$count != 0) {
						throw new flash.errors.IOError('Bad data format: CollectionDataMessage.shirtPath cannot be set twice.');
					}
					++shirt_path$count;
					this.shirtPath = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 5:
					if (powerup_types_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CollectionDataMessage.powerupTypesId cannot be set twice.');
					}
					++powerup_types_id$count;
					this.powerupTypesId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 7:
					this.pages.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.CollectionPageDataMessage()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
