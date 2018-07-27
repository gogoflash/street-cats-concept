package com.alisacasino.bingo.utils.keyboard
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.Fonts;
	import com.alisacasino.bingo.assets.ImageAsset;
	import com.alisacasino.bingo.assets.ImagesAtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.assets.SoundZipAsset;
	import com.alisacasino.bingo.commands.ShowNoMoneyPopup;
	import com.alisacasino.bingo.commands.ShowTournamentEndAndReload;
	import com.alisacasino.bingo.commands.dialogCommands.ShowNoConnectionDialog;
	import com.alisacasino.bingo.commands.dialogCommands.ShowStore;
	import com.alisacasino.bingo.commands.gameScreenCommands.RoundOverCommand;
	import com.alisacasino.bingo.commands.messages.HandlePurchaseOkMessage;
	import com.alisacasino.bingo.commands.player.CollectCommodityItem;
	import com.alisacasino.bingo.commands.player.ShowCompleteCollectionPageDialog;
	import com.alisacasino.bingo.commands.player.UpdateLobbyBarsTrueValue;
	import com.alisacasino.bingo.components.DottedLine;
	import com.alisacasino.bingo.components.MultiCharsLabel;
	import com.alisacasino.bingo.components.NativeStageRedErrorPlate;
	import com.alisacasino.bingo.components.effects.ParticleExplosion;
	import com.alisacasino.bingo.controls.ChestAwardView;
	import com.alisacasino.bingo.controls.GameCard;
	import com.alisacasino.bingo.controls.ReadyGo;
	import com.alisacasino.bingo.controls.ResourceBar;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.cardPatternHint.CardPattern;
	import com.alisacasino.bingo.dialogs.BaseDialog;
	import com.alisacasino.bingo.dialogs.ClaimBonusDialog;
	import com.alisacasino.bingo.dialogs.DialogProperties;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.InfoDialog;
	import com.alisacasino.bingo.dialogs.InviteFriendsDialog;
	import com.alisacasino.bingo.dialogs.NewVersionDialog;
	import com.alisacasino.bingo.dialogs.ReconnectDialog;
	import com.alisacasino.bingo.dialogs.ServiceDialog;
	import com.alisacasino.bingo.dialogs.chests.ChestOpenDialog;
	import com.alisacasino.bingo.dialogs.chests.ChestPartsView;
	import com.alisacasino.bingo.dialogs.chests.ChestTakeOutDialog;
	import com.alisacasino.bingo.dialogs.offers.OfferDialog;
	import com.alisacasino.bingo.dialogs.offers.SaleBadgeView;
	import com.alisacasino.bingo.dialogs.scratchCard.ScratchCardWindow;
	import com.alisacasino.bingo.dialogs.slots.SlotsDialog;
	import com.alisacasino.bingo.dialogs.tournamentResultDialogClasses.TournamentResultDialog;
	import com.alisacasino.bingo.models.TutorialManager;
	import com.alisacasino.bingo.models.chests.ChestData;
	import com.alisacasino.bingo.models.chests.ChestRewardGenerator;
	import com.alisacasino.bingo.models.chests.ChestsData;
	import com.alisacasino.bingo.models.collections.Collection;
	import com.alisacasino.bingo.models.collections.CollectionItem;
	import com.alisacasino.bingo.models.collections.CollectionPage;
	import com.alisacasino.bingo.models.collections.CollectionsData;
	import com.alisacasino.bingo.models.gifts.GiftsModel;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.models.quests.QuestObjective;
	import com.alisacasino.bingo.models.quests.QuestType;
	import com.alisacasino.bingo.models.quests.questItems.BurnNCards;
	import com.alisacasino.bingo.models.quests.questItems.CollectNCards;
	import com.alisacasino.bingo.models.scratchCard.ScratchCardModel;
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.protocol.CustomizationType;
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import com.alisacasino.bingo.protocol.CardType;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.protocol.ChestWinMessage;
	import com.alisacasino.bingo.protocol.ClaimOfferOkMessage;
	import com.alisacasino.bingo.protocol.LiveEventInfoOkMessage;
	import com.alisacasino.bingo.protocol.PowerupType;
	import com.alisacasino.bingo.protocol.PurchaseOkMessage;
	import com.alisacasino.bingo.protocol.QuestDataMessage;
	import com.alisacasino.bingo.protocol.RoundOverMessage;
	import com.alisacasino.bingo.protocol.TournamentResultMessage;
	import com.alisacasino.bingo.protocol.TournamentTopPlayer;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.FullscreenDialogBase;
	import com.alisacasino.bingo.screens.ResultsUI;
	import com.alisacasino.bingo.screens.gameScreenClasses.GameScreenController;
	import com.alisacasino.bingo.screens.gameScreenClasses.PowerupDisplay;
	import com.alisacasino.bingo.screens.gameScreenClasses.ScreenCatScooter;
	import com.alisacasino.bingo.screens.gameScreenClasses.WinnerPlate;
	import com.alisacasino.bingo.screens.gameScreenClasses.WinnersPane;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.InventoryScreen;
	import com.alisacasino.bingo.screens.questsScreenClasses.QuestsScreen;
	import com.alisacasino.bingo.screens.resultsUIClasses.LeaderboardListView;
	import com.alisacasino.bingo.screens.storeWindow.StoreScreen;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.FriendsManager;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.Settings;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAReconnectShownEvent;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.StringUtils;
	import com.alisacasino.bingo.utils.TimeService;
	import com.alisacasino.bingo.utils.caurina.transitions.properties.DisplayShortcuts;
	import com.alisacasino.bingo.utils.layoutHelperClasses.LayoutHelper;
	import com.alisacasino.bingo.utils.misc.TextureMaskStyle;
	import feathers.controls.ImageLoader;
	import flash.display.Stage3D;
	import flash.display.StageDisplayState;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.System;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite3D;
	import starling.events.Event;
	import treefortress.sound.SoundAS;
	import treefortress.sound.SoundInstance;
	
	import com.alisacasino.bingo.controls.PlayerBingoedPlate;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.RateUsDialog;
	import com.alisacasino.bingo.dialogs.SendGiftsDialog;
	import com.alisacasino.bingo.logging.SaveHTMLLog;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.RateDialogManager;
	import com.alisacasino.bingo.models.roomClasses.EventInfo;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.models.roomClasses.RoomType;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.EventPrizeMessage;
	import com.alisacasino.bingo.protocol.PlayerBingoedMessage;
	import com.alisacasino.bingo.protocol.PlayerMessage;
	import com.alisacasino.bingo.protocol.PrizeItemMessage;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.screens.gameScreenClasses.StarsEmitter;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.DevUtils;
	import com.alisacasino.bingo.utils.ServerConnection;
	import com.alisacasino.bingo.utils.TextureAccountant;
	import com.alisacasino.bingo.utils.emibap.textureAtlas.DynamicAtlas;
	import com.netease.protobuf.UInt64;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.text.Font;
	import flash.ui.Keyboard;
	import starling.core.Starling;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class KeyboardController
	{
		private var currentPattern:int = 1;
		
		public function KeyboardController(eventDispatcher:EventDispatcher)
		{
			
			eventDispatcher.addEventListener(KeyboardEvent.KEY_DOWN, eventDispatcher_keyDownHandler);
		}
		
		private function eventDispatcher_keyDownHandler(e:KeyboardEvent):void
		{
			if (!(e.ctrlKey || e.keyCode != Keyboard.SPACE))
			{
				return;
			}
			
			if (!e.shiftKey)
				return;
			
			if (e.keyCode == Keyboard.S)
			{
				new SaveHTMLLog().execute();
			}
			
			if (e.keyCode == 226)
			{
				Starling.current.showStats = !Starling.current.showStats;
			}
			
			if (!Constants.isDevFeaturesEnabled)
			{
				return;
			}
			
			if (e.keyCode == Keyboard.D)
			{
				doCtrlShiftD();
			}
			
			if (e.keyCode == Keyboard.V)
			{
				doCtrlShiftV();
			}
			
			if (e.keyCode == Keyboard.M)
			{
				ViewClassExplorer.changeState();
			}
			
			if (e.keyCode == Keyboard.L)
			{
				//var dialog:RareChestDialog = new RareChestDialog();
				//dialog.debugMode = true;
				//dialog.show();
				//Starling.current.nativeStage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE; 
				
				//return;
				
				/*var chestAwardView:ChestAwardView = new ChestAwardView(trace);
				   chestAwardView.x = Math.random() * 1290;
				   chestAwardView.y = Math.random() * 800;
				   (Game.current.currentScreen as GameScreen).addChild(chestAwardView);
				   chestAwardView.appear(0, 1);
				   Starling.juggler.delayCall(chestAwardView.show, 2, 1, 2, 4, 1);
				   Starling.juggler.delayCall(chestAwardView.hide, 6, 0);
				   return;*/
				
				(Game.current.currentScreen as GameScreen).debugShowResults(1, true);
				return;
				
				/*var ch:ChestAwardView = new ChestAwardView();
				   ch.x = 400;
				   ch.y = 400;
				   ch.show(ChestType.SILVER, 4000);
				   (Game.current.currentScreen as GameScreen).addChild(ch);
				   return;*/
				
					   //EffectsManager.showFullscreenSplash((Game.current.currentScreen as GameScreen), 0.7, 0.3);
					   //return;
				
			}
			
			if (e.keyCode == Keyboard.E)
			{
				doCtrlShiftE();
				
			}
			
			if (e.keyCode == Keyboard.T)
			{
				doCtrlShiftT();
			}
			
			if (e.keyCode == Keyboard.R)
			{
				
				//Game.connectionManager.sendPlayerUpdateMessage();
				//Game.current.currentScreen.cashBar.tweenAnimate(Player.current.cashCount);
				gameManager.questModel.refreshQuests();
				return;
				var reconnectDialog1:ReconnectDialog = new ReconnectDialog(ReconnectDialog.TYPE_RECONNECT, 'Custom title', 'Please reconnect. Beware flesh eating pigeons.');
				DialogsManager.addDialog(reconnectDialog1, true, true);
				return;
				
				gameManager.chestsData.dispatchEventWith(ChestsData.EVENT_ACCELERATE_CHEST_TAKE_OUT_DIALOG);
				
				return;
				
				var bar:ResourceBar = Game.current.gameScreen.lobbyUI.cashBar;
				
				EffectsManager.tweenAppearAndFly(Game.current.gameScreen, AtlasAsset.CommonAtlas.getTexture("bars/cash"), new Point(bar.x - 10 * pxScale, bar.y + 140 * pxScale), new Point(bar.x + 160 * pxScale, bar.y + 22 * pxScale), 1, 0, 1, 1);
				
				return;
				
				//var reconnectDialog:ReconnectDialog = new ReconnectDialog(ReconnectDialog.TYPE_RECONNECT, 'Custom title', 'bla lbal bla lblal bal lbal bla lblal bal lbal bla lblal bal lbal bla lblal bal lbal bla lblal bal lbal 1 bla lblal bal lbal bla lblal bal lbal bla lblal bal lbal bla lblal bal lbal bla lblal bal 2 l');
				var reconnectDialog:ReconnectDialog = new ReconnectDialog(ReconnectDialog.TYPE_RECONNECT, 'wqd', 'qwd', 10, function():void
				{
					trace('asdasd')
				}, '');
				DialogsManager.addDialog(reconnectDialog, true);
				
					//SoundManager.instance.stopSfxLoop(SoundAsset.LeaderboardFrameMoveLoop, 0.2);
				
					//Game.current.gameScreen.gameUI.gameUIPanel.winnersPane.debugAddPlayers();
					//debugAddWinnersHistory(4);
			}
			
			if (e.keyCode == Keyboard.Y)
			{
				//if (DialogsManager.instance.getDialogByClass(QuestsScreen))
				//(DialogsManager.instance.getDialogByClass(QuestsScreen) as QuestsScreen).debugShowCatCycle();
				
				//Room.current.stakeData.scorePowerupsDropped = 2;
				
				//Game.current.gameScreen.gameScreenController.dropScores(1);
				//new ScreenCatScooter().show(Game.current.gameScreen);
		
				var loadingAnimation:AnimationContainer = new AnimationContainer(MovieClipAsset.PackBase, true, true);
				loadingAnimation.reverse = true;
				//loadingAnimation.pivotX = 42 * pxScale;
				//loadingAnimation.pivotY = 42 * pxScale;
				//loadingAnimation.scale = 0.6;
				loadingAnimation.currentClip.debugMode = true;
				loadingAnimation.x = 1280 / 2;
				loadingAnimation.y = 400;
				loadingAnimation.scale = 2;
				Game.current.gameScreen.addChild(loadingAnimation);
				loadingAnimation.playTimeline('cat_scooter', false, true);
				
				
				return;
				//loadingAnimation.goToAndStop(Math.random() > 0.5 ? 0 : loadingAnimation.totalFrames);
				
				//SoundManager.instance.stopSfxLoop(SoundAsset.SuperChestJingleLoopV4);
				return;
				
				var va:int;
				
				if (counter_1 % 6 == 0)
				{
					va = 1 + Math.random() * 8;
					Player.current.updateCashCount(va, "debug");
					Player.current.reservedCashCount += va;
					
					va = 1 + Math.random() * 8;
					gameManager.powerupModel.addPowerupsFromDrop(va, gameManager.powerupModel.roundEndDropTable, "debug");
					gameManager.powerupModel.reservedPowerupsCount = va;
					trace(1);
				}
				if (counter_1 % 6 == 1)
				{
					va = 10 + Math.random() * 88;
					Player.current.updateCashCount(va, "debug");
					Player.current.reservedCashCount += va;
					
					va = 1 + Math.random() * 8;
					gameManager.powerupModel.addPowerupsFromDrop(va, gameManager.powerupModel.roundEndDropTable, "debug");
					gameManager.powerupModel.reservedPowerupsCount = va;
					trace(2);
				}
				if (counter_1 % 6 == 2)
				{
					va = 100 + Math.random() * 900;
					Player.current.updateCashCount(va, "debug");
					Player.current.reservedCashCount += va;
					
					va = 1 + Math.random() * 8;
					gameManager.powerupModel.addPowerupsFromDrop(va, gameManager.powerupModel.roundEndDropTable, "debug");
					gameManager.powerupModel.reservedPowerupsCount = va;
					trace(3);
				}
				
				if (counter_1 % 6 == 3)
				{
					va = 1 + Math.random() * 8;
					Player.current.updateCashCount(va, "debug");
					Player.current.reservedCashCount += va;
					
					va = 10 + Math.random() * 88;
					gameManager.powerupModel.addPowerupsFromDrop(va, gameManager.powerupModel.roundEndDropTable, "debug");
					gameManager.powerupModel.reservedPowerupsCount = va;
					trace(4);
				}
				if (counter_1 % 6 == 4)
				{
					va = 10 + Math.random() * 88;
					Player.current.updateCashCount(va, "debug");
					Player.current.reservedCashCount += va;
					
					va = 10 + Math.random() * 88;
					gameManager.powerupModel.addPowerupsFromDrop(va, gameManager.powerupModel.roundEndDropTable, "debug");
					gameManager.powerupModel.reservedPowerupsCount = va;
					trace(5);
				}
				if (counter_1 % 6 == 5)
				{
					va = 100 + Math.random() * 900;
					Player.current.updateCashCount(va, "debug");
					Player.current.reservedCashCount += va;
					
					va = 10 + Math.random() * 88;
					gameManager.powerupModel.addPowerupsFromDrop(va, gameManager.powerupModel.roundEndDropTable, "debug");
					gameManager.powerupModel.reservedPowerupsCount = va;
					trace(6);
				}
				
				new UpdateLobbyBarsTrueValue().execute();
				
				counter_1++;
				
				//Player.current.cleanReservedCashCount(1);
				return;
				
				///Player.current.cashCount += 100;
				//Game.connectionManager.sendPlayerUpdateMessage();
				//Game.current.currentScreen.coinsBar.tweenAnimate(Player.current.cashCount);
				
				var modifiedItem:CommodityItem = new CommodityItem(CommodityType.CASH, Player.current.cashCount + 100);
				var collectCommand:CollectCommodityItem = new CollectCommodityItem(modifiedItem, "cashBonus");
				collectCommand.doNotSendPlayerUpdate = true;
				collectCommand.execute();
				
					//SoundManager.instance.playSfxLoop(SoundAsset.LeaderboardFrameMoveLoop, 0.738, 0.1, 0.3);	
				
					//TextureAccountant.printCreatedAndUncollected();
			}
			
			if (e.keyCode == Keyboard.K)
			{
				gameManager.slotsModel.showDialog();
				
				//DialogsManager.addDialog(new SlotsDialog());
				/*var tween_0:BezierTween = new BezierTween(item, 0.2, new <Point>[new Point(item.x, item.y), new Point(item.x, item.y - 150), new Point(item.x, item.y)], BezierTween.SPEED_DEFAULT, BezierTween.ACCURACY_FINE, Transitions.EASE_IN);
				var tween_2:BezierTween = new BezierTween(item, 0.2, new <Point>[finishPoint, finishPoint, finishPoint], BezierTween.SPEED_DEFAULT, BezierTween.ACCURACY_FINE, Transitions.EASE_OUT);
				
				
				//tween_0.delay = 0.18;
				tween_0.animate('scale', 2.35 + Math.random());
				
				tween_0.nextTween = tween_2;
				
				tween_2.delay = holdUpDelay;
				tween_2.animate('x', finishPoint.x);
				tween_2.animate('y', finishPoint.y);
				tween_2.animate('scaleX', 0.91);
				tween_2.animate('scaleY', 0.91);
				tween_2.onStart = SoundManager.instance.playSfx;
				tween_2.onStartArgs = [SoundAsset.PowerUpDropV3, 0.0, 0, 1, 0, false];
				tween_2.onComplete = shakeUIs;
				tween_2.onCompleteArgs = [true, 0];
				tween_2.nextTween = tween_3;
			
				
				Starling.juggler.add(tween_0);*/
				
				return;
				DialogsManager.addDialog(new InventoryScreen(InventoryScreen.DAUBER_MODE));
				
				return;
				
				var ls:SoundZipAsset = new SoundZipAsset('female.zip');
				ls.load(function():void
				{
				
					//image = new Image(l.getTexture('cards/cats/card_background.png'));
				
				}, null);
				
				return;
				
				var l:ImagesAtlasAsset = new ImagesAtlasAsset(new <String>['cards/cats/bingo_button.png', 'cards/cats/card_background.png']);
				l.load(function():void
				{
					var image:Image;
					image = new Image(l.getTexture('cards/cats/card_background.png'));
					Game.current.gameScreen.addChild(image);
				}, null);
				
				return;
				//SoundAsset.OpenChestJingleLoop.instance.channel.soundTransform.volume = 5;
				
				/*setInterval(function():void {
				   var t:* = Starling.current.nativeStage.stage3Ds;
				   var a:Stage3D = Starling.current.nativeStage.stage3Ds[0];
				   trace('Stage3Ds: ', Starling.current.nativeStage.stage3Ds);
				
				   }, 2);*/
				
				debugShowTournamentResultDialog();
				
				return;
				//SoundManager.instance.playSfxLoop(SoundAsset.SuperChestJingleLoopV4, 3.6, 0, 0);
				SoundManager.instance.playSfxLoop(SoundAsset.SuperChestJingleLoopV4, 3.59, 0.05, 0.05);
				
				/*var dialog1:SendGiftsDialog = new SendGiftsDialog();
				   dialog1.show();*/
				
				//var dialog1:RateUsDialog = new RateUsDialog();
				//dialog1.show();
				return;
//				Game.current.gameScreen.gameUI.gameUIPanel.winnersPane.reset();
				return;
				RateDialogManager.instance.triggered = true;
				RateDialogManager.instance.showRateDialog();
			}
			
			if (e.keyCode == Keyboard.B)
			{
				//Game.current.gameScreen.gameUI.handleExitFromServer();
				
				//var json:Object = {
				
				//id: 0,
				   //session: gameManager.connectionManager.sessionId,
				   //name: "joinGame",
				   //payload: {playerId:Player.current.playerId} 
				//}
			//
				//ServerConnection.current.sendMessageNew(json);
				
				//DialogsManager.closeAll([TournamentResultDialog, ReconnectDialog, ScratchCardWindow]);
				//doCtrlShiftB();
			}
			
			if (e.keyCode == Keyboard.N)
			{
				var asd:DottedLine = new DottedLine();
				asd.x = 200;
				asd.y = 200;
				Game.current.gameScreen.addChild(asd);
				
				asd.rect = new Rectangle(0, 0, 200, 300);
				
				
				//showClipDebug(MovieClipAsset.LogoFire, MovieClipAsset.PackBase, 'logo_fire', 0, 0);
				return;
				
				/*var r:Quad = new Quad(100, 50, 0x000000);
				   r.alpha = 0.2;
				   r.x = 200;
				   r.y = 200;
				   Game.current.gameScreen.addChild(r);*/
				
				/*Game.current.gameScreen.gameUI.gameCardsView.getCardById(0).changeStyleTextures(true);
				   Game.current.gameScreen.gameUI.gameCardsView.getCardById(1).changeStyleTextures(true);
				   Game.current.gameScreen.gameUI.gameCardsView.getCardById(2).changeStyleTextures(true);
				   Game.current.gameScreen.gameUI.gameCardsView.getCardById(3).changeStyleTextures(true);
				   return;*/
				
				/*var starsExplosion:ParticleExplosion = new ParticleExplosion(AtlasAsset.LoadingAtlas, "misc/white_star", null, 20);
				   starsExplosion.setProperties(20*pxScale, 3, -0.045, 0.0, 0, 1);
				   starsExplosion.setFineProperties(0.3, 0.6, 0.5, 1.2, 0.5, 2);
				   starsExplosion.setEmitDirectionAngleProperties(Math.PI, Math.PI/4);
				   starsExplosion.x = 400;
				   starsExplosion.y = 400;
				
				
				   Game.current.gameScreen.addChild(starsExplosion )
				   starsExplosion.play(370, 20);
				
				   return;*/
				
				//Game.current.gameScreen.gameUI.gameUIPanel.winnersPane.addWinnerFromPlayerBingoedMessage(WinnersPane.debugGetPlayerBingoedMessage(true, counter_4++));
				
				/*var aa:int = 10000
				   while (aa-- > 0 ) {
				   gameManager.chestsData.takeTutorChest();
				   }*/
				
				//gameManager.chestsData.debugSelectPrizes();
				
				//SoundManager.instance.setSoundtrackVolume(0.2, 500);
				//return;
				
				gameManager.collectionsData.debugCreateOwnedItems(45);
				var newCollectionItems:Vector.<CollectionItem> = gameManager.collectionsData.debugGetOwnedItems(1 + Math.random() * 4);
				gameManager.collectionsData.newCollectionItems = gameManager.collectionsData.newCollectionItems.concat(newCollectionItems);
//				Game.current.gameScreen.lobbyUI.lobbyItemDropsController.showDrops(newCollectionItems, null);
				
				var customizers:Vector.<CustomizerItemBase> = new <CustomizerItemBase>[];
				var customizers1:Vector.<CustomizerItemBase> = new <CustomizerItemBase>[];
				customizers.push(gameManager.skinningData.getCustomizerByAsset(CustomizationType.CARD, '2018'));
				customizers.push(gameManager.skinningData.getCustomizerByAsset(CustomizationType.CARD, 'bell'));
				customizers1.push(gameManager.skinningData.getCustomizerByAsset(CustomizationType.CARD, '2018'));
				customizers1.push(gameManager.skinningData.getCustomizerByAsset(CustomizationType.CARD, 'bell'));
				//customizers.push(gameManager.skinningData.getCustomizerByAsset(CustomizationType.CARD, 'snow'));
				//customizers.push(gameManager.skinningData.getCustomizerByAsset(CustomizationType.CARD, 'santa'));
				//customizers.push(gameManager.skinningData.getCustomizerByAsset(CustomizationType.DAUB_ICON, 'classic_black'));
				//customizers.push(gameManager.skinningData.getCustomizerByAsset(CustomizationType.DAUB_ICON, 'classic_green'));
				//customizers.push(gameManager.skinningData.getCustomizerByAsset(CustomizationType.DAUB_ICON, 'classic_pink'));
				//customizers.push(gameManager.skinningData.getCustomizerByAsset(CustomizationType.DAUB_ICON, 'classic_purple'));
				//gameManager.skinningData.newCustomizerItems = customizers1;
				//Game.current.gameScreen.lobbyUI.lobbyItemDropsController.showDrops(null, customizers);
				
				//l.skipAnimate();
				//return;
				
				//(Game.current.currentScreen as GameScreen).lobbyUI.chestsView.shakeSlots(5)//Math.round(Math.random() * 4));
				return;
				
				(Game.current.currentScreen as GameScreen).debugShowGame(true, 4, 9);
				
				/*var s:Sprite = new Sprite();
				   var ii:int = 20;
				   while(ii-- > 0) {
				   "SharkLatin"
				   var numberLabel:XTextField = new XTextField(60, 60, XTextFieldStyle.CardNumberTextFieldStyle, '' + String(ii));
				   //var numberLabel:XTextField = new XTextField(60, 60, XTextFieldStyle.LeaderboardItemTitleTextFieldStyle, String(ii));
				
				   //numberLabel.redraw();
				   numberLabel.batchable = true;
				   //numberLabel.border = true;
				   numberLabel.pivotX = numberLabel.width >> 1;
				   numberLabel.pivotY = numberLabel.height >> 1;
				   numberLabel.x = 100 + Math.random() * 900;
				   numberLabel.y = 100 + Math.random() * 700;
				   s.addChild(numberLabel);
				
				   var mm:Image = new Image(AtlasAsset.LoadingAtlas.getTexture("misc/white_star"));
				   mm.x = 100 + Math.random() * 900;
				   mm.y = 100 + Math.random() * 700;
				   //s.addChild(mm);
				   }
				
				   (Game.current.currentScreen as GameScreen).addChild(s);*/
			}
			
			if (e.keyCode == Keyboard.U)
			{
				Game.current.gameScreen.gameUI.nextFightAction();
				return;
				//DialogsManager.addDialog(new ScratchCardWindow(ScratchCardModel.X50_CARD_TYPE));
				
				//if (DialogsManager.instance.getDialogByClass(QuestsScreen))
					//(DialogsManager.instance.getDialogByClass(QuestsScreen) as QuestsScreen).hideFunCats();
				
				//gameManager.skinningData.debugAddRandomNewCustomizer(CustomizationType.CARD, 2);
				//gameManager.skinningData.loadDauberSkin(1, true);
				//gameManager.skinningData.loadCardSkin(1, true);
				//return;
				
				//Game.current.gameScreen.showInboxNotify();
				
				/*				var reconnectDialog:ReconnectDialog = new ReconnectDialog();
				   DialogsManager.addDialog(reconnectDialog);*/
				
				//var sadfas:Sкtring = gameManager.powerupModel.getRandomPowerup();
				//trace(' >> ', sadfas);
				//return;
				//Game.current.gameScreen.gameUI.gameCardsView.debugCardVisible(); 
				
				//gameManager.powerupModel.addPowerup(Powerup.CASH, 1);
				//Game.current.gameScreen.gameUI.gameUIPanel.powerupBar.reset();
				//debugPowerupBar.reset()
				//return;
				
				//Game.current.gameScreen.resultsUI.resultsRankView.show(Math.random()*500, 2.7);
				//return;
				
				Game.current.gameScreen.gameUI.debugAddPowerUpToCards();
				
				return;
				Player.current.clearCards();
				Room.current.numbers = [];
				new RoundOverCommand(Game.current.currentScreen as GameScreen, new RoundOverMessage(), true).execute();
			}
			
			if (e.keyCode == Keyboard.J)
			{
				/*var starsExplosion:ParticleExplosion = new ParticleExplosion(AtlasAsset.LoadingAtlas, "icons/square", null, 20);
				   starsExplosion.setProperties(20*pxScale, 3, -0.045, 0.0, 0, 1);
				   starsExplosion.setFineProperties(0.3, 0.6, 0.5, 1.2, 0.5, 2);
				   starsExplosion.setEmitDirectionAngleProperties(Math.PI, Math.PI/4);
				   starsExplosion.x = 400;
				   starsExplosion.y = 400;
				   Game.current.gameScreen.addChild(starsExplosion )
				   starsExplosion.play(370, 20);*/
				
				debugParticleExplode()
				
				return;
				//DialogsManager.addDialog(new OfferDialog());
				gameManager.offerManager.refresh();
				
				return;
				gameManager.skinningData.loadDauberSkin(2, true);
				gameManager.skinningData.loadCardSkin(2, true);
				return;
				
				var roundOverMessage:RoundOverMessage = new RoundOverMessage();
				roundOverMessage.chestWin = null//win ? (new ChestWinMessage()) : null;
				new RoundOverCommand(Game.current.gameScreen, roundOverMessage, true).execute();
				
				//GameScreen.debugShowTextField('for sen ' + Math.random(), true);
				
				return;
				Game.current.gameScreen.gameUI.gameCardsView.getCard(counter_4).debugShowX2Powerup(10000);
				counter_4++;
				if (counter_4 == 2)
					counter_4 = 0;
				
				return;
				DialogsManager.addDialog(new InviteFriendsDialog(FriendsManager.DIALOG_MODE_GET_FREE_CASH));
			}
			
			if (e.keyCode == Keyboard.I)
			{
				/*showFade(4);
				
				   var particleExplosion1:ParticleExplosion = EffectsManager.getConfettiParticleExplosion1();
				   particleExplosion1.x = 480 * pxScale;
				   particleExplosion1.y = 280 * pxScale;
				   Game.current.gameScreen.addChild(particleExplosion1);
				   particleExplosion1.play(400, 150, 110, 0);*/
				
				gameManager.tournamentData.endsAt = TimeService.serverTimeMs + 40 * 1000;
				gameManager.questModel.dropDailyQuestPassedCount();
				
				return;
				gameManager.questModel.reservedProgress += 30;
				gameManager.questModel.cleanReservedProgress();
				/*gameManager.tutorialManager.modifyPlayerXp();
				   Player.current.gamesCount++;
				   Player.current.consumeExp();
				   Player.current.clearEarned();
				   trace('>', Player.current.xpCount, gameManager.gameData.getXpCountForLevel(Player.current.xpLevel), gameManager.gameData.getXpCountForLevel(Player.current.xpLevel + 1));
				   Player.current.dispatchEventWith(Player.EVENT_LEVEL_CHANGE, true);*/
				
				//Game.current.gameScreen.gameUI.gameCardsView.refreshSkinTextures();
				//trace(Game.connectionManager.createSignature());
				return;
				
				addCoins(1000);
				new UpdateLobbyBarsTrueValue(0).execute();
				return;
				
				/*if (!debugPowerupBar)
				   debugShowPowerupDisplay();
				   else
				   debugPowerupBar.advance();
				 */
				Game.current.gameScreen.gameUI.advancePowerup();
				
				return;
				(Game.current.currentScreen as GameScreen).gameUI.gameUIPanel.jumpUI();
				(Game.current.currentScreen as GameScreen).shakeBackground(ResizeUtils.SHAKE_X_Y_SHRINK);
				
			}
			
			if (e.keyCode == Keyboard.G)
			{
				var vars:URLVariables = new URLVariables();
				//vars.key = 'debug_1';
				//vars.content = "log_DEBUG_1";
				//vars.decode("key=debug_1&content=log_DEBUG_1");
				
				//uploadURL.url = "myfile.php?var1=var1Value&var2=var2Value";
				//uploadURL.contentType = 'application/octet-stream';
				
				var hdr:URLRequestHeader = new URLRequestHeader("Content-type", "application/json");
				
				var uploadURL:URLRequest = new URLRequest();
				uploadURL.url = 'http://bingo2-dev0.alisagaming.net:9095/push';
				uploadURL.method = URLRequestMethod.POST;
				uploadURL.data = '{ "key": "test_2", "content": "log_1 22 3223" }';
				uploadURL.requestHeaders.push(hdr);
				
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
				urlLoader.addEventListener(Event.COMPLETE, completeHandler);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler); 
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
				urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler); 
				urlLoader.load(uploadURL);
    
				function completeHandler(event:*):void
				{
					1 + 1
				}
				
				function errorHandler(event:*):void
				{
					1 + 1
				}
				
				function httpStatusHandler(event:*):void
				{
					1 + 1
				}
				
				


				
				
				return;
				gameManager.chestsData.debugCreateNewAwardChest(ChestType.SUPER);
//				Game.current.gameScreen.lobbyUI.chestsView.takeOutNewAwardChests();
				
				return;
				DialogsManager.addDialog(new InfoDialog(Constants.TITLE_CLAIMED, Constants.TEXT_CLAIMED, Constants.BTN_OK, false, false));
				return;
				
				var claimOfferOkMessage:ClaimOfferOkMessage = new ClaimOfferOkMessage();
				claimOfferOkMessage.offerType = 'coins';
				claimOfferOkMessage.offerValue = 178;
				DialogsManager.addDialog(new ClaimBonusDialog(ClaimBonusDialog.TYPE_FREEBIE_CLAIM, claimOfferOkMessage, ''));
				
				return;
				
				var i1:int = 0;
				while (i1 < 101)
				{
					trace(i1, StringUtils.numberToNounString(i1));
					i1++;
				}
				
				return;
				
				showFade(4);
				
				var particleExplosion:ParticleExplosion = EffectsManager.getConfettiParticleExplosion();
				particleExplosion.x = 480 * pxScale;
				particleExplosion.y = 280 * pxScale;
				Game.current.gameScreen.addChild(particleExplosion);
				particleExplosion.play(400, 150, 110, 0);
				
				return;
				SaleBadgeView.debugPreviewAllBadges(Game.current.gameScreen);
				
				//SoundManager.instance.playBallNumber(1 + int(Math.random() * 74));
				return;
				
				//
				addCoins(-400);
				new UpdateLobbyBarsTrueValue(0).execute();
				return;
				
				//NativeStageRedErrorPlate.show(2, 'adasd');
				
				//GiftsModel.DEBUG_MODE = true;
				//GameManager.instance.giftsModel.debugAddGifts(5);
				
				
					//gameManager.tutorialManager.showAlphaMask(Game.current.gameScreen, Math.random() * 800, Math.random() * 500, Math.random() * 800, Math.random() * 100, 100, 100, 0.3);
			}
			
			if (e.keyCode == Keyboard.Z)
			{
				debugParticleExplode2();
				return;
				//addCollections(3);
				
				/*EffectsManager.scaleJumpDisappear(Game.current.gameScreen.lobbyUI.b, 0.45, 0, function():void { Starling.juggler.delayCall(function():void {Game.current.gameScreen.lobbyUI.b.scale = 1;}, 1)});
				   EffectsManager.scaleJumpDisappear(Game.current.gameScreen.lobbyUI.checkMark, 0.45, 0, function():void { Starling.juggler.delayCall(function():void {Game.current.gameScreen.lobbyUI.checkMark.scale = 1;}, 1)});
				   EffectsManager.scaleJumpDisappear(Game.current.gameScreen.lobbyUI.checkMark1, 0.3, 0, function():void { Starling.juggler.delayCall(function():void {Game.current.gameScreen.lobbyUI.checkMark1.scale = 1;}, 1)});*/
				
				//Game.current.gameScreen.onBackButtonPressed();
				
				gameManager.connectionManager.sendClientMessage('test');
				
				//Game.current.gameScreen.lobbyUI.storeButton.badgeTexture = Math.random() > 0.5 ? 'controls/badge_free' : null;
				
				//Game.current.gameScreen.gameUI.gameUIPanel.winnersPane.debugAddPlayer();
				//Starling.juggler.delayCall(Game.current.gameScreen.gameUI.gameUIPanel.winnersPane.debugAddPlayer, 2);
				
				//DEBUG_BOOLEAN = true; 
				return;
				
				new ShowNoMoneyPopup(ShowNoMoneyPopup.YELLOW, /*titleContainer*/ Starling.current.stage, new Point(400 * pxScale, 400 * pxScale)).execute();
				return;
				//Game.current.gameScreen.resultsUI.jumpBg();
				
				//Game.current.gameScreen.resultsUI.resultsRankView.show(1000, 1);
				
				//resultsRankView.show(scoreUpdateOKMessage.currentPosition.liveEventRank, 1);
				Game.current.gameScreen.backToLobby();
				return;
				
				Game.current.gameScreen.gameUI.forceFinishBingoAnimations();
				return;
				
				GameManager.instance.deactivated = false;
				Game.dispatchEventWith(Game.ACTIVATED);
				
				return;
				
				addCoins(1000);
				new UpdateLobbyBarsTrueValue(0).execute();
				return;
				
				var claimOfferOkMessage1:ClaimOfferOkMessage = new ClaimOfferOkMessage();
				claimOfferOkMessage1.offerType = 'coins';
				claimOfferOkMessage1.offerValue = 178;
				DialogsManager.addDialog(new ClaimBonusDialog(ClaimBonusDialog.TYPE_FACEBOOK_BONUS, claimOfferOkMessage1, ''));
				
				return;
				new ShowNoConnectionDialog(null, null).execute();
				//Game.connectionManager.sendClaimOfferMessage('asdasd');
				return;
				
				var message:ClaimOfferOkMessage = new ClaimOfferOkMessage();
				message.offerType = "coins";
				message.offerValue = 100;
				//FriendsManager.instance.showClaimBonusDialog(message);
				
				//gameManager.tutorialManager.hideAlphaMask(false, 0.3, 0, Math.random() * 800, Math.random() * 500);
				///gameManager.tutorialManager.showAlphaMask(Game.current.gameScreen, Math.random() * 800, Math.random() * 500, Math.random() * 800, Math.random() * 100);
				
				return;
				var f:FullscreenDialogBase = new FullscreenDialogBase();
				DialogsManager.addDialog(f);
				
				return;
				debugTornamentClose();
				return;
				
				var chestData:ChestData = gameManager.chestsData.getEmptySlot(Math.floor((gameManager.chestsData.chests.length - 1) / 2));
				chestData.generatePrizes(ChestType.SILVER, 50, 0, 15, 1, CardType.NORMAL, 1, 2, 4);
				chestData.generatePrizes(ChestType.GOLD, 50, 0, 15, 1, CardType.NORMAL, 1, 2, 4);
				chestData.generatePrizes(ChestType.BRONZE, 50, 0, 15, 1, CardType.NORMAL, 1, 1, 2);
				
				return;
				
				gameManager.chestsData.closeOpenAndTakeOutDialogs();
				return;
				
				new ShowNoConnectionDialog(null, null).execute();
				return;
				/*var c:ChestTakeOutDialog = DialogsManager.instance.getDialogByClass(ChestTakeOutDialog) as ChestTakeOutDialog;
				   if(c)
				   c.accelerateTweens();
				   return;*/
				
					   //Game.current.gameScreen.backToSplash();
				
			}
			
			if (e.keyCode == Keyboard.NUMBER_9)
			{
				//new ReadyGo().show(Game.current.currentScreen as GameScreen, 0);
				//return;
				
				TutorialManager.addBallToGame(true, false/*, CardPattern.generateTutorialList()*/, null, true);
				return;
				
				var mm:Image = new Image(AtlasAsset.CommonAtlas.getTexture("cards/energy_orange"));
				mm.alignPivot();
				//mm.x = 100 + Math.random() * 900;
				//mm.y = 100 + Math.random() * 700;
				
				var sp:Sprite3D = new Sprite3D();
				sp.x = 200 + Math.random() * 700;
				sp.y = 200 + Math.random() * 550;
				sp.addChild(mm);
				
				sp.rotationY = -Math.PI//-(60 * Math.PI) / 180;
				
				Game.current.gameScreen.addChild(sp);
				
				Starling.juggler.delayCall(function():void
				{
					mm.texture = AtlasAsset.CommonAtlas.getTexture("cards/cash")
				}, 0.4 + 0.3);
				
				var tweenCard_0:Tween = new Tween(sp, 0.8, Transitions.EASE_OUT);
				var tweenCard_1:Tween = new Tween(sp, 0.2, Transitions.EASE_IN);
				var tweenCard_2:Tween = new Tween(sp, 0.18, Transitions.EASE_OUT_BACK);
				
				tweenCard_0.delay = 0.4;
				tweenCard_0.animate('rotationY', (180 * Math.PI) / 180);
				//tweenCard_0.animate('scaleX', 0.86);
				//tweenCard_0.animate('scaleY', 1.03);
				tweenCard_0.animate('scale', 1.3);
				tweenCard_0.nextTween = tweenCard_1;
				
				tweenCard_1.animate('rotationY', (360 * Math.PI) / 180);
				tweenCard_1.animate('scale', 1);
				
				//tweenCard_1.nextTween = tweenCard_2;
				
				tweenCard_2.animate('rotation', 0);
				tweenCard_2.animate('scaleX', 1);
				tweenCard_2.animate('scaleY', 1);
				//				tweenCard_2.moveTo(cardFinishX, cardFinishY);
				
				Starling.juggler.add(tweenCard_0);
				
				return;
				
				Starling.juggler.tween(sp, 2, {transition: Transitions.EASE_OUT_BACK, delay: 2, rotationY: 60 / 180 * Math.PI, onComplete: cycleRotateShineImage, onCompleteArgs: [sp, sp.rotationY + 2]
				
				});
				
				return;
				//EffectsManager.showParticleColoredStarsSquaresLozenge(Game.current.gameScreen, 1, 400, 400);
				debugParticleExplode2();
				return;
				/*if(ff == 0)
				   ff = EffectsManager.showStarsShine(Game.current.currentScreen as GameScreen, new Rectangle(100,100, 300, 50), 10, 0.2, 0.8);
				   else
				   EffectsManager.cleanStarsShine();*/
				
				//EffectsManager.showParticleColoredStarsAndSquares(Game.current.currentScreen as GameScreen, 1, 400, 300);
				
				new ReadyGo().show(Game.current.currentScreen as GameScreen, 0);
			}
			
			if (e.keyCode == Keyboard.NUMBER_1)
			{
				LayoutHelper.LARGE_SCREEN_DIAGONAL = 14.7;
				gameManager.layoutHelper.initScreen(Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight);
				Game.current.gameScreen.debugShowGame(true, 1, 3);
			}
			if (e.keyCode == Keyboard.NUMBER_2)
			{
				LayoutHelper.LARGE_SCREEN_DIAGONAL = 14.7;
				gameManager.layoutHelper.initScreen(Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight);
				Game.current.gameScreen.debugShowGame(true, 2, 3);
			}
			if (e.keyCode == Keyboard.NUMBER_3)
			{
				LayoutHelper.LARGE_SCREEN_DIAGONAL = 14.7;
				gameManager.layoutHelper.initScreen(Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight);
				Game.current.gameScreen.debugShowGame(true, 3, 3);
			}
			if (e.keyCode == Keyboard.NUMBER_4)
			{
				LayoutHelper.LARGE_SCREEN_DIAGONAL = 14.7;
				gameManager.layoutHelper.initScreen(Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight);
				Game.current.gameScreen.debugShowGame(true, 4, 3);
			}
			
			if (e.keyCode == Keyboard.NUMBER_5)
			{
				ServiceDialog.debugSetPlayerStartPack();
			}
			
			if (e.keyCode == Keyboard.NUMBER_6)
			{
				ServiceDialog.switchIPhoneXBackground();
			}
			
			if (e.keyCode == Keyboard.NUMBER_7)
			{
				DialogsManager.addDialog(new ServiceDialog(), true);
			}
		
		}
		
		private function doCtrlShiftV():void
		{
			cycleActiveQuest();
		}
		
		private function cycleActiveQuest():void
		{
			//gameManager.questModel.cycleActiveQuest();
		}
		
		private function fillCollectionAndShowWindow():void
		{
			var page:CollectionPage = gameManager.collectionsData.getCurrentCollection().getCurrentPage();
			for each (var item:CollectionItem in page.items)
			{
				if (!item.owned)
				{
					item.owned = true;
					break;
				}
			}
			gameManager.collectionsData.showRecentlyCollectedPageIfAny()
		}
		
		private function doCtrlShiftB():void
		{
			fillCollectionAndShowWindow();
		
			//SoundManager.instance.playSfxLoop(SoundAsset.SuperChestJingleLoopV4, 3.61, 0.07, 0.05);
			//return;
			//gameManager.collectionsData.debugCreateOwnedItems(25);
		
			//var baseDialog:BaseDialog = new BaseDialog(DialogProperties.STUB);
			//DialogsManager.addDialog(new RateUsDialog(RateUsDialog.MODE_RATE));
		
			//debugLeaderBoardView(60, 360, 4, 0);	
			//debugLeaderBoardView(60, 5, 360, 0);	
			//debugShowNextLeaderBoardView(ResultsUI.debugLeaderBoardsParamsList);
			//debugLeaderBoardView(5, 0, 2, 0);	
			//debugLeaderBoardView(16, 0, 16, 0);
		
		/*var sp:Sprite = new Sprite();
		   var openChestDialog:Quad = new Quad(Math.random()*300 + 1, 1 + Math.random()*300, Math.random()*0xFFFFFF);
		   openChestDialog.x = Math.random()*400;
		   openChestDialog.y = Math.random() * 400;
		   sp.addChild(openChestDialog);
		   DialogsManager.addDialog(openChestDialog, 0.8);*/
		}
		
		public static var DEBUG_BOOLEAN:Boolean;
		
		public var counter_0:int;
		public var counter_1:int;
		public var counter_2:int;
		public var counter_3:int;
		public var counter_4:int;
		
		private function doCtrlShiftT():void
		{
			//Settings.instance.maintenance = !Settings.instance.maintenance;
			
			
			if (Starling.juggler.timeScale == 1)
				Starling.juggler.timeScale = 0.25
			else
				Starling.juggler.timeScale = 1
		
		/*
		   gameManager.tournamentData.debugCreateTournamentResultToShow();
		   new ShowTournamentEndAndReload().execute();
		 */
		
		/*
		   gameManager.tournamentData.tournamentResultToShow = createEventTournamentResultMessage();
		   gameManager.tournamentData.pendingTournametInfo = new LiveEventInfoOkMessage();
		   gameManager.tournamentData.pendingTournametInfo.liveEventEndsAt = UInt64.fromNumber(Math.random() * int.MAX_VALUE);
		   gameManager.tournamentData.pendingTournametInfo.liveEventStartsAt = UInt64.fromNumber(Math.random() * int.MAX_VALUE);
		   while (!gameManager.tournamentData.pendingCollection || gameManager.tournamentData.pendingCollection == gameManager.tournamentData.collection)
		   {
		   gameManager.tournamentData.pendingCollection = gameManager.collectionsData.collectionList[int(Math.random() * gameManager.collectionsData.collectionList.length)];
		   }
		   gameManager.tournamentData.pendingTournametInfo.liveEventId = UInt64.fromNumber(Math.random() * uint.MAX_VALUE);
		   gameManager.tournamentData.pendingTournamentChange = true;
		
		   new ShowTournamentEndAndReload().execute();
		 */
		
			 //new ShowCompleteCollectionPageDialog(gameManager.collectionsData.getCurrentCollection().getCurrentPage()).execute();
		}
		
		private var instance:SoundInstance
		private var instance1:SoundInstance
		
		private function doCtrlShiftD():void
		{
		
		}
		
		private function doCtrlShiftE():void
		{
			//(Game.current.currentScreen as GameScreen).shakeBackground();
			//(Game.current.currentScreen as GameScreen).debugShowBackFromGame();
		
			//return;
		/*var openChestDialog:ChestOpenDialog = new ChestOpenDialog(ChestData.debugGetRandom(), false, null, 0);
		   openChestDialog.x = 400;
		   openChestDialog.y = 400;*/
			   //(Game.current.currentScreen as GameScreen).addChild(openChestDialog);
		
			   //DialogsManager.instance.addDialog(openChestDialog);
		
			   //EffectsManager.showFullscreenSplash((Game.current.currentScreen as GameScreen), 0.7, 0.3);
		/*var chestData:ChestData = new ChestData(0);
		   chestData.type = ChestType.GOLD;
		   chestData.seed = (Math.random() * (int.MAX_VALUE - 1)) + 1;
		   new ChestTakeOutCommand(chestData, null, null, true).execute();*/
		}
		
		private function cycleRotateShineImage(i:Sprite3D, angle:Number):void
		{
			Starling.juggler.tween(i, 2, {transition: Transitions.LINEAR, rotationY: (i.rotationY + angle), onComplete: cycleRotateShineImage, onCompleteArgs: [i, angle]});
		}
		
		private function createEventTournamentResultMessage():TournamentResultMessage
		{
			var message:TournamentResultMessage = new TournamentResultMessage();
			var top:Array = []
			for (var i:int = 0; i < 3; i++)
			{
				var ttp:TournamentTopPlayer = new TournamentTopPlayer();
				ttp.player = new PlayerMessage();
				
				ttp.player.playerId = UInt64.fromNumber(int(Math.random() * int.MAX_VALUE));
				ttp.player.firstName = ttp.player.playerId.toString(36);
				top.push(ttp);
			}
			message.top = top;
			
			message.eventPrizes = [createEventPrizeMessage()];
			
			return message;
		}
		
		private function createEventPrizeMessage():EventPrizeMessage
		{
			var eventPrizeMessage:EventPrizeMessage = new EventPrizeMessage();
			eventPrizeMessage.eventId = Math.random() * int.MAX_VALUE;
			//eventPrizeMessage.roomType = RoomType.FarmRoomType.roomTypeName;
			eventPrizeMessage.score = Math.random() * 1000 + 1000;
			eventPrizeMessage.place = Math.random() * 100;
			
			var prizePayload:PrizeItemMessage = new PrizeItemMessage();
			var commodity:CommodityItemMessage = new CommodityItemMessage();
			commodity.type = 0;
			commodity.quantity = 100;
			prizePayload.payload.push(commodity);
			
			eventPrizeMessage.prizePayload = prizePayload;
			
			return eventPrizeMessage;
		}
		
		//Already used: M, O, R, S, T, Y
		
		public var l:LeaderboardListView;
		
		public var currentLeaderboardParamsIndex:int;
		
		public var debugQuad:Quad
		
		private function debugShowNextLeaderBoardView(paramsArray:Array):void
		{
			trace('index:', currentLeaderboardParamsIndex, 'params: ', paramsArray[currentLeaderboardParamsIndex]);
			
			debugLeaderBoardView.apply(null, paramsArray[currentLeaderboardParamsIndex]);
			
			currentLeaderboardParamsIndex++;
			
			if (currentLeaderboardParamsIndex >= paramsArray.length)
				currentLeaderboardParamsIndex = 0;
		}
		
		private function debugLeaderBoardView(neighborsTotalCount:uint = 60, minRank:int = 50, minOldRank:int = 50, randomizeRank:int = 200, isTopPlayer:Boolean = false):void
		{
			if (!l)
			{
				debugQuad = new Quad(1, 1, 0x0);
				debugQuad.alpha = 0.85;
				(Game.current.currentScreen as GameScreen).addChild(debugQuad);
				
				l = new LeaderboardListView((Game.current.currentScreen as GameScreen).shakeBackground, null, 628 * pxScale, 231 * pxScale);
				l.setSize(628 * pxScale, 231 * pxScale);
				l.validate();
				(Game.current.currentScreen as GameScreen).addChild(l);
			}
			
			debugQuad.width = gameManager.layoutHelper.stageWidth;
			debugQuad.height = gameManager.layoutHelper.stageHeight;
			
			l.scale = gameManager.layoutHelper.scaleFromEtalonMin;
			l.x = (gameManager.layoutHelper.stageWidth - l.width) / 2;
			l.y = (gameManager.layoutHelper.stageHeight - l.height) / 2;
			
			//l.debugPlayWidthNewData(); 
			l.createDebugData(neighborsTotalCount, minRank, minOldRank, randomizeRank, isTopPlayer);
			l.animate();
		}
		
		private function debugParticleFlow():void
		{
			var particleEffect:ParticleExplosion = new ParticleExplosion(AtlasAsset.CommonAtlas, "effects/puff_ball", new <uint>[0x98FFFE]);
			particleEffect.x = 143 * pxScale;
			particleEffect.y = 240 * pxScale;
			particleEffect.setProperties(0, 130 * pxScale, 2.8, -0.001, 0, 0, 0.3);
			particleEffect.setFineProperties(0.2, 0.4, 0.1, 2, 0, 0);
			particleEffect.setDirectionAngleProperties(0.03, 18, 0);
			particleEffect.setEmitDirectionAngleProperties(0, Math.PI / 6);
			
			particleEffect.x = 50;
			particleEffect.y = 300;
			
			(Game.current.currentScreen as GameScreen).addChild(particleEffect);
			particleEffect.play(0, 60, 10);
		
		}
		
		private function showFade(removeDelay:Number = 0):void
		{
			var q:Quad;
			if (!Game.current.gameScreen.getChildByName('blackQuad'))
			{
				q = new Quad(layoutHelper.stageWidth, layoutHelper.stageHeight, 0x000000);
				q.alpha = 0.85;
				q.name = 'blackQuad';
				q.touchable = false;
				Game.current.gameScreen.addChild(q);
				
			}
			else
			{
				q = Game.current.gameScreen.getChildByName('blackQuad') as Quad;
			}
			
			Starling.juggler.removeTweens(q);
			
			if (removeDelay != 0)
				Starling.juggler.tween(q, 0.3, {alpha: 0, onComplete: q.removeFromParent, onCompleteArgs: [true], delay: removeDelay});
		
		}
		
		private function debugParticleExplode():void
		{
			showFade(4);
			
			var colors:Vector.<uint> = new <uint>[0x8BE902/*green*/, 0xE80C72/*pink*/, 0x17D0FF/*blue*/, 0xFFFF00/*yellow*/, 0xDA89EB/*purple*/];
			var particleEffect:ParticleExplosion = new ParticleExplosion(AtlasAsset.CommonAtlas, new <String>["effects/square_white"], colors);
			particleEffect.x = 443 * pxScale + 211;
			particleEffect.y = 340 * pxScale//- 175;
			particleEffect.setProperties(0, 10 * pxScale, 11, -0.015, 0.08, 0, 0.4);
			particleEffect.setFineProperties(1.0, 0.8, 0.1, 1, 0, 0);
			particleEffect.onlyPositiveSpeed = true;
			particleEffect.setAccelerationProperties(-0.31);
			//particleEffect.setEmitDirectionAngleProperties(1, -Math.PI/2, 300 * Math.PI / 180);
			particleEffect.gravityAcceleration = 0.07;
			particleEffect.skewAplitude = 0.2
			particleEffect.play(350, 90, 90);
			//particleEffect.play(750, 1, 0);
			
			Game.current.gameScreen.addChild(particleEffect);
			
			if (DialogsManager.instance.getDialogByClass(QuestsScreen))
				(DialogsManager.instance.getDialogByClass(QuestsScreen) as QuestsScreen).addChild(particleEffect);
		
		}
		
		private function debugParticleExplode1():void
		{
			var colors:Vector.<uint> = new <uint>[0xFFFFFF, 0x95E501, 0xFF6600, 0xFFEF00, 0x8EF3FF, 0xFFFF00/*, 0x0055FD, 0xF99BE5*/];
			var particleEffect:ParticleExplosion = new ParticleExplosion(AtlasAsset.CommonAtlas, new <String>["icons/star", 'icons/square', "icons/lozenge"], colors);
			particleEffect.x = 443 * pxScale;
			particleEffect.y = 340 * pxScale;
			particleEffect.setProperties(0, 100 * pxScale, 5, -0.030, 0.01, 0, 0.8);
			particleEffect.setFineProperties(1.0, 0.4, 0.2, 1.4, 0.5, 4);
			particleEffect.setAccelerationProperties(-0.19);
			
			(Game.current.currentScreen as GameScreen).addChild(particleEffect);
			particleEffect.play(150, 20, 15);
		
		}
		
		private function debugParticleExplode2():void
		{
			var colors:Vector.<uint> = new <uint>[0xFFFFFF];
			var particleEffect:ParticleExplosion = new ParticleExplosion(AtlasAsset.CommonAtlas, new <String>["effects/smoke_1", "effects/smoke_0"], colors);
			particleEffect.x = 443 * pxScale;
			particleEffect.y = 340 * pxScale;
			particleEffect.setProperties(0, 80 * pxScale, +0.01, 0.028, 0.01, 0, 0.7, true);
			particleEffect.setFineProperties(0.6, 0.0, 0.0, 0);
			//particleEffect.setAccelerationProperties(-0.02);
			particleEffect.lifetime = 500;
			(Game.current.currentScreen as GameScreen).addChild(particleEffect);
			//particleEffect.play(150, 20, 15);
			particleEffect.play(3000, 70, 0);
		
		}
		
		private function debugParticleExplode3():void
		{
			var colors:Vector.<uint> = new <uint>[0xFFFFFF, 0x95E501, 0xFF6600, 0xFFEF00, 0x8EF3FF, 0xFFFF00/*, 0x0055FD, 0xF99BE5*/];
			var particleEffect:ParticleExplosion = new ParticleExplosion(AtlasAsset.CommonAtlas, new <String>["icons/star", 'icons/square', "icons/lozenge"], colors);
			particleEffect.x = 443 * pxScale;
			particleEffect.y = 340 * pxScale;
			particleEffect.setProperties(0, 100 * pxScale, 1.5, -0.010, 0.01, 0, 0.8);
			particleEffect.setFineProperties(1.0, 0.4, 0.2, 1.4, 0.5, 4);
			//particleEffect.setAccelerationProperties(-0.19);
			
			(Game.current.currentScreen as GameScreen).addChild(particleEffect);
			particleEffect.play(1150, 50, 5, 0.09);
		
		}
		
		public var debugPowerupBar:PowerupDisplay;
		
		private function debugShowPowerupDisplay():void
		{
			var a:Quad = new Quad(1200, 1000, 0x0);
			a.x = 100;
			a.y = 100;
			a.alpha = 0.15;
			Game.current.gameScreen.addChild(a);
			
			debugPowerupBar = new PowerupDisplay();
			
			debugPowerupBar.x = 600;
			debugPowerupBar.y = 300;
			
			//debugPowerupBar.x = Game.current.gameScreen.width - debugPowerupBar.width - (gameManager.layoutHelper.isLargeScreen ? 11 : 7) * gameUILayoutScale;
			//debugPowerupBar.y = (gameManager.layoutHelper.isLargeScreen ? 9 : 5) * gameUILayoutScale
			
			Game.current.gameScreen.addChild(debugPowerupBar);
		}
		
		private function debugAddWinnersHistory(count:int):void
		{
			var place:int = 1;
			Room.current.bingoHistory = [];
			while (count-- > 0)
			{
				Room.current.bingoHistory.push(WinnersPane.debugGetPlayerBingoedMessage(count % 2 == 0, place++));
			}
		
		}
		
		public static function debugShowTournamentResultDialog():void
		{
			DialogsManager.addDialog(new TournamentResultDialog(debugGetTournamentResultMessage(), debugTornamentClose));
		}
		
		public static function debugGetTournamentResultMessage():TournamentResultMessage
		{
			var eventPrizeMessage:EventPrizeMessage = new EventPrizeMessage();
			eventPrizeMessage.eventId = 1;
			eventPrizeMessage.place = 1;
			eventPrizeMessage.score = 1000;
			eventPrizeMessage.prizePayload = new PrizeItemMessage();
			eventPrizeMessage.prizePayload.payload = [];
			
			var item:CommodityItemMessage = new CommodityItemMessage();
			item.type = Type.CASH;
			item.quantity = int(47 * Math.random());
			eventPrizeMessage.prizePayload.payload.push(item);
			
			var tournamentResultMessage:TournamentResultMessage = new TournamentResultMessage();
			tournamentResultMessage.eventPrizes = [eventPrizeMessage];
			
			tournamentResultMessage.top = [debugGetTournamentTopPlayer('212881995497403', 'Vasiliy'),//'Vasiliy Nikitin'),
			debugGetTournamentTopPlayer('425495904128135', 'Min'), debugGetTournamentTopPlayer('1785802438299679', 'Котоед')];
			
			return tournamentResultMessage;
		}
		
		private static function debugTornamentClose():void
		{
			Player.current.refundAndClearCards();
			//gameManager.tournamentData.setDataToPending();
			gameManager.tutorialManager.clearOnTournamentChange();
			Game.current.showGameScreen();
		}
		
		private static function debugGetTournamentTopPlayer(playerId:String, name:String):TournamentTopPlayer
		{
			var ttp:TournamentTopPlayer = new TournamentTopPlayer();
			ttp.player = new PlayerMessage();
			ttp.player.facebookIdString = playerId//'212881995497403';
			ttp.player.firstName = name//'Vasiliy';
			return ttp;
		}
		
		private function addCoins(value:int, sendUpdate:Boolean = true):void
		{
			if (Player.current.cashCount + value < 0)
			{
				Player.current.reservedCashCount = 0;
				Player.current.setCashCount(0, "debug");
			}
			else
			{
				Player.current.reservedCashCount += value;
				Player.current.updateCashCount(value, "debug");
			}
			
			if (sendUpdate)
				Game.connectionManager.sendPlayerUpdateMessage();
		}
		
		public static function addTestImages(count:int, complex:Boolean = false):void
		{
			//count = 100;
			var top:Image;
			
			while (count-- > 0 && !complex)
			{
				top = new Image(AtlasAsset.CommonAtlas.getTexture('dialogs/chest/chest_silver_top'));
				top.x = 100 + 900 * Math.random();
				top.y = 100 + 600 * Math.random();
				;
				Game.current.gameScreen.addChild(top);
				
				Starling.juggler.tween(top, 1, {scaleY: 1.2, scaleX: 0.55, y: (top.y - 100), alpha: 1, repeatCount: 0, reverse: true, transition: Transitions.EASE_IN_OUT_BACK})
			}
			
			var ch:ChestPartsView;
			while (count-- > 0 && complex)
			{
				ch = new ChestPartsView(ChestType.SILVER);
				ch.x = 100 + 900 * Math.random();
				ch.y = 100 + 600 * Math.random();
				;
				Game.current.gameScreen.addChild(ch);
				
				Starling.juggler.tween(ch, 1, {scaleY: 1.2, scaleX: 0.55, y: (ch.y - 100), alpha: 1, repeatCount: 0, reverse: true, transition: Transitions.EASE_IN_OUT_BACK})
			}
		
		}
		
		public function addCollections(count:int, rarity:int = -1):void
		{
			var currentCollection:Collection = gameManager.tournamentData.collection;
			var page:CollectionPage;
			var card:CollectionItem;
			var userCollectionItem:CollectionItem;
			
			if (rarity == -1)
				rarity = CollectionsData.allRarities[Math.floor(CollectionsData.allRarities.length * Math.random())];
			
			for (var i:int = 0; i < count; i++)
			{
				var forCurrentPage:Boolean = Math.random() > gameManager.collectionsData.completedPageProbabilty;
				page = currentCollection.getCurrentPage();
				
				if (!forCurrentPage || !page)
				{
					var randomCompletedPage:CollectionPage = currentCollection.getRandomCompletedPage(Math.random());
					if (randomCompletedPage)
						page = randomCompletedPage;
				}
				
				//rarity = CardType.NORMAL;
				
				if (page)
					card = page.getRandomCard(rarity, Math.random());
				
				if (!card)
					card = gameManager.collectionsData.getRandomCollectionItem(rarity);
				
				if (card)
				{
					userCollectionItem = gameManager.collectionsData.getItemByID(card.id);
					if (userCollectionItem)
					{
						if (!userCollectionItem.owned)
							gameManager.collectionsData.newCollectionItems.push(userCollectionItem);
						
						userCollectionItem.owned = true;
						userCollectionItem.duplicates += 1;
						
						gameManager.collectionsData.collectionDropItems.push(userCollectionItem);
					}
				}
			}
			
			new UpdateLobbyBarsTrueValue().execute();
			Game.connectionManager.sendPlayerUpdateMessage();
		}
	
		public function showClipDebug(baseAsset:MovieClipAsset, commonAsset:MovieClipAsset, linkage:String, cPivotX:int=0, cPivotY:int=0):void 
		{
			var quad:Quad = new Quad(100 * pxScale, 100 * pxScale, 0xFFFF00);
			quad.alpha = 0.5;
			quad.x = 100;
			quad.y = 100;
			Game.current.gameScreen.addChild(quad);
				
			var animation:AnimationContainer = new AnimationContainer(baseAsset, true, true);
			//animation.pivotX = 42 * pxScale;
			//animation.pivotY = 42 * pxScale;
			//animation.scale = 0.6;
			animation.x = 100;
			animation.y = 100;
			animation.play();
			Game.current.gameScreen.addChild(animation);
			
			quad.width = animation.width;
			quad.height = animation.height;
			
			animation = new AnimationContainer(commonAsset, false, true);
			animation.pivotX = cPivotX * pxScale;
			animation.pivotY = cPivotY * pxScale;
			//animation.scale = 0.6;
			animation.x = 100;
			animation.y = 100;
			animation.playTimeline(linkage, false, true);
			Game.current.gameScreen.addChild(animation);
			
			
			
			
			quad = new Quad(100 * pxScale, 100 * pxScale, 0x00FF00);
			quad.alpha = 0.5;
			quad.x = 600;
			quad.y = 100;
			Game.current.gameScreen.addChild(quad);
				
			animation = new AnimationContainer(baseAsset, true, true);
			//animation.pivotX = 42 * pxScale;
			//animation.pivotY = 42 * pxScale;
			animation.scale = 0.55;
			animation.x = 600;
			animation.y = 100;
			animation.play();
			Game.current.gameScreen.addChild(animation);
			
			quad.width = animation.width;
			quad.height = animation.height;
			
			animation = new AnimationContainer(commonAsset, false, true);
			animation.pivotX = cPivotX * pxScale;
			animation.pivotY = cPivotY * pxScale;
			animation.scale = 0.55;
			animation.x = 600;
			animation.y = 100;
			animation.playTimeline(linkage, false, true);
			Game.current.gameScreen.addChild(animation);
			
			
			
			
			quad = new Quad(100 * pxScale, 100 * pxScale, 0x00FF00);
			quad.alpha = 0.5;
			quad.x = 600;
			quad.y = 400;
			quad.pivotX = 42 * pxScale;
			quad.pivotY = 42 * pxScale;
			Game.current.gameScreen.addChild(quad);
				
			animation = new AnimationContainer(baseAsset, true, true);
			animation.pivotX = 42 * pxScale;
			animation.pivotY = 42 * pxScale;
			animation.scale = 0.55;
			animation.x = 600;
			animation.y = 400;
			animation.rotation = Math.PI / 4;
			animation.play();
			Game.current.gameScreen.addChild(animation);
			
			quad.width = animation.width;
			quad.height = animation.height;
			
			animation = new AnimationContainer(commonAsset, false, true);
			animation.pivotX = 42 * pxScale;
			animation.pivotY = 42 * pxScale;
			animation.scale = 0.55;
			animation.rotation = Math.PI / 4;
			animation.x = 600;
			animation.y = 400;
			animation.playTimeline(linkage, false, true);
			Game.current.gameScreen.addChild(animation);
			
			
			
			animation = new AnimationContainer(baseAsset, true, true);
			animation.scale = 1;
			animation.x = 100;
			animation.y = 400;
			animation.play();
			Game.current.gameScreen.addChild(animation);
		}
				
				
		
	/*var daubHintAnimation:AnimationContainer;
	   if (!daubHintAnimation) {
	   daubHintAnimation = new AnimationContainer(MovieClipAsset.ChestBronzeOpen, true);
	   //daubHintAnimation.dispatchOnCompleteTimeline = true;
	   addChild(daubHintAnimation);
	   daubHintAnimation.x = 0;
	   daubHintAnimation.y = 0;
	   daubHintAnimation.touchable = false;
	
	   daubHintAnimation.addClipEventListener("movieEvent", handler_movieEvent);
	   daubHintAnimation.addEventOnFrame(100, "movieEvent", false, ' 100 ');
	   daubHintAnimation.addEventOnFrame(200, "movieEvent", false, ' 200 ');
	   daubHintAnimation.addEventOnFrame(300, "movieEvent");
	   daubHintAnimation.addEventOnFrame(600, "movieEvent", false, ' 600 ');
	
	   //daubHintAnimation.addEventListener(Event.COMPLETE, handler_daubHintAnimationComplete);
	   daubHintAnimation.play();
	   }*/
	
	}

}