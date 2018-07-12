package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.VoiceType;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class RoomResourceBundleMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const VOICE:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.alisacasino.bingo.protocol.RoomResourceBundleMessage.voice", "voice", (1 << 3) | com.netease.protobuf.WireType.VARINT, com.alisacasino.bingo.protocol.VoiceType);

		public var voice:int;

		/**
		 *  @private
		 */
		public static const BACKGROUND_ASSET:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.RoomResourceBundleMessage.background_asset", "backgroundAsset", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var backgroundAsset:String;

		/**
		 *  @private
		 */
		public static const SOUNDTRACK_ASSET:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.RoomResourceBundleMessage.soundtrack_asset", "soundtrackAsset", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var soundtrackAsset:String;

		/**
		 *  @private
		 */
		public static const CAT_ASSET:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.RoomResourceBundleMessage.cat_asset", "catAsset", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var catAsset:String;

		/**
		 *  @private
		 */
		public static const EVENT_TITLE_ASSET:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.RoomResourceBundleMessage.event_title_asset", "eventTitleAsset", (5 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var eventTitleAsset:String;

		/**
		 *  @private
		 */
		public static const ICON_ASSET:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.RoomResourceBundleMessage.icon_asset", "iconAsset", (6 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var iconAsset:String;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.voice);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.backgroundAsset);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.soundtrackAsset);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.catAsset);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 5);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.eventTitleAsset);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 6);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.iconAsset);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var voice$count:uint = 0;
			var background_asset$count:uint = 0;
			var soundtrack_asset$count:uint = 0;
			var cat_asset$count:uint = 0;
			var event_title_asset$count:uint = 0;
			var icon_asset$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (voice$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomResourceBundleMessage.voice cannot be set twice.');
					}
					++voice$count;
					this.voice = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 2:
					if (background_asset$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomResourceBundleMessage.backgroundAsset cannot be set twice.');
					}
					++background_asset$count;
					this.backgroundAsset = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (soundtrack_asset$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomResourceBundleMessage.soundtrackAsset cannot be set twice.');
					}
					++soundtrack_asset$count;
					this.soundtrackAsset = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (cat_asset$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomResourceBundleMessage.catAsset cannot be set twice.');
					}
					++cat_asset$count;
					this.catAsset = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 5:
					if (event_title_asset$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomResourceBundleMessage.eventTitleAsset cannot be set twice.');
					}
					++event_title_asset$count;
					this.eventTitleAsset = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 6:
					if (icon_asset$count != 0) {
						throw new flash.errors.IOError('Bad data format: RoomResourceBundleMessage.iconAsset cannot be set twice.');
					}
					++icon_asset$count;
					this.iconAsset = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
