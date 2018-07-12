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
	import com.alisacasino.bingo.protocol.PlayerMessage.Gender;
	import com.alisacasino.bingo.protocol.ChestSlotMessage;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.PlayerItemMessage;
	import com.alisacasino.bingo.protocol.PlayerCustomizationSettingsMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class PlayerMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const PLAYER_ID:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.PlayerMessage.player_id", "playerId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var playerId:UInt64;

		/**
		 *  @private
		 */
		public static const AVATAR:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.PlayerMessage.avatar", "avatar", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var avatar$field:String;

		public function clearAvatar():void {
			avatar$field = null;
		}

		public function get hasAvatar():Boolean {
			return avatar$field != null;
		}

		public function set avatar(value:String):void {
			avatar$field = value;
		}

		public function get avatar():String {
			return avatar$field;
		}

		/**
		 *  @private
		 */
		public static const FIRST_NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.PlayerMessage.first_name", "firstName", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var first_name$field:String;

		public function clearFirstName():void {
			first_name$field = null;
		}

		public function get hasFirstName():Boolean {
			return first_name$field != null;
		}

		public function set firstName(value:String):void {
			first_name$field = value;
		}

		public function get firstName():String {
			return first_name$field;
		}

		/**
		 *  @private
		 */
		public static const LAST_NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.PlayerMessage.last_name", "lastName", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var last_name$field:String;

		public function clearLastName():void {
			last_name$field = null;
		}

		public function get hasLastName():Boolean {
			return last_name$field != null;
		}

		public function set lastName(value:String):void {
			last_name$field = value;
		}

		public function get lastName():String {
			return last_name$field;
		}

		/**
		 *  @private
		 */
		public static const NICK_NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.PlayerMessage.nick_name", "nickName", (5 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var nick_name$field:String;

		public function clearNickName():void {
			nick_name$field = null;
		}

		public function get hasNickName():Boolean {
			return nick_name$field != null;
		}

		public function set nickName(value:String):void {
			nick_name$field = value;
		}

		public function get nickName():String {
			return nick_name$field;
		}

		/**
		 *  @private
		 */
		public static const XP_COUNT:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.PlayerMessage.xp_count", "xpCount", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		private var xp_count$field:uint;

		private var hasField$0:uint = 0;

		public function clearXpCount():void {
			hasField$0 &= 0xfffffffe;
			xp_count$field = new uint();
		}

		public function get hasXpCount():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set xpCount(value:uint):void {
			hasField$0 |= 0x1;
			xp_count$field = value;
		}

		public function get xpCount():uint {
			return xp_count$field;
		}

		/**
		 *  @private
		 */
		public static const XP_LEVEL:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.PlayerMessage.xp_level", "xpLevel", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		private var xp_level$field:uint;

		public function clearXpLevel():void {
			hasField$0 &= 0xfffffffd;
			xp_level$field = new uint();
		}

		public function get hasXpLevel():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set xpLevel(value:uint):void {
			hasField$0 |= 0x2;
			xp_level$field = value;
		}

		public function get xpLevel():uint {
			return xp_level$field;
		}

		/**
		 *  @private
		 */
		public static const TICKETS_COUNT:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.PlayerMessage.tickets_count", "ticketsCount", (8 << 3) | com.netease.protobuf.WireType.VARINT);

		private var tickets_count$field:uint;

		public function clearTicketsCount():void {
			hasField$0 &= 0xfffffffb;
			tickets_count$field = new uint();
		}

		public function get hasTicketsCount():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set ticketsCount(value:uint):void {
			hasField$0 |= 0x4;
			tickets_count$field = value;
		}

		public function get ticketsCount():uint {
			return tickets_count$field;
		}

		/**
		 *  @private
		 */
		public static const COINS_COUNT:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.PlayerMessage.coins_count", "coinsCount", (9 << 3) | com.netease.protobuf.WireType.VARINT);

		private var coins_count$field:uint;

		public function clearCoinsCount():void {
			hasField$0 &= 0xfffffff7;
			coins_count$field = new uint();
		}

		public function get hasCoinsCount():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set coinsCount(value:uint):void {
			hasField$0 |= 0x8;
			coins_count$field = value;
		}

		public function get coinsCount():uint {
			return coins_count$field;
		}

		/**
		 *  @private
		 */
		public static const ENERGY_COUNT:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.PlayerMessage.energy_count", "energyCount", (10 << 3) | com.netease.protobuf.WireType.VARINT);

		private var energy_count$field:uint;

		public function clearEnergyCount():void {
			hasField$0 &= 0xffffffef;
			energy_count$field = new uint();
		}

		public function get hasEnergyCount():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set energyCount(value:uint):void {
			hasField$0 |= 0x10;
			energy_count$field = value;
		}

		public function get energyCount():uint {
			return energy_count$field;
		}

		/**
		 *  @private
		 */
		public static const BINGOS_COUNT:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.PlayerMessage.bingos_count", "bingosCount", (11 << 3) | com.netease.protobuf.WireType.VARINT);

		private var bingos_count$field:uint;

		public function clearBingosCount():void {
			hasField$0 &= 0xffffffdf;
			bingos_count$field = new uint();
		}

		public function get hasBingosCount():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set bingosCount(value:uint):void {
			hasField$0 |= 0x20;
			bingos_count$field = value;
		}

		public function get bingosCount():uint {
			return bingos_count$field;
		}

		/**
		 *  @private
		 */
		public static const DAUBS_COUNT:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.PlayerMessage.daubs_count", "daubsCount", (12 << 3) | com.netease.protobuf.WireType.VARINT);

		private var daubs_count$field:uint;

		public function clearDaubsCount():void {
			hasField$0 &= 0xffffffbf;
			daubs_count$field = new uint();
		}

		public function get hasDaubsCount():Boolean {
			return (hasField$0 & 0x40) != 0;
		}

		public function set daubsCount(value:uint):void {
			hasField$0 |= 0x40;
			daubs_count$field = value;
		}

		public function get daubsCount():uint {
			return daubs_count$field;
		}

		/**
		 *  @private
		 */
		public static const GAMES_COUNT:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.PlayerMessage.games_count", "gamesCount", (13 << 3) | com.netease.protobuf.WireType.VARINT);

		private var games_count$field:uint;

		public function clearGamesCount():void {
			hasField$0 &= 0xffffff7f;
			games_count$field = new uint();
		}

		public function get hasGamesCount():Boolean {
			return (hasField$0 & 0x80) != 0;
		}

		public function set gamesCount(value:uint):void {
			hasField$0 |= 0x80;
			games_count$field = value;
		}

		public function get gamesCount():uint {
			return games_count$field;
		}

		/**
		 *  @private
		 */
		public static const POWERUPS_USED_COUNT:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.PlayerMessage.powerups_used_count", "powerupsUsedCount", (14 << 3) | com.netease.protobuf.WireType.VARINT);

		private var powerups_used_count$field:uint;

		public function clearPowerupsUsedCount():void {
			hasField$0 &= 0xfffffeff;
			powerups_used_count$field = new uint();
		}

		public function get hasPowerupsUsedCount():Boolean {
			return (hasField$0 & 0x100) != 0;
		}

		public function set powerupsUsedCount(value:uint):void {
			hasField$0 |= 0x100;
			powerups_used_count$field = value;
		}

		public function get powerupsUsedCount():uint {
			return powerups_used_count$field;
		}

		/**
		 *  @private
		 */
		public static const COMPLETED_OBJECTIVES:RepeatedFieldDescriptor$TYPE_STRING = new RepeatedFieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.PlayerMessage.completed_objectives", "completedObjectives", (15 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		[ArrayElementType("String")]
		public var completedObjectives:Array = [];

		/**
		 *  @private
		 */
		public static const GENDER:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.alisacasino.bingo.protocol.PlayerMessage.gender", "gender", (16 << 3) | com.netease.protobuf.WireType.VARINT, com.alisacasino.bingo.protocol.PlayerMessage.Gender);

		private var gender$field:int;

		public function clearGender():void {
			hasField$0 &= 0xfffffdff;
			gender$field = new int();
		}

		public function get hasGender():Boolean {
			return (hasField$0 & 0x200) != 0;
		}

		public function set gender(value:int):void {
			hasField$0 |= 0x200;
			gender$field = value;
		}

		public function get gender():int {
			return gender$field;
		}

		/**
		 *  @private
		 */
		public static const COUNTRY:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.PlayerMessage.country", "country", (17 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var country$field:String;

		public function clearCountry():void {
			country$field = null;
		}

		public function get hasCountry():Boolean {
			return country$field != null;
		}

		public function set country(value:String):void {
			country$field = value;
		}

		public function get country():String {
			return country$field;
		}

		/**
		 *  @private
		 */
		public static const BONUS_USED_TIMESTAMP:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.PlayerMessage.bonus_used_timestamp", "bonusUsedTimestamp", (18 << 3) | com.netease.protobuf.WireType.VARINT);

		private var bonus_used_timestamp$field:UInt64;

		public function clearBonusUsedTimestamp():void {
			bonus_used_timestamp$field = null;
		}

		public function get hasBonusUsedTimestamp():Boolean {
			return bonus_used_timestamp$field != null;
		}

		public function set bonusUsedTimestamp(value:UInt64):void {
			bonus_used_timestamp$field = value;
		}

		public function get bonusUsedTimestamp():UInt64 {
			return bonus_used_timestamp$field;
		}

		/**
		 *  @private
		 */
		public static const LIFETIME:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.PlayerMessage.lifetime", "lifetime", (19 << 3) | com.netease.protobuf.WireType.VARINT);

		private var lifetime$field:uint;

		public function clearLifetime():void {
			hasField$0 &= 0xfffffbff;
			lifetime$field = new uint();
		}

		public function get hasLifetime():Boolean {
			return (hasField$0 & 0x400) != 0;
		}

		public function set lifetime(value:uint):void {
			hasField$0 |= 0x400;
			lifetime$field = value;
		}

		public function get lifetime():uint {
			return lifetime$field;
		}

		/**
		 *  @private
		 */
		public static const LIFETIME_VALUE:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.PlayerMessage.lifetime_value", "lifetimeValue", (20 << 3) | com.netease.protobuf.WireType.VARINT);

		private var lifetime_value$field:uint;

		public function clearLifetimeValue():void {
			hasField$0 &= 0xfffff7ff;
			lifetime_value$field = new uint();
		}

		public function get hasLifetimeValue():Boolean {
			return (hasField$0 & 0x800) != 0;
		}

		public function set lifetimeValue(value:uint):void {
			hasField$0 |= 0x800;
			lifetime_value$field = value;
		}

		public function get lifetimeValue():uint {
			return lifetime_value$field;
		}

		/**
		 *  @private
		 */
		public static const KEYS_COUNT:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.PlayerMessage.keys_count", "keysCount", (21 << 3) | com.netease.protobuf.WireType.VARINT);

		private var keys_count$field:uint;

		public function clearKeysCount():void {
			hasField$0 &= 0xffffefff;
			keys_count$field = new uint();
		}

		public function get hasKeysCount():Boolean {
			return (hasField$0 & 0x1000) != 0;
		}

		public function set keysCount(value:uint):void {
			hasField$0 |= 0x1000;
			keys_count$field = value;
		}

		public function get keysCount():uint {
			return keys_count$field;
		}

		/**
		 *  @private
		 */
		public static const MAGICBOXES_OPENED_COUNT:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.PlayerMessage.magicboxes_opened_count", "magicboxesOpenedCount", (22 << 3) | com.netease.protobuf.WireType.VARINT);

		private var magicboxes_opened_count$field:uint;

		public function clearMagicboxesOpenedCount():void {
			hasField$0 &= 0xffffdfff;
			magicboxes_opened_count$field = new uint();
		}

		public function get hasMagicboxesOpenedCount():Boolean {
			return (hasField$0 & 0x2000) != 0;
		}

		public function set magicboxesOpenedCount(value:uint):void {
			hasField$0 |= 0x2000;
			magicboxes_opened_count$field = value;
		}

		public function get magicboxesOpenedCount():uint {
			return magicboxes_opened_count$field;
		}

		/**
		 *  @private
		 */
		public static const INVITES_SENT_COUNT:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.PlayerMessage.invites_sent_count", "invitesSentCount", (24 << 3) | com.netease.protobuf.WireType.VARINT);

		private var invites_sent_count$field:uint;

		public function clearInvitesSentCount():void {
			hasField$0 &= 0xffffbfff;
			invites_sent_count$field = new uint();
		}

		public function get hasInvitesSentCount():Boolean {
			return (hasField$0 & 0x4000) != 0;
		}

		public function set invitesSentCount(value:uint):void {
			hasField$0 |= 0x4000;
			invites_sent_count$field = value;
		}

		public function get invitesSentCount():uint {
			return invites_sent_count$field;
		}

		/**
		 *  @private
		 */
		public static const CHECK_SUM:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.PlayerMessage.check_sum", "checkSum", (25 << 3) | com.netease.protobuf.WireType.VARINT);

		private var check_sum$field:uint;

		public function clearCheckSum():void {
			hasField$0 &= 0xffff7fff;
			check_sum$field = new uint();
		}

		public function get hasCheckSum():Boolean {
			return (hasField$0 & 0x8000) != 0;
		}

		public function set checkSum(value:uint):void {
			hasField$0 |= 0x8000;
			check_sum$field = value;
		}

		public function get checkSum():uint {
			return check_sum$field;
		}

		/**
		 *  @private
		 */
		public static const PLATFORM:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.alisacasino.bingo.protocol.PlayerMessage.platform", "platform", (26 << 3) | com.netease.protobuf.WireType.VARINT, com.alisacasino.bingo.protocol.SignInMessage.Platform);

		private var platform$field:int;

		public function clearPlatform():void {
			hasField$0 &= 0xfffeffff;
			platform$field = new int();
		}

		public function get hasPlatform():Boolean {
			return (hasField$0 & 0x10000) != 0;
		}

		public function set platform(value:int):void {
			hasField$0 |= 0x10000;
			platform$field = value;
		}

		public function get platform():int {
			return platform$field;
		}

		/**
		 *  @private
		 */
		public static const FACEBOOK_ID_STRING:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.PlayerMessage.facebook_id_string", "facebookIdString", (27 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

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
		public static const FREE_SPIN_TIMESTAMP:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.PlayerMessage.free_spin_timestamp", "freeSpinTimestamp", (28 << 3) | com.netease.protobuf.WireType.VARINT);

		private var free_spin_timestamp$field:UInt64;

		public function clearFreeSpinTimestamp():void {
			free_spin_timestamp$field = null;
		}

		public function get hasFreeSpinTimestamp():Boolean {
			return free_spin_timestamp$field != null;
		}

		public function set freeSpinTimestamp(value:UInt64):void {
			free_spin_timestamp$field = value;
		}

		public function get freeSpinTimestamp():UInt64 {
			return free_spin_timestamp$field;
		}

		/**
		 *  @private
		 */
		public static const SPIN_0_COUNT:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.PlayerMessage.spin_0_count", "spin_0Count", (29 << 3) | com.netease.protobuf.WireType.VARINT);

		private var spin_0_count$field:uint;

		public function clearSpin_0Count():void {
			hasField$0 &= 0xfffdffff;
			spin_0_count$field = new uint();
		}

		public function get hasSpin_0Count():Boolean {
			return (hasField$0 & 0x20000) != 0;
		}

		public function set spin_0Count(value:uint):void {
			hasField$0 |= 0x20000;
			spin_0_count$field = value;
		}

		public function get spin_0Count():uint {
			return spin_0_count$field;
		}

		/**
		 *  @private
		 */
		public static const SPIN_1_COUNT:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.PlayerMessage.spin_1_count", "spin_1Count", (30 << 3) | com.netease.protobuf.WireType.VARINT);

		private var spin_1_count$field:uint;

		public function clearSpin_1Count():void {
			hasField$0 &= 0xfffbffff;
			spin_1_count$field = new uint();
		}

		public function get hasSpin_1Count():Boolean {
			return (hasField$0 & 0x40000) != 0;
		}

		public function set spin_1Count(value:uint):void {
			hasField$0 |= 0x40000;
			spin_1_count$field = value;
		}

		public function get spin_1Count():uint {
			return spin_1_count$field;
		}

		/**
		 *  @private
		 */
		public static const SPIN_2_COUNT:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.PlayerMessage.spin_2_count", "spin_2Count", (31 << 3) | com.netease.protobuf.WireType.VARINT);

		private var spin_2_count$field:uint;

		public function clearSpin_2Count():void {
			hasField$0 &= 0xfff7ffff;
			spin_2_count$field = new uint();
		}

		public function get hasSpin_2Count():Boolean {
			return (hasField$0 & 0x80000) != 0;
		}

		public function set spin_2Count(value:uint):void {
			hasField$0 |= 0x80000;
			spin_2_count$field = value;
		}

		public function get spin_2Count():uint {
			return spin_2_count$field;
		}

		/**
		 *  @private
		 */
		public static const SPIN_3_COUNT:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.PlayerMessage.spin_3_count", "spin_3Count", (32 << 3) | com.netease.protobuf.WireType.VARINT);

		private var spin_3_count$field:uint;

		public function clearSpin_3Count():void {
			hasField$0 &= 0xffefffff;
			spin_3_count$field = new uint();
		}

		public function get hasSpin_3Count():Boolean {
			return (hasField$0 & 0x100000) != 0;
		}

		public function set spin_3Count(value:uint):void {
			hasField$0 |= 0x100000;
			spin_3_count$field = value;
		}

		public function get spin_3Count():uint {
			return spin_3_count$field;
		}

		/**
		 *  @private
		 */
		public static const SPIN_4_COUNT:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.PlayerMessage.spin_4_count", "spin_4Count", (33 << 3) | com.netease.protobuf.WireType.VARINT);

		private var spin_4_count$field:uint;

		public function clearSpin_4Count():void {
			hasField$0 &= 0xffdfffff;
			spin_4_count$field = new uint();
		}

		public function get hasSpin_4Count():Boolean {
			return (hasField$0 & 0x200000) != 0;
		}

		public function set spin_4Count(value:uint):void {
			hasField$0 |= 0x200000;
			spin_4_count$field = value;
		}

		public function get spin_4Count():uint {
			return spin_4_count$field;
		}

		/**
		 *  @private
		 */
		public static const LAST_GIFT_ACCEPTED_TIMESTAMP_MILLIS:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.PlayerMessage.last_gift_accepted_timestamp_millis", "lastGiftAcceptedTimestampMillis", (34 << 3) | com.netease.protobuf.WireType.VARINT);

		private var last_gift_accepted_timestamp_millis$field:UInt64;

		public function clearLastGiftAcceptedTimestampMillis():void {
			last_gift_accepted_timestamp_millis$field = null;
		}

		public function get hasLastGiftAcceptedTimestampMillis():Boolean {
			return last_gift_accepted_timestamp_millis$field != null;
		}

		public function set lastGiftAcceptedTimestampMillis(value:UInt64):void {
			last_gift_accepted_timestamp_millis$field = value;
		}

		public function get lastGiftAcceptedTimestampMillis():UInt64 {
			return last_gift_accepted_timestamp_millis$field;
		}

		/**
		 *  @private
		 */
		public static const PERIODIC_BONUS_TIME_MILLIS:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.PlayerMessage.periodic_bonus_time_millis", "periodicBonusTimeMillis", (39 << 3) | com.netease.protobuf.WireType.VARINT);

		private var periodic_bonus_time_millis$field:UInt64;

		public function clearPeriodicBonusTimeMillis():void {
			periodic_bonus_time_millis$field = null;
		}

		public function get hasPeriodicBonusTimeMillis():Boolean {
			return periodic_bonus_time_millis$field != null;
		}

		public function set periodicBonusTimeMillis(value:UInt64):void {
			periodic_bonus_time_millis$field = value;
		}

		public function get periodicBonusTimeMillis():UInt64 {
			return periodic_bonus_time_millis$field;
		}

		/**
		 *  @private
		 */
		public static const GIFTS_ACCEPTED_IN_SESSION_COUNT:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.PlayerMessage.gifts_accepted_in_session_count", "giftsAcceptedInSessionCount", (35 << 3) | com.netease.protobuf.WireType.VARINT);

		private var gifts_accepted_in_session_count$field:uint;

		public function clearGiftsAcceptedInSessionCount():void {
			hasField$0 &= 0xffbfffff;
			gifts_accepted_in_session_count$field = new uint();
		}

		public function get hasGiftsAcceptedInSessionCount():Boolean {
			return (hasField$0 & 0x400000) != 0;
		}

		public function set giftsAcceptedInSessionCount(value:uint):void {
			hasField$0 |= 0x400000;
			gifts_accepted_in_session_count$field = value;
		}

		public function get giftsAcceptedInSessionCount():uint {
			return gifts_accepted_in_session_count$field;
		}

		/**
		 *  @private
		 */
		public static const DEVICE_TOKEN:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.PlayerMessage.device_token", "deviceToken", (36 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var device_token$field:String;

		public function clearDeviceToken():void {
			device_token$field = null;
		}

		public function get hasDeviceToken():Boolean {
			return device_token$field != null;
		}

		public function set deviceToken(value:String):void {
			device_token$field = value;
		}

		public function get deviceToken():String {
			return device_token$field;
		}

		/**
		 *  @private
		 */
		public static const ACCOUNT:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.PlayerMessage.account", "account", (37 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.CommodityItemMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.CommodityItemMessage")]
		public var account:Array = [];

		/**
		 *  @private
		 */
		public static const ITEMS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.PlayerMessage.items", "items", (38 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PlayerItemMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.PlayerItemMessage")]
		public var items:Array = [];

		/**
		 *  @private
		 */
		public static const CHEST_SLOTS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.PlayerMessage.chest_slots", "chestSlots", (40 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.ChestSlotMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.ChestSlotMessage")]
		public var chestSlots:Array = [];

		/**
		 *  @private
		 */
		public static const FIRST_PLACE_COUNT:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.PlayerMessage.first_place_count", "firstPlaceCount", (41 << 3) | com.netease.protobuf.WireType.VARINT);

		private var first_place_count$field:uint;

		public function clearFirstPlaceCount():void {
			hasField$0 &= 0xff7fffff;
			first_place_count$field = new uint();
		}

		public function get hasFirstPlaceCount():Boolean {
			return (hasField$0 & 0x800000) != 0;
		}

		public function set firstPlaceCount(value:uint):void {
			hasField$0 |= 0x800000;
			first_place_count$field = value;
		}

		public function get firstPlaceCount():uint {
			return first_place_count$field;
		}

		/**
		 *  @private
		 */
		public static const SECOND_PLACE_COUNT:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.PlayerMessage.second_place_count", "secondPlaceCount", (42 << 3) | com.netease.protobuf.WireType.VARINT);

		private var second_place_count$field:uint;

		public function clearSecondPlaceCount():void {
			hasField$0 &= 0xfeffffff;
			second_place_count$field = new uint();
		}

		public function get hasSecondPlaceCount():Boolean {
			return (hasField$0 & 0x1000000) != 0;
		}

		public function set secondPlaceCount(value:uint):void {
			hasField$0 |= 0x1000000;
			second_place_count$field = value;
		}

		public function get secondPlaceCount():uint {
			return second_place_count$field;
		}

		/**
		 *  @private
		 */
		public static const THIRD_PLACE_COUNT:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.PlayerMessage.third_place_count", "thirdPlaceCount", (43 << 3) | com.netease.protobuf.WireType.VARINT);

		private var third_place_count$field:uint;

		public function clearThirdPlaceCount():void {
			hasField$0 &= 0xfdffffff;
			third_place_count$field = new uint();
		}

		public function get hasThirdPlaceCount():Boolean {
			return (hasField$0 & 0x2000000) != 0;
		}

		public function set thirdPlaceCount(value:uint):void {
			hasField$0 |= 0x2000000;
			third_place_count$field = value;
		}

		public function get thirdPlaceCount():uint {
			return third_place_count$field;
		}

		/**
		 *  @private
		 */
		public static const OPEN_CHESTS_COUNT:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.PlayerMessage.open_chests_count", "openChestsCount", (44 << 3) | com.netease.protobuf.WireType.VARINT);

		private var open_chests_count$field:uint;

		public function clearOpenChestsCount():void {
			hasField$0 &= 0xfbffffff;
			open_chests_count$field = new uint();
		}

		public function get hasOpenChestsCount():Boolean {
			return (hasField$0 & 0x4000000) != 0;
		}

		public function set openChestsCount(value:uint):void {
			hasField$0 |= 0x4000000;
			open_chests_count$field = value;
		}

		public function get openChestsCount():uint {
			return open_chests_count$field;
		}

		/**
		 *  @private
		 */
		public static const PUSH_TOKEN:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.PlayerMessage.push_token", "pushToken", (45 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var push_token$field:String;

		public function clearPushToken():void {
			push_token$field = null;
		}

		public function get hasPushToken():Boolean {
			return push_token$field != null;
		}

		public function set pushToken(value:String):void {
			push_token$field = value;
		}

		public function get pushToken():String {
			return push_token$field;
		}

		/**
		 *  @private
		 */
		public static const ACCESS_LEVEL:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.PlayerMessage.access_level", "accessLevel", (46 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var access_level$field:String;

		public function clearAccessLevel():void {
			access_level$field = null;
		}

		public function get hasAccessLevel():Boolean {
			return access_level$field != null;
		}

		public function set accessLevel(value:String):void {
			access_level$field = value;
		}

		public function get accessLevel():String {
			return access_level$field;
		}

		/**
		 *  @private
		 */
		public static const INSTALLTRACKINGDATA:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.PlayerMessage.installTrackingData", "installTrackingData", (47 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var installTrackingData$field:String;

		public function clearInstallTrackingData():void {
			installTrackingData$field = null;
		}

		public function get hasInstallTrackingData():Boolean {
			return installTrackingData$field != null;
		}

		public function set installTrackingData(value:String):void {
			installTrackingData$field = value;
		}

		public function get installTrackingData():String {
			return installTrackingData$field;
		}

		/**
		 *  @private
		 */
		public static const OPENTRACKINGDATA:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.PlayerMessage.openTrackingData", "openTrackingData", (48 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var openTrackingData$field:String;

		public function clearOpenTrackingData():void {
			openTrackingData$field = null;
		}

		public function get hasOpenTrackingData():Boolean {
			return openTrackingData$field != null;
		}

		public function set openTrackingData(value:String):void {
			openTrackingData$field = value;
		}

		public function get openTrackingData():String {
			return openTrackingData$field;
		}

		/**
		 *  @private
		 */
		public static const CUSTOMIZATIONSETTINGS:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.PlayerMessage.customizationSettings", "customizationSettings", (49 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PlayerCustomizationSettingsMessage; });

		private var customizationSettings$field:com.alisacasino.bingo.protocol.PlayerCustomizationSettingsMessage;

		public function clearCustomizationSettings():void {
			customizationSettings$field = null;
		}

		public function get hasCustomizationSettings():Boolean {
			return customizationSettings$field != null;
		}

		public function set customizationSettings(value:com.alisacasino.bingo.protocol.PlayerCustomizationSettingsMessage):void {
			customizationSettings$field = value;
		}

		public function get customizationSettings():com.alisacasino.bingo.protocol.PlayerCustomizationSettingsMessage {
			return customizationSettings$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, this.playerId);
			if (hasAvatar) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, avatar$field);
			}
			if (hasFirstName) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, first_name$field);
			}
			if (hasLastName) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, last_name$field);
			}
			if (hasNickName) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, nick_name$field);
			}
			if (hasXpCount) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, xp_count$field);
			}
			if (hasXpLevel) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, xp_level$field);
			}
			if (hasTicketsCount) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, tickets_count$field);
			}
			if (hasCoinsCount) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 9);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, coins_count$field);
			}
			if (hasEnergyCount) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 10);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, energy_count$field);
			}
			if (hasBingosCount) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 11);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, bingos_count$field);
			}
			if (hasDaubsCount) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 12);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, daubs_count$field);
			}
			if (hasGamesCount) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 13);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, games_count$field);
			}
			if (hasPowerupsUsedCount) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 14);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, powerups_used_count$field);
			}
			for (var completedObjectives$index:uint = 0; completedObjectives$index < this.completedObjectives.length; ++completedObjectives$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 15);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.completedObjectives[completedObjectives$index]);
			}
			if (hasGender) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 16);
				com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, gender$field);
			}
			if (hasCountry) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 17);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, country$field);
			}
			if (hasBonusUsedTimestamp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 18);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, bonus_used_timestamp$field);
			}
			if (hasLifetime) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 19);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, lifetime$field);
			}
			if (hasLifetimeValue) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 20);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, lifetime_value$field);
			}
			if (hasKeysCount) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 21);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, keys_count$field);
			}
			if (hasMagicboxesOpenedCount) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 22);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, magicboxes_opened_count$field);
			}
			if (hasInvitesSentCount) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 24);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, invites_sent_count$field);
			}
			if (hasCheckSum) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 25);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, check_sum$field);
			}
			if (hasPlatform) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 26);
				com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, platform$field);
			}
			if (hasFacebookIdString) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 27);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, facebook_id_string$field);
			}
			if (hasFreeSpinTimestamp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 28);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, free_spin_timestamp$field);
			}
			if (hasSpin_0Count) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 29);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, spin_0_count$field);
			}
			if (hasSpin_1Count) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 30);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, spin_1_count$field);
			}
			if (hasSpin_2Count) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 31);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, spin_2_count$field);
			}
			if (hasSpin_3Count) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 32);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, spin_3_count$field);
			}
			if (hasSpin_4Count) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 33);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, spin_4_count$field);
			}
			if (hasLastGiftAcceptedTimestampMillis) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 34);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, last_gift_accepted_timestamp_millis$field);
			}
			if (hasPeriodicBonusTimeMillis) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 39);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, periodic_bonus_time_millis$field);
			}
			if (hasGiftsAcceptedInSessionCount) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 35);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, gifts_accepted_in_session_count$field);
			}
			if (hasDeviceToken) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 36);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, device_token$field);
			}
			for (var account$index:uint = 0; account$index < this.account.length; ++account$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 37);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.account[account$index]);
			}
			for (var items$index:uint = 0; items$index < this.items.length; ++items$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 38);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.items[items$index]);
			}
			for (var chestSlots$index:uint = 0; chestSlots$index < this.chestSlots.length; ++chestSlots$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 40);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.chestSlots[chestSlots$index]);
			}
			if (hasFirstPlaceCount) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 41);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, first_place_count$field);
			}
			if (hasSecondPlaceCount) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 42);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, second_place_count$field);
			}
			if (hasThirdPlaceCount) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 43);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, third_place_count$field);
			}
			if (hasOpenChestsCount) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 44);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, open_chests_count$field);
			}
			if (hasPushToken) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 45);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, push_token$field);
			}
			if (hasAccessLevel) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 46);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, access_level$field);
			}
			if (hasInstallTrackingData) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 47);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, installTrackingData$field);
			}
			if (hasOpenTrackingData) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 48);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, openTrackingData$field);
			}
			if (hasCustomizationSettings) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 49);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, customizationSettings$field);
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
			var avatar$count:uint = 0;
			var first_name$count:uint = 0;
			var last_name$count:uint = 0;
			var nick_name$count:uint = 0;
			var xp_count$count:uint = 0;
			var xp_level$count:uint = 0;
			var tickets_count$count:uint = 0;
			var coins_count$count:uint = 0;
			var energy_count$count:uint = 0;
			var bingos_count$count:uint = 0;
			var daubs_count$count:uint = 0;
			var games_count$count:uint = 0;
			var powerups_used_count$count:uint = 0;
			var gender$count:uint = 0;
			var country$count:uint = 0;
			var bonus_used_timestamp$count:uint = 0;
			var lifetime$count:uint = 0;
			var lifetime_value$count:uint = 0;
			var keys_count$count:uint = 0;
			var magicboxes_opened_count$count:uint = 0;
			var invites_sent_count$count:uint = 0;
			var check_sum$count:uint = 0;
			var platform$count:uint = 0;
			var facebook_id_string$count:uint = 0;
			var free_spin_timestamp$count:uint = 0;
			var spin_0_count$count:uint = 0;
			var spin_1_count$count:uint = 0;
			var spin_2_count$count:uint = 0;
			var spin_3_count$count:uint = 0;
			var spin_4_count$count:uint = 0;
			var last_gift_accepted_timestamp_millis$count:uint = 0;
			var periodic_bonus_time_millis$count:uint = 0;
			var gifts_accepted_in_session_count$count:uint = 0;
			var device_token$count:uint = 0;
			var first_place_count$count:uint = 0;
			var second_place_count$count:uint = 0;
			var third_place_count$count:uint = 0;
			var open_chests_count$count:uint = 0;
			var push_token$count:uint = 0;
			var access_level$count:uint = 0;
			var installTrackingData$count:uint = 0;
			var openTrackingData$count:uint = 0;
			var customizationSettings$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (player_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.playerId cannot be set twice.');
					}
					++player_id$count;
					this.playerId = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 2:
					if (avatar$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.avatar cannot be set twice.');
					}
					++avatar$count;
					this.avatar = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (first_name$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.firstName cannot be set twice.');
					}
					++first_name$count;
					this.firstName = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (last_name$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.lastName cannot be set twice.');
					}
					++last_name$count;
					this.lastName = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 5:
					if (nick_name$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.nickName cannot be set twice.');
					}
					++nick_name$count;
					this.nickName = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 6:
					if (xp_count$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.xpCount cannot be set twice.');
					}
					++xp_count$count;
					this.xpCount = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 7:
					if (xp_level$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.xpLevel cannot be set twice.');
					}
					++xp_level$count;
					this.xpLevel = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 8:
					if (tickets_count$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.ticketsCount cannot be set twice.');
					}
					++tickets_count$count;
					this.ticketsCount = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 9:
					if (coins_count$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.coinsCount cannot be set twice.');
					}
					++coins_count$count;
					this.coinsCount = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 10:
					if (energy_count$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.energyCount cannot be set twice.');
					}
					++energy_count$count;
					this.energyCount = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 11:
					if (bingos_count$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.bingosCount cannot be set twice.');
					}
					++bingos_count$count;
					this.bingosCount = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 12:
					if (daubs_count$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.daubsCount cannot be set twice.');
					}
					++daubs_count$count;
					this.daubsCount = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 13:
					if (games_count$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.gamesCount cannot be set twice.');
					}
					++games_count$count;
					this.gamesCount = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 14:
					if (powerups_used_count$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.powerupsUsedCount cannot be set twice.');
					}
					++powerups_used_count$count;
					this.powerupsUsedCount = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 15:
					this.completedObjectives.push(com.netease.protobuf.ReadUtils.read$TYPE_STRING(input));
					break;
				case 16:
					if (gender$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.gender cannot be set twice.');
					}
					++gender$count;
					this.gender = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 17:
					if (country$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.country cannot be set twice.');
					}
					++country$count;
					this.country = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 18:
					if (bonus_used_timestamp$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.bonusUsedTimestamp cannot be set twice.');
					}
					++bonus_used_timestamp$count;
					this.bonusUsedTimestamp = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 19:
					if (lifetime$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.lifetime cannot be set twice.');
					}
					++lifetime$count;
					this.lifetime = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 20:
					if (lifetime_value$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.lifetimeValue cannot be set twice.');
					}
					++lifetime_value$count;
					this.lifetimeValue = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 21:
					if (keys_count$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.keysCount cannot be set twice.');
					}
					++keys_count$count;
					this.keysCount = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 22:
					if (magicboxes_opened_count$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.magicboxesOpenedCount cannot be set twice.');
					}
					++magicboxes_opened_count$count;
					this.magicboxesOpenedCount = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 24:
					if (invites_sent_count$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.invitesSentCount cannot be set twice.');
					}
					++invites_sent_count$count;
					this.invitesSentCount = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 25:
					if (check_sum$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.checkSum cannot be set twice.');
					}
					++check_sum$count;
					this.checkSum = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 26:
					if (platform$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.platform cannot be set twice.');
					}
					++platform$count;
					this.platform = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 27:
					if (facebook_id_string$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.facebookIdString cannot be set twice.');
					}
					++facebook_id_string$count;
					this.facebookIdString = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 28:
					if (free_spin_timestamp$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.freeSpinTimestamp cannot be set twice.');
					}
					++free_spin_timestamp$count;
					this.freeSpinTimestamp = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 29:
					if (spin_0_count$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.spin_0Count cannot be set twice.');
					}
					++spin_0_count$count;
					this.spin_0Count = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 30:
					if (spin_1_count$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.spin_1Count cannot be set twice.');
					}
					++spin_1_count$count;
					this.spin_1Count = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 31:
					if (spin_2_count$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.spin_2Count cannot be set twice.');
					}
					++spin_2_count$count;
					this.spin_2Count = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 32:
					if (spin_3_count$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.spin_3Count cannot be set twice.');
					}
					++spin_3_count$count;
					this.spin_3Count = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 33:
					if (spin_4_count$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.spin_4Count cannot be set twice.');
					}
					++spin_4_count$count;
					this.spin_4Count = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 34:
					if (last_gift_accepted_timestamp_millis$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.lastGiftAcceptedTimestampMillis cannot be set twice.');
					}
					++last_gift_accepted_timestamp_millis$count;
					this.lastGiftAcceptedTimestampMillis = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 39:
					if (periodic_bonus_time_millis$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.periodicBonusTimeMillis cannot be set twice.');
					}
					++periodic_bonus_time_millis$count;
					this.periodicBonusTimeMillis = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 35:
					if (gifts_accepted_in_session_count$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.giftsAcceptedInSessionCount cannot be set twice.');
					}
					++gifts_accepted_in_session_count$count;
					this.giftsAcceptedInSessionCount = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 36:
					if (device_token$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.deviceToken cannot be set twice.');
					}
					++device_token$count;
					this.deviceToken = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 37:
					this.account.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.CommodityItemMessage()));
					break;
				case 38:
					this.items.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.PlayerItemMessage()));
					break;
				case 40:
					this.chestSlots.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.ChestSlotMessage()));
					break;
				case 41:
					if (first_place_count$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.firstPlaceCount cannot be set twice.');
					}
					++first_place_count$count;
					this.firstPlaceCount = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 42:
					if (second_place_count$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.secondPlaceCount cannot be set twice.');
					}
					++second_place_count$count;
					this.secondPlaceCount = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 43:
					if (third_place_count$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.thirdPlaceCount cannot be set twice.');
					}
					++third_place_count$count;
					this.thirdPlaceCount = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 44:
					if (open_chests_count$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.openChestsCount cannot be set twice.');
					}
					++open_chests_count$count;
					this.openChestsCount = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 45:
					if (push_token$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.pushToken cannot be set twice.');
					}
					++push_token$count;
					this.pushToken = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 46:
					if (access_level$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.accessLevel cannot be set twice.');
					}
					++access_level$count;
					this.accessLevel = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 47:
					if (installTrackingData$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.installTrackingData cannot be set twice.');
					}
					++installTrackingData$count;
					this.installTrackingData = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 48:
					if (openTrackingData$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.openTrackingData cannot be set twice.');
					}
					++openTrackingData$count;
					this.openTrackingData = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 49:
					if (customizationSettings$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerMessage.customizationSettings cannot be set twice.');
					}
					++customizationSettings$count;
					this.customizationSettings = new com.alisacasino.bingo.protocol.PlayerCustomizationSettingsMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.customizationSettings);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
