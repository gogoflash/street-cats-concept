package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.CollectionItemDataMessage;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.ModificatorMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CollectionPageDataMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ID:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.CollectionPageDataMessage.id", "id", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		public var id:uint;

		/**
		 *  @private
		 */
		public static const TROPHY:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.CollectionPageDataMessage.trophy", "trophy", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var trophy:String;

		/**
		 *  @private
		 */
		public static const NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.CollectionPageDataMessage.name", "name", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var name:String;

		/**
		 *  @private
		 */
		public static const OPENGRAPH_URL:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.CollectionPageDataMessage.opengraph_url", "opengraphUrl", (9 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var opengraph_url$field:String;

		public function clearOpengraphUrl():void {
			opengraph_url$field = null;
		}

		public function get hasOpengraphUrl():Boolean {
			return opengraph_url$field != null;
		}

		public function set opengraphUrl(value:String):void {
			opengraph_url$field = value;
		}

		public function get opengraphUrl():String {
			return opengraph_url$field;
		}

		/**
		 *  @private
		 */
		public static const ITEMS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.CollectionPageDataMessage.items", "items", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.CollectionItemDataMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.CollectionItemDataMessage")]
		public var items:Array = [];

		/**
		 *  @private
		 */
		public static const PERMANENT_PRIZES:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.CollectionPageDataMessage.permanent_prizes", "permanentPrizes", (6 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.ModificatorMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.ModificatorMessage")]
		public var permanentPrizes:Array = [];

		/**
		 *  @private
		 */
		public static const ONE_TIME_PRIZES:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.CollectionPageDataMessage.one_time_prizes", "oneTimePrizes", (7 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.CommodityItemMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.CommodityItemMessage")]
		public var oneTimePrizes:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.id);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.trophy);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.name);
			if (hasOpengraphUrl) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 9);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, opengraph_url$field);
			}
			for (var items$index:uint = 0; items$index < this.items.length; ++items$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.items[items$index]);
			}
			for (var permanentPrizes$index:uint = 0; permanentPrizes$index < this.permanentPrizes.length; ++permanentPrizes$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.permanentPrizes[permanentPrizes$index]);
			}
			for (var oneTimePrizes$index:uint = 0; oneTimePrizes$index < this.oneTimePrizes.length; ++oneTimePrizes$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.oneTimePrizes[oneTimePrizes$index]);
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
			var trophy$count:uint = 0;
			var name$count:uint = 0;
			var opengraph_url$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 4:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CollectionPageDataMessage.id cannot be set twice.');
					}
					++id$count;
					this.id = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 1:
					if (trophy$count != 0) {
						throw new flash.errors.IOError('Bad data format: CollectionPageDataMessage.trophy cannot be set twice.');
					}
					++trophy$count;
					this.trophy = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 2:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: CollectionPageDataMessage.name cannot be set twice.');
					}
					++name$count;
					this.name = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 9:
					if (opengraph_url$count != 0) {
						throw new flash.errors.IOError('Bad data format: CollectionPageDataMessage.opengraphUrl cannot be set twice.');
					}
					++opengraph_url$count;
					this.opengraphUrl = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					this.items.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.CollectionItemDataMessage()));
					break;
				case 6:
					this.permanentPrizes.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.ModificatorMessage()));
					break;
				case 7:
					this.oneTimePrizes.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.CommodityItemMessage()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
