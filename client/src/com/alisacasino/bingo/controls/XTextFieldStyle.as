package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.Fonts;
	import flash.utils.Dictionary;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.utils.Align;
	
	public class XTextFieldStyle
	{
		public var fontSize:Number;
		private var mFontColor:uint;
		private var mStrokeSize:Number;
		private var mStrokeColor:uint;
		public var shadowSize:Number;
		public var shadowColor:uint;
		public var hAlign:String;
		public var vAlign:String;
		public var fontName:String;
		public var charsetSourceFontName:String;
		private var _bold:Boolean = false;
		public var shadowAlpha:Number = 1.;
		private var mCharset:String;
		private var mCharMargin:int;
		
		public var shadowAngle:int;
		public var shadowBlur:int;
		public var shadowStrength:int;
		
		public function XTextFieldStyle(params:Object)
		{
			fontSize = params.fontSize ? params.fontSize : 100.0;
			mFontColor = params.fontColor;
			hAlign = params.hAlign ? params.hAlign : Align.CENTER;
			vAlign = params.vAlign ? params.vAlign : Align.CENTER;
			fontName = 'fontName' in params ? params.fontName : Fonts.WALRUS_BOLD;
			charsetSourceFontName = 'charsetSourceFontName' in params ? params.charsetSourceFontName : null;
			_bold = params.hasOwnProperty("bold") ? params.bold : false;
			mCharset = params.charset;
			mCharMargin = charMargin in params ? params.charMargin : -2;
			
			mStrokeSize = params.strokeSize;
			mStrokeColor = params.strokeColor;
			
			shadowSize = 'shadowSize' in params ? params['shadowSize'] : 0;
			shadowColor = params.shadowColor;
			shadowAlpha = params.hasOwnProperty("shadowAlpha") ? params.shadowAlpha : 1.;
			shadowAngle = params.hasOwnProperty("shadowAngle") ? params.shadowAngle : 90;
			shadowBlur = 'shadowBlur' in params ? params['shadowBlur'] : 5;
			shadowStrength = 'shadowStrength' in params ? params['shadowStrength'] : 8;
			
		}
		
		public function addStroke(strokeSize:Number, strokeColor:uint):XTextFieldStyle
		{
			mStrokeSize = strokeSize;
			mStrokeColor = strokeColor;
			return this;
		}
		
		public function get fontColor():uint
		{
			return mFontColor;
		}
		
		public function set fontColor(value:uint):void
		{
			mFontColor = value;
		}
		
		public function get strokeSize():Number
		{
			return mStrokeSize;
		}
		
		public function set strokeSize(value:Number):void
		{
			mStrokeSize = value;
		}
		
		public function get strokeColor():uint
		{
			return mStrokeColor;
		}
		
		public function set strokeColor(value:uint):void
		{
			mStrokeColor = value;
		}
		
		public function get bold():Boolean
		{
			return _bold;
		}
		
		public function get charset():String
		{
			return mCharset;
		}

		public function get charMargin():int
		{
			return mCharMargin;
		}
		
        public function toString():String
        {
            return fontName;
        }
		
		public static function getChateaudeGarage(size:int, color:int = 0xFFFFFF, hAlign:String = Align.CENTER, vAlign:String = Align.CENTER):XTextFieldStyle {
			return new XTextFieldStyle({
				fontName:       Fonts.CHATEAU_DE_GARAGE,
				fontSize:		size,
				hAlign:			hAlign,
				vAlign:			vAlign,
				fontColor:		color
			});
		}
		
		public static function getWalrus(size:int, color:int = 0xFFFFFF, hAlign:String = Align.CENTER, vAlign:String = Align.CENTER):XTextFieldStyle {
			return new XTextFieldStyle({
				fontName:       Fonts.WALRUS_BOLD,
				fontSize:		size,
				hAlign:			hAlign,
				vAlign:			vAlign,
				fontColor:		color
			});
		}
		
		public static function houseHolidaySans(size:int, color:int = 0xFFFFFF, hAlign:String = Align.CENTER, vAlign:String = Align.CENTER):XTextFieldStyle {
			return new XTextFieldStyle({
				fontName:       Fonts.HOUSE_HOLIDAY_SANS,
				fontSize:		size,
				hAlign:			hAlign,
				vAlign:			vAlign,
				fontColor:		color
			});
		}
		
		public static function getMatrixComplex(size:int, color:int = 0xFFFFFF, hAlign:String = Align.CENTER, vAlign:String = Align.CENTER):XTextFieldStyle {
			return new XTextFieldStyle({
				fontName:       Fonts.MATRIX_COMPLEX,
				fontSize:		size,
				hAlign:			hAlign,
				vAlign:			vAlign,
				fontColor:		color
			});
		}
		
		public static function getSystem(size:int, color:int = 0xFFFFFF, hAlign:String = Align.CENTER, vAlign:String = Align.CENTER):XTextFieldStyle {
			return new XTextFieldStyle({
				fontName:       '',
				fontSize:		size,
				hAlign:			hAlign,
				vAlign:			vAlign,
				fontColor:		color
			});
		}
		
		public function setShadow(shadowSize:Number=1, shadowColor:int=0, shadowAlpha:Number = 1, shadowAngle:int = 90, shadowBlur:int=5, shadowStrength:int=8):XTextFieldStyle {
			this.shadowSize = shadowSize;
			this.shadowColor = shadowColor;
			this.shadowAlpha = shadowAlpha;
			this.shadowAngle = shadowAngle;
			this.shadowBlur = shadowBlur;
			this.shadowStrength = shadowStrength;
			return this;
		}
		
		public function setStroke(strokeSize:Number=1, strokeColor:int=0x000000):XTextFieldStyle {
			mStrokeSize = strokeSize;
			mStrokeColor = strokeColor;
			return this;
		}
		
		public static const ProfileBarXpLevelTextFieldStyle:XTextFieldStyle = new XTextFieldStyle( {
			fontSize:		34.0,
			fontColor:		0xffffff,
			shadowSize:		1.0,
			shadowColor:	0x000000
		});
		
		public static const CashBonusProgress:XTextFieldStyle = new XTextFieldStyle( {
			fontSize:		50.0,
			fontColor:		0xffffff,
			strokeSize:		1,
			strokeColor:	0x000000,
			hAlign:			Align.LEFT
		});
		
		public static const ProfileBarXpLevelTextFieldBitmapStyle:XTextFieldStyle = new XTextFieldStyle( {
			fontName: "SharkLatin",
			fontSize:		28.0,
			fontColor:		0x8f360a
		});
		
		public static const ResourceBarTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		23.0,
			fontColor:		0xFFFFFF,
			shadowSize:		1.0,
			shadowColor:	0x1C0C31
		});
		
		public static const ResourceBarRedTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		26.0,
			fontColor:		0xfb173c,
			shadowSize:		1.0,
			shadowColor:	0x1C0C31
		});

		public static const BigProfileBarTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		60.0,
			fontColor:		0xffffff,
			strokeSize:		1,
			strokeColor:	0x000000
		});

		public static const ProfileItemTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		60.0,
			fontColor:		0x392809,
			hAlign:			Align.LEFT
		});
		
		public static const SettingsItemTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		62.0,
			fontColor:		0x392809,
			hAlign:			Align.LEFT
		});
		
		public static const SettingsItemOnOffTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		50.0,
			fontColor:		0xffffff,
			shadowSize:		1.0,
			shadowColor:	0x000000
		});
		
		public static const SpecialBonusTitleTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		50.0,
			fontColor:		0xededed,
			strokeSize:		2,
			strokeColor:	0x310b00			
		});
		
		public static const StoreItemTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		55.0,
			fontColor:		0x3e8a88			
		});
		
		public static const StorePriceTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		50.0,
			fontColor:		0xffffff,			
			strokeSize:		2,
			strokeColor:	0x1d6041			
		});
		
		public static const DialogTitleTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		74.0,
			fontColor:		0xffffff,
			strokeSize:		2,
			strokeColor:	0x967a64			
		});
		
		public static const DialogTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		50.0,
			fontColor:		0x392809			
		});
		
		public static const DialogLargeTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		75.0,
			fontColor:		0x392809			
		});
		
		public static const DialogHugeTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		90.0,
			fontColor:		0x392809			
		});
		
		public static const DialogAlternateTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		60.0,
			fontColor:		0xffffff,
			strokeColor:	0x40888a,
			strokeSize:		2
		});
		
		public static const OfferDialogValueTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		50.0,
			fontColor:		0xfcd4a4
		});

		public static const OfferDialogPriceTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		50.0,
			fontColor:		0xf9ea52,
			strokeColor:	0x000000,
			strokeSize:		1
		});

		public static const SelectCardsAmountTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		45.0,
			fontColor:		0x543d3d
		});
		
		public static const SelectCardsPriceTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		60.0,
			fontColor:		0xffffff
		});
		
		public static const BuyCardsClockTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		75.0,
			fontColor:		0xfffffff,
			shadowColor:	0x224c6c,
			shadowSize:		1
		});
		
		public static const BuyCardsClockSmallTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		38.0,
			fontColor:		0xfffffff,
			shadowColor:	0x224c6c,
			shadowSize:		1
		});

		public static const BallTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontName:		"BallTextFieldStyle",
			charsetSourceFontName:"Walrus Bold",
			charset:		"1234567890",
			fontSize:		52.0,
			fontColor:		0x424242,
			hAlign:			Align.CENTER
		});
		
		public static const CardNumberTextFieldStyle:XTextFieldStyle = new XTextFieldStyle( {
			charsetSourceFontName:'Chateau de Garage',
			charset:		"1234567890",
			fontName:		"CardNumberTextFieldStyle",
			fontName:		"Chateau de Garage",
			fontSize:		52.0,
			fontColor:		0x585858,
			hAlign:			Align.CENTER
		});
		
		public static const CardNumberMarkedTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			charsetSourceFontName:'Chateau de Garage',
			charset:		"1234567890",
			fontName:		"CardNumberMarkedTextFieldStyle",
			fontSize:		55.0,
			fontColor:		0xffffff
		});
		
		public static const CardPopXpTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		45.0,
			fontColor:		0xffffff,
			strokeSize:		1,
			strokeColor:	0x4cc9ef
		});
		
		public static const BlackoutCardPopXpTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		45.0,
			fontColor:		0xffffff,
			strokeSize:		1,
			strokeColor:	0x844d87
		});
		
		public static const RedCardPopXpTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		45.0,
			fontColor:		0xffffff,
			strokeSize:		1,
			strokeColor:	0xff4c00
		});
		
		public static const CardPopCoinsTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		45.0,
			fontColor:		0xf9c205,
			strokeSize:		1,
			strokeColor:	0xffffff
		});

		public static const CardPopTicketsTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		45.0,
			fontColor:		0x5bc7ea,
			strokeSize:		1,
			strokeColor:	0xffffff
		});

		public static const CardPopScoreTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		45.0,
			fontColor:		0x5bc7ea,
			strokeSize:		1,
			strokeColor:	0xffffff
		});

		public static const BingosLeftNumberTextFieldStyle:XTextFieldStyle = new XTextFieldStyle( {
			fontName: "Walrus Bold",
			fontSize:		45.0,
			fontColor:		0xfff700,
			shadowSize:		1.3,
			shadowColor:	0x000000,
			shadowAlpha:	0.3,
			shadowBlur:		1
		});
		
		public static const BingosLeftTextTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		35.0,
			fontColor:		0xff9900,
			strokeSize:		1,
			strokeColor:	0xffffff,
			shadowSize:		1,
			shadowColor:	0x000000
		});

		public static const BingosLeftTextTextFieldStyleTablet:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		30.0,
			fontColor:		0xff9900,
			strokeSize:		0.5,
			strokeColor:	0xffffff,
			shadowSize:		0.5,
			shadowColor:	0x000000
		});
		
		public static const BingosLeftNumberTextFieldStyleTablet:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		49.0,
			fontColor:		0xFEF700,
			//strokeSize:		1,
			//strokeColor:	0xffffff,
			shadowSize:		1.3,
			shadowColor:	0x000000,
			shadowAlpha: 	0.5,
			shadowBlur:		1
			
		});
		
		public static const TicketsCoinsWonTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontName:'TicketsCoinsWonTextFieldStyle',
			charsetSourceFontName:'Chateau de Garage',
			charset:		"1234567890",
			fontSize:		26.0,
			fontColor:		0x392809
		});
		
		public static const PlayersCountTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		40.0,
			fontColor:		0xffffff
		});
		
		public static const PlayerBingoedTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		40.0,
			fontColor:		0xffffff,
			shadowSize:		1,
			shadowColor:	0x000000
		});
		
		public static const NumbersTableTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			charsetSourceFontName:'Chateau de Garage',
			fontName:'NumbersTableTextFieldStyle',
			charset:		"1234567890",
			fontSize:		18.0,
			charMargin:     -3,
			fontColor:		0xffffff
		});

		public static const NoEnergyTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		40.0,
			fontColor:		0xfdf03f,
			strokeSize:		1,
			strokeColor:	0xef4945
		});
		
		public static const ObjectiveItemTitleTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		45.0,
			fontColor:		0xffffff,
			hAlign:			Align.LEFT
		});
		
		public static const ObjectiveItemRewardTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		45.0,
			fontColor:		0x423a34,
			hAlign:			Align.LEFT
		});
		
		public static const ObjectiveItemTitleDoneTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		45.0,
			fontColor:		0x384537,
			hAlign:			Align.LEFT
		});

		public static const ObjectiveItemProgressTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		40.0,
			fontColor:		0x423a34
		});

		public static const ObjectiveItemDoneTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		45.0,
			fontColor:		0x1f9c19,
			hAlign:			Align.LEFT
		});
		
		public static const CollectionTextFieldStyle1:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		50.0,
			fontColor:		0x6e6e6e			
		});

		public static const CollectionTextFieldStyle2:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		60.0,
			fontColor:		0xffffff,
			shadowSize:		2,
			shadowColor:	0xa2105a
		});

		public static const LeaderboardItemTitleTextFieldStyle:XTextFieldStyle = new XTextFieldStyle( {
			fontName:		"SharkLatin",	
			fontSize:		42.0,
			fontColor:		0xffffff,
			hAlign:			Align.LEFT
		});

		public static const LeaderboardItemScoreTextFieldStyle:XTextFieldStyle = new XTextFieldStyle( {
			fontName:		"SharkLatin",	
			fontSize:		42.0,
			fontColor:		0x423934,
			hAlign:			Align.LEFT
		});

		public static const LeaderboardItemRewardTextFieldStyle:XTextFieldStyle = new XTextFieldStyle( {
			fontName:		"SharkLatin",	
			fontSize:		28.0,
			fontColor:		0x423934
		});

		public static const LeaderboardCoinRewardAlternateTextFieldStyle:XTextFieldStyle = new XTextFieldStyle( {
			fontName:		"SharkLatin",
			fontSize:		27.0,
			fontColor:		0xffbb00,
			hAlign:			Align.LEFT
		});
		
		public static const LeaderboardTicketRewardAlternateTextFieldStyle:XTextFieldStyle = new XTextFieldStyle( {
			fontName:		"SharkLatin",
			fontSize:		27.0,
			fontColor:		0x65ccea,
			hAlign:			Align.LEFT
		});
		
		public static const InviteFriendsDialogInvitedCountTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		42.0,
			fontColor:		0x393939,
			strokeColor:	0xffffff,
			strokeSize:		2
		});
		
		public static const LobbyGiftsCountBadgeTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		30.0,
			fontColor:		0xffffff
		});

		public static const GiftAcceptDialogTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		45.0,
			fontColor:		0x302d1b
		});
		
		public static const GiftLimitCountdownTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		20.0,
			fontColor:		0x00aeef
		});
		
		public static const LeaderboardItemRankTextFieldStyle:XTextFieldStyle = new XTextFieldStyle( {
			fontName: "SharkLatin",
			fontSize:		50.0,
			fontColor:		0x115570
		});

		public static const LargeStoreItemTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		40.0,
			fontColor:		0x0d7070
		});

		public static const LargeStoreItemHighlightedTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		60.0,
			fontColor:		0x0d7070,
			strokeSize:		2,
			strokeColor:	0xffffff
		});
		
		public static const LargeStoreItemBonusTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		70.0,
			fontColor:		0x741d08
		});
		
		public static const LargeStoreBlackFridayTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		70.0,
			fontColor:		0xffacff
		});

		public static const LargeStoreItemHighlightedBonusTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		70.0,
			fontColor:		0x771b08,
			strokeSize:		2,
			strokeColor:	0xfff758
		});
		
		public static const ServiceTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		24.0,
			fontColor:		0x392809,
			hAlign:			Align.CENTER
		});
		
		public static const Yellow70C:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		70.0,
			fontColor:		0xFFFF00,
			hAlign:			Align.CENTER
		});
		
		public static const Yellow70L:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		70.0,
			fontColor:		0xFFFF00,
			hAlign:			Align.LEFT
		});
		
		public static const Yellow40L:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		40.0,
			fontColor:		0xFFFF00,
			hAlign:			Align.LEFT
		});
		
		public static const Yellow30L:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		30.0,
			fontColor:		0xFFFF00,
			hAlign:			Align.LEFT
		});
		
		public static const White70C:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		55.0,
			fontColor:		0xFFFFFF,
			hAlign:			Align.CENTER
		});
		
		public static const White70L:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		70.0,
			fontColor:		0xFFFFFF,
			hAlign:			Align.LEFT
		});
		
		public static const White30L:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		30.0,
			fontColor:		0xFFFFFF,
			hAlign:			Align.LEFT
		});
		
		public static const White40L:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		40.0,
			fontColor:		0xFFFFFF,
			hAlign:			Align.LEFT
		});
		
		public static const White70R:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		70.0,
			fontColor:		0xFFFFFF,
			hAlign:			Align.RIGHT
		});
		
		public static const SlotMachineGoldPlaqueLabelStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		70.0,
			fontColor:		0xFFFFFF,
			strokeSize:		2,
			strokeColor:	0x793C00,
			hAlign:			Align.LEFT
		});
		
		
		static public var InboxRowMessageStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		45.0,
			fontColor:		0x0096AC,
			strokeSize:		1,
			strokeColor:	0xffffff
		});
		
		static public var LoadingScreenInfoBadgeTextStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		90.0,
			fontColor:		0xffffff,
			shadowSize:		1.5,
			shadowColor:	0x000000,
			shadowAlpha: 0.7
		});
		
		public static const Green70C:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		70.0,
			fontColor:		0x84FF00,
			hAlign:			Align.CENTER
		});
		
		public static const Green70L:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		70.0,
			fontColor:		0x84FF00,
			hAlign:			Align.LEFT
		});
		
		public static const Green40L:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		40.0,
			fontColor:		0x84FF00,
			hAlign:			Align.LEFT
		});
		
		public static const Red70C:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		70.0,
			fontColor:		0xFF0000,
			hAlign:			Align.CENTER
		});
		
		public static const Red70L:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		70.0,
			fontColor:		0xFF0000,
			hAlign:			Align.LEFT
		});
		
		
		public static const Red40L:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		2.0,
			fontColor:		0xFF0000,
			hAlign:			Align.LEFT
		});
		
		public static const White50LightBlueOutline:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		50.0,
			fontColor:		0xffffff,			
			strokeSize:		2,
			strokeColor:	0x00b4ff			
		});
		
		public static const InviteFriendsDialogHintTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontName:		"SharkLatin",	
			fontSize:		45.0,
			fontColor:		0x423934,
			hAlign:			Align.LEFT
		});
		
		public static const InviteFriendItemOnTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		32.0,
			fontColor:		0x1376AB,
			bold: true
		});
		
		public static const InviteFriendItemOffTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		32.0,
			fontColor:		0x666666,
			bold: true
		});
		
		public static const InviteFriendItemOnTextureTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontName:		"SharkLatin",
			fontSize:		38.0,
			fontColor:		0x1376AB
		});
		
		public static const InviteFriendItemOffTextureTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontName:		"SharkLatin",
			fontSize:		38.0,
			fontColor:		0x666666
		});
		
		public static const BadBingoTimerTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		64.0,
			fontColor:		0xFFDB0E,
			strokeSize:		2,
			strokeColor:	0xC42600,
			hAlign:			Align.LEFT
		});
		
		public static const OfferTimerTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		38.0,
			fontColor:		0xE85F5F
		});

		public static const OfferBadgeTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		72.0,
			fontColor:		0xffffff,
			strokeSize:		1,
			strokeColor:	0x007AD0
		});
		
		public static const OfferOldPriceTextFieldStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		60.0,
			fontColor:		0xC09E8C,
			hAlign:			Align.RIGHT
		});
		
		public static const BuyCardsTitle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		42.0,
			fontColor:		0xffffff,
			strokeSize:		1,
			strokeColor:	0x293036
		});
		
		public static const BuyCardsTimer:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		42.0,
			fontColor:		0xFFFC00,
			strokeSize:		1,
			strokeColor:	0x293036,
			hAlign:			Align.LEFT
		});
		
		public static const ChestCashTitle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		24.0,
			fontColor:		0x92FFFD,
			shadowSize:		1.0,
			shadowColor:	0x1C0C31
		});
		
		static public const WalrusWhiteCenter90:XTextFieldStyle = new XTextFieldStyle({
			fontName:		"Walrus Bold",
			fontSize:		90.0,
			fontColor:		0xFFFFFF,
			hAlign:			Align.CENTER,
			shadowSize:		1.0,
			shadowColor:	0x0,
			shadowAlpha:	0.3
		});
		
		static public const WalrusWhiteCenter40:XTextFieldStyle = new XTextFieldStyle({
			fontName:		"Walrus Bold",
			fontSize:		40.0,
			fontColor:		0xFFFFFF,
			hAlign:			Align.CENTER,
			shadowSize:		1.3,
			shadowColor:	0x0,
			shadowAlpha:	0.5,
			shadowBlur:		1
		});
		
		
		public static const ResultsBigWhiteTitle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		58.0,
			fontColor:		0xFFFFFF
		});
		
		public static const ResultsBigYellowTitle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		48.0,
			fontColor:		0xFFFF00
		});
		
		public static const WalrusWhite32:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		32.0,
			fontColor:		0xFFFFFF
		});
		
		public static const WalrusWhite50:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		50.0,
			fontColor:		0xFFFFFF
		});
		
		public static const WalrusWhite33Shadowed:XTextFieldStyle = new XTextFieldStyle( {
			fontSize:		33.0,
			fontColor:		0xffffff,
			shadowSize:		1.0,
			shadowColor:	0x000000
		});

		static public var InboxPlayerNameStyle:XTextFieldStyle = new XTextFieldStyle({
            fontName:       Fonts.CHATEAU_DE_GARAGE,
			fontSize:		31.0,
			fontColor:		0x00a4f0,
			hAlign:			Align.LEFT
		});
		
		static public var InboxPlayerNameSystemFont:XTextFieldStyle = new XTextFieldStyle({
            fontName:       '',
			fontSize:		31.0,
			fontColor:		0x00a4f0,
			hAlign:			Align.LEFT
		});
		
		static public var TournamentResultPlayerNameStyle:XTextFieldStyle = new XTextFieldStyle({
            fontName:       Fonts.WALRUS_BOLD,
			fontSize:		31.0,
			fontColor:		0x30ff00,
			hAlign:			Align.CENTER
		});
		
		static public var TournamentResultPlayerNameSystemFont:XTextFieldStyle = new XTextFieldStyle({
            fontName:       '',
			fontSize:		31.0,
			fontColor:		0x30ff00,
			hAlign:			Align.CENTER
		});

		static public var InviteOutOfStyle:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		24.0,
			fontColor:		0xFFFFFF,
			strokeSize:		1.4,
			strokeColor:	0x000000,
			hAlign:			Align.CENTER
		});

		static public var InboxPlayerNameLatinStyle:XTextFieldStyle = new XTextFieldStyle({
			fontName:		"SharkLatin",
			fontSize:		32.0,
			fontColor:		0x00a4f0,
			hAlign:			Align.LEFT
		});

		static public var InboxSentYouGiftStyle:XTextFieldStyle = new XTextFieldStyle({
            fontName:       Fonts.CHATEAU_DE_GARAGE,
			fontSize:		21.0,
			fontColor:		0x6e6e6e,
			hAlign:			Align.LEFT
		});

		static public var InboxPrizeAmount:XTextFieldStyle = new XTextFieldStyle({
            fontName:       Fonts.CHATEAU_DE_GARAGE,
			fontSize:		38.0,
			fontColor:		0x5e5e5e,
			hAlign:			Align.CENTER
		});
		
		static public var CellDaubFlyUpXP:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		32,
			fontColor:		0xFFFFFF,
			shadowSize:		1.5,
			shadowColor:	0x0099ff,
			strokeSize:		0.3,
			strokeColor:	0x0099ff
			
		});
		
		static public var CellDaubFlyUpXP_X2:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		32,
			fontColor:		0xFFFFFF,
			shadowSize:		1.5,
			shadowColor:	0xFF5529,
			strokeSize:		0.3,
			strokeColor:	0xFF5529
			
		});
		
		static public var CellFlyUpCash:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		32,
			fontColor:		0xFFFFFF,
			shadowSize:		1.2,
			shadowColor:	0x7424a6,
			strokeSize:		0.25,
			strokeColor:	0x7424a6
			
		});
		
		static public var CellFlyUpScore:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		32,
			fontColor:		0xFFFFFF,
			shadowSize:		1.2,
			shadowColor:	0xd658e9,
			strokeSize:		0.25,
			strokeColor:	0xd658e9
			
		});
		
		static public var CellFlyUpXP:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		32,
			fontColor:		0xFFFFFF,
			shadowSize:		1.2,
			shadowColor:	0x0099ff,
			strokeSize:		0.25,
			strokeColor:	0x0099ff
			
		});
		
		static public var CellFlyUp2X:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		32,
			fontColor:		0xFFFFFF,
			shadowSize:		1.2,
			shadowColor:	0xfe740f,
			strokeSize:		0.25,
			strokeColor:	0xfe740f
			
		});
		
		static public var CellFlyUpMinigame:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		32,
			fontColor:		0xFFFFFF,
			shadowSize:		1.2,
			shadowColor:	0x995ccc,
			strokeSize:		0.25,
			strokeColor:	0x995ccc
			
		});
		
		static public var ChestCardTitlePurple:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		62,
			fontColor:		0xE78BFF,
			hAlign:			Align.LEFT,
			strokeSize:		1,
			strokeColor:	0x000000	
		});
		
		static public var ChestCardTitleWhite:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		62,
			fontColor:		0xFFFFFF,
			hAlign:			Align.LEFT,
			strokeSize:		1,
			strokeColor:	0x000000	
		});
		
		static public var ChestCardTitleBlue:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		62,
			fontColor:		0x78eaff,
			hAlign:			Align.LEFT,
			strokeSize:		1,
			strokeColor:	0x000000	
		});
		
		static public var ChestCardTitleOrange:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		62,
			fontColor:		0xffc527,
			hAlign:			Align.LEFT,
			strokeSize:		1,
			strokeColor:	0x000000	
		});
		
		static public var ChestCardTitleGreen:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		62,
			fontColor:		0x19fe49,
			hAlign:			Align.LEFT,
			strokeSize:		1,
			strokeColor:	0x000000	
		});
		
		static public var ChestCardTypePurple:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		37,
			fontColor:		0xE78BFF,
			hAlign:			Align.LEFT,
			strokeSize:		1,
			strokeColor:	0x000000	
		});
		
		static public var ChestCardTypeWhite:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		37,
			fontColor:		0xFFFFFF,
			hAlign:			Align.LEFT,
			strokeSize:		1,
			strokeColor:	0x000000	
		});
		
		static public var BuyForCashButton:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		21,
			fontColor:		0xFFFFFF,
			shadowSize:		1.4,
			shadowColor:	0x087315
		});
		
		static public var BuyForCashButtonCashValue:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		30,
			fontColor:		0xFFFFFF,
			shadowSize:		1.4,
			shadowColor:	0x087315
		});
		
		static public var OfferPackBuyForRealButton:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		34,
			fontColor:		0xFFFFFF,
			shadowSize:		1.4,
			shadowColor:	0x087315
		});
		
		static public var LeaderboardRankStandard:XTextFieldStyle = new XTextFieldStyle({
			fontName:       Fonts.CHATEAU_DE_GARAGE,
			fontSize:		28,
			fontColor:		0x6b6b6b
		});
		
		static public var LeaderboardRankFirst:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		50,
			fontColor:		0xF7EB11,
			shadowSize:		1.0,
			shadowColor:	0x000000
		});
		
		static public var LeaderboardRankSecond:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		50,
			fontColor:		0xB4EBFF,
			shadowSize:		1.0,
			shadowColor:	0x000000
		});
		
		static public var LeaderboardRankThird:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		50,
			fontColor:		0xF5A854,
			shadowSize:		1.0,
			shadowColor:	0x000000
		});
		
		static public var BuyCardCash:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		35.0,
			fontColor:		0xFFFFFF,
			shadowSize:		1.2,
			shadowColor:	0x1C0C31
		});
		
		static public var BuyCardSelected:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		29.0,
			fontColor:		0xFFFFFF
		});
		
		static public var FreeChestSlot:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		29.0,
			fontColor:		0xFFFFFF,
			shadowSize:		1.2,
			shadowColor:	0x1C0C31
		});
		
		static public var ChestOpenCardCountNormal:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		56.0,
			fontColor:		0xFFFFFF,
			strokeSize:		1,
			strokeColor:	0x000000	
		});
		
		static public var ChestOpenCardCountSmall:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		43.0,
			fontColor:		0xFFFFFF,
			strokeSize:		1,
			strokeColor:	0x000000	
		});
		
		static public var MenuProfileXpLabel:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		24.0,
			fontColor:		0xFFFFFF,
			shadowSize:		1.2,
			shadowColor:	0x0028ba,
			shadowAlpha: 	1,
			shadowBlur:		4
		});
		
		static public var MenuProfileNickNameLabel:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		30.0,
			fontColor:		0xFFFFFF,
			hAlign:			Align.LEFT
		});
		
		static public var LeaderboardsPlayerName:XTextFieldStyle = new XTextFieldStyle({
			fontName:       Fonts.CHATEAU_DE_GARAGE,
			fontSize:		24,
			fontColor:		0x00a4f0,
			hAlign:			Align.LEFT
		});
		
		static public var LeaderboardsBotName:XTextFieldStyle = new XTextFieldStyle({
			fontName:       Fonts.CHATEAU_DE_GARAGE,
			fontSize:		24,
			fontColor:		0xF05A5C,
			hAlign:			Align.LEFT
		});
		
		
		static public var WinnerPlayerNameYellow:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		27,
			fontColor:		0xefdd13,
			strokeSize:		1,
			strokeColor:	0x000000,	
			hAlign:			Align.LEFT
		});
		
		static public var WinnerPlayerNameSilver:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		27,
			fontColor:		0xc4eafb,
			strokeSize:		1,
			strokeColor:	0x000000,	
			hAlign:			Align.LEFT
		});
		
		static public var WinnerPlayerNameBronze:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		27,
			fontColor:		0xf3a74b,
			strokeSize:		1,
			strokeColor:	0x000000,	
			hAlign:			Align.LEFT
		});
		
		static public var WinnerPlayerNameWhite:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		27,
			fontColor:		0xFFFFFF,
			strokeSize:		1,
			strokeColor:	0x000000,	
			hAlign:			Align.LEFT
		});
		
		static public var WinnerBotName:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		27,
			fontColor:		0xF05A5C,
			strokeSize:		1,
			strokeColor:	0x000000,
			hAlign:			Align.LEFT
		});
		
		static public var CardsIconViewBig:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		60,
			fontColor:		0xFFFFFF,
			strokeSize:		0.8,
			strokeColor:	0x000000
		});
		
		static public var CardsIconViewSmall:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		46,
			fontColor:		0xFFFFFF,
			strokeSize:		0.8,
			strokeColor:	0x000000
		});
		
		static public var InventoryRendererCount:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		23,
			fontColor:		0xFFFFFF
		});
		
		static public var Streak10x:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		36,
			fontColor:		0xFFFFFF,
			shadowSize:		1.2,
			shadowColor:	0xfe240f,
			strokeSize:		0.25,
			strokeColor:	0xfe240f
			
		});
		
		static public var LeaderboardXp:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		20,
			fontColor:		0xFFFFFF,
			shadowSize:		1,
			shadowColor:	0x0028ba,
			shadowBlur:		4
		});
		
		static public var PlayButton:XTextFieldStyle = new XTextFieldStyle({
			fontSize:		61.0,
			fontColor:		0xffffff,
			shadowSize:		2,
			shadowColor:	0x0B4CAA,
			shadowBlur:		1.1,
			shadowStrength: 2
		});
		
		
		/***********************
		 * 
		 * Helpers:
		 * 
		 * *********************/
		
		private static var allStyles:Vector.<XTextFieldStyle>;
		
		private static var allStylesNames:Dictionary;
		
		static public function getNext(currentStyle:XTextFieldStyle):XTextFieldStyle 
		{
			createStylesList();
			var index:int = allStyles.indexOf(currentStyle);
			
			if (index >= allStyles.length -1)
				index = -1;
			
			return allStyles[index + 1];
		}
		
		static public function getPrevious(currentStyle:XTextFieldStyle):XTextFieldStyle 
		{
			createStylesList();
			var index:int = allStyles.indexOf(currentStyle);
			
			if (index <= 0)
				index = allStyles.length;
			
			return allStyles[index - 1];
		}
		
		static public function getInfo(currentStyle:XTextFieldStyle):String
		{
			createStylesList();
			
			if (!currentStyle)
				return 'style is null'; 
				
			var index:int = allStyles.indexOf(currentStyle);
			if (index == -1)
				return 'No style in list. Add it!';
			
			var name:String = currentStyle in allStylesNames ? allStylesNames[currentStyle] : 'no name or not added';	
			
			return name + ", size: " + currentStyle.fontSize + " | " + index + " off " + allStyles.length + ' | ' + (TextField.getBitmapFont(currentStyle.fontName) ? 'BitmapFont' : 'NativeFont');
		}
		
		static private function createStylesList():void 
		{
			if (allStyles)
				return;
			allStyles = new <XTextFieldStyle> [];
			
			allStylesNames = new Dictionary();
			
			allStylesNames[ProfileBarXpLevelTextFieldStyle] = "ProfileBarXpLevelTextFieldStyle";
			allStylesNames[ProfileBarXpLevelTextFieldBitmapStyle] = "ProfileBarXpLevelTextFieldBitmapStyle";
			allStylesNames[ResourceBarTextFieldStyle] = "ResourceBarTextFieldStyle";
			allStylesNames[ResourceBarRedTextFieldStyle] = "ResourceBarRedTextFieldStyle";
			allStylesNames[BigProfileBarTextFieldStyle] = "BigProfileBarTextFieldStyle";
			allStylesNames[ProfileItemTextFieldStyle] = "ProfileItemTextFieldStyle";
			allStylesNames[SettingsItemTextFieldStyle] = "SettingsItemTextFieldStyle";
			allStylesNames[SettingsItemOnOffTextFieldStyle] = "SettingsItemOnOffTextFieldStyle";
			allStylesNames[SpecialBonusTitleTextFieldStyle] = "SpecialBonusTitleTextFieldStyle";
			allStylesNames[StoreItemTextFieldStyle] = "StoreItemTextFieldStyle";
			allStylesNames[StorePriceTextFieldStyle] = "StorePriceTextFieldStyle";
			allStylesNames[DialogTitleTextFieldStyle] = "DialogTitleTextFieldStyle";
			allStylesNames[DialogTextFieldStyle] = "DialogTextFieldStyle";
			allStylesNames[DialogLargeTextFieldStyle] = "DialogLargeTextFieldStyle";
			allStylesNames[DialogHugeTextFieldStyle] = "DialogHugeTextFieldStyle";
			allStylesNames[DialogAlternateTextFieldStyle] = "DialogAlternateTextFieldStyle";
			allStylesNames[OfferDialogValueTextFieldStyle] = "OfferDialogValueTextFieldStyle";
			allStylesNames[OfferDialogPriceTextFieldStyle] = "OfferDialogPriceTextFieldStyle";
			allStylesNames[SelectCardsAmountTextFieldStyle] = "SelectCardsAmountTextFieldStyle";
			allStylesNames[SelectCardsPriceTextFieldStyle] = "SelectCardsPriceTextFieldStyle";
			allStylesNames[BuyCardsClockTextFieldStyle] = "BuyCardsClockTextFieldStyle";
			allStylesNames[BuyCardsClockSmallTextFieldStyle] = "BuyCardsClockSmallTextFieldStyle";
			allStylesNames[BallTextFieldStyle] = "BallTextFieldStyle";
			allStylesNames[CardNumberTextFieldStyle] = "CardNumberTextFieldStyle";
			allStylesNames[CardNumberMarkedTextFieldStyle] = "CardNumberMarkedTextFieldStyle";
			allStylesNames[CardPopXpTextFieldStyle] = "CardPopXpTextFieldStyle";
			allStylesNames[BlackoutCardPopXpTextFieldStyle] = "BlackoutCardPopXpTextFieldStyle";
			allStylesNames[RedCardPopXpTextFieldStyle] = "RedCardPopXpTextFieldStyle";
			allStylesNames[CardPopCoinsTextFieldStyle] = "CardPopCoinsTextFieldStyle";
			allStylesNames[CardPopTicketsTextFieldStyle] = "CardPopTicketsTextFieldStyle";
			allStylesNames[CardPopScoreTextFieldStyle] = "CardPopScoreTextFieldStyle";
			allStylesNames[BingosLeftNumberTextFieldStyle] = "BingosLeftNumberTextFieldStyle";
			allStylesNames[BingosLeftTextTextFieldStyle] = "BingosLeftTextTextFieldStyle";
			allStylesNames[BingosLeftTextTextFieldStyleTablet] = "BingosLeftTextTextFieldStyleTablet";
			allStylesNames[BingosLeftNumberTextFieldStyleTablet] = "BingosLeftNumberTextFieldStyleTablet";
			allStylesNames[TicketsCoinsWonTextFieldStyle] = "TicketsCoinsWonTextFieldStyle";
			allStylesNames[PlayersCountTextFieldStyle] = "PlayersCountTextFieldStyle";
			allStylesNames[PlayerBingoedTextFieldStyle] = "PlayerBingoedTextFieldStyle";
			allStylesNames[NumbersTableTextFieldStyle] = "NumbersTableTextFieldStyle";
			allStylesNames[NoEnergyTextFieldStyle] = "NoEnergyTextFieldStyle";
			allStylesNames[ObjectiveItemTitleTextFieldStyle] = "ObjectiveItemTitleTextFieldStyle";
			allStylesNames[ObjectiveItemRewardTextFieldStyle] = "ObjectiveItemRewardTextFieldStyle";
			allStylesNames[ObjectiveItemTitleDoneTextFieldStyle] = "ObjectiveItemTitleDoneTextFieldStyle";
			allStylesNames[ObjectiveItemProgressTextFieldStyle] = "ObjectiveItemProgressTextFieldStyle";
			allStylesNames[ObjectiveItemDoneTextFieldStyle] = "ObjectiveItemDoneTextFieldStyle";
			allStylesNames[CollectionTextFieldStyle1] = "CollectionTextFieldStyle1";
			allStylesNames[CollectionTextFieldStyle2] = ";CollectionTextFieldStyle2";
			allStylesNames[LeaderboardItemTitleTextFieldStyle] = "LeaderboardItemTitleTextFieldStyle";
			allStylesNames[LeaderboardItemScoreTextFieldStyle] = "LeaderboardItemScoreTextFieldStyle";
			allStylesNames[LeaderboardItemRewardTextFieldStyle] = "LeaderboardItemRewardTextFieldStyle";
			allStylesNames[LeaderboardCoinRewardAlternateTextFieldStyle] = "LeaderboardCoinRewardAlternateTextFieldStyle";
			allStylesNames[LeaderboardTicketRewardAlternateTextFieldStyle] = "LeaderboardTicketRewardAlternateTextFieldStyle";
			allStylesNames[InviteFriendItemOnTextFieldStyle] = "InviteFriendItemOnTextFieldStyle";
			allStylesNames[InviteFriendItemOffTextFieldStyle] = "InviteFriendItemOffTextFieldStyle";
			allStylesNames[InviteFriendItemOnTextureTextFieldStyle] = "InviteFriendItemOnTextureTextFieldStyle";
			allStylesNames[InviteFriendItemOffTextureTextFieldStyle] = "InviteFriendItemOffTextureTextFieldStyle";
			allStylesNames[InviteFriendsDialogInvitedCountTextFieldStyle] = "InviteFriendsDialogInvitedCountTextFieldStyle";
			allStylesNames[LobbyGiftsCountBadgeTextFieldStyle] = "LobbyGiftsCountBadgeTextFieldStyle";
			allStylesNames[GiftAcceptDialogTextFieldStyle] = "GiftAcceptDialogTextFieldStyle";
			allStylesNames[GiftLimitCountdownTextFieldStyle] = "GiftLimitCountdownTextFieldStyle";
			allStylesNames[LeaderboardItemRankTextFieldStyle] = "LeaderboardItemRankTextFieldStyle";
			allStylesNames[LargeStoreItemTextFieldStyle] = "LargeStoreItemTextFieldStyle";
			allStylesNames[LargeStoreItemHighlightedTextFieldStyle] = "LargeStoreItemHighlightedTextFieldStyle";
			allStylesNames[LargeStoreItemBonusTextFieldStyle] = "LargeStoreItemBonusTextFieldStyle";
			allStylesNames[LargeStoreItemHighlightedBonusTextFieldStyle] = "LargeStoreItemHighlightedBonusTextFieldStyle";
			allStylesNames[ServiceTextFieldStyle] = "ServiceTextFieldStyle";
			allStylesNames[Yellow70C] = "Yellow70C";
			allStylesNames[White70C] = "White70C";
			allStylesNames[White70R] = "White70R";
			allStylesNames[SlotMachineGoldPlaqueLabelStyle] = "SlotMachineGoldPlaqueLabelStyle";
			allStylesNames[InboxRowMessageStyle] = "InboxRowMessageStyle";
			allStylesNames[LoadingScreenInfoBadgeTextStyle] = "LoadingScreenInfoBadgeTextStyle";
			allStylesNames[InviteFriendsDialogHintTextFieldStyle] = "InviteFriendsDialogHintTextFieldStyle";
			allStylesNames[BadBingoTimerTextFieldStyle] = "BadBingoTimerTextFieldStyle";
			allStylesNames[OfferTimerTextFieldStyle] = "OfferTimerTextFieldStyle";
			allStylesNames[OfferBadgeTextFieldStyle] = "OfferBadgeTextFieldStyle";
		
			for ( var style:XTextFieldStyle in allStylesNames) {
				allStyles.push(style);
			}
		}
		
		public function clone():XTextFieldStyle 
		{
			var raw:Object = {};
			raw['fontSize'] = fontSize;
			raw['fontColor'] = mFontColor;
			raw['strokeSize'] = mStrokeSize;
			raw['strokeColor'] = mStrokeColor;
			raw['shadowSize'] = shadowSize;
			raw['shadowColor'] = shadowColor;
			raw['shadowAlpha'] = shadowAlpha;
			raw['shadowAngle'] = shadowAngle;
			raw['shadowBlur'] = shadowBlur;
			raw['shadowStrength'] = shadowStrength;
			raw['hAlign'] = hAlign;
			raw['vAlign'] = vAlign;
			raw['fontName'] = fontName;
			raw['bold'] = _bold;
			raw['charset'] = mCharset;
			raw['charMargin'] = mCharMargin;
			raw['fontSize'] = fontSize;
			raw['charsetSourceFontName'] = charsetSourceFontName;
			return new XTextFieldStyle(raw);
		}
		
		public function addShadow(distance:Number, color:uint, alpha:Number = 1., blur:Number = 2.):XTextFieldStyle 
		{
			shadowSize = distance;
			shadowColor = color;
			shadowAlpha = alpha;
			shadowBlur = blur;
			return this;
		}
	}
}