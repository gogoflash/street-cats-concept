package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.RoomTypeMessage;
	import com.alisacasino.bingo.protocol.TournamentResultMessage;
	import flash.utils.ByteArray;
	import com.alisacasino.bingo.protocol.InvitedPlayerMessage;
	import com.alisacasino.bingo.protocol.GiftedPlayerMessage;
	import com.alisacasino.bingo.protocol.LobbyDataMessage;
	import com.alisacasino.bingo.protocol.CollectionInfoOkMessage;
	import com.alisacasino.bingo.protocol.StaticDataMessage;
	import com.alisacasino.bingo.protocol.PlayerMessage;
	import com.alisacasino.bingo.protocol.LiveEventInfoOkMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SignInOkMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const PLAYER:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SignInOkMessage.player", "player", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PlayerMessage; });

		public var player:com.alisacasino.bingo.protocol.PlayerMessage;

		/**
		 *  @private
		 */
		public static const ROOM_TYPES:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SignInOkMessage.room_types", "roomTypes", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.RoomTypeMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.RoomTypeMessage")]
		public var roomTypes:Array = [];

		/**
		 *  @private
		 */
		public static const INVITED_PLAYERS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SignInOkMessage.invited_players", "invitedPlayers", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.InvitedPlayerMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.InvitedPlayerMessage")]
		public var invitedPlayers:Array = [];

		/**
		 *  @private
		 */
		public static const GIFTED_PLAYERS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SignInOkMessage.gifted_players", "giftedPlayers", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.GiftedPlayerMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.GiftedPlayerMessage")]
		public var giftedPlayers:Array = [];

		/**
		 *  @private
		 */
		public static const LAST_ACCEPTED_GIFTS_TIMESTAMPS:RepeatedFieldDescriptor$TYPE_UINT64 = new RepeatedFieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.SignInOkMessage.last_accepted_gifts_timestamps", "lastAcceptedGiftsTimestamps", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		[ArrayElementType("UInt64")]
		public var lastAcceptedGiftsTimestamps:Array = [];

		/**
		 *  @private
		 */
		public static const IS_REFUNDED:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.alisacasino.bingo.protocol.SignInOkMessage.is_refunded", "isRefunded", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		private var is_refunded$field:Boolean;

		private var hasField$0:uint = 0;

		public function clearIsRefunded():void {
			hasField$0 &= 0xfffffffe;
			is_refunded$field = new Boolean();
		}

		public function get hasIsRefunded():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set isRefunded(value:Boolean):void {
			hasField$0 |= 0x1;
			is_refunded$field = value;
		}

		public function get isRefunded():Boolean {
			return is_refunded$field;
		}

		/**
		 *  @private
		 */
		public static const FULL_QUEUE_FACEBOOK_IDS_STRING:RepeatedFieldDescriptor$TYPE_STRING = new RepeatedFieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.SignInOkMessage.full_queue_facebook_ids_string", "fullQueueFacebookIdsString", (8 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		[ArrayElementType("String")]
		public var fullQueueFacebookIdsString:Array = [];

		/**
		 *  @private
		 */
		public static const LOBBY_LIST_DATA:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SignInOkMessage.lobby_list_data", "lobbyListData", (9 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.LobbyDataMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.LobbyDataMessage")]
		public var lobbyListData:Array = [];

		/**
		 *  @private
		 */
		public static const CLIENT_DATA:FieldDescriptor$TYPE_BYTES = new FieldDescriptor$TYPE_BYTES("com.alisacasino.bingo.protocol.SignInOkMessage.client_data", "clientData", (10 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var client_data$field:flash.utils.ByteArray;

		public function clearClientData():void {
			client_data$field = null;
		}

		public function get hasClientData():Boolean {
			return client_data$field != null;
		}

		public function set clientData(value:flash.utils.ByteArray):void {
			client_data$field = value;
		}

		public function get clientData():flash.utils.ByteArray {
			return client_data$field;
		}

		/**
		 *  @private
		 */
		public static const STATIC_DATA:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SignInOkMessage.static_data", "staticData", (11 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.StaticDataMessage; });

		public var staticData:com.alisacasino.bingo.protocol.StaticDataMessage;

		/**
		 *  @private
		 */
		public static const COLLECTION_INFO:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SignInOkMessage.collection_info", "collectionInfo", (12 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.CollectionInfoOkMessage; });

		public var collectionInfo:com.alisacasino.bingo.protocol.CollectionInfoOkMessage;

		/**
		 *  @private
		 */
		public static const TOURNAMENT_INFO:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SignInOkMessage.tournament_info", "tournamentInfo", (13 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.LiveEventInfoOkMessage; });

		public var tournamentInfo:com.alisacasino.bingo.protocol.LiveEventInfoOkMessage;

		/**
		 *  @private
		 */
		public static const TOURNAMENT_RESULT:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SignInOkMessage.tournament_result", "tournamentResult", (14 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.TournamentResultMessage; });

		private var tournament_result$field:com.alisacasino.bingo.protocol.TournamentResultMessage;

		public function clearTournamentResult():void {
			tournament_result$field = null;
		}

		public function get hasTournamentResult():Boolean {
			return tournament_result$field != null;
		}

		public function set tournamentResult(value:com.alisacasino.bingo.protocol.TournamentResultMessage):void {
			tournament_result$field = value;
		}

		public function get tournamentResult():com.alisacasino.bingo.protocol.TournamentResultMessage {
			return tournament_result$field;
		}

		/**
		 *  @private
		 */
		public static const IS_FIRST_SIGNIN:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.alisacasino.bingo.protocol.SignInOkMessage.is_first_signin", "isFirstSignin", (15 << 3) | com.netease.protobuf.WireType.VARINT);

		private var is_first_signin$field:Boolean;

		public function clearIsFirstSignin():void {
			hasField$0 &= 0xfffffffd;
			is_first_signin$field = new Boolean();
		}

		public function get hasIsFirstSignin():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set isFirstSignin(value:Boolean):void {
			hasField$0 |= 0x2;
			is_first_signin$field = value;
		}

		public function get isFirstSignin():Boolean {
			return is_first_signin$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.player);
			for (var roomTypes$index:uint = 0; roomTypes$index < this.roomTypes.length; ++roomTypes$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.roomTypes[roomTypes$index]);
			}
			for (var invitedPlayers$index:uint = 0; invitedPlayers$index < this.invitedPlayers.length; ++invitedPlayers$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.invitedPlayers[invitedPlayers$index]);
			}
			for (var giftedPlayers$index:uint = 0; giftedPlayers$index < this.giftedPlayers.length; ++giftedPlayers$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.giftedPlayers[giftedPlayers$index]);
			}
			for (var lastAcceptedGiftsTimestamps$index:uint = 0; lastAcceptedGiftsTimestamps$index < this.lastAcceptedGiftsTimestamps.length; ++lastAcceptedGiftsTimestamps$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, this.lastAcceptedGiftsTimestamps[lastAcceptedGiftsTimestamps$index]);
			}
			if (hasIsRefunded) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, is_refunded$field);
			}
			for (var fullQueueFacebookIdsString$index:uint = 0; fullQueueFacebookIdsString$index < this.fullQueueFacebookIdsString.length; ++fullQueueFacebookIdsString$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.fullQueueFacebookIdsString[fullQueueFacebookIdsString$index]);
			}
			for (var lobbyListData$index:uint = 0; lobbyListData$index < this.lobbyListData.length; ++lobbyListData$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 9);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.lobbyListData[lobbyListData$index]);
			}
			if (hasClientData) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 10);
				com.netease.protobuf.WriteUtils.write$TYPE_BYTES(output, client_data$field);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 11);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.staticData);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 12);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.collectionInfo);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 13);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.tournamentInfo);
			if (hasTournamentResult) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 14);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, tournament_result$field);
			}
			if (hasIsFirstSignin) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 15);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, is_first_signin$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var player$count:uint = 0;
			var is_refunded$count:uint = 0;
			var client_data$count:uint = 0;
			var static_data$count:uint = 0;
			var collection_info$count:uint = 0;
			var tournament_info$count:uint = 0;
			var tournament_result$count:uint = 0;
			var is_first_signin$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (player$count != 0) {
						throw new flash.errors.IOError('Bad data format: SignInOkMessage.player cannot be set twice.');
					}
					++player$count;
					this.player = new com.alisacasino.bingo.protocol.PlayerMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.player);
					break;
				case 2:
					this.roomTypes.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.RoomTypeMessage()));
					break;
				case 3:
					this.invitedPlayers.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.InvitedPlayerMessage()));
					break;
				case 4:
					this.giftedPlayers.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.GiftedPlayerMessage()));
					break;
				case 6:
					if ((tag & 7) == com.netease.protobuf.WireType.LENGTH_DELIMITED) {
						com.netease.protobuf.ReadUtils.readPackedRepeated(input, com.netease.protobuf.ReadUtils.read$TYPE_UINT64, this.lastAcceptedGiftsTimestamps);
						break;
					}
					this.lastAcceptedGiftsTimestamps.push(com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input));
					break;
				case 7:
					if (is_refunded$count != 0) {
						throw new flash.errors.IOError('Bad data format: SignInOkMessage.isRefunded cannot be set twice.');
					}
					++is_refunded$count;
					this.isRefunded = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 8:
					this.fullQueueFacebookIdsString.push(com.netease.protobuf.ReadUtils.read$TYPE_STRING(input));
					break;
				case 9:
					this.lobbyListData.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.LobbyDataMessage()));
					break;
				case 10:
					if (client_data$count != 0) {
						throw new flash.errors.IOError('Bad data format: SignInOkMessage.clientData cannot be set twice.');
					}
					++client_data$count;
					this.clientData = com.netease.protobuf.ReadUtils.read$TYPE_BYTES(input);
					break;
				case 11:
					if (static_data$count != 0) {
						throw new flash.errors.IOError('Bad data format: SignInOkMessage.staticData cannot be set twice.');
					}
					++static_data$count;
					this.staticData = new com.alisacasino.bingo.protocol.StaticDataMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.staticData);
					break;
				case 12:
					if (collection_info$count != 0) {
						throw new flash.errors.IOError('Bad data format: SignInOkMessage.collectionInfo cannot be set twice.');
					}
					++collection_info$count;
					this.collectionInfo = new com.alisacasino.bingo.protocol.CollectionInfoOkMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.collectionInfo);
					break;
				case 13:
					if (tournament_info$count != 0) {
						throw new flash.errors.IOError('Bad data format: SignInOkMessage.tournamentInfo cannot be set twice.');
					}
					++tournament_info$count;
					this.tournamentInfo = new com.alisacasino.bingo.protocol.LiveEventInfoOkMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.tournamentInfo);
					break;
				case 14:
					if (tournament_result$count != 0) {
						throw new flash.errors.IOError('Bad data format: SignInOkMessage.tournamentResult cannot be set twice.');
					}
					++tournament_result$count;
					this.tournamentResult = new com.alisacasino.bingo.protocol.TournamentResultMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.tournamentResult);
					break;
				case 15:
					if (is_first_signin$count != 0) {
						throw new flash.errors.IOError('Bad data format: SignInOkMessage.isFirstSignin cannot be set twice.');
					}
					++is_first_signin$count;
					this.isFirstSignin = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
