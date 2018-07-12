package com.alisacasino.bingo.dialogs.cardBuy
{
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.Fonts;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.commands.ShowNoMoneyPopup;
	import com.alisacasino.bingo.commands.dialogCommands.ShowNoConnectionDialog;
	import com.alisacasino.bingo.commands.dialogCommands.ShowStore;
	import com.alisacasino.bingo.components.AlertSignView;
	import com.alisacasino.bingo.components.effects.FlaresShineHelper;
	import com.alisacasino.bingo.controls.BingoTextFormat;
	import com.alisacasino.bingo.controls.Countdown;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.ServiceDialog;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.TutorialManager;
	import com.alisacasino.bingo.models.chests.ChestsData;
	import com.alisacasino.bingo.models.game.StakeData;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.screens.lobbyScreenClasses.ChestSlotView;
	import com.alisacasino.bingo.screens.lobbyScreenClasses.LobbyUI;
	import com.alisacasino.bingo.screens.miniGames.MiniGamesView;
	import com.alisacasino.bingo.screens.storeWindow.StoreScreen;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.JumpWithHintHelper;
	import com.alisacasino.bingo.utils.Settings;
	import com.alisacasino.bingo.utils.TimeService;
	import com.alisacasino.bingo.utils.UIUtils;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNACardBuyTransactonEvent;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAReconnectShownEvent;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAUIInteractionEvent;
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.setInterval;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.utils.Align;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class BuyCardsView extends FeathersControl
	{
		static public const STATE_INIT:String = "STATE_INIT";
		static public const STATE_LOBBY:String = "stateLobby";
		static public const STATE_BUY_CARDS:String = "stateBuyCards";
		static public const STATE_WAIT_FOR_ROUND:String = "stateWaitForRound";
		static public const STATE_MINI_GAMES:String = "STATE_MINI_GAMES";
		static public const STATE_TO_GAME:String = "STATE_TO_GAME";
		static public const STATE_AFTER_LOAD_TO_WAIT_FOR_ROUND:String = 'STATE_AFTER_LOAD_TO_WAIT_FOR_ROUND';
		//static public const STATE_PLAY_SCRATCH_CARD:String = "statePlayScratchCard";
		
		private const CARDS_COUNT:int = 4;
		private const CARDS_GAP_COEFFFICIENT:Number = 0.025;
		private const BACKGROUND_HEIGHT_COEFFFICIENT:Number = 1.512;
		
		private const playButtonShiftY:int = 42;
		
		//private var cardsGap:Number = 0;
		private var _state:String = STATE_INIT;
		private var _previousState:String; 
		private var skipResize:Boolean;
		
		private var background:Image;
		private var titleLabel:XTextField;
		private var gameScreen:GameScreen;
		private var playButton:Button;
		private var playButtonJumpHelper:JumpWithHintHelper;
		private var whiteEffectBg:Image;
		private var timerLabel:XTextField;
		private var bgContainer:Sprite;
		private var titleContainer:Sprite;
		
		private var miniGamesSwitchButton:Button;
		private var miniGamesView:MiniGamesView;
		private var minigamesFlares:FlaresShineHelper;
		
		private var buyCardsButtons:Vector.<BuyCardButton>;
		private var timer:Timer;
		
		private var cardsBackGroundY:Number;
		private var extraScale:Number = 1;
		private var useExtraScaleForCards:Boolean;
		
		private var cardsLobbyExtraScale:Number = 1;
		private var checkTimerAndTransferToMinigames:Boolean;
		private var stakeButton:StakeButton;
		private var stakeIndex:int;
		private var stakeButtonContainer:Sprite;
		private var bonusMinigamesIndicator:AlertSignView;
		
		public function BuyCardsView(gameScreen:GameScreen, startState:String)
		{
			this.gameScreen = gameScreen;
			_state = startState;
			setSizeInternal(gameManager.layoutHelper.stageWidth, gameManager.layoutHelper.stageHeight, true);
		}
		
		public function get state():String 
		{
			return _state;
		}
		
		public function set state(value:String):void 
		{
			//sosTrace( "BuyCardsPlate.set > state : " + value );
			if (_state != value)
			{
				_previousState = _state;
				
				_state = value;
				invalidate(INVALIDATION_FLAG_STATE);
			}
		}
		
		public function setStateWithoutValidation(value:String):void 
		{
			if (_state != value) {
				_previousState = _state;
				_state = value;
			}
		}
		
		public function invalidateResize(width:Number, height:Number, cardsBackGroundY:Number, extraScale:Number, useExtraScaleForCards:Boolean = false, cardsLobbyExtraScale:Number = 1):void
		{
			this.cardsBackGroundY = cardsBackGroundY;
			this.extraScale = extraScale;
			this.useExtraScaleForCards = useExtraScaleForCards;
			this.cardsLobbyExtraScale = cardsLobbyExtraScale;
			setSize(width, height);
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			bgContainer = new Sprite();
			addChild(bgContainer);
			
			background = new Image(AtlasAsset.CommonAtlas.getTexture("buy_cards/buy_cards_bg"));
			background.scale9Grid = new Rectangle(40 * pxScale, 0, 60 * pxScale, background.height);
			
			bgContainer.addChild(background);
			
			buyCardsButtons = new Vector.<BuyCardButton>();
			
			stakeIndex = gameManager.gameData.stakes.indexOf(Room.current.stakeData);
			
			var buyCardButton:BuyCardButton;
			for (var i:int = 0; i < CARDS_COUNT; i++) {
				buyCardButton = new BuyCardButton(i);
				buyCardButton.addEventListener(Event.TRIGGERED, buyCardsButtonClick);
				buyCardButton.y = -200 * pxScale;
				buyCardsButtons.push(buyCardButton);
				//addChildAt(buyCardButton, 0);
			}
			
			buyCardsButtons[1].setUnlockProperties(2, 10);
			buyCardsButtons[2].setUnlockProperties(3, 30);
			buyCardsButtons[3].setUnlockProperties(4, 60);
			
			addChildAt(buyCardsButtons[0], 0);
			addChildAt(buyCardsButtons[3], 0);
			addChildAt(buyCardsButtons[1], 0);
			addChildAt(buyCardsButtons[2], 0);
			
			addChildAt(bgContainer, 0);
			
			titleContainer = new Sprite();
			addChild(titleContainer);
			
			titleLabel = new XTextField(840 * pxScale, 50 * pxScale, XTextFieldStyle.BuyCardsTitle);
			//titleLabel.autoScale = true;
			titleLabel.text = 'CHOOSE THE NUMBER OF CARDS';
			titleLabel.touchable = false;
			titleContainer.addChild(titleLabel);
			
			stakeButtonContainer = new Sprite();
			bgContainer.addChild(stakeButtonContainer);
			stakeButton = new StakeButton();
			stakeButton.addEventListener(Event.TRIGGERED, stakeButton_triggeredHandler);
			stakeButtonContainer.addChild(stakeButton);
			
			playButton = new Button();//XButtonStyle.BuyCardsPlay, 'PLAY');
			//playButton.scaleWhenDown = 0.9;
			playButton.defaultSkin = getPlayButtonSkin();
			playButton.pivotX = playButton.defaultSkin.width / 2;
			playButton.pivotY = playButton.defaultSkin.height / 2;
			playButton.addEventListener(Event.TRIGGERED, playButton_triggeredHandler);
			addChild(playButton);
			playButtonJumpHelper = new JumpWithHintHelper(playButton, true, true);
			playButtonJumpHelper.setEnabled(false);
			
			//addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			timer = new Timer(100);
			timer.addEventListener(TimerEvent.TIMER, handler_timer);
			
			miniGamesSwitchButton = new Button();
			miniGamesSwitchButton.scaleWhenDown = 0.95;
			miniGamesSwitchButton.useHandCursor = true;
			miniGamesSwitchButton.defaultSkin = getButtonSkin(AtlasAsset.CommonAtlas.getTexture("buy_cards/button_mini_games"), 40, 30);
			miniGamesSwitchButton.addEventListener(Event.TRIGGERED, handler_miniGamesSwitchButton);
			bgContainer.addChild(miniGamesSwitchButton);
			
			bonusMinigamesIndicator = new AlertSignView("");
			bonusMinigamesIndicator.touchable = false;
			bgContainer.addChild(bonusMinigamesIndicator);
			
			if(Room.current)
				Room.current.addEventListener(Room.EVENT_ROUND_STATE_UPDATE, handler_roundStateUpdate);
			
			//titleLabel.text = "ROUND STARTS IN:";
			//setInterval(function():void {setTimerLabel(Math.random()>0.5 ? '38 BINGOS' : '30 SECONDS')}, 3000);
			//"ROUND STARTS IN:"; " BINGO" + (bingosLeft > 1 ? "S" : "" "WAIT...";
		}
		
		override protected function feathersControl_addedToStageHandler(event:Event):void 
		{
			super.feathersControl_addedToStageHandler(event);
			Room.current.addEventListener(Event.CHANGE, currentRoom_changeHandler);
		}
		
		private function currentRoom_changeHandler(e:Event):void 
		{
			if (gameManager.gameData.stakes.indexOf(Room.current.stakeData) != stakeIndex)
			{
				stakeIndex = gameManager.gameData.stakes.indexOf(Room.current.stakeData);
				setStakeToButtons();
			}
		}
		
		override protected function feathersControl_removedFromStageHandler(event:Event):void 
		{
			super.feathersControl_removedFromStageHandler(event);
			if(Room.current) {
				Room.current.removeEventListener(Event.CHANGE, currentRoom_changeHandler);
				Room.current.removeEventListener(Room.EVENT_ROUND_STATE_UPDATE, handler_roundStateUpdate);
			}	
		}
		
		private function stakeButton_triggeredHandler(e:Event):void 
		{
			stakeIndex++;
			if (stakeIndex >= gameManager.gameData.stakes.length)
				stakeIndex = 0;
				
			Room.current.stakeData = gameManager.gameData.stakes[stakeIndex];
			setStakeToButtons();
			
			var soundAsset:SoundAsset;
			switch(Room.current.stakeData.multiplier) {
				case 2: soundAsset = SoundAsset.CardsBoostX2; break;
				case 3: soundAsset = SoundAsset.CardsBoostX3; break;
				case 5: soundAsset = SoundAsset.CardsBoostX5; break;
			}
			
			if(soundAsset)
				SoundManager.instance.playSfx(soundAsset, 0.0);
		}
		
		private function setStakeToButtons():void 
		{
			for (var i:int = 0; i < 4; i++) 
			{
				Starling.juggler.delayCall(setStakeDataToButton, 0.16 * i, buyCardsButtons[i], Room.current.stakeData);
			}
		}
		
		private function setStakeDataToButton(button:BuyCardButton, stakeData:StakeData):void 
		{
			if (!button.isLockedByLevel)
			{
				button.stakeData = stakeData;
			}
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			var globalUIScale:Number = layoutHelper.independentScaleFromEtalonMin;
			var buyCardButton:BuyCardButton;
			var i:int;
			var buyCardButtonScale:Number = getCardsScale(width, useExtraScaleForCards);
			
			if (isInvalid(INVALIDATION_FLAG_SIZE))
			{
				for (i = 0; i < buyCardsButtons.length; i++) {
					buyCardsButtons[i].scale = buyCardButtonScale;
				}

				background.scale = 1;
				background.height = BuyCardButton.HEIGHT * pxScale * buyCardButtonScale * BACKGROUND_HEIGHT_COEFFFICIENT;
				background.width = 0.9859375 * width * extraScale;
				
				titleLabel.scale = globalUIScale;
				
				if(timerLabel)
					timerLabel.scale = globalUIScale * extraScale;
				
				background.x = (width - background.width) / 2 - 4 * pxScale;
			}
			
			var cardWidth:Number = buyCardsButtons[0].width;
			
			if (isInvalid(INVALIDATION_FLAG_STATE))
			{
				timer.stop();
				
				//trace('BuyCardsView state ', state, _previousState);
				
				if (state == STATE_INIT)
				{
					resize();
					
					playButton.x = width / 2;
					playButton.y = getCardsY(STATE_LOBBY, buyCardButtonScale * cardsLobbyExtraScale) + buyCardButtonScale * cardsLobbyExtraScale * playButtonShiftY * pxScale;
					playButton.scale = 0;
					
					//bgContainer.scaleX = 0;
					//bgContainer.alpha = 0;
					
					//titleContainer.alpha = 0
					
					tweenCardsAppear(1.1);
					
					tweenPlayButtonAppear(1.2);
					
					setStateWithoutValidation(STATE_LOBBY);
					
					skipResize = true;
				}
				else if (state == STATE_LOBBY)
				{
					rechildBuyCards(BuyCardButton.STATE_LOBBY, false);
					tweensBackToLobby();
				}
				else if (state == STATE_BUY_CARDS)
				{
					if (_previousState == STATE_INIT)
					{
						// появление после окна результатов:
						
						skipResize = true;
						
						prepareFromGameToBuyCards();
						Starling.juggler.delayCall(tweenFromGameToBuyCards, gameManager.chestsData.hasNewChests ? 1.2 : 0.2, BuyCardButton.STATE_BUY);
					}
					else if (_previousState == STATE_MINI_GAMES) 
					{
						// возврат из мини-игр:
						
						tweensReturnFromMiniGames();
					}
					else 
					{
						// переход из лобби:
						
						if (_previousState == STATE_WAIT_FOR_ROUND)
							rechildBuyCards(BuyCardButton.STATE_BUY, false);
					
						miniGamesSwitchButton.defaultSkin = getButtonSkin(AtlasAsset.CommonAtlas.getTexture("buy_cards/button_mini_games"), 40, 30);
						alignMiniGamesAndStakeSwitchButton();
							
						tweensToBuyCards();
						stakeButton.isEnabled = true;
					}
				}
				else if (state == STATE_WAIT_FOR_ROUND)
				{
					timer.start();
					handler_timer(null);
					if (_previousState == STATE_MINI_GAMES)
					{
						// возврат из мини-игр:
						tweensReturnFromMiniGames();
					}
					else
					{
						
					}
				}
				else if (state == STATE_MINI_GAMES)
				{
					tweensStateMiniGames();
					
					if (getSelectedIndex() == -1) {
						titleLabel.text = "TRY YOUR LUCK AND ";
						setTimerLabel("WIN BIG!");
					}
					else {
						timer.start();
						handler_timer(null);
					}
				}
				else if (state == STATE_TO_GAME)
				{
					tweensStateToGame();
				}
				else if (state == STATE_AFTER_LOAD_TO_WAIT_FOR_ROUND)
				{
					skipResize = true;
					
					prepareFromGameToBuyCards();
					
					var playerCardsCount:int = Player.current.cards.length;
					
					if (playerCardsCount > 0)
					{
						timer.start();
						handler_timer(null);
						
						for (i = 0; i < buyCardsButtons.length; i++) {
							buyCardButton = buyCardsButtons[i];
							buyCardButton.selected = buyCardButton.index == (playerCardsCount - 1);
							buyCardButton.state = BuyCardButton.STATE_BUY;
							buyCardButton.validate();
						}
						
						tweenFromGameToBuyCards(BuyCardButton.STATE_PRE_GAME);
						
						//checkTimerAndTransferToMinigames = true;
					}
					else
					{
						tweenFromGameToBuyCards(BuyCardButton.STATE_BUY);
					}
				}
				
			}
			
			if (isInvalid(INVALIDATION_FLAG_SIZE))
			{
				if (skipResize) {
					skipResize = false;
					return;
				}
				resize();
			}
		}
		
		private function tweensToBuyCards():void
		{
			SoundManager.instance.playSfx(SoundAsset.CardsRoll);
			
			var globalUIScale:Number = layoutHelper.independentScaleFromEtalonMin;
			var buyCardButtonScale:Number = getCardsScale(width, useExtraScaleForCards);
	
			var cardsY:int = getCardsY(STATE_BUY_CARDS, buyCardButtonScale);
			var cardsGap:Number = getCardsGap(width);
			var cardWidth:Number = BuyCardButton.WIDTH * pxScale * buyCardButtonScale;// buyCardsButtons[0].width;
			var startX:Number = getCardsStartX(cardWidth);
			
			var startCardsY:int = getCardsY(STATE_LOBBY, buyCardsButtons[0].scale);
			buyCardsButtons[1].y = startCardsY;
			buyCardsButtons[1].rotation = (23 * Math.PI) / 180;
			buyCardsButtons[2].y = startCardsY;
			buyCardsButtons[2].rotation = -(29 * Math.PI) / 180;
			Starling.juggler.tween(buyCardsButtons[1], 0.55, {transition:Transitions.EASE_OUT_BACK, alpha:1.0, onStart:setAlpha, onStartArgs:[buyCardsButtons[1], 1] , delay:0.35, rotation:0, x:getCardX(1, startX, cardWidth, cardsGap), y:cardsY, scale:buyCardButtonScale});
			Starling.juggler.tween(buyCardsButtons[2], 0.55, {transition:Transitions.EASE_OUT_BACK, alpha:1.0, onStart:setAlpha, onStartArgs:[buyCardsButtons[2], 1], delay:0.35, rotation:0, x:getCardX(2, startX, cardWidth, cardsGap), y:cardsY, scale:buyCardButtonScale});
			
			//Starling.juggler.tween(buyCardsButtons[0], 0.8, {transition:Transitions.EASE_OUT_BACK, alpha:1.0, delay:0.05, rotation:(-Math.PI*2), x:getCardX(0, startX, cardWidth, cardsGap), y:cardsY});
			//Starling.juggler.tween(buyCardsButtons[1], 0.5, {transition:Transitions.EASE_OUT_BACK, alpha:1.0, onStart:setAlpha, onStartArgs:[buyCardsButtons[1], 1] , delay:0.35, rotation:0, x:getCardX(1, startX, cardWidth, cardsGap), y:cardsY});
			//Starling.juggler.tween(buyCardsButtons[2], 0.5, {transition:Transitions.EASE_OUT_BACK, alpha:1.0, onStart:setAlpha, onStartArgs:[buyCardsButtons[2], 1], delay:0.35, rotation:0, x:getCardX(2, startX, cardWidth, cardsGap), y:cardsY});
			//Starling.juggler.tween(buyCardsButtons[3], 0.8, {transition:Transitions.EASE_OUT_BACK, alpha:1.0, delay:0.05, rotation:Math.PI*2, x:getCardX(3, startX, cardWidth, cardsGap), y:cardsY});
			
			var cardTween_0:Tween = new Tween(buyCardsButtons[0], 0.25, Transitions.EASE_OUT);
			var cardTween_1:Tween = new Tween(buyCardsButtons[0], 0.6, Transitions.EASE_OUT_BACK);
			cardTween_0.delay = 0.05;
			cardTween_0.animate('rotation', buyCardsButtons[0].rotation + (2 * Math.PI) / 180);
			cardTween_0.animate('x', buyCardsButtons[0].x + 15*globalUIScale*pxScale);
			cardTween_0.nextTween = cardTween_1;
			cardTween_1.animate('rotation', (-Math.PI*2));
			cardTween_1.animate('x', getCardX(0, startX, cardWidth, cardsGap));
			cardTween_1.animate('y', cardsY);
			cardTween_1.animate('scale', buyCardButtonScale);
			cardTween_1.onComplete = firstCardTweenComplete;
			Starling.juggler.add(cardTween_0);
			
			var cardTween_0_4:Tween = new Tween(buyCardsButtons[3], 0.25, Transitions.EASE_OUT);
			var cardTween_1_4:Tween = new Tween(buyCardsButtons[3], 0.6, Transitions.EASE_OUT_BACK);
			cardTween_0_4.delay = 0.05;
			cardTween_0_4.animate('rotation', buyCardsButtons[3].rotation - (1 * Math.PI) / 180);
			cardTween_0_4.animate('x', buyCardsButtons[3].x - 15*globalUIScale*pxScale);
			cardTween_0_4.nextTween = cardTween_1_4;
			cardTween_1_4.animate('rotation', Math.PI*2);
			cardTween_1_4.animate('x', getCardX(3, startX, cardWidth, cardsGap));
			cardTween_1_4.animate('y', cardsY);
			cardTween_1_4.animate('scale', buyCardButtonScale);
			Starling.juggler.add(cardTween_0_4);
			
			
			var buyCardButton:BuyCardButton;
			var i:int = 0;
			for (i = 0; i < buyCardsButtons.length; i++) {
				buyCardsButtons[i].state = BuyCardButton.STATE_BUY;
			}
			//bgContainer.alpha = 1;
			Starling.juggler.tween(bgContainer, 0.35, {transition:Transitions.EASE_OUT_BACK, scaleX:1, onStart:setAlpha, onStartArgs:[bgContainer as DisplayObject, 1], delay:0.35});
			
			whiteEffectBg = new Image(AtlasAsset.CommonAtlas.getTexture("buy_cards/white_bg"));
			whiteEffectBg.scale9Grid = ResizeUtils.getScaledRect(20,20,2,2);
			whiteEffectBg.alignPivot();
			whiteEffectBg.width = 324*pxScale*globalUIScale;
			whiteEffectBg.height = 102*pxScale*globalUIScale;
			whiteEffectBg.x = playButton.x;
			whiteEffectBg.y = playButton.y;
			whiteEffectBg.touchable = false;
			whiteEffectBg.alpha = 1;
			addChildAt(whiteEffectBg, 0);
			
			var tweenWhite_0:Tween = new Tween(whiteEffectBg, 0.07, Transitions.LINEAR);
			var tweenWhite_1:Tween = new Tween(whiteEffectBg, 0.18, Transitions.LINEAR);
			
			tweenWhite_0.animate('alpha', 0.95);
			tweenWhite_0.animate('width', 324*pxScale*globalUIScale);
			tweenWhite_0.animate('height', 102*pxScale*globalUIScale);
			tweenWhite_0.nextTween = tweenWhite_1;
			
			tweenWhite_1.animate('width', width * 0.8);
			tweenWhite_1.animate('alpha', 0);
			tweenWhite_1.animate('height', 0);
			tweenWhite_1.onComplete = removeWhiteEffectBg;
			
			Starling.juggler.add(tweenWhite_0);
		
			//trace('BuyCardsView: tweensToBuyCards');
			
			EffectsManager.removeJump(playButton);
			Starling.juggler.removeTweens(playButton);
			var playButtonScale:Number = buyCardButtonScale * cardsLobbyExtraScale;
			var tween_0:Tween = new Tween(playButton, 0.1, Transitions.EASE_IN_OUT);
			var tween_1:Tween = new Tween(playButton, 0.12, Transitions.EASE_IN_OUT);
			var tween_2:Tween = new Tween(playButton, 0.15, Transitions.EASE_IN_OUT);
			
			tween_0.animate('scaleX', 1.1*playButtonScale);
			tween_0.animate('scaleY', 0.85*playButtonScale);
			tween_0.nextTween = tween_1;
			
			tween_1.animate('scaleX', 0.5*playButtonScale);
			tween_1.animate('scaleY', 1.4*playButtonScale);
			tween_1.nextTween = tween_2;
			
			tween_2.animate('scaleX', 1*playButtonScale);
			tween_2.animate('scaleY', 0);
			
			Starling.juggler.add(tween_0);
			
			var titleTween_0:Tween = new Tween(titleContainer, 0.2, Transitions.EASE_OUT);
			var titleTween_1:Tween = new Tween(titleContainer, 0.1, Transitions.EASE_OUT);
			
			titleTween_0.delay = 0.45;
			titleTween_0.onStart = setAlpha;
			titleTween_0.onStartArgs = [titleContainer, 0.3];
			titleTween_0.animate('scaleX', 1.15);
			titleTween_0.animate('scaleY', 0.6);
			titleTween_0.animate('alpha', 1);
			titleTween_0.nextTween = titleTween_1;
			
			titleTween_1.animate('scaleX', 1);
			titleTween_1.animate('scaleY', 1);
			
			Starling.juggler.add(titleTween_0);
			
			titleLabel.text = 'CHOOSE THE NUMBER OF CARDS';
			setTimerLabel(null);
			alignTitleAndTimerLabel();
			
			handler_roundStateUpdate(null);
		}
		
		private function firstCardTweenComplete():void
		{
			if (TutorialManager.isFirstStartTutorEnabled) 
			{
				var alphaMaskShowDelay:Number = 1.0;
				
				Starling.juggler.delayCall(DialogsManager.closeAll, alphaMaskShowDelay + 0.01);
				
				showFirstStartTutorHandAndMask(alphaMaskShowDelay);
			}
		}
		
		private function showFirstStartTutorHandAndMask(delay:Number):void 
		{
			var widthUIBlock:Boolean = Settings.instance.firstStartTutorType == TutorialManager.FIRST_START_TUTOR_WIDTH_BLOCK;
			var buyCardButton:BuyCardButton = buyCardsButtons[0];
			
			var alphaMaskPositionRect:Rectangle = new Rectangle(buyCardButton.x - 0.5*pxScale*buyCardButton.scale, buyCardButton.y - 3*pxScale*buyCardButton.scale, buyCardButton.width + 20*pxScale/**buyCardButton.scale*/, buyCardButton.height + 23*pxScale/**buyCardButton.scale*/);
			
			if (gameManager.tutorialManager.hasAlphaMask)
				gameManager.tutorialManager.tweenAlphaMask(alphaMaskPositionRect.x, alphaMaskPositionRect.y, alphaMaskPositionRect.width, alphaMaskPositionRect.height, 0.02, 0, true);
			else
				gameManager.tutorialManager.showAlphaMask(Game.current.gameScreen, alphaMaskPositionRect.x, alphaMaskPositionRect.y, alphaMaskPositionRect.width, alphaMaskPositionRect.height, 870 * pxScale, 650 * pxScale, 0.4, delay, true, widthUIBlock);
			
			gameManager.tutorialManager.showHand(Game.current.gameScreen, buyCardButton.x - (buyCardButton.width / 2) + 20 * pxScale * buyCardButton.scale, buyCardButton.y, 1.0, 0/*, buyCardButton.scale, buyCardButton.scale*/);
			if(!widthUIBlock)
			{
				//EffectsManager.jump(buyCardButton, 1000, buyCardButton.scale, buyCardButton.scale*1.05, 0.15, 0.15, 1.8, 2, 2, 1.8, true);	
				gameManager.tutorialManager.hideAlphaMask(false, 0.2, 0.2, 3.5, 970 * pxScale, 650 * pxScale);
			}
		}
		
		private function tweensBackToLobby():void
		{
			var buyCardButtonScale:Number = getCardsScale(width) * cardsLobbyExtraScale;
			var startX_0:Number = getCardCollapsedStartX(0);
			var startX_1:Number = getCardCollapsedStartX(3);
			var rotation_0:Number = -(7 * Math.PI) / 180;
			var rotation_1:Number = (8 * Math.PI) / 180;
			var cardsY:int = getCardsY(STATE_LOBBY, buyCardButtonScale);
			
			EffectsManager.removeJump(buyCardsButtons[0]);	
			gameManager.tutorialManager.hideHand();
			
			Starling.juggler.tween(buyCardsButtons[0], 0.8, {transition:Transitions.EASE_IN_BACK, alpha:1, rotation:(rotation_0 + 2*Math.PI), x:startX_0, y:cardsY, scale:buyCardButtonScale});
			Starling.juggler.tween(buyCardsButtons[1], 0.8, {transition:Transitions.EASE_IN_BACK, alpha:0, rotation:rotation_0, x:startX_0, y:cardsY, scale:buyCardButtonScale});
			Starling.juggler.tween(buyCardsButtons[2], 0.8, {transition:Transitions.EASE_IN_BACK, alpha:0, rotation:rotation_1, x:startX_1, y:cardsY, scale:buyCardButtonScale});
			Starling.juggler.tween(buyCardsButtons[3], 0.8, {transition:Transitions.EASE_IN_BACK, alpha:1, rotation:(rotation_1 - 2*Math.PI), x:startX_1, y:cardsY, scale:buyCardButtonScale});
			
			var buyCardButton:BuyCardButton;
			var i:int = 0;
			for (i = 0; i < buyCardsButtons.length; i++) {
				buyCardsButtons[i].state = BuyCardButton.STATE_LOBBY;
			}
			
			Starling.juggler.tween(bgContainer, 0.7, {transition:Transitions.EASE_IN_BACK, scaleX:0.2, onComplete:setAlpha, onCompleteArgs:[bgContainer as DisplayObject, 0]});
			
			tweenPlayButtonAppear(0.4);
			
			var titleTween_0:Tween = new Tween(titleContainer, 0.3, Transitions.EASE_OUT);
			var titleTween_1:Tween = new Tween(titleContainer, 0.2, Transitions.EASE_OUT);
			
			//titleTween_0.delay = 0.3;
			titleTween_0.animate('scaleX', 1.6);
			titleTween_0.animate('scaleY', 0.6);
			titleTween_0.nextTween = titleTween_1;
			
			titleTween_1.animate('scaleX', 0.4);
			titleTween_1.animate('scaleY', 1);
			titleTween_1.animate('alpha', 0);
			
			Starling.juggler.add(titleTween_0);
			
			if (miniGamesView) {
				Starling.juggler.tween(miniGamesView, 0.4, {transition:Transitions.EASE_OUT_BACK, alpha:0, x:(miniGamesView.x + 440*pxScale)});
				miniGamesView.touchable = false;
			}
			
		}
		
		private function tweenFromGameToBuyCards(buyCardButtonState:String):void 
		{
			//SoundManager.instance.playSfx(SoundAsset.CardsRoll);
			
			var cardsDelay:Number = 0.1;
			var buyCardsFinishScale:Number = getCardsScale(width);
			var valueScale:Number = buyCardsFinishScale * pxScale;
			var cardsY:int = getCardsY(STATE_BUY_CARDS, buyCardsButtons[0].scale);
			var cardsGap:Number = getCardsGap(width);
			
			Starling.juggler.delayCall(setBuyCardButton, cardsDelay, 0, width/2 - 14 * valueScale, cardsY, (28 * Math.PI) / 180, 1);
			Starling.juggler.delayCall(setBuyCardButton, cardsDelay, 2, width/2 - 0 * valueScale, cardsY, (18 * Math.PI) / 180, 1);
			Starling.juggler.delayCall(setBuyCardButton, cardsDelay, 1, width/2 + 15 * valueScale, cardsY, -(11 * Math.PI) / 180, 1);
			Starling.juggler.delayCall(setBuyCardButton, cardsDelay, 3, width/2 + 13 * valueScale, cardsY, -(30 * Math.PI) / 180, 1);
			
			var cardWidth:Number = buyCardsButtons[0].width;
			var startX:Number = getCardsStartX(cardWidth);
			Starling.juggler.tween(buyCardsButtons[0], 0.6, {transition:Transitions.EASE_OUT_BACK, delay:cardsDelay, rotation:0, x:getCardX(0, startX, cardWidth, cardsGap), scale:buyCardsFinishScale, onComplete:firstCardTweenComplete});
			Starling.juggler.tween(buyCardsButtons[1], 0.6, {transition:Transitions.EASE_OUT_BACK, delay:cardsDelay, rotation:0, x:getCardX(1, startX, cardWidth, cardsGap), scale:buyCardsFinishScale});
			Starling.juggler.tween(buyCardsButtons[2], 0.6, {transition:Transitions.EASE_OUT_BACK, delay:cardsDelay, rotation:0, x:getCardX(2, startX, cardWidth, cardsGap), scale:buyCardsFinishScale});
			Starling.juggler.tween(buyCardsButtons[3], 0.6, {transition:Transitions.EASE_OUT_BACK, delay:cardsDelay, rotation:0, x:getCardX(3, startX, cardWidth, cardsGap), scale:buyCardsFinishScale});
			
			var buyCardButton:BuyCardButton;
			var i:int = 0;
			for (i = 0; i < buyCardsButtons.length; i++) {
				buyCardsButtons[i].state = buyCardButtonState;
				//buyCardsButtons[i].scale = 0.72*buyCardsFinishScale;
			}
			
			if (buyCardButtonState == BuyCardButton.STATE_BUY)
			{
				stakeButton.isEnabled = true;
			}
			else
			{
				stakeButton.isEnabled = false;
			}
			
			
			Starling.juggler.tween(bgContainer, 0.6, {transition:Transitions.EASE_OUT_BACK, scaleX:1, onStart:setAlpha, onStartArgs:[bgContainer as DisplayObject, 1], delay:0.0});
			
			var titleTween_0:Tween = new Tween(titleContainer, 0.3, Transitions.EASE_OUT);
			var titleTween_1:Tween = new Tween(titleContainer, 0.2, Transitions.EASE_OUT);
			
			titleTween_0.delay = 0.1;
			titleTween_0.onStart = setAlpha;
			titleTween_0.onStartArgs = [titleContainer, 0.3];
			titleTween_0.animate('scaleX', 1.15);
			titleTween_0.animate('scaleY', 0.6);
			titleTween_0.animate('alpha', 1);
			titleTween_0.nextTween = titleTween_1;
			
			titleTween_1.animate('scaleX', 1);
			titleTween_1.animate('scaleY', 1);
			
			Starling.juggler.add(titleTween_0);
		}
		
		private function tweensReturnFromMiniGames():void 
		{
			var cardsY:int = getCardsY(state, buyCardsButtons[0].scale);
			var startX:Number = getCardsStartX(buyCardsButtons[0].width);
			var buyCardsFinishScale:Number = getCardsScale(width);
			var cardsGap:Number = getCardsGap(width);
			
			var i:int;
			var buyCardButton:BuyCardButton;
			for (i = 0; i < buyCardsButtons.length; i++) {
				buyCardButton = buyCardsButtons[i];
				buyCardButton.y = cardsY;
				Starling.juggler.tween(buyCardButton, 0.2, {transition:Transitions.EASE_OUT_BACK, delay:i*0.05, rotation:0, alpha:1, x:getCardX(i, startX, buyCardsButtons[0].width, cardsGap), scale:buyCardsFinishScale});
			}
			
			miniGamesSwitchButton.defaultSkin = getButtonSkin(AtlasAsset.CommonAtlas.getTexture("buy_cards/button_mini_games"), 40, 30);
			alignMiniGamesAndStakeSwitchButton();
			
			if(miniGamesView) {
				Starling.juggler.removeTweens(miniGamesView);
				Starling.juggler.tween(miniGamesView, 0.4, {transition:Transitions.EASE_OUT_BACK, alpha:0, x:(miniGamesView.x + 440*pxScale)});
			}
			
			miniGamesView.touchable = false;
			
			if (state == STATE_BUY_CARDS) 
			{
				titleLabel.text = 'CHOOSE THE NUMBER OF CARDS';
				setTimerLabel(null);
				alignTitleAndTimerLabel();
				
				handler_roundStateUpdate(null);
			}
		}
		
		private function tweensStateMiniGames():void
		{
			var cardWidth:Number = buyCardsButtons[0].width;
			var cardsGap:Number = getCardsGap(width);
			
			var i:int;
			var buyCardButton:BuyCardButton;
			for (i = 0; i < buyCardsButtons.length; i++) {
				buyCardButton = buyCardsButtons[i];
				Starling.juggler.tween(buyCardButton, 0.2, {transition:Transitions.EASE_IN_BACK, alpha:0, delay:i*0.05, x:getCardX(0, getCardsStartX(cardWidth), cardWidth, cardsGap)});
			}
			
			miniGamesSwitchButton.defaultSkin = getButtonSkin(AtlasAsset.CommonAtlas.getTexture("buy_cards/button_back"), 40, 30);
			alignMiniGamesAndStakeSwitchButton();
			
			if (!miniGamesView) {
				miniGamesView = new MiniGamesView(this);
				miniGamesView.state = MiniGamesView.STATE_CHOOSE;
				miniGamesView.alpha = 0;
				miniGamesView.setSize(background.width, background.height - background.height * 0.228);
				miniGamesView.x = bgContainer.x - background.width/2 + 440*pxScale;
				miniGamesView.y = bgContainer.y + background.height * 0.228//90 * pxScale * outerScale;
				addChild(miniGamesView);
			}
			
			miniGamesView.touchable = true;
		
			Starling.juggler.tween(miniGamesView, 0.4, {transition:Transitions.EASE_OUT_BACK, delay:0.2, alpha:1, x:(bgContainer.x - background.width/2)});
		}
		
		private function tweensStateToGame():void 
		{
			var startX_0:Number = getCardCollapsedStartX(0);
			var startX_1:Number = getCardCollapsedStartX(1);
			var rotation_0:Number = -(7 * Math.PI) / 180;
			var rotation_1:Number = (8 * Math.PI) / 180;
			var cardsY:int = getCardsY(STATE_BUY_CARDS, buyCardsButtons[0].scale);
			
			Starling.juggler.tween(buyCardsButtons[0], 0.3, {transition:Transitions.EASE_IN_BACK, delay:0.1, rotation:(rotation_0 + 2*Math.PI), x:startX_0, onComplete:setAlpha, onCompleteArgs:[buyCardsButtons[0], 0]});
			Starling.juggler.tween(buyCardsButtons[1], 0.3, {transition:Transitions.EASE_IN_BACK, delay:0.1, rotation:rotation_0, x:startX_0, onComplete:setAlpha, onCompleteArgs:[buyCardsButtons[1], 0]});
			Starling.juggler.tween(buyCardsButtons[2], 0.3, {transition:Transitions.EASE_IN_BACK, delay:0.1, rotation:rotation_1, x:startX_1, onComplete:setAlpha, onCompleteArgs:[buyCardsButtons[2], 0]});
			Starling.juggler.tween(buyCardsButtons[3], 0.3, {transition:Transitions.EASE_IN_BACK, delay:0.1, rotation:(rotation_1 - 2*Math.PI), x:startX_1, onComplete:setAlpha, onCompleteArgs:[buyCardsButtons[3], 0]});
			
			Starling.juggler.tween(bgContainer, 0.3, {transition:Transitions.EASE_IN_BACK, scaleX:0.2, onComplete:setAlpha, onCompleteArgs:[bgContainer as DisplayObject, 0]});
			Starling.juggler.tween(titleContainer, 0.3, {transition:Transitions.EASE_IN_BACK, scaleX:0.2, onComplete:setAlpha, onCompleteArgs:[titleContainer, 0]});
			
			if (miniGamesView) {
				Starling.juggler.tween(miniGamesView, 0.3, {transition:Transitions.EASE_OUT_BACK, alpha:0, x:(miniGamesView.x + 440*pxScale)});
				miniGamesView.touchable = false;
			}
		}
		
		private function tweenCardsAppear(delay:Number):void
		{
			var buyCardButtonScale:Number = getCardsScale(width) * cardsLobbyExtraScale;
			var cardsY:int = getCardsY(STATE_LOBBY, buyCardButtonScale);
			var tweenDistanceX:int = 65 * pxScale;
			
			buyCardsButtons[0].scale = 0;
			buyCardsButtons[3].scale = 0;
			
			var cardX_0:Number = getCardCollapsedStartX(0);
			var cardX_3:Number = getCardCollapsedStartX(3);
			
			setBuyCardButton(0, cardX_0, cardsY, 0, 1);
			setBuyCardButton(3, cardX_3, cardsY, 0, 1);
			
			var cardTweenFinish_0:Tween = new Tween(buyCardsButtons[0], 0.3, Transitions.EASE_OUT_BACK);
			cardTweenFinish_0.animate('rotation', -(7 * Math.PI) / 180);
			cardTweenFinish_0.animate('scale', buyCardButtonScale);
			cardTweenFinish_0.animate('x', cardX_0);
			Starling.juggler.tween(buyCardsButtons[0], 0.3, {delay:delay, transition:Transitions.EASE_OUT, scale:buyCardButtonScale*1.35, x:(cardX_0 - tweenDistanceX), rotation:-(35 * Math.PI) / 180, nextTween:cardTweenFinish_0});
			
			var cardTweenFinish_3:Tween = new Tween(buyCardsButtons[3], 0.3, Transitions.EASE_OUT_BACK);
			cardTweenFinish_3.animate('rotation', (8 * Math.PI) / 180);
			cardTweenFinish_3.animate('scale', buyCardButtonScale);
			cardTweenFinish_3.animate('x', cardX_3);
			Starling.juggler.tween(buyCardsButtons[3], 0.3, {delay:delay, transition:Transitions.EASE_OUT, scale:buyCardButtonScale*1.35, x:(cardX_3 + tweenDistanceX), rotation:(35 * Math.PI) / 180, nextTween:cardTweenFinish_3});
		}
		
		private function tweenPlayButtonAppear(delay:Number):void
		{
			Starling.juggler.removeTweens(playButton);
			
			var playButtonScale:Number = getCardsScale(width) * cardsLobbyExtraScale;
			playButtonJumpHelper.scale = playButtonScale;
			
			//trace('BuyCardsView: tweensBackToLobby, tweenPlayButtonAppear');	
			var tween_0:Tween = new Tween(playButton, 0.2, Transitions.EASE_IN_OUT);
			var tween_1:Tween = new Tween(playButton, 0.2, Transitions.EASE_IN_OUT);
			var tween_2:Tween = new Tween(playButton, 0.4, Transitions.EASE_OUT_ELASTIC);
			
			tween_0.delay = delay;
			tween_0.animate('scaleX', 0.5*playButtonScale);
			tween_0.animate('scaleY', 1.3*playButtonScale);
			tween_0.nextTween = tween_1;
			
			tween_1.animate('scaleX', 1.3*playButtonScale);
			tween_1.animate('scaleY', 0.7*playButtonScale);
			tween_1.nextTween = tween_2;
			
			tween_2.animate('scaleX', 1*playButtonScale);
			tween_2.animate('scaleY', 1 * playButtonScale);
			tween_2.onComplete = completeTweenPlayButtonAppear;
			//tween_2.onCompleteArgs = [true];
			
			Starling.juggler.add(tween_0);
		}
		
		private function completeTweenPlayButtonAppear():void 
		{
			playButtonJumpHelper.setEnabled(true);
			
			if (TutorialManager.isFirstStartTutorEnabled) {
				EffectsManager.jump(playButton, 10000, playButtonJumpHelper.scale, playButtonJumpHelper.scale * 1.05, 0.15, 0.12, 1.2, 2, 1.2, 2.2, true);
			}
		}
		
		private function resize():void 
		{
			var i:int;
			var buyCardButton:BuyCardButton;
			
			var cardsBaseScale:Number = getCardsScale(width, useExtraScaleForCards); // скейл карт в режиме покупки карт. В лобби он домножен на cardsLobbyExtraScale
			var cardsLobbyScale:Number = cardsBaseScale * cardsLobbyExtraScale;
			var cardWidth:Number = BuyCardButton.WIDTH * pxScale * cardsBaseScale;
			var cardsGap:Number = getCardsGap(width);
			var _cardsStartX:Number = getCardsStartX(cardWidth);
			
			removeCardTweens();
			Starling.juggler.removeTweens(bgContainer);
			Starling.juggler.removeTweens(playButton);
			Starling.juggler.removeTweens(titleContainer);
			
			bgContainer.x = width/2;
			bgContainer.y = cardsBackGroundY;
			bgContainer.pivotX = width / 2;
			
			titleLabel.pivotY = (titleLabel.height/titleLabel.scale) / 2;
			
			titleContainer.y = bgContainer.y + background.height * 0.158;
			
			playButton.x = width / 2;
			playButton.y = getCardsY(STATE_LOBBY, cardsLobbyScale) + cardsLobbyScale * playButtonShiftY * pxScale;
	
			miniGamesSwitchButton.scale = backgroundScale;
			stakeButtonContainer.scale = backgroundScale;
			
			var cardsY:int = getCardsY(state, cardsBaseScale);
			
			if (state == STATE_LOBBY || state == STATE_INIT)
			{
				bgContainer.scaleX = 0.2;
				bgContainer.alpha = 0//0.5;
				
				titleContainer.x = width/2;
				titleContainer.scaleX = 0.5;
				titleContainer.scaleY = 0.4;
				titleContainer.alpha = 0.0;
				titleContainer.pivotX = width / 2;
				
				
				cardsY = getCardsY(state, cardsLobbyScale);
				
				setBuyCardButton(0, getCardCollapsedStartX(0), cardsY, -(7 * Math.PI) / 180, 1);
				setBuyCardButton(1, getCardCollapsedStartX(1), cardsY, -(7 * Math.PI) / 180, 0);
				setBuyCardButton(2, getCardCollapsedStartX(2), cardsY, (8 * Math.PI) / 180, 0);
				setBuyCardButton(3, getCardCollapsedStartX(3), cardsY, (8 * Math.PI) / 180, 1);
				
				for (i = 0; i < buyCardsButtons.length; i++) {
					buyCardsButtons[i].scale = cardsLobbyScale;
				}
				
				playButton.scale = cardsLobbyScale;
				playButtonJumpHelper.scale = playButton.scale;
				
				if (TutorialManager.isFirstStartTutorEnabled && EffectsManager.isJumping(playButton)) {
					EffectsManager.jump(playButton, 10000, playButtonJumpHelper.scale, playButtonJumpHelper.scale * 1.05, 0.15, 0.12, 1.2, 2, 1.2, 2.2, true);
				}
			}
			else if (state == STATE_BUY_CARDS)
			{
				cardWidth = BuyCardButton.WIDTH * pxScale * cardsBaseScale;
			
				for (i = 0; i < buyCardsButtons.length; i++) {
					setBuyCardButton(i, getCardX(i, _cardsStartX, cardWidth, cardsGap), cardsY, 0, 1);
				}
				
				bgContainer.scaleX = 1;
				bgContainer.alpha = 1;
				
				removeWhiteEffectBg();
				
				playButton.scale = 0;
				
				titleLabel.x = (width - titleLabel.width) / 2;
				
				titleContainer.scaleX = 1;
				titleContainer.alpha = 1;
				titleContainer.x = width/2;
				titleContainer.pivotX = width / 2;
				
				if (TutorialManager.isFirstStartTutorEnabled) {
					showFirstStartTutorHandAndMask(0);
				}
			}
			else if (state == STATE_WAIT_FOR_ROUND)
			{
				for (i = 0; i < buyCardsButtons.length; i++) {
					setBuyCardButton(i, getCardX(i, _cardsStartX, cardWidth, cardsGap), cardsY, 0, 1);
				}
			}
			else if (state == STATE_MINI_GAMES)
			{
				//playButton.y = getCardsY(STATE_LOBBY, cardBaseScale * cardsLobbyExtraScale) + cardBaseScale * cardsLobbyExtraScale * playButtonShiftY * pxScale;
			}
			
			if (miniGamesView) {
				miniGamesView.setSize(background.width, background.height - background.height * 0.228);
				miniGamesView.x = bgContainer.x - background.width/2;
				miniGamesView.y = bgContainer.y + background.height * 0.228;
			}	
			
			alignMiniGamesAndStakeSwitchButton();
			
			alignTitleAndTimerLabel(0);
		}
		
		private function prepareFromGameToBuyCards():void 
		{
			removeCardTweens();
			Starling.juggler.removeTweens(bgContainer);
			Starling.juggler.removeTweens(playButton);
			Starling.juggler.removeTweens(titleContainer);
			
			bgContainer.x = width/2;
			bgContainer.y = cardsBackGroundY;
			bgContainer.pivotX = width / 2;
			
			titleLabel.x = (width - titleLabel.width) / 2;
			titleLabel.pivotY = (titleLabel.height/titleLabel.scale) / 2;
			
			titleContainer.y = bgContainer.y + background.height * 0.158;
			
			playButton.x = width / 2;
			playButton.y = getCardsY(STATE_LOBBY, buyCardsButtons[0].scale) + getCardsScale(width, useExtraScaleForCards) * playButtonShiftY * pxScale;
			playButton.scale = 0;
			
			bgContainer.scaleX = 0;
			bgContainer.alpha = 0;
			
			titleContainer.x = width/2;
			titleContainer.scaleX = 0.5;
			titleContainer.scaleY = 0.4;
			titleContainer.alpha = 0;
			titleContainer.pivotX = width / 2;
			
			handler_roundStateUpdate(null);
			alignTitleAndTimerLabel();
			
			miniGamesSwitchButton.scale = backgroundScale;
			stakeButtonContainer.scale = backgroundScale;
			
			alignMiniGamesAndStakeSwitchButton();
			
			var buyCardButton:BuyCardButton;
			var i:int = 0;
			for (i = 0; i < buyCardsButtons.length; i++) {
				buyCardsButtons[i].alpha = 0;
			}
		}
		
		public function setAlpha(displayObject:DisplayObject, value:Number):void
		{
			displayObject.alpha = value;
		}
		
		private function rechildBuyCards(cardState:String = null, selected:Object = null):void
		{
			var length:int = buyCardsButtons.length;
			var buyCardButton:BuyCardButton;
			for (var i:int = 0; i < length; i++) {
				buyCardButton = buyCardsButtons[i];
				if (state)
					buyCardButton.state = cardState;
				if (selected != null)
					buyCardButton.selected = selected as Boolean;
				//addChildAt(buyCardButton, 1);
			}
		
			var startChildIndex:int = getChildIndex(bgContainer) + 1;
			addChildAt(buyCardsButtons[0], startChildIndex);
			addChildAt(buyCardsButtons[3], startChildIndex);
			addChildAt(buyCardsButtons[1], startChildIndex);
			addChildAt(buyCardsButtons[2], startChildIndex);
		}
		
		private function getCardsStartX(cardWidth:Number):Number {
			return (width - buyCardsButtons.length * cardWidth - (CARDS_COUNT -1) * getCardsGap(width))/2;
		}
		
		private function getCardsScale(containerWidth:Number, withExtraScale:Boolean = true):Number {
			var extraScale:Number = withExtraScale ? this.extraScale : 1;
			var sideGap:Number = 146 * pxScale;
			
			return (containerWidth * extraScale) / (BuyCardButton.WIDTH * pxScale * CARDS_COUNT + (CARDS_COUNT - 1) * getCardsGap(null) + 2 * sideGap);
		}
		
		private function getCardsGap(containerWidth:Number):Number {
			return 37 * pxScale;
		}
		
		private function getCardX(index:int, startX:Number, cardWidth:Number, gap:Number):Number 
		{
			return startX + index * (cardWidth + gap) + cardWidth/2;
		}
		
		private function getCardCollapsedStartX(cardIndex:int):Number {
			return width/2 + ((cardIndex == 0 || cardIndex == 1) ? -14 : 11) * pxScale * getCardsScale(width);
		}
		
		private function getCardsY(state:String, cardScale:Number):Number {
			//addChild(UIUtils.drawQuad('11111', 0, bgContainer.y, 400, background.height, 0.4, 0));
			if (state == STATE_INIT || state == STATE_LOBBY) 
				return layoutHelper.stageHeight * 16/30;
			else 
				return bgContainer.y + buyCardsButtons[0].pivotY * cardScale + background.height * 0.249;
		}
		
		private function removeWhiteEffectBg():void
		{
			if (whiteEffectBg) {
				Starling.juggler.removeTweens(whiteEffectBg);
				whiteEffectBg.removeFromParent(true);
				whiteEffectBg = null;
			}
		}
		
		private function setBuyCardButton(index:int, x:Number, y:Number, rotation:Number, alpha:Number):void 
		{
			var buyCardButton:BuyCardButton = buyCardsButtons[index];
			buyCardButton.x = x;
			buyCardButton.y = y;
			buyCardButton.rotation = rotation;
			buyCardButton.alpha = alpha;
		}
		
		private function playButton_triggeredHandler(e:Event):void 
		{
			playButtonJumpHelper.setEnabled(false);
			
			if (SoundManager.instance.soundLoadQueue)
				SoundManager.instance.soundLoadQueue.prioritizeCardBuySounds();
			
			gameManager.analyticsManager.sendDeltaDNAEvent(
				new DDNAUIInteractionEvent(
					DDNAUIInteractionEvent.ACTION_TRIGGERED,
					DDNAUIInteractionEvent.LOCATION_LOBBY,
					"playButton",
					DDNAUIInteractionEvent.TYPE_BUTTON));
			
			gameScreen.lobbyUI.state = LobbyUI.STATE_BUY_CARDS;
		}
		
		private function handler_miniGamesSwitchButton(e:Event):void 
		{
			if(state != STATE_MINI_GAMES)
				state = STATE_MINI_GAMES;
			else if (state == STATE_MINI_GAMES)
				state = getSelectedIndex() == -1 ? STATE_BUY_CARDS : STATE_WAIT_FOR_ROUND;
				
			validate();	
		}
		
		private function buyCardsButtonClick(e:Event):void
		{
			if (state == STATE_LOBBY) {
				playButton_triggeredHandler(null);
			}
			else if (state == STATE_BUY_CARDS) {
				buySelectedCard(int(e.data), e.currentTarget as DisplayObject);
			}
		}
		
		private function buySelectedCard(selectedIndex:int, selectedButton:DisplayObject):void
		{
			if (!Player.current) {
				new ShowNoConnectionDialog(DDNAReconnectShownEvent.OTHER, 'BuyCardsView.buySelectedCard no Player').execute();
				return;
			}
			
			if (getSelectedIndex() != -1 || selectedButton.alpha < 0.9)
				return;
			
			var cardsCount:int = selectedIndex + 1;
			var totalCost:int = gameManager.tournamentData.getCardCost(cardsCount);
			// cash check 
			if (Player.current.cashCount < totalCost) 
			{
				new ShowNoMoneyPopup(ShowNoMoneyPopup.YELLOW, titleContainer, new Point(titleContainer.pivotX, 100*pxScale)).execute();
				return;
			}
			
			Player.current.updateCashCount(-totalCost, "bingoCardsPurchase");
			Game.connectionManager.sendPlayerUpdateMessage();
			
			var buyCardButton:BuyCardButton;
			var i:int = 0;
			for (i = 0; i < buyCardsButtons.length; i++) {
				buyCardButton = buyCardsButtons[i];
				buyCardButton.selected = buyCardButton == selectedButton;
				buyCardButton.state = BuyCardButton.STATE_PRE_GAME;
			}
			
			stakeButton.isEnabled = false;
			
			checkTimerAndTransferToMinigames = true;
			//state = STATE_MINI_GAMES;
			//state = STATE_WAIT_FOR_ROUND;
			//return;
			
			gameManager.clientDataManager.setValue("preselectedCardIndex", selectedIndex);
			
			Starling.juggler.removeByID(TutorialManager.TUTORIAL_SHOW_FREE_OPEN_CHEST_DELAY_CALL_ID);
			
			gameManager.tutorialManager.hideHand();
			
			if (gameManager.tutorialManager.allTutorialLevelsPassed) 
			{
				Game.connectionManager.sendBuyCardsMessage(selectedIndex + 1, Room.current.stakeData.multiplier);
				gameScreen.needToDropScores = true;
			}
			else 
			{
				if (!gameManager.tutorialManager.tutorialFirstLevelPassed) 
				{
					Game.current.setGameTouchable(false);
					var fadeScale:Number = titleLabel.scale * pxScale;
					var point:Point = titleContainer.localToGlobal(new Point(titleLabel.x, titleLabel.y));
					var alphaMaskPositionRect:Rectangle = new Rectangle(layoutHelper.stageWidth / 2 - 63 * fadeScale, point.y, 570 * fadeScale, 89 * fadeScale);
					if (gameManager.tutorialManager.hasAlphaMask) {
						//gameManager.tutorialManager.tweenAlphaMask(alphaMaskPositionRect.x, alphaMaskPositionRect.y, alphaMaskPositionRect.width + 150, alphaMaskPositionRect.height + 60, 0.2, 0.02);
						gameManager.tutorialManager.tweenAlphaMask(alphaMaskPositionRect.x, alphaMaskPositionRect.y, alphaMaskPositionRect.width, alphaMaskPositionRect.height, 0.4, 0.02, true, Transitions.EASE_OUT);
					}
					else {
						gameManager.tutorialManager.showAlphaMask(Game.current.gameScreen, alphaMaskPositionRect.x, alphaMaskPositionRect.y, alphaMaskPositionRect.width, alphaMaskPositionRect.height, 870 * fadeScale, 150 * fadeScale, 0.4, 0)//0.8);
					}
						
					gameManager.tutorialManager.hideAlphaMask(false, 0.2, 0.2, 7.9, 870 * fadeScale, 150 * fadeScale);
					
					Starling.juggler.delayCall(Game.current.setGameTouchable, 8.5, true);
				}
				
				gameManager.tutorialManager.buyTutorialCard(cardsCount);
				
				gameManager.analyticsManager.sendDeltaDNAEvent(new DDNACardBuyTransactonEvent(totalCost, cardsCount, "tutorial" + String(Player.current.gamesCount + 1))); // Add 1 to match round over event
				
				gameManager.analyticsManager.sendTutorialEvent('buyCard_' + (Player.current.gamesCount + 1).toString(), selectedIndex + 1);
			}
		}
		
		private function getSelectedIndex():int
		{
			var buyCardButton:BuyCardButton;
			var i:int = 0;
			for (i = 0; i < buyCardsButtons.length; i++) {
				if (buyCardsButtons[i].selected)
					return i;
			}
			
			return -1;
		}
		
		private function removeCardTweens():void
		{
			var length:int = buyCardsButtons.length;
			var i:int = 0;
			for (i = 0; i < length; i++) {
				Starling.juggler.removeTweens(buyCardsButtons[i]);
			}
		}
		
		private function setTimerLabel(value:String):void
		{
			if (value) {
				if (!timerLabel) {
					timerLabel = new XTextField(400 * pxScale, 50 * pxScale, XTextFieldStyle.BuyCardsTimer, '12:12:12');
					timerLabel.touchable = false;
					titleContainer.addChild(timerLabel);
				}
				
				timerLabel.text = value;
				alignTitleAndTimerLabel();
			}
			else {
				if (timerLabel) {
					timerLabel.removeFromParent();
					timerLabel = null;
				}
			}
		}
		
		private function alignTitleAndTimerLabel(pixelThreshold:int = 20):void
		{
			if (gameManager.deactivated)
				return;
				
			if (!timerLabel) {
				titleLabel.x = (width - titleLabel.width) / 2;
				return;
			}
			
			timerLabel.scale = titleLabel.scale;
			timerLabel.y = titleLabel.y;
			timerLabel.pivotY = titleLabel.pivotY;
				
			var titleWidth:Number = (titleLabel.textBounds.width + 240*pxScale)*titleLabel.scale;
			titleLabel.x = (width - titleWidth) / 2 - titleLabel.textBounds.x * titleLabel.scale;
			
			var timerLabelNewX:Number = titleLabel.x + (titleLabel.textBounds.x + titleLabel.textBounds.width - timerLabel.textBounds.x + 3*pxScale) * titleLabel.scale;
			
			if(Math.abs(timerLabelNewX - timerLabel.x) > pixelThreshold*pxScale*timerLabel.scale)
				timerLabel.x = timerLabelNewX;
		}
		
		private function alignMiniGamesAndStakeSwitchButton():void 
		{
			miniGamesSwitchButton.validate();
			miniGamesSwitchButton.alignPivot();	
			
			miniGamesSwitchButton.y = background.height * 0.146;
			stakeButtonContainer.y = background.height * 0.074;
			
			if (state == STATE_MINI_GAMES) 
			{
				stakeButton.visible = false;
				miniGamesSwitchButton.x = background.x + (miniGamesSwitchButton.width)/2 - 3 * pxScale * background.scaleY;
			}
			else
			{
				stakeButton.visible = true;
				miniGamesSwitchButton.x = background.x + background.width - (miniGamesSwitchButton.width) / 2 + 4 * pxScale * background.scaleY;
				stakeButtonContainer.x = background.x + 30 * pxScale * background.scaleY;
			}
			
			miniGamesSwitchButton.visible = gameManager.tutorialManager.tutorialFirstLevelPassed && gameManager.tutorialManager.tutorialLevelsPassed && AtlasAsset.ScratchCardAtlas.loaded;//Player.current.gamesCount > 0;
			stakeButtonContainer.visible = miniGamesSwitchButton.visible;
			
			if (miniGamesSwitchButton.visible)
				gameManager.slotsModel.commitLoadResources();
			
			updateAndAlignFreeMinigamesIndicator();
		}
		
		private function updateAndAlignFreeMinigamesIndicator():void 
		{
			
			var totalBonusMinigames:int = gameManager.scratchCardModel.totalBonusScratches + gameManager.slotsModel.totalBonusSpins;
			if (gameManager.slotsModel.tutorSpinCount == 0 && totalBonusMinigames == 0 && miniGamesSwitchButton.visible) 
			{
				bonusMinigamesIndicator.text = '!';
				if (!minigamesFlares) {
					minigamesFlares = new FlaresShineHelper(bgContainer, AtlasAsset.ScratchCardAtlas.getTexture('slots/spark_yellow'), miniGamesSwitchButton.x, miniGamesSwitchButton.y, 0.7*bonusMinigamesIndicator.scale);
					minigamesFlares.setCoordinatesList([[67, 30], [29, 43], [10, 30], [38, 30], [13, 3], [67, 3]], -48/**pxScale*/*bonusMinigamesIndicator.scale, - 23/**pxScale*/*bonusMinigamesIndicator.scale, bonusMinigamesIndicator.scale);
					//minigamesFlares.play(100, 0.77);
				}
				
				if (state != STATE_MINI_GAMES)
					minigamesFlares.play(700, 0.77);
				else
					minigamesFlares.stop(true);
			}
			else {
				if (minigamesFlares) {
					minigamesFlares.stop(true);
					minigamesFlares = null;
				}
				bonusMinigamesIndicator.text = totalBonusMinigames.toString();
			}
			
			bonusMinigamesIndicator.visible = miniGamesSwitchButton.visible && state != STATE_MINI_GAMES && (totalBonusMinigames > 0 || gameManager.slotsModel.tutorSpinCount == 0);
			bonusMinigamesIndicator.scale = miniGamesSwitchButton.scale;
			
			bonusMinigamesIndicator.x = miniGamesSwitchButton.x - 59*pxScale*bonusMinigamesIndicator.scale;
			bonusMinigamesIndicator.y = miniGamesSwitchButton.y - 21*pxScale*bonusMinigamesIndicator.scale;
		}
		
		private function handler_timer(event:TimerEvent):void
		{
			//timerLabel.text = StringUtils.formatTime(timeout, "{1}:{2}:{3}", false, false, true);
			//trace('BCV.handler_timer', Room.current.estimatedRoundEnd, int((Room.current.roundStartTime - TimeService.serverTimeMs) / 1000), Room.current.bingosLeft);
			//sosTrace('BCV.handler_timer', Room.current.estimatedRoundEnd, int((Room.current.roundStartTime - TimeService.serverTimeMs) / 1000), Room.current.bingosLeft);
			
			if (!Room.current || isNaN(Room.current.estimatedRoundEnd))
				return;
			
			var tutorialLevelsPassed:Boolean = gameManager.tutorialManager.tutorialFirstLevelPassed && gameManager.tutorialManager.tutorialLevelsPassed;
			
			if (!tutorialLevelsPassed) 
				gameManager.chestsData.dispatchEventWith(ChestsData.EVENT_ACCELERATE_CHEST_TAKE_OUT_DIALOG);
			
			var roundStartTime:Number = tutorialLevelsPassed ? Room.current.roundStartTime : gameManager.tutorialManager.roundStartTime;
			var roundStartsIn:Number = Math.max(0, roundStartTime - TimeService.serverTimeMs);
			var bingosLeft:int = tutorialLevelsPassed ? Room.current.bingosLeft : gameManager.tutorialManager.bingosTimerCount;
			
			if (gameManager.deactivated)
				return;
			
			titleLabel.text = "ROUND STARTS IN:";
			
			if (roundStartTime != 0 || (Player.current && Player.current.isActivePlayer))
			{
				var minutesLeft:Number = int(roundStartsIn / 60 / 1000);
				var secondsLeft:Number = int((roundStartsIn / 1000) % 60);
				var secondsString:String = secondsLeft > 9 ? secondsLeft.toString() : "0" + secondsLeft.toString();
				setTimerLabel(minutesLeft.toString() + ":" + secondsString);
			}
			else if (bingosLeft > 0)
			{
				if (checkTimerAndTransferToMinigames && tutorialLevelsPassed)
				{
					if ((Player.current.cashCount >= gameManager.scratchCardModel.minimumCashCount)/* || (Player.current.gamesCount < (TutorialManager.TUTORIAL_GAMES_COUNT + 2))*/)
					{
						state = STATE_MINI_GAMES;
					}
				}
				setTimerLabel(bingosLeft + " BINGO" + (bingosLeft > 1 ? "S" : ""));
			}
			else 
			{
				setTimerLabel("WAIT...");
			}
			
			
			checkTimerAndTransferToMinigames = false;
		}	
		
		public function get backgroundScale():Number
		{
			return background.scaleY;
		}
		
		private function get playerActiveInGame():Boolean
		{
			return Player.current && Player.current.isActivePlayer;
		}
		
		public function getBackgroundHeight(containerWidth:Number, withExtraScale:Boolean):Number
		{
			//trace('>> getBackgroundHeight ', getCardsScale(containerWidth, withExtraScale));
			return BuyCardButton.HEIGHT * pxScale * getCardsScale(containerWidth, withExtraScale) * BACKGROUND_HEIGHT_COEFFFICIENT;
		}
	
		private function getButtonSkin(texture:Texture, gapHorisontal:uint = 10, gapVertical:uint = 10):Sprite 
		{
			var sprite:Sprite = new Sprite();
			var quad:Quad = new Quad(1,1, 0x00FF00);
			var image:Image = new Image(texture);
			//gapHorisontal=gapVertical =0
			sprite.addChild(quad);
			sprite.addChild(image);
			
			quad.alpha = 0.0;
			quad.width = image.width + 2 * gapHorisontal * pxScale;
			quad.height = image.height + 2 * gapVertical * pxScale;
			
			image.x = gapHorisontal * pxScale;
			image.y = gapVertical * pxScale;
			
			return sprite;
		}
		
		override public function dispose():void 
		{
			super.dispose();
		}
		
		private function getPlayButtonSkin():Sprite
		{
			var sprite:Sprite = new Sprite();
			
			var image:Image = new Image(AtlasAsset.CommonAtlas.getTexture("buy_cards/button_play"));
			image.scale9Grid = ResizeUtils.getScaledRect(22, 18, 1, 1);
			image.width = 324 * pxScale;
			image.height = 113 * pxScale;
			sprite.addChild(image);
			
			var textField:XTextField = new XTextField(image.width, image.height, XTextFieldStyle.PlayButton, 'PLAY');
			textField.pixelSnapping = false;
			textField.x = -2 * pxScale;
			textField.y = -2 * pxScale;
			sprite.addChild(textField);
			
			image = new Image(AtlasAsset.CommonAtlas.getTexture("icons/star"));
			image.scale = 0.416;
			image.rotation = -0.2618;
			image.x = 40 * pxScale;
			image.y = 41 * pxScale;
			sprite.addChild(image);
			
			image = new Image(AtlasAsset.CommonAtlas.getTexture("icons/star"));
			image.scale = 0.416;
			image.rotation = 0.2618;
			image.x = 254 * pxScale;
			image.y = 35 * pxScale;
			sprite.addChild(image);
			
			return sprite;
		}
		
		private function handler_roundStateUpdate(event:Event):void 
		{
			//trace('handler_roundStateUpdate STATE ', state, playerActiveInGame, timer.running, Room.current);
			//sosTrace('handler_roundStateUpdate STATE ', state, playerActiveInGame, timer.running, Room.current);
			
			if (state != STATE_BUY_CARDS || playerActiveInGame || timer.running || !Room.current || !gameManager.tutorialManager.tutorialLevelsPassed)
				return;
			
			if (Room.current.currentRoundBallsCount > 0)
			{
				titleLabel.text = 'ROUND IN PROGRESS: ';
				setTimerLabel(Room.current.currentRoundBallsCount.toString() + (Room.current.currentRoundBallsCount == 1 ?' BALL' : ' BALLS'));
			}
			else
			{
				titleLabel.text = 'CHOOSE THE NUMBER OF CARDS';
				setTimerLabel(null);
			}
			
			alignTitleAndTimerLabel();
			
		}
		
		
	}
}