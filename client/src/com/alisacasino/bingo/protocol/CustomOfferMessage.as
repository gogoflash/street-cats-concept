package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CustomOfferMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.CustomOfferMessage.name", "name", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var name:String;

		/**
		 *  @private
		 */
		public static const FACEBOOK_ITEM_ID:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.CustomOfferMessage.facebook_item_id", "facebookItemId", (14 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var facebookItemId:String;

		/**
		 *  @private
		 */
		public static const AMAZON_ITEM_ID:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.CustomOfferMessage.amazon_item_id", "amazonItemId", (15 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var amazonItemId:String;

		/**
		 *  @private
		 */
		public static const IOS_ITEM_ID:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.CustomOfferMessage.ios_item_id", "iosItemId", (16 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var iosItemId:String;

		/**
		 *  @private
		 */
		public static const ANDROID_ITEM_ID:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.CustomOfferMessage.android_item_id", "androidItemId", (17 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var androidItemId:String;

		/**
		 *  @private
		 */
		public static const TITLE:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.CustomOfferMessage.title", "title", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var title:String;

		/**
		 *  @private
		 */
		public static const PRICE:FieldDescriptor$TYPE_DOUBLE = new FieldDescriptor$TYPE_DOUBLE("com.alisacasino.bingo.protocol.CustomOfferMessage.price", "price", (3 << 3) | com.netease.protobuf.WireType.FIXED_64_BIT);

		public var price:Number;

		/**
		 *  @private
		 */
		public static const PRICE_WITH_SALE:FieldDescriptor$TYPE_DOUBLE = new FieldDescriptor$TYPE_DOUBLE("com.alisacasino.bingo.protocol.CustomOfferMessage.price_with_sale", "priceWithSale", (4 << 3) | com.netease.protobuf.WireType.FIXED_64_BIT);

		public var priceWithSale:Number;

		/**
		 *  @private
		 */
		public static const SALE_PERCENTS:FieldDescriptor$TYPE_DOUBLE = new FieldDescriptor$TYPE_DOUBLE("com.alisacasino.bingo.protocol.CustomOfferMessage.sale_percents", "salePercents", (5 << 3) | com.netease.protobuf.WireType.FIXED_64_BIT);

		public var salePercents:Number;

		/**
		 *  @private
		 */
		public static const TRIGGER:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.CustomOfferMessage.trigger", "trigger", (6 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var trigger:String;

		/**
		 *  @private
		 */
		public static const ENABLED:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.alisacasino.bingo.protocol.CustomOfferMessage.enabled", "enabled", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		public var enabled:Boolean;

		/**
		 *  @private
		 */
		public static const LTV_MIN:FieldDescriptor$TYPE_DOUBLE = new FieldDescriptor$TYPE_DOUBLE("com.alisacasino.bingo.protocol.CustomOfferMessage.ltv_min", "ltvMin", (8 << 3) | com.netease.protobuf.WireType.FIXED_64_BIT);

		public var ltvMin:Number;

		/**
		 *  @private
		 */
		public static const LTV_MAX:FieldDescriptor$TYPE_DOUBLE = new FieldDescriptor$TYPE_DOUBLE("com.alisacasino.bingo.protocol.CustomOfferMessage.ltv_max", "ltvMax", (9 << 3) | com.netease.protobuf.WireType.FIXED_64_BIT);

		public var ltvMax:Number;

		/**
		 *  @private
		 */
		public static const TIMEOUT_ON_HIDE:FieldDescriptor$TYPE_INT64 = new FieldDescriptor$TYPE_INT64("com.alisacasino.bingo.protocol.CustomOfferMessage.timeout_on_hide", "timeoutOnHide", (11 << 3) | com.netease.protobuf.WireType.VARINT);

		private var timeout_on_hide$field:Int64;

		public function clearTimeoutOnHide():void {
			timeout_on_hide$field = null;
		}

		public function get hasTimeoutOnHide():Boolean {
			return timeout_on_hide$field != null;
		}

		public function set timeoutOnHide(value:Int64):void {
			timeout_on_hide$field = value;
		}

		public function get timeoutOnHide():Int64 {
			return timeout_on_hide$field;
		}

		/**
		 *  @private
		 */
		public static const TIMEOUT_ON_PURCHASE:FieldDescriptor$TYPE_INT64 = new FieldDescriptor$TYPE_INT64("com.alisacasino.bingo.protocol.CustomOfferMessage.timeout_on_purchase", "timeoutOnPurchase", (12 << 3) | com.netease.protobuf.WireType.VARINT);

		private var timeout_on_purchase$field:Int64;

		public function clearTimeoutOnPurchase():void {
			timeout_on_purchase$field = null;
		}

		public function get hasTimeoutOnPurchase():Boolean {
			return timeout_on_purchase$field != null;
		}

		public function set timeoutOnPurchase(value:Int64):void {
			timeout_on_purchase$field = value;
		}

		public function get timeoutOnPurchase():Int64 {
			return timeout_on_purchase$field;
		}

		/**
		 *  @private
		 */
		public static const ITEMS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.CustomOfferMessage.items", "items", (13 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.CommodityItemMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.CommodityItemMessage")]
		public var items:Array = [];

		/**
		 *  @private
		 */
		public static const PERCENT_BADGE_COLOR:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.CustomOfferMessage.percent_badge_color", "percentBadgeColor", (18 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var percentBadgeColor:String;

		/**
		 *  @private
		 */
		public static const BADGE_COLOR:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.CustomOfferMessage.badge_color", "badgeColor", (19 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var badgeColor:String;

		/**
		 *  @private
		 */
		public static const PRICE_TEXT_COLOR:FieldDescriptor$TYPE_INT64 = new FieldDescriptor$TYPE_INT64("com.alisacasino.bingo.protocol.CustomOfferMessage.price_text_color", "priceTextColor", (20 << 3) | com.netease.protobuf.WireType.VARINT);

		public var priceTextColor:Int64;

		/**
		 *  @private
		 */
		public static const PRICE_TEXT_BORDER_COLOR:FieldDescriptor$TYPE_INT64 = new FieldDescriptor$TYPE_INT64("com.alisacasino.bingo.protocol.CustomOfferMessage.price_text_border_color", "priceTextBorderColor", (21 << 3) | com.netease.protobuf.WireType.VARINT);

		public var priceTextBorderColor:Int64;

		/**
		 *  @private
		 */
		public static const PERCENT_TEXT_COLOR:FieldDescriptor$TYPE_INT64 = new FieldDescriptor$TYPE_INT64("com.alisacasino.bingo.protocol.CustomOfferMessage.percent_text_color", "percentTextColor", (22 << 3) | com.netease.protobuf.WireType.VARINT);

		public var percentTextColor:Int64;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.name);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 14);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.facebookItemId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 15);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.amazonItemId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 16);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.iosItemId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 17);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.androidItemId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.title);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_64_BIT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_DOUBLE(output, this.price);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_64_BIT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_DOUBLE(output, this.priceWithSale);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_64_BIT, 5);
			com.netease.protobuf.WriteUtils.write$TYPE_DOUBLE(output, this.salePercents);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 6);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.trigger);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
			com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, this.enabled);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_64_BIT, 8);
			com.netease.protobuf.WriteUtils.write$TYPE_DOUBLE(output, this.ltvMin);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_64_BIT, 9);
			com.netease.protobuf.WriteUtils.write$TYPE_DOUBLE(output, this.ltvMax);
			if (hasTimeoutOnHide) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 11);
				com.netease.protobuf.WriteUtils.write$TYPE_INT64(output, timeout_on_hide$field);
			}
			if (hasTimeoutOnPurchase) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 12);
				com.netease.protobuf.WriteUtils.write$TYPE_INT64(output, timeout_on_purchase$field);
			}
			for (var items$index:uint = 0; items$index < this.items.length; ++items$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 13);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.items[items$index]);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 18);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.percentBadgeColor);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 19);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.badgeColor);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 20);
			com.netease.protobuf.WriteUtils.write$TYPE_INT64(output, this.priceTextColor);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 21);
			com.netease.protobuf.WriteUtils.write$TYPE_INT64(output, this.priceTextBorderColor);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 22);
			com.netease.protobuf.WriteUtils.write$TYPE_INT64(output, this.percentTextColor);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var name$count:uint = 0;
			var facebook_item_id$count:uint = 0;
			var amazon_item_id$count:uint = 0;
			var ios_item_id$count:uint = 0;
			var android_item_id$count:uint = 0;
			var title$count:uint = 0;
			var price$count:uint = 0;
			var price_with_sale$count:uint = 0;
			var sale_percents$count:uint = 0;
			var trigger$count:uint = 0;
			var enabled$count:uint = 0;
			var ltv_min$count:uint = 0;
			var ltv_max$count:uint = 0;
			var timeout_on_hide$count:uint = 0;
			var timeout_on_purchase$count:uint = 0;
			var percent_badge_color$count:uint = 0;
			var badge_color$count:uint = 0;
			var price_text_color$count:uint = 0;
			var price_text_border_color$count:uint = 0;
			var percent_text_color$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomOfferMessage.name cannot be set twice.');
					}
					++name$count;
					this.name = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 14:
					if (facebook_item_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomOfferMessage.facebookItemId cannot be set twice.');
					}
					++facebook_item_id$count;
					this.facebookItemId = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 15:
					if (amazon_item_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomOfferMessage.amazonItemId cannot be set twice.');
					}
					++amazon_item_id$count;
					this.amazonItemId = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 16:
					if (ios_item_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomOfferMessage.iosItemId cannot be set twice.');
					}
					++ios_item_id$count;
					this.iosItemId = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 17:
					if (android_item_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomOfferMessage.androidItemId cannot be set twice.');
					}
					++android_item_id$count;
					this.androidItemId = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 2:
					if (title$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomOfferMessage.title cannot be set twice.');
					}
					++title$count;
					this.title = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (price$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomOfferMessage.price cannot be set twice.');
					}
					++price$count;
					this.price = com.netease.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 4:
					if (price_with_sale$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomOfferMessage.priceWithSale cannot be set twice.');
					}
					++price_with_sale$count;
					this.priceWithSale = com.netease.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 5:
					if (sale_percents$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomOfferMessage.salePercents cannot be set twice.');
					}
					++sale_percents$count;
					this.salePercents = com.netease.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 6:
					if (trigger$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomOfferMessage.trigger cannot be set twice.');
					}
					++trigger$count;
					this.trigger = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 7:
					if (enabled$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomOfferMessage.enabled cannot be set twice.');
					}
					++enabled$count;
					this.enabled = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 8:
					if (ltv_min$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomOfferMessage.ltvMin cannot be set twice.');
					}
					++ltv_min$count;
					this.ltvMin = com.netease.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 9:
					if (ltv_max$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomOfferMessage.ltvMax cannot be set twice.');
					}
					++ltv_max$count;
					this.ltvMax = com.netease.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 11:
					if (timeout_on_hide$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomOfferMessage.timeoutOnHide cannot be set twice.');
					}
					++timeout_on_hide$count;
					this.timeoutOnHide = com.netease.protobuf.ReadUtils.read$TYPE_INT64(input);
					break;
				case 12:
					if (timeout_on_purchase$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomOfferMessage.timeoutOnPurchase cannot be set twice.');
					}
					++timeout_on_purchase$count;
					this.timeoutOnPurchase = com.netease.protobuf.ReadUtils.read$TYPE_INT64(input);
					break;
				case 13:
					this.items.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.CommodityItemMessage()));
					break;
				case 18:
					if (percent_badge_color$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomOfferMessage.percentBadgeColor cannot be set twice.');
					}
					++percent_badge_color$count;
					this.percentBadgeColor = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 19:
					if (badge_color$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomOfferMessage.badgeColor cannot be set twice.');
					}
					++badge_color$count;
					this.badgeColor = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 20:
					if (price_text_color$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomOfferMessage.priceTextColor cannot be set twice.');
					}
					++price_text_color$count;
					this.priceTextColor = com.netease.protobuf.ReadUtils.read$TYPE_INT64(input);
					break;
				case 21:
					if (price_text_border_color$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomOfferMessage.priceTextBorderColor cannot be set twice.');
					}
					++price_text_border_color$count;
					this.priceTextBorderColor = com.netease.protobuf.ReadUtils.read$TYPE_INT64(input);
					break;
				case 22:
					if (percent_text_color$count != 0) {
						throw new flash.errors.IOError('Bad data format: CustomOfferMessage.percentTextColor cannot be set twice.');
					}
					++percent_text_color$count;
					this.percentTextColor = com.netease.protobuf.ReadUtils.read$TYPE_INT64(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
