package com.alisacasino.bingo
{
	import avmplus.getQualifiedClassName;
	import by.blooddy.crypto.Base64;
	import com.alisacasino.bingo.assets.AssetsManager;
	import com.alisacasino.bingo.assets.loading.AssetLoadingEvent;
	import com.alisacasino.bingo.assets.loading.AssetQueue;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.LoaderQueueEntry;
	import com.alisacasino.bingo.commands.ICommand;
	import com.alisacasino.bingo.commands.ParallelCommandSet;
	import com.alisacasino.bingo.commands.SequentialCommandSet;
	import com.alisacasino.bingo.commands.assetIndex.LoadAssetIndices;
	import com.alisacasino.bingo.commands.dialogCommands.ShowNoConnectionDialog;
	import com.alisacasino.bingo.commands.gameLoading.LoadGame;
	import com.alisacasino.bingo.commands.gameLoading.LoadSettings;
	import com.alisacasino.bingo.commands.dialogCommands.ShowMaintenanceDialog;
	import com.alisacasino.bingo.components.NativeStageRedErrorPlate;
	import com.alisacasino.bingo.controls.LoadingWheel;
	import com.alisacasino.bingo.dialogs.BaseDialog;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.ReconnectDialog;
	import com.alisacasino.bingo.logging.SaveHTMLLog;
	import com.alisacasino.bingo.models.Card;
	import com.alisacasino.bingo.models.FacebookIdAndTimestamp;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.RateDialogManager;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.models.roomClasses.RoomType;
	import com.alisacasino.bingo.platform.IFacebookManager;
	import com.alisacasino.bingo.platform.IInterceptor;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.platform.mobile.FacebookDialogResponse;
	import com.alisacasino.bingo.platform.mobile.MobileInterceptor;
	import com.alisacasino.bingo.protocol.RequestServerStatusMessage;
	import com.alisacasino.bingo.screens.lobbyScreenClasses.LobbyUI;
	import com.alisacasino.bingo.utils.ServerConnection;
	import com.alisacasino.bingo.utils.TimeService;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAReconnectShownEvent;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAUIInteractionEvent;
	import feathers.controls.BasicButton;
	import flash.desktop.NativeApplication;
	import flash.events.IOErrorEvent;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import starling.display.Quad;
	import starling.events.EnterFrameEvent;
	import starling.events.EventDispatcher;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;
	import starling.display.DisplayObjectContainer;

	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.screens.IScreen;
	import com.alisacasino.bingo.screens.LoadingScreen;
	import com.alisacasino.bingo.utils.AndroidFocusUtils;
	import com.alisacasino.bingo.utils.ConnectionManager;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.FacebookData;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.ScreenshotUtils;
	import com.alisacasino.bingo.utils.Settings;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.analytics.events.LoadingStateEvent;
	import com.alisacasino.bingo.utils.backgroundThread.BackgroundThreadManager;
	import com.alisacasino.bingo.utils.disposal.DisposalUtils;
	
	import flash.events.ErrorEvent;
	import flash.events.TimerEvent;
	import flash.events.UncaughtErrorEvent;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
		
	public class Game extends Sprite
	{
		public static const DAUB_EVENT:String = "DaubEvent";
		
		public static const FACEBOOK_LOGOUT_EVENT:String = "FacebookLogoutEvent";
		public static const FACEBOOK_SESSION_OPENED_EVENT:String = "FacebookSessionOpenedEvent";
		public static const FACEBOOK_SESSION_ERROR_EVENT:String = "FacebookSessionErrorEvent";
		public static const FACEBOOK_ME_REQUEST_COMPLETED_EVENT:String = "FacebookMeRequestCompletedEvent";
		public static const FACEBOOK_ME_REQUEST_ERROR_EVENT:String = "FacebookMeRequestErrorEvent";
		static public const FACEBOOK_ME_REQUEST_CANCELLED_EVENT:String = "FacebookMeRequestCancelledEvent";
		
		static public const ACTIVATED:String = "activated";
		static public const DEACTIVATED:String = "deactivated";
		static public const FACEBOOK_LOGIN_CANCELLED:String = "facebookLoginCancelled";
		static public const STAGE_RESIZE:String = "stageResize";
		
		public static const EVENT_COUNTDOWN_ROUND_START:String = "EVENT_COUNTDOWN_ROUND_START";
		static public const COLLECTION_EFFECTS_UPDATED:String = "collectionEffectsUpdated";
		
		static public const EVENT_ORIENTATION_CHANGED:String = "EVENT_ORIENTATION_CHANGEDc";
		static public const DAUB_MISS_EVENT:String = "daubMissEvent";
		
		public static const EVENT_ROUND_START_TIMEOUT:String = "EVENT_ROUND_START_TIMEOUT";

		private static var _instance:Game;
		
		private static var dispatcher:EventDispatcher = new EventDispatcher();
		
		public var hasUncaughtError:Boolean = false;
		
		public static var uncaughtErrorsCounter:int;
		public var staticAssetPreloadQueue:AssetQueue;
		
		private var mAssetsManager:AssetsManager = AssetsManager.instance;
		private var mGameManager:GameManager = GameManager.instance;
		private var mSoundManager:SoundManager = SoundManager.instance;
		
		private var loadingScreen:LoadingScreen;
		private var mCurrentScreen:IScreen;
		private var androidFocusUtils:AndroidFocusUtils;
		private var activated:Boolean;
		private var assetQueue:AssetQueue;
		private var pendingScreen:IScreen;
		private var loadGameCommand:ICommand;
		private var mPlatformInterceptor:IInterceptor = PlatformServices.interceptor;
		
		private static var _connectionManager:ConnectionManager;
		
		private var _gameScreenLoaded:Boolean;
		private var loadSettingsCommand:ICommand;
		private var logButton:BasicButton;
		
		private var history:Vector.<String>;
		private var historyDepth:int = 2;
		
		private var _isSignInComplete:Boolean;
		
		public function get gameScreenLoaded():Boolean 
		{
			return _gameScreenLoaded;
		}
		
		public function Game()
		{
			_instance = this;
			
			gameManager.analyticsManager.deltaDNAAnalytics.setFrameListener(this);
		
			sosTrace( "Game.Game", SOSLog.DEBUG);
			
			logButton = new BasicButton();
			var quad:Quad = new Quad(90, 35, 0xff00ff);
			quad.alpha = 0;
			logButton.defaultSkin = quad;
			logButton.addEventListener(Event.TRIGGERED, logButton_triggeredHandler);
			
			mPlatformInterceptor.trackInstall();
			
			mPlatformInterceptor.startAppsFlyer();
			
			_connectionManager = new ConnectionManager(this);
			addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
			
			Game.addEventListener(Game.FACEBOOK_SESSION_OPENED_EVENT, onFacebookSessionOpened);
			Game.addEventListener(Game.FACEBOOK_LOGOUT_EVENT, onFacebookLogOut);
			Game.addEventListener(ConnectionManager.SIGN_IN_COMPLETE_EVENT, signInCompleteEventHandler);
			
			gameManager.backgroundThreadManager.initialize();
			gameManager.workerManager.initialize();
			
			gameManager.watchdogs.initialize(this);
			
			AssetsManager.instance.addEventListener(AssetLoadingEvent.FAIL, onAssetsFailed);
			
			mPlatformInterceptor.addNativeEventListener(flash.events.Event.ACTIVATE, onActivate);
			mPlatformInterceptor.addNativeEventListener(flash.events.Event.DEACTIVATE, onDeactivate);
			mPlatformInterceptor.addNativeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			mPlatformInterceptor.addNativeEventListener("invoke", onInvoke);
			
			if (PlatformServices.isAndroid)
			{
				androidFocusUtils = new AndroidFocusUtils();
				androidFocusUtils.addEventListener(Event.CHANGE, androidFocusUtils_changeHandler);
			}
			
			DialogsManager.init();
			DialogsManager.instance.addEventListener(DialogsManager.EVENT_REMOVE, dialogsManger_eventRemoveHandler);
			
			gameManager.giftsModel;
			
			activated = true;
			Preloader.showStatusPixels(Preloader.STATUS_GAME_INIT);
			
			history = new <String>[];
			
			PlatformServices.interceptor.listenOrientation();
		}
		
		private function dialogsManger_eventRemoveHandler(e:Event):void 
		{
			checkMaintenanceStatus();
		}
		
		private function logButton_triggeredHandler(e:Event):void 
		{
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes(SaveHTMLLog.getHTMLString());
			connectionManager.sendClientMessage(Base64.encode(ba), true); 
		}
		
		public static function get connectionManager():ConnectionManager {
			return _connectionManager;
		}
		
		private function androidFocusUtils_changeHandler(e:Event):void 
		{
			if (androidFocusUtils.inFocus)
			{
				tryToReactivate();
			}
		}
		
		public function onAddedToStage(e:starling.events.Event):void
		{
			Preloader.showStatusPixels(Preloader.STATUS_GAME_ON_STAGE);
			
			sosTrace( "Game.onAddedToStage > e : " + e, SOSLog.DEBUG);
			sosTrace( "Constants.isDevBuild : " + Constants.isDevBuild, SOSLog.DEBUG);
			sosTrace( "Constants.isAmazonBuild : " + Constants.isAmazonBuild, SOSLog.DEBUG);
			if (PlatformServices.isCanvas) {
				stage.addEventListener(starling.events.Event.RESIZE, onResize);
			}
			else 
			{
				if (currentScreen)
				{
					(currentScreen as DisplayObject).visible = true;
				}
			}
			loadGame();
		}
		
		private function onResize(e:starling.events.Event = null):void {
			var nativeStageWidth:int = Starling.current.nativeStage.stageWidth;
			var nativeStageHeight:int = Starling.current.nativeStage.stageHeight;
			
			mGameManager.layoutHelper.initScreen(nativeStageWidth, nativeStageHeight);
			
			sosTrace('Game.onResize ' + nativeStageWidth + " " + nativeStageHeight + " layoutHelper: " + mGameManager.layoutHelper.realScreenWidth + " " + mGameManager.layoutHelper.realScreenHeight, SOSLog.SYSTEM);
			
			var starling:Starling = Starling.current;
			
			starling.viewPort.setTo(0, 0, mGameManager.layoutHelper.realScreenWidth, mGameManager.layoutHelper.realScreenHeight);
			starling.stage.stageWidth = mGameManager.layoutHelper.stageWidth;
			starling.stage.stageHeight = mGameManager.layoutHelper.stageHeight;
			
			dispatchEventWith(STAGE_RESIZE);
			
			ResizeUtils.resizeChildDialogs(this);
			if (mCurrentScreen) {
				mCurrentScreen.resize();
			}
		} 
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			e.stopImmediatePropagation();
			e.preventDefault();
			if (e.keyCode == Keyboard.BACK) {
				mCurrentScreen.onBackButtonPressed();
			}
		}
		
		private function onActivate(e:flash.events.Event):void
		{
			activated = true;
			
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAUIInteractionEvent(DDNAUIInteractionEvent.ACTION_ACTIVATED, DDNAUIInteractionEvent.LOCATION_GLOBAL, DDNAUIInteractionEvent.ACTION_ACTIVATED, DDNAUIInteractionEvent.ACTION_ACTIVATED));
			
			tryToReactivate();
			
			//TODO: Better handling of activate/deactivate routines
		}
		
		private function tryToReactivate():void 
		{
			if (!activated)
				return;
			
			if (PlatformServices.isAndroid && !androidFocusUtils.inFocus)
				return;
			
			if (PlatformServices.isAndroid)
			{
				if (!Starling.current.contextValid) {
					NativeApplication.nativeApplication.exit();
					return;
				}	
			}
			
			SOSLog.restore();
			sosTrace("Game.onActivate", SOSLog.WARNING);
			
			var needToReconnect:Boolean = false;
			
			if (ServerConnection.current != null) {
				try
				{
					ServerConnection.current.sendMessage(new RequestServerStatusMessage());
				}
				catch (e:Error)
				{
					needToReconnect = true;
				}
			}
			else
			{
				needToReconnect = true;
			}
			
			if (needToReconnect)
			{
				if (!(mCurrentScreen is LoadingScreen)) {
					connectionManager.stopTimer();
					loadGame();
				}
			}
			else
			{
				mSoundManager.resume();
			}
			
			
			GameManager.instance.deactivated = false;
			TimeService.instance.resume();
			if (!PlatformServices.isCanvas)
			{
				if(currentScreen is DisplayObject)
				{
					(currentScreen as DisplayObject).visible = true;
				}
			}
			dispatchEventWith(ACTIVATED);
		}
		
		private function onDeactivate(e:flash.events.Event):void
		{
			activated = false;
			sosTrace("Game.onDeactivate", SOSLog.WARNING);
			
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAUIInteractionEvent(DDNAUIInteractionEvent.ACTION_DEACTIVATED, DDNAUIInteractionEvent.LOCATION_GLOBAL, DDNAUIInteractionEvent.ACTION_DEACTIVATED, DDNAUIInteractionEvent.ACTION_DEACTIVATED));
			
			GameManager.instance.deactivated = true;
			mSoundManager.pause();
			SOSLog.disconnectTracer();
			TimeService.instance.pause();
			if (!PlatformServices.isCanvas)
			{
				if(currentScreen is DisplayObject)
				{
					(currentScreen as DisplayObject).visible = false;
				}
			}
			PlatformServices.interceptor.setBackgroundMode();
			dispatchEventWith(Game.DEACTIVATED);
		}
		
		private function onInvoke(e:flash.events.Event):void
		{
			//sosTrace( "Game.onInvoke > e : ", e, SOSLog.DEBUG);
			if (e.hasOwnProperty("arguments") && e["arguments"].length > 0) 
			{
				sosTrace( "e[\"arguments\"] : " + e["arguments"], SOSLog.DEBUG);
				if (!e["arguments"][0])
					return;
				
				var params:Array = e["arguments"][0].split("&");
				gameManager.freebiesManager.parseMobileFreebies(params);
				gameManager.freebiesManager.sendFreebiesClaimMessage();
			}
		}

		private function onAssetsFailed(e:AssetLoadingEvent):void
		{
			sosTrace("Game::onAssetsFailed", SOSLog.ERROR);
			Room.current = null;
			Player.current = null;
			FacebookData.instance.clear();
			
			if (mCurrentScreen is LoadingScreen) {
				(mCurrentScreen as LoadingScreen).hideLoadingBar();
			}
			connectionManager.stopTimer();
			
			try
			{
				var text:String = (Constants.isDevBuild || Constants.isLocalBuild) ? (Constants.TEXT_LOADING_ERROR_DEV + String(e.data)) : Constants.TEXT_LOADING_ERROR;
				new ShowNoConnectionDialog(DDNAReconnectShownEvent.NO_RESOURCES, 'Load assets error: ' + String(e.data), ReconnectDialog.TYPE_RECONNECT, Constants.TITLE_LOADING_ERROR, text).execute();
			} catch (error:Error) {
				sosTrace("Game::onAssetsFailed/reconnectDialog.show() error", SOSLog.ERROR);
				//TODO: what to do on reconnect dialog failure?
			}
		}
		
		private function onFacebookSessionOpened(e:starling.events.Event):void
		{
			trace("Game::onFacebookSessionOpened");
			handleFacebookLogInLogOut();
		}
		
		private function onFacebookLogOut(e:starling.events.Event):void
		{
			trace("Game::onFacebookLogOut");
			handleFacebookLogInLogOut();
		}
		
		private function handleFacebookLogInLogOut():void
		{
			clean();
			if (!(mCurrentScreen is LoadingScreen)) {
				if (ServerConnection.current) {
					ServerConnection.current.close();
					ServerConnection.current = null;
				}
				
				connectionManager.stopTimer();
				loadGame();
			}
		}
		
		private function signInCompleteEventHandler(e:Event):void 
		{
			_isSignInComplete = true;
			gameManager.freebiesManager.sendFreebiesClaimMessage();
		}
		
		public function clean():void
		{
			_isSignInComplete = false;
			
			Room.current = null;
			Player.current = null;
			connectionManager.cancelPlayerUpdate();
			connectionManager.cancelClientDataSave();
			FacebookData.instance.clear();
			
			//Starling.juggler.purge(); не открывать валит после ресета игру, но надо как-то разобраться
			
			gameManager.onStartDialogsQueue.clean();
			gameManager.giftsModel.clear(false);
			gameManager.freebiesManager.clean();
			gameManager.chestsData.cleanChests();
			gameManager.offerManager.clean();
		}
		
		public function showScreen(newScreen:IScreen):IScreen
		{
			sosTrace( "Game.showScreen > newScreen : " + getQualifiedClassName(newScreen), SOSLog.DEBUG);
			if (!PlatformServices.isCanvas && !(mCurrentScreen is LoadingScreen))
			{
				DialogsManager.hideDialogLayer();
				ScreenshotUtils.screenshot();
			}
			
			sosTrace( "mAssetsManager.checkIfAssetsLoaded(newScreen.requiredAssets) : " + mAssetsManager.checkIfAssetsLoaded(newScreen.requiredAssets), SOSLog.DEBUG);
			
			if (mCurrentScreen != null && mCurrentScreen is GameScreen)
				LoadingWheel.show();
			
			pendingScreen = newScreen;
			
			if (staticAssetPreloadQueue)
			{
				sosTrace( "staticAssetPreloadQueue.emptyUnloadedAndRemoveListeners() : " + staticAssetPreloadQueue, SOSLog.FINER);
				staticAssetPreloadQueue.emptyUnloadedAndRemoveListeners();
				staticAssetPreloadQueue = null;
			}
			if (assetQueue)
			{
				assetQueue.stop();
				assetQueue = null;
			}
			
			if (mAssetsManager.checkIfAssetsLoaded(newScreen.requiredAssets))
			{
				removeCurrentScreenAndShowNewOne();
			}
			else
			{
				gameManager.backgroundThreadManager.setBudgetForBlockingLoad();
				
				assetQueue = mAssetsManager.loadAssetsForScreen(newScreen, removeCurrentScreenAndShowNewOne, "screen loading queue");
				
				if (mCurrentScreen && mCurrentScreen is LoadingScreen && assetQueue != null)
				{
					(mCurrentScreen as LoadingScreen).watchAssetQueue(assetQueue);
				}
			}
			
			return newScreen;
		}
		
		private function removeCurrentScreenAndShowNewOne():void
		{
			if (!pendingScreen)
			{
				sosTrace("No pending screen, aborting screen show", SOSLog.ERROR);
				loadGame();
				return;
			}
			
			if (!mAssetsManager.checkIfAssetsLoaded(pendingScreen.requiredAssets))
			{
				sosTrace("Assets are not loaded for pending screen", SOSLog.ERROR);
				showScreen(pendingScreen);
				return;
			}
			
			if (pendingScreen is GameScreen) {
				if (loadingScreen && !loadingScreen.hideComplete)
				{
					loadingScreen.tweenHide(removeCurrentScreenAndShowNewOne);
					return;
				}
			}
			
			if (mCurrentScreen == pendingScreen)
			{
				sosTrace( "currentScreen equals pending screen.", SOSLog.WARNING);
				return;
			}
			
			if (DialogsManager.instance.dialogsLayer)
			{
				DialogsManager.instance.dialogsLayer.removeFromParent(false);
			}
			
			if (mCurrentScreen != null) 
				removeChild(mCurrentScreen as DisplayObject, true);
			
			assetQueue = null;
			
			gameManager.backgroundThreadManager.setNormalBudget();
			
			
			/*if (PlatformServices.isCanvas && mCurrentScreen is LoadingScreen) {
				SoundManager.instance.preloadSounds();
			}*/
			
			if (mCurrentScreen is LoadingScreen)
			{
				gameManager.watchdogs.loadingWatchdog.transitionedFromLoadingScreen();
			}
			
			DisposalUtils.destroy(mCurrentScreen as DisplayObjectContainer);
			
			mCurrentScreen = pendingScreen;
			addChild(pendingScreen as DisplayObject);
			DialogsManager.showDialogLayer();
			
			if (gameManager.firstSession && currentScreen is GameScreen)
			{
				(currentScreen as GameScreen).finishLoadingAllAssets();
			}
			
			pendingScreen = null;
			
			if (!PlatformServices.isCanvas)
			{
				ScreenshotUtils.dispose();
			}
			
			if (!(mCurrentScreen is LoadingScreen) && PlatformServices.isCanvas)
			{
				_gameScreenLoaded = true;
				SOSLog.connectTracer();
			}
		}
		
		public function loadGame():void
		{
			sosTrace( "Game.loadGame", SOSLog.DEBUG);
			gameManager.analyticsManager.resetSessionID();
			gameManager.analyticsManager.resetDDNASessionID();
			
			//trace(">> ", assetQueue, loadGameCommand);
			
			DialogsManager.closeAll();
			
			if(ServerConnection.current)
				ServerConnection.current.close();
			
			gameManager.watchdogs.connectionWatchdog.reset();
			
			if (assetQueue)
			{
				assetQueue.stop();
				assetQueue = null;
			}
			if (loadGameCommand)
			{
				loadGameCommand.stop();
				loadGameCommand = null;
			}
			
			AssetsManager.instance.stopAllLoading();
			
			DialogsManager.cleanUpAndDeferShowingDialogs();
			gameManager.giftsModel.clear(false);
			FacebookData.instance.clear();
			gameManager.offerManager.clean();
			
			uncaughtErrorsCounter = 0;
			
			gameManager.backgroundThreadManager.setBudgetForBlockingLoad();
			
			loadingScreen = new LoadingScreen();
            showScreen(loadingScreen);
            loadGameCommand = new LoadGame(loadingScreen).execute(onLoadGameComplete, onLoadGameError);
			
		}
		
		private function onLoadGameError():void 
		{
			loadGame();
		}
		
		private function onLoadGameComplete():void 
		{
			loadGameCommand = null;
			showGameScreen();
			Settings.instance.addEventListener(Settings.MAINTENANCE_STATUS_CHANGE, maintenanceStatusChangeHandler);
			checkMaintenanceStatus();
		}
		
		private function maintenanceStatusChangeHandler(e:Event):void 
		{
			checkMaintenanceStatus();
		}
		
		private function checkMaintenanceStatus():void 
		{
			if (Settings.instance.maintenance)
			{
				new ShowMaintenanceDialog().execute();
			}
		}
		
		public function showGameScreen():void
		{
			showScreen(new GameScreen());
		}
		
		public function get currentScreen():IScreen
		{
			return mCurrentScreen;
		}
		
		public function get gameScreen():GameScreen
		{
			return mCurrentScreen as GameScreen;
		}
		
		public static function get current():Game
		{
			return _instance;
		}
		
		public function showGameScreenToBuyCards(nextTryDelay:Number = 0):void
		{
			if (gameScreen && gameScreen.lobbyUI) {
				//gameScreen.lobbyUI.state = LobbyUI.STATE_BUY_CARDS;
				return;
			}
				
			if (nextTryDelay > 0)
				Starling.juggler.delayCall(Game.current.showGameScreenToBuyCards, nextTryDelay);
		}
		
		public static function dispatchEventWith(type:String, bubbles:Boolean=false, data:Object=null):void
		{
			current.dispatchEventWith(type, bubbles, data);
		}
		
		public static function addEventListener(type:String, listener:Function):void
		{
			current.addEventListener(type, listener);
		}
		
		public static function removeEventListener(type:String, listener:Function):void
		{
			current.removeEventListener(type, listener);
		}
		
		public static function hasEventListener(type:String, listener:Function):void
		{
			current.hasEventListener(type, listener);
		}
		
		
		public static function get pathHistory():String
		{
			return _instance ? _instance.history.join(', ') : '';
		}
		
		public static function addToHistory(value:String):void {
			if (_instance) {
				_instance.history.push(getTimer().toString() + ":" + value);
				gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAUIInteractionEvent("transition", DDNAUIInteractionEvent.LOCATION_GLOBAL, value, DDNAUIInteractionEvent.TYPE_SCREEN));
				if (_instance.history.length > _instance.historyDepth)
					_instance.history.shift();
			}
		}
		
		public static function uncaughtErrorHandler(event:UncaughtErrorEvent):void
		{
			var errorEvent:ErrorEvent = event.error as ErrorEvent;
			var error:Error;
			if(!errorEvent)
				error = event.error as Error;
				
			if (error) 
			{
				highlightPlayerNameForError();
				NativeStageRedErrorPlate.show(10, "Error: " + event.toString() + ", " + error.getStackTrace());
				sosTrace( "Game.uncaughtErrorHandler > event : " + event, error.getStackTrace(), SOSLog.ERROR);
				
				Game.connectionManager.sendClientMessage(error.getStackTrace());
					
				if (current.currentScreen is LoadingScreen)
				{
					current.loadGame();
				}
			} 
			else if (errorEvent) 
			{
				if (errorEvent.type != "ioError") 
				{
					highlightPlayerNameForError();
					NativeStageRedErrorPlate.show(10, "Error: " + event.toString() + ", " + errorEvent.errorID.toString() + ", " + errorEvent.text);
					sosTrace( "Game.uncaughtErrorHandler > event : " + event, errorEvent.errorID.toString(), errorEvent.text, SOSLog.ERROR);
					
					Game.connectionManager.sendClientMessage(errorEvent.toString());
				}
			} 
			else 
			{
				highlightPlayerNameForError();
				NativeStageRedErrorPlate.show(10, "a non-Error, non-ErrorEvent type was thrown and uncaught");
				sosTrace( "Game.uncaughtErrorHandler > a non-Error, non-ErrorEvent type was thrown and uncaught", SOSLog.ERROR);
				
				Game.connectionManager.sendClientMessage("a non-Error, non-ErrorEvent type was thrown and uncaught");
			}
			
			uncaughtErrorsCounter++;
		}
		
		private static function highlightPlayerNameForError(color:uint = 0xFEDE04):void {
			current.hasUncaughtError = true;
		//	if (Game.current.gameScreen && Game.current.gameScreen.lobbyUI) 
			//	Game.current.gameScreen.lobbyUI.highlightPlayerName(color);
		}
		
		public function callResize():void {
			onResize();
		}
		
		public function setGameTouchable(value:Boolean):void {
			if (Game.current.gameScreen)
				Game.current.gameScreen.touchable = value;
		}
		
		public function get isSignInComplete():Boolean {
			return _isSignInComplete;
		}
		
	}
}
