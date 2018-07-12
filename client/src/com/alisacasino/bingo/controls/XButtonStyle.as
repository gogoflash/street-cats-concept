package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import flash.geom.Rectangle;
	import starling.utils.Align;

	public class XButtonStyle
	{
		private var mUpStateTextureName:String;
		private var mDownStateTextureName:String;
		private var mDisabledStateTextureName:String
		private var mAtlas:AtlasAsset;
		private var mTopAligned:Boolean;
		private var mBottomAligned:Boolean;
		private var mTextFieldStyle:XTextFieldStyle;
		private var mDisabledTextFieldStyle:XTextFieldStyle;
		private var _labelYShift:Number;
		private var _labelXShift:Number;
		public var scale9Rect:Rectangle;
		public var width:int;
		public var height:int;
		public var icon:String
		public var iconYShift:Number;
		public var iconXShift:Number;
		public var soundAsset:SoundAsset;
		public var soundVolume:Number = 1;
		
		public var emptyTextureWidth:int;
		public var emptyTextureHeight:int;
		
		public function get labelXShift():Number 
		{
			return _labelXShift;
		}
		
		public function set labelXShift(value:Number):void 
		{
			_labelXShift = value;
		}
		
		public function XButtonStyle(params:Object)
		{
			mUpStateTextureName = params.upState;
			mDownStateTextureName = params.downState;
			mDisabledStateTextureName = params.disabledState;
			mTextFieldStyle = params.textFieldStyle;
			mDisabledTextFieldStyle = params.disabledTextFieldStyle;
			mTopAligned = params.topAligned;
			mBottomAligned = params.bottomAligned;
			mAtlas = params.atlas;
			labelXShift = params.hasOwnProperty("labelXShift") ? params.labelXShift : 0;
			labelYShift = params.hasOwnProperty("labelYShift") ? params.labelYShift : 0;
			scale9Rect = (params["scale9Rect"] as Rectangle);
			width = 'width' in params ? params['width'] : 0;
			height = 'height' in params ? params['height'] : 0;
			
			emptyTextureWidth = 'emptyTextureWidth' in params ? params['emptyTextureWidth'] : 100;
			emptyTextureHeight = 'emptyTextureHeight' in params ? params['emptyTextureHeight'] : 35;
			
			if ('icon' in params && params['icon'] != '') {
				icon = params['icon'];
				iconXShift = 'iconXShift' in params ? params['iconXShift'] : 0;
				iconYShift = 'iconYShift' in params ? params['iconYShift'] : 0;
			}
			
			if (soundAsset in params) {
				soundAsset = params.soundAsset;
				soundVolume = params.soundVolume || 1;
			}
			else {
				soundAsset = SoundAsset.ButtonClick;
				soundVolume = SoundAsset.DEFAULT_BUTTON_CLICK_VOLUME;
			}
		}
		
		public function clone():XButtonStyle {
			var raw:Object = {};
			raw['upState'] = mUpStateTextureName;
			raw['downState'] = mDownStateTextureName;
			raw['disabledState'] = mDisabledStateTextureName;
			raw['topAligned'] = mTopAligned;
			raw['bottomAligned'] = mBottomAligned;
			raw['atlas'] = mAtlas;
			raw['labelXShift'] = labelXShift;
			raw['labelYShift'] = labelYShift;
			raw['scale9Rect'] = new Rectangle(scale9Rect.x, scale9Rect.y, scale9Rect.width, scale9Rect.height);
			raw['width'] = width;
			raw['height'] = height;
			raw['icon'] = icon;
			raw['iconXShift'] = iconXShift;
			raw['iconYShift'] = iconYShift;
			raw['emptyTextureWidth'] = emptyTextureWidth;
			raw['emptyTextureHeight'] = emptyTextureHeight;
			
			if(mTextFieldStyle)
				raw['textFieldStyle'] = mTextFieldStyle.clone();
				
			if(mDisabledTextFieldStyle)
				raw['disabledTextFieldStyle'] = mDisabledTextFieldStyle.clone();
			
			return new XButtonStyle(raw);
		}
		
		public function get upStateTextureName():String
		{
			return mUpStateTextureName;
		}
		
		public function set upStateTextureName(value:String):void
		{
			mUpStateTextureName = value;
		}
		
		public function get downStateTextureName():String
		{
			return mDownStateTextureName;
		}
		
		public function get disabledStateTextureName():String
		{
			return mDisabledStateTextureName;
		}
		
		public function get topAligned():Boolean
		{
			return mTopAligned;
		}
		
		public function get bottomAligned():Boolean
		{
			return mBottomAligned;
		}

		public function get textFieldStyle():XTextFieldStyle
		{
			return mTextFieldStyle;
		}
		
		public function get disabledTextFieldStyle():XTextFieldStyle
		{
			return mDisabledTextFieldStyle;
		}
		
		public function get atlas():AtlasAsset
		{
			return mAtlas;
		}
		
		public function get labelYShift():Number 
		{
			return _labelYShift;
		}
		
		public function set labelYShift(value:Number):void 
		{
			_labelYShift = value;
		}
		
		public static const DialogCloseButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"dialogs/buttons/close",
			atlas:			AtlasAsset.LoadingAtlas
		});
		
		public static const DialogGreenButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"buttons/green_base",
			disabledState:	"buttons/gray_base",
			atlas:			AtlasAsset.CommonAtlas,
			scale9Rect:     new Rectangle(96, 0, 12, 0),
			width:			233,
			labelYShift:	1,
			textFieldStyle:	new XTextFieldStyle({
				fontSize:		35.0,
				fontColor:		0xffffff,
				shadowSize:		1.4,
				shadowColor:	0x087315
			}),
			disabledTextFieldStyle: new XTextFieldStyle({
				fontSize:		35.0,
				fontColor:		0xffffff,
				shadowSize:		1.4,
				shadowColor:	0x333333
			})
		});
		
		public static const ProfileShopGreenButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"buttons/green_base",
			disabledState:	"buttons/gray_base",
			atlas:			AtlasAsset.CommonAtlas,
			scale9Rect:     new Rectangle(96, 0, 12, 0),
			width:			190,
			labelYShift:	1,
			textFieldStyle:	new XTextFieldStyle({
				fontSize:		32.0,
				fontColor:		0xffffff,
				shadowSize:		1.4,
				shadowColor:	0x087315
			}),
			disabledTextFieldStyle: new XTextFieldStyle({
				fontSize:		32.0,
				fontColor:		0xffffff,
				shadowSize:		1.4,
				shadowColor:	0x333333
			})
		});
		
		public static const InventoryPurple:XButtonStyle = new XButtonStyle({
			upState:		"buttons/purple_base",
			disabledState:	"buttons/gray_base",
			atlas:			AtlasAsset.CommonAtlas,
			scale9Rect:     new Rectangle(87, 0, 1, 0),
			width:			280,
			height:			64,
			labelYShift:	1,
			textFieldStyle:	new XTextFieldStyle({
				fontSize:		32.0,
				fontColor:		0xffffff,
				shadowSize:		1.4,
				shadowColor:	0x4E009E
			}),
			disabledTextFieldStyle: new XTextFieldStyle({
				fontSize:		32.0,
				fontColor:		0xffffff,
				shadowSize:		1.4,
				shadowColor:	0x333333
			})
		});
		
		public static const DialogBigGreenButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"buttons/green_big",
			disabledState:	"buttons/gray_big",
			atlas:			AtlasAsset.CommonAtlas,
			labelYShift:	1,
			emptyTextureWidth: 200,
			emptyTextureHeight: 45,
			textFieldStyle:	new XTextFieldStyle({
				fontSize:		35.0,
				fontColor:		0xffffff,
				shadowSize:		1.4,
				shadowColor:	0x087315
			}),
			disabledTextFieldStyle: new XTextFieldStyle({
				fontSize:		35.0,
				fontColor:		0xffffff,
				shadowSize:		1.4,
				shadowColor:	0x333333
			})
		});
		
		public static const LoadAtlasDialogBigGreen:XButtonStyle = new XButtonStyle({
			upState:		"dialogs/buttons/green_button_big_slice",
			atlas:			AtlasAsset.LoadingAtlas,
			scale9Rect:     new Rectangle(18, 0, 2, 0),
			width:			279,
			labelYShift:	1,
			emptyTextureWidth: 200,
			emptyTextureHeight: 45,
			textFieldStyle:	new XTextFieldStyle({
				fontSize:		35.0,
				fontColor:		0xffffff,
				shadowSize:		1.4,
				shadowColor:	0x087315
			}),
			disabledTextFieldStyle: new XTextFieldStyle({
				fontSize:		35.0,
				fontColor:		0xffffff,
				shadowSize:		1.4,
				shadowColor:	0x333333
			})
		});
		
		public static const DialogRedButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"dialogs/buttons/red_base",
			downState:		"dialogs/buttons/red_base_on",
			atlas:			AtlasAsset.LoadingAtlas,
			topAligned:		true,
			textFieldStyle:	new XTextFieldStyle({
				fontSize:		70.0,
				fontColor:		0x9e0000,
				strokeSize:		2,
				strokeColor:	0xeeeeee
			})
		});
		
		public static const DialogBigBlueButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"dialogs/buttons/big_blue",
			downState:		"dialogs/buttons/big_blue_on",
			atlas:			AtlasAsset.LoadingAtlas,
			topAligned:		true,
			textFieldStyle:	new XTextFieldStyle({
				fontSize:		70.0,
				fontColor:		0xffffff,
				strokeSize:		2,
				strokeColor:	0x004b6d
			})
		});
		
		public static const ProfileButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"lobby/profile_button",
			downState:		"lobby/profile_button_on",
			atlas:			AtlasAsset.CommonAtlas,
			textFieldStyle:	new XTextFieldStyle({
				fontSize:		50.0,
				fontColor:		0xffffff,
				strokeSize:		2,
				strokeColor:	0x062e4e
			})
		});
		
		public static const BarPlusButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"bars/plus",
			atlas:			AtlasAsset.CommonAtlas
		});
		
		public static const BarPlusSaleButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"bars/plus_sale",
			atlas:			AtlasAsset.CommonAtlas
		});

		public static const BarLeaderboardsButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"bars/leaderboard",
			atlas:			AtlasAsset.CommonAtlas,
			textFieldStyle: new XTextFieldStyle({
				fontSize:		30.0,
				fontColor:		0xffffff,
				strokeSize:		1,
				strokeColor:	0x054200
			})
		});
		
		public static const ObjectivesButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"lobby/obj_ico",
			atlas:			AtlasAsset.CommonAtlas,
			bottomAligned:	true,
			textFieldStyle:	new XTextFieldStyle({
				fontSize:		42.0,
				fontColor:		0xededed,
				strokeSize:		2,
				strokeColor:	0x310b00
			}),
			labelYShift: 7
		});
		
		
		public static const CollectionsButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"collections",
			atlas:			AtlasAsset.CommonAtlas,
			bottomAligned:	true,
			textFieldStyle:	new XTextFieldStyle({
				fontSize:		42.0,
				fontColor:		0xededed,
				strokeSize:		2,
				strokeColor:	0x310b00
			}),
			labelYShift: 5
		});
		
		public static const FriendsButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"dialogs/buy_cards/pink_medium_up",
			atlas:			AtlasAsset.CommonAtlas,
			bottomAligned:	true,
			textFieldStyle:	new XTextFieldStyle({
				fontSize:		42.0,
				fontColor:		0xededed,
				strokeSize:		2,
				strokeColor:	0x310b00
			}),
			labelYShift: 5
		});
		
		public static const InboxButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"dialogs/buy_cards/pink_medium_up",
			atlas:			AtlasAsset.CommonAtlas,
			bottomAligned:	true,
			textFieldStyle:	new XTextFieldStyle({
				fontSize:		42.0,
				fontColor:		0xededed,
				strokeSize:		2,
				strokeColor:	0x310b00
			})
		});
		
		public static const SpecialBonusButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"lobby/bonus_button_ready",
			downState:		"lobby/bonus_button_ready_on",
			disabledState:	"lobby/bonus_button",
			atlas:			AtlasAsset.CommonAtlas,
			textFieldStyle:	new XTextFieldStyle({
				fontSize:		50.0,
				fontColor:		0xdffe00,
				strokeSize:		2,
				strokeColor:	0x2f0616
			}),
			disabledTextFieldStyle: new XTextFieldStyle({
				fontSize:		50.0,
				fontColor:		0xe9c869
			})
		});
		
		
		public static const StandardStoreItemButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"dialogs/store/base",
			atlas:			AtlasAsset.CommonAtlas
		});
		
		public static const LargeStoreItemButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"dialogs/blue_item_background",
			atlas:			AtlasAsset.CommonAtlas
		});
		
		public static const LargeStoreBuyButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"dialogs/store/store_btn",
			downState:		"dialogs/store/store_btn_on",
			atlas:			AtlasAsset.CommonAtlas,
			textFieldStyle: new XTextFieldStyle({
				fontColor:	0xffffff,
				fontSize:	50,
				strokeSize:	2,
				strokeColor: 0x0c5e3b
			})
		});

		public static const SettingsButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"lobby/settings",
			downState:		"lobby/settings_on",
			atlas:			AtlasAsset.CommonAtlas
		});
		
		public static const FullScreenButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"side_menu/full_screen_icon",
			atlas:			AtlasAsset.CommonAtlas
		});
		
		public static const LobbyMenuButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"buttons/menu_button",
			atlas:			AtlasAsset.CommonAtlas,
			scale9Rect:     new Rectangle(1, 1, 2, 0),
			width: 105, //+50px
			height: 90
		});
		
		public static const GameMenuButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"game/side_menu_btn",
			atlas:			AtlasAsset.CommonAtlas,
			scale9Rect:     new Rectangle(1, 1, 2, 0),
			width: 123,
			height: 117
		});
		
		public static const LargeBlueButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"buttons/blue_base",
			atlas:			AtlasAsset.CommonAtlas,
			scale9Rect:     new Rectangle(19, 15, 233, 39),
			width: 324,
			height: 84,
			labelYShift:    2,
			textFieldStyle: new XTextFieldStyle({
				fontName:		"Walrus Bold",
				fontSize:		40.0,
				fontColor:		0xFFFFFF,
				hAlign:			Align.CENTER,
				shadowSize:		1.4,
				shadowColor:	0x2364e9,
				shadowAlpha:	1,
				shadowBlur:		8
			})
		});
		
		public static const ObjectiveItemButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"dialogs/objectives/obj_button",
			downState:		"dialogs/objectives/obj_button_on",
			atlas:			AtlasAsset.CommonAtlas,
			textFieldStyle: new XTextFieldStyle({
				fontColor:	0xffffff,
				fontSize:	50,
				strokeSize:	2,
				strokeColor: 0x61002f
			})
		});
		
		public static const CardScrollButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"card/arrow",
			atlas:			AtlasAsset.CommonAtlas
		});
		
		
		static public const MediumGreenButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"buttons/green_medium_up",
			downState:		"buttons/green_medium_down",
			atlas:			AtlasAsset.CommonAtlas,
			textFieldStyle: new XTextFieldStyle({
				fontColor:	0xffffff,
				fontSize:	50,
				strokeSize:	2,
				strokeColor: 0x0c5e3b
			})
		});
		
		
		static public const FacebookConnectButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"buttons/blue_base",
			atlas:			AtlasAsset.CommonAtlas,
			labelYShift:    2,
			scale9Rect:     new Rectangle(134, 41, 2, 0),
			width:			323,
			height:			85,
			textFieldStyle: new XTextFieldStyle({
				fontSize:		36.0,
				fontColor:		0xffffff,
				shadowSize:		1.4,
				shadowColor:	0x0076D0
			})
		});
		
		static public const LoadScreenFacebookConnect:XButtonStyle = new XButtonStyle({
			upState:		"dialogs/buttons/blue_base",
			atlas:			AtlasAsset.LoadingAtlas,
			labelYShift:    2,
			scale9Rect:     new Rectangle(65, 41, 2, 0),
			width:			323,
			height:			85,
			textFieldStyle: new XTextFieldStyle({
				fontSize:		36.0,
				fontColor:		0xffffff,
				shadowSize:		1.4,
				shadowColor:	0x0076D0
			})
		});
		
		public static const RateButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"buttons/green_base",
			atlas:			AtlasAsset.CommonAtlas,
			textFieldStyle:	new XTextFieldStyle({
				fontSize:		66.0,
				fontColor:		0xeeeeee,
				strokeSize:		2,
				strokeColor:	0x054200
			})
		});
		
		public static const BlueButtonStyle:XButtonStyle = new XButtonStyle({
			upState:		"buttons/button_blue",
			atlas:			AtlasAsset.CommonAtlas,
			width:			218,
			labelYShift:    -2,
			textFieldStyle: new XTextFieldStyle({
				fontSize:		24.0,
				fontColor:		0xffffff
			})
		});
		
		public static const StoreButton:XButtonStyle = new XButtonStyle({
			upState:		"buttons/button_blue",
			atlas:			AtlasAsset.CommonAtlas,
			width:			260,
			labelYShift:    -2,
			labelXShift:    -10,
			icon:         	"buy_cards/store_icon",
			iconXShift:     66,
			iconYShift:     -3,
			textFieldStyle: new XTextFieldStyle({
				fontSize:		25.0,
				fontColor:		0xffffff
			})

		});
		
		public static const GreenButton:XButtonStyle = new XButtonStyle({
			upState:		"buttons/green_base",
			atlas:			AtlasAsset.CommonAtlas,
			labelYShift:    3,
			textFieldStyle: new XTextFieldStyle({
				fontSize:		34.0,
				fontColor:		0xffffff,
				shadowSize:		1.4,
				shadowColor:	0x087315
			})
		});
		
		public static const GreenButtonContoured:XButtonStyle = new XButtonStyle({
			upState:		"buttons/green_base_contoured",
			atlas:			AtlasAsset.CommonAtlas,
			labelYShift:    3,
			textFieldStyle: new XTextFieldStyle({
				fontSize:		34.0,
				fontColor:		0xffffff,
				shadowSize:		1.4,
				shadowColor:	0x087315
			})
		});
		
		public static const GreenButtonContouredSliced:XButtonStyle = new XButtonStyle({
			upState:		"buttons/green_base_contoured",
			atlas:			AtlasAsset.CommonAtlas,
			scale9Rect:     new Rectangle(101, 35, 2, 1),
			labelYShift:    3,
			textFieldStyle: new XTextFieldStyle({
				fontSize:		34.0,
				fontColor:		0xffffff,
				shadowSize:		1.4,
				shadowColor:	0x087315
			})
		});
		
		public static const RedButton:XButtonStyle = new XButtonStyle({
			upState:		"buttons/red_base",
			atlas:			AtlasAsset.CommonAtlas,
			scale9Rect:     new Rectangle(87, 0, 1, 0),
			labelYShift:    0,
			textFieldStyle: new XTextFieldStyle({
				fontSize:		34.0,
				fontColor:		0xffffff,
				shadowSize:		1.4,
				shadowColor:	0x7A0000
			})
		});
		
		public static const GreenCounter:XButtonStyle = new XButtonStyle({
			upState:		"buttons/green_base_mini",
			disabledState:	"buttons/gray_base_mini",
			atlas:			AtlasAsset.CommonAtlas,
			scale9Rect:     new Rectangle(17, 0, 1, 0),
			width:			70,
			labelYShift:	1,
			textFieldStyle:	new XTextFieldStyle({
				fontSize:		48.0,
				fontColor:		0xffffff,
				strokeSize:		1.0,
				strokeColor:	0x000000
			}),
			disabledTextFieldStyle: new XTextFieldStyle({
				fontSize:		48.0,
				fontColor:		0xffffff,
				strokeSize:		1.0,
				strokeColor:	0x000000
			})
		});
		
		public static const GreenButtonNext:XButtonStyle = new XButtonStyle({
			upState:		"buttons/green_base",
			atlas:			AtlasAsset.CommonAtlas,
			labelYShift:    1,
			scale9Rect:     new Rectangle(96, 0, 12, 0),
			width:			233,
			textFieldStyle: new XTextFieldStyle({
				fontSize:		34.0,
				fontColor:		0xffffff,
				shadowSize:		1.4,
				shadowColor:	0x087315
			})
		});
		
		public static const GreenSelect:XButtonStyle = new XButtonStyle({
			upState:		"buttons/green_base_contoured",
			atlas:			AtlasAsset.CommonAtlas,
			labelYShift:    2,
			scale9Rect:     new Rectangle(100, 34, 4, 1),
			height:			73,
			width:			208,
			textFieldStyle: new XTextFieldStyle({
				fontSize:		28.0,
				fontColor:		0xffffff,
				strokeSize:		0.03,
				strokeColor:	0x087315,
				shadowSize:		0.8,
				shadowColor:	0x087315
			})
		});
		
		public static const OrangeBurn:XButtonStyle = new XButtonStyle({
			upState:		"buttons/orange_base",
			atlas:			AtlasAsset.CommonAtlas,
			labelYShift:    2,
			scale9Rect:     new Rectangle(87, 35, 1, 1),
			height:			70,
			width:			206,
			textFieldStyle: new XTextFieldStyle({
				fontSize:		28.0,
				fontColor:		0xffffff,
				strokeSize:		0.03,
				strokeColor:	0x930522,
				shadowSize:		0.8,
				shadowColor:	0x930522
			})
		});
		
		public static const GreenButtonFont21:XButtonStyle = new XButtonStyle({
			upState:		"buttons/green_base",
			atlas:			AtlasAsset.CommonAtlas,
			labelYShift:    1,
			scale9Rect:     new Rectangle(96, 0, 12, 0),
			width:			233,
			textFieldStyle: new XTextFieldStyle({
				fontSize:		21.0,
				fontColor:		0xffffff,
				shadowSize:		1.4,
				shadowColor:	0x087315
			})
		});
		
		public static const TextSkipButton:XButtonStyle = new XButtonStyle({
			upState:		"dialogs/buttons/empty_square",
			atlas:			AtlasAsset.LoadingAtlas,
			width:			233,
			height:			40,
			textFieldStyle: new XTextFieldStyle({
				fontSize:		34.0,
				fontColor:		0x4A585B
			})
		});
		
		public static const CardScrollButtonUp:XButtonStyle = new XButtonStyle({
			upState:		"game/card_scroll_button_up",
			atlas:			AtlasAsset.CommonAtlas,
			soundVolume: 	0.4
			//soundAsset:		SoundAsset.CardsRoll
		});
		
		public static const CardScrollButtonDown:XButtonStyle = new XButtonStyle({
			upState:		"game/card_scroll_button_down",
			atlas:			AtlasAsset.CommonAtlas,
			soundVolume: 	0.4
			//soundAsset:		SoundAsset.CardsRoll
		});
		
		public static const InboxTrash:XButtonStyle = new XButtonStyle({
			upState:		"invite/delete_gift",
			atlas:			AtlasAsset.CommonAtlas
		});
		
		public static const InboxGreenButton:XButtonStyle = new XButtonStyle({
			upState:		"buttons/green_base",
			atlas:			AtlasAsset.CommonAtlas,
			labelYShift:    2,
			scale9Rect:     new Rectangle(100, 32, 4, 0),
			height:			69,
			width:			193,
			textFieldStyle: new XTextFieldStyle({
				fontSize:		28.0,
				fontColor:		0xffffff,
				strokeSize:		0.03,
				strokeColor:	0x087315,
				shadowSize:		0.8,
				shadowColor:	0x087315
			})
		});
		
		public static const InboxBottomGreenButton:XButtonStyle = new XButtonStyle({
			upState:		"buttons/green_big",
			disabledState:	"buttons/gray_big",
			atlas:			AtlasAsset.CommonAtlas,
			labelYShift:	3,
			textFieldStyle:	new XTextFieldStyle({
				fontSize:		28.0,
				fontColor:		0xffffff,
				strokeSize:		0.03,
				strokeColor:	0x087315,
				shadowSize:		0.8,
				shadowColor:	0x087315
			}),
			disabledTextFieldStyle: new XTextFieldStyle({
				fontSize:		28.0,
				fontColor:		0xffffff,
				strokeSize:		0.03,
				strokeColor:	0x333333,
				shadowSize:		0.8,
				shadowColor:	0x333333
			})
		});
			
		public static const OfferBuyButton:XButtonStyle = new XButtonStyle({
			upState:		"offers/btn_green_big",
			atlas:			AtlasAsset.ScratchCardAtlas,
			scale9Rect:     new Rectangle(127, 0, 2, 0),
			labelYShift:    3,
			textFieldStyle: new XTextFieldStyle({
				fontSize:		48.0,
				fontColor:		0xffffff,
				shadowSize:		1.4,
				shadowColor:	0x087315
			})
		});
		
		public static const GreenButtonMiniFont:XButtonStyle = new XButtonStyle({
			upState:		"buttons/green_base_contoured",
			atlas:			AtlasAsset.CommonAtlas,
			scale9Rect:     new Rectangle(101, 35, 2, 1),
			labelYShift:    3,
			textFieldStyle: new XTextFieldStyle({
				fontSize:		18.0,
				fontColor:		0xffffff,
				shadowSize:		1.0,
				shadowColor:	0x000000
			})
		});
		
		public static function getStyle(atlas:AtlasAsset, upState:String, disabledState:String = null):XButtonStyle
		{
			var style:XButtonStyle = new XButtonStyle({
				atlas:			atlas,
				upState:		upState,
				disabledState : disabledState
			});
			
			return style;
		}
		
			
	}
}