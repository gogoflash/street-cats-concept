package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.ClaimEventPrizeMessage;
	import com.alisacasino.bingo.protocol.PlayerBoughtCardsMessage;
	import com.alisacasino.bingo.protocol.SaveClientDataMessage;
	import com.alisacasino.bingo.protocol.RequestUnacceptedGiftsMessage;
	import com.alisacasino.bingo.protocol.HelloMessage;
	import com.alisacasino.bingo.protocol.PurchaseMessage;
	import com.alisacasino.bingo.protocol.LiveEventInfoOkMessage;
	import com.alisacasino.bingo.protocol.ClaimOfferV2Message;
	import com.alisacasino.bingo.protocol.BadBingoMessage;
	import com.alisacasino.bingo.protocol.LeaveMessage;
	import com.alisacasino.bingo.protocol.LiveEventLeaderboardsMessage;
	import com.alisacasino.bingo.protocol.ServerStatusMessage;
	import com.alisacasino.bingo.protocol.RoomMessage;
	import com.alisacasino.bingo.protocol.RoundStateMessage;
	import com.alisacasino.bingo.protocol.BingoMessage;
	import com.alisacasino.bingo.protocol.ClaimOfferMessage;
	import com.alisacasino.bingo.protocol.RequestIncomingItemsMessage;
	import com.alisacasino.bingo.protocol.PlayerMessage;
	import com.alisacasino.bingo.protocol.RoundOverMessage;
	import com.alisacasino.bingo.protocol.CardMessage;
	import com.alisacasino.bingo.protocol.PlayerUpdateOkMessage;
	import com.alisacasino.bingo.protocol.OfferAcceptedMessage;
	import com.alisacasino.bingo.protocol.JoinOkMessage;
	import com.alisacasino.bingo.protocol.SignInMessage;
	import com.alisacasino.bingo.protocol.SignInOkMessage;
	import com.alisacasino.bingo.protocol.ClaimOfferOkMessage;
	import com.alisacasino.bingo.protocol.ClientMessage;
	import com.alisacasino.bingo.protocol.RequestUnacceptedGiftsOkMessage;
	import com.alisacasino.bingo.protocol.TournamentEndMessage;
	import com.alisacasino.bingo.protocol.PurchaseOkMessage;
	import com.alisacasino.bingo.protocol.PlayerUpdateMessage;
	import com.alisacasino.bingo.protocol.JoinMessage;
	import com.alisacasino.bingo.protocol.InviteMessage;
	import com.alisacasino.bingo.protocol.ErrorMessage;
	import com.alisacasino.bingo.protocol.GiftsAcceptedMessage;
	import com.alisacasino.bingo.protocol.PurchaseFailedMessage;
	import com.alisacasino.bingo.protocol.BuyCardsMessage;
	import com.alisacasino.bingo.protocol.GiftMessage;
	import com.alisacasino.bingo.protocol.RequestIncomingItemsOkMessage;
	import com.alisacasino.bingo.protocol.BingoOkMessage;
	import com.alisacasino.bingo.protocol.BuyCardsOkMessage;
	import com.alisacasino.bingo.protocol.RequestServerStatusMessage;
	import com.alisacasino.bingo.protocol.LiveEventScoreUpdateOkMessage;
	import com.alisacasino.bingo.protocol.PlayerBingoedMessage;
	import com.alisacasino.bingo.protocol.LiveEventInfoMessage;
	import com.alisacasino.bingo.protocol.LeaveOkMessage;
	import com.alisacasino.bingo.protocol.LiveEventScoreUpdateMessage;
	import com.alisacasino.bingo.protocol.RoundStartedMessage;
	import com.alisacasino.bingo.protocol.LiveEventLeaderboardsOkMessage;
	import com.alisacasino.bingo.protocol.GiftAcceptedMessage;
	import com.alisacasino.bingo.protocol.BallMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class BaseMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const REQUESTID:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.BaseMessage.requestId", "requestId", (54 << 3) | com.netease.protobuf.WireType.VARINT);

		private var requestId$field:UInt64;

		public function clearRequestId():void {
			requestId$field = null;
		}

		public function get hasRequestId():Boolean {
			return requestId$field != null;
		}

		public function set requestId(value:UInt64):void {
			requestId$field = value;
		}

		public function get requestId():UInt64 {
			return requestId$field;
		}

		/**
		 *  @private
		 */
		public static const BAD_BINGO_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.bad_bingo_message", "badBingoMessage", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.BadBingoMessage; });

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
		public static const BALL_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.ball_message", "ballMessage", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.BallMessage; });

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
		public static const BINGO_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.bingo_message", "bingoMessage", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.BingoMessage; });

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
		public static const BINGO_OK_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.bingo_ok_message", "bingoOkMessage", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.BingoOkMessage; });

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
		public static const BUY_CARDS_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.buy_cards_message", "buyCardsMessage", (5 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.BuyCardsMessage; });

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
		public static const BUY_CARDS_OK_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.buy_cards_ok_message", "buyCardsOkMessage", (6 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.BuyCardsOkMessage; });

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
		public static const CARD_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.card_message", "cardMessage", (7 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.CardMessage; });

		private var card_message$field:com.alisacasino.bingo.protocol.CardMessage;

		public function clearCardMessage():void {
			card_message$field = null;
		}

		public function get hasCardMessage():Boolean {
			return card_message$field != null;
		}

		public function set cardMessage(value:com.alisacasino.bingo.protocol.CardMessage):void {
			card_message$field = value;
		}

		public function get cardMessage():com.alisacasino.bingo.protocol.CardMessage {
			return card_message$field;
		}

		/**
		 *  @private
		 */
		public static const ERROR_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.error_message", "errorMessage", (8 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.ErrorMessage; });

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
		public static const HELLO_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.hello_message", "helloMessage", (9 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.HelloMessage; });

		private var hello_message$field:com.alisacasino.bingo.protocol.HelloMessage;

		public function clearHelloMessage():void {
			hello_message$field = null;
		}

		public function get hasHelloMessage():Boolean {
			return hello_message$field != null;
		}

		public function set helloMessage(value:com.alisacasino.bingo.protocol.HelloMessage):void {
			hello_message$field = value;
		}

		public function get helloMessage():com.alisacasino.bingo.protocol.HelloMessage {
			return hello_message$field;
		}

		/**
		 *  @private
		 */
		public static const JOIN_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.join_message", "joinMessage", (10 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.JoinMessage; });

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
		public static const JOIN_OK_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.join_ok_message", "joinOkMessage", (11 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.JoinOkMessage; });

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
		public static const LEAVE_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.leave_message", "leaveMessage", (12 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.LeaveMessage; });

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
		public static const LEAVE_OK_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.leave_ok_message", "leaveOkMessage", (13 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.LeaveOkMessage; });

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
		public static const PLAYER_BINGOED_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.player_bingoed_message", "playerBingoedMessage", (14 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PlayerBingoedMessage; });

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
		public static const PLAYER_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.player_message", "playerMessage", (15 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PlayerMessage; });

		private var player_message$field:com.alisacasino.bingo.protocol.PlayerMessage;

		public function clearPlayerMessage():void {
			player_message$field = null;
		}

		public function get hasPlayerMessage():Boolean {
			return player_message$field != null;
		}

		public function set playerMessage(value:com.alisacasino.bingo.protocol.PlayerMessage):void {
			player_message$field = value;
		}

		public function get playerMessage():com.alisacasino.bingo.protocol.PlayerMessage {
			return player_message$field;
		}

		/**
		 *  @private
		 */
		public static const ROOM_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.room_message", "roomMessage", (16 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.RoomMessage; });

		private var room_message$field:com.alisacasino.bingo.protocol.RoomMessage;

		public function clearRoomMessage():void {
			room_message$field = null;
		}

		public function get hasRoomMessage():Boolean {
			return room_message$field != null;
		}

		public function set roomMessage(value:com.alisacasino.bingo.protocol.RoomMessage):void {
			room_message$field = value;
		}

		public function get roomMessage():com.alisacasino.bingo.protocol.RoomMessage {
			return room_message$field;
		}

		/**
		 *  @private
		 */
		public static const ROUND_OVER_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.round_over_message", "roundOverMessage", (17 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.RoundOverMessage; });

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
		public static const ROUND_STARTED_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.round_started_message", "roundStartedMessage", (18 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.RoundStartedMessage; });

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
		public static const SIGN_IN_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.sign_in_message", "signInMessage", (19 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.SignInMessage; });

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
		public static const SIGN_IN_OK_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.sign_in_ok_message", "signInOkMessage", (20 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.SignInOkMessage; });

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
		public static const PLAYER_BOUGHT_CARDS_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.player_bought_cards_message", "playerBoughtCardsMessage", (21 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PlayerBoughtCardsMessage; });

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
		public static const PLAYER_UPDATE_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.player_update_message", "playerUpdateMessage", (22 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PlayerUpdateMessage; });

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
		public static const PLAYER_UPDATE_OK_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.player_update_ok_message", "playerUpdateOkMessage", (23 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PlayerUpdateOkMessage; });

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
		public static const REQUEST_SERVER_STATUS_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.request_server_status_message", "requestServerStatusMessage", (24 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.RequestServerStatusMessage; });

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
		public static const SERVER_STATUS_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.server_status_message", "serverStatusMessage", (25 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.ServerStatusMessage; });

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
		public static const SENTBYSERVERTIMESTAMP:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.BaseMessage.sentByServerTimestamp", "sentByServerTimestamp", (26 << 3) | com.netease.protobuf.WireType.VARINT);

		private var sentByServerTimestamp$field:UInt64;

		public function clearSentByServerTimestamp():void {
			sentByServerTimestamp$field = null;
		}

		public function get hasSentByServerTimestamp():Boolean {
			return sentByServerTimestamp$field != null;
		}

		public function set sentByServerTimestamp(value:UInt64):void {
			sentByServerTimestamp$field = value;
		}

		public function get sentByServerTimestamp():UInt64 {
			return sentByServerTimestamp$field;
		}

		/**
		 *  @private
		 */
		public static const PURCHASE_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.purchase_message", "purchaseMessage", (27 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PurchaseMessage; });

		private var purchase_message$field:com.alisacasino.bingo.protocol.PurchaseMessage;

		public function clearPurchaseMessage():void {
			purchase_message$field = null;
		}

		public function get hasPurchaseMessage():Boolean {
			return purchase_message$field != null;
		}

		public function set purchaseMessage(value:com.alisacasino.bingo.protocol.PurchaseMessage):void {
			purchase_message$field = value;
		}

		public function get purchaseMessage():com.alisacasino.bingo.protocol.PurchaseMessage {
			return purchase_message$field;
		}

		/**
		 *  @private
		 */
		public static const PURCHASE_OK_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.purchase_ok_message", "purchaseOkMessage", (28 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PurchaseOkMessage; });

		private var purchase_ok_message$field:com.alisacasino.bingo.protocol.PurchaseOkMessage;

		public function clearPurchaseOkMessage():void {
			purchase_ok_message$field = null;
		}

		public function get hasPurchaseOkMessage():Boolean {
			return purchase_ok_message$field != null;
		}

		public function set purchaseOkMessage(value:com.alisacasino.bingo.protocol.PurchaseOkMessage):void {
			purchase_ok_message$field = value;
		}

		public function get purchaseOkMessage():com.alisacasino.bingo.protocol.PurchaseOkMessage {
			return purchase_ok_message$field;
		}

		/**
		 *  @private
		 */
		public static const PURCHASE_FAILED_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.purchase_failed_message", "purchaseFailedMessage", (29 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PurchaseFailedMessage; });

		private var purchase_failed_message$field:com.alisacasino.bingo.protocol.PurchaseFailedMessage;

		public function clearPurchaseFailedMessage():void {
			purchase_failed_message$field = null;
		}

		public function get hasPurchaseFailedMessage():Boolean {
			return purchase_failed_message$field != null;
		}

		public function set purchaseFailedMessage(value:com.alisacasino.bingo.protocol.PurchaseFailedMessage):void {
			purchase_failed_message$field = value;
		}

		public function get purchaseFailedMessage():com.alisacasino.bingo.protocol.PurchaseFailedMessage {
			return purchase_failed_message$field;
		}

		/**
		 *  @private
		 */
		public static const LIVE_EVENT_INFO_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.live_event_info_message", "liveEventInfoMessage", (30 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.LiveEventInfoMessage; });

		private var live_event_info_message$field:com.alisacasino.bingo.protocol.LiveEventInfoMessage;

		public function clearLiveEventInfoMessage():void {
			live_event_info_message$field = null;
		}

		public function get hasLiveEventInfoMessage():Boolean {
			return live_event_info_message$field != null;
		}

		public function set liveEventInfoMessage(value:com.alisacasino.bingo.protocol.LiveEventInfoMessage):void {
			live_event_info_message$field = value;
		}

		public function get liveEventInfoMessage():com.alisacasino.bingo.protocol.LiveEventInfoMessage {
			return live_event_info_message$field;
		}

		/**
		 *  @private
		 */
		public static const LIVE_EVENT_INFO_OK_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.live_event_info_ok_message", "liveEventInfoOkMessage", (31 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.LiveEventInfoOkMessage; });

		private var live_event_info_ok_message$field:com.alisacasino.bingo.protocol.LiveEventInfoOkMessage;

		public function clearLiveEventInfoOkMessage():void {
			live_event_info_ok_message$field = null;
		}

		public function get hasLiveEventInfoOkMessage():Boolean {
			return live_event_info_ok_message$field != null;
		}

		public function set liveEventInfoOkMessage(value:com.alisacasino.bingo.protocol.LiveEventInfoOkMessage):void {
			live_event_info_ok_message$field = value;
		}

		public function get liveEventInfoOkMessage():com.alisacasino.bingo.protocol.LiveEventInfoOkMessage {
			return live_event_info_ok_message$field;
		}

		/**
		 *  @private
		 */
		public static const LIVE_EVENT_LEADERBOARDS_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.live_event_leaderboards_message", "liveEventLeaderboardsMessage", (32 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.LiveEventLeaderboardsMessage; });

		private var live_event_leaderboards_message$field:com.alisacasino.bingo.protocol.LiveEventLeaderboardsMessage;

		public function clearLiveEventLeaderboardsMessage():void {
			live_event_leaderboards_message$field = null;
		}

		public function get hasLiveEventLeaderboardsMessage():Boolean {
			return live_event_leaderboards_message$field != null;
		}

		public function set liveEventLeaderboardsMessage(value:com.alisacasino.bingo.protocol.LiveEventLeaderboardsMessage):void {
			live_event_leaderboards_message$field = value;
		}

		public function get liveEventLeaderboardsMessage():com.alisacasino.bingo.protocol.LiveEventLeaderboardsMessage {
			return live_event_leaderboards_message$field;
		}

		/**
		 *  @private
		 */
		public static const LIVE_EVENT_LEADERBOARDS_OK_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.live_event_leaderboards_ok_message", "liveEventLeaderboardsOkMessage", (33 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.LiveEventLeaderboardsOkMessage; });

		private var live_event_leaderboards_ok_message$field:com.alisacasino.bingo.protocol.LiveEventLeaderboardsOkMessage;

		public function clearLiveEventLeaderboardsOkMessage():void {
			live_event_leaderboards_ok_message$field = null;
		}

		public function get hasLiveEventLeaderboardsOkMessage():Boolean {
			return live_event_leaderboards_ok_message$field != null;
		}

		public function set liveEventLeaderboardsOkMessage(value:com.alisacasino.bingo.protocol.LiveEventLeaderboardsOkMessage):void {
			live_event_leaderboards_ok_message$field = value;
		}

		public function get liveEventLeaderboardsOkMessage():com.alisacasino.bingo.protocol.LiveEventLeaderboardsOkMessage {
			return live_event_leaderboards_ok_message$field;
		}

		/**
		 *  @private
		 */
		public static const LIVE_EVENT_SCORE_UPDATE_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.live_event_score_update_message", "liveEventScoreUpdateMessage", (34 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.LiveEventScoreUpdateMessage; });

		private var live_event_score_update_message$field:com.alisacasino.bingo.protocol.LiveEventScoreUpdateMessage;

		public function clearLiveEventScoreUpdateMessage():void {
			live_event_score_update_message$field = null;
		}

		public function get hasLiveEventScoreUpdateMessage():Boolean {
			return live_event_score_update_message$field != null;
		}

		public function set liveEventScoreUpdateMessage(value:com.alisacasino.bingo.protocol.LiveEventScoreUpdateMessage):void {
			live_event_score_update_message$field = value;
		}

		public function get liveEventScoreUpdateMessage():com.alisacasino.bingo.protocol.LiveEventScoreUpdateMessage {
			return live_event_score_update_message$field;
		}

		/**
		 *  @private
		 */
		public static const LIVE_EVENT_SCORE_UPDATE_OK_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.live_event_score_update_ok_message", "liveEventScoreUpdateOkMessage", (35 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.LiveEventScoreUpdateOkMessage; });

		private var live_event_score_update_ok_message$field:com.alisacasino.bingo.protocol.LiveEventScoreUpdateOkMessage;

		public function clearLiveEventScoreUpdateOkMessage():void {
			live_event_score_update_ok_message$field = null;
		}

		public function get hasLiveEventScoreUpdateOkMessage():Boolean {
			return live_event_score_update_ok_message$field != null;
		}

		public function set liveEventScoreUpdateOkMessage(value:com.alisacasino.bingo.protocol.LiveEventScoreUpdateOkMessage):void {
			live_event_score_update_ok_message$field = value;
		}

		public function get liveEventScoreUpdateOkMessage():com.alisacasino.bingo.protocol.LiveEventScoreUpdateOkMessage {
			return live_event_score_update_ok_message$field;
		}

		/**
		 *  @private
		 */
		public static const INVITE_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.invite_message", "inviteMessage", (36 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.InviteMessage; });

		private var invite_message$field:com.alisacasino.bingo.protocol.InviteMessage;

		public function clearInviteMessage():void {
			invite_message$field = null;
		}

		public function get hasInviteMessage():Boolean {
			return invite_message$field != null;
		}

		public function set inviteMessage(value:com.alisacasino.bingo.protocol.InviteMessage):void {
			invite_message$field = value;
		}

		public function get inviteMessage():com.alisacasino.bingo.protocol.InviteMessage {
			return invite_message$field;
		}

		/**
		 *  @private
		 */
		public static const GIFT_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.gift_message", "giftMessage", (37 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.GiftMessage; });

		private var gift_message$field:com.alisacasino.bingo.protocol.GiftMessage;

		public function clearGiftMessage():void {
			gift_message$field = null;
		}

		public function get hasGiftMessage():Boolean {
			return gift_message$field != null;
		}

		public function set giftMessage(value:com.alisacasino.bingo.protocol.GiftMessage):void {
			gift_message$field = value;
		}

		public function get giftMessage():com.alisacasino.bingo.protocol.GiftMessage {
			return gift_message$field;
		}

		/**
		 *  @private
		 */
		public static const GIFT_ACCEPTED_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.gift_accepted_message", "giftAcceptedMessage", (38 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.GiftAcceptedMessage; });

		private var gift_accepted_message$field:com.alisacasino.bingo.protocol.GiftAcceptedMessage;

		public function clearGiftAcceptedMessage():void {
			gift_accepted_message$field = null;
		}

		public function get hasGiftAcceptedMessage():Boolean {
			return gift_accepted_message$field != null;
		}

		public function set giftAcceptedMessage(value:com.alisacasino.bingo.protocol.GiftAcceptedMessage):void {
			gift_accepted_message$field = value;
		}

		public function get giftAcceptedMessage():com.alisacasino.bingo.protocol.GiftAcceptedMessage {
			return gift_accepted_message$field;
		}

		/**
		 *  @private
		 */
		public static const CLAIM_OFFER_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.claim_offer_message", "claimOfferMessage", (39 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.ClaimOfferMessage; });

		private var claim_offer_message$field:com.alisacasino.bingo.protocol.ClaimOfferMessage;

		public function clearClaimOfferMessage():void {
			claim_offer_message$field = null;
		}

		public function get hasClaimOfferMessage():Boolean {
			return claim_offer_message$field != null;
		}

		public function set claimOfferMessage(value:com.alisacasino.bingo.protocol.ClaimOfferMessage):void {
			claim_offer_message$field = value;
		}

		public function get claimOfferMessage():com.alisacasino.bingo.protocol.ClaimOfferMessage {
			return claim_offer_message$field;
		}

		/**
		 *  @private
		 */
		public static const CLAIM_OFFER_OK_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.claim_offer_ok_message", "claimOfferOkMessage", (40 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.ClaimOfferOkMessage; });

		private var claim_offer_ok_message$field:com.alisacasino.bingo.protocol.ClaimOfferOkMessage;

		public function clearClaimOfferOkMessage():void {
			claim_offer_ok_message$field = null;
		}

		public function get hasClaimOfferOkMessage():Boolean {
			return claim_offer_ok_message$field != null;
		}

		public function set claimOfferOkMessage(value:com.alisacasino.bingo.protocol.ClaimOfferOkMessage):void {
			claim_offer_ok_message$field = value;
		}

		public function get claimOfferOkMessage():com.alisacasino.bingo.protocol.ClaimOfferOkMessage {
			return claim_offer_ok_message$field;
		}

		/**
		 *  @private
		 */
		public static const REQUEST_UNACCEPTED_GIFTS_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.request_unaccepted_gifts_message", "requestUnacceptedGiftsMessage", (41 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.RequestUnacceptedGiftsMessage; });

		private var request_unaccepted_gifts_message$field:com.alisacasino.bingo.protocol.RequestUnacceptedGiftsMessage;

		public function clearRequestUnacceptedGiftsMessage():void {
			request_unaccepted_gifts_message$field = null;
		}

		public function get hasRequestUnacceptedGiftsMessage():Boolean {
			return request_unaccepted_gifts_message$field != null;
		}

		public function set requestUnacceptedGiftsMessage(value:com.alisacasino.bingo.protocol.RequestUnacceptedGiftsMessage):void {
			request_unaccepted_gifts_message$field = value;
		}

		public function get requestUnacceptedGiftsMessage():com.alisacasino.bingo.protocol.RequestUnacceptedGiftsMessage {
			return request_unaccepted_gifts_message$field;
		}

		/**
		 *  @private
		 */
		public static const REQUEST_UNACCEPTED_GIFTS_OK_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.request_unaccepted_gifts_ok_message", "requestUnacceptedGiftsOkMessage", (42 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.RequestUnacceptedGiftsOkMessage; });

		private var request_unaccepted_gifts_ok_message$field:com.alisacasino.bingo.protocol.RequestUnacceptedGiftsOkMessage;

		public function clearRequestUnacceptedGiftsOkMessage():void {
			request_unaccepted_gifts_ok_message$field = null;
		}

		public function get hasRequestUnacceptedGiftsOkMessage():Boolean {
			return request_unaccepted_gifts_ok_message$field != null;
		}

		public function set requestUnacceptedGiftsOkMessage(value:com.alisacasino.bingo.protocol.RequestUnacceptedGiftsOkMessage):void {
			request_unaccepted_gifts_ok_message$field = value;
		}

		public function get requestUnacceptedGiftsOkMessage():com.alisacasino.bingo.protocol.RequestUnacceptedGiftsOkMessage {
			return request_unaccepted_gifts_ok_message$field;
		}

		/**
		 *  @private
		 */
		public static const CLIENT_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.client_message", "clientMessage", (43 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.ClientMessage; });

		private var client_message$field:com.alisacasino.bingo.protocol.ClientMessage;

		public function clearClientMessage():void {
			client_message$field = null;
		}

		public function get hasClientMessage():Boolean {
			return client_message$field != null;
		}

		public function set clientMessage(value:com.alisacasino.bingo.protocol.ClientMessage):void {
			client_message$field = value;
		}

		public function get clientMessage():com.alisacasino.bingo.protocol.ClientMessage {
			return client_message$field;
		}

		/**
		 *  @private
		 */
		public static const CLAIM_OFFER_V2_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.claim_offer_v2_message", "claimOfferV2Message", (44 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.ClaimOfferV2Message; });

		private var claim_offer_v2_message$field:com.alisacasino.bingo.protocol.ClaimOfferV2Message;

		public function clearClaimOfferV2Message():void {
			claim_offer_v2_message$field = null;
		}

		public function get hasClaimOfferV2Message():Boolean {
			return claim_offer_v2_message$field != null;
		}

		public function set claimOfferV2Message(value:com.alisacasino.bingo.protocol.ClaimOfferV2Message):void {
			claim_offer_v2_message$field = value;
		}

		public function get claimOfferV2Message():com.alisacasino.bingo.protocol.ClaimOfferV2Message {
			return claim_offer_v2_message$field;
		}

		/**
		 *  @private
		 */
		public static const OFFER_ACCEPTED_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.offer_accepted_message", "offerAcceptedMessage", (45 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.OfferAcceptedMessage; });

		private var offer_accepted_message$field:com.alisacasino.bingo.protocol.OfferAcceptedMessage;

		public function clearOfferAcceptedMessage():void {
			offer_accepted_message$field = null;
		}

		public function get hasOfferAcceptedMessage():Boolean {
			return offer_accepted_message$field != null;
		}

		public function set offerAcceptedMessage(value:com.alisacasino.bingo.protocol.OfferAcceptedMessage):void {
			offer_accepted_message$field = value;
		}

		public function get offerAcceptedMessage():com.alisacasino.bingo.protocol.OfferAcceptedMessage {
			return offer_accepted_message$field;
		}

		/**
		 *  @private
		 */
		public static const GIFTS_ACCEPTED_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.gifts_accepted_message", "giftsAcceptedMessage", (46 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.GiftsAcceptedMessage; });

		private var gifts_accepted_message$field:com.alisacasino.bingo.protocol.GiftsAcceptedMessage;

		public function clearGiftsAcceptedMessage():void {
			gifts_accepted_message$field = null;
		}

		public function get hasGiftsAcceptedMessage():Boolean {
			return gifts_accepted_message$field != null;
		}

		public function set giftsAcceptedMessage(value:com.alisacasino.bingo.protocol.GiftsAcceptedMessage):void {
			gifts_accepted_message$field = value;
		}

		public function get giftsAcceptedMessage():com.alisacasino.bingo.protocol.GiftsAcceptedMessage {
			return gifts_accepted_message$field;
		}

		/**
		 *  @private
		 */
		public static const CLAIM_EVENT_PRIZE_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.claim_event_prize_message", "claimEventPrizeMessage", (47 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.ClaimEventPrizeMessage; });

		private var claim_event_prize_message$field:com.alisacasino.bingo.protocol.ClaimEventPrizeMessage;

		public function clearClaimEventPrizeMessage():void {
			claim_event_prize_message$field = null;
		}

		public function get hasClaimEventPrizeMessage():Boolean {
			return claim_event_prize_message$field != null;
		}

		public function set claimEventPrizeMessage(value:com.alisacasino.bingo.protocol.ClaimEventPrizeMessage):void {
			claim_event_prize_message$field = value;
		}

		public function get claimEventPrizeMessage():com.alisacasino.bingo.protocol.ClaimEventPrizeMessage {
			return claim_event_prize_message$field;
		}

		/**
		 *  @private
		 */
		public static const REQUEST_INCOMING_ITEMS_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.request_incoming_items_message", "requestIncomingItemsMessage", (48 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.RequestIncomingItemsMessage; });

		private var request_incoming_items_message$field:com.alisacasino.bingo.protocol.RequestIncomingItemsMessage;

		public function clearRequestIncomingItemsMessage():void {
			request_incoming_items_message$field = null;
		}

		public function get hasRequestIncomingItemsMessage():Boolean {
			return request_incoming_items_message$field != null;
		}

		public function set requestIncomingItemsMessage(value:com.alisacasino.bingo.protocol.RequestIncomingItemsMessage):void {
			request_incoming_items_message$field = value;
		}

		public function get requestIncomingItemsMessage():com.alisacasino.bingo.protocol.RequestIncomingItemsMessage {
			return request_incoming_items_message$field;
		}

		/**
		 *  @private
		 */
		public static const REQUEST_INCOMING_ITEMS_OK_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.request_incoming_items_ok_message", "requestIncomingItemsOkMessage", (49 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.RequestIncomingItemsOkMessage; });

		private var request_incoming_items_ok_message$field:com.alisacasino.bingo.protocol.RequestIncomingItemsOkMessage;

		public function clearRequestIncomingItemsOkMessage():void {
			request_incoming_items_ok_message$field = null;
		}

		public function get hasRequestIncomingItemsOkMessage():Boolean {
			return request_incoming_items_ok_message$field != null;
		}

		public function set requestIncomingItemsOkMessage(value:com.alisacasino.bingo.protocol.RequestIncomingItemsOkMessage):void {
			request_incoming_items_ok_message$field = value;
		}

		public function get requestIncomingItemsOkMessage():com.alisacasino.bingo.protocol.RequestIncomingItemsOkMessage {
			return request_incoming_items_ok_message$field;
		}

		/**
		 *  @private
		 */
		public static const STATIC_VERSION:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.BaseMessage.static_version", "staticVersion", (50 << 3) | com.netease.protobuf.WireType.VARINT);

		private var static_version$field:uint;

		private var hasField$0:uint = 0;

		public function clearStaticVersion():void {
			hasField$0 &= 0xfffffffe;
			static_version$field = new uint();
		}

		public function get hasStaticVersion():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set staticVersion(value:uint):void {
			hasField$0 |= 0x1;
			static_version$field = value;
		}

		public function get staticVersion():uint {
			return static_version$field;
		}

		/**
		 *  @private
		 */
		public static const PROTOCOL_VERSION:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.BaseMessage.protocol_version", "protocolVersion", (51 << 3) | com.netease.protobuf.WireType.VARINT);

		private var protocol_version$field:uint;

		public function clearProtocolVersion():void {
			hasField$0 &= 0xfffffffd;
			protocol_version$field = new uint();
		}

		public function get hasProtocolVersion():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set protocolVersion(value:uint):void {
			hasField$0 |= 0x2;
			protocol_version$field = value;
		}

		public function get protocolVersion():uint {
			return protocol_version$field;
		}

		/**
		 *  @private
		 */
		public static const SAVE_CLIENT_DATA_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.save_client_data_message", "saveClientDataMessage", (52 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.SaveClientDataMessage; });

		private var save_client_data_message$field:com.alisacasino.bingo.protocol.SaveClientDataMessage;

		public function clearSaveClientDataMessage():void {
			save_client_data_message$field = null;
		}

		public function get hasSaveClientDataMessage():Boolean {
			return save_client_data_message$field != null;
		}

		public function set saveClientDataMessage(value:com.alisacasino.bingo.protocol.SaveClientDataMessage):void {
			save_client_data_message$field = value;
		}

		public function get saveClientDataMessage():com.alisacasino.bingo.protocol.SaveClientDataMessage {
			return save_client_data_message$field;
		}

		/**
		 *  @private
		 */
		public static const ROUND_STATE_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.round_state_message", "roundStateMessage", (53 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.RoundStateMessage; });

		private var round_state_message$field:com.alisacasino.bingo.protocol.RoundStateMessage;

		public function clearRoundStateMessage():void {
			round_state_message$field = null;
		}

		public function get hasRoundStateMessage():Boolean {
			return round_state_message$field != null;
		}

		public function set roundStateMessage(value:com.alisacasino.bingo.protocol.RoundStateMessage):void {
			round_state_message$field = value;
		}

		public function get roundStateMessage():com.alisacasino.bingo.protocol.RoundStateMessage {
			return round_state_message$field;
		}

		/**
		 *  @private
		 */
		public static const TOURNAMENT_END_MESSAGE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.BaseMessage.tournament_end_message", "tournamentEndMessage", (55 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.TournamentEndMessage; });

		private var tournament_end_message$field:com.alisacasino.bingo.protocol.TournamentEndMessage;

		public function clearTournamentEndMessage():void {
			tournament_end_message$field = null;
		}

		public function get hasTournamentEndMessage():Boolean {
			return tournament_end_message$field != null;
		}

		public function set tournamentEndMessage(value:com.alisacasino.bingo.protocol.TournamentEndMessage):void {
			tournament_end_message$field = value;
		}

		public function get tournamentEndMessage():com.alisacasino.bingo.protocol.TournamentEndMessage {
			return tournament_end_message$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasRequestId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 54);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, requestId$field);
			}
			if (hasBadBingoMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, bad_bingo_message$field);
			}
			if (hasBallMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, ball_message$field);
			}
			if (hasBingoMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, bingo_message$field);
			}
			if (hasBingoOkMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, bingo_ok_message$field);
			}
			if (hasBuyCardsMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, buy_cards_message$field);
			}
			if (hasBuyCardsOkMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, buy_cards_ok_message$field);
			}
			if (hasCardMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, card_message$field);
			}
			if (hasErrorMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, error_message$field);
			}
			if (hasHelloMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 9);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, hello_message$field);
			}
			if (hasJoinMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 10);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, join_message$field);
			}
			if (hasJoinOkMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 11);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, join_ok_message$field);
			}
			if (hasLeaveMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 12);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, leave_message$field);
			}
			if (hasLeaveOkMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 13);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, leave_ok_message$field);
			}
			if (hasPlayerBingoedMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 14);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, player_bingoed_message$field);
			}
			if (hasPlayerMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 15);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, player_message$field);
			}
			if (hasRoomMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 16);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, room_message$field);
			}
			if (hasRoundOverMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 17);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, round_over_message$field);
			}
			if (hasRoundStartedMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 18);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, round_started_message$field);
			}
			if (hasSignInMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 19);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, sign_in_message$field);
			}
			if (hasSignInOkMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 20);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, sign_in_ok_message$field);
			}
			if (hasPlayerBoughtCardsMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 21);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, player_bought_cards_message$field);
			}
			if (hasPlayerUpdateMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 22);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, player_update_message$field);
			}
			if (hasPlayerUpdateOkMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 23);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, player_update_ok_message$field);
			}
			if (hasRequestServerStatusMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 24);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, request_server_status_message$field);
			}
			if (hasServerStatusMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 25);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, server_status_message$field);
			}
			if (hasSentByServerTimestamp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 26);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, sentByServerTimestamp$field);
			}
			if (hasPurchaseMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 27);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, purchase_message$field);
			}
			if (hasPurchaseOkMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 28);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, purchase_ok_message$field);
			}
			if (hasPurchaseFailedMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 29);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, purchase_failed_message$field);
			}
			if (hasLiveEventInfoMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 30);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, live_event_info_message$field);
			}
			if (hasLiveEventInfoOkMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 31);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, live_event_info_ok_message$field);
			}
			if (hasLiveEventLeaderboardsMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 32);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, live_event_leaderboards_message$field);
			}
			if (hasLiveEventLeaderboardsOkMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 33);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, live_event_leaderboards_ok_message$field);
			}
			if (hasLiveEventScoreUpdateMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 34);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, live_event_score_update_message$field);
			}
			if (hasLiveEventScoreUpdateOkMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 35);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, live_event_score_update_ok_message$field);
			}
			if (hasInviteMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 36);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, invite_message$field);
			}
			if (hasGiftMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 37);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, gift_message$field);
			}
			if (hasGiftAcceptedMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 38);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, gift_accepted_message$field);
			}
			if (hasClaimOfferMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 39);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, claim_offer_message$field);
			}
			if (hasClaimOfferOkMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 40);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, claim_offer_ok_message$field);
			}
			if (hasRequestUnacceptedGiftsMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 41);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, request_unaccepted_gifts_message$field);
			}
			if (hasRequestUnacceptedGiftsOkMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 42);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, request_unaccepted_gifts_ok_message$field);
			}
			if (hasClientMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 43);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, client_message$field);
			}
			if (hasClaimOfferV2Message) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 44);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, claim_offer_v2_message$field);
			}
			if (hasOfferAcceptedMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 45);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, offer_accepted_message$field);
			}
			if (hasGiftsAcceptedMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 46);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, gifts_accepted_message$field);
			}
			if (hasClaimEventPrizeMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 47);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, claim_event_prize_message$field);
			}
			if (hasRequestIncomingItemsMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 48);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, request_incoming_items_message$field);
			}
			if (hasRequestIncomingItemsOkMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 49);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, request_incoming_items_ok_message$field);
			}
			if (hasStaticVersion) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 50);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, static_version$field);
			}
			if (hasProtocolVersion) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 51);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, protocol_version$field);
			}
			if (hasSaveClientDataMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 52);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, save_client_data_message$field);
			}
			if (hasRoundStateMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 53);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, round_state_message$field);
			}
			if (hasTournamentEndMessage) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 55);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, tournament_end_message$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var requestId$count:uint = 0;
			var bad_bingo_message$count:uint = 0;
			var ball_message$count:uint = 0;
			var bingo_message$count:uint = 0;
			var bingo_ok_message$count:uint = 0;
			var buy_cards_message$count:uint = 0;
			var buy_cards_ok_message$count:uint = 0;
			var card_message$count:uint = 0;
			var error_message$count:uint = 0;
			var hello_message$count:uint = 0;
			var join_message$count:uint = 0;
			var join_ok_message$count:uint = 0;
			var leave_message$count:uint = 0;
			var leave_ok_message$count:uint = 0;
			var player_bingoed_message$count:uint = 0;
			var player_message$count:uint = 0;
			var room_message$count:uint = 0;
			var round_over_message$count:uint = 0;
			var round_started_message$count:uint = 0;
			var sign_in_message$count:uint = 0;
			var sign_in_ok_message$count:uint = 0;
			var player_bought_cards_message$count:uint = 0;
			var player_update_message$count:uint = 0;
			var player_update_ok_message$count:uint = 0;
			var request_server_status_message$count:uint = 0;
			var server_status_message$count:uint = 0;
			var sentByServerTimestamp$count:uint = 0;
			var purchase_message$count:uint = 0;
			var purchase_ok_message$count:uint = 0;
			var purchase_failed_message$count:uint = 0;
			var live_event_info_message$count:uint = 0;
			var live_event_info_ok_message$count:uint = 0;
			var live_event_leaderboards_message$count:uint = 0;
			var live_event_leaderboards_ok_message$count:uint = 0;
			var live_event_score_update_message$count:uint = 0;
			var live_event_score_update_ok_message$count:uint = 0;
			var invite_message$count:uint = 0;
			var gift_message$count:uint = 0;
			var gift_accepted_message$count:uint = 0;
			var claim_offer_message$count:uint = 0;
			var claim_offer_ok_message$count:uint = 0;
			var request_unaccepted_gifts_message$count:uint = 0;
			var request_unaccepted_gifts_ok_message$count:uint = 0;
			var client_message$count:uint = 0;
			var claim_offer_v2_message$count:uint = 0;
			var offer_accepted_message$count:uint = 0;
			var gifts_accepted_message$count:uint = 0;
			var claim_event_prize_message$count:uint = 0;
			var request_incoming_items_message$count:uint = 0;
			var request_incoming_items_ok_message$count:uint = 0;
			var static_version$count:uint = 0;
			var protocol_version$count:uint = 0;
			var save_client_data_message$count:uint = 0;
			var round_state_message$count:uint = 0;
			var tournament_end_message$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 54:
					if (requestId$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.requestId cannot be set twice.');
					}
					++requestId$count;
					this.requestId = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 1:
					if (bad_bingo_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.badBingoMessage cannot be set twice.');
					}
					++bad_bingo_message$count;
					this.badBingoMessage = new com.alisacasino.bingo.protocol.BadBingoMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.badBingoMessage);
					break;
				case 2:
					if (ball_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.ballMessage cannot be set twice.');
					}
					++ball_message$count;
					this.ballMessage = new com.alisacasino.bingo.protocol.BallMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.ballMessage);
					break;
				case 3:
					if (bingo_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.bingoMessage cannot be set twice.');
					}
					++bingo_message$count;
					this.bingoMessage = new com.alisacasino.bingo.protocol.BingoMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.bingoMessage);
					break;
				case 4:
					if (bingo_ok_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.bingoOkMessage cannot be set twice.');
					}
					++bingo_ok_message$count;
					this.bingoOkMessage = new com.alisacasino.bingo.protocol.BingoOkMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.bingoOkMessage);
					break;
				case 5:
					if (buy_cards_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.buyCardsMessage cannot be set twice.');
					}
					++buy_cards_message$count;
					this.buyCardsMessage = new com.alisacasino.bingo.protocol.BuyCardsMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.buyCardsMessage);
					break;
				case 6:
					if (buy_cards_ok_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.buyCardsOkMessage cannot be set twice.');
					}
					++buy_cards_ok_message$count;
					this.buyCardsOkMessage = new com.alisacasino.bingo.protocol.BuyCardsOkMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.buyCardsOkMessage);
					break;
				case 7:
					if (card_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.cardMessage cannot be set twice.');
					}
					++card_message$count;
					this.cardMessage = new com.alisacasino.bingo.protocol.CardMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.cardMessage);
					break;
				case 8:
					if (error_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.errorMessage cannot be set twice.');
					}
					++error_message$count;
					this.errorMessage = new com.alisacasino.bingo.protocol.ErrorMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.errorMessage);
					break;
				case 9:
					if (hello_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.helloMessage cannot be set twice.');
					}
					++hello_message$count;
					this.helloMessage = new com.alisacasino.bingo.protocol.HelloMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.helloMessage);
					break;
				case 10:
					if (join_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.joinMessage cannot be set twice.');
					}
					++join_message$count;
					this.joinMessage = new com.alisacasino.bingo.protocol.JoinMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.joinMessage);
					break;
				case 11:
					if (join_ok_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.joinOkMessage cannot be set twice.');
					}
					++join_ok_message$count;
					this.joinOkMessage = new com.alisacasino.bingo.protocol.JoinOkMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.joinOkMessage);
					break;
				case 12:
					if (leave_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.leaveMessage cannot be set twice.');
					}
					++leave_message$count;
					this.leaveMessage = new com.alisacasino.bingo.protocol.LeaveMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.leaveMessage);
					break;
				case 13:
					if (leave_ok_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.leaveOkMessage cannot be set twice.');
					}
					++leave_ok_message$count;
					this.leaveOkMessage = new com.alisacasino.bingo.protocol.LeaveOkMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.leaveOkMessage);
					break;
				case 14:
					if (player_bingoed_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.playerBingoedMessage cannot be set twice.');
					}
					++player_bingoed_message$count;
					this.playerBingoedMessage = new com.alisacasino.bingo.protocol.PlayerBingoedMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.playerBingoedMessage);
					break;
				case 15:
					if (player_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.playerMessage cannot be set twice.');
					}
					++player_message$count;
					this.playerMessage = new com.alisacasino.bingo.protocol.PlayerMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.playerMessage);
					break;
				case 16:
					if (room_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.roomMessage cannot be set twice.');
					}
					++room_message$count;
					this.roomMessage = new com.alisacasino.bingo.protocol.RoomMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.roomMessage);
					break;
				case 17:
					if (round_over_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.roundOverMessage cannot be set twice.');
					}
					++round_over_message$count;
					this.roundOverMessage = new com.alisacasino.bingo.protocol.RoundOverMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.roundOverMessage);
					break;
				case 18:
					if (round_started_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.roundStartedMessage cannot be set twice.');
					}
					++round_started_message$count;
					this.roundStartedMessage = new com.alisacasino.bingo.protocol.RoundStartedMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.roundStartedMessage);
					break;
				case 19:
					if (sign_in_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.signInMessage cannot be set twice.');
					}
					++sign_in_message$count;
					this.signInMessage = new com.alisacasino.bingo.protocol.SignInMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.signInMessage);
					break;
				case 20:
					if (sign_in_ok_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.signInOkMessage cannot be set twice.');
					}
					++sign_in_ok_message$count;
					this.signInOkMessage = new com.alisacasino.bingo.protocol.SignInOkMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.signInOkMessage);
					break;
				case 21:
					if (player_bought_cards_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.playerBoughtCardsMessage cannot be set twice.');
					}
					++player_bought_cards_message$count;
					this.playerBoughtCardsMessage = new com.alisacasino.bingo.protocol.PlayerBoughtCardsMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.playerBoughtCardsMessage);
					break;
				case 22:
					if (player_update_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.playerUpdateMessage cannot be set twice.');
					}
					++player_update_message$count;
					this.playerUpdateMessage = new com.alisacasino.bingo.protocol.PlayerUpdateMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.playerUpdateMessage);
					break;
				case 23:
					if (player_update_ok_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.playerUpdateOkMessage cannot be set twice.');
					}
					++player_update_ok_message$count;
					this.playerUpdateOkMessage = new com.alisacasino.bingo.protocol.PlayerUpdateOkMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.playerUpdateOkMessage);
					break;
				case 24:
					if (request_server_status_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.requestServerStatusMessage cannot be set twice.');
					}
					++request_server_status_message$count;
					this.requestServerStatusMessage = new com.alisacasino.bingo.protocol.RequestServerStatusMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.requestServerStatusMessage);
					break;
				case 25:
					if (server_status_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.serverStatusMessage cannot be set twice.');
					}
					++server_status_message$count;
					this.serverStatusMessage = new com.alisacasino.bingo.protocol.ServerStatusMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.serverStatusMessage);
					break;
				case 26:
					if (sentByServerTimestamp$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.sentByServerTimestamp cannot be set twice.');
					}
					++sentByServerTimestamp$count;
					this.sentByServerTimestamp = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 27:
					if (purchase_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.purchaseMessage cannot be set twice.');
					}
					++purchase_message$count;
					this.purchaseMessage = new com.alisacasino.bingo.protocol.PurchaseMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.purchaseMessage);
					break;
				case 28:
					if (purchase_ok_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.purchaseOkMessage cannot be set twice.');
					}
					++purchase_ok_message$count;
					this.purchaseOkMessage = new com.alisacasino.bingo.protocol.PurchaseOkMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.purchaseOkMessage);
					break;
				case 29:
					if (purchase_failed_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.purchaseFailedMessage cannot be set twice.');
					}
					++purchase_failed_message$count;
					this.purchaseFailedMessage = new com.alisacasino.bingo.protocol.PurchaseFailedMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.purchaseFailedMessage);
					break;
				case 30:
					if (live_event_info_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.liveEventInfoMessage cannot be set twice.');
					}
					++live_event_info_message$count;
					this.liveEventInfoMessage = new com.alisacasino.bingo.protocol.LiveEventInfoMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.liveEventInfoMessage);
					break;
				case 31:
					if (live_event_info_ok_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.liveEventInfoOkMessage cannot be set twice.');
					}
					++live_event_info_ok_message$count;
					this.liveEventInfoOkMessage = new com.alisacasino.bingo.protocol.LiveEventInfoOkMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.liveEventInfoOkMessage);
					break;
				case 32:
					if (live_event_leaderboards_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.liveEventLeaderboardsMessage cannot be set twice.');
					}
					++live_event_leaderboards_message$count;
					this.liveEventLeaderboardsMessage = new com.alisacasino.bingo.protocol.LiveEventLeaderboardsMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.liveEventLeaderboardsMessage);
					break;
				case 33:
					if (live_event_leaderboards_ok_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.liveEventLeaderboardsOkMessage cannot be set twice.');
					}
					++live_event_leaderboards_ok_message$count;
					this.liveEventLeaderboardsOkMessage = new com.alisacasino.bingo.protocol.LiveEventLeaderboardsOkMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.liveEventLeaderboardsOkMessage);
					break;
				case 34:
					if (live_event_score_update_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.liveEventScoreUpdateMessage cannot be set twice.');
					}
					++live_event_score_update_message$count;
					this.liveEventScoreUpdateMessage = new com.alisacasino.bingo.protocol.LiveEventScoreUpdateMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.liveEventScoreUpdateMessage);
					break;
				case 35:
					if (live_event_score_update_ok_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.liveEventScoreUpdateOkMessage cannot be set twice.');
					}
					++live_event_score_update_ok_message$count;
					this.liveEventScoreUpdateOkMessage = new com.alisacasino.bingo.protocol.LiveEventScoreUpdateOkMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.liveEventScoreUpdateOkMessage);
					break;
				case 36:
					if (invite_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.inviteMessage cannot be set twice.');
					}
					++invite_message$count;
					this.inviteMessage = new com.alisacasino.bingo.protocol.InviteMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.inviteMessage);
					break;
				case 37:
					if (gift_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.giftMessage cannot be set twice.');
					}
					++gift_message$count;
					this.giftMessage = new com.alisacasino.bingo.protocol.GiftMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.giftMessage);
					break;
				case 38:
					if (gift_accepted_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.giftAcceptedMessage cannot be set twice.');
					}
					++gift_accepted_message$count;
					this.giftAcceptedMessage = new com.alisacasino.bingo.protocol.GiftAcceptedMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.giftAcceptedMessage);
					break;
				case 39:
					if (claim_offer_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.claimOfferMessage cannot be set twice.');
					}
					++claim_offer_message$count;
					this.claimOfferMessage = new com.alisacasino.bingo.protocol.ClaimOfferMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.claimOfferMessage);
					break;
				case 40:
					if (claim_offer_ok_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.claimOfferOkMessage cannot be set twice.');
					}
					++claim_offer_ok_message$count;
					this.claimOfferOkMessage = new com.alisacasino.bingo.protocol.ClaimOfferOkMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.claimOfferOkMessage);
					break;
				case 41:
					if (request_unaccepted_gifts_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.requestUnacceptedGiftsMessage cannot be set twice.');
					}
					++request_unaccepted_gifts_message$count;
					this.requestUnacceptedGiftsMessage = new com.alisacasino.bingo.protocol.RequestUnacceptedGiftsMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.requestUnacceptedGiftsMessage);
					break;
				case 42:
					if (request_unaccepted_gifts_ok_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.requestUnacceptedGiftsOkMessage cannot be set twice.');
					}
					++request_unaccepted_gifts_ok_message$count;
					this.requestUnacceptedGiftsOkMessage = new com.alisacasino.bingo.protocol.RequestUnacceptedGiftsOkMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.requestUnacceptedGiftsOkMessage);
					break;
				case 43:
					if (client_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.clientMessage cannot be set twice.');
					}
					++client_message$count;
					this.clientMessage = new com.alisacasino.bingo.protocol.ClientMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.clientMessage);
					break;
				case 44:
					if (claim_offer_v2_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.claimOfferV2Message cannot be set twice.');
					}
					++claim_offer_v2_message$count;
					this.claimOfferV2Message = new com.alisacasino.bingo.protocol.ClaimOfferV2Message();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.claimOfferV2Message);
					break;
				case 45:
					if (offer_accepted_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.offerAcceptedMessage cannot be set twice.');
					}
					++offer_accepted_message$count;
					this.offerAcceptedMessage = new com.alisacasino.bingo.protocol.OfferAcceptedMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.offerAcceptedMessage);
					break;
				case 46:
					if (gifts_accepted_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.giftsAcceptedMessage cannot be set twice.');
					}
					++gifts_accepted_message$count;
					this.giftsAcceptedMessage = new com.alisacasino.bingo.protocol.GiftsAcceptedMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.giftsAcceptedMessage);
					break;
				case 47:
					if (claim_event_prize_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.claimEventPrizeMessage cannot be set twice.');
					}
					++claim_event_prize_message$count;
					this.claimEventPrizeMessage = new com.alisacasino.bingo.protocol.ClaimEventPrizeMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.claimEventPrizeMessage);
					break;
				case 48:
					if (request_incoming_items_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.requestIncomingItemsMessage cannot be set twice.');
					}
					++request_incoming_items_message$count;
					this.requestIncomingItemsMessage = new com.alisacasino.bingo.protocol.RequestIncomingItemsMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.requestIncomingItemsMessage);
					break;
				case 49:
					if (request_incoming_items_ok_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.requestIncomingItemsOkMessage cannot be set twice.');
					}
					++request_incoming_items_ok_message$count;
					this.requestIncomingItemsOkMessage = new com.alisacasino.bingo.protocol.RequestIncomingItemsOkMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.requestIncomingItemsOkMessage);
					break;
				case 50:
					if (static_version$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.staticVersion cannot be set twice.');
					}
					++static_version$count;
					this.staticVersion = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 51:
					if (protocol_version$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.protocolVersion cannot be set twice.');
					}
					++protocol_version$count;
					this.protocolVersion = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 52:
					if (save_client_data_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.saveClientDataMessage cannot be set twice.');
					}
					++save_client_data_message$count;
					this.saveClientDataMessage = new com.alisacasino.bingo.protocol.SaveClientDataMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.saveClientDataMessage);
					break;
				case 53:
					if (round_state_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.roundStateMessage cannot be set twice.');
					}
					++round_state_message$count;
					this.roundStateMessage = new com.alisacasino.bingo.protocol.RoundStateMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.roundStateMessage);
					break;
				case 55:
					if (tournament_end_message$count != 0) {
						throw new flash.errors.IOError('Bad data format: BaseMessage.tournamentEndMessage cannot be set twice.');
					}
					++tournament_end_message$count;
					this.tournamentEndMessage = new com.alisacasino.bingo.protocol.TournamentEndMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.tournamentEndMessage);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
