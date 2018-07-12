package com.alisacasino.bingo.screens
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.Fonts;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.commands.player.UpdateLobbyBarsTrueValue;
	import com.alisacasino.bingo.controls.AnimatedProgressBar;
	import com.alisacasino.bingo.controls.AnimatedResultsView;
	import com.alisacasino.bingo.controls.ChestAwardView;
	import com.alisacasino.bingo.controls.CoinsBar;
	import com.alisacasino.bingo.controls.EnergyBar;
	import com.alisacasino.bingo.controls.PlayerValueView;
	import com.alisacasino.bingo.controls.ScoreBar;
	import com.alisacasino.bingo.controls.StarTitle;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XImage;
	import com.alisacasino.bingo.controls.XPAnimatedProgressBar;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.controls.XpBar;
	import com.alisacasino.bingo.dialogs.cardBuy.BuyCardsView;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.chests.ChestData;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.LiveEventScoreUpdateOkMessage;
	import com.alisacasino.bingo.protocol.RoundOverMessage;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.screens.resultsUIClasses.LeaderboardListView;
	import com.alisacasino.bingo.utils.ConnectionManager;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.layoutHelperClasses.LayoutHelper;
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.ProgressBar;
	import feathers.core.FeathersControl;
	import feathers.utils.touch.TapToTrigger;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.utils.setInterval;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextFormat;
	import starling.utils.Align;
	
	
	public class ResultsUI extends FeathersControl
	{
		static public const STATE_RESULTS:String = "STATE_RESULTS";
		static public const STATE_LEADERBOARD:String = "STATE_LEADERBOARD";
		static public const STATE_TO_LOBBY:String = "STATE_TO_LOBBY";
		
		public static var DEBUG_MODE:Boolean = false;
		
		private var BACKGROUND_WIDTH:uint = 646;
		
		private var _state:String;
		
		private var isHiding:Boolean;
		
		private var gameScreen:GameScreen;
		private var removeCallback:Function;
		private var showLobbyUICallback:Function;
		private var hideGameUICallback:Function;
		private var roundOverMessage:RoundOverMessage;
	
		private var noEmptyChestSlot:Boolean;
		
		private var fadeScreen:Quad;
		private var background:Image;
		private var container:Sprite;
		
		private var resultsStarTitle:StarTitle;
		private var resultsPointsView:AnimatedResultsView;
		public var resultsRankView:AnimatedResultsView;
		private var experienceProgressBar:XPAnimatedProgressBar;
		
		private var rewardsStarTitle:StarTitle;
		private var rewardsBg:Quad;
		private var cashPlayerValueView:PlayerValueView;
		private var energyPlayerValueView:PlayerValueView;
		private var bingosTitle:XTextField;
		private var chestAwardView:ChestAwardView;
			
		private var leaderboardStarTitle:StarTitle;
		private var nextButton:XButton;
		private var skipButton:XButton;
		
		private var whiteEffectBg:Image;
		
		private var hasBingosInRound:Boolean;
		private var leaderboardContent:LeaderboardListView;
		private var scoreUpdateOKMessage:LiveEventScoreUpdateOkMessage;
		
		private var levelTitleStarsShineId:int;
		private var newLevelBlurStrike:Image;
		
		private var showRewardsViews:Boolean = true;
		
		private var xpEarned:int;
		private var levelRewards:Array;
		
		public function ResultsUI(gameScreen:GameScreen, roundOverMessage:RoundOverMessage, scoreUpdateOKMessage:LiveEventScoreUpdateOkMessage, xpEarned:int, levelRewards:Array, hideGameUICallback:Function, showLobbyUICallback:Function, removeCallback:Function)
		{
			this.levelRewards = levelRewards;
			this.gameScreen = gameScreen;
			this.roundOverMessage = roundOverMessage;
			this.scoreUpdateOKMessage = scoreUpdateOKMessage;
			this.xpEarned = xpEarned;
			this.hideGameUICallback = hideGameUICallback;
			this.showLobbyUICallback = showLobbyUICallback;
			this.removeCallback = removeCallback;
			
			hasBingosInRound = Player.current.bingosInARound > 0;
			
			if (roundOverMessage) 
			{
				if (roundOverMessage.hasChestWin) {
					
					noEmptyChestSlot = !gameManager.chestsData.parseAwardChest(roundOverMessage.chestWin);
					
					// запоминаем выданные сундуки сразу. 
					gameManager.chestsData.sendDataToServer();
				}
			}
			
			if (!gameManager.tutorialManager.isRoundResultsUIStepPassed) {
				if (roundOverMessage && roundOverMessage.hasChestWin) {
					noEmptyChestSlot = !gameManager.tutorialManager.createNewChest();
					gameManager.chestsData.sendDataToServer();
				}
			}
			
			if (DEBUG_MODE) 
			{
				if (Player.current.bingosInARound > 0)
				{
					if (gameManager.chestsData.emptySlotsCount > 0) {
						gameManager.chestsData.debugCreateNewAwardChests(1 + Math.round(Math.random() * 3));
						noEmptyChestSlot = false;
					}
					else {
						noEmptyChestSlot = true;
					}
				}
				else {
					noEmptyChestSlot = false;
				}
				
				return;
			}
			
			if(!scoreUpdateOKMessage)
				Game.addEventListener(ConnectionManager.LIVE_EVENT_SCORE_UPDATE_OK_EVENT, liveEventScoreUpdateOkEventHandler);
		}
		
		private function liveEventScoreUpdateOkEventHandler(e:Event):void 
		{
			scoreUpdateOKMessage = e.data as LiveEventScoreUpdateOkMessage;
			if (leaderboardContent)
				leaderboardContent.setData(scoreUpdateOKMessage);
			
			if(resultsRankView)	
				resultsRankView.show(scoreUpdateOKMessage.currentPosition.liveEventRank, 1);	
				
			Game.removeEventListener(ConnectionManager.LIVE_EVENT_SCORE_UPDATE_OK_EVENT, liveEventScoreUpdateOkEventHandler);
		}
		
		public function get state():String 
		{
			return _state;
		}
		
		public function set state(value:String):void 
		{
			if (_state != value) {
				_state = value;
				invalidate(INVALIDATION_FLAG_STATE);
			}
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			fadeScreen = new Quad(100, 100, 0x000000);
			fadeScreen.alpha = 0;
			addChild(fadeScreen);
			
			background = new Image(AtlasAsset.LoadingAtlas.getTexture("dialogs/window_bg"));
			//background.scale9Grid = new Rectangle(30 * pxScale, 0, 140 * pxScale, 0);
			//background.scale9Grid = new Rectangle(40 * pxScale, 0, 120 * pxScale, 0);
			background.scale9Grid = ResizeUtils.getScaledRect(10, 1, 2, 2);
			background.pivotX = background.texture.frameWidth / 2 - background.pivotX;//background.texture.frameWidth / 2;
			background.scaleX = 0;
			addChild(background);
			
			container = new Sprite();
			addChild(container);
			
			// ROUND RESULTS BLOCK:
			resultsStarTitle = new StarTitle('ROUND RESULTS', XTextFieldStyle.ResultsBigWhiteTitle, 8, 0, -4, resize);
			resultsStarTitle.pivotY = resultsStarTitle.height / 2;
			resultsStarTitle.scaleY = 0;
			container.addChild(resultsStarTitle);
			
			resultsRankView = new AnimatedResultsView("RANK", "bars/rank", '#', jumpBg, -300*pxScale, -300*pxScale, false);
			container.addChild(resultsRankView);
			
			resultsPointsView = new AnimatedResultsView("SCORE", "bars/score", '', jumpBg, -300*pxScale, -300*pxScale);
			container.addChild(resultsPointsView);
			
			experienceProgressBar = new XPAnimatedProgressBar();
			container.addChild(experienceProgressBar);
			if (Constants.isDevFeaturesEnabled) {
				var tapToTrigger:TapToTrigger = new TapToTrigger(experienceProgressBar);
				experienceProgressBar.addEventListener(Event.TRIGGERED, handler_debugExperienceProgressBarTriggered);
			}
			
			
			// REWARDS BLOCK:
			if (showRewardsViews)
			{
				rewardsStarTitle = new StarTitle('REWARDS', XTextFieldStyle.ResultsBigYellowTitle, 8, 0, -3, resize);
				rewardsStarTitle.pivotY = rewardsStarTitle.height / 2;
				rewardsStarTitle.scaleY = 0;
				container.addChild(rewardsStarTitle);
				
				rewardsBg = new Quad(10, 235 * pxScale, 0xF6F6F6);
				rewardsBg.alpha = 0.1;
				rewardsBg.pivotY = rewardsBg.height / 2;
				//rewardsBg.scaleY = 0;
				container.addChild(rewardsBg);
				
				chestAwardView = new ChestAwardView(shakeGameScreenBackground);
				container.addChild(chestAwardView);
				
				cashPlayerValueView = new PlayerValueView('bars/medium/cash', -4, SoundAsset.RoundResultsCashPopup);
				container.addChild(cashPlayerValueView);
				
				energyPlayerValueView = new PlayerValueView('bars/medium/energy', 0, SoundAsset.RoundResultsLightningPopup);
				container.addChild(energyPlayerValueView);
				
				var bingosTitleText:String;
				
				if (Player.current.bingosInARound <= 0)
					bingosTitleText = 'NO BINGOS';
				else if(noEmptyChestSlot)
					bingosTitleText = 'NO SLOT';
				else
					bingosTitleText = Player.current.bingosInARound.toString() + (Player.current.bingosInARound == 1 ? ' BINGO' : " BINGOS");
					
				bingosTitle = new XTextField(200*pxScale, 30*pxScale, XTextFieldStyle.getChateaudeGarage(30), bingosTitleText);
				bingosTitle.alignPivot(Align.LEFT);
				bingosTitle.scaleY = 0;
				//bingosTitle.border = true;
				container.addChild(bingosTitle);
			}
			
			nextButton = new XButton(XButtonStyle.GreenButtonNext);
			nextButton.addEventListener(Event.TRIGGERED, handler_nextButtonClick);
			///nextButton.scale9Grid = new Rectangle(25 * pxScale, 0, 35 * pxScale, 0);
			nextButton.alignPivot();
			nextButton.text = 'NEXT';
			nextButton.scaleY = 0;
			container.addChild(nextButton);
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_SIZE)) {
				resize();
			}
			
			if (isInvalid(INVALIDATION_FLAG_STATE))
			{
				if (state == STATE_RESULTS)
				{
					tweensAppear();
				}
				else if (state == STATE_LEADERBOARD)
				{
					tweensToLeaderboard();
				}
				else if (state == STATE_TO_LOBBY)
				{
					tweensDisappear();
				}
			}
		}	
		
		public function tweensAppear():void
		{
			SoundManager.instance.playSfx(SoundAsset.RoundResultsPopup);
			
			Starling.juggler.tween(fadeScreen, 0.37, {transition:Transitions.LINEAR, alpha:0.45});
			
			Starling.juggler.delayCall(callHideGameUICallback, 0.58);
			
			var oldBackgroundWidth:Number = background.scaleX; 
			background.scaleX = 0;
			var tweenBg_0:Tween = new Tween(background, 0.21, Transitions.EASE_IN);
			var tweenBg_1:Tween = new Tween(background, /*0.42*/0.8, Transitions.EASE_OUT_BACK);
			
			//tweenBg_0.animate('width', gameManager.layoutHelper.stageWidth);
			tweenBg_0.delay = 0.37;
			tweenBg_0.animate('scaleX', gameManager.layoutHelper.stageWidth/background.texture.frameWidth);
			tweenBg_0.nextTween = tweenBg_1;
			
			//tweenWhite_1.animate('width', 640);
			tweenBg_1.animate('scaleX', oldBackgroundWidth);// (BACKGROUND_WIDTH / LayoutHelper.ORIGINAL_WIDTH * gameManager.layoutHelper.stageWidth) / background.texture.frameWidth);
			
			Starling.juggler.add(tweenBg_0);
			
			resultsStarTitle.scaleY = 0;
			Starling.juggler.tween(resultsStarTitle, 1, {transition:Transitions.EASE_OUT_ELASTIC, delay:1, scaleY:viewsScale});
			
			if (showRewardsViews)
			{
				if (Room.current.stakeData.multiplier > 1) {
					var scoreWithoutStakesMultiplier:int = Player.current.liveEventScoreEarned / Room.current.getPointsBonusForCurrentCards();
					resultsPointsView.show(scoreWithoutStakesMultiplier, 1.45, Player.current.liveEventScoreEarned, '+' + ((Room.current.getPointsBonusForCurrentCards() - 1)*100).toFixed(0) + '%');
				}
				else {
					resultsPointsView.show(Player.current.liveEventScoreEarned, 1.45);
				}
		
				if (DEBUG_MODE)
				{
					resultsRankView.show(Math.random()*300, 2.72);
				}
				else
				{
					if(scoreUpdateOKMessage) {
						resultsRankView.show(scoreUpdateOKMessage.currentPosition.liveEventRank, 2.72);
					}	
					else 
					{
						var currentRank:int;
						var oscillateAmplitude:int;
						if (gameManager.tournamentData.currentLiveEventRank == 0) {
							currentRank = 1;
							oscillateAmplitude = 200;
						}
						else {
							currentRank = gameManager.tournamentData.currentLiveEventRank;
							oscillateAmplitude = gameManager.tournamentData.currentLiveEventRank * 0.2;
						}
						resultsRankView.showOscillate(currentRank, oscillateAmplitude, 2.72);	
					}	
				}
				
				//experienceProgressBar.setValues(Math.random()*0.4, int(Math.random() * 100), int(Math.random() * 500));
				//experienceProgressBar.debugAnimateValues(true, isNewLevel);
				
				//Player.current.xpCount = gameManager.gameData.getXpCountForLevel(20) + 1;			
	
				var isNewLevel:Boolean;
				var currentLevel:int = gameManager.gameData.getLevelForXp(Player.current.xpCount);
				var currentRatio:Number = getRatioForXp(Player.current.xpCount);
				
				var previousLevel:int;
				var previousXp:int;
				var previousRatio:Number = 0;
				
				if (xpEarned > 0) {
					// тока тут может быть нью левел
					previousXp = Math.max(0, Player.current.xpCount - xpEarned);
					previousLevel = gameManager.gameData.getLevelForXp(previousXp);
					previousRatio = getRatioForXp(previousXp);
					
					isNewLevel = currentLevel > previousLevel;
				}
				else {
					isNewLevel = false;
					previousXp = Player.current.xpCount;
					previousLevel = currentLevel;
					previousRatio = currentRatio;
				}
				
				//trace('xp eraneed', xpEarned, previousXp, Player.current.xpCount, '|', previousLevel, currentLevel, '|', previousRatio, currentRatio);
				
				if (DEBUG_MODE) {
					xpEarned = 50;
					previousXp = 10;
					previousLevel = 10;
					previousRatio = 0.2;
					currentRatio = 0.3;
					isNewLevel = Math.random() > 0.5;//true;
				}
				
				experienceProgressBar.setValues(previousRatio, currentLevel, xpEarned);
				experienceProgressBar.animateValues(/*isNewLevel ? 1 : */currentRatio, 3.5, isNewLevel);
				
				if (isNewLevel) {
					rewardsStarTitle.text = 'LEVEL UP!';
					SoundManager.instance.playSfx(SoundAsset.RoundResultsLevelUpJingle, 4.25);
					Starling.juggler.delayCall(SoundManager.instance.setSoundtrackVolume, 3.5, 0.1, 1000);
					Starling.juggler.delayCall(SoundManager.instance.setSoundtrackVolume, 8.5, SoundManager.BACKGROUND_VOLUME, 4000); 
				}
					
				rewardsStarTitle.scaleY = 0;
				Starling.juggler.tween(rewardsStarTitle, 1, {transition:Transitions.EASE_OUT_ELASTIC, delay:(isNewLevel ? 5.25 : 4.35), scaleY:viewsScale});
				//, onStart:SoundManager.instance.playSfx, onStartArgs:[SoundAsset.RoundResultsRewardsPopup]
				SoundManager.instance.playSfx(SoundAsset.RoundResultsRewardsPopup, isNewLevel ? 5.25 : 4.35);
				
				rewardsBg.scaleY = 0;
				rewardsBg.width = backgroundWidth - 2*9*pxScale;
				Starling.juggler.tween(rewardsBg, 1.1, {transition:Transitions.EASE_OUT_ELASTIC, delay:4.53, scaleY:viewsScale});
				
				cashPlayerValueView.show(Player.current.cashEarned, 4.82);
				energyPlayerValueView.show(Player.current.powerupsEarned, 5.08);
				
				bingosTitle.scaleY = 0;
				Starling.juggler.tween(bingosTitle, 0.6, {transition:Transitions.EASE_OUT_BACK, delay:5.86, scaleY:viewsScale/*, onStart:SoundManager.instance.playSfx, onStartArgs:[SoundAsset.RoundResultsBingosPopup]*/});
				
				chestAwardView.appear(6.24, viewsScale);
				
				var newChests:Vector.<ChestData> = gameManager.chestsData.newChests;
				if(newChests.length > 0) {
					chestAwardView.show(newChests[0].type, 1.8, 5, 6.24 + 2);
				}	
				else {
					chestAwardView.show(ChestType.NONE, 1.8, 5, 6.24, noEmptyChestSlot);
				}
				
				nextButton.scaleY = 0;
				Starling.juggler.tween(nextButton, 0.3, {transition:Transitions.EASE_OUT_BACK, delay:6, scaleY:viewsScale});
			}/*
			else
			{
				resultsPointsView.show(0, 1.1);
				resultsRankView.show(0, 1.3);
				
				experienceProgressBar.setValues(Math.random()*0.4, int(Math.random() * 100), 0);
				experienceProgressBar.debugAnimateValues(hasBingosInRound, isNewLevel);
				
				createLeaderboardViews(false);
				leaderboardContent.alpha = 0;
				Starling.juggler.tween(leaderboardContent, 0.4, {delay: 1.0, "alpha#": 1 });
				Starling.juggler.delayCall(leaderboardContent.animate, 1.9);
				
				Starling.juggler.tween(leaderboardStarTitle, 0.3, {transition:Transitions.EASE_OUT_BACK, scaleY:viewsScale, delay:1.7});
				
				nextButton.scaleY = 0;
				Starling.juggler.tween(nextButton, 0.3, {transition:Transitions.EASE_OUT_BACK, delay:2, scaleY:viewsScale});
			}*/
			
			if (isNewLevel)
				tweensNewLevel();
		}
		
		public function tweensToLeaderboard():void
		{
			SoundManager.instance.playSfx(SoundAsset.RoundResultsPopup);
			
			var _coefficientY:Number = coefficientY;
			
			createLeaderboardViews(true);

			skipButton = new XButton(XButtonStyle.TextSkipButton, "SKIP");
			skipButton.addEventListener(Event.TRIGGERED, handler_skipButtonClick);
			skipButton.scale = viewsScale;
			skipButton.alignPivot();
			skipButton.x =  background.width/2;
			skipButton.y = 968 * _coefficientY;
			container.addChild(skipButton);
			
			Starling.juggler.tween(container, 0.85, {transition:Transitions.EASE_OUT_BACK, y:(-300 * _coefficientY), delay:0.15, onComplete:removeResultStateViews});
		
			Starling.juggler.tween(experienceProgressBar, 0.2, {transition:Transitions.EASE_IN, y:(experienceProgressBar.y - 30*coefficientY), delay:0.3});
			Starling.juggler.tween(leaderboardStarTitle, 0.3, {transition:Transitions.EASE_OUT_BACK, scaleY:viewsScale, delay:0.9});
			
			showWhiteBgEffect(nextButton.x, nextButton.y);
			EffectsManager.scaleJumpDisappear(nextButton, 0.2);
			
			//Starling.juggler.tween(skipButton, 0.07, { transition:Transitions.EASE_OUT, alpha:0, delay:3, onComplete:handler_skipButtonClick } );
			
			Starling.juggler.delayCall(leaderboardContent.animate, 0.85);
		}
		
		public function tweensDisappear():void
		{
			if (isHiding)
				return;	
				
			isHiding = true;
			
			Player.current.clearCards();
			Player.current.clearEarned();
			
			showWhiteBgEffect(nextButton.x, nextButton.y);
			EffectsManager.scaleJumpDisappear(nextButton, 0.2);
			
			if(chestAwardView)
				chestAwardView.hide(0.15);
			
			Starling.juggler.removeTweens(fadeScreen);
			Starling.juggler.tween(fadeScreen, 0.4, {transition:Transitions.LINEAR, delay:0.2, alpha:0});
			
			Starling.juggler.removeTweens(background);
			Starling.juggler.tween(background, 0.4, {transition:Transitions.EASE_IN_BACK, scaleX:0, delay:0.2, onComplete:callRemoveCallback});
			
			Starling.juggler.removeTweens(container);
			Starling.juggler.tween(container, 0.12, {transition:Transitions.LINEAR, delay:0.4, alpha:0});
			
			Starling.juggler.delayCall(callShowLobbyUI, 0.23);
			
			new UpdateLobbyBarsTrueValue(gameManager.chestsData.hasNewChests ? 1.8 : 0.6).execute();
		}
		
		private function createLeaderboardViews(callSkipButtonHide:Boolean):void
		{
			var _coefficientY:Number = coefficientY;
			var _backGroundWidth:Number = backgroundWidth;
			
			leaderboardStarTitle = new StarTitle('LEADERBOARD', XTextFieldStyle.getWalrus(48, 0x00F0FF), 8, 0, -4, resize);
			leaderboardStarTitle.alignPivot(Align.LEFT, Align.CENTER);
			leaderboardStarTitle.scaleX = viewsScale;
			leaderboardStarTitle.scaleY = 0;
			leaderboardStarTitle.y = /*(hasBingosInRound ? 653 : 340)*/653 * _coefficientY;
			leaderboardStarTitle.x = (_backGroundWidth - leaderboardStarTitle.width)/2;
			container.addChild(leaderboardStarTitle);
			
			leaderboardContent = new LeaderboardListView(jumpBg, callSkipButtonHide ? handler_skipButtonClick : null, 628 * pxScale, 231 * pxScale);
			container.addChild(leaderboardContent);
			alignLeaderBoard();
			leaderboardContent.setData(scoreUpdateOKMessage);
			
			if (DEBUG_MODE) 
			{
				if (debugLeaderBoardsParamsList[debugCurrentLeaderboardParamsIndex].length == 1) {
					(leaderboardContent[debugLeaderBoardsParamsList[debugCurrentLeaderboardParamsIndex]] as Function).apply(null, null);
					trace('index:', debugCurrentLeaderboardParamsIndex, 'params: ', debugLeaderBoardsParamsList[debugCurrentLeaderboardParamsIndex]);
				}
				else {
					leaderboardContent.createDebugData.apply(null, debugLeaderBoardsParamsList[debugCurrentLeaderboardParamsIndex]);
					trace('index:', debugCurrentLeaderboardParamsIndex, 'params: ', debugLeaderBoardsParamsList[debugCurrentLeaderboardParamsIndex]);
				}
				
				debugCurrentLeaderboardParamsIndex++;
			
				if (debugCurrentLeaderboardParamsIndex >= debugLeaderBoardsParamsList.length)
					debugCurrentLeaderboardParamsIndex = 0;
				
				//leaderboardContent.createDebugData(10, 10, 5000, 0);
			}
		}
		
		private function removeResultStateViews():void
		{
			if (!resultsStarTitle)
				return;
			
			resultsStarTitle.dispose();
			resultsStarTitle.removeFromParent();
			resultsStarTitle = null;
			
			resultsPointsView.removeFromParent();
			resultsPointsView = null;
			
			resultsRankView.removeFromParent();
			resultsRankView = null;
			
			experienceProgressBar.removeFromParent(); 
			experienceProgressBar = null;
			
		}
		
		private function callHideGameUICallback():void
		{
			if (hideGameUICallback != null)
				hideGameUICallback();
		}
		
		private function callShowLobbyUI():void
		{
			if (showLobbyUICallback != null)
				showLobbyUICallback();
		}
		
		private function callRemoveCallback():void
		{
			if (removeCallback != null)
				removeCallback();
		}
		
		private function removeView(displayObject:DisplayObject):void
		{
			displayObject.removeFromParent();
			//displayObject.dispose();
		}
		
		private function resize():void
		{
			var _coefficientY:Number = coefficientY;
			var _backGroundWidth:Number = backgroundWidth;
			
			fadeScreen.width = gameManager.layoutHelper.stageWidth;
			fadeScreen.height = gameManager.layoutHelper.stageHeight;
			
			//trace(gameManager.layoutHelper.realScreenHeight < LayoutHelper.ORIGINAL_HEIGHT ? '< 720' : '> 720');
			
			/*sosTrace('HAMSTER 1 ', Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight, SOSLog.DEBUG);
			sosTrace('HAMSTER 2 ', Starling.current.stage.stageWidth, Starling.current.stage.stageHeight, SOSLog.DEBUG);
			sosTrace('HAMSTER 3 ', gameManager.layoutHelper.realScreenWidth, gameManager.layoutHelper.realScreenHeight, SOSLog.DEBUG);
			sosTrace('HAMSTER 4 ', gameManager.layoutHelper.stageWidth, gameManager.layoutHelper.stageHeight, SOSLog.DEBUG);
			sosTrace('HAMSTER 5 ', Capabilities.screenDPI, Capabilities.screenResolutionX, Capabilities.screenResolutionY ,SOSLog.DEBUG);
			sosTrace('HAMSTER 6 ', gameManager.layoutHelper.realScreenHeight / Capabilities.screenDPI, gameManager.layoutHelper.realScreenWidth / Capabilities.screenDPI,SOSLog.DEBUG);
			*/
			
			background.width = _backGroundWidth;
			
			//sosTrace('HAMSTER 7 ', _backGroundWidth, SOSLog.DEBUG);
			
			background.x = gameManager.layoutHelper.stageWidth/2;
			background.height = gameManager.layoutHelper.stageHeight;
			
			container.x = (gameManager.layoutHelper.stageWidth - _backGroundWidth)/2;
			
			//var viewsScale:Number = Math.min(1, gameManager.layoutHelper.stageHeight / LayoutHelper.ORIGINAL_HEIGHT);
			//trace('>> ', coefficientY, backgroundWidth, viewsScale);
			if (rewardsBg) {
				rewardsStarTitle.scale = viewsScale;
				bingosTitle.scale = viewsScale;
				chestAwardView.scale = viewsScale;
				cashPlayerValueView.scale = viewsScale;
				energyPlayerValueView.scale = viewsScale;
			}
			
			nextButton.scale = viewsScale;
	
			if (resultsStarTitle) 
			{
				resultsStarTitle.scale = viewsScale; 
				resultsPointsView.scale = viewsScale;
				resultsRankView.scale = viewsScale;
				experienceProgressBar.scale = viewsScale;
				
				resultsStarTitle.pivotY = resultsStarTitle.height / 2;
				resultsStarTitle.y = 60*_coefficientY;
				resultsStarTitle.x = (_backGroundWidth - resultsStarTitle.width)/2;
				
				resultsPointsView.x = 110/BACKGROUND_WIDTH * _backGroundWidth;
				resultsPointsView.y = 150*_coefficientY;
				
				resultsRankView.x = 375/BACKGROUND_WIDTH * _backGroundWidth;
				resultsRankView.y = resultsPointsView.y;
				
				experienceProgressBar.x = (_backGroundWidth - experienceProgressBar.width)/2;
				experienceProgressBar.y = 219*_coefficientY;
			}
			
			if (rewardsBg) 
			{
				rewardsStarTitle.pivotY = rewardsStarTitle.height / 2;
				rewardsStarTitle.y = 340*_coefficientY;
				rewardsStarTitle.x = (_backGroundWidth - rewardsStarTitle.width)/2;
				
				rewardsBg.width = _backGroundWidth - 2*9*pxScale;
				rewardsBg.scaleY = viewsScale;
				//rewardsBg.pivotY = rewardsBg.height / 2;
				rewardsBg.x = (_backGroundWidth - rewardsBg.width) / 2;
				rewardsBg.y = 493*_coefficientY;
				
				cashPlayerValueView.x = 116 / BACKGROUND_WIDTH * _backGroundWidth;
				cashPlayerValueView.y = rewardsBg.y - rewardsBg.pivotY*viewsScale + 67*pxScale*viewsScale;
				
				energyPlayerValueView.x = cashPlayerValueView.x;
				energyPlayerValueView.y = cashPlayerValueView.y  + 102*pxScale*viewsScale;
				
				//bingosTitle.border = true;
				bingosTitle.alignPivot(Align.LEFT);
				bingosTitle.x = 381/BACKGROUND_WIDTH * _backGroundWidth;
				bingosTitle.y = rewardsBg.y - rewardsBg.pivotY*viewsScale + 47*pxScale*viewsScale;
				
				chestAwardView.x = 480/BACKGROUND_WIDTH * _backGroundWidth;
				chestAwardView.y = rewardsBg.y - rewardsBg.pivotY*viewsScale + 147*pxScale*viewsScale;
			}
			
			nextButton.x = _backGroundWidth/2;
			nextButton.alignPivot();
			
			if (state == STATE_RESULTS/* || !hasBingosInRound*/) 
			{
				container.y = 0; 
				nextButton.y = 667 * _coefficientY;
			}
			else 
			{
				container.y = -300 * _coefficientY;
				nextButton.y = 963 * _coefficientY;
			}
			
			alignLeaderBoard();
			
			if (leaderboardStarTitle) {
				leaderboardStarTitle.alignPivot(Align.LEFT, Align.CENTER);
				leaderboardStarTitle.scale = viewsScale;
				leaderboardStarTitle.y = /*(hasBingosInRound ? 653 : 340)*/653 * _coefficientY;
				leaderboardStarTitle.x = (_backGroundWidth - leaderboardStarTitle.width) / 2;
			}
			
			if (skipButton) {
				skipButton.scale = viewsScale;
				skipButton.x =  _backGroundWidth/2;
				skipButton.y = 968 * _coefficientY;
			}
		}
		
		private function alignLeaderBoard():void
		{
			if (leaderboardContent)
			{
				var _backGroundWidth:Number = backgroundWidth;
				leaderboardContent.setSize(628 * pxScale, 231 * pxScale);
				leaderboardContent.validate();
				leaderboardContent.scale = _backGroundWidth/(BACKGROUND_WIDTH*pxScale);
				leaderboardContent.x = (_backGroundWidth - leaderboardContent.width) / 2;
				leaderboardContent.y = /*(hasBingosInRound ? 804 : 493)*/804 * coefficientY - leaderboardContent.height/2;
			}
		}
		
		private function showWhiteBgEffect(posX:int, posY:int):void 
		{
			removeWhiteEffectBg();
			
			whiteEffectBg = new Image(AtlasAsset.CommonAtlas.getTexture("buy_cards/white_bg"));
			whiteEffectBg.scale9Grid = ResizeUtils.getScaledRect(20, 20, 2, 2);
			whiteEffectBg.width = 324*pxScale*viewsScale;
			whiteEffectBg.height = 102*pxScale*viewsScale;
			whiteEffectBg.alignPivot();
			whiteEffectBg.x = posX;
			whiteEffectBg.y = posY;
			whiteEffectBg.touchable = false;
			whiteEffectBg.alpha = 1;
			container.addChildAt(whiteEffectBg, 0);
			
			var tweenWhite_0:Tween = new Tween(whiteEffectBg, 0.07, Transitions.EASE_IN);
			var tweenWhite_1:Tween = new Tween(whiteEffectBg, 0.04, Transitions.EASE_IN_OUT);
			
			tweenWhite_0.animate('width', gameManager.layoutHelper.stageWidth * 0.7);
			tweenWhite_0.animate('alpha', 0.2);
			tweenWhite_0.animate('height', 102*pxScale*0.3*viewsScale);
			tweenWhite_0.nextTween = tweenWhite_1;
			
			tweenWhite_1.animate('alpha', 0);
			tweenWhite_1.animate('height', 0);
			tweenWhite_1.onComplete = removeWhiteEffectBg;
			
			Starling.juggler.add(tweenWhite_0);
		}
		
		private function tweensNewLevel():void 
		{
			var _coefficientY:Number = coefficientY;
			var coefficientX:Number = coefficientY;
			var _backGroundWidth:Number = backgroundWidth;
			//experienceProgressBar.x = (_backGroundWidth - experienceProgressBar.width)/2;
			//experienceProgressBar.y = 219*_coefficientY;
			
			var particleColoredStarsAndSquaresDelay:Number = 4.1;
			
			Starling.juggler.delayCall(EffectsManager.showParticleColoredStarsAndSquares, particleColoredStarsAndSquaresDelay + 0.3, container, viewsScale, 568/BACKGROUND_WIDTH * _backGroundWidth, 263* _coefficientY);
			Starling.juggler.delayCall(EffectsManager.showParticleColoredStarsAndSquares, particleColoredStarsAndSquaresDelay + 0.6, container, viewsScale, 111/BACKGROUND_WIDTH * _backGroundWidth, 265* _coefficientY);
			Starling.juggler.delayCall(EffectsManager.showParticleColoredStarsAndSquares, particleColoredStarsAndSquaresDelay + 1.2, container, viewsScale, 440 / BACKGROUND_WIDTH * _backGroundWidth, 337 * _coefficientY);
			Starling.juggler.delayCall(EffectsManager.showParticleColoredStarsAndSquares, particleColoredStarsAndSquaresDelay + 1.8, container, viewsScale, 234/BACKGROUND_WIDTH * _backGroundWidth, 326* _coefficientY);
		
			Starling.juggler.delayCall(showLevelTitleStarsShine, 6);
			//EffectsManager.showStarsShine(Game.current.currentScreen as GameScreen, new Rectangle(100,100, 300, 50), 10, 0.2, 0.8);
		
			newLevelBlurStrike = new Image(AtlasAsset.CommonAtlas.getTexture("effects/blur_strike"));
			newLevelBlurStrike.alignPivot();
			newLevelBlurStrike.scale = 0;
			newLevelBlurStrike.x = _backGroundWidth/2;
			newLevelBlurStrike.y = rewardsStarTitle ? rewardsStarTitle.y : leaderboardStarTitle.y;
			newLevelBlurStrike.blendMode = BlendMode.ADD;
			container.addChildAt(newLevelBlurStrike, container.getChildIndex(rewardsStarTitle || leaderboardStarTitle)-1);
			
			var tween_0:Tween = new Tween(newLevelBlurStrike, 0.2, Transitions.EASE_IN);
			var tween_1:Tween = new Tween(newLevelBlurStrike, 0.3, Transitions.EASE_OUT);
			
			tween_0.delay = 5.25;
			tween_0.animate('scaleX', viewsScale * 2.8);
			tween_0.animate('scaleY', viewsScale * 2.7);
			tween_0.nextTween = tween_1;
			
			tween_1.animate('scaleX', viewsScale * 4);
			tween_1.animate('scaleY', 0);
			tween_1.animate('alpha', 0.3);
			
			Starling.juggler.add(tween_0);
			
			var newLevelCash:int = 0;
			var newLevelPowerups:int = 0;
			
			if (levelRewards)
			{
				for each (var item:CommodityItemMessage in levelRewards) 
				{
					if (item.type == Type.CASH)
					{
						newLevelCash = item.quantity;
					}
					else if (item.type == Type.POWERUP)
					{
						newLevelPowerups = item.quantity;
					}
				}
			}
			
			
			//Player.current.cashEarned += newLevelCash;
			//Player.current.powerupsEarned += newLevelPowerups;
			
			if(cashPlayerValueView)
				cashPlayerValueView.showExtraValue(Player.current.cashEarned + newLevelCash, newLevelCash, 5.8 + 1.5, true);
			
			if(energyPlayerValueView)
				energyPlayerValueView.showExtraValue(Player.current.powerupsEarned + newLevelPowerups, newLevelPowerups, 6.0 + 1.5, true);
		}
		
		private function removeWhiteEffectBg():void
		{
			if (whiteEffectBg) {
				Starling.juggler.removeTweens(whiteEffectBg);
				whiteEffectBg.removeFromParent(true);
				whiteEffectBg = null;
			}
		}
		
		public function jumpBg(jumpLeaderboardTitle:Boolean = false):void
		{
			if (isHiding)
				return;	
			
			Starling.juggler.removeTweens(background);
			
			var tween_0:Tween = new Tween(background, 0.05, Transitions.EASE_OUT);
			var tween_1:Tween = new Tween(background, 0.3, Transitions.EASE_OUT_ELASTIC);
			
			tween_0.animate('scaleX', background.scaleX*1.03);
			tween_0.nextTween = tween_1;
			
			tween_1.animate('width', backgroundWidth);
			
			Starling.juggler.add(tween_0);
			
			shakeGameScreenBackground();
			
			if (jumpLeaderboardTitle && leaderboardStarTitle) 
			{
				var tweenLeaderboardTitle_0:Tween = new Tween(leaderboardStarTitle, 0.1, Transitions.EASE_IN);
				var tweenLeaderboardTitle_1:Tween = new Tween(leaderboardStarTitle, 0.25, Transitions.EASE_OUT_BACK);
				
				tweenLeaderboardTitle_0.delay = 0.05;
				tweenLeaderboardTitle_0.animate('y', leaderboardStarTitle.y - 15*pxScale);
				tweenLeaderboardTitle_0.nextTween = tweenLeaderboardTitle_1;
				
				tweenLeaderboardTitle_1.animate('y', leaderboardStarTitle.y);
				
				Starling.juggler.add(tweenLeaderboardTitle_0);
			}
		}
		
		private function shakeGameScreenBackground():void
		{
			gameScreen.shakeBackground(ResizeUtils.SHAKE_Y_ELASTIC);
		}
		
		private function handler_nextButtonClick(e:Event):void 
		{	
			if (state == STATE_RESULTS) 
			{
				//cashPlayerValueView.showExtraValue(int(Math.random() * 200), int(Math.random() * 200));
				//energyPlayerValueView.showExtraValue(int(Math.random() * 200), int(Math.random() * 200));
			
				chestAwardView.skipFinishEffect();
				
				state = gameManager.tournamentData.pendingTournamentChange ? STATE_TO_LOBBY : STATE_LEADERBOARD;
				validate();
			}
			else if (state == STATE_LEADERBOARD) {
				state = STATE_TO_LOBBY;
				validate();
			}
			
			if (levelTitleStarsShineId != 0)
				EffectsManager.cleanStarsShine(levelTitleStarsShineId);
				
			if (newLevelBlurStrike) {
				Starling.juggler.removeTweens(newLevelBlurStrike);
				newLevelBlurStrike = null;
			}
		}
		
		private function handler_skipButtonClick(event:Event = null):void 
		{
			Starling.juggler.tween(skipButton, 0.07, { transition:Transitions.EASE_OUT, alpha:0} );
			skipButton.touchable = false;
			
			nextButton.y = 963 * coefficientY;
			
			if (event) {
				leaderboardContent.skipAnimate();
				Starling.juggler.removeTweens(skipButton);
				Starling.juggler.tween(skipButton, 0.07, {transition:Transitions.EASE_OUT, alpha:0});
				EffectsManager.scaleJumpAppearElastic(nextButton, viewsScale, 0.7, 0.03);
			}
			else {
				EffectsManager.scaleJumpAppearElastic(nextButton, viewsScale, 0.7);
			}
		}
		
		private function showLevelTitleStarsShine():void
		{
			var _coefficientY:Number = coefficientY;
			var _backGroundWidth:Number = backgroundWidth;
			levelTitleStarsShineId = EffectsManager.showStarsShine(container, new Rectangle(142*pxScale/BACKGROUND_WIDTH * _backGroundWidth, 312*pxScale * _coefficientY, 343*pxScale*viewsScale, 56*pxScale*viewsScale), 10, 0.2, 0.8, viewsScale);
		}
		
		
		private function get coefficientY():Number {
			return gameManager.layoutHelper.stageHeight / LayoutHelper.ORIGINAL_HEIGHT;
		}
		
		private function get viewsScale():Number
		{
			return layoutHelper.independentScaleFromEtalonMin;
			//return Math.min(1, gameManager.layoutHelper.stageHeight / gameManager.layoutHelper.assetMode);
		}	
		
		private function get backgroundWidth():Number
		{
			var baseWidth:int = BACKGROUND_WIDTH * pxScale * layoutHelper.independentScaleFromEtalonMin;
			var maxScreenInchesSize:Number = layoutHelper.canvasLayoutMode ? 11 : 3.5;
			if (layoutHelper.canvasLayoutMode)
			{
				if (gameManager.layoutHelper.realScreenHeight < LayoutHelper.ORIGINAL_HEIGHT)
				{
					return Math.max(baseWidth, BACKGROUND_WIDTH * (gameManager.layoutHelper.realScreenWidth / LayoutHelper.ORIGINAL_WIDTH)*(gameManager.layoutHelper.screenRatio/LayoutHelper.ORIGINAL_RATIO));
				}
				else 
				{
					//trace('screen inches upper ', maxScreenInchesSize.toString(), ' ', (gameManager.layoutHelper.realScreenHeight / Capabilities.screenDPI) > maxScreenInchesSize);
					if ((gameManager.layoutHelper.realScreenHeight / Capabilities.screenDPI) > maxScreenInchesSize) 
						return Math.max(baseWidth, BACKGROUND_WIDTH * ( (Capabilities.screenDPI * maxScreenInchesSize) / LayoutHelper.ORIGINAL_HEIGHT));
					else
						return Math.max(baseWidth, BACKGROUND_WIDTH * ( gameManager.layoutHelper.realScreenHeight / LayoutHelper.ORIGINAL_HEIGHT));
				}
			}
			else
			{
				return Math.max(baseWidth, BACKGROUND_WIDTH * pxScale);
			}
		}
		
		private function getRatioForXp(xpValue:int):Number 
		{
			var currentLevel:int = gameManager.gameData.getLevelForXp(xpValue);
			if (currentLevel < gameManager.gameData.maxLevel) {
				var xpCountCurrentLevel:uint = gameManager.gameData.getXpCountForLevel(currentLevel);
				var xpCountNextLevel:uint = gameManager.gameData.getXpCountForLevel(currentLevel + 1);
				return (xpValue - xpCountCurrentLevel) / (xpCountNextLevel - xpCountCurrentLevel);
			}
			
			return 1;
		}	
		
		private function callback_starTitleUpdate():void 
		{
			if (rewardsStarTitle) {
				rewardsStarTitle.pivotY = rewardsStarTitle.height / 2;
				rewardsStarTitle.x = (backgroundWidth - rewardsStarTitle.width)/2;
			}
		}
		
		/*******************************************************************************************
		 * 
		 * DEBUG
		 * 
		 ******************************************************************************************/
		
		private function handler_debugExperienceProgressBarTriggered(event:Event):void {
			gameManager.xpModifier.showModifiers(experienceProgressBar);
		}
		 
		public static var debugCurrentLeaderboardParamsIndex:int;
		
		public static var debugLeaderBoardsParamsList:Array = 
		[
		//[360, 16, 200, 0],
		//[360, 16, 200, 0],
		
		/*[16, 0, 16, 0],
			[16, 0, 16, 0],
			
			[40, 0, 40, 0],
			[60, 16, 200, 0],
		
			[16, 16, 4, 0],
			[40, 40, 4, 0],
			[40, 40, 4, 0],
			[40, 40, 4, 0],*/
			
			/*[340, 0, 40, 0],
			[360, 16, 200, 0],	*/
		
			['createDebugOnePositionChangeDown3'],
			
			// спецслучай через одно место на первое:
			['createDebugTwoPositionChangeUp'],
			
			// спецслучаи место не меняется
			['createDebugNoChangePositionFirstPlace'],
			['createDebugNoChangePositionMiddlePlace'],
			['createDebugNoChangePositionLastPlace'],
			
			// спецслучаи с изменением на 1 место
			['createDebugOnePositionChangeUp'],
			['createDebugOnePositionChangeUp1'],
			['createDebugOnePositionChangeUp2'],
			['createDebugOnePositionChangeDown'],
			['createDebugOnePositionChangeDown1'],
			['createDebugOnePositionChangeDown2'],
				
			/*поднятие по ранку с возрастанием промежутка между старым и новым местом */
			[5, 0, 2, 0],
			//[5, 0, 3, 0],
			//[6, 0, 3, 0],
			[16, 0, 16, 0],
			[40, 0, 40, 0],
			
			//[60, 6, 200, 0],
			[60, 16, 200, 0],
			
			// поднятие по ранку на первое место
			[5, 0, 2, 0, true],
			[16, 0, 16, 0, true],
			[60, 6, 200, 0, true],
			
			// опускание по ранку с возрастанием промежутка между старым и новым местом 
			[5, 2, 0, 0],
			//6, 5, 0, 0
			[6, 6, 4, 0],
			[16, 16, 4, 0],
			[40, 40, 4, 0],
			[60, 60, 4, 0],
			[60, 360, 4, 0]
		]
		
	}
}