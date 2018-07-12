package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.CardType;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CustomDaubIcon extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ID:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.CustomDaubIcon.id", "id", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var id:uint;

		/**
		 *  @private
		 */
		public static const UID:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.CustomDaubIcon.uid", "uid", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var uid:String;

		/**
		 *  @private
		 */
		public static const NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.CustomDaubIcon.name", "name", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var name:String;

		/**
		 *  @private
		 */
		public static const ASSETURL:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.CustomDaubIcon.assetUrl", "assetUrl", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var assetUrl:String;

		/**
		 *  @private
		 */
		public static const IMAGEURL:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.CustomDaubIcon.imageUrl", "imageUrl", (5 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var imageUrl:String;

		/**
		 *  @private
		 */
		public static const WEIGHT:FieldDescriptor$TYPE_DOUBLE = new FieldDescriptor$TYPE_DOUBLE("com.alisacasino.bingo.protocol.CustomDaubIcon.weight", "weight", (6 << 3) | com.netease.protobuf.WireType.FIXED_64_BIT);

		public var weight:Number;

		/**
		 *  @private
		 */
		public static const ORDER:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.CustomDaubIcon.order", "order", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		public var order:uint;

		/**
		 *  @private
		 */
		public static const RARITY:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.alisacasino.bingo.protocol.CustomDaubIcon.rarity", "rarity", (8 << 3) | com.netease.protobuf.WireType.VARINT, com.alisacasino.bingo.protocol.CardType);

		public var rarity:int;

		/**
		 *  @private
		 */
		public static const PRACTICLEANIMATION:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.CustomDaubIcon.practicleAnimation", "practicleAnimation", (9 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var practicleAnimation:String;

		/**
		 *  @private
		 */
		public static const SETID:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.CustomDaubIcon.setId", "setId", (10 << 3) | com.netease.protobuf.WireType.VARINT);

		private var setId$field:uint;

		private var hasField$0:uint = 0;

		public function clearSetId():void {
			hasField$0 &= 0xfffffffe;
			setId$field = new uint();
		}

		public function get hasSetId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set setId(value:uint):void {
			hasField$0 |= 0x1;
			setId$field = value;
		}

		public function get setId():uint {
			return setId$field;
		}

		/**
		 *  @private
		 */
		public static const COLOR:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.CustomDaubIcon.color", "color", (11 << 3) | com.netease.protobuf.WireType.VARINT);

		private var color$field:uint;

		public function clearColor():void {
			hasField$0 &= 0xfffffffd;
			color$field = new uint();
		}

		public function get hasColor():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set color(value:uint):void {
			hasField$0 |= 0x2;
			color$field = value;
		}

		public function get color():uint {
			return color$field;
		}

		/**
		 *  @private
		 */
		public static const SET_PRICE:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.CustomDaubIcon.set_price", "setPrice", (12 << 3) | com.netease.protobuf.WireType.VARINT);

		public var setPrice:uint;

		/**
		 *  @private
		 */
		public static const MARKED_CELL_TEXT_COLOR:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.CustomDaubIcon.marked_cell_text_color", "markedCellTextColor", (13 << 3) | com.netease.protobuf.WireType.VARINT);

		public var markedCellTextColor:uint;

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
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.assetUrl);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 5);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.imageUrl);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_64_BIT, 6);
			com.netease.protobuf.WriteUtils.write$TYPE_DOUBLE(output, this.weight);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.order);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 8);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.rarity);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 9);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.practicleAnimation);
			if (hasSetId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 10);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, setId$field);
			}
			if (hasColor) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 11);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, color$field);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 12);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.setPrice);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 13);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.markedCellTextColor);
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
			var assetUrl$count:uint = 0;
			var imageUrl$count:uint = 0;
			var weight$count:uint = 0;
			var order$count:uint = 0;
			var rarity$count:uint = 0;
			var practicleAnimation$count:uint = 0;
			var setId$count:uint = 0;
			var color$count:uint = 0;
			var set_price$count:uint = 0;
			var marked_cell_text_color$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomDaubIcon.id cannot be set twice.');
					}
					++id$count;
					this.id = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (uid$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomDaubIcon.uid cannot be set twice.');
					}
					++uid$count;
					this.uid = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomDaubIcon.name cannot be set twice.');
					}
					++name$count;
					this.name = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (assetUrl$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomDaubIcon.assetUrl cannot be set twice.');
					}
					++assetUrl$count;
					this.assetUrl = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 5:
					if (imageUrl$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomDaubIcon.imageUrl cannot be set twice.');
					}
					++imageUrl$count;
					this.imageUrl = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 6:
					if (weight$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomDaubIcon.weight cannot be set twice.');
					}
					++weight$count;
					this.weight = com.netease.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 7:
					if (order$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomDaubIcon.order cannot be set twice.');
					}
					++order$count;
					this.order = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 8:
					if (rarity$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomDaubIcon.rarity cannot be set twice.');
					}
					++rarity$count;
					this.rarity = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 9:
					if (practicleAnimation$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomDaubIcon.practicleAnimation cannot be set twice.');
					}
					++practicleAnimation$count;
					this.practicleAnimation = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 10:
					if (setId$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomDaubIcon.setId cannot be set twice.');
					}
					++setId$count;
					this.setId = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 11:
					if (color$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomDaubIcon.color cannot be set twice.');
					}
					++color$count;
					this.color = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 12:
					if (set_price$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomDaubIcon.setPrice cannot be set twice.');
					}
					++set_price$count;
					this.setPrice = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 13:
					if (marked_cell_text_color$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomDaubIcon.markedCellTextColor cannot be set twice.');
					}
					++marked_cell_text_color$count;
					this.markedCellTextColor = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
