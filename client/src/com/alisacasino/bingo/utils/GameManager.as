package com.alisacasino.bingo.utils
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.Preloader;
	import com.alisacasino.bingo.assets.loading.LoadManager;
	import com.alisacasino.bingo.dialogs.OnStartDialogsQueue;
	import com.alisacasino.bingo.models.GameHintsManager;
	import com.alisacasino.bingo.models.TutorialManager;
	import com.alisacasino.bingo.models.cats.CatsModel;
	import com.alisacasino.bingo.models.collections.CollectionsData;
	import com.alisacasino.bingo.models.chests.ChestsData;
	import com.alisacasino.bingo.models.dailyEventChestData.RareChestData;
	import com.alisacasino.bingo.assets.Fonts;
	import com.alisacasino.bingo.models.game.GameData;
	import com.alisacasino.bingo.models.gifts.GiftsModel;
	import com.alisacasino.bingo.models.liveEvents.EventPrizeModel;
import com.alisacasino.bingo.models.notification.PushData;
import com.alisacasino.bingo.models.offers.CustomOfferManager;
	import com.alisacasino.bingo.models.offers.FacebookConnectManager;
	import com.alisacasino.bingo.models.offers.FreebiesManager;
	import com.alisacasino.bingo.models.offers.OfferManager;
	import com.alisacasino.bingo.models.powerups.PowerupModel;
	import com.alisacasino.bingo.models.quests.questItems.QuestBase;
	import com.alisacasino.bingo.models.quests.QuestModel;
	import com.alisacasino.bingo.models.roomClasses.RoomsModel;
	import com.alisacasino.bingo.models.scratchCard.ScratchCardModel;
	import com.alisacasino.bingo.models.skinning.SkinningData;
	import com.alisacasino.bingo.models.slots.SlotsModel;
	import com.alisacasino.bingo.models.tournament.TournamentData;
	import com.alisacasino.bingo.platform.IInterceptor;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.StaticDataMessage;
	import com.alisacasino.bingo.store.StoreData;
	import com.alisacasino.bingo.store.items.ChestStoreItem;
	import com.alisacasino.bingo.utils.analytics.AnalyticsManager;
	import com.alisacasino.bingo.utils.backgroundThread.BackgroundThreadManager;
	import com.alisacasino.bingo.utils.backgroundThread.WorkerManager;
	import com.alisacasino.bingo.utils.clientData.ClientDataManager;
	import com.alisacasino.bingo.utils.connection.ConnectionWatchdog;
	import com.alisacasino.bingo.utils.graphics.FramerateWatchdog;
	import com.alisacasino.bingo.utils.layoutHelperClasses.LayoutHelper;
import com.alisacasino.bingo.utils.periodic.PeriodicBonusManager;
import com.netease.protobuf.UInt64;
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.system.ApplicationDomain;
	import starling.events.EventDispatcher;
	import starling.textures.Texture;

	import flash.desktop.NativeApplication;
	import flash.system.Capabilities;

	public class GameManager extends EventDispatcher
	{
        public function GameManager() {
            Fonts.initHash();
			
			_tutorialManager = new TutorialManager();
			_onStartDialogsQueue = new OnStartDialogsQueue();
			
			
			//Fonts.createBitmapFonts();
        }

		private var mAccessToken:String;
		private var mFacebookId:String;

		private var mSource:String;
		private var mCampaign:String;
		
		private var _tutorialManager:TutorialManager;
		
		private var _onStartDialogsQueue:OnStartDialogsQueue;

		public function get accessToken():String
		{
			return mAccessToken;
		}

		public function set accessToken(accessToken:String):void
		{
			mAccessToken = accessToken;
		}

		public function get facebookId():String
		{
			return mFacebookId;
		}

		public function set facebookId(facebookId:String):void
		{
			mFacebookId = facebookId;
		}

		private var _backgroundThreadManager:BackgroundThreadManager;

		public function get backgroundThreadManager():BackgroundThreadManager
		{
			if (!_backgroundThreadManager)
			{
				_backgroundThreadManager = new BackgroundThreadManager();
			}
			return _backgroundThreadManager;
		}

		private var _workerManager:WorkerManager;

		public function get workerManager():WorkerManager
		{
			if (!_workerManager)
				_workerManager = new WorkerManager();

			return _workerManager;
		}

		private var _periodicBonusManager:PeriodicBonusManager;

        public function get periodicBonusManager():PeriodicBonusManager {
			if(!_periodicBonusManager) {
				_periodicBonusManager = new PeriodicBonusManager();
			}

            return _periodicBonusManager;
        }

		private var _slotsModel:SlotsModel;

		public function get slotsModel():SlotsModel
		{
			if (!_slotsModel)
				_slotsModel = new SlotsModel();
			
			return _slotsModel;
		}
		
		private var _giftsModel:GiftsModel;

		public function get giftsModel():GiftsModel
		{
			if (!_giftsModel)
			{
				_giftsModel = new GiftsModel();
			}
			return _giftsModel;
		}

		private var _scratchCardModel:ScratchCardModel;

		public function get scratchCardModel():ScratchCardModel
		{
			if (!_scratchCardModel)
			{
				_scratchCardModel = new ScratchCardModel();
			}
			return _scratchCardModel;
		}


		private var _eventPrizeModel:EventPrizeModel;

		public function get eventPrizeModel():EventPrizeModel
		{
			if (!_eventPrizeModel)
			{
				_eventPrizeModel = new EventPrizeModel();
			}
			return _eventPrizeModel;
		}

		private var _roomsModel:RoomsModel;

		public function get roomsModel():RoomsModel
		{
			if (!_roomsModel)
			{
				_roomsModel = new RoomsModel();
			}
			return _roomsModel;
		}

		private var _analyticsManager:AnalyticsManager;

		public function get analyticsManager():AnalyticsManager
		{
			if (!_analyticsManager)
			{
				_analyticsManager = new AnalyticsManager();
			}
			return _analyticsManager;
		}

		private var _clientDataManager:ClientDataManager;

		public function get clientDataManager():ClientDataManager
		{
			if (!_clientDataManager)
			{
				_clientDataManager = new ClientDataManager();
			}
			return _clientDataManager;
		}

		private var _freebiesManager:FreebiesManager;

		public function get freebiesManager():FreebiesManager
		{
			if (!_freebiesManager)
				_freebiesManager = new FreebiesManager();
			
			return _freebiesManager;
		}
		
		private var _facebookConnectManager:FacebookConnectManager;

		public function get facebookConnectManager():FacebookConnectManager 
		{
			if (!_facebookConnectManager)
				_facebookConnectManager = new FacebookConnectManager();
			
			return _facebookConnectManager;
		}
		
		private var _offerManager:OfferManager;

		public function get offerManager():OfferManager
		{
			if (!_offerManager)
			{
				_offerManager = new OfferManager();
			}
			return _offerManager;
		}

		private var _customOfferManager:CustomOfferManager;

		public function get customOfferManager():CustomOfferManager
		{
			if (!_customOfferManager)
			{
				_customOfferManager = new CustomOfferManager();
			}
			return _customOfferManager;
		}

		private var _powerupModel:PowerupModel;

		public function get powerupModel():PowerupModel
		{
			if (!_powerupModel)
			{
				_powerupModel = new PowerupModel();
			}
			return _powerupModel;
		}

		private var _gameData:GameData;

		public function get gameData():GameData
		{
			if (!_gameData)
			{
				_gameData = new GameData();
			}
			return _gameData;
		}

		private var _gameHintsManager:GameHintsManager;

		public function get gameHintsManager():GameHintsManager
		{
			if (!_gameHintsManager)
				_gameHintsManager = new GameHintsManager();

			return _gameHintsManager;
		}

		private var _tournamentData:TournamentData;

		public function get tournamentData():TournamentData
		{
			if (!_tournamentData)
				_tournamentData = new TournamentData();

			return _tournamentData;
		}

		private var _collectionsData:CollectionsData;

		public function get collectionsData():CollectionsData
		{
			if (!_collectionsData)
				_collectionsData = new CollectionsData();

			return _collectionsData;
		}

		private var _layoutHelper:LayoutHelper;

		public function get layoutHelper():LayoutHelper
		{
			if (!_layoutHelper)
				_layoutHelper = new LayoutHelper();

			return _layoutHelper;
		}


		private var _chestsData:ChestsData;

		public function get chestsData():ChestsData
		{
			if (!_chestsData)
				_chestsData = new ChestsData();

			return _chestsData;
		}

		private var _storeData:StoreData;

		public function get storeData():StoreData
		{
			if (!_storeData)
				_storeData = new StoreData();

			return _storeData;
		}

		private var _pushData:PushData;

		public function get pushData():PushData
		{
			if(!_pushData) {
				_pushData = new PushData();
			}

			return _pushData;
		}
		
		private var _watchdogs:WatchdogContainer;
		
		public function get watchdogs():WatchdogContainer
		{
			if (!_watchdogs)
				_watchdogs = new WatchdogContainer();

			return _watchdogs;
		}

		private var _skinningData:SkinningData;

		public function get skinningData():SkinningData
		{
			if (!_skinningData)
				_skinningData = new SkinningData();

			return _skinningData;
		}
		
		private var _questModel:QuestModel;

		public function get questModel():QuestModel
		{
			if (!_questModel)
				_questModel = new QuestModel();

			return _questModel;
		}
		
		private var _xpModifier:XpModifier;

		public function get xpModifier():XpModifier
		{
			if (!_xpModifier)
				_xpModifier = new XpModifier();

			return _xpModifier;
		}

		
		
		private var _catsModel:CatsModel;

		public function get catsModel():CatsModel
		{
			if (!_catsModel)
				_catsModel = new CatsModel();

			return _catsModel;
		}
		
		public var playerCats:Array = [];
		
		public var enemyCats:Array = [];	
		
		public var CAT_SLOTS_MAX:int = 3;

		public var gameMode:String;
		
		public var pvpEnemySetted:Boolean;
		public var playerCatsSetted:Boolean;
		public var pvpUserReady:Boolean;
		
		public static const GAME_MODE_SIMPLE:String = 'GAME_MODE_SIMPLE';
		public static const GAME_MODE_GROUP:String = 'GAME_MODE_GROUP';
		public static const GAME_MODE_PVP:String = 'GAME_MODE_PVP';
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		private static var sGameManager:GameManager = null;

		public static const PLAYER_ID_KEY:String = "PlayerId";
		public static const PWD_HASH_KEY:String = "PwdHash";
		public static const CURRENT_ROOM_TYPE_NAME_KEY:String = "CurrentRoomTypeName";
		public static const HAS_LIKED:String = "HasLiked";
		public static const HAS_RATED:String = "HasRated";

		public var appDomain:ApplicationDomain;

		public var stage:Stage;

		public var preloader:Preloader;
		public var firstSession:Boolean;
		public var trackingData:String;
		public var trackingDataAppOpen:String;
		public var canBeFirstSession:Boolean = true;
		
		private var _deactivated:Boolean;
		
		public function get deactivated():Boolean
		{
			return _deactivated;
		}
		
		public function set deactivated(value:Boolean):void
		{
			_deactivated = value;
		}
		
		public function get hasStage3D():Boolean
		{
			return stage && stage.stage3Ds.length > 0 && stage.stage3Ds[0].context3D; 
		}
		
		public function get loadManager():LoadManager
		{
			return LoadManager.instance;
		}
		
		private var _preloaderBackgroundTexture:Texture;
		
		public function get preloaderBackgroundTexture():Texture
		{
			if (!_preloaderBackgroundTexture)
			{
				if (preloader && preloader.backgroundBitmap)
				{
					_preloaderBackgroundTexture = Texture.fromBitmap(preloader.backgroundBitmap);
				}
				else
				{
					sosTrace("Could not get preloader background", SOSLog.WARNING);
					_preloaderBackgroundTexture = Texture.fromColor(100, 100, 0x0);
				}
			}
			return _preloaderBackgroundTexture;
		}
		
		private var mPlatformInterceptor:IInterceptor = PlatformServices.interceptor;
		
		public static function get instance():GameManager
		{
			if (sGameManager == null) {
				sGameManager = new GameManager();
				if (!sGameManager.layoutHelper.canvasLayoutMode) {
					sGameManager.layoutHelper.initScreen(PlatformServices.interceptor.getScreenWidth(), PlatformServices.interceptor.getScreenHeight());
				} else {
					sGameManager.layoutHelper.initScreen();
				}
			}
			return sGameManager;
		}

		private function get nativeVersionNumber():String
		{
			var xml:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = xml.namespace();
			return xml.ns::versionNumber;
		}

		public function get playerId():UInt64
		{
			return mPlatformInterceptor.playerId;
		}

		public function set playerId(playerId:UInt64):void
		{
			mPlatformInterceptor.playerId = playerId;
		}

		public function clearPlayerID():void
		{
			mPlatformInterceptor.clearPlayerID();
		}

		public function get pwdHash():String
		{
			return mPlatformInterceptor.pwdHash;
		}

		public function set pwdHash(pwdHash:String):void
		{
			mPlatformInterceptor.pwdHash = pwdHash;
		}

		public function clearPasswordHash():void
		{
			mPlatformInterceptor.clearPasswordHash();
		}

		public function createNewPwdHash():String
		{
			var pwdLength:int = 32;
			var symbols:String = "01234567890abcdef";
			var pwdHash:String = "";
			for (var i:int = 0; i < pwdLength; i++) {
				var pos:int = (i == 0) ? (int(Math.random() * (symbols.length - 1)) + 1) : (int(Math.random() * symbols.length))
				pwdHash += symbols.charAt(pos);
			}
			this.pwdHash = pwdHash;
			return pwdHash;
		}

		private var sessionID:String;

		public function getSessionID():String
		{
			if (!sessionID)
			{
				sessionID = int(Math.random() * 8999 + 1000).toString(36);
			}

			return sessionID;
		}

		public function getVersionString():String
		{
			if (!PlatformServices.isCanvas)
			{
				return nativeVersionNumber;
			}
			else
			{
				return Constants.CANVAS_VERSION;
			}
		}
		
		public function getChestItem():ChestStoreItem
		{
			return storeData.chestItems.length > 0 ? storeData.chestItems[0] : null;
		}

		public function get hasLiked():Boolean
		{
			return mPlatformInterceptor.hasLiked;
		}

		public function set hasLiked(value:Boolean):void
		{
			mPlatformInterceptor.hasLiked = value;
		}

		public function get hasRated():Boolean
		{
			return mPlatformInterceptor.hasRated;
		}

		public function set hasRated(value:Boolean):void
		{
			mPlatformInterceptor.hasRated = value;
		}

		public function get connectionManager():ConnectionManager
		{
			return Game.connectionManager;
		}
		
		public function get tutorialManager():TutorialManager
		{
			return _tutorialManager;
		}
		
		public function get onStartDialogsQueue():OnStartDialogsQueue
		{
			return _onStartDialogsQueue;
		}
		
		public function get lastPaymentTime():uint
		{
			return clientDataManager.getValue('lastPaymentTime', 0);
		}
		
		public function set lastPaymentTime(time:uint):void
		{
			clientDataManager.setValue('lastPaymentTime', time, true);
		}
		
		private var previousSessionSignInTime:uint;
		
		public function get lastSignInTime():uint
		{
			return previousSessionSignInTime;
		}
		
		public function set lastSignInTime(time:uint):void
		{
			previousSessionSignInTime = clientDataManager.getValue('lastSignInTime', TimeService.serverTime);
			clientDataManager.setValue('lastSignInTime', time);
		}
	}
}
import com.alisacasino.bingo.Game;
import com.alisacasino.bingo.utils.connection.ConnectionWatchdog;
import com.alisacasino.bingo.utils.graphics.FramerateWatchdog;
import com.alisacasino.bingo.utils.LoadingWatchdog;

class WatchdogContainer
{
	private var _framerateWatchdog:FramerateWatchdog;
	
	public function get framerateWatchdog():FramerateWatchdog 
	{
		return _framerateWatchdog;
	}
	private var _loadingWatchdog:LoadingWatchdog;
	
	public function get loadingWatchdog():LoadingWatchdog 
	{
		return _loadingWatchdog;
	}
	private var _connectionWatchdog:ConnectionWatchdog;
	
	public function get connectionWatchdog():ConnectionWatchdog 
	{
		return _connectionWatchdog;
	}
	public function WatchdogContainer() 
	{
		_framerateWatchdog = new FramerateWatchdog();
		_loadingWatchdog = new LoadingWatchdog();
		_connectionWatchdog = new ConnectionWatchdog();
		super();
	}
	public function initialize(game:Game):void
	{
		_framerateWatchdog.initialize(game);
		_connectionWatchdog.initialize(game);
		_loadingWatchdog.initialize(game);
	}
}