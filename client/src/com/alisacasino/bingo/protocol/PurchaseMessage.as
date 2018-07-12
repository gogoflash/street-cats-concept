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
	public dynamic final class PurchaseMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ITEM_ID:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.PurchaseMessage.item_id", "itemId", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var itemId:String;

		/**
		 *  @private
		 */
		public static const VALUE:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.PurchaseMessage.value", "value", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var value:uint;

		/**
		 *  @private
		 */
		public static const GOOGLE_PLAY_JSON_DATA:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.PurchaseMessage.google_play_json_data", "googlePlayJsonData", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var google_play_json_data$field:String;

		public function clearGooglePlayJsonData():void {
			google_play_json_data$field = null;
		}

		public function get hasGooglePlayJsonData():Boolean {
			return google_play_json_data$field != null;
		}

		public function set googlePlayJsonData(value:String):void {
			google_play_json_data$field = value;
		}

		public function get googlePlayJsonData():String {
			return google_play_json_data$field;
		}

		/**
		 *  @private
		 */
		public static const GOOGLE_PLAY_SIGNATURE:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.PurchaseMessage.google_play_signature", "googlePlaySignature", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var google_play_signature$field:String;

		public function clearGooglePlaySignature():void {
			google_play_signature$field = null;
		}

		public function get hasGooglePlaySignature():Boolean {
			return google_play_signature$field != null;
		}

		public function set googlePlaySignature(value:String):void {
			google_play_signature$field = value;
		}

		public function get googlePlaySignature():String {
			return google_play_signature$field;
		}

		/**
		 *  @private
		 */
		public static const AMAZON_USER_ID:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.PurchaseMessage.amazon_user_id", "amazonUserId", (5 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var amazon_user_id$field:String;

		public function clearAmazonUserId():void {
			amazon_user_id$field = null;
		}

		public function get hasAmazonUserId():Boolean {
			return amazon_user_id$field != null;
		}

		public function set amazonUserId(value:String):void {
			amazon_user_id$field = value;
		}

		public function get amazonUserId():String {
			return amazon_user_id$field;
		}

		/**
		 *  @private
		 */
		public static const AMAZON_PURCHASE_TOKEN:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.PurchaseMessage.amazon_purchase_token", "amazonPurchaseToken", (6 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var amazon_purchase_token$field:String;

		public function clearAmazonPurchaseToken():void {
			amazon_purchase_token$field = null;
		}

		public function get hasAmazonPurchaseToken():Boolean {
			return amazon_purchase_token$field != null;
		}

		public function set amazonPurchaseToken(value:String):void {
			amazon_purchase_token$field = value;
		}

		public function get amazonPurchaseToken():String {
			return amazon_purchase_token$field;
		}

		/**
		 *  @private
		 */
		public static const IOS_RECEIPT:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.PurchaseMessage.ios_receipt", "iosReceipt", (7 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var ios_receipt$field:String;

		public function clearIosReceipt():void {
			ios_receipt$field = null;
		}

		public function get hasIosReceipt():Boolean {
			return ios_receipt$field != null;
		}

		public function set iosReceipt(value:String):void {
			ios_receipt$field = value;
		}

		public function get iosReceipt():String {
			return ios_receipt$field;
		}

		/**
		 *  @private
		 */
		public static const FACEBOOK_PAYMENT_ID:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.PurchaseMessage.facebook_payment_id", "facebookPaymentId", (8 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var facebook_payment_id$field:String;

		public function clearFacebookPaymentId():void {
			facebook_payment_id$field = null;
		}

		public function get hasFacebookPaymentId():Boolean {
			return facebook_payment_id$field != null;
		}

		public function set facebookPaymentId(value:String):void {
			facebook_payment_id$field = value;
		}

		public function get facebookPaymentId():String {
			return facebook_payment_id$field;
		}

		/**
		 *  @private
		 */
		public static const AMAZON_RECEIPT_ID:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.PurchaseMessage.amazon_receipt_id", "amazonReceiptId", (9 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var amazon_receipt_id$field:String;

		public function clearAmazonReceiptId():void {
			amazon_receipt_id$field = null;
		}

		public function get hasAmazonReceiptId():Boolean {
			return amazon_receipt_id$field != null;
		}

		public function set amazonReceiptId(value:String):void {
			amazon_receipt_id$field = value;
		}

		public function get amazonReceiptId():String {
			return amazon_receipt_id$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.itemId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.value);
			if (hasGooglePlayJsonData) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, google_play_json_data$field);
			}
			if (hasGooglePlaySignature) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, google_play_signature$field);
			}
			if (hasAmazonUserId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, amazon_user_id$field);
			}
			if (hasAmazonPurchaseToken) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, amazon_purchase_token$field);
			}
			if (hasIosReceipt) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, ios_receipt$field);
			}
			if (hasFacebookPaymentId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, facebook_payment_id$field);
			}
			if (hasAmazonReceiptId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 9);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, amazon_receipt_id$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var item_id$count:uint = 0;
			var value$count:uint = 0;
			var google_play_json_data$count:uint = 0;
			var google_play_signature$count:uint = 0;
			var amazon_user_id$count:uint = 0;
			var amazon_purchase_token$count:uint = 0;
			var ios_receipt$count:uint = 0;
			var facebook_payment_id$count:uint = 0;
			var amazon_receipt_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (item_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: PurchaseMessage.itemId cannot be set twice.');
					}
					++item_id$count;
					this.itemId = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 2:
					if (value$count != 0) {
						throw new flash.errors.IOError('Bad data format: PurchaseMessage.value cannot be set twice.');
					}
					++value$count;
					this.value = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (google_play_json_data$count != 0) {
						throw new flash.errors.IOError('Bad data format: PurchaseMessage.googlePlayJsonData cannot be set twice.');
					}
					++google_play_json_data$count;
					this.googlePlayJsonData = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (google_play_signature$count != 0) {
						throw new flash.errors.IOError('Bad data format: PurchaseMessage.googlePlaySignature cannot be set twice.');
					}
					++google_play_signature$count;
					this.googlePlaySignature = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 5:
					if (amazon_user_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: PurchaseMessage.amazonUserId cannot be set twice.');
					}
					++amazon_user_id$count;
					this.amazonUserId = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 6:
					if (amazon_purchase_token$count != 0) {
						throw new flash.errors.IOError('Bad data format: PurchaseMessage.amazonPurchaseToken cannot be set twice.');
					}
					++amazon_purchase_token$count;
					this.amazonPurchaseToken = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 7:
					if (ios_receipt$count != 0) {
						throw new flash.errors.IOError('Bad data format: PurchaseMessage.iosReceipt cannot be set twice.');
					}
					++ios_receipt$count;
					this.iosReceipt = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 8:
					if (facebook_payment_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: PurchaseMessage.facebookPaymentId cannot be set twice.');
					}
					++facebook_payment_id$count;
					this.facebookPaymentId = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 9:
					if (amazon_receipt_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: PurchaseMessage.amazonReceiptId cannot be set twice.');
					}
					++amazon_receipt_id$count;
					this.amazonReceiptId = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
