package com.alisacasino.bingo.screens
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AssetsManager;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.BitmapFontAsset;
	import com.alisacasino.bingo.assets.Fonts;
	import com.alisacasino.bingo.assets.ImageAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.assets.XmlAsset;
	import com.alisacasino.bingo.assets.loading.AssetQueue;
	import com.alisacasino.bingo.assets.loading.LoadManager;
	import com.alisacasino.bingo.commands.ICommand;
	import com.alisacasino.bingo.commands.ShowTournamentEndAndReload;
	import com.alisacasino.bingo.commands.dialogCommands.ShowMaintenanceDialog;
	import com.alisacasino.bingo.commands.gameLoading.LoadSoundsAndAnimations;
	import com.alisacasino.bingo.commands.gameLoading.PreloadCollectionCards;
	import com.alisacasino.bingo.controls.CashBar;
	import com.alisacasino.bingo.controls.CoinsBar;
	import com.alisacasino.bingo.controls.EnergyBar;
	import com.alisacasino.bingo.controls.LoadingWheel;
	import com.alisacasino.bingo.controls.ScoreBar;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XpBar;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.ReconnectDialog;
	import com.alisacasino.bingo.dialogs.chests.ChestTakeOutDialog;
	import com.alisacasino.bingo.dialogs.scratchCard.ScratchCardWindow;
	import com.alisacasino.bingo.dialogs.slots.SlotsDialog;
	import com.alisacasino.bingo.dialogs.tournamentResultDialogClasses.TournamentResultDialog;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.cats.CatModel;
	import com.alisacasino.bingo.models.cats.CatRole;
	import com.alisacasino.bingo.models.chests.ChestData;
	import com.alisacasino.bingo.models.chests.ChestsData;
	import com.alisacasino.bingo.models.collections.Collection;
	import com.alisacasino.bingo.models.offers.OfferType;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.models.roomClasses.RoomType;
	import com.alisacasino.bingo.models.skinning.SkinningData;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.LiveEventScoreUpdateOkMessage;
	import com.alisacasino.bingo.protocol.RoomPattern;
	import com.alisacasino.bingo.protocol.RoundOverMessage;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.gameScreenClasses.CatView;
	import com.alisacasino.bingo.screens.gameScreenClasses.GameScreenController;
	import com.alisacasino.bingo.screens.gameScreenClasses.GameUI;
	import com.alisacasino.bingo.screens.gameScreenClasses.GameUIPanel;
	import com.alisacasino.bingo.screens.gameScreenClasses.ScreenCatScooter;
	import com.alisacasino.bingo.screens.lobbyScreenClasses.LobbyUI;
	import com.alisacasino.bingo.screens.sideMenuClasses.SideMenuContainer;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.Settings;
	import com.alisacasino.bingo.utils.sounds.SoundLoadAssetQueue;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.TimeService;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNARoundStartedEvent;
	import com.alisacasino.bingo.utils.disposal.DisposalUtils;
	import com.alisacasino.bingo.utils.keyboard.KeyboardController;
	import feathers.controls.List;
	import feathers.controls.ScrollContainer;
	import feathers.controls.ScrollPolicy;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	import flash.desktop.NativeApplication;
	import flash.display3D.Context3DBlendFactor;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.text.TextFormat;
	import starling.utils.Align;
	import starling.utils.TweenHelper;
	
	
	public class GameScreen extends Sprite implements IScreen
	{
		public var mBackgroundImage:Image;
		
		
		public var lobbyUI:LobbyUI;
		public var gameUI:GameUI;
		public var resultsUI:ResultsUI;
		public var dialogsLayer:Sprite;
		public var frontLayer:Sprite;
		
		private var mGameManager:GameManager = GameManager.instance;
		private var mPlayer:Player = Player.current;
		private var _state:String = STATE_PRE_GAME;
		public var gameScreenController:GameScreenController;
		
		private var mRoomType:RoomType;
		
		private var _overlayWindow:FeathersControl;
		public var sideMenuContainer:SideMenuContainer;
		private var backQuad:Quad;
		private var whiteoutQuad:Quad;
		
		private var callShowDeferredDialogsAfterRound:Boolean;
		
		private var snowParticles:PDParticleSystem;
		
		public function get overlayWindow():FeathersControl 
		{
			return _overlayWindow;
		}
		
		public function set overlayWindow(value:FeathersControl):void 
		{
			_overlayWindow = value;
		}
		
		public function get roomType():RoomType {
			return mRoomType;
		}
		
		public function get state():String
		{
			return _state;
		}
		
		public function set state(value:String):void
		{
			if (_state != value)
			{
				_state = value;
			}
		}
		
		static public const STATE_PRE_GAME:String = "statePreGame";
		static public const STATE_IN_GAME:String = "stateInGame";
		
		public function GameScreen()
		{
			backQuad = new Quad(1, 1, 0x0);
			addChild(backQuad);
			
			gameScreenController = new GameScreenController(this);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		public function onAddedToStage(e:Event):void
		{
			gameScreenController.init();
			
			
			while (gameManager.playerCats.length < gameManager.CAT_SLOTS_MAX) 
			{
				var cat:CatModel = new CatModel();
				cat.id = gameManager.catsModel.getNextCatID();
				cat.health = 3;
				cat.catUID = gameManager.catsModel.getRandomCatUID();
				
				
				cat.role = CatRole.HARVESTER;//CatRole.getRandom();
				//cat.targetCat = Math.floor(Math.random()*3);
				
				gameManager.playerCats.push(cat);
			}
			
			mBackgroundImage = new Image(AtlasAsset.ScratchCardAtlas.getTexture('backgrounds/' + '3'/*Math.ceil(Math.random()*5).toString()*/));
			addChild(mBackgroundImage);
			mBackgroundImage.alignPivot();
			
			
			createLobbyUI(true, false, LobbyUI.STATE_FIRST_START);
			
			gameUI = new GameUI(this);
			
			dialogsLayer = new Sprite();
			addChild(dialogsLayer);
			DialogsManager.setDialogsLayer(dialogsLayer);
			
			sideMenuContainer = new SideMenuContainer(this);
			addChild(sideMenuContainer);
			
			frontLayer = new Sprite();
			addChild(frontLayer);
			
			fadeQuad();
			
			resize();
			
			new LoadSoundsAndAnimations().execute();
		}
		
		override public function dispose():void 
		{
			callback_lobbyUIHide();
			gameManager.loadManager.releaseParent(this);
			super.dispose();
		}
		
		private function fadeQuad():void 
		{
			if (!whiteoutQuad)
				whiteoutQuad = new Quad(1, 1, 0xffffff);
			
			whiteoutQuad.alpha = 1;
			whiteoutQuad.touchable = false;
			whiteoutQuad.blendMode = BlendMode.ADD;
			addChild(whiteoutQuad);
			TweenHelper.tween(whiteoutQuad, 1.2, {delay: 0.0, alpha:0, transition:Transitions.EASE_IN_SINE});
		}
		
		public function resize():void
		{
			backQuad.width = layoutHelper.stageWidth;
			backQuad.height = layoutHelper.stageHeight;
			
			if (whiteoutQuad)
			{
				whiteoutQuad.width = layoutHelper.stageWidth;
				whiteoutQuad.height = layoutHelper.stageHeight;
			}
			
			ResizeUtils.resizeBackground(mBackgroundImage);
			mBackgroundImage.alignPivot();
			mBackgroundImage.x = mBackgroundImage.pivotX + (layoutHelper.stageWidth - mBackgroundImage.texture.frameWidth) / 2;
			mBackgroundImage.y = mBackgroundImage.pivotY + (layoutHelper.stageHeight - mBackgroundImage.texture.frameHeight) / 2; 
			
			if(lobbyUI)
				lobbyUI.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
				
			gameUI.setSize(layoutHelper.stageWidth, layoutHelper.stageHeight);
			gameUI.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
			
			sideMenuContainer.setSize(layoutHelper.stageWidth, layoutHelper.stageHeight);
			
			if (resultsUI)
				resultsUI.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
			
			ResizeUtils.resizeChildDialogs(this);
		}
			
		private function onRemovedFromStage(e:Event):void
		{
			gameScreenController.destroy();
			LoadManager.instance.releaseParent(this);
		}
		
		private function createLobbyUI(isFirstStart:Boolean, fromRoundOver:Boolean = false, startState:String = null):void 
		{
			ResultsUI.DEBUG_MODE = false;
			Player.IS_DEBUG_ROUND = false;
			
			if (lobbyUI)
				return;
			
			if (!startState)
			{
				if (isFirstStart)
					startState = LobbyUI.STATE_FIRST_START;
				else
					startState = LobbyUI.STATE_INIT;
			}
			
			Game.addToHistory('lobby_ui');
			
			lobbyUI = new LobbyUI(this, startState, callback_lobbyUIHide);
			lobbyUI.addEventListener(LobbyUI.EVENT_FIRST_START_COMPLETE, lobbyUI_firstStartCompleteHandler);
			
			addChildAt(lobbyUI, (resultsUI && contains(resultsUI) && fromRoundOver) ? getChildIndex(resultsUI) : numChildren);
			
			if (callShowDeferredDialogsAfterRound) 
			{
				callShowDeferredDialogsAfterRound = false;
				DialogsManager.showDeferredDialogs();
			}
			
			if (Settings.instance.maintenance)
			{
				new ShowMaintenanceDialog(true).execute();
			}
		}
		
		private function lobbyUI_firstStartCompleteHandler(e:Event):void 
		{
			DialogsManager.showDeferredDialogs();
		}
		
		public function shakeBackground(shakeType:String = null):void
		{
			ResizeUtils.shakeBackground(mBackgroundImage, shakeType || ResizeUtils.SHAKE_Y_LINEAR);
		}
		
		public function closeSideMenu():void
		{
			if (sideMenuContainer)
			{
				sideMenuContainer.hideMenu();
			}
		}
		
		public function get hasSideMenu():Boolean
		{
			return sideMenuContainer && sideMenuContainer.isShowing;
		}
		
		/****************************************************************************************************
		 * 
		 *  change UI
		 * 
		 ***************************************************************************************************/
	
		public function showGame(showReadyGo:Boolean = false):void
		{
			if (SoundManager.instance.soundLoadQueue)
				SoundManager.instance.soundLoadQueue.prioritizeRoundSounds();
			
			DialogsManager.closeAll([TournamentResultDialog, ReconnectDialog, ScratchCardWindow, ChestTakeOutDialog, SlotsDialog]);
			
			state = STATE_IN_GAME;
			
			if (lobbyUI)
			{
				lobbyUI.state = LobbyUI.STATE_TO_GAME;
			}
			else
			{
			}
			
			addChild(gameUI);
			gameUI.show(showReadyGo);
			
			Game.addToHistory('game_ui');
			
			//var lastRecordedRoundStart:String = gameManager.clientDataManager.getValue("lastRecordedRoundStart", null);
			//if (lastRecordedRoundStart != Room.current.roundID)
			//{
				//gameManager.clientDataManager.setValue("lastRecordedRoundStart", Room.current.roundID);
				//gameManager.analyticsManager.sendDeltaDNAEvent(new DDNARoundStartedEvent());
			//}
		}
		
		public function backToLobby():void
		{
			Game.connectionManager.sendReturnFromRoundMessage();
			
			gameScreenController.startLeaveProcedure();
			
			createLobbyUI(false, true);
            gameUI.hide();
            state = STATE_PRE_GAME;
			
			/*var shouldShowConfirmationDialog:Boolean = state == STATE_IN_GAME || (mPlayer.cards.length > 0);
			
			if (shouldShowConfirmationDialog)
			{
				
			}
			else
			{
				gameScreenController.startLeaveProcedure();
			}*/
		}
		
		public function hideGameUI():void
		{
			gameUI.hide();
		}
		
		/****************************************************************************************************
		 * 
		 * 
		 * 
		 ***************************************************************************************************/
		
		
		 
		private var _backgroundBlur:uint;
		
		public function setBackgroundBlur(value:int, quality:Number = 10):void 
		{
			if (_backgroundBlur == value)
				return;
			
			_backgroundBlur = value;
			
			if (_backgroundBlur <= 0) {
				mBackgroundImage.filter = null;
				return;
			}
			
			if(!mBackgroundImage.filter) {
				mBackgroundImage.filter = new BlurFilter(value, value, quality); 
			}	
			else {
				(mBackgroundImage.filter as BlurFilter).blurY = value; 
				(mBackgroundImage.filter as BlurFilter).blurX = value; 
			}
		}
		
		public function get backgroundBlur():uint {
			return _backgroundBlur;
		}
		 
		private function callback_removeGameResults():void 
		{
			if (resultsUI) {
				resultsUI.removeFromParent();
				resultsUI = null;
			}
		} 
		
		private function callback_afterResultsShown():void 
		{
			if (gameManager.tournamentData.tournamentResultToShow)
			{
				if (!gameManager.tutorialManager.isTourneyResultsHandleStepPassed) 
				{
					gameManager.tournamentData.tutorialForceChangeTournamentData(true);
					Game.current.showGameScreen();
					Starling.juggler.delayCall(Game.current.showGameScreenToBuyCards, 1.6, 0.5);
				}
				else
				{
					var showTournamentEndAndReload:ShowTournamentEndAndReload = new ShowTournamentEndAndReload();
					if (!gameManager.tournamentData.pendingTournamentChange)
					{
						showTournamentEndAndReload.addCompleteCallback(onTournamentResultsShown).addErrorCallback(onTournamentResultsShown);
					}
					showTournamentEndAndReload.execute();
				}
			}
			else
			{
				onTournamentResultsShown();
			}
			
			gameManager.tutorialManager.completeTourneyResultsHandleStep();
		} 
		
		private function onTournamentResultsShown():void 
		{
			if (Game.current.gameScreen) 
			{
				//Game.current.gameScreen.showBuyCardsState(true);
			}	
		}
		 
		private function onRulesDialogShown():void 
		{
		}
		
		private function callback_lobbyUIHide():void
		{
			if (lobbyUI) {
				lobbyUI.removeEventListener(LobbyUI.EVENT_FIRST_START_COMPLETE, lobbyUI_firstStartCompleteHandler);
				lobbyUI.removeFromParent(true);
				lobbyUI = null;
			}
		}
				
		public function roundOverHandle():void
		{
			gameUI.roundOverHandle();
		}
		
		public function onBackButtonPressed():void
		{
			/*var topChild:DisplayObject = getChildAt(numChildren - 1);
			if (topChild is LoadingWheel)
				return;
				
			if (lobbyUI && lobbyUI.state != LobbyUI.STATE_TO_GAME)
			{
				var leaveDialog:ReconnectDialog = new ReconnectDialog(ReconnectDialog.TYPE_BLANK, 'LEAVE GAME', "Are you sure you want to leave game?", 10,	closeReconnectDialog, 'NO',	0.85);
				leaveDialog.setProperties(40, true, XButtonStyle.GreenButtonContouredSliced, 226 * pxScale, 70*pxScale, 'YES', XButtonStyle.RedButton, NativeApplication.nativeApplication.exit, 1*pxScale, true);
				DialogsManager.addDialog(leaveDialog, true, true);
			}*/
		}
		
		private function closeReconnectDialog():void
		{
			DialogsManager.instance.closeDialogByClass(ReconnectDialog);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
        {
			var displayObject:DisplayObject = super.addChildAt(child, index);
			
			if (dialogsLayer && (getChildIndex(dialogsLayer) != numChildren - 1))
				setChildIndex(dialogsLayer, numChildren);
			
			if (sideMenuContainer && (getChildIndex(sideMenuContainer) != numChildren - 1))
				setChildIndex(sideMenuContainer, numChildren);	
				
			if (frontLayer && (getChildIndex(frontLayer) != numChildren - 1))
				setChildIndex(frontLayer, numChildren);
			
			if (snowParticles) {
				setChildIndex(snowParticles, numChildren);
			}
			
			return displayObject;
		}
		
		private function getNextAvailableRoom(currentXpLevel:uint):RoomType
		{
			for (var newXpLevel:int = currentXpLevel + 1; newXpLevel <= currentXpLevel + 2; newXpLevel++)
			{
				for each (var roomType:RoomType in RoomType.availableRoomTypes)
				{
					if (roomType.requiredXpLevel == newXpLevel)
					{
						if (roomType.hasActiveEvent && roomType.activeEvent.ended)
							continue;
						return roomType;
					}
				}
			}
			return null;
		}
		
		public static function getFirstSessionPreload():Array
		{
			return [BitmapFontAsset.SharkLatin,
					AtlasAsset.LoadingAtlas, 
					AtlasAsset.CommonAtlas,
					AtlasAsset.ScratchCardAtlas,
					MovieClipAsset.PackBase,
					MovieClipAsset.PackCommon];
		}
		
		public static function getStaticAssets():Array
		{
			var staticAssets:Array = [
			BitmapFontAsset.SharkLatin,
			AtlasAsset.LoadingAtlas, 
			AtlasAsset.CommonAtlas,
			MovieClipAsset.CatDisconnect,
			AtlasAsset.ScratchCardAtlas,
			];
			
			if (PlatformServices.isCanvas)
				staticAssets = staticAssets.concat(new SoundLoadAssetQueue().getAllSoundAssets());
				
			return staticAssets;
		}
		
		public function get requiredAssets():Array
		{
			var ra:Array;
			sosTrace( "gameManager.firstSession : " + gameManager.firstSession, SOSLog.FINER);
			sosTrace( "Player.current : " + Player.current.level, SOSLog.FINER);
			if (gameManager.firstSession && Player.current && Player.current.level < 2)
			{
				ra = getFirstSessionPreload();
				
				if (PlatformServices.isCanvas)
					ra = ra.concat(new SoundLoadAssetQueue().getFirstSessionSounds());
				
			}
			else
			{
				ra = getStaticAssets();
			}
			
			return ra;
		}
		
		public function showSideMenu():void 
		{
			addChild(sideMenuContainer);
			sideMenuContainer.showMenu();
		}
		
		public function backToSplash():void 
		{
			createLobbyUI(false, false);
			lobbyUI.state = LobbyUI.STATE_LOBBY;
            state = STATE_PRE_GAME;
		}
		
		/*********************************************************************************************************************
		*
		* Debug methods:
		* 
		*********************************************************************************************************************/	
		
		public function debugShowResults(chestsAwardCount:int = 1, winValue:Boolean = true):void 
		{
			ResultsUI.DEBUG_MODE = true;
			
			//if (false) {
			//if (true) {
			if (winValue) {
				Player.current.bingosInARound = 1 + Math.round(Math.random() * 3);
				//gameManager.chestsData.debugCreateNewAwardChests(chestsAwardCount);
				Player.current.liveEventScoreEarned = Math.random() > 0.5 ? Math.round(30 + Math.random() * 160) : Math.round(1000 + Math.random() * 4000);
				
				Player.current.sequenceRoundWinsCount++;
				Player.current.sequenceRoundLossCount = 0;
			}
			else {
				Player.current.bingosInARound = 0;
				
				Player.current.sequenceRoundLossCount++;
				Player.current.sequenceRoundWinsCount = 0;
			}
			
			callback_lobbyUIHide();
			callback_removeGameResults();
			
			resultsUI = new ResultsUI(this, null, null, winValue ? int(1 + Math.random() * 200) : 0, null, hideGameUI, callback_afterResultsShown, callback_removeGameResults);
			addChild(resultsUI);
			
			resultsUI.state = ResultsUI.STATE_RESULTS;
		}

		public function debugShowBackFromGame():void 
		{
			//callback_lobbyUIHide();
			
			//showBuyCardsState();
			
			//createLobbyUI(false, true);
			
			createLobbyUI(false, false);
			//lobbyUI.invalidate();
			gameUI.hide();
			state = STATE_PRE_GAME;
		}
		
		public function debugReCreateLobbyUI():void 
		{
			callback_lobbyUIHide();
			
			//showBuyCardsState();
			
			createLobbyUI(false, false);
			//lobbyUI.invalidate();
			
			state = STATE_PRE_GAME;
		}
		
		public function debugShowGame(showReadyGo:Boolean = false, cardsCount:uint = 1, ballsCount:uint = 0):void
		{
			ResultsUI.DEBUG_MODE = true;
			Player.IS_DEBUG_ROUND = true;
			
			state = STATE_IN_GAME;
				
			mPlayer.bingosInARound = 0;
			mPlayer.badBingosInARound = 0;
			mPlayer.isFirstPlaceBingo = false;
			mPlayer.isInstantBingo = false;
			
			mPlayer.clearCards();
			Room.current.numbers = [];
			
			gameScreenController.x2Clean();
			
			//Player.current.debugCreateCards(1 + int(Math.random() * 3));
			Player.current.debugCreateCards(cardsCount);
			
			while(Room.current.numbers.length < ballsCount) {
				Room.current.numbers.push(Math.max(1, int(Math.random() * 75)));
			}
				
			
			if (lobbyUI)
			{
				lobbyUI.state = LobbyUI.STATE_TO_GAME;
			}
			else
			{
				
			}
			
			addChild(gameUI);
			gameUI.show(showReadyGo);
			
		}
		
		private static var debugTextScrollContainer:DebugScrollContainer;
		private static var debugTextField:TextField;
		private static var debugTextFieldLineCount:int;
		public static var debugTextFieldText:String = '';
		public var needToDropScores:Boolean;
		
		public static function debugShowTextField(text:String, incrementText:Boolean = false):void 
		{
			//return;
			
			if (text == null)
				text = 'null';
			
			if (!debugTextField) 
			{
				debugTextScrollContainer = new DebugScrollContainer();
				debugTextScrollContainer.layout = new VerticalLayout();
				debugTextScrollContainer.verticalScrollPolicy = ScrollPolicy.ON;
				//debugTextScrollContainer.pageHeight = layoutHelper.stageHeight;
				debugTextScrollContainer.clipContent = true;
				//debugTextScrollContainer.snapToPages = true;
				
				debugTextField = new TextField(layoutHelper.stageWidth - 100*pxScale, 3000*pxScale, /*text*/"", new TextFormat(Fonts.CHATEAU_DE_GARAGE, 13, 0xcf0202, Align.LEFT, Align.TOP));
				//debugTextField.autoSize = TextFieldAutoSize.VERTICAL;
				debugTextField.y = pxScale * 20;
				debugTextField.touchable = false;
				
				debugTextScrollContainer.addChild(debugTextField);
			}
			
			//debugTextFieldLineCount++;
			//debugTextField.height = debugTextFieldLineCount * 20;
			
			var logDate:Date = new Date();
			var timeString:String = logDate.getHours() + "-" + padWithZeroes(logDate.getMinutes(), 2) + "-" + padWithZeroes(logDate.getSeconds(), 2) + ': ';
			
			debugTextField.text = incrementText ? (debugTextField.text + '\n' + timeString + text) : (timeString + text);
			
			debugTextScrollContainer.height = layoutHelper.stageHeight;
			
			Starling.current.stage.addChild(debugTextScrollContainer);
		}
		
		public function finishLoadingAllAssets():void 
		{
			AssetsManager.instance.loadAssetsIfNeeded(getStaticAssets(), null);
		}
		
		private static function padWithZeroes(num:int, minLength:uint):String
		{
			var str:String = num.toString();
			while (str.length < minLength) {
				str = "0" + str;
			}
			return str;
		}
	}
}
import feathers.controls.ScrollContainer;
import flash.geom.Point;
import starling.display.DisplayObject;

final class DebugScrollContainer extends ScrollContainer {
	public function DebugScrollContainer() {
		
	}
	
	override public function hitTest(localPoint:Point):DisplayObject
	{
		return localPoint.x < 30 ? this : null;
		
		var localX:Number = localPoint.x;
		var localY:Number = localPoint.y;
		
		var result:DisplayObject = super.hitTest(localPoint);
		if(!result)
		{
			return this._hitArea.contains(localX, localY) ? this : null;
		}
		
		return result;
	}
}