package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.SignInMessage.Platform;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SignInMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const PLAYER_ID:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.SignInMessage.player_id", "playerId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var player_id$field:UInt64;

		public function clearPlayerId():void {
			player_id$field = null;
		}

		public function get hasPlayerId():Boolean {
			return player_id$field != null;
		}

		public function set playerId(value:UInt64):void {
			player_id$field = value;
		}

		public function get playerId():UInt64 {
			return player_id$field;
		}

		/**
		 *  @private
		 */
		public static const PWD_HASH:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.SignInMessage.pwd_hash", "pwdHash", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var pwd_hash$field:String;

		public function clearPwdHash():void {
			pwd_hash$field = null;
		}

		public function get hasPwdHash():Boolean {
			return pwd_hash$field != null;
		}

		public function set pwdHash(value:String):void {
			pwd_hash$field = value;
		}

		public function get pwdHash():String {
			return pwd_hash$field;
		}

		/**
		 *  @private
		 */
		public static const ACCESS_TOKEN:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.SignInMessage.access_token", "accessToken", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var access_token$field:String;

		public function clearAccessToken():void {
			access_token$field = null;
		}

		public function get hasAccessToken():Boolean {
			return access_token$field != null;
		}

		public function set accessToken(value:String):void {
			access_token$field = value;
		}

		public function get accessToken():String {
			return access_token$field;
		}

		/**
		 *  @private
		 */
		public static const PLATFORM:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.alisacasino.bingo.protocol.SignInMessage.platform", "platform", (5 << 3) | com.netease.protobuf.WireType.VARINT, com.alisacasino.bingo.protocol.SignInMessage.Platform);

		public var platform:int;

		/**
		 *  @private
		 */
		public static const DEVICE_ID:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.SignInMessage.device_id", "deviceId", (6 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var device_id$field:String;

		public function clearDeviceId():void {
			device_id$field = null;
		}

		public function get hasDeviceId():Boolean {
			return device_id$field != null;
		}

		public function set deviceId(value:String):void {
			device_id$field = value;
		}

		public function get deviceId():String {
			return device_id$field;
		}

		/**
		 *  @private
		 */
		public static const TRACKING_DATA:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.SignInMessage.tracking_data", "trackingData", (7 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var tracking_data$field:String;

		public function clearTrackingData():void {
			tracking_data$field = null;
		}

		public function get hasTrackingData():Boolean {
			return tracking_data$field != null;
		}

		public function set trackingData(value:String):void {
			tracking_data$field = value;
		}

		public function get trackingData():String {
			return tracking_data$field;
		}

		/**
		 *  @private
		 */
		public static const FACEBOOK_ID_STRING:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.SignInMessage.facebook_id_string", "facebookIdString", (8 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var facebook_id_string$field:String;

		public function clearFacebookIdString():void {
			facebook_id_string$field = null;
		}

		public function get hasFacebookIdString():Boolean {
			return facebook_id_string$field != null;
		}

		public function set facebookIdString(value:String):void {
			facebook_id_string$field = value;
		}

		public function get facebookIdString():String {
			return facebook_id_string$field;
		}

		/**
		 *  @private
		 */
		public static const SESSION_ID:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.SignInMessage.session_id", "sessionId", (9 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var session_id$field:String;

		public function clearSessionId():void {
			session_id$field = null;
		}

		public function get hasSessionId():Boolean {
			return session_id$field != null;
		}

		public function set sessionId(value:String):void {
			session_id$field = value;
		}

		public function get sessionId():String {
			return session_id$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasPlayerId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, player_id$field);
			}
			if (hasPwdHash) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, pwd_hash$field);
			}
			if (hasAccessToken) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, access_token$field);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.platform);
			if (hasDeviceId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, device_id$field);
			}
			if (hasTrackingData) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, tracking_data$field);
			}
			if (hasFacebookIdString) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, facebook_id_string$field);
			}
			if (hasSessionId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 9);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, session_id$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var player_id$count:uint = 0;
			var pwd_hash$count:uint = 0;
			var access_token$count:uint = 0;
			var platform$count:uint = 0;
			var device_id$count:uint = 0;
			var tracking_data$count:uint = 0;
			var facebook_id_string$count:uint = 0;
			var session_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (player_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SignInMessage.playerId cannot be set twice.');
					}
					++player_id$count;
					this.playerId = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 2:
					if (pwd_hash$count != 0) {
						throw new flash.errors.IOError('Bad data format: SignInMessage.pwdHash cannot be set twice.');
					}
					++pwd_hash$count;
					this.pwdHash = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (access_token$count != 0) {
						throw new flash.errors.IOError('Bad data format: SignInMessage.accessToken cannot be set twice.');
					}
					++access_token$count;
					this.accessToken = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 5:
					if (platform$count != 0) {
						throw new flash.errors.IOError('Bad data format: SignInMessage.platform cannot be set twice.');
					}
					++platform$count;
					this.platform = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 6:
					if (device_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SignInMessage.deviceId cannot be set twice.');
					}
					++device_id$count;
					this.deviceId = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 7:
					if (tracking_data$count != 0) {
						throw new flash.errors.IOError('Bad data format: SignInMessage.trackingData cannot be set twice.');
					}
					++tracking_data$count;
					this.trackingData = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 8:
					if (facebook_id_string$count != 0) {
						throw new flash.errors.IOError('Bad data format: SignInMessage.facebookIdString cannot be set twice.');
					}
					++facebook_id_string$count;
					this.facebookIdString = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 9:
					if (session_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SignInMessage.sessionId cannot be set twice.');
					}
					++session_id$count;
					this.sessionId = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
