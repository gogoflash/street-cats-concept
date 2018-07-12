package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.CustomVoiceOver;
	import com.alisacasino.bingo.protocol.CustomCard;
	import com.alisacasino.bingo.protocol.SlotMachineStatic;
	import com.alisacasino.bingo.protocol.ObjectiveMessage;
	import com.alisacasino.bingo.protocol.QuestSettingsMessage;
	import com.alisacasino.bingo.protocol.CollectionDataMessage;
	import com.alisacasino.bingo.protocol.PeriodicBonusDataMessage;
	import com.alisacasino.bingo.protocol.CustomizationSet;
	import com.alisacasino.bingo.protocol.CustomAvatar;
	import com.alisacasino.bingo.protocol.PowerupDropTableMessage;
	import com.alisacasino.bingo.protocol.ScratchLotteryDataMessage;
	import com.alisacasino.bingo.protocol.CustomDaubIcon;
	import com.alisacasino.bingo.protocol.ChestDropDataMessage;
	import com.alisacasino.bingo.protocol.RoomTypeMessage;
	import com.alisacasino.bingo.protocol.GenericDropDataMessage;
	import com.alisacasino.bingo.protocol.StakeDataMessage;
	import com.alisacasino.bingo.protocol.DailyTournamentChestPrizeMessage;
	import com.alisacasino.bingo.protocol.CurrencyConverter;
	import com.alisacasino.bingo.protocol.PowerupInfoMessage;
	import com.alisacasino.bingo.protocol.XpLevelDataMessage;
	import com.alisacasino.bingo.protocol.CustomOfferMessage;
	import com.alisacasino.bingo.protocol.QuestDataMessage;
	import com.alisacasino.bingo.protocol.TournamentPlaceRewardDataMessage;
	import com.alisacasino.bingo.protocol.PlatformStoreItemsDataMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class StaticDataMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const OFFER_SHOW_TIME:FieldDescriptor$TYPE_INT64 = new FieldDescriptor$TYPE_INT64("com.alisacasino.bingo.protocol.StaticDataMessage.offer_show_time", "offerShowTime", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var offer_show_time$field:Int64;

		public function clearOfferShowTime():void {
			offer_show_time$field = null;
		}

		public function get hasOfferShowTime():Boolean {
			return offer_show_time$field != null;
		}

		public function set offerShowTime(value:Int64):void {
			offer_show_time$field = value;
		}

		public function get offerShowTime():Int64 {
			return offer_show_time$field;
		}

		/**
		 *  @private
		 */
		public static const OFFER_SHOW_INTERVAL:FieldDescriptor$TYPE_INT64 = new FieldDescriptor$TYPE_INT64("com.alisacasino.bingo.protocol.StaticDataMessage.offer_show_interval", "offerShowInterval", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var offer_show_interval$field:Int64;

		public function clearOfferShowInterval():void {
			offer_show_interval$field = null;
		}

		public function get hasOfferShowInterval():Boolean {
			return offer_show_interval$field != null;
		}

		public function set offerShowInterval(value:Int64):void {
			offer_show_interval$field = value;
		}

		public function get offerShowInterval():Int64 {
			return offer_show_interval$field;
		}

		/**
		 *  @private
		 */
		public static const FREE_SCORE_CELL_SCORE_MIN:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.StaticDataMessage.free_score_cell_score_min", "freeScoreCellScoreMin", (10 << 3) | com.netease.protobuf.WireType.VARINT);

		private var free_score_cell_score_min$field:uint;

		private var hasField$0:uint = 0;

		public function clearFreeScoreCellScoreMin():void {
			hasField$0 &= 0xfffffffe;
			free_score_cell_score_min$field = new uint();
		}

		public function get hasFreeScoreCellScoreMin():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set freeScoreCellScoreMin(value:uint):void {
			hasField$0 |= 0x1;
			free_score_cell_score_min$field = value;
		}

		public function get freeScoreCellScoreMin():uint {
			return free_score_cell_score_min$field;
		}

		/**
		 *  @private
		 */
		public static const FREE_SCORE_CELL_SCORE_MAX:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.StaticDataMessage.free_score_cell_score_max", "freeScoreCellScoreMax", (11 << 3) | com.netease.protobuf.WireType.VARINT);

		private var free_score_cell_score_max$field:uint;

		public function clearFreeScoreCellScoreMax():void {
			hasField$0 &= 0xfffffffd;
			free_score_cell_score_max$field = new uint();
		}

		public function get hasFreeScoreCellScoreMax():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set freeScoreCellScoreMax(value:uint):void {
			hasField$0 |= 0x2;
			free_score_cell_score_max$field = value;
		}

		public function get freeScoreCellScoreMax():uint {
			return free_score_cell_score_max$field;
		}

		/**
		 *  @private
		 */
		public static const DAILY_TOURNAMENT_CHEST_TARGET:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.StaticDataMessage.daily_tournament_chest_target", "dailyTournamentChestTarget", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var daily_tournament_chest_target$field:uint;

		public function clearDailyTournamentChestTarget():void {
			hasField$0 &= 0xfffffffb;
			daily_tournament_chest_target$field = new uint();
		}

		public function get hasDailyTournamentChestTarget():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set dailyTournamentChestTarget(value:uint):void {
			hasField$0 |= 0x4;
			daily_tournament_chest_target$field = value;
		}

		public function get dailyTournamentChestTarget():uint {
			return daily_tournament_chest_target$field;
		}

		/**
		 *  @private
		 */
		public static const RATE_US_ENABLED:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.alisacasino.bingo.protocol.StaticDataMessage.rate_us_enabled", "rateUsEnabled", (12 << 3) | com.netease.protobuf.WireType.VARINT);

		private var rate_us_enabled$field:Boolean;

		public function clearRateUsEnabled():void {
			hasField$0 &= 0xfffffff7;
			rate_us_enabled$field = new Boolean();
		}

		public function get hasRateUsEnabled():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set rateUsEnabled(value:Boolean):void {
			hasField$0 |= 0x8;
			rate_us_enabled$field = value;
		}

		public function get rateUsEnabled():Boolean {
			return rate_us_enabled$field;
		}

		/**
		 *  @private
		 */
		public static const RATE_US_SHOW_INTERVAL:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.StaticDataMessage.rate_us_show_interval", "rateUsShowInterval", (13 << 3) | com.netease.protobuf.WireType.VARINT);

		private var rate_us_show_interval$field:uint;

		public function clearRateUsShowInterval():void {
			hasField$0 &= 0xffffffef;
			rate_us_show_interval$field = new uint();
		}

		public function get hasRateUsShowInterval():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set rateUsShowInterval(value:uint):void {
			hasField$0 |= 0x10;
			rate_us_show_interval$field = value;
		}

		public function get rateUsShowInterval():uint {
			return rate_us_show_interval$field;
		}

		/**
		 *  @private
		 */
		public static const RATE_US_MIN_ROUNDS:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.StaticDataMessage.rate_us_min_rounds", "rateUsMinRounds", (14 << 3) | com.netease.protobuf.WireType.VARINT);

		private var rate_us_min_rounds$field:uint;

		public function clearRateUsMinRounds():void {
			hasField$0 &= 0xffffffdf;
			rate_us_min_rounds$field = new uint();
		}

		public function get hasRateUsMinRounds():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set rateUsMinRounds(value:uint):void {
			hasField$0 |= 0x20;
			rate_us_min_rounds$field = value;
		}

		public function get rateUsMinRounds():uint {
			return rate_us_min_rounds$field;
		}

		/**
		 *  @private
		 */
		public static const RATE_US_TOURNAMENT_TOP_PLACE:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.StaticDataMessage.rate_us_tournament_top_place", "rateUsTournamentTopPlace", (15 << 3) | com.netease.protobuf.WireType.VARINT);

		private var rate_us_tournament_top_place$field:uint;

		public function clearRateUsTournamentTopPlace():void {
			hasField$0 &= 0xffffffbf;
			rate_us_tournament_top_place$field = new uint();
		}

		public function get hasRateUsTournamentTopPlace():Boolean {
			return (hasField$0 & 0x40) != 0;
		}

		public function set rateUsTournamentTopPlace(value:uint):void {
			hasField$0 |= 0x40;
			rate_us_tournament_top_place$field = value;
		}

		public function get rateUsTournamentTopPlace():uint {
			return rate_us_tournament_top_place$field;
		}

		/**
		 *  @private
		 */
		public static const RATE_US_DAILY_BONUSES_TAKEN:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.StaticDataMessage.rate_us_daily_bonuses_taken", "rateUsDailyBonusesTaken", (16 << 3) | com.netease.protobuf.WireType.VARINT);

		private var rate_us_daily_bonuses_taken$field:uint;

		public function clearRateUsDailyBonusesTaken():void {
			hasField$0 &= 0xffffff7f;
			rate_us_daily_bonuses_taken$field = new uint();
		}

		public function get hasRateUsDailyBonusesTaken():Boolean {
			return (hasField$0 & 0x80) != 0;
		}

		public function set rateUsDailyBonusesTaken(value:uint):void {
			hasField$0 |= 0x80;
			rate_us_daily_bonuses_taken$field = value;
		}

		public function get rateUsDailyBonusesTaken():uint {
			return rate_us_daily_bonuses_taken$field;
		}

		/**
		 *  @private
		 */
		public static const RATE_US_IOS_URL:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.StaticDataMessage.rate_us_ios_url", "rateUsIosUrl", (17 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var rate_us_ios_url$field:String;

		public function clearRateUsIosUrl():void {
			rate_us_ios_url$field = null;
		}

		public function get hasRateUsIosUrl():Boolean {
			return rate_us_ios_url$field != null;
		}

		public function set rateUsIosUrl(value:String):void {
			rate_us_ios_url$field = value;
		}

		public function get rateUsIosUrl():String {
			return rate_us_ios_url$field;
		}

		/**
		 *  @private
		 */
		public static const RATE_US_IOS7_URL:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.StaticDataMessage.rate_us_ios7_url", "rateUsIos7Url", (20 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var rate_us_ios7_url$field:String;

		public function clearRateUsIos7Url():void {
			rate_us_ios7_url$field = null;
		}

		public function get hasRateUsIos7Url():Boolean {
			return rate_us_ios7_url$field != null;
		}

		public function set rateUsIos7Url(value:String):void {
			rate_us_ios7_url$field = value;
		}

		public function get rateUsIos7Url():String {
			return rate_us_ios7_url$field;
		}

		/**
		 *  @private
		 */
		public static const RATE_US_ANDROID_URL:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.StaticDataMessage.rate_us_android_url", "rateUsAndroidUrl", (18 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var rate_us_android_url$field:String;

		public function clearRateUsAndroidUrl():void {
			rate_us_android_url$field = null;
		}

		public function get hasRateUsAndroidUrl():Boolean {
			return rate_us_android_url$field != null;
		}

		public function set rateUsAndroidUrl(value:String):void {
			rate_us_android_url$field = value;
		}

		public function get rateUsAndroidUrl():String {
			return rate_us_android_url$field;
		}

		/**
		 *  @private
		 */
		public static const RATE_US_AMAZON_URL:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.StaticDataMessage.rate_us_amazon_url", "rateUsAmazonUrl", (19 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var rate_us_amazon_url$field:String;

		public function clearRateUsAmazonUrl():void {
			rate_us_amazon_url$field = null;
		}

		public function get hasRateUsAmazonUrl():Boolean {
			return rate_us_amazon_url$field != null;
		}

		public function set rateUsAmazonUrl(value:String):void {
			rate_us_amazon_url$field = value;
		}

		public function get rateUsAmazonUrl():String {
			return rate_us_amazon_url$field;
		}

		/**
		 *  @private
		 */
		public static const DAUB_HINTS_ENABLED:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.alisacasino.bingo.protocol.StaticDataMessage.daub_hints_enabled", "daubHintsEnabled", (21 << 3) | com.netease.protobuf.WireType.VARINT);

		private var daub_hints_enabled$field:Boolean;

		public function clearDaubHintsEnabled():void {
			hasField$0 &= 0xfffffeff;
			daub_hints_enabled$field = new Boolean();
		}

		public function get hasDaubHintsEnabled():Boolean {
			return (hasField$0 & 0x100) != 0;
		}

		public function set daubHintsEnabled(value:Boolean):void {
			hasField$0 |= 0x100;
			daub_hints_enabled$field = value;
		}

		public function get daubHintsEnabled():Boolean {
			return daub_hints_enabled$field;
		}

		/**
		 *  @private
		 */
		public static const FREE_DAUB_HINT_ROUNDS:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.StaticDataMessage.free_daub_hint_rounds", "freeDaubHintRounds", (22 << 3) | com.netease.protobuf.WireType.VARINT);

		private var free_daub_hint_rounds$field:uint;

		public function clearFreeDaubHintRounds():void {
			hasField$0 &= 0xfffffdff;
			free_daub_hint_rounds$field = new uint();
		}

		public function get hasFreeDaubHintRounds():Boolean {
			return (hasField$0 & 0x200) != 0;
		}

		public function set freeDaubHintRounds(value:uint):void {
			hasField$0 |= 0x200;
			free_daub_hint_rounds$field = value;
		}

		public function get freeDaubHintRounds():uint {
			return free_daub_hint_rounds$field;
		}

		/**
		 *  @private
		 */
		public static const DAUB_HINTS_PRICE:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.StaticDataMessage.daub_hints_price", "daubHintsPrice", (23 << 3) | com.netease.protobuf.WireType.VARINT);

		private var daub_hints_price$field:uint;

		public function clearDaubHintsPrice():void {
			hasField$0 &= 0xfffffbff;
			daub_hints_price$field = new uint();
		}

		public function get hasDaubHintsPrice():Boolean {
			return (hasField$0 & 0x400) != 0;
		}

		public function set daubHintsPrice(value:uint):void {
			hasField$0 |= 0x400;
			daub_hints_price$field = value;
		}

		public function get daubHintsPrice():uint {
			return daub_hints_price$field;
		}

		/**
		 *  @private
		 */
		public static const WBT_LEVEL_MIN:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.StaticDataMessage.wbt_level_min", "wbtLevelMin", (24 << 3) | com.netease.protobuf.WireType.VARINT);

		private var wbt_level_min$field:uint;

		public function clearWbtLevelMin():void {
			hasField$0 &= 0xfffff7ff;
			wbt_level_min$field = new uint();
		}

		public function get hasWbtLevelMin():Boolean {
			return (hasField$0 & 0x800) != 0;
		}

		public function set wbtLevelMin(value:uint):void {
			hasField$0 |= 0x800;
			wbt_level_min$field = value;
		}

		public function get wbtLevelMin():uint {
			return wbt_level_min$field;
		}

		/**
		 *  @private
		 */
		public static const BAD_BINGO_TIMER_ATTEMPTS:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.StaticDataMessage.bad_bingo_timer_attempts", "badBingoTimerAttempts", (25 << 3) | com.netease.protobuf.WireType.VARINT);

		private var bad_bingo_timer_attempts$field:uint;

		public function clearBadBingoTimerAttempts():void {
			hasField$0 &= 0xffffefff;
			bad_bingo_timer_attempts$field = new uint();
		}

		public function get hasBadBingoTimerAttempts():Boolean {
			return (hasField$0 & 0x1000) != 0;
		}

		public function set badBingoTimerAttempts(value:uint):void {
			hasField$0 |= 0x1000;
			bad_bingo_timer_attempts$field = value;
		}

		public function get badBingoTimerAttempts():uint {
			return bad_bingo_timer_attempts$field;
		}

		/**
		 *  @private
		 */
		public static const COMPLETED_PAGE_PROBABILTY:FieldDescriptor$TYPE_DOUBLE = new FieldDescriptor$TYPE_DOUBLE("com.alisacasino.bingo.protocol.StaticDataMessage.completed_page_probabilty", "completedPageProbabilty", (38 << 3) | com.netease.protobuf.WireType.FIXED_64_BIT);

		private var completed_page_probabilty$field:Number;

		public function clearCompletedPageProbabilty():void {
			hasField$0 &= 0xffffdfff;
			completed_page_probabilty$field = new Number();
		}

		public function get hasCompletedPageProbabilty():Boolean {
			return (hasField$0 & 0x2000) != 0;
		}

		public function set completedPageProbabilty(value:Number):void {
			hasField$0 |= 0x2000;
			completed_page_probabilty$field = value;
		}

		public function get completedPageProbabilty():Number {
			return completed_page_probabilty$field;
		}

		/**
		 *  @private
		 */
		public static const DAUBPOINTS:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.StaticDataMessage.daubPoints", "daubPoints", (39 << 3) | com.netease.protobuf.WireType.VARINT);

		private var daubPoints$field:uint;

		public function clearDaubPoints():void {
			hasField$0 &= 0xffffbfff;
			daubPoints$field = new uint();
		}

		public function get hasDaubPoints():Boolean {
			return (hasField$0 & 0x4000) != 0;
		}

		public function set daubPoints(value:uint):void {
			hasField$0 |= 0x4000;
			daubPoints$field = value;
		}

		public function get daubPoints():uint {
			return daubPoints$field;
		}

		/**
		 *  @private
		 */
		public static const DAUBXP:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.StaticDataMessage.daubXP", "daubXP", (40 << 3) | com.netease.protobuf.WireType.VARINT);

		private var daubXP$field:uint;

		public function clearDaubXP():void {
			hasField$0 &= 0xffff7fff;
			daubXP$field = new uint();
		}

		public function get hasDaubXP():Boolean {
			return (hasField$0 & 0x8000) != 0;
		}

		public function set daubXP(value:uint):void {
			hasField$0 |= 0x8000;
			daubXP$field = value;
		}

		public function get daubXP():uint {
			return daubXP$field;
		}

		/**
		 *  @private
		 */
		public static const POINTPOWERUPQUANTITY:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.StaticDataMessage.pointPowerupQuantity", "pointPowerupQuantity", (41 << 3) | com.netease.protobuf.WireType.VARINT);

		private var pointPowerupQuantity$field:uint;

		public function clearPointPowerupQuantity():void {
			hasField$0 &= 0xfffeffff;
			pointPowerupQuantity$field = new uint();
		}

		public function get hasPointPowerupQuantity():Boolean {
			return (hasField$0 & 0x10000) != 0;
		}

		public function set pointPowerupQuantity(value:uint):void {
			hasField$0 |= 0x10000;
			pointPowerupQuantity$field = value;
		}

		public function get pointPowerupQuantity():uint {
			return pointPowerupQuantity$field;
		}

		/**
		 *  @private
		 */
		public static const XPPOWERUPQUANTITY:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.StaticDataMessage.xpPowerupQuantity", "xpPowerupQuantity", (42 << 3) | com.netease.protobuf.WireType.VARINT);

		private var xpPowerupQuantity$field:uint;

		public function clearXpPowerupQuantity():void {
			hasField$0 &= 0xfffdffff;
			xpPowerupQuantity$field = new uint();
		}

		public function get hasXpPowerupQuantity():Boolean {
			return (hasField$0 & 0x20000) != 0;
		}

		public function set xpPowerupQuantity(value:uint):void {
			hasField$0 |= 0x20000;
			xpPowerupQuantity$field = value;
		}

		public function get xpPowerupQuantity():uint {
			return xpPowerupQuantity$field;
		}

		/**
		 *  @private
		 */
		public static const CASHPOWERUPQUANTITY:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.StaticDataMessage.cashPowerupQuantity", "cashPowerupQuantity", (43 << 3) | com.netease.protobuf.WireType.VARINT);

		private var cashPowerupQuantity$field:uint;

		public function clearCashPowerupQuantity():void {
			hasField$0 &= 0xfffbffff;
			cashPowerupQuantity$field = new uint();
		}

		public function get hasCashPowerupQuantity():Boolean {
			return (hasField$0 & 0x40000) != 0;
		}

		public function set cashPowerupQuantity(value:uint):void {
			hasField$0 |= 0x40000;
			cashPowerupQuantity$field = value;
		}

		public function get cashPowerupQuantity():uint {
			return cashPowerupQuantity$field;
		}

		/**
		 *  @private
		 */
		public static const POWERUPRETURNCOEFFICENT:FieldDescriptor$TYPE_FLOAT = new FieldDescriptor$TYPE_FLOAT("com.alisacasino.bingo.protocol.StaticDataMessage.powerupReturnCoefficent", "powerupReturnCoefficent", (44 << 3) | com.netease.protobuf.WireType.FIXED_32_BIT);

		private var powerupReturnCoefficent$field:Number;

		public function clearPowerupReturnCoefficent():void {
			hasField$0 &= 0xfff7ffff;
			powerupReturnCoefficent$field = new Number();
		}

		public function get hasPowerupReturnCoefficent():Boolean {
			return (hasField$0 & 0x80000) != 0;
		}

		public function set powerupReturnCoefficent(value:Number):void {
			hasField$0 |= 0x80000;
			powerupReturnCoefficent$field = value;
		}

		public function get powerupReturnCoefficent():Number {
			return powerupReturnCoefficent$field;
		}

		/**
		 *  @private
		 */
		public static const TOURNAMENTENDPUSH:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.StaticDataMessage.tournamentEndPush", "tournamentEndPush", (45 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var tournamentEndPush$field:String;

		public function clearTournamentEndPush():void {
			tournamentEndPush$field = null;
		}

		public function get hasTournamentEndPush():Boolean {
			return tournamentEndPush$field != null;
		}

		public function set tournamentEndPush(value:String):void {
			tournamentEndPush$field = value;
		}

		public function get tournamentEndPush():String {
			return tournamentEndPush$field;
		}

		/**
		 *  @private
		 */
		public static const CASHBONUSPUSH:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.StaticDataMessage.cashBonusPush", "cashBonusPush", (46 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var cashBonusPush$field:String;

		public function clearCashBonusPush():void {
			cashBonusPush$field = null;
		}

		public function get hasCashBonusPush():Boolean {
			return cashBonusPush$field != null;
		}

		public function set cashBonusPush(value:String):void {
			cashBonusPush$field = value;
		}

		public function get cashBonusPush():String {
			return cashBonusPush$field;
		}

		/**
		 *  @private
		 */
		public static const CHESTOPENEDPUSH:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.StaticDataMessage.chestOpenedPush", "chestOpenedPush", (47 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var chestOpenedPush$field:String;

		public function clearChestOpenedPush():void {
			chestOpenedPush$field = null;
		}

		public function get hasChestOpenedPush():Boolean {
			return chestOpenedPush$field != null;
		}

		public function set chestOpenedPush(value:String):void {
			chestOpenedPush$field = value;
		}

		public function get chestOpenedPush():String {
			return chestOpenedPush$field;
		}

		/**
		 *  @private
		 */
		public static const SCRATCH_MIN_CASH_PLAY:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.StaticDataMessage.scratch_min_cash_play", "scratchMinCashPlay", (48 << 3) | com.netease.protobuf.WireType.VARINT);

		private var scratch_min_cash_play$field:uint;

		public function clearScratchMinCashPlay():void {
			hasField$0 &= 0xffefffff;
			scratch_min_cash_play$field = new uint();
		}

		public function get hasScratchMinCashPlay():Boolean {
			return (hasField$0 & 0x100000) != 0;
		}

		public function set scratchMinCashPlay(value:uint):void {
			hasField$0 |= 0x100000;
			scratch_min_cash_play$field = value;
		}

		public function get scratchMinCashPlay():uint {
			return scratch_min_cash_play$field;
		}

		/**
		 *  @private
		 */
		public static const AVGBALLTOBINGO:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.StaticDataMessage.avgBallToBingo", "avgBallToBingo", (49 << 3) | com.netease.protobuf.WireType.VARINT);

		private var avgBallToBingo$field:uint;

		public function clearAvgBallToBingo():void {
			hasField$0 &= 0xffdfffff;
			avgBallToBingo$field = new uint();
		}

		public function get hasAvgBallToBingo():Boolean {
			return (hasField$0 & 0x200000) != 0;
		}

		public function set avgBallToBingo(value:uint):void {
			hasField$0 |= 0x200000;
			avgBallToBingo$field = value;
		}

		public function get avgBallToBingo():uint {
			return avgBallToBingo$field;
		}

		/**
		 *  @private
		 */
		public static const INITIALBALLTOBINGO:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.StaticDataMessage.initialBallToBingo", "initialBallToBingo", (50 << 3) | com.netease.protobuf.WireType.VARINT);

		private var initialBallToBingo$field:uint;

		public function clearInitialBallToBingo():void {
			hasField$0 &= 0xffbfffff;
			initialBallToBingo$field = new uint();
		}

		public function get hasInitialBallToBingo():Boolean {
			return (hasField$0 & 0x400000) != 0;
		}

		public function set initialBallToBingo(value:uint):void {
			hasField$0 |= 0x400000;
			initialBallToBingo$field = value;
		}

		public function get initialBallToBingo():uint {
			return initialBallToBingo$field;
		}

		/**
		 *  @private
		 */
		public static const INVITESHAREURL:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.StaticDataMessage.inviteShareUrl", "inviteShareUrl", (51 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var inviteShareUrl$field:String;

		public function clearInviteShareUrl():void {
			inviteShareUrl$field = null;
		}

		public function get hasInviteShareUrl():Boolean {
			return inviteShareUrl$field != null;
		}

		public function set inviteShareUrl(value:String):void {
			inviteShareUrl$field = value;
		}

		public function get inviteShareUrl():String {
			return inviteShareUrl$field;
		}

		/**
		 *  @private
		 */
		public static const OPENGRAPH_PATH:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.StaticDataMessage.opengraph_path", "opengraphPath", (26 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var opengraph_path$field:String;

		public function clearOpengraphPath():void {
			opengraph_path$field = null;
		}

		public function get hasOpengraphPath():Boolean {
			return opengraph_path$field != null;
		}

		public function set opengraphPath(value:String):void {
			opengraph_path$field = value;
		}

		public function get opengraphPath():String {
			return opengraph_path$field;
		}

		/**
		 *  @private
		 */
		public static const OFFERS_GLOBAL_TIMEOUT:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("com.alisacasino.bingo.protocol.StaticDataMessage.offers_global_timeout", "offersGlobalTimeout", (28 << 3) | com.netease.protobuf.WireType.VARINT);

		private var offers_global_timeout$field:UInt64;

		public function clearOffersGlobalTimeout():void {
			offers_global_timeout$field = null;
		}

		public function get hasOffersGlobalTimeout():Boolean {
			return offers_global_timeout$field != null;
		}

		public function set offersGlobalTimeout(value:UInt64):void {
			offers_global_timeout$field = value;
		}

		public function get offersGlobalTimeout():UInt64 {
			return offers_global_timeout$field;
		}

		/**
		 *  @private
		 */
		public static const DAILY_TOURNAMENT_CHEST_PRIZES:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.StaticDataMessage.daily_tournament_chest_prizes", "dailyTournamentChestPrizes", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.DailyTournamentChestPrizeMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.DailyTournamentChestPrizeMessage")]
		public var dailyTournamentChestPrizes:Array = [];

		/**
		 *  @private
		 */
		public static const POWERUPS_INFO:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.StaticDataMessage.powerups_info", "powerupsInfo", (5 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PowerupInfoMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.PowerupInfoMessage")]
		public var powerupsInfo:Array = [];

		/**
		 *  @private
		 */
		public static const ROOM_TYPES:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.StaticDataMessage.room_types", "roomTypes", (6 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.RoomTypeMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.RoomTypeMessage")]
		public var roomTypes:Array = [];

		/**
		 *  @private
		 */
		public static const OBJECTIVES:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.StaticDataMessage.objectives", "objectives", (7 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.ObjectiveMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.ObjectiveMessage")]
		public var objectives:Array = [];

		/**
		 *  @private
		 */
		public static const CUSTOM_OFFERS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.StaticDataMessage.custom_offers", "customOffers", (27 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.CustomOfferMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.CustomOfferMessage")]
		public var customOffers:Array = [];

		/**
		 *  @private
		 */
		public static const COLLECTION_DATA:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.StaticDataMessage.collection_data", "collectionData", (29 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.CollectionDataMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.CollectionDataMessage")]
		public var collectionData:Array = [];

		/**
		 *  @private
		 */
		public static const PERIODIC_DATA:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.StaticDataMessage.periodic_data", "periodicData", (30 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PeriodicBonusDataMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.PeriodicBonusDataMessage")]
		public var periodicData:Array = [];

		/**
		 *  @private
		 */
		public static const CASH_ITEMS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.StaticDataMessage.cash_items", "cashItems", (32 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PlatformStoreItemsDataMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.PlatformStoreItemsDataMessage")]
		public var cashItems:Array = [];

		/**
		 *  @private
		 */
		public static const SCRATCH_LOTTERIES:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.StaticDataMessage.scratch_lotteries", "scratchLotteries", (33 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.ScratchLotteryDataMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.ScratchLotteryDataMessage")]
		public var scratchLotteries:Array = [];

		/**
		 *  @private
		 */
		public static const TOURNAMENT_PLACE_REWARDS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.StaticDataMessage.tournament_place_rewards", "tournamentPlaceRewards", (34 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.TournamentPlaceRewardDataMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.TournamentPlaceRewardDataMessage")]
		public var tournamentPlaceRewards:Array = [];

		/**
		 *  @private
		 */
		public static const CHEST_DROP:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.StaticDataMessage.chest_drop", "chestDrop", (35 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.ChestDropDataMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.ChestDropDataMessage")]
		public var chestDrop:Array = [];

		/**
		 *  @private
		 */
		public static const LEVELS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.StaticDataMessage.levels", "levels", (36 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.XpLevelDataMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.XpLevelDataMessage")]
		public var levels:Array = [];

		/**
		 *  @private
		 */
		public static const POWERUP_DROP:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.StaticDataMessage.powerup_drop", "powerupDrop", (37 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PowerupDropTableMessage; });

		private var powerup_drop$field:com.alisacasino.bingo.protocol.PowerupDropTableMessage;

		public function clearPowerupDrop():void {
			powerup_drop$field = null;
		}

		public function get hasPowerupDrop():Boolean {
			return powerup_drop$field != null;
		}

		public function set powerupDrop(value:com.alisacasino.bingo.protocol.PowerupDropTableMessage):void {
			powerup_drop$field = value;
		}

		public function get powerupDrop():com.alisacasino.bingo.protocol.PowerupDropTableMessage {
			return powerup_drop$field;
		}

		/**
		 *  @private
		 */
		public static const CUSTOMDAUBICONS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.StaticDataMessage.customDaubIcons", "customDaubIcons", (52 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.CustomDaubIcon; });

		[ArrayElementType("com.alisacasino.bingo.protocol.CustomDaubIcon")]
		public var customDaubIcons:Array = [];

		/**
		 *  @private
		 */
		public static const CUSTOMCARDS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.StaticDataMessage.customCards", "customCards", (54 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.CustomCard; });

		[ArrayElementType("com.alisacasino.bingo.protocol.CustomCard")]
		public var customCards:Array = [];

		/**
		 *  @private
		 */
		public static const CUSTOMAVATARS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.StaticDataMessage.customAvatars", "customAvatars", (55 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.CustomAvatar; });

		[ArrayElementType("com.alisacasino.bingo.protocol.CustomAvatar")]
		public var customAvatars:Array = [];

		/**
		 *  @private
		 */
		public static const CUSTOMVOICEOVERS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.StaticDataMessage.customVoiceOvers", "customVoiceOvers", (56 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.CustomVoiceOver; });

		[ArrayElementType("com.alisacasino.bingo.protocol.CustomVoiceOver")]
		public var customVoiceOvers:Array = [];

		/**
		 *  @private
		 */
		public static const CUSTOMIZATIONSETS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.StaticDataMessage.customizationSets", "customizationSets", (57 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.CustomizationSet; });

		[ArrayElementType("com.alisacasino.bingo.protocol.CustomizationSet")]
		public var customizationSets:Array = [];

		/**
		 *  @private
		 */
		public static const CURRENCYCONVERTER:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.StaticDataMessage.currencyConverter", "currencyConverter", (58 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.CurrencyConverter; });

		private var currencyConverter$field:com.alisacasino.bingo.protocol.CurrencyConverter;

		public function clearCurrencyConverter():void {
			currencyConverter$field = null;
		}

		public function get hasCurrencyConverter():Boolean {
			return currencyConverter$field != null;
		}

		public function set currencyConverter(value:com.alisacasino.bingo.protocol.CurrencyConverter):void {
			currencyConverter$field = value;
		}

		public function get currencyConverter():com.alisacasino.bingo.protocol.CurrencyConverter {
			return currencyConverter$field;
		}

		/**
		 *  @private
		 */
		public static const QUESTS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.StaticDataMessage.quests", "quests", (59 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.QuestDataMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.QuestDataMessage")]
		public var quests:Array = [];

		/**
		 *  @private
		 */
		public static const STAKES:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.StaticDataMessage.stakes", "stakes", (60 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.StakeDataMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.StakeDataMessage")]
		public var stakes:Array = [];

		/**
		 *  @private
		 */
		public static const XPBONUSLEVELMIN:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.alisacasino.bingo.protocol.StaticDataMessage.xpBonusLevelMin", "xpBonusLevelMin", (61 << 3) | com.netease.protobuf.WireType.VARINT);

		private var xpBonusLevelMin$field:int;

		public function clearXpBonusLevelMin():void {
			hasField$0 &= 0xff7fffff;
			xpBonusLevelMin$field = new int();
		}

		public function get hasXpBonusLevelMin():Boolean {
			return (hasField$0 & 0x800000) != 0;
		}

		public function set xpBonusLevelMin(value:int):void {
			hasField$0 |= 0x800000;
			xpBonusLevelMin$field = value;
		}

		public function get xpBonusLevelMin():int {
			return xpBonusLevelMin$field;
		}

		/**
		 *  @private
		 */
		public static const XPBONUSLEVELMAX:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.alisacasino.bingo.protocol.StaticDataMessage.xpBonusLevelMax", "xpBonusLevelMax", (62 << 3) | com.netease.protobuf.WireType.VARINT);

		private var xpBonusLevelMax$field:int;

		public function clearXpBonusLevelMax():void {
			hasField$0 &= 0xfeffffff;
			xpBonusLevelMax$field = new int();
		}

		public function get hasXpBonusLevelMax():Boolean {
			return (hasField$0 & 0x1000000) != 0;
		}

		public function set xpBonusLevelMax(value:int):void {
			hasField$0 |= 0x1000000;
			xpBonusLevelMax$field = value;
		}

		public function get xpBonusLevelMax():int {
			return xpBonusLevelMax$field;
		}

		/**
		 *  @private
		 */
		public static const XPBONUSMULTIPLIER:FieldDescriptor$TYPE_DOUBLE = new FieldDescriptor$TYPE_DOUBLE("com.alisacasino.bingo.protocol.StaticDataMessage.xpBonusMultiplier", "xpBonusMultiplier", (63 << 3) | com.netease.protobuf.WireType.FIXED_64_BIT);

		private var xpBonusMultiplier$field:Number;

		public function clearXpBonusMultiplier():void {
			hasField$0 &= 0xfdffffff;
			xpBonusMultiplier$field = new Number();
		}

		public function get hasXpBonusMultiplier():Boolean {
			return (hasField$0 & 0x2000000) != 0;
		}

		public function set xpBonusMultiplier(value:Number):void {
			hasField$0 |= 0x2000000;
			xpBonusMultiplier$field = value;
		}

		public function get xpBonusMultiplier():Number {
			return xpBonusMultiplier$field;
		}

		/**
		 *  @private
		 */
		public static const QUESTSSETTINGS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.StaticDataMessage.questsSettings", "questsSettings", (64 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.QuestSettingsMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.QuestSettingsMessage")]
		public var questsSettings:Array = [];

		/**
		 *  @private
		 */
		public static const BALLINTERVAL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.alisacasino.bingo.protocol.StaticDataMessage.ballInterval", "ballInterval", (65 << 3) | com.netease.protobuf.WireType.VARINT);

		private var ballInterval$field:int;

		public function clearBallInterval():void {
			hasField$0 &= 0xfbffffff;
			ballInterval$field = new int();
		}

		public function get hasBallInterval():Boolean {
			return (hasField$0 & 0x4000000) != 0;
		}

		public function set ballInterval(value:int):void {
			hasField$0 |= 0x4000000;
			ballInterval$field = value;
		}

		public function get ballInterval():int {
			return ballInterval$field;
		}

		/**
		 *  @private
		 */
		public static const STARTBALLINTERVAL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.alisacasino.bingo.protocol.StaticDataMessage.startBallInterval", "startBallInterval", (66 << 3) | com.netease.protobuf.WireType.VARINT);

		private var startBallInterval$field:int;

		public function clearStartBallInterval():void {
			hasField$0 &= 0xf7ffffff;
			startBallInterval$field = new int();
		}

		public function get hasStartBallInterval():Boolean {
			return (hasField$0 & 0x8000000) != 0;
		}

		public function set startBallInterval(value:int):void {
			hasField$0 |= 0x8000000;
			startBallInterval$field = value;
		}

		public function get startBallInterval():int {
			return startBallInterval$field;
		}

		/**
		 *  @private
		 */
		public static const BALLTHRESHOLD:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.alisacasino.bingo.protocol.StaticDataMessage.ballThreshold", "ballThreshold", (67 << 3) | com.netease.protobuf.WireType.VARINT);

		private var ballThreshold$field:int;

		public function clearBallThreshold():void {
			hasField$0 &= 0xefffffff;
			ballThreshold$field = new int();
		}

		public function get hasBallThreshold():Boolean {
			return (hasField$0 & 0x10000000) != 0;
		}

		public function set ballThreshold(value:int):void {
			hasField$0 |= 0x10000000;
			ballThreshold$field = value;
		}

		public function get ballThreshold():int {
			return ballThreshold$field;
		}

		/**
		 *  @private
		 */
		public static const SLOTMACHINESTATIC:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.StaticDataMessage.slotMachineStatic", "slotMachineStatic", (68 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.SlotMachineStatic; });

		[ArrayElementType("com.alisacasino.bingo.protocol.SlotMachineStatic")]
		public var slotMachineStatic:Array = [];

		/**
		 *  @private
		 */
		public static const GENERICDROPDATA:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.StaticDataMessage.genericDropData", "genericDropData", (69 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.GenericDropDataMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.GenericDropDataMessage")]
		public var genericDropData:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasOfferShowTime) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT64(output, offer_show_time$field);
			}
			if (hasOfferShowInterval) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT64(output, offer_show_interval$field);
			}
			if (hasFreeScoreCellScoreMin) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 10);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, free_score_cell_score_min$field);
			}
			if (hasFreeScoreCellScoreMax) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 11);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, free_score_cell_score_max$field);
			}
			if (hasDailyTournamentChestTarget) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, daily_tournament_chest_target$field);
			}
			if (hasRateUsEnabled) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 12);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, rate_us_enabled$field);
			}
			if (hasRateUsShowInterval) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 13);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, rate_us_show_interval$field);
			}
			if (hasRateUsMinRounds) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 14);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, rate_us_min_rounds$field);
			}
			if (hasRateUsTournamentTopPlace) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 15);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, rate_us_tournament_top_place$field);
			}
			if (hasRateUsDailyBonusesTaken) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 16);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, rate_us_daily_bonuses_taken$field);
			}
			if (hasRateUsIosUrl) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 17);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, rate_us_ios_url$field);
			}
			if (hasRateUsIos7Url) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 20);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, rate_us_ios7_url$field);
			}
			if (hasRateUsAndroidUrl) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 18);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, rate_us_android_url$field);
			}
			if (hasRateUsAmazonUrl) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 19);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, rate_us_amazon_url$field);
			}
			if (hasDaubHintsEnabled) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 21);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, daub_hints_enabled$field);
			}
			if (hasFreeDaubHintRounds) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 22);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, free_daub_hint_rounds$field);
			}
			if (hasDaubHintsPrice) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 23);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, daub_hints_price$field);
			}
			if (hasWbtLevelMin) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 24);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, wbt_level_min$field);
			}
			if (hasBadBingoTimerAttempts) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 25);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, bad_bingo_timer_attempts$field);
			}
			if (hasCompletedPageProbabilty) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_64_BIT, 38);
				com.netease.protobuf.WriteUtils.write$TYPE_DOUBLE(output, completed_page_probabilty$field);
			}
			if (hasDaubPoints) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 39);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, daubPoints$field);
			}
			if (hasDaubXP) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 40);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, daubXP$field);
			}
			if (hasPointPowerupQuantity) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 41);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, pointPowerupQuantity$field);
			}
			if (hasXpPowerupQuantity) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 42);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, xpPowerupQuantity$field);
			}
			if (hasCashPowerupQuantity) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 43);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, cashPowerupQuantity$field);
			}
			if (hasPowerupReturnCoefficent) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_32_BIT, 44);
				com.netease.protobuf.WriteUtils.write$TYPE_FLOAT(output, powerupReturnCoefficent$field);
			}
			if (hasTournamentEndPush) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 45);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, tournamentEndPush$field);
			}
			if (hasCashBonusPush) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 46);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, cashBonusPush$field);
			}
			if (hasChestOpenedPush) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 47);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, chestOpenedPush$field);
			}
			if (hasScratchMinCashPlay) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 48);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, scratch_min_cash_play$field);
			}
			if (hasAvgBallToBingo) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 49);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, avgBallToBingo$field);
			}
			if (hasInitialBallToBingo) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 50);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, initialBallToBingo$field);
			}
			if (hasInviteShareUrl) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 51);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, inviteShareUrl$field);
			}
			if (hasOpengraphPath) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 26);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, opengraph_path$field);
			}
			if (hasOffersGlobalTimeout) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 28);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, offers_global_timeout$field);
			}
			for (var dailyTournamentChestPrizes$index:uint = 0; dailyTournamentChestPrizes$index < this.dailyTournamentChestPrizes.length; ++dailyTournamentChestPrizes$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.dailyTournamentChestPrizes[dailyTournamentChestPrizes$index]);
			}
			for (var powerupsInfo$index:uint = 0; powerupsInfo$index < this.powerupsInfo.length; ++powerupsInfo$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.powerupsInfo[powerupsInfo$index]);
			}
			for (var roomTypes$index:uint = 0; roomTypes$index < this.roomTypes.length; ++roomTypes$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.roomTypes[roomTypes$index]);
			}
			for (var objectives$index:uint = 0; objectives$index < this.objectives.length; ++objectives$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.objectives[objectives$index]);
			}
			for (var customOffers$index:uint = 0; customOffers$index < this.customOffers.length; ++customOffers$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 27);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.customOffers[customOffers$index]);
			}
			for (var collectionData$index:uint = 0; collectionData$index < this.collectionData.length; ++collectionData$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 29);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.collectionData[collectionData$index]);
			}
			for (var periodicData$index:uint = 0; periodicData$index < this.periodicData.length; ++periodicData$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 30);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.periodicData[periodicData$index]);
			}
			for (var cashItems$index:uint = 0; cashItems$index < this.cashItems.length; ++cashItems$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 32);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.cashItems[cashItems$index]);
			}
			for (var scratchLotteries$index:uint = 0; scratchLotteries$index < this.scratchLotteries.length; ++scratchLotteries$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 33);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.scratchLotteries[scratchLotteries$index]);
			}
			for (var tournamentPlaceRewards$index:uint = 0; tournamentPlaceRewards$index < this.tournamentPlaceRewards.length; ++tournamentPlaceRewards$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 34);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.tournamentPlaceRewards[tournamentPlaceRewards$index]);
			}
			for (var chestDrop$index:uint = 0; chestDrop$index < this.chestDrop.length; ++chestDrop$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 35);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.chestDrop[chestDrop$index]);
			}
			for (var levels$index:uint = 0; levels$index < this.levels.length; ++levels$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 36);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.levels[levels$index]);
			}
			if (hasPowerupDrop) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 37);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, powerup_drop$field);
			}
			for (var customDaubIcons$index:uint = 0; customDaubIcons$index < this.customDaubIcons.length; ++customDaubIcons$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 52);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.customDaubIcons[customDaubIcons$index]);
			}
			for (var customCards$index:uint = 0; customCards$index < this.customCards.length; ++customCards$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 54);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.customCards[customCards$index]);
			}
			for (var customAvatars$index:uint = 0; customAvatars$index < this.customAvatars.length; ++customAvatars$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 55);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.customAvatars[customAvatars$index]);
			}
			for (var customVoiceOvers$index:uint = 0; customVoiceOvers$index < this.customVoiceOvers.length; ++customVoiceOvers$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 56);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.customVoiceOvers[customVoiceOvers$index]);
			}
			for (var customizationSets$index:uint = 0; customizationSets$index < this.customizationSets.length; ++customizationSets$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 57);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.customizationSets[customizationSets$index]);
			}
			if (hasCurrencyConverter) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 58);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, currencyConverter$field);
			}
			for (var quests$index:uint = 0; quests$index < this.quests.length; ++quests$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 59);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.quests[quests$index]);
			}
			for (var stakes$index:uint = 0; stakes$index < this.stakes.length; ++stakes$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 60);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.stakes[stakes$index]);
			}
			if (hasXpBonusLevelMin) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 61);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, xpBonusLevelMin$field);
			}
			if (hasXpBonusLevelMax) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 62);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, xpBonusLevelMax$field);
			}
			if (hasXpBonusMultiplier) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_64_BIT, 63);
				com.netease.protobuf.WriteUtils.write$TYPE_DOUBLE(output, xpBonusMultiplier$field);
			}
			for (var questsSettings$index:uint = 0; questsSettings$index < this.questsSettings.length; ++questsSettings$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 64);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.questsSettings[questsSettings$index]);
			}
			if (hasBallInterval) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 65);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, ballInterval$field);
			}
			if (hasStartBallInterval) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 66);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, startBallInterval$field);
			}
			if (hasBallThreshold) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 67);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, ballThreshold$field);
			}
			for (var slotMachineStatic$index:uint = 0; slotMachineStatic$index < this.slotMachineStatic.length; ++slotMachineStatic$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 68);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.slotMachineStatic[slotMachineStatic$index]);
			}
			for (var genericDropData$index:uint = 0; genericDropData$index < this.genericDropData.length; ++genericDropData$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 69);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.genericDropData[genericDropData$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var offer_show_time$count:uint = 0;
			var offer_show_interval$count:uint = 0;
			var free_score_cell_score_min$count:uint = 0;
			var free_score_cell_score_max$count:uint = 0;
			var daily_tournament_chest_target$count:uint = 0;
			var rate_us_enabled$count:uint = 0;
			var rate_us_show_interval$count:uint = 0;
			var rate_us_min_rounds$count:uint = 0;
			var rate_us_tournament_top_place$count:uint = 0;
			var rate_us_daily_bonuses_taken$count:uint = 0;
			var rate_us_ios_url$count:uint = 0;
			var rate_us_ios7_url$count:uint = 0;
			var rate_us_android_url$count:uint = 0;
			var rate_us_amazon_url$count:uint = 0;
			var daub_hints_enabled$count:uint = 0;
			var free_daub_hint_rounds$count:uint = 0;
			var daub_hints_price$count:uint = 0;
			var wbt_level_min$count:uint = 0;
			var bad_bingo_timer_attempts$count:uint = 0;
			var completed_page_probabilty$count:uint = 0;
			var daubPoints$count:uint = 0;
			var daubXP$count:uint = 0;
			var pointPowerupQuantity$count:uint = 0;
			var xpPowerupQuantity$count:uint = 0;
			var cashPowerupQuantity$count:uint = 0;
			var powerupReturnCoefficent$count:uint = 0;
			var tournamentEndPush$count:uint = 0;
			var cashBonusPush$count:uint = 0;
			var chestOpenedPush$count:uint = 0;
			var scratch_min_cash_play$count:uint = 0;
			var avgBallToBingo$count:uint = 0;
			var initialBallToBingo$count:uint = 0;
			var inviteShareUrl$count:uint = 0;
			var opengraph_path$count:uint = 0;
			var offers_global_timeout$count:uint = 0;
			var powerup_drop$count:uint = 0;
			var currencyConverter$count:uint = 0;
			var xpBonusLevelMin$count:uint = 0;
			var xpBonusLevelMax$count:uint = 0;
			var xpBonusMultiplier$count:uint = 0;
			var ballInterval$count:uint = 0;
			var startBallInterval$count:uint = 0;
			var ballThreshold$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (offer_show_time$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.offerShowTime cannot be set twice.');
					}
					++offer_show_time$count;
					this.offerShowTime = com.netease.protobuf.ReadUtils.read$TYPE_INT64(input);
					break;
				case 2:
					if (offer_show_interval$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.offerShowInterval cannot be set twice.');
					}
					++offer_show_interval$count;
					this.offerShowInterval = com.netease.protobuf.ReadUtils.read$TYPE_INT64(input);
					break;
				case 10:
					if (free_score_cell_score_min$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.freeScoreCellScoreMin cannot be set twice.');
					}
					++free_score_cell_score_min$count;
					this.freeScoreCellScoreMin = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 11:
					if (free_score_cell_score_max$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.freeScoreCellScoreMax cannot be set twice.');
					}
					++free_score_cell_score_max$count;
					this.freeScoreCellScoreMax = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (daily_tournament_chest_target$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.dailyTournamentChestTarget cannot be set twice.');
					}
					++daily_tournament_chest_target$count;
					this.dailyTournamentChestTarget = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 12:
					if (rate_us_enabled$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.rateUsEnabled cannot be set twice.');
					}
					++rate_us_enabled$count;
					this.rateUsEnabled = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 13:
					if (rate_us_show_interval$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.rateUsShowInterval cannot be set twice.');
					}
					++rate_us_show_interval$count;
					this.rateUsShowInterval = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 14:
					if (rate_us_min_rounds$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.rateUsMinRounds cannot be set twice.');
					}
					++rate_us_min_rounds$count;
					this.rateUsMinRounds = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 15:
					if (rate_us_tournament_top_place$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.rateUsTournamentTopPlace cannot be set twice.');
					}
					++rate_us_tournament_top_place$count;
					this.rateUsTournamentTopPlace = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 16:
					if (rate_us_daily_bonuses_taken$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.rateUsDailyBonusesTaken cannot be set twice.');
					}
					++rate_us_daily_bonuses_taken$count;
					this.rateUsDailyBonusesTaken = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 17:
					if (rate_us_ios_url$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.rateUsIosUrl cannot be set twice.');
					}
					++rate_us_ios_url$count;
					this.rateUsIosUrl = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 20:
					if (rate_us_ios7_url$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.rateUsIos7Url cannot be set twice.');
					}
					++rate_us_ios7_url$count;
					this.rateUsIos7Url = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 18:
					if (rate_us_android_url$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.rateUsAndroidUrl cannot be set twice.');
					}
					++rate_us_android_url$count;
					this.rateUsAndroidUrl = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 19:
					if (rate_us_amazon_url$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.rateUsAmazonUrl cannot be set twice.');
					}
					++rate_us_amazon_url$count;
					this.rateUsAmazonUrl = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 21:
					if (daub_hints_enabled$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.daubHintsEnabled cannot be set twice.');
					}
					++daub_hints_enabled$count;
					this.daubHintsEnabled = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 22:
					if (free_daub_hint_rounds$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.freeDaubHintRounds cannot be set twice.');
					}
					++free_daub_hint_rounds$count;
					this.freeDaubHintRounds = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 23:
					if (daub_hints_price$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.daubHintsPrice cannot be set twice.');
					}
					++daub_hints_price$count;
					this.daubHintsPrice = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 24:
					if (wbt_level_min$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.wbtLevelMin cannot be set twice.');
					}
					++wbt_level_min$count;
					this.wbtLevelMin = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 25:
					if (bad_bingo_timer_attempts$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.badBingoTimerAttempts cannot be set twice.');
					}
					++bad_bingo_timer_attempts$count;
					this.badBingoTimerAttempts = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 38:
					if (completed_page_probabilty$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.completedPageProbabilty cannot be set twice.');
					}
					++completed_page_probabilty$count;
					this.completedPageProbabilty = com.netease.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 39:
					if (daubPoints$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.daubPoints cannot be set twice.');
					}
					++daubPoints$count;
					this.daubPoints = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 40:
					if (daubXP$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.daubXP cannot be set twice.');
					}
					++daubXP$count;
					this.daubXP = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 41:
					if (pointPowerupQuantity$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.pointPowerupQuantity cannot be set twice.');
					}
					++pointPowerupQuantity$count;
					this.pointPowerupQuantity = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 42:
					if (xpPowerupQuantity$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.xpPowerupQuantity cannot be set twice.');
					}
					++xpPowerupQuantity$count;
					this.xpPowerupQuantity = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 43:
					if (cashPowerupQuantity$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.cashPowerupQuantity cannot be set twice.');
					}
					++cashPowerupQuantity$count;
					this.cashPowerupQuantity = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 44:
					if (powerupReturnCoefficent$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.powerupReturnCoefficent cannot be set twice.');
					}
					++powerupReturnCoefficent$count;
					this.powerupReturnCoefficent = com.netease.protobuf.ReadUtils.read$TYPE_FLOAT(input);
					break;
				case 45:
					if (tournamentEndPush$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.tournamentEndPush cannot be set twice.');
					}
					++tournamentEndPush$count;
					this.tournamentEndPush = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 46:
					if (cashBonusPush$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.cashBonusPush cannot be set twice.');
					}
					++cashBonusPush$count;
					this.cashBonusPush = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 47:
					if (chestOpenedPush$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.chestOpenedPush cannot be set twice.');
					}
					++chestOpenedPush$count;
					this.chestOpenedPush = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 48:
					if (scratch_min_cash_play$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.scratchMinCashPlay cannot be set twice.');
					}
					++scratch_min_cash_play$count;
					this.scratchMinCashPlay = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 49:
					if (avgBallToBingo$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.avgBallToBingo cannot be set twice.');
					}
					++avgBallToBingo$count;
					this.avgBallToBingo = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 50:
					if (initialBallToBingo$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.initialBallToBingo cannot be set twice.');
					}
					++initialBallToBingo$count;
					this.initialBallToBingo = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 51:
					if (inviteShareUrl$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.inviteShareUrl cannot be set twice.');
					}
					++inviteShareUrl$count;
					this.inviteShareUrl = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 26:
					if (opengraph_path$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.opengraphPath cannot be set twice.');
					}
					++opengraph_path$count;
					this.opengraphPath = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 28:
					if (offers_global_timeout$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.offersGlobalTimeout cannot be set twice.');
					}
					++offers_global_timeout$count;
					this.offersGlobalTimeout = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 4:
					this.dailyTournamentChestPrizes.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.DailyTournamentChestPrizeMessage()));
					break;
				case 5:
					this.powerupsInfo.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.PowerupInfoMessage()));
					break;
				case 6:
					this.roomTypes.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.RoomTypeMessage()));
					break;
				case 7:
					this.objectives.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.ObjectiveMessage()));
					break;
				case 27:
					this.customOffers.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.CustomOfferMessage()));
					break;
				case 29:
					this.collectionData.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.CollectionDataMessage()));
					break;
				case 30:
					this.periodicData.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.PeriodicBonusDataMessage()));
					break;
				case 32:
					this.cashItems.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.PlatformStoreItemsDataMessage()));
					break;
				case 33:
					this.scratchLotteries.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.ScratchLotteryDataMessage()));
					break;
				case 34:
					this.tournamentPlaceRewards.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.TournamentPlaceRewardDataMessage()));
					break;
				case 35:
					this.chestDrop.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.ChestDropDataMessage()));
					break;
				case 36:
					this.levels.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.XpLevelDataMessage()));
					break;
				case 37:
					if (powerup_drop$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.powerupDrop cannot be set twice.');
					}
					++powerup_drop$count;
					this.powerupDrop = new com.alisacasino.bingo.protocol.PowerupDropTableMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.powerupDrop);
					break;
				case 52:
					this.customDaubIcons.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.CustomDaubIcon()));
					break;
				case 54:
					this.customCards.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.CustomCard()));
					break;
				case 55:
					this.customAvatars.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.CustomAvatar()));
					break;
				case 56:
					this.customVoiceOvers.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.CustomVoiceOver()));
					break;
				case 57:
					this.customizationSets.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.CustomizationSet()));
					break;
				case 58:
					if (currencyConverter$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.currencyConverter cannot be set twice.');
					}
					++currencyConverter$count;
					this.currencyConverter = new com.alisacasino.bingo.protocol.CurrencyConverter();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.currencyConverter);
					break;
				case 59:
					this.quests.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.QuestDataMessage()));
					break;
				case 60:
					this.stakes.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.StakeDataMessage()));
					break;
				case 61:
					if (xpBonusLevelMin$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.xpBonusLevelMin cannot be set twice.');
					}
					++xpBonusLevelMin$count;
					this.xpBonusLevelMin = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 62:
					if (xpBonusLevelMax$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.xpBonusLevelMax cannot be set twice.');
					}
					++xpBonusLevelMax$count;
					this.xpBonusLevelMax = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 63:
					if (xpBonusMultiplier$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.xpBonusMultiplier cannot be set twice.');
					}
					++xpBonusMultiplier$count;
					this.xpBonusMultiplier = com.netease.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 64:
					this.questsSettings.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.QuestSettingsMessage()));
					break;
				case 65:
					if (ballInterval$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.ballInterval cannot be set twice.');
					}
					++ballInterval$count;
					this.ballInterval = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 66:
					if (startBallInterval$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.startBallInterval cannot be set twice.');
					}
					++startBallInterval$count;
					this.startBallInterval = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 67:
					if (ballThreshold$count != 0) {
						throw new flash.errors.IOError('Bad data format: StaticDataMessage.ballThreshold cannot be set twice.');
					}
					++ballThreshold$count;
					this.ballThreshold = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 68:
					this.slotMachineStatic.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.SlotMachineStatic()));
					break;
				case 69:
					this.genericDropData.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.GenericDropDataMessage()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
