package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.BuyCardsOkMessage;
	import com.alisacasino.bingo.protocol.PlayerBoughtCardsMessage;
	import com.alisacasino.bingo.protocol.RequestServerStatusMessage;
	import com.alisacasino.bingo.protocol.SignInMessage;
	import com.alisacasino.bingo.protocol.SelfTestMessage.InternalEvent;
	import com.alisacasino.bingo.protocol.BingoMessage;
	import com.alisacasino.bingo.protocol.SignInOkMessage;
	import com.alisacasino.bingo.protocol.PlayerBingoedMessage;
	import com.alisacasino.bingo.protocol.RoundOverMessage;
	import com.alisacasino.bingo.protocol.PlayerUpdateMessage;
	import com.alisacasino.bingo.protocol.BadBingoMessage;
	import com.alisacasino.bingo.protocol.JoinMessage;
	import com.alisacasino.bingo.protocol.LeaveMessage;
	import com.alisacasino.bingo.protocol.PlayerUpdateOkMessage;
	import com.alisacasino.bingo.protocol.ErrorMessage;
	import com.alisacasino.bingo.protocol.LeaveOkMessage;
	import com.alisacasino.bingo.protocol.ServerStatusMessage;
	import com.alisacasino.bingo.protocol.RoundStartedMessage;
	import com.alisacasino.bingo.protocol.JoinOkMessage;
	import com.alisacasino.bingo.protocol.BuyCardsMessage;
	import com.alisacasino.bingo.protocol.BallMessage;
	import com.alisacasino.bingo.protocol.BingoOkMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SelfTestMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ROOM_ID:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.SelfTestMessage.room_id", "roomId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var room_id$field:uint;

		private var hasField$0:uint = 0;

		public function clearRoomId():void {
			hasField$0 &= 0xfffffffe;
			room_id$field = new uint();
		}

		public function get hasRoomId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set roomId(value:uint):void {
			hasField$0 |= 0x1;
			room_id$field = value;
		}

		public function get roomId():uint {
			return room_id$field;
		}

		/**
		 *  @private
		 */
		public static const ROOM_TIER:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.SelfTestMessage.room_tier", "roomTier", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var room_tier$field:uint;

		public function clearRoomTier():void {
			hasField$0 &= 0xfffffffd;
			room_tier$field = new uint();
		}

		public function get hasRoomTier():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set roomTier(value:uint):void {
			hasField$0 |= 0x2;
			room_tier$field = value;
		}

		public function get roomTier():uint {
			return room_tier$field;
		}

		/**
		 *  @private
		 */
		public static const ROOM_TYPE_NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.SelfTestMessage.room_type_name", "roomTypeName", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var room_type_name$field:String;

		public function clearRoomTypeName():void {
			room_type_name$field = null;
		}

		public function get hasRoomTypeName():Boolean {
			return room_type_name$field != null;
		}

		public function set roomTypeName(value:String):void {
			room_type_name$field = value;
		}

		public function get roomTypeName():String {
			return room_type_name$field;
		}

		/**
		 *  @private
		 */
		public static const PLAYER_ID:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.SelfTestMessage.player_id", "playerId", (4 << 3) | com.netease.protobuf.WireType.VARINT);

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
		public static const TIMESTAMP:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.SelfTestMessage.timestamp", "timestamp", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var timestamp$field:UInt64;

		public function clearTimestamp():void {
			timestamp$field = null;
		}

		public function get hasTimestamp():Boolean {
			return timestamp$field != null;
		}

		public function set timestamp(value:UInt64):void {
			timestamp$field = value;
		}

		public function get timestamp():UInt64 {
			return timestamp$field;
		}

		/**
		 *  @private
		 */
		public static const INTERNAL_EVENT:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.alisacasino.bingo.protocol.SelfTestMessage.internal_event", "internalEvent", (6 << 3) | com.netease.protobuf.WireType.VARINT, com.alisacasino.bingo.protocol.SelfTestMessage.InternalEvent);

		private var internal_event$field:int;

		public function clearInternalEvent():void {
			hasField$0 &= 0xfffffffb;
			internal_event$field = new int();
		}

		public function get hasInternalEvent():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set internalEvent(value:int):void {
			hasField$0 |= 0x4;
			internal_event$field = value;
		}

		public function get internalEvent():int {
			return internal_event$field;
		}

		/**
		 *  @private
		 */
		public static const SIGN_IN_OK_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SelfTestMessage.sign_in_ok_message", "signInOkMessage", (7 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.SignInOkMessage; });

		private var sign_in_ok_message$field:com.alisacasino.bingo.protocol.SignInOkMessage;

		public function clearSignInOkMessage():void {
			sign_in_ok_message$field = null;
		}

		public function get hasSignInOkMessage():Boolean {
			return sign_in_ok_message$field != null;
		}

		public function set signInOkMessage(value:com.alisacasino.bingo.protocol.SignInOkMessage):void {
			sign_in_ok_message$field = value;
		}

		public function get signInOkMessage():com.alisacasino.bingo.protocol.SignInOkMessage {
			return sign_in_ok_message$field;
		}

		/**
		 *  @private
		 */
		public static const BUY_CARDS_OK_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SelfTestMessage.buy_cards_ok_message", "buyCardsOkMessage", (8 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.BuyCardsOkMessage; });

		private var buy_cards_ok_message$field:com.alisacasino.bingo.protocol.BuyCardsOkMessage;

		public function clearBuyCardsOkMessage():void {
			buy_cards_ok_message$field = null;
		}

		public function get hasBuyCardsOkMessage():Boolean {
			return buy_cards_ok_message$field != null;
		}

		public function set buyCardsOkMessage(value:com.alisacasino.bingo.protocol.BuyCardsOkMessage):void {
			buy_cards_ok_message$field = value;
		}

		public function get buyCardsOkMessage():com.alisacasino.bingo.protocol.BuyCardsOkMessage {
			return buy_cards_ok_message$field;
		}

		/**
		 *  @private
		 */
		public static const ROUND_STARTED_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SelfTestMessage.round_started_message", "roundStartedMessage", (9 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.RoundStartedMessage; });

		private var round_started_message$field:com.alisacasino.bingo.protocol.RoundStartedMessage;

		public function clearRoundStartedMessage():void {
			round_started_message$field = null;
		}

		public function get hasRoundStartedMessage():Boolean {
			return round_started_message$field != null;
		}

		public function set roundStartedMessage(value:com.alisacasino.bingo.protocol.RoundStartedMessage):void {
			round_started_message$field = value;
		}

		public function get roundStartedMessage():com.alisacasino.bingo.protocol.RoundStartedMessage {
			return round_started_message$field;
		}

		/**
		 *  @private
		 */
		public static const BALL_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SelfTestMessage.ball_message", "ballMessage", (10 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.BallMessage; });

		private var ball_message$field:com.alisacasino.bingo.protocol.BallMessage;

		public function clearBallMessage():void {
			ball_message$field = null;
		}

		public function get hasBallMessage():Boolean {
			return ball_message$field != null;
		}

		public function set ballMessage(value:com.alisacasino.bingo.protocol.BallMessage):void {
			ball_message$field = value;
		}

		public function get ballMessage():com.alisacasino.bingo.protocol.BallMessage {
			return ball_message$field;
		}

		/**
		 *  @private
		 */
		public static const BINGO_OK_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SelfTestMessage.bingo_ok_message", "bingoOkMessage", (11 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.BingoOkMessage; });

		private var bingo_ok_message$field:com.alisacasino.bingo.protocol.BingoOkMessage;

		public function clearBingoOkMessage():void {
			bingo_ok_message$field = null;
		}

		public function get hasBingoOkMessage():Boolean {
			return bingo_ok_message$field != null;
		}

		public function set bingoOkMessage(value:com.alisacasino.bingo.protocol.BingoOkMessage):void {
			bingo_ok_message$field = value;
		}

		public function get bingoOkMessage():com.alisacasino.bingo.protocol.BingoOkMessage {
			return bingo_ok_message$field;
		}

		/**
		 *  @private
		 */
		public static const BAD_BINGO_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SelfTestMessage.bad_bingo_message", "badBingoMessage", (12 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.BadBingoMessage; });

		private var bad_bingo_message$field:com.alisacasino.bingo.protocol.BadBingoMessage;

		public function clearBadBingoMessage():void {
			bad_bingo_message$field = null;
		}

		public function get hasBadBingoMessage():Boolean {
			return bad_bingo_message$field != null;
		}

		public function set badBingoMessage(value:com.alisacasino.bingo.protocol.BadBingoMessage):void {
			bad_bingo_message$field = value;
		}

		public function get badBingoMessage():com.alisacasino.bingo.protocol.BadBingoMessage {
			return bad_bingo_message$field;
		}

		/**
		 *  @private
		 */
		public static const ROUND_OVER_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SelfTestMessage.round_over_message", "roundOverMessage", (13 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.RoundOverMessage; });

		private var round_over_message$field:com.alisacasino.bingo.protocol.RoundOverMessage;

		public function clearRoundOverMessage():void {
			round_over_message$field = null;
		}

		public function get hasRoundOverMessage():Boolean {
			return round_over_message$field != null;
		}

		public function set roundOverMessage(value:com.alisacasino.bingo.protocol.RoundOverMessage):void {
			round_over_message$field = value;
		}

		public function get roundOverMessage():com.alisacasino.bingo.protocol.RoundOverMessage {
			return round_over_message$field;
		}

		/**
		 *  @private
		 */
		public static const PLAYER_UPDATE_OK_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SelfTestMessage.player_update_ok_message", "playerUpdateOkMessage", (14 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PlayerUpdateOkMessage; });

		private var player_update_ok_message$field:com.alisacasino.bingo.protocol.PlayerUpdateOkMessage;

		public function clearPlayerUpdateOkMessage():void {
			player_update_ok_message$field = null;
		}

		public function get hasPlayerUpdateOkMessage():Boolean {
			return player_update_ok_message$field != null;
		}

		public function set playerUpdateOkMessage(value:com.alisacasino.bingo.protocol.PlayerUpdateOkMessage):void {
			player_update_ok_message$field = value;
		}

		public function get playerUpdateOkMessage():com.alisacasino.bingo.protocol.PlayerUpdateOkMessage {
			return player_update_ok_message$field;
		}

		/**
		 *  @private
		 */
		public static const ERROR_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SelfTestMessage.error_message", "errorMessage", (15 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.ErrorMessage; });

		private var error_message$field:com.alisacasino.bingo.protocol.ErrorMessage;

		public function clearErrorMessage():void {
			error_message$field = null;
		}

		public function get hasErrorMessage():Boolean {
			return error_message$field != null;
		}

		public function set errorMessage(value:com.alisacasino.bingo.protocol.ErrorMessage):void {
			error_message$field = value;
		}

		public function get errorMessage():com.alisacasino.bingo.protocol.ErrorMessage {
			return error_message$field;
		}

		/**
		 *  @private
		 */
		public static const BINGO_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SelfTestMessage.bingo_message", "bingoMessage", (16 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.BingoMessage; });

		private var bingo_message$field:com.alisacasino.bingo.protocol.BingoMessage;

		public function clearBingoMessage():void {
			bingo_message$field = null;
		}

		public function get hasBingoMessage():Boolean {
			return bingo_message$field != null;
		}

		public function set bingoMessage(value:com.alisacasino.bingo.protocol.BingoMessage):void {
			bingo_message$field = value;
		}

		public function get bingoMessage():com.alisacasino.bingo.protocol.BingoMessage {
			return bingo_message$field;
		}

		/**
		 *  @private
		 */
		public static const BUY_CARDS_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SelfTestMessage.buy_cards_message", "buyCardsMessage", (17 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.BuyCardsMessage; });

		private var buy_cards_message$field:com.alisacasino.bingo.protocol.BuyCardsMessage;

		public function clearBuyCardsMessage():void {
			buy_cards_message$field = null;
		}

		public function get hasBuyCardsMessage():Boolean {
			return buy_cards_message$field != null;
		}

		public function set buyCardsMessage(value:com.alisacasino.bingo.protocol.BuyCardsMessage):void {
			buy_cards_message$field = value;
		}

		public function get buyCardsMessage():com.alisacasino.bingo.protocol.BuyCardsMessage {
			return buy_cards_message$field;
		}

		/**
		 *  @private
		 */
		public static const JOIN_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SelfTestMessage.join_message", "joinMessage", (18 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.JoinMessage; });

		private var join_message$field:com.alisacasino.bingo.protocol.JoinMessage;

		public function clearJoinMessage():void {
			join_message$field = null;
		}

		public function get hasJoinMessage():Boolean {
			return join_message$field != null;
		}

		public function set joinMessage(value:com.alisacasino.bingo.protocol.JoinMessage):void {
			join_message$field = value;
		}

		public function get joinMessage():com.alisacasino.bingo.protocol.JoinMessage {
			return join_message$field;
		}

		/**
		 *  @private
		 */
		public static const LEAVE_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SelfTestMessage.leave_message", "leaveMessage", (19 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.LeaveMessage; });

		private var leave_message$field:com.alisacasino.bingo.protocol.LeaveMessage;

		public function clearLeaveMessage():void {
			leave_message$field = null;
		}

		public function get hasLeaveMessage():Boolean {
			return leave_message$field != null;
		}

		public function set leaveMessage(value:com.alisacasino.bingo.protocol.LeaveMessage):void {
			leave_message$field = value;
		}

		public function get leaveMessage():com.alisacasino.bingo.protocol.LeaveMessage {
			return leave_message$field;
		}

		/**
		 *  @private
		 */
		public static const PLAYER_UPDATE_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SelfTestMessage.player_update_message", "playerUpdateMessage", (20 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PlayerUpdateMessage; });

		private var player_update_message$field:com.alisacasino.bingo.protocol.PlayerUpdateMessage;

		public function clearPlayerUpdateMessage():void {
			player_update_message$field = null;
		}

		public function get hasPlayerUpdateMessage():Boolean {
			return player_update_message$field != null;
		}

		public function set playerUpdateMessage(value:com.alisacasino.bingo.protocol.PlayerUpdateMessage):void {
			player_update_message$field = value;
		}

		public function get playerUpdateMessage():com.alisacasino.bingo.protocol.PlayerUpdateMessage {
			return player_update_message$field;
		}

		/**
		 *  @private
		 */
		public static const REQUEST_SERVER_STATUS_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SelfTestMessage.request_server_status_message", "requestServerStatusMessage", (21 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.RequestServerStatusMessage; });

		private var request_server_status_message$field:com.alisacasino.bingo.protocol.RequestServerStatusMessage;

		public function clearRequestServerStatusMessage():void {
			request_server_status_message$field = null;
		}

		public function get hasRequestServerStatusMessage():Boolean {
			return request_server_status_message$field != null;
		}

		public function set requestServerStatusMessage(value:com.alisacasino.bingo.protocol.RequestServerStatusMessage):void {
			request_server_status_message$field = value;
		}

		public function get requestServerStatusMessage():com.alisacasino.bingo.protocol.RequestServerStatusMessage {
			return request_server_status_message$field;
		}

		/**
		 *  @private
		 */
		public static const SIGN_IN_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SelfTestMessage.sign_in_message", "signInMessage", (22 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.SignInMessage; });

		private var sign_in_message$field:com.alisacasino.bingo.protocol.SignInMessage;

		public function clearSignInMessage():void {
			sign_in_message$field = null;
		}

		public function get hasSignInMessage():Boolean {
			return sign_in_message$field != null;
		}

		public function set signInMessage(value:com.alisacasino.bingo.protocol.SignInMessage):void {
			sign_in_message$field = value;
		}

		public function get signInMessage():com.alisacasino.bingo.protocol.SignInMessage {
			return sign_in_message$field;
		}

		/**
		 *  @private
		 */
		public static const ID:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.SelfTestMessage.id", "id", (23 << 3) | com.netease.protobuf.WireType.VARINT);

		public var id:UInt64;

		/**
		 *  @private
		 */
		public static const JOIN_OK_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SelfTestMessage.join_ok_message", "joinOkMessage", (24 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.JoinOkMessage; });

		private var join_ok_message$field:com.alisacasino.bingo.protocol.JoinOkMessage;

		public function clearJoinOkMessage():void {
			join_ok_message$field = null;
		}

		public function get hasJoinOkMessage():Boolean {
			return join_ok_message$field != null;
		}

		public function set joinOkMessage(value:com.alisacasino.bingo.protocol.JoinOkMessage):void {
			join_ok_message$field = value;
		}

		public function get joinOkMessage():com.alisacasino.bingo.protocol.JoinOkMessage {
			return join_ok_message$field;
		}

		/**
		 *  @private
		 */
		public static const LEAVE_OK_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SelfTestMessage.leave_ok_message", "leaveOkMessage", (25 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.LeaveOkMessage; });

		private var leave_ok_message$field:com.alisacasino.bingo.protocol.LeaveOkMessage;

		public function clearLeaveOkMessage():void {
			leave_ok_message$field = null;
		}

		public function get hasLeaveOkMessage():Boolean {
			return leave_ok_message$field != null;
		}

		public function set leaveOkMessage(value:com.alisacasino.bingo.protocol.LeaveOkMessage):void {
			leave_ok_message$field = value;
		}

		public function get leaveOkMessage():com.alisacasino.bingo.protocol.LeaveOkMessage {
			return leave_ok_message$field;
		}

		/**
		 *  @private
		 */
		public static const PLAYER_BINGOED_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SelfTestMessage.player_bingoed_message", "playerBingoedMessage", (26 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PlayerBingoedMessage; });

		private var player_bingoed_message$field:com.alisacasino.bingo.protocol.PlayerBingoedMessage;

		public function clearPlayerBingoedMessage():void {
			player_bingoed_message$field = null;
		}

		public function get hasPlayerBingoedMessage():Boolean {
			return player_bingoed_message$field != null;
		}

		public function set playerBingoedMessage(value:com.alisacasino.bingo.protocol.PlayerBingoedMessage):void {
			player_bingoed_message$field = value;
		}

		public function get playerBingoedMessage():com.alisacasino.bingo.protocol.PlayerBingoedMessage {
			return player_bingoed_message$field;
		}

		/**
		 *  @private
		 */
		public static const PLAYER_BOUGHT_CARDS_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SelfTestMessage.player_bought_cards_message", "playerBoughtCardsMessage", (27 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PlayerBoughtCardsMessage; });

		private var player_bought_cards_message$field:com.alisacasino.bingo.protocol.PlayerBoughtCardsMessage;

		public function clearPlayerBoughtCardsMessage():void {
			player_bought_cards_message$field = null;
		}

		public function get hasPlayerBoughtCardsMessage():Boolean {
			return player_bought_cards_message$field != null;
		}

		public function set playerBoughtCardsMessage(value:com.alisacasino.bingo.protocol.PlayerBoughtCardsMessage):void {
			player_bought_cards_message$field = value;
		}

		public function get playerBoughtCardsMessage():com.alisacasino.bingo.protocol.PlayerBoughtCardsMessage {
			return player_bought_cards_message$field;
		}

		/**
		 *  @private
		 */
		public static const SERVER_STATUS_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.SelfTestMessage.server_status_message", "serverStatusMessage", (28 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.ServerStatusMessage; });

		private var server_status_message$field:com.alisacasino.bingo.protocol.ServerStatusMessage;

		public function clearServerStatusMessage():void {
			server_status_message$field = null;
		}

		public function get hasServerStatusMessage():Boolean {
			return server_status_message$field != null;
		}

		public function set serverStatusMessage(value:com.alisacasino.bingo.protocol.ServerStatusMessage):void {
			server_status_message$field = value;
		}

		public function get serverStatusMessage():com.alisacasino.bingo.protocol.ServerStatusMessage {
			return server_status_message$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasRoomId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, room_id$field);
			}
			if (hasRoomTier) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, room_tier$field);
			}
			if (hasRoomTypeName) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, room_type_name$field);
			}
			if (hasPlayerId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, player_id$field);
			}
			if (hasTimestamp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, timestamp$field);
			}
			if (hasInternalEvent) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, internal_event$field);
			}
			if (hasSignInOkMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, sign_in_ok_message$field);
			}
			if (hasBuyCardsOkMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, buy_cards_ok_message$field);
			}
			if (hasRoundStartedMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 9);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, round_started_message$field);
			}
			if (hasBallMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 10);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, ball_message$field);
			}
			if (hasBingoOkMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 11);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, bingo_ok_message$field);
			}
			if (hasBadBingoMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 12);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, bad_bingo_message$field);
			}
			if (hasRoundOverMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 13);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, round_over_message$field);
			}
			if (hasPlayerUpdateOkMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 14);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, player_update_ok_message$field);
			}
			if (hasErrorMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 15);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, error_message$field);
			}
			if (hasBingoMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 16);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, bingo_message$field);
			}
			if (hasBuyCardsMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 17);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, buy_cards_message$field);
			}
			if (hasJoinMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 18);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, join_message$field);
			}
			if (hasLeaveMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 19);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, leave_message$field);
			}
			if (hasPlayerUpdateMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 20);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, player_update_message$field);
			}
			if (hasRequestServerStatusMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 21);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, request_server_status_message$field);
			}
			if (hasSignInMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 22);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, sign_in_message$field);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 23);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, this.id);
			if (hasJoinOkMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 24);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, join_ok_message$field);
			}
			if (hasLeaveOkMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 25);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, leave_ok_message$field);
			}
			if (hasPlayerBingoedMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 26);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, player_bingoed_message$field);
			}
			if (hasPlayerBoughtCardsMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 27);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, player_bought_cards_message$field);
			}
			if (hasServerStatusMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 28);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, server_status_message$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var room_id$count:uint = 0;
			var room_tier$count:uint = 0;
			var room_type_name$count:uint = 0;
			var player_id$count:uint = 0;
			var timestamp$count:uint = 0;
			var internal_event$count:uint = 0;
			var sign_in_ok_message$count:uint = 0;
			var buy_cards_ok_message$count:uint = 0;
			var round_started_message$count:uint = 0;
			var ball_message$count:uint = 0;
			var bingo_ok_message$count:uint = 0;
			var bad_bingo_message$count:uint = 0;
			var round_over_message$count:uint = 0;
			var player_update_ok_message$count:uint = 0;
			var error_message$count:uint = 0;
			var bingo_message$count:uint = 0;
			var buy_cards_message$count:uint = 0;
			var join_message$count:uint = 0;
			var leave_message$count:uint = 0;
			var player_update_message$count:uint = 0;
			var request_server_status_message$count:uint = 0;
			var sign_in_message$count:uint = 0;
			var id$count:uint = 0;
			var join_ok_message$count:uint = 0;
			var leave_ok_message$count:uint = 0;
			var player_bingoed_message$count:uint = 0;
			var player_bought_cards_message$count:uint = 0;
			var server_status_message$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (room_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SelfTestMessage.roomId cannot be set twice.');
					}
					++room_id$count;
					this.roomId = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (room_tier$count != 0) {
						throw new flash.errors.IOError('Bad data format: SelfTestMessage.roomTier cannot be set twice.');
					}
					++room_tier$count;
					this.roomTier = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (room_type_name$count != 0) {
						throw new flash.errors.IOError('Bad data format: SelfTestMessage.roomTypeName cannot be set twice.');
					}
					++room_type_name$count;
					this.roomTypeName = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (player_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SelfTestMessage.playerId cannot be set twice.');
					}
					++player_id$count;
					this.playerId = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 5:
					if (timestamp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SelfTestMessage.timestamp cannot be set twice.');
					}
					++timestamp$count;
					this.timestamp = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 6:
					if (internal_event$count != 0) {
						throw new flash.errors.IOError('Bad data format: SelfTestMessage.internalEvent cannot be set twice.');
					}
					++internal_event$count;
					this.internalEvent = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 7:
					if (sign_in_ok_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: SelfTestMessage.signInOkMessage cannot be set twice.');
					}
					++sign_in_ok_message$count;
					this.signInOkMessage = new com.alisacasino.bingo.protocol.SignInOkMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.signInOkMessage);
					break;
				case 8:
					if (buy_cards_ok_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: SelfTestMessage.buyCardsOkMessage cannot be set twice.');
					}
					++buy_cards_ok_message$count;
					this.buyCardsOkMessage = new com.alisacasino.bingo.protocol.BuyCardsOkMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.buyCardsOkMessage);
					break;
				case 9:
					if (round_started_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: SelfTestMessage.roundStartedMessage cannot be set twice.');
					}
					++round_started_message$count;
					this.roundStartedMessage = new com.alisacasino.bingo.protocol.RoundStartedMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.roundStartedMessage);
					break;
				case 10:
					if (ball_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: SelfTestMessage.ballMessage cannot be set twice.');
					}
					++ball_message$count;
					this.ballMessage = new com.alisacasino.bingo.protocol.BallMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.ballMessage);
					break;
				case 11:
					if (bingo_ok_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: SelfTestMessage.bingoOkMessage cannot be set twice.');
					}
					++bingo_ok_message$count;
					this.bingoOkMessage = new com.alisacasino.bingo.protocol.BingoOkMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.bingoOkMessage);
					break;
				case 12:
					if (bad_bingo_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: SelfTestMessage.badBingoMessage cannot be set twice.');
					}
					++bad_bingo_message$count;
					this.badBingoMessage = new com.alisacasino.bingo.protocol.BadBingoMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.badBingoMessage);
					break;
				case 13:
					if (round_over_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: SelfTestMessage.roundOverMessage cannot be set twice.');
					}
					++round_over_message$count;
					this.roundOverMessage = new com.alisacasino.bingo.protocol.RoundOverMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.roundOverMessage);
					break;
				case 14:
					if (player_update_ok_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: SelfTestMessage.playerUpdateOkMessage cannot be set twice.');
					}
					++player_update_ok_message$count;
					this.playerUpdateOkMessage = new com.alisacasino.bingo.protocol.PlayerUpdateOkMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.playerUpdateOkMessage);
					break;
				case 15:
					if (error_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: SelfTestMessage.errorMessage cannot be set twice.');
					}
					++error_message$count;
					this.errorMessage = new com.alisacasino.bingo.protocol.ErrorMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.errorMessage);
					break;
				case 16:
					if (bingo_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: SelfTestMessage.bingoMessage cannot be set twice.');
					}
					++bingo_message$count;
					this.bingoMessage = new com.alisacasino.bingo.protocol.BingoMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.bingoMessage);
					break;
				case 17:
					if (buy_cards_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: SelfTestMessage.buyCardsMessage cannot be set twice.');
					}
					++buy_cards_message$count;
					this.buyCardsMessage = new com.alisacasino.bingo.protocol.BuyCardsMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.buyCardsMessage);
					break;
				case 18:
					if (join_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: SelfTestMessage.joinMessage cannot be set twice.');
					}
					++join_message$count;
					this.joinMessage = new com.alisacasino.bingo.protocol.JoinMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.joinMessage);
					break;
				case 19:
					if (leave_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: SelfTestMessage.leaveMessage cannot be set twice.');
					}
					++leave_message$count;
					this.leaveMessage = new com.alisacasino.bingo.protocol.LeaveMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.leaveMessage);
					break;
				case 20:
					if (player_update_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: SelfTestMessage.playerUpdateMessage cannot be set twice.');
					}
					++player_update_message$count;
					this.playerUpdateMessage = new com.alisacasino.bingo.protocol.PlayerUpdateMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.playerUpdateMessage);
					break;
				case 21:
					if (request_server_status_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: SelfTestMessage.requestServerStatusMessage cannot be set twice.');
					}
					++request_server_status_message$count;
					this.requestServerStatusMessage = new com.alisacasino.bingo.protocol.RequestServerStatusMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.requestServerStatusMessage);
					break;
				case 22:
					if (sign_in_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: SelfTestMessage.signInMessage cannot be set twice.');
					}
					++sign_in_message$count;
					this.signInMessage = new com.alisacasino.bingo.protocol.SignInMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.signInMessage);
					break;
				case 23:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SelfTestMessage.id cannot be set twice.');
					}
					++id$count;
					this.id = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 24:
					if (join_ok_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: SelfTestMessage.joinOkMessage cannot be set twice.');
					}
					++join_ok_message$count;
					this.joinOkMessage = new com.alisacasino.bingo.protocol.JoinOkMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.joinOkMessage);
					break;
				case 25:
					if (leave_ok_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: SelfTestMessage.leaveOkMessage cannot be set twice.');
					}
					++leave_ok_message$count;
					this.leaveOkMessage = new com.alisacasino.bingo.protocol.LeaveOkMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.leaveOkMessage);
					break;
				case 26:
					if (player_bingoed_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: SelfTestMessage.playerBingoedMessage cannot be set twice.');
					}
					++player_bingoed_message$count;
					this.playerBingoedMessage = new com.alisacasino.bingo.protocol.PlayerBingoedMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.playerBingoedMessage);
					break;
				case 27:
					if (player_bought_cards_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: SelfTestMessage.playerBoughtCardsMessage cannot be set twice.');
					}
					++player_bought_cards_message$count;
					this.playerBoughtCardsMessage = new com.alisacasino.bingo.protocol.PlayerBoughtCardsMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.playerBoughtCardsMessage);
					break;
				case 28:
					if (server_status_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: SelfTestMessage.serverStatusMessage cannot be set twice.');
					}
					++server_status_message$count;
					this.serverStatusMessage = new com.alisacasino.bingo.protocol.ServerStatusMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.serverStatusMessage);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
