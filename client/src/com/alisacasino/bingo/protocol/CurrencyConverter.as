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
	public dynamic final class CurrencyConverter extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const DUST_GAIN_COLLECTION_NORMAL:FieldDescriptor$TYPE_DOUBLE = new FieldDescriptor$TYPE_DOUBLE("com.alisacasino.bingo.protocol.CurrencyConverter.dust_gain_collection_normal", "dustGainCollectionNormal", (1 << 3) | com.netease.protobuf.WireType.FIXED_64_BIT);

		private var dust_gain_collection_normal$field:Number;

		private var hasField$0:uint = 0;

		public function clearDustGainCollectionNormal():void {
			hasField$0 &= 0xfffffffe;
			dust_gain_collection_normal$field = new Number();
		}

		public function get hasDustGainCollectionNormal():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set dustGainCollectionNormal(value:Number):void {
			hasField$0 |= 0x1;
			dust_gain_collection_normal$field = value;
		}

		public function get dustGainCollectionNormal():Number {
			return dust_gain_collection_normal$field;
		}

		/**
		 *  @private
		 */
		public static const DUST_GAIN_COLLECTION_MAGIC:FieldDescriptor$TYPE_DOUBLE = new FieldDescriptor$TYPE_DOUBLE("com.alisacasino.bingo.protocol.CurrencyConverter.dust_gain_collection_magic", "dustGainCollectionMagic", (2 << 3) | com.netease.protobuf.WireType.FIXED_64_BIT);

		private var dust_gain_collection_magic$field:Number;

		public function clearDustGainCollectionMagic():void {
			hasField$0 &= 0xfffffffd;
			dust_gain_collection_magic$field = new Number();
		}

		public function get hasDustGainCollectionMagic():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set dustGainCollectionMagic(value:Number):void {
			hasField$0 |= 0x2;
			dust_gain_collection_magic$field = value;
		}

		public function get dustGainCollectionMagic():Number {
			return dust_gain_collection_magic$field;
		}

		/**
		 *  @private
		 */
		public static const DUST_GAIN_COLLECTION_RARE:FieldDescriptor$TYPE_DOUBLE = new FieldDescriptor$TYPE_DOUBLE("com.alisacasino.bingo.protocol.CurrencyConverter.dust_gain_collection_rare", "dustGainCollectionRare", (3 << 3) | com.netease.protobuf.WireType.FIXED_64_BIT);

		private var dust_gain_collection_rare$field:Number;

		public function clearDustGainCollectionRare():void {
			hasField$0 &= 0xfffffffb;
			dust_gain_collection_rare$field = new Number();
		}

		public function get hasDustGainCollectionRare():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set dustGainCollectionRare(value:Number):void {
			hasField$0 |= 0x4;
			dust_gain_collection_rare$field = value;
		}

		public function get dustGainCollectionRare():Number {
			return dust_gain_collection_rare$field;
		}

		/**
		 *  @private
		 */
		public static const DUST_GAIN_CUSTOMIZER_NORMAL:FieldDescriptor$TYPE_DOUBLE = new FieldDescriptor$TYPE_DOUBLE("com.alisacasino.bingo.protocol.CurrencyConverter.dust_gain_customizer_normal", "dustGainCustomizerNormal", (4 << 3) | com.netease.protobuf.WireType.FIXED_64_BIT);

		private var dust_gain_customizer_normal$field:Number;

		public function clearDustGainCustomizerNormal():void {
			hasField$0 &= 0xfffffff7;
			dust_gain_customizer_normal$field = new Number();
		}

		public function get hasDustGainCustomizerNormal():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set dustGainCustomizerNormal(value:Number):void {
			hasField$0 |= 0x8;
			dust_gain_customizer_normal$field = value;
		}

		public function get dustGainCustomizerNormal():Number {
			return dust_gain_customizer_normal$field;
		}

		/**
		 *  @private
		 */
		public static const DUST_GAIN_CUSTOMIZER_MAGIC:FieldDescriptor$TYPE_DOUBLE = new FieldDescriptor$TYPE_DOUBLE("com.alisacasino.bingo.protocol.CurrencyConverter.dust_gain_customizer_magic", "dustGainCustomizerMagic", (5 << 3) | com.netease.protobuf.WireType.FIXED_64_BIT);

		private var dust_gain_customizer_magic$field:Number;

		public function clearDustGainCustomizerMagic():void {
			hasField$0 &= 0xffffffef;
			dust_gain_customizer_magic$field = new Number();
		}

		public function get hasDustGainCustomizerMagic():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set dustGainCustomizerMagic(value:Number):void {
			hasField$0 |= 0x10;
			dust_gain_customizer_magic$field = value;
		}

		public function get dustGainCustomizerMagic():Number {
			return dust_gain_customizer_magic$field;
		}

		/**
		 *  @private
		 */
		public static const DUST_GAIN_CUSTOMIZER_RARE:FieldDescriptor$TYPE_DOUBLE = new FieldDescriptor$TYPE_DOUBLE("com.alisacasino.bingo.protocol.CurrencyConverter.dust_gain_customizer_rare", "dustGainCustomizerRare", (6 << 3) | com.netease.protobuf.WireType.FIXED_64_BIT);

		private var dust_gain_customizer_rare$field:Number;

		public function clearDustGainCustomizerRare():void {
			hasField$0 &= 0xffffffdf;
			dust_gain_customizer_rare$field = new Number();
		}

		public function get hasDustGainCustomizerRare():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set dustGainCustomizerRare(value:Number):void {
			hasField$0 |= 0x20;
			dust_gain_customizer_rare$field = value;
		}

		public function get dustGainCustomizerRare():Number {
			return dust_gain_customizer_rare$field;
		}

		/**
		 *  @private
		 */
		public static const DUST_COST_CHEST_CONVERSION:FieldDescriptor$TYPE_DOUBLE = new FieldDescriptor$TYPE_DOUBLE("com.alisacasino.bingo.protocol.CurrencyConverter.dust_cost_chest_conversion", "dustCostChestConversion", (7 << 3) | com.netease.protobuf.WireType.FIXED_64_BIT);

		private var dust_cost_chest_conversion$field:Number;

		public function clearDustCostChestConversion():void {
			hasField$0 &= 0xffffffbf;
			dust_cost_chest_conversion$field = new Number();
		}

		public function get hasDustCostChestConversion():Boolean {
			return (hasField$0 & 0x40) != 0;
		}

		public function set dustCostChestConversion(value:Number):void {
			hasField$0 |= 0x40;
			dust_cost_chest_conversion$field = value;
		}

		public function get dustCostChestConversion():Number {
			return dust_cost_chest_conversion$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasDustGainCollectionNormal) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_64_BIT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_DOUBLE(output, dust_gain_collection_normal$field);
			}
			if (hasDustGainCollectionMagic) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_64_BIT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_DOUBLE(output, dust_gain_collection_magic$field);
			}
			if (hasDustGainCollectionRare) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_64_BIT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_DOUBLE(output, dust_gain_collection_rare$field);
			}
			if (hasDustGainCustomizerNormal) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_64_BIT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_DOUBLE(output, dust_gain_customizer_normal$field);
			}
			if (hasDustGainCustomizerMagic) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_64_BIT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_DOUBLE(output, dust_gain_customizer_magic$field);
			}
			if (hasDustGainCustomizerRare) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_64_BIT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_DOUBLE(output, dust_gain_customizer_rare$field);
			}
			if (hasDustCostChestConversion) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_64_BIT, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_DOUBLE(output, dust_cost_chest_conversion$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var dust_gain_collection_normal$count:uint = 0;
			var dust_gain_collection_magic$count:uint = 0;
			var dust_gain_collection_rare$count:uint = 0;
			var dust_gain_customizer_normal$count:uint = 0;
			var dust_gain_customizer_magic$count:uint = 0;
			var dust_gain_customizer_rare$count:uint = 0;
			var dust_cost_chest_conversion$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (dust_gain_collection_normal$count != 0) {
						throw new flash.errors.IOError('Bad data format: CurrencyConverter.dustGainCollectionNormal cannot be set twice.');
					}
					++dust_gain_collection_normal$count;
					this.dustGainCollectionNormal = com.netease.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 2:
					if (dust_gain_collection_magic$count != 0) {
						throw new flash.errors.IOError('Bad data format: CurrencyConverter.dustGainCollectionMagic cannot be set twice.');
					}
					++dust_gain_collection_magic$count;
					this.dustGainCollectionMagic = com.netease.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 3:
					if (dust_gain_collection_rare$count != 0) {
						throw new flash.errors.IOError('Bad data format: CurrencyConverter.dustGainCollectionRare cannot be set twice.');
					}
					++dust_gain_collection_rare$count;
					this.dustGainCollectionRare = com.netease.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 4:
					if (dust_gain_customizer_normal$count != 0) {
						throw new flash.errors.IOError('Bad data format: CurrencyConverter.dustGainCustomizerNormal cannot be set twice.');
					}
					++dust_gain_customizer_normal$count;
					this.dustGainCustomizerNormal = com.netease.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 5:
					if (dust_gain_customizer_magic$count != 0) {
						throw new flash.errors.IOError('Bad data format: CurrencyConverter.dustGainCustomizerMagic cannot be set twice.');
					}
					++dust_gain_customizer_magic$count;
					this.dustGainCustomizerMagic = com.netease.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 6:
					if (dust_gain_customizer_rare$count != 0) {
						throw new flash.errors.IOError('Bad data format: CurrencyConverter.dustGainCustomizerRare cannot be set twice.');
					}
					++dust_gain_customizer_rare$count;
					this.dustGainCustomizerRare = com.netease.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 7:
					if (dust_cost_chest_conversion$count != 0) {
						throw new flash.errors.IOError('Bad data format: CurrencyConverter.dustCostChestConversion cannot be set twice.');
					}
					++dust_cost_chest_conversion$count;
					this.dustCostChestConversion = com.netease.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
