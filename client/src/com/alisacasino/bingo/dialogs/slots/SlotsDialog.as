package com.alisacasino.bingo.dialogs.slots 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.Fonts;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.assets.loading.GAFClipWrapper;
	import com.alisacasino.bingo.commands.dialogCommands.ChestTakeOutCommand;
	import com.alisacasino.bingo.commands.player.ShowReservedDrops;
	import com.alisacasino.bingo.commands.player.UpdateLobbyBarsTrueValue;
	import com.alisacasino.bingo.components.effects.FlaresShineHelper;
	import com.alisacasino.bingo.components.effects.ParticleExplosion;
	import com.alisacasino.bingo.controls.BingoTextFormat;
	import com.alisacasino.bingo.controls.PlayerResourceBarView;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.chests.ChestPartsView;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.chests.ChestData;
	import com.alisacasino.bingo.models.chests.StoredChest;
	import com.alisacasino.bingo.models.powerups.Minigame;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.models.slots.SlotMachineRewardType;
	import com.alisacasino.bingo.models.slots.SlotMachineWinType;
	import com.alisacasino.bingo.models.slots.SlotsAnimationState;
	import com.alisacasino.bingo.models.slots.SlotMachineReward;
	import com.alisacasino.bingo.models.slots.SpinPattern;
	import com.alisacasino.bingo.models.slots.SpinType;
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.protocol.PowerupType;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.utils.ConnectionManager;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.JumpWithHintHelper;
	import com.alisacasino.bingo.utils.StringUtils;
	import com.alisacasino.bingo.utils.TimeService;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import starling.animation.Tween;
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.TweenHelper;
	
	import com.alisacasino.bingo.dialogs.IDialog;
	import com.alisacasino.bingo.models.slots.SlotsModel;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.utils.GAFUtils;
	
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import starling.utils.Align;

	import com.alisacasino.bingo.models.slots.SpinResult;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.UIConstructor;
	import com.catalystapps.gaf.display.GAFMovieClip;
	
	
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class SlotsDialog extends FeathersControl implements IDialog 
	{
		public static var WIDTH:uint = 1280;
		public static var HEIGHT:uint = 720;
		
		public static var DEBUG_MODE:Boolean = false;
		
		static public const STATE_IDLE:String = "stateIdle";
		static public const STATE_SPINNING:String = "stateSpinning";
		static public const STATE_WINNING:String = "stateWinning";
		
		private var machineState:String = STATE_IDLE;
		
		private var flaresHeightAmplitude:int = 275 * pxScale;
		
		private const CHESTS_CONTAINER_WIDTH:int = 140 * pxScale;
		
		private var model:SlotsModel;
		private var reels:Vector.<SlotMachineReel>;
		private var spinResult:SpinResult;
		private var isShowing:Boolean = true;
		private var isHiding:Boolean;
		
		private var betIndex:int;
		
		private var backgroundEffects:BackgroundEffects
		
		private var quad:Quad
		private var fadeQuad:Quad;
		private var reelsBg:Quad
		private var closeButton:Button;
		
		private var container:Sprite;
		private var controlsContainer:Sprite;
		private var reelContainer:Sprite;
		private var flaresContainer:Sprite;
		//private var chestsContainer:Sprite;
		//private var chestsByCountCache:Dictionary = new Dictionary();
		private var chestsCountByType:Object = {};
		private var chestsList:Vector.<ChestPartsView> = new <ChestPartsView> [];
		private var indicator:SlotMachineIndicator;
		private var animation:AnimationContainer;
		private var arrowLeft:Image;
		private var arrowRight:Image;
		private var gearImage:Image;
		private var betDisplay:BetDisplay;
		
		private var betButton:Button;
		private var spinButton:Button;
		private var infoButton:Button;
		
		//private var textField:TextField;
		
		private var roundStartHint:XTextField;
		
		private var spinButtonHelper:JumpWithHintHelper;
		private var betButtonHelper:JumpWithHintHelper;
		
		private var frameFlares:Vector.<Image>;
		
		private var _animationState:String;
		private var _animationType:String;
		private var animationStateQueue:Array = [];
		
		private var commitAnimationType:String;
		
		private var stopReelsDelayCallId:uint;
		
		private var freeSpinsImage:Image;
		private var debugControlsButtonQuad:Quad;
		
		private var callShowReservedDropsOnClose:Boolean;
		
		private var permanentSpinMode:Boolean;	
		
		private var spinButtonReleased:Boolean;	
		
		private var heavenFlaresShine:FlaresShineHelper;
		private var hellFlaresShine:FlaresShineHelper;
		
		//private var indicatorPerimeterFlaresShine:FlaresShineHelper;
		
		private var starsExplosion:ParticleExplosion;
		private var gearsExplosion:ParticleExplosion;
		
		private var reelSpinSounds:Vector.<SoundAsset> = new <SoundAsset>[];
		private var reelStopSounds:Vector.<SoundAsset> = new <SoundAsset>[];
		
		private var spinSoundAsset:SoundAsset;
		
		private var freeSpinDelayCallId:uint;
		private var freeSpinSoundAsset:SoundAsset;
		private var freeSpinsTotalItems:Object;
		
		private var animationFps:int = 60;
		
		private var stopReelsCalled:Boolean; 
		private var hasBonusSpinsAtStart:Boolean; 		
		
		private var speedSpinsCounter:int;
		private var spinButtonLastTouchTimeout:uint;
		private var spinButtonTouchCounter:uint;
		private var spinButtonMaxTouchCount:uint = 2;
		private var speedSpinModeEnabled:Boolean;
		private var spinButtonTouchCounterCleanId:uint;
		private var speedSpinModeTimer:Timer;
		private var blockSpinButtonTimestamp:int;
		
		private var timeToRoundStart:int = int.MAX_VALUE;
		
		public function SlotsDialog() 
		{
			super();
			model = GameManager.instance.slotsModel;
			freeSpinsTotalItems = {};
		}
		
		public function get fadeStrength():Number 
		{
			return 0.0;
		}
		
		public function get blockerFade():Boolean 
		{
			return true;
		}
		
		public function get fadeClosable():Boolean 
		{
			return false;
		}
		
		public function get align():String 
		{
			return Align.CENTER;
		}
		
		public function get selfScaled():Boolean 
		{
			return false;
		}
		
		public function get baseScale():Number
		{
			return layoutHelper.independentScaleFromEtalonMin;
		}
		
		override public function get width():Number {
			return WIDTH * pxScale * scale;
		}
		
		override public function get height():Number {
			return HEIGHT * pxScale * scale;
		}
		
		override public function set scale(value:Number):void 
		{
			super.scale = value;
			invalidate(INVALIDATION_FLAG_SIZE);
			
			speedSpinModeTimer = new Timer(420, 0);
			speedSpinModeTimer.addEventListener(TimerEvent.TIMER, handler_speedSpinModeTimer);
		}
		
		private function get overHeight():int
		{
			return (Math.max(0, gameManager.layoutHelper.stageHeight - height) / 2) / scale;
		}
		
		private function get overWidth():int
		{
			return (Math.max(0, gameManager.layoutHelper.stageWidth - width) / 2) / scale;
		}
		
		override protected function initialize():void 
		{
			super.initialize();
		
			if (SoundManager.instance.soundLoadQueue)
				SoundManager.instance.soundLoadQueue.prioritizeSlotMachine();
			
			fadeQuad = new Quad(1, 1, 0x0);
			addChild(fadeQuad);
			
			/*quad = new Quad(1, 1, 0xFF0000);
			addChild(quad);*/
			
			backgroundEffects = new BackgroundEffects();
			addChild(backgroundEffects);
			
			closeButton = UIConstructor.dialogCloseButton();
			closeButton.addEventListener(Event.TRIGGERED, handler_closeButton);
			addChild(closeButton);
			
			container = new Sprite();
			addChild(container);
			
			infoButton = new Button();
			infoButton.addEventListener(Event.TRIGGERED, handler_info);
			infoButton.defaultSkin = getInfoButtonContent(100 * pxScale);
			infoButton.validate();
			infoButton.alignPivot();
			infoButton.useHandCursor = true;
			container.addChild(infoButton);
			infoButton.x = 382*pxScale - 70*pxScale;
			infoButton.y = -106*pxScale;
			new JumpWithHintHelper(infoButton, true, true);
			
			gearImage = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/gear'));
			gearImage.alignPivot();
			container.addChild(gearImage);
			
			animation = new AnimationContainer(gameManager.slotsModel.animationAsset, false, true);
			animation.pivotX = 342 * pxScale;
			animation.pivotY = 255 * pxScale;
			animation.x = 27*pxScale;
			animation.y = 50*pxScale;
			container.addChild(animation);
			
			gearImage.x = animation.x + 330*pxScale;
			gearImage.y = animation.y;
			
			reelContainer = new Sprite();
			
			reelsBg = new Quad(1, 1, 0xE6E6E6);
			reelsBg.x = 53 * pxScale;
			reelsBg.y = 95 * pxScale;
			reelsBg.width = 572 * pxScale;
			reelsBg.height = 335 * pxScale;
			reelContainer.addChild(reelsBg);
			
			createReels();
			
			var clipRectQuad:Quad = new Quad(1, 1, 0xFF0000);
			clipRectQuad.x = reelsBg.x;
			clipRectQuad.y = reelsBg.y;
			clipRectQuad.width = reelsBg.width;
			clipRectQuad.height = reelsBg.height;
			reelContainer.mask = clipRectQuad;
			
			indicator = new SlotMachineIndicator();
			indicator.x = 59*pxScale;
			indicator.y = - 3*pxScale;
			
			
			flaresContainer = new Sprite();
			container.addChild(flaresContainer);
			
			frameFlares = new <Image>[];
			flaresContainer.x = animation.x  - animation.pivotX;
			flaresContainer.y = animation.y - animation.pivotY + 134*pxScale;
			flaresContainer.alpha = 0;
			
			createFrameFlare(54, 1);
			createFrameFlare(247, 0.35);
			createFrameFlare(433, 0.35);
			createFrameFlare(625, 1);
			
			
			arrowLeft = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/arrow'));
			arrowLeft.pivotX = 30 * pxScale;
			arrowLeft.pivotY = 29 * pxScale;
			arrowLeft.x = animation.x - 319*pxScale;
			arrowLeft.y = animation.y;
			arrowLeft.rotation = 0;
			container.addChild(arrowLeft);
			
			arrowRight = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/arrow'));
			arrowRight.pivotX = 30 * pxScale;
			arrowRight.pivotY = 29 * pxScale;
			arrowRight.scaleX = -1;
			arrowRight.x = animation.x + 319*pxScale;
			arrowRight.y = animation.y;
			arrowRight.rotation = 0;
			container.addChild(arrowRight);
			
			/*********** controls ***********/
			
			controlsContainer = new Sprite();
			container.addChild(controlsContainer);
			
			var buttonsBackgroundGap:int = 4 * pxScale;
			
			var bottomPanelBg:Image = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/bottom_panel_bg'));
			bottomPanelBg.scale9Grid = ResizeUtils.getScaledRect(32, 0, 1, 0);
			bottomPanelBg.width = 668*pxScale;
			//bottomPanelBg.height = ;
			controlsContainer.addChild(bottomPanelBg);
			
			var image:Image = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/black_square_bg'));
			image.scale9Grid = ResizeUtils.getScaledRect(12, 12, 1, 1);
			image.width = 87 * pxScale;
			image.height = 78 * pxScale;
			image.x = 21 * pxScale;
			image.y = (bottomPanelBg.height - image.height)/2;
			controlsContainer.addChild(image);
			
			var betButtonWidth:int = image.width - buttonsBackgroundGap * 2;
			var betButtonHeight:int = image.height - buttonsBackgroundGap * 2;
			
			betButton = new Button();
			betButton.addEventListener(Event.TRIGGERED, handler_betButton);
			//betButton.scaleWhenDown = 0.93;
			betButton.useHandCursor = true;
			betButton.defaultSkin = getBetButtonContent(betButtonWidth, betButtonHeight);
			betButton.pivotX = betButton.defaultSkin.width / 2;
			betButton.pivotY = betButton.defaultSkin.height / 2;
			betButton.validate();
			betButton.x = image.x + betButtonWidth/2 + buttonsBackgroundGap;
			betButton.y = image.y + betButtonHeight/2 + buttonsBackgroundGap;
			//controlsContainer.addChild(betButton);
			
			betButtonHelper = new JumpWithHintHelper(betButton, true, true);
			betButtonHelper.setStateCallbacks(callback_betButtonMouseDown, callback_betButtonMouseUp);
			betButtonHelper.minScale = 0.92;
			
			image = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/black_square_bg'));
			image.scale9Grid = ResizeUtils.getScaledRect(12, 12, 1, 1);
			image.width = 262 * pxScale;
			image.height = 78 * pxScale;
			image.x = bottomPanelBg.width - image.width - 21 * pxScale;
			image.y = (bottomPanelBg.height - image.height)/2;
			controlsContainer.addChild(image);
			
			spinButton = new Button();
			spinButton.addEventListener(Event.TRIGGERED, handler_spinButton);
			//betButton.scaleWhenDown = 0.93;
			spinButton.useHandCursor = true;
			spinButton.defaultSkin = getSpinButtonContent(image.width - buttonsBackgroundGap * 2, image.height - buttonsBackgroundGap * 2);
			spinButton.pivotX = spinButton.defaultSkin.width / 2;
			spinButton.pivotY = spinButton.defaultSkin.height/2;
			spinButton.validate();
			spinButton.x = image.x + spinButton.pivotX + buttonsBackgroundGap;
			spinButton.y = image.y + spinButton.pivotY + buttonsBackgroundGap;
			controlsContainer.addChild(spinButton);
			
			spinButtonHelper = new JumpWithHintHelper(spinButton, true, true);
			spinButtonHelper.setStateCallbacks(callback_spinButtonMouseDown, callback_spinButtonMouseUp);
			spinButtonHelper.minScaleX = 0.96;
			spinButtonHelper.minScaleY = 0.92;
			
			var betButtonX:int = betButton.x + betButtonWidth/2 + buttonsBackgroundGap;
			var gapBetPanelGap:int = 7 * pxScale;
			
			controlsContainer.pivotX = bottomPanelBg.width/2;
			controlsContainer.pivotY = bottomPanelBg.height / 2;
			controlsContainer.x = animation.x - 2*pxScale;
			controlsContainer.y = animation.y + controlsContainer.pivotY + 170*pxScale;
			
			betDisplay = new BetDisplay(spinButton.x - spinButton.pivotX - buttonsBackgroundGap - betButtonX - 2*gapBetPanelGap, 78 * pxScale);
			betDisplay.x = betButton.x + betButtonWidth/2 + buttonsBackgroundGap + gapBetPanelGap;
			betDisplay.y = (bottomPanelBg.height - image.height)/2;
			controlsContainer.addChild(betDisplay);
			controlsContainer.addChild(betButton);
			
			
			//playAnimation('hell_spin', -1, false);
			//_animationState = SlotsAnimationState.APPEAR;
			
			//playAnimation(_animationState + '_' + _animationType, 1);
			
			betIndex = Math.min(model.storedBetIndex, model.betList.length - 1);
			_animationType = betIndex % 2 == 0 ? SlotsAnimationState.HELL : SlotsAnimationState.HEAVEN;
			
			indicator.defaultColor = _animationType == SlotsAnimationState.HELL ? SlotMachineIndicator.COLOR_RED : SlotMachineIndicator.COLOR_ANGEL_BLUE;
			
			//trace('start cat animationType', _animationType, betIndex, betIndex % 2);
			setAnimationState(SlotsAnimationState.APPEAR, _animationType);
			animation.goToAndStop(1);
			
			
			if (model.totalBonusSpins > 0) 
			{
				betDisplay.showIcon(false);
				betDisplay.drawText('FREE!', 0xFFFFFF, 62 * pxScale);
				indicator.showText("FREE SPINS: " + model.totalBonusSpins.toString(), SlotMachineIndicator.COLOR_BLUE_LIGHT, indicator.defaultTextSize, false, 0.35);
				disableBetButton();
				
				hasBonusSpinsAtStart = true;
			}
			else {
				betDisplayShowCurrentBet(false);
				indicator.showIdleMessage(true);
			}
			
			//setInterval(shakeReels, 3000);
			//addChild(backgroundEffects);
			//setTimeout(backgroundEffects.showHellEffect, 2000);
			//setTimeout(backgroundEffects.showHeavenEffect, 2000);
			
			//setTimeout(indicator.showWin, 4000);
			
			
			/*chestsContainer = new Sprite();
			chestsContainer.x = -510 * pxScale;
			chestsContainer.y = 260 * pxScale;
			chestsContainer.addEventListener(TouchEvent.TOUCH, handler_chestsContainerTouch);	
			container.addChild(chestsContainer);*/
			
			//refreshChestsContainer();
			
			if(DEBUG_MODE)
				debugShowDebugControls();
			
			/*setTimeout(function():void {
				animation.currentClip.fps = 180;
			}, 5000);*/
			
			heavenFlaresShine = new FlaresShineHelper(container, AtlasAsset.ScratchCardAtlas.getTexture('slots/spark_blue'), -animationWidth/2 + 24*pxScale, -animationHeight/2 + 48*pxScale);
			heavenFlaresShine.setCoordinatesList([[84, -114], [210, -61], [294, -94], [83, -55], [98, -55], [159, -115], [240, -61], [150, -53], [314, -54], [198, -97], [139, -59], [218, -55], [244, -98]], 28, 28);
			heavenFlaresShine.play(700, 0.77);
			//heavenFlaresShine.play(20, 0.57);
			
			hellFlaresShine = new FlaresShineHelper(container, AtlasAsset.ScratchCardAtlas.getTexture('slots/spark_yellow'), -animationWidth/2 + 24*pxScale, -animationHeight/2 + 48*pxScale);
			hellFlaresShine.setCoordinatesList([[378, -117], [527, -64], [380, -74], [459, -114], [544, -75], [420, -56]], 28, 28);
			hellFlaresShine.play(600, 0.77);
			//hellFlaresShine.play(20, 0.57);
			
			/*
			indicatorPerimeterFlaresShine = new FlaresShineHelper(indicator, AtlasAsset.ScratchCardAtlas.getTexture('slots/spark_yellow'), 0, 3, 0.5);
			var b_y:int = 80;
			indicatorPerimeterFlaresShine.setCoordinatesList(
			[
				[0, 0], [50, 0], [100, 0], [150, 0], [200, 0], [250, 0], [300, 0], [350, 0], [400, 0], [450, 0], [500, 0], [540, 0], [540, 45], 
				[540, b_y], [500, b_y], [450, b_y], [400, b_y], [350, b_y], [300, b_y], [250, b_y], [200, b_y], [150, b_y], [100, b_y], [50, b_y], [0, b_y], [0, b_y/2]
			], 0,0);*/
			//indicatorPerimeterFlaresShine.play(100, 0.77, false);
			
			
			starsExplosion = new ParticleExplosion(AtlasAsset.CommonAtlas, "icons/white_star", null, 20);
			starsExplosion.setProperties(0, 20*pxScale, 3, -0.02, 0.07, 0, 1);
			starsExplosion.setFineProperties(1.0, 1.0, 0.5, 1.2, 0.5, 2);
			starsExplosion.setEmitDirectionAngleProperties(1, Math.PI, Math.PI);
			starsExplosion.x = -animationWidth/2 - 15 * pxScale;
			starsExplosion.y = 40 * pxScale;
			container.addChildAt(starsExplosion, 0);
			//container.addChild(starsExplosion);
			starsExplosion.skewAplitude = 0.14;
			
			gearsExplosion = new ParticleExplosion(AtlasAsset.ScratchCardAtlas, "slots/gear", null, 20);
			gearsExplosion.setProperties(20, 40*pxScale, 5, -0.001, 0.04, 0, 1);
			gearsExplosion.setFineProperties(0.3, 0.4, 0.5, 1.2, 0.5, 2);
			gearsExplosion.setEmitDirectionAngleProperties(1, -30 * Math.PI / 180, 100 * Math.PI / 180);
			gearsExplosion.x = animationWidth/2 + 15 * pxScale;
			gearsExplosion.y = 40 * pxScale;
			gearsExplosion.gravityAcceleration = 0.23;
			gearsExplosion.setAccelerationProperties( -0.13);
			gearsExplosion.onlyPositiveSpeed = true;
			container.addChildAt(gearsExplosion, container.getChildIndex(infoButton) + 1);
			
			reelStopSounds = new <SoundAsset> [SoundAsset.SlotsReelStop_03, SoundAsset.SlotsReelStop_02, SoundAsset.SlotsReelStop_01];
			
			if (Player.current.hasCards) 
			{
				addEventListener(Event.ENTER_FRAME, handler_roundStartEnterFrame);
				Game.addEventListener(ConnectionManager.ROUND_STARTED_EVENT, handler_roundStarted);
				
				roundStartHint = new XTextField(740*pxScale, 40*pxScale, XTextFieldStyle.getMatrixComplex(31, 0xFFFFFF, Align.LEFT), "");
				//textField.pixelSnapping = false;
				roundStartHint.alignPivot();
				roundStartHint.isHtmlText = true;
				//roundStartHint.x = (width - roundStartHint.width)/2 + roundStartHint.pivotX;
				roundStartHint.y = height - roundStartHint.height + roundStartHint.pivotY + 10*pxScale;
				addChildAt(roundStartHint, getChildIndex(container));
				
				handler_roundStartEnterFrame(null);
			}
		}
		
		private function createFrameFlare(_x:int, _scaleX:Number):void
		{
			var image:Image = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/flare'));
			image.alignPivot();
			image.x = _x * pxScale;
			image.scaleX = _scaleX;
			//image.alpha = 0;
			frameFlares.push(image);
			flaresContainer.addChild(image);
		}
		
		private function createReels():void
		{
			reels = new Vector.<SlotMachineReel>();
			var reelsAtlas:AtlasAsset = AtlasAsset.ScratchCardAtlas;
			var reelTextures:Array = [
				[
					reelsAtlas.getTexture('slots/reel/arc_0'),
					reelsAtlas.getTexture('slots/reel/arc_1'),
					reelsAtlas.getTexture('slots/reel/arc_2'),
					reelsAtlas.getTexture('slots/reel/arc_3'),
					reelsAtlas.getTexture('slots/reel/arc_4'),
					reelsAtlas.getTexture('slots/reel/arc_5')
				],
				[
					reelsAtlas.getTexture('slots/reel/straight_0'),
					reelsAtlas.getTexture('slots/reel/straight_1'),
					reelsAtlas.getTexture('slots/reel/straight_2'),
					reelsAtlas.getTexture('slots/reel/straight_3'),
					reelsAtlas.getTexture('slots/reel/straight_4'),
					reelsAtlas.getTexture('slots/reel/straight_5')
				],
				[
					reelsAtlas.getTexture('slots/reel/arc_0'),
					reelsAtlas.getTexture('slots/reel/arc_1'),
					reelsAtlas.getTexture('slots/reel/arc_2'),
					reelsAtlas.getTexture('slots/reel/arc_3'),
					reelsAtlas.getTexture('slots/reel/arc_4'),
					reelsAtlas.getTexture('slots/reel/arc_5')
				]
			]
			
			var reelsWidth:Vector.<int> = new <int>[179, 187, 179];
			var lastX:Number = 6;
			for (var i:int = 0; i < reelTextures.length; i++) 
			{
				var reel:SlotMachineReel = new SlotMachineReel(i, reelTextures[i], reelsWidth[i]*pxScale, 335*pxScale, SlotMachineRewardType.FREE_SPINS);
				reel.x = reelsBg.x + lastX;
				reel.y = reelsBg.y;
				reel.rewards = gameManager.slotsModel.getRewardViews();
				reel.addEventListener(Event.COMPLETE, handler_reelSpinComplete);
				reelContainer.addChild(reel);
				reels.push(reel);
				
				lastX += (reelsWidth[i] * pxScale + 8 * pxScale);
			}
			
			
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_DATA)) 
			{
				
			}
			
			if (isInvalid(INVALIDATION_FLAG_SIZE)) 
				resize();
			
			tweenAppear();
		}
		
		public function resize():void
		{
			var overHeight:int = this.overHeight;
			
			if (/*!isShowing &&*/ !isHiding)
			{
				container.x = (width / scale) / 2;
				container.y = containerY;
			}
			
			if(roundStartHint)
				roundStartHint.y = height - roundStartHint.height + roundStartHint.pivotY + overHeight - 1*pxScale;
			
			//controlsContainer.x = animation.x;
			//controlsContainer.y = animation.y;
			
			/*quad.alpha = 0;
			quad.x = -overWidth + 5;
			quad.y = -overHeight + 5 ;
			quad.width = gameManager.layoutHelper.stageWidth/scale -10/scale;
			quad.height = gameManager.layoutHelper.stageHeight/scale -10/scale;*/
			
			//indicator.alpha = 0.6
			
			fadeQuad.x = -overWidth - 2;
			fadeQuad.y = -overHeight - 2;
			fadeQuad.width = gameManager.layoutHelper.stageWidth / scale + 4;
			fadeQuad.height = gameManager.layoutHelper.stageHeight / scale + 4;
			
			//backgroundEffects.alpha = 0;
			backgroundEffects.x = -overWidth;
			backgroundEffects.y = -overHeight;
			backgroundEffects.invalidate(INVALIDATION_FLAG_SIZE); 
			backgroundEffects.validate();
	
			
			if (closeButton) {
				closeButton.x = width/scale + overWidth - closeButton.width / 2 + (layoutHelper.isIPhoneX ? 30 : 40) * pxScale;
				closeButton.y = -overHeight + 60 * pxScale; //(PACKS_PADDING_TOP * pxScale - overHeight) / 2;
			}
			
			if (debugControlsButtonQuad)
				debugControlsButtonQuad.x = -overWidth;
		}
		
		private function tweenAppear():void
		{
			if (!isShowing)
				return;
				
			isShowing = false;
			
			SoundManager.instance.setSoundtrackVolume(SoundManager.BACKGROUND_SLOT_MACHINE_VOLUME);
			
			var overHeight:int = this.overHeight;
			var overWidth:int = this.overWidth;
			
			refreshChestsContainer(true, 0.2);
			
			fadeQuad.y = -fadeQuad.height - overHeight;
			fadeQuad.alpha = 0;
			Starling.juggler.tween(fadeQuad, 0.23, {y:-overHeight-2, alpha:1});
			
			//closeButton.alpha = 0;
			//Starling.juggler.tween(closeButton, 0.5, {delay:1.5, alpha:1, transition:Transitions.LINEAR});
			
			EffectsManager.scaleJumpAppearElastic(closeButton, 1, 0.6, 0.6);
			
			container.scaleX = 0.8;
			container.scaleY = 1.2;
			container.y = -animation.pivotY - 100 * pxScale;
			
			
			TweenHelper.tween(container, 0.35, {delay:0, y:((height - 130*pxScale) / scale) / 2, transition:Transitions.EASE_IN}).
				chain(container, 0.08, {y:((height + 70 * pxScale) / scale) / 2, scaleX:1.2, scaleY:0.9, transition:Transitions.LINEAR}).
				chain(container, 0.15, {y:((height - 50 * pxScale) / scale) / 2, scaleX:0.95, scaleY:1.1, transition:Transitions.EASE_OUT}).
				chain(container, 0.22, {y:containerY, scaleX:1, scaleY:1, transition:Transitions.EASE_OUT_BACK});
				
				
			TweenHelper.tween(controlsContainer, 0.08, {delay:0.35, scaleY:0.9, scaleX:1.07, transition:Transitions.EASE_IN}).
				chain(controlsContainer, 0.7, {scaleX:1, scaleY:1, transition:Transitions.EASE_OUT_ELASTIC})	
				
			Starling.juggler.delayCall(animation.goToAndPlay, 0.7, 1);	
			
			Starling.juggler.tween(infoButton, 0.4, {delay:0.6, x:382*pxScale, transition:Transitions.EASE_OUT_BACK});
			
			SoundManager.instance.playSfx(SoundAsset.SlotsAppear, 0, 0, 0.5);
			
			if (roundStartHint) {
				roundStartHint.alpha = 0;
				Starling.juggler.tween(roundStartHint, 0.25, {delay:0.5, alpha:1});
			}
			
			//animation.goToAndPlay(1);	
			//playAnimation('hell_appear', 1);	
			
			/*if (gameManager.slotsModel.totalBonusSpins > 0) {
				closeButton.alpha = 0.6;
				closeButton.touchable = false;
			}*/
			
			
			
			//Starling.juggler.tween(animation.currentClip, 4, {fps:120, delay:3, repeatCount:0, reverse:true});
			
			//setInterval(function():void { changeAnimationFps( animationFps == 60 ? 120 : 60)}, 2500);
		}
		
		private function get containerY():int {
			return (height / scale) / 2 - (roundStartHint ? 20*pxScale : 0);
		}
		
		private function tweenHide():void
		{
			if (isHiding)
				return;	
				
			isHiding = true;
			
			SoundManager.instance.stopSfx(spinSoundAsset);
			
			SoundManager.instance.setSoundtrackVolume(SoundManager.BACKGROUND_VOLUME);
			
			var overHeight:int = this.overHeight;
			var overWidth:int = this.overWidth;
			
			fadeQuad.touchable = false;
			Starling.juggler.tween(fadeQuad, 0.23, { delay: 0.07, /*y:(-fadeQuad.height-overHeight),*/ alpha:0, transition:Transitions.EASE_IN });
			
			if (closeButton) {
				Starling.juggler.removeTweens(closeButton);
				closeButton.touchable = false;
				EffectsManager.scaleJumpDisappear(closeButton, 0.4);
			}
			
			for (var i:int = 0; i < chestsList.length; i++) 
			{
				Starling.juggler.removeTweens(chestsList[i]);
				Starling.juggler.tween(chestsList[i], 0.15, {delay:((chestsList.length - 1 - i) * 0.06), x:(-80 * pxScale - chestsContainerX - overWidth), transition:Transitions.EASE_OUT});
			}
			
			Starling.juggler.tween(container, 0.25, {y:(-animation.pivotY - overHeight - 100*pxScale), transition:Transitions.EASE_IN_BACK });
			
			Starling.juggler.delayCall(removeDialog, 0.4);
			
			if (roundStartHint) 
				Starling.juggler.tween(roundStartHint, 0.15, {alpha:0});
		}
		
		protected function handler_closeButton(e:Event):void
		{
			SoundManager.instance.playSfx(SoundAsset.ButtonClick, 0, 0, SoundAsset.DEFAULT_BUTTON_CLICK_VOLUME, 0, true);
			close();
		}
		
		public function close():void
		{
			disableBetButton();
			disableSpinButton();
			
			model.storedBetIndex = betIndex;
			
			Starling.juggler.removeByID(freeSpinDelayCallId);
			model.freeSpins = 0;
			
			speedSpinModeTimer.removeEventListener(TimerEvent.TIMER, handler_speedSpinModeTimer);
			speedSpinModeTimer.stop();
		
			Game.removeEventListener(ConnectionManager.ROUND_STARTED_EVENT, handler_roundStarted);
			removeEventListener(Event.ENTER_FRAME, handler_roundStartEnterFrame);
			
			heavenFlaresShine.stop();
			hellFlaresShine.stop();
			
			tweenHide();
			
			if (spinSoundAsset)
				SoundManager.instance.stopSfx(spinSoundAsset);
			
			if (freeSpinSoundAsset) {
				SoundManager.instance.stopSfxLoop(freeSpinSoundAsset, 0.1);
				freeSpinSoundAsset = null;
			}
		}	
		
		protected function removeDialog():void 
		{
			indicator.clean();
			
			removeFromParent();
			
			if(callShowReservedDropsOnClose)
				new ShowReservedDrops(0.5).execute();		
		}
		
		/*******************************************************************************************************************************************
		* 
		* CAT ANIMATION
		* 
		******************************************************************************************************************************************/
		
		private function setAnimationState(state:String, type:String, cycleCount:int = 3):void 
		{
			//trace('setAnimationState ', state, type, animationStateQueue.length, betIndex, betIndex % 2);
			
			if (_animationState == state && _animationType == type)
				return;
			
			var parsedLinkage:Array = animation.currentClip.gafTimeline.linkage.split('_');
			var actualAnimationType:String = parsedLinkage[0];	
			var actualAnimationState:String  = '_' + parsedLinkage[1];	
			var animationStopAndInLastFrame:Boolean = !animation.currentClip.inPlay && animation.currentClip.currentFrame == animation.currentClip.totalFrames;
			if (_animationType != type)	
			{
				animationStateQueue.splice(0, animationStateQueue.length);
				
				if (animationStopAndInLastFrame || actualAnimationState == SlotsAnimationState.IDLE) 
				{
					if (actualAnimationState != SlotsAnimationState.HIDE) 
					{
						//_animationType = type;
						playAnimation(_animationType + SlotsAnimationState.HIDE, -1, false, 0, animationFps);
						animation.currentClip.addEventListener(Event.COMPLETE, handler_animationStopLastFrame);
						animationStateQueue.push(new SlotsAnimationState(SlotsAnimationState.HIDE, type));
					}
					else {
						_animationType = type;
						_animationState = SlotsAnimationState.HIDE;
						setAnimationState(SlotsAnimationState.APPEAR, type);
						
						indicator.changeDefaultColor(_animationType == SlotsAnimationState.HELL ? SlotMachineIndicator.COLOR_RED : SlotMachineIndicator.COLOR_ANGEL_BLUE);
					}
					
					/*if (_animationType == type) {
						playAnimation(_animationType + SlotsAnimationState.HIDE, -1);
						animationStateQueue.push(new SlotsAnimationState(SlotsAnimationState.IDLE, _animationType));
					}
					else {
						
					}
					
					playAnimation(type + state, -1);
					animation.currentClip.addEventListener(Event.COMPLETE, handler_animationCompleteToNext);
					animationStateQueue.push(new SlotsAnimationState(SlotsAnimationState.IDLE, _animationType));*/
				}
				else 
				{
					if (actualAnimationState == SlotsAnimationState.IDLE) 
						animation.currentClip.fps = 180;
					
					animation.currentClip.addEventListener(Event.COMPLETE, handler_animationStopLastFrame);
					animationStateQueue.push(new SlotsAnimationState(state, type));
				}
				
				//if(actualAnimationState)
				
				// смена клипа и переключение на стейт:
				return;
				// дожидаемся конца анимации текущего клипа, врубаем хайд, врубаем аппеар, врубаем от состояния либо айдл либо прокрут
			}
				
			if (state == SlotsAnimationState.APPEAR) 
			{
				animationStateQueue.splice(0, animationStateQueue.length);
				
				_animationState = state;
				
				playAnimation(type + state, -1, false, 0, animationFps);
				animation.currentClip.addEventListener(Event.COMPLETE, handler_animationCompleteToNext);
				animationStateQueue.push(new SlotsAnimationState(SlotsAnimationState.IDLE, _animationType));
			}
			else if (state == SlotsAnimationState.IDLE) 
			{
				_animationState = state;
				playAnimation(type + state, -1, true, 0, animationFps);
				
				actualizeCatType();
			}
			else if (state == SlotsAnimationState.SPIN) 
			{
				animationStateQueue.splice(0, animationStateQueue.length);
				
				_animationState = state;
				playAnimation(type + state, -1, false, 0, animationFps);
				animation.currentClip.addEventListener(Event.COMPLETE, handler_animationSpinComplete);
				
				SoundManager.instance.playSfx(SoundAsset.SlotsSpinReel, 0, 0, 0.7);
				//animationStateQueue.push(new SlotsAnimationState(SlotsAnimationState.IDLE, _animationType));
			}
			else if (state == SlotsAnimationState.WIN || state == SlotsAnimationState.WIN_ALTERNATIVE) 
			{
				animationStateQueue.splice(0, animationStateQueue.length);
				
				/*if (animationStopAndInLastFrame) 
				{*/
					_animationState = state;
					
					var cycleSettings:Array = SlotsAnimationState.getCycleSettings(type, state);
					playAnimation(type + state, -1, false, 35, animationFps, cycleSettings[0], cycleSettings[1], cycleCount);
					animation.currentClip.addEventListener(Event.COMPLETE, handler_animationCompleteToNext);
					animationStateQueue.push(new SlotsAnimationState(SlotsAnimationState.IDLE, _animationType));
				/*}
				else 
				{
					animation.currentClip.addEventListener(Event.COMPLETE, handler_animationStopLastFrame);
					animationStateQueue.push(new SlotsAnimationState(state, type));
				}*/
			}
			/*else if (state == SlotsAnimationState.WIN_ALTERNATIVE) 
			{
				
			}*/
			else if (state == SlotsAnimationState.HIDE) 
			{
				
			}
			
			//playAnimation('hell_appear', 1);
		}
		
		private function handler_animationCompleteToNext(event:Event):void 
		{
			animation.currentClip.removeEventListener(Event.COMPLETE, handler_animationCompleteToNext);
			nextQueueAnimationState();
		}
		
		private function handler_animationStopLastFrame(event:Event):void 
		{
			animation.currentClip.removeEventListener(Event.COMPLETE, handler_animationStopLastFrame);
			animation.currentClip.gotoAndStop(animation.currentClip.totalFrames);
			nextQueueAnimationState();
		}
		
		private function nextQueueAnimationState():void 
		{
			if (animationStateQueue.length > 0) {
				var animationState:SlotsAnimationState = animationStateQueue.shift();
				setAnimationState(animationState.state, animationState.type);
			}
		}
		
		private function handler_animationSpinComplete(event:Event):void 
		{
			animation.currentClip.removeEventListener(Event.COMPLETE, handler_animationSpinComplete);
			
			var isSpeedSpinMode:Boolean = (speedSpinModeEnabled && spinButtonTouchCounter >= 1 && speedSpinsCounter > 0)
				
			if (spinButtonReleased || isSpeedSpinMode) 
			{
				_animationState = '';
				setAnimationState(SlotsAnimationState.SPIN, _animationType);  
				
				if (animationFps >= 86) {
					starsExplosion.play(370, 20, 6, 2);
					gearsExplosion.play(370, 12, 5, 40);
				}
				else if (animationFps >= 64) {
					starsExplosion.play(370, 10, 5, 10);
					gearsExplosion.play(370, 6, 2, 140);
				}
			}
			else {
				
				setAnimationState(SlotsAnimationState.IDLE, _animationType);
			}
		}
		
		/******************************************************************************************************************************************
		* 
		* 
		* 
		******************************************************************************************************************************************/
		
		private function spin(freeSpinIndicatorOverride:int = -1, debugSpinResult:SpinResult = null):void 
		{
			if (spinResult) {
				return;
			}	
			
			stopReelsCalled = false;
			
			var totalBonusSpins:int = gameManager.slotsModel.totalBonusSpins;
			var spinType:String;
			
			if (totalBonusSpins > 0) {
				spinType = SpinType.BONUS_MINIGAME;
			}	
			else if (model.freeSpins > 0) {
				spinType = SpinType.FREE;
			}	
			else {
				spinType = SpinType.DEFAULT;
				freeSpinsTotalItems = {};
			}
			
			spinResult = model.useSpin(spinType, betIndex, speedSpinModeEnabled, debugSpinResult);
			//spinResult.isLastFreeSpin = hasFreeSpins && model.freeSpins <= 0;
			if (!spinResult)
				return;
			
			var needToSpeedSpinPattern:Boolean = (totalBonusSpins > 0 || model.freeSpins > 0) && timeToRoundStart <= 10;	
			
			if((speedSpinModeEnabled && animationFps >= 82) || needToSpeedSpinPattern)
				spinResult.spinPattern = SpinPattern.getForSpeedSpin();	
			
			disableBetButton();
			
			//indicator.showSpin();
			indicator.showIdleMessage();
			
			setAnimationState(SlotsAnimationState.SPIN, _animationType);
			
			if (freeSpinIndicatorOverride != -1 || spinType == SpinType.BONUS_MINIGAME || spinType == SpinType.FREE) 
			{
				var indicatorString:String;
				if (freeSpinIndicatorOverride != -1) 
					indicatorString = "FREE SPINS: " + freeSpinIndicatorOverride.toString();
				if (spinType == SpinType.BONUS_MINIGAME) 
					indicatorString = "FREE SPINS: " + totalBonusSpins.toString();
				else if (spinType == SpinType.FREE) 
					indicatorString = "FREE SPINS: " + (model.freeSpins + 1).toString();
				
				indicator.showText(indicatorString, SlotMachineIndicator.COLOR_BLUE_LIGHT, indicator.defaultTextSize, false, 0.35);
				
				if (!freeSpinSoundAsset) 
				{
					if (_animationType == SlotsAnimationState.HELL) {
						freeSpinSoundAsset = SoundAsset.SlotsDevilFreeSpinsMusic; 
						SoundManager.instance.playSfxLoop(freeSpinSoundAsset, 14.8, 0.05, 0.05, 0.6);
					}
					else {
						freeSpinSoundAsset = SoundAsset.SlotsAngelFreeSpinsMusic; 
						SoundManager.instance.playSfxLoop(freeSpinSoundAsset, 7.7, 0.1, 0.1, 0.6);
					}
				}
			}
			
			machineState = STATE_SPINNING;
			
			for (var i:int = 0; i < reels.length; i++) 
			{
				var reel:SlotMachineReel = reels[i];
				if(speedSpinModeEnabled)
					reel.launch(i * 50, SlotMachineReel.LAUNCH_SPEED_FAST);
				else
					reel.launch(i * 100);
			}
			
			TweenHelper.tween(gearImage, 0.4, {delay:0, rotation:(gearImage.rotation - Math.PI/8), transition:Transitions.EASE_IN_BACK}).
				chain(gearImage, 1.7, {delay:0, rotation:(gearImage.rotation - 2 * Math.PI - Math.PI/8), transition:Transitions.LINEAR, repeatCount:100});
				
			animateArrow(arrowLeft,	0, false, 0);
			animateArrow(arrowRight, 0, true, 0.3);
			
			//TweenHelper.tween(controlsContainer, 0.15, {y:(controlsContainer.y + 2), delay:0.4, transition:Transitions.EASE_OUT_SINE, reverse:true, repeatCount:0});
			
			tweenFlares(0.15, 0.45);
			
			Starling.juggler.removeByID(stopReelsDelayCallId);
			stopReelsDelayCallId = Starling.juggler.delayCall(stopReels, SpinPattern.getSpinTime(spinResult.spinPattern), 'spin');
			//trace('> stopReelsDelayCallId', stopReelsDelayCallId);
			
			//SoundManager.instance.playSfx(SoundAsset.SlotsSpinReel);
			
			if (!(spinType == SpinType.FREE || spinType == SpinType.BONUS_MINIGAME)) 
			{
				if (reelSpinSounds.length == 0) 
					reelSpinSounds = new <SoundAsset> [SoundAsset.SlotsReelSpin_01, SoundAsset.SlotsReelSpin_02, SoundAsset.SlotsReelSpin_03, SoundAsset.SlotsReelSpin_04, SoundAsset.SlotsReelSpin_05, SoundAsset.SlotsReelSpin_06];
			
				if (speedSpinModeEnabled && spinSoundAsset)
					SoundManager.instance.stopSfx(spinSoundAsset);
					
				spinSoundAsset = reelSpinSounds.splice(Math.floor(reelSpinSounds.length * Math.random()), 1)[0] ;	
				SoundManager.instance.playSfx(spinSoundAsset, 0, speedSpinModeEnabled ? 1000 : 0);
			}
		}
		
		private function stopReels(source:String = ''):void 
		{
			if (isHiding)
				return;
			
			if (spinButtonReleased) {
				Starling.juggler.removeByID(stopReelsDelayCallId);
				stopReelsDelayCallId = Starling.juggler.delayCall(stopReels, SpinPattern.getSpinTime(SpinPattern.SIMPLE), 'stopReelsInternal');
				//trace('> stopReelsDelayCallId spinButtonReleased', stopReelsDelayCallId);
				return;
			}
			
			//if (!spinResult) 
				//spinResult = new SpinResult();
			
			stopReelsCalled = true;
			
			if(speedSpinModeEnabled && animationFps >= 82)
				spinResult.spinPattern = SpinPattern.getForSpeedSpin();
				
			var i:int = 0;
			var length:int = reels.length;
			var reel:SlotMachineReel;
			var stopDelays:Array = SpinPattern.getStopDelays(spinResult.spinPattern, reels.length);
			var rewardTypes:Array = getRewardTypes(spinResult.spinPattern, spinResult.reward, reels.length);
			spinResult.rewardTypes = rewardTypes;
			
			//trace('stopDelays: ', stopDelays, spinResult.spinPattern, source);
			
			if(!speedSpinModeEnabled)
				SoundManager.instance.stopSfx(spinSoundAsset);
			
			for (i = 0; i < length; i++) 
			{
				reels[i].stop(stopDelays[i], rewardTypes[i]);
				
				if (stopDelays[i] > 800) {
					SoundManager.instance.playSfx(SoundAsset.SlotsReelAnticipation, 0.3, 0, 0.5);
					Starling.juggler.delayCall(SoundManager.instance.stopSfx, 0.3 + 1.35, SoundAsset.SlotsReelAnticipation);
				}	
					
				SoundManager.instance.playSfx(reelStopSounds[Math.min(i, reelStopSounds.length - 1)], stopDelays[i]/1000);
			}
			
			Starling.juggler.removeTweens(frameFlares[1]);
			Starling.juggler.tween(frameFlares[1], 0.15 * ((flaresHeightAmplitude - frameFlares[1].y) / flaresHeightAmplitude), {y:flaresHeightAmplitude, transition:Transitions.EASE_IN_OUT, onUpdate:updateFlaresPositions});
			
			Starling.juggler.removeTweens(gearImage);
			Starling.juggler.tween(gearImage, 0.4, {rotation:(gearImage.rotation - Math.PI / 8), transition:Transitions.EASE_OUT_BACK});
			
			animateArrowFinish(arrowLeft, 1.8, 0);
			Starling.juggler.delayCall(animateArrowFinish, 0.3, arrowRight, 1.8, 0);
			
			//Starling.juggler.removeTweens(controlsContainer);
			//Starling.juggler.tween(controlsContainer, 0.15, {y:(animation.y + controlsContainer.pivotY + 170*pxScale), transition:Transitions.EASE_OUT_BACK});
		}
		
		private function handler_reelSpinComplete(e:Event):void 
		{
			if (!isReelsStoped || !spinResult)
				return;
				
			// cat reaction
			// bg effect
			// reels effect
			
			var totalBonusSpins:int = model.totalBonusSpins;
			var winFreeSpins:Boolean;
			var winType:String;
			var winCashValue:int;
			var winDurationTime:Number = 0.7;
			var playerCashString:String = 'CASH: $' + StringUtils.delimitThousands(Player.current.cashCount, ",");
			var rewardType:String = spinResult.reward ? spinResult.reward.rewardType : null;
			var winAnimationCycleCount:int = 1;
			
			if (spinResult.reward && spinResult.reward.rewardType != SlotMachineRewardType.NO_WIN && spinResult.reward.commodityItem)
			{
				winType = SlotMachineRewardType.getWinType(spinResult.reward.rewardType);
				
				switch(spinResult.reward.commodityItem.type) 
				{
					case CommodityType.CASH: 
					{
						winCashValue = spinResult.reward.commodityItem.quantity;
						
						if (winType == SlotMachineWinType.MEGA || winType == SlotMachineWinType.BIG) 
						{
							indicator.showCashMegaWin(winCashValue, Player.current.cashCount);
							winAnimationCycleCount = winType == SlotMachineWinType.MEGA ? 4 : 2;
							winDurationTime = 2.5 + SlotMachineRewardType.getCashAnimateDuration(winCashValue);
						}	
						else 
						{
							if (spinResult.reward.rewardType == SlotMachineRewardType.CASH_1) 
							{
								indicator.showTextSequence(['WIN: $' + winCashValue.toString(), playerCashString], 
									[SlotMachineIndicator.COLOR_GREEN, SlotMachineIndicator.COLOR_PURPLE],
									[indicator.defaultTextSize, indicator.defaultTextSize], 
									0, 1.0, 0.35, false);	
								winAnimationCycleCount = 1;	
							}
							else
							{
								indicator.showTextSequence(['WIN: $' + winCashValue.toString(), playerCashString], 
									[SlotMachineIndicator.COLOR_GREEN, SlotMachineIndicator.COLOR_PURPLE],
									[indicator.defaultTextSize, indicator.defaultTextSize], 
									0, 1.0, 0.35, false);
								winAnimationCycleCount = 2;	
							}
							winDurationTime = 1.5;
						}
							
						//showPlayerResourceProgressView(Type.CASH);	
						
						addToFreeSpinsTotalItems(SlotMachineRewardType.CASH_1, winCashValue);
						
						break;
					}
					case CommodityType.POWERUP: 
					{
						indicator.showCommonMegaWin('BIG WIN!', 65*pxScale, spinResult.reward.rewardType == SlotMachineRewardType.THREE_DAUBS ? SlotMachineIndicator.COLOR_BLUE : SlotMachineIndicator.COLOR_PINK,
							2, spinResult.reward.commodityItem.quantity.toString() + ' ' + SlotMachineRewardType.getName(spinResult.reward.rewardType), playerCashString);
						
						winAnimationCycleCount = winType == SlotMachineWinType.MEGA ? 3 : 2;
						winDurationTime = 3.5;
						
						addToFreeSpinsTotalItems(rewardType, spinResult.reward.commodityItem.quantity);
						
						break;
					}
					case CommodityType.DUST: 
					{
						indicator.showTextSequence(['WIN: ' + spinResult.reward.commodityItem.quantity.toString() + ' DUST', 'CASH: $'+Player.current.cashCount.toString()], 
									[SlotMachineIndicator.COLOR_GREEN, SlotMachineIndicator.COLOR_PURPLE],
									[indicator.defaultTextSize, indicator.defaultTextSize], 
									0, 1.0, 0.35, false);
									
						winAnimationCycleCount = 2;
						winDurationTime = 1.5;
						
						addToFreeSpinsTotalItems(rewardType, spinResult.reward.commodityItem.quantity);
						
						break;
					}
					case CommodityType.CHEST: 
					{
						indicator.showCommonMegaWin('BIG WIN!', 65*pxScale, SlotMachineIndicator.COLOR_YELLOW, 2, spinResult.reward.commodityItem.quantity.toString() + ' ' + SlotMachineRewardType.getName(spinResult.reward.rewardType), playerCashString);
						
						refreshChestsContainer();
						
						winAnimationCycleCount = 4;	
						winDurationTime = 4;
						
						addToFreeSpinsTotalItems(rewardType, spinResult.reward.commodityItem.quantity);
						
						break;
					}
					case CommodityType.SLOT_FREE_SPINS: 
					{
						indicator.showCommonMegaWin('FREE SPINS!', 51*pxScale, SlotMachineIndicator.COLOR_BLUE_LIGHT, 2, null);
						
						showFreeSpinsIndicator = model.freeSpins > 0;
						
						winFreeSpins = true;
						
						closeButton.alpha = 0.6;
						closeButton.touchable = false;
						
						winAnimationCycleCount = 1;	
						winDurationTime = 2;
						
						disableSpeedSpinMode();
						changeAnimationFps(animationFps);
						
						disableSpinButton();
						
						break;
					}
				}
				
				if (winType == SlotMachineWinType.MEGA)
				{
					setAnimationState(SlotsAnimationState.WIN, _animationType, winAnimationCycleCount);
					backgroundEffects.showWinEffect(_animationType);
					Starling.juggler.delayCall(backgroundEffects.completeEffect, 3); 
					SoundManager.instance.playSfx(SoundAsset.SlotsWinStart);
				}
				else if (winType == SlotMachineWinType.BIG)
				{
					//if(!speedSpinModeEnabled)
					setAnimationState(SlotsAnimationState.WIN, _animationType, winAnimationCycleCount);
					backgroundEffects.showWinEffect(_animationType, true);
					Starling.juggler.delayCall(backgroundEffects.completeEffect, 1.35); 
					SoundManager.instance.playSfx(SoundAsset.SlotsWinStart);
				}
				else
				{
					if(!speedSpinModeEnabled)
						setAnimationState(SlotsAnimationState.WIN_ALTERNATIVE, _animationType, winAnimationCycleCount);
					SoundManager.instance.playSfx(SoundAsset.SlotsSimpleWin, 0, 0, 0.7);
				}
			}
			else
			{
				//showPlayerResourceProgressView(Type.CASH);	
				//indicator.showRegular();
				
				if (model.freeSpins == 0 && totalBonusSpins == 0) 
				{
					indicator.showTextSequence(['CASH: $'+Player.current.cashCount.toString()], 
									[SlotMachineIndicator.COLOR_PURPLE],
									[indicator.defaultTextSize], 
									0, 1.0, 0.35, false);
				}					
								
				winDurationTime = 0.3;				
			}	
			
			if (winType == SlotMachineWinType.MEGA && speedSpinModeEnabled) 
			{
				blockSpinButtonTimestamp = getTimer() + winDurationTime*1000; 
				disableSpeedSpinMode();
			}
			
			new UpdateLobbyBarsTrueValue(0).execute();
			
			var winRewardType:String = rewardType;
			if (winRewardType == SlotMachineRewardType.CASH_1)
				winRewardType = SlotMachineRewardType.CASH_2;
				
			showReelsWin(winRewardType);
			
			// отработали, выдали все, очищаем spinResult
			var lastSpinType:String = spinResult.spinType;
			spinResult = null;
			
			if (totalBonusSpins > 0)
			{
				//launchBonusSpins();
				freeSpinDelayCallId = Starling.juggler.delayCall(spin, winDurationTime);
				closeButton.alpha = 0.6;
				closeButton.touchable = false;
			}
			else if (model.freeSpins > 0) 
			{
				freeSpinDelayCallId = Starling.juggler.delayCall(spin, winFreeSpins ? 1.6 : winDurationTime);
			}
			else 
			{
				//indicator.showIdleMessage();
				
				if (freeSpinSoundAsset) {
					SoundManager.instance.stopSfxLoop(freeSpinSoundAsset, 0.1);
					freeSpinSoundAsset = null;
					SoundManager.instance.playSfx(SoundAsset.SlotsWinCompleted, 0.1);
				}
				
				if (timeToRoundStart <= 0) 
				{
					close();
					return;
				}
				
				closeButton.alpha = 1;
				closeButton.touchable = true;
				
				if (speedSpinModeEnabled && spinButtonTouchCounter >= 2)
				{
					freeSpinDelayCallId = Starling.juggler.delayCall(spin, 0.05);
					speedSpinsCounter++;
				}
				else
				{
					disableSpeedSpinMode();
					enableSpinButton();
					enableBetButton();
				}
				
				
				var freeSpinsTotalItemsString:String;
				if (lastSpinType == SpinType.FREE)
				{
					freeSpinsTotalItemsString = getFreeSpinsTotalItemsString();
					if (freeSpinsTotalItemsString) 
						indicator.showTotalText(freeSpinsTotalItemsString, playerCashString, rewardType == SlotMachineRewardType.NO_WIN ? 0.3 : winDurationTime);
				}
				else if (lastSpinType == SpinType.BONUS_MINIGAME)
				{
					betDisplayShowCurrentBet(true);
					
					freeSpinsTotalItemsString = getFreeSpinsTotalItemsString();
					if (freeSpinsTotalItemsString) 
						indicator.showTotalText(freeSpinsTotalItemsString, playerCashString, rewardType == SlotMachineRewardType.NO_WIN ? 0.3 : winDurationTime);
					else
						indicator.showIdleMessage();
				}
			}
			
			handleActualizeCatType();
		}
		
		private function disableSpeedSpinMode():void 
		{
			speedSpinsCounter = 0;
			speedSpinModeEnabled = false;
			animationFps = 60;	
			
			if (spinSoundAsset) {
				SoundManager.instance.stopSfx(spinSoundAsset);
				spinSoundAsset = null;
			}
		}
		
		
		private function updateBetIndex(index:int):void 
		{
			var oldStakeValue:int = model.betList[betIndex]
			betIndex = index;
			var stakeValue:int = model.betList[betIndex];
			betDisplay.tweenIntText(oldStakeValue, stakeValue);
		}
		
		private function get isReelsStoped():Boolean
		{
			for each (var item:SlotMachineReel in reels) 
			{
				if (item.isSpinning)
					return false;
			}
			return true;
		}
		
		private function getRewardTypes(pattern:String, reward:SlotMachineReward, reelsCount:int):Array 
		{
			var result:Array = [];
			
			if (reward && reward.rewardType != SlotMachineRewardType.NO_WIN) 
			{
				if (reward.rewardType == SlotMachineRewardType.CASH_1)
				{
					if (pattern == SpinPattern.TWISTING)
					{
						rewardType = model.getRandomReward([SlotMachineRewardType.CASH_2]).rewardType;
						result = [rewardType, rewardType, SlotMachineRewardType.CASH_2];
					}
					else
					{
						result = [SlotMachineRewardType.CASH_2];
						result.push(model.getRandomReward(result).rewardType);
						result.push(model.getRandomReward(result).rewardType);
						result.sort(randomSort);
					}
				}
				else
				{
					while (reelsCount > 0) {
						result.push(reward.rewardType);
						reelsCount--;
					}
				}
				
				return result;
			}
			
			var rewardType:String;	
			
			switch(pattern)
			{
				case SpinPattern.SIMPLE: 
				case SpinPattern.LONG: {
					while (reelsCount > 0) 
					{
						result.push(model.getRandomReward(result.concat([SlotMachineRewardType.CASH_2])).rewardType);
						reelsCount--;
					}
					
					break;
				}
				case SpinPattern.TWISTING: {
					rewardType = model.getRandomReward([SlotMachineRewardType.CASH_2]).rewardType;
					result = [rewardType, rewardType];
					result.push(model.getRandomReward(result.concat([SlotMachineRewardType.CASH_2])).rewardType);
					break;
				}
			}
			
			return result;
		}
		
		private function tweenFlares(time:Number, delay:Number = 0.1):void 
		{
			Starling.juggler.removeTweens(frameFlares[1]);
			flaresContainer.alpha = 0;
			frameFlares[1].y = 0;
			Starling.juggler.tween(frameFlares[1], time, {y:flaresHeightAmplitude, transition:Transitions.LINEAR/*EASE_IN_OUT*/, delay:delay, repeatCount:0, onUpdate:updateFlaresPositions});
		}
		
		private function updateFlaresPositions():void 
		{
			var tweenRatio:Number = frameFlares[1].y / flaresHeightAmplitude;
			
			frameFlares[0].y = frameFlares[2].y = frameFlares[3].y = frameFlares[1].y;
			
			if (tweenRatio < 0.1) 
				flaresContainer.alpha = tweenRatio / 0.1;
			else if (tweenRatio < 0.9) 
				flaresContainer.alpha = 1;
			else  
				flaresContainer.alpha = (1 - tweenRatio) / 0.1;
			
			var shiftXRatio:Number;
			var rotationRatio:Number;
			if (tweenRatio < 0.5) {
				shiftXRatio = easeOut(tweenRatio * 2);
				rotationRatio = 1 - shiftXRatio;
			}
			else  {
				shiftXRatio = easeOut((1 - tweenRatio) * 2);
				rotationRatio = -1 + shiftXRatio;
			}
			
			frameFlares[0].rotation = rotationRatio * (5 * Math.PI / 180);
			frameFlares[3].rotation = -rotationRatio * (5 * Math.PI / 180);
			frameFlares[0].x = 54*pxScale - shiftXRatio * 4 * pxScale;
			frameFlares[3].x = 625*pxScale + shiftXRatio * 4 * pxScale;
		}
		
		private function easeOut(ratio:Number):Number
        {
            var invRatio:Number = ratio - 1.0;
            return invRatio * invRatio * invRatio + 1;
        }        
		
		private function shakeReels():void 
		{
			var i:int = 0;
			var length:int = reels.length;
			var reel:SlotMachineReel;
			for (i = 0; i < length; i++) 
			{
				reels[i].shake(0.25, i*0.1);
			}
		}
		
		private function showReelsWin(rewardType:String):void 
		{
			var i:int = 0;
			var length:int = reels.length;
			var reel:SlotMachineReel;
			for (i = 0; i < length; i++) 
			{
				if(spinResult.rewardTypes[i] == rewardType)
					reels[i].showWin(rewardType, i*0.11);
			}
		}
		
		private function shakeControls():void 
		{
			var _x:int = animation.x - 2*pxScale;
			var _y:int = (animation.y + controlsContainer.pivotY + 170 * pxScale);
			var finishX:int = _x + 2 - 4 * Math.random();
			var finishY:int = _y + 2 - 4 * Math.random();
			var dist:Number = Point.distance(new Point(_x, _y), new Point(finishX, finishY));
			
			TweenHelper.tween(controlsContainer, dist / 10, {x:finishX, y:finishY, transition:(Math.random() > 0.5 ? Transitions.EASE_IN : Transitions.EASE_OUT_BACK), onComplete:shakeControls});
		}
		
		private function animateArrow(image:Image, startRotation:Number, invertAngle:Boolean, delay:Number):void 
		{
			Starling.juggler.removeTweens(image);
			
			var k:int = invertAngle ? -1:1;
			TweenHelper.tween(image, 0.6, {delay:delay, rotation:(startRotation + k * (Math.PI / 10)), transition:Transitions.EASE_IN}).
				chain(image, 0.3, {rotation:(startRotation + k * (Math.PI / 7.5)), transition:Transitions.EASE_IN_OUT, reverse:true, repeatCount:0});
		}
		
		private function animateArrowFinish(image:Image, time:Number, rotation:Number):void 
		{
			Starling.juggler.removeTweens(image);
			Starling.juggler.tween(image, time, {rotation:rotation, transition:Transitions.EASE_OUT_ELASTIC})
		}
		
		private function playAnimation(linkageId:String, stopOnFrame:int = -1, loop:Boolean = false, startFrame:int = 0, fps:int = -1, cycleStartFrame:int=-1, cycleFinishFrame:int=-1, cycleCount:int = 1):void
		{
			//trace('play animation: ', linkageId);
			
			reelContainer.removeFromParent();
			indicator.removeFromParent();
			
			//GAFUtils.createGAFMovieClip(gameManager.slotsModel.animationAsset.getGAFTimelineByLinkage(linkageId), linkageId + SlotsDialog.LAYER_REELS_ID, animationLayerIdsSettings[SlotsDialog.LAYER_REELS_ID + linkageId], 0, true);	
			//GAFUtils.createGAFMovieClip(gameManager.slotsModel.animationAsset.getGAFTimelineByLinkage(linkageId), linkageId + SlotsDialog.LAYER_SCREEN_ID, animationLayerIdsSettings[SlotsDialog.LAYER_SCREEN_ID + linkageId], 0, true);
			
			animation.playTimeline(linkageId, false, loop, fps);
			
			if (cycleStartFrame != -1 && cycleFinishFrame != -1 && cycleCount > 1) {
				animation.cycle(linkageId, cycleStartFrame, cycleFinishFrame, cycleCount-1);
			}
			
			
			if (stopOnFrame > -1)
				animation.goToAndStop(stopOnFrame);
			else {
				//animation.currentClip.gotoFrame(startFrame);
				animation.goToAndPlay(startFrame);
			}
	
			var reelsGafMovieClip:GAFMovieClip = animation.currentClip.getChildByID(linkageId + SlotsAnimationState.LAYER_REELS_ID) as GAFMovieClip;
			if (reelsGafMovieClip)
				reelsGafMovieClip.addChild(reelContainer);
			
			var indicatorGafMovieClip:GAFMovieClip = animation.currentClip.getChildByID(linkageId + SlotsAnimationState.LAYER_SCREEN_ID) as GAFMovieClip;
			if (indicatorGafMovieClip)
				indicatorGafMovieClip.addChild(indicator);	
		}
		
		private function changeAnimationFps(fps:int):void 
		{
			//trace('fps', fps);
			animation.stop();
			animation.currentClip.fps = fps;
			//animation.playTimeline(linkageId, false, loop, fps);
			//animation.goToAndPlay(startFrame);
			animation.play();
		}
		
		private function getBetButtonContent(width:int, height:int):Sprite 
		{
			var sprite:Sprite = new Sprite();
			var touchQuadWidth:int = 136 * pxScale;
			var touchQuadHeight:int = 130 * pxScale;
			
			var image:Image = new Image(AtlasAsset.ScratchCardAtlas.getTexture("slots/button_green"));
			image.scale9Grid = ResizeUtils.getScaledRect(15, 27, 1, 1);
			image.width = width;
			image.height = height;
			image.x = (touchQuadWidth - width) / 2;
			image.y = (touchQuadHeight - height) / 2;
			sprite.addChild(image);
			
			var textField:XTextField = new XTextField(width, height, XTextFieldStyle.getWalrus(32), "BET");
			textField.pixelSnapping = false;
			textField.x = (touchQuadWidth - width) / 2;
			textField.y = (touchQuadHeight - height) / 2;
			sprite.addChild(textField);
			
			image = new Image(AtlasAsset.ScratchCardAtlas.getTexture("slots/button_shadow"));
			image.scale9Grid = ResizeUtils.getScaledRect(14, 0, 1, 0);
			image.width = width;
			image.x = (touchQuadWidth - width) / 2;
			image.y = (touchQuadHeight - height) / 2 - 1.5 * pxScale;
			image.alpha = 0;
			sprite.addChild(image);
			
			var touchQuad:Quad = new Quad(1, 1);
			touchQuad.alpha = 0.0;
			touchQuad.width = touchQuadWidth;
			touchQuad.height = touchQuadHeight;
			sprite.addChild(touchQuad);
			
			return sprite;
		}
		
		private function getSpinButtonContent(width:int, height:int):Sprite 
		{
			var sprite:Sprite = new Sprite();
			
			var image:Image = new Image(AtlasAsset.ScratchCardAtlas.getTexture("slots/button_red"));
			image.scale9Grid = ResizeUtils.getScaledRect(14, 27, 1, 1);
			image.width = width;
			image.height = height;
			sprite.addChild(image);
			
			var textField:XTextField = new XTextField(width, height, XTextFieldStyle.getWalrus(59).setStroke(0.3, 0x7E070F), "SPIN");
			//textField.helperFormat.nativeTextExtraWidth = 10 * pxScale;
			textField.pixelSnapping = false;
			sprite.addChild(textField);
			
			image = new Image(AtlasAsset.ScratchCardAtlas.getTexture("slots/button_shadow"));
			image.scale9Grid = ResizeUtils.getScaledRect(14, 0, 1, 0);
			image.width = width;// * pxScale;//(width - 14)* pxScale;
			//image.x = 7 * pxScale;
			image.y = -1.5 * pxScale;
			image.alpha = 0;
			sprite.addChild(image);
			
			return sprite;
		}
		
		private function getInfoButtonContent(width:int):Sprite 
		{
			var sprite:Sprite = new Sprite();
			
			var image:Image = new Image(AtlasAsset.ScratchCardAtlas.getTexture("slots/info_button_bg"));
			image.scale9Grid = ResizeUtils.getScaledRect(0, 0, 1, 0);
			image.width = width;// * pxScale;
			//image.height = height;
			sprite.addChild(image);
			
			var textField:XTextField = new XTextField(width, image.height, XTextFieldStyle.houseHolidaySans(95, 0xFCEB8D).setStroke(1, 0x000000), "i");
			//textField.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			textField.pixelSnapping = false;
			textField.x = 10*pxScale;
			textField.y = 10*pxScale;
			textField.scaleY = 0.85;
			sprite.addChild(textField);
			
			return sprite;
		}
		
		private function handler_betButton(event:Event):void
		{
			if (model.freeSpins > 0)
				return;
				
			var index:int = betIndex + 1;
			if (index >= model.betList.length) 
				index = 0;	
			
			updateBetIndex(index);
			
			SoundManager.instance.playSfx(SoundAsset.SlotsBetChange);
			
			actualizeCatType();
		}
		
		private function callback_betButtonMouseDown():void
		{
			setButtonShadowAlpha(betButton, 1);
		}
		
		private function callback_betButtonMouseUp():void
		{
			setButtonShadowAlpha(betButton, 0);
		}
		
		private function setButtonShadowAlpha(button:Button, alpha:Number):void {
			var image:Image = (button.defaultSkin as Sprite).getChildAt(2) as Image;
			Starling.juggler.tween(image, 0.07, {alpha:alpha});
		}
		
		private function enableBetButton():void
		{
			betButtonHelper.setEnabled(true, false);
			betButton.isEnabled = true;
			
			Starling.juggler.tween(betButton, 0.3, {scale:1, transition:Transitions.EASE_OUT_BACK});
			
			setButtonShadowAlpha(betButton, 0);
		}
		
		private function disableBetButton():void
		{
			betButton.scale = betButtonHelper.minScale;
			betButtonHelper.setEnabled(false, false);
			betButton.isEnabled = false;
			setButtonShadowAlpha(betButton, 1);
		}	
		
		private function disableSpinButton():void
		{
			spinButton.scaleX = spinButtonHelper.minScaleX;
			spinButton.scaleY = spinButtonHelper.minScaleY;
			spinButtonHelper.setEnabled(false, false);
			spinButton.isEnabled = false;
			setButtonShadowAlpha(spinButton, 1);
		}	
		
		private function handler_spinButton(event:Event):void
		{
			//Starling.juggler.delayCall(enableSpinButton, 3);
			//spin();
		}
		
		private function callback_spinButtonMouseDown():void
		{
			setButtonShadowAlpha(spinButton, 1);
			SoundManager.instance.playSfx(SoundAsset.ButtonClick, 0, 0, SoundAsset.DEFAULT_BUTTON_CLICK_VOLUME, 0, true);
			
			if (blockSpinButtonTimestamp - getTimer() > 0) {
				spinButtonLastTouchTimeout = getTimer();
				return;
			}
			
			if (hasBonusSpinsAtStart && spinButton.isEnabled && model.totalBonusSpins > 0) {
				hasBonusSpinsAtStart = false;
				disableSpinButton();
			}
			
			if ((getTimer() - spinButtonLastTouchTimeout) < 900)
			{
				spinButtonTouchCounter++;
				
				if (spinButtonTouchCounter >= spinButtonMaxTouchCount) 
				{
					/*if (spinButtonTouchCounter >= 3 && spinButtonTouchCounter < 6) {
						starsExplosion.play(170, 6, 1, 10);
						gearsExplosion.play(270, 3, 2, 130);
					}*/
				
					speedSpinModeEnabled = true;
				}
				
				Starling.juggler.removeByID(spinButtonTouchCounterCleanId);
				spinButtonTouchCounterCleanId = Starling.juggler.delayCall(cleanSpinButtonTouchCounter, 0.91);
				
				animationFps = Math.min(90, animationFps + 2);
				if(!speedSpinModeTimer.running)
					speedSpinModeTimer.start();
					
				changeAnimationFps(animationFps);
			}
			else {
				//spinButtonTouchCounter = 0;
			}
			
			//trace('> ',spinButtonTouchCounter, animationFps);	
				
			spinButtonLastTouchTimeout = getTimer();
			
			if (spinResult) 
			{
				/*if (!speedSpinModeEnabled && !stopReelsCalled) {
					trace('remove stopReelsDelayCallId', stopReelsDelayCallId);
					Starling.juggler.removeByID(stopReelsDelayCallId);
					stopReels('spin as stop button');
				}*/
				
				return;
			}
			
			spin();
			
			if (spinResult) {
				spinButton.addEventListener(TouchEvent.TOUCH, handler_spinButtonTouch);
				spinButtonReleased = true;
			}
		}
		
		private function handler_speedSpinModeTimer(e:TimerEvent):void 
		{
			animationFps = Math.max(60, animationFps - 4);
			
			changeAnimationFps(animationFps);
			
			if (animationFps <= 60)
				speedSpinModeTimer.stop();
		}
		
		private function cleanSpinButtonTouchCounter():void
		{
			spinButtonTouchCounter = 0;
			animationFps = 60;	
		}
		
		private function callback_spinButtonMouseUp():void
		{
			setButtonShadowAlpha(spinButton, 0);
			//spinButtonReleased = false;
		}
		
		private function handler_spinButtonTouch(event:TouchEvent):void
		{
			const touch:Touch = event.getTouch(spinButton);
			if (touch) 
			{
				if (touch.phase == TouchPhase.ENDED) 
				{
					spinButtonMouseReleased();
				}
				else if (touch.phase == TouchPhase.MOVED) 
				{	
					if(spinButtonHelper.outOfBounds) {
						spinButtonMouseReleased();
					} 
				}
			} 
			else {
				spinButtonMouseReleased();
			}
		}
		
		private function spinButtonMouseReleased():void
		{
			spinButton.removeEventListener(TouchEvent.TOUCH, handler_spinButtonTouch);
			spinButtonReleased = false;
		}
		
		private function enableSpinButton():void
		{
			spinButtonHelper.setEnabled(true, false);
			spinButton.isEnabled = true;
			
			Starling.juggler.tween(spinButton, 0.3, {scale:1, transition:Transitions.EASE_OUT_BACK});
			
			setButtonShadowAlpha(spinButton, 0);
		}
		
		private function handler_info(event:Event):void
		{
			SoundManager.instance.playSfx(SoundAsset.ButtonClick, 0, 0, SoundAsset.DEFAULT_BUTTON_CLICK_VOLUME, 0, true);
			DialogsManager.addDialog(new SlotsPayoutsDialog(), true);
		}
		
		private function set showFreeSpinsIndicator(value:Boolean):void
		{
			// пока что не показывать
			return;
			
			if (value)
			{
				if (!freeSpinsImage)
				{
					freeSpinsImage = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/prizes/free_spins'));
					freeSpinsImage.alignPivot();
					freeSpinsImage.x = 530*pxScale;
					freeSpinsImage.y = -106*pxScale;
					container.addChild(freeSpinsImage);
				
					TweenHelper.tween(freeSpinsImage, 0.36, {alpha:0.38, repeatCount:0, reverse:true});
				}
			}
			else
			{
				if (freeSpinsImage)
				{
					Starling.juggler.removeTweens(freeSpinsImage);
					TweenHelper.tween(freeSpinsImage, 0.36, {alpha:0, onComplete:removeFreeSpinsImage});
				}
			}
		}
		
		private function removeFreeSpinsImage():void
		{
			if (freeSpinsImage)
			{
				freeSpinsImage.removeFromParent();
				freeSpinsImage = null;
			}
		}
		
		/******************************************************************************************************************************************
		* 
		* 
		* 
		******************************************************************************************************************************************/
		
		private function refreshChestsContainer(isDialogAppear:Boolean = false, delay:Number = 0):void
		{
			var localChestsCountByType:Object = {};
			var i:int;
			var length:int = gameManager.chestsData.storedChests.length;
			var chestPartsView:ChestPartsView;
			var storedChest:StoredChest;
			var newChestFinishX:int;
			var newChestCounter:int;
			for (i = 0; i < length; i++) 
			{
				storedChest = gameManager.chestsData.storedChests[i];
				if (storedChest.source == SlotsModel.SOURCE_ID) 
				{
					if (!(storedChest.type in chestsCountByType))
					{
						// здесь появление свежего:
						chestPartsView = new ChestPartsView(storedChest.type, 0.777);
						chestPartsView.data = storedChest;
						chestPartsView.addEventListener(TouchEvent.TOUCH, handler_chestTouch);	
						chestPartsView.setCountValueProperties(50*pxScale, 57*pxScale, 1);
						addChild(chestPartsView);
						
						chestPartsView.y = containerY + animation.pivotY + 10 * pxScale;
						chestPartsView.x = -80 * pxScale - chestsContainerX - overWidth;
						chestPartsView.skewX = -20 * Math.PI / 180;
						
						// додвигаем имеющиеся:
						alignChests(true, 0.3);
						
						newChestFinishX = chestsList.length > 0 ? chestsContainerX : (chestsContainerX + CHESTS_CONTAINER_WIDTH/2);
						
						TweenHelper.tween(chestPartsView, 0.35, {delay:newChestCounter * 0.2, x:newChestFinishX, transition:Transitions.EASE_IN}).
							chain(chestPartsView, 0.08, {x:(newChestFinishX+20), skewX:(20 * Math.PI / 180), transition:Transitions.EASE_IN, onComplete:(isDialogAppear ? null : chestPartsView.showSmokeExplosion)}).
							chain(chestPartsView, 0.45, {x:newChestFinishX, skewX:0, transition:Transitions.EASE_OUT_BACK});
						
						localChestsCountByType[storedChest.type] = 1;	
						chestsCountByType[storedChest.type] = 1;
						chestsList.push(chestPartsView);
						newChestCounter++;
					}
					else
					{
						if(storedChest.type in localChestsCountByType)
							localChestsCountByType[storedChest.type]++;
						else
							localChestsCountByType[storedChest.type] = 1;
						
						chestsCountByType[storedChest.type] = localChestsCountByType[storedChest.type];
					}
				}
			}
			
			length = chestsList.length;
			for (i = 0; i < length; i++) 
			{
				chestPartsView = chestsList[i];
				chestPartsView.countValue = chestsCountByType[chestPartsView.data.type];
			}
		}
		
		private function get chestsContainerX():int
		{
			return container.x - animation.pivotX - 208 * pxScale;
		}
		
		private function alignChests(forNew:Boolean, delay:Number = 0):void
		{
			if (chestsList.length <= 0)
				return;
				
			
			var chestsContainerX:int = (container.x - animation.pivotX - 208 * pxScale);
			
			if (!forNew && chestsList.length == 1) 
			{
				Starling.juggler.removeTweens(chestsList[0]);
				Starling.juggler.tween(chestsList[0], 0.25, {delay:j*0.3, x:(chestsContainerX + CHESTS_CONTAINER_WIDTH/2), skewX:0, transition:Transitions.EASE_OUT});
				return;
			}
			
			var expectСhestsCount:int = chestsList.length - (forNew ? 0 : 1);
			var stepX:int = CHESTS_CONTAINER_WIDTH / expectСhestsCount;
			for (var j:int = 0; j < chestsList.length; j++) 
			{
				Starling.juggler.removeTweens(chestsList[j]);
				Starling.juggler.tween(chestsList[j], 0.25, {delay:delay, x:(chestsContainerX + stepX * (expectСhestsCount - j)), skewX:0, transition:Transitions.EASE_OUT});
			}
		}
		
		private function handler_chestTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.currentTarget as DisplayObject);
			if (touch == null)
				return;
	
			var chestPartsView:ChestPartsView;	
			if (touch.phase != TouchPhase.ENDED) 
				return;
				
			if (model.freeSpins)
				return;
				
			chestPartsView = event.currentTarget as ChestPartsView;
		
			var storedChest:StoredChest = chestPartsView.data as StoredChest;
			
			gameManager.chestsData.removeStoredChestBySourceAndType(storedChest.source, storedChest.type);
			
			var chestData:ChestData = new ChestData(0);
			chestData.type = storedChest.type;
			chestData.seed = (Math.random() * (int.MAX_VALUE - 1)) + 1;
			
			//close();
			
			new ChestTakeOutCommand(chestData, null, null, true, SlotsModel.SOURCE_ID, null, false, false).execute();
			callShowReservedDropsOnClose = true;
			
			if (chestPartsView.countValue <= 1) 
			{
				delete chestsCountByType[storedChest.type];
				
				var index:int = chestsList.indexOf(chestPartsView);
				if (index != -1)
					chestsList.splice(index, 1);
				
				chestPartsView.removeFromParent();
				chestPartsView = null;
			}
			else {
				chestPartsView.countValue--;
				chestsCountByType[storedChest.type]--;
			}
			
			alignChests(false, 0);
		}
		
		private function randomSort(...args):int {
			return Math.random() > 0.5 ? -1 : 1;
		}
		
		private function get animationWidth():Number {
			return 680 * pxScale;
		}
		
		private function get animationHeight():Number {
			return 510 * pxScale;
		}
		
		/******************************************************************************************************************************************
		* 
		* 
		* 
		******************************************************************************************************************************************/
		
		private function actualizeCatType():void
		{
			commitAnimationType = betIndex % 2 == 0 ? SlotsAnimationState.HELL : SlotsAnimationState.HEAVEN;
			//trace('swapCatType ', commitAnimationType, _animationType, currentAnimationType, betIndex, betIndex % 2);
			
			if (commitAnimationType == _animationType) {
				commitAnimationType = null;
				return;
			}	
			
			handleActualizeCatType();
		}
		
		private function handleActualizeCatType():void
		{
			if (!commitAnimationType)
				return;
			
			//if(spinResult)
				//return;
				
			//trace('handleCommitSwapCat current:', _animationType, 'to: ', commitAnimationType, betIndex, betIndex % 2);	
				
			setAnimationState(SlotsAnimationState.APPEAR, commitAnimationType);
			
			Starling.juggler.delayCall(commitAnimationType == SlotsAnimationState.HEAVEN ? showAngelParticles : showHellParticles, 0.65);
			
			commitAnimationType = null;
		}
		
		private function showAngelParticles():void
		{
			var particleExplosion:ParticleExplosion = new ParticleExplosion(AtlasAsset.ScratchCardAtlas, "slots/spark_blue", null, 0);
			particleExplosion.setProperties(0, 0*pxScale, 3, -0.01, 0.05, 0, 1);
			particleExplosion.setFineProperties(0.7, 1.0, 0.5, 1.2, 0.5, 2);
			particleExplosion.setDirectionAngleProperties(0.03, 20, 0.1);
			particleExplosion.setEmitDirectionAngleProperties(1, Math.PI, 0);
			particleExplosion.x = -60 * pxScale;
			particleExplosion.y = -animationHeight/2 - 20 *pxScale;
			container.addChild(particleExplosion);
			//particleExplosion.startXAmplitude = 40 * pxScale;
			particleExplosion.startYAmplitude = 50 * pxScale;
			//particleExplosion.skewAplitude = 0.14;
			particleExplosion.play(870, 17, 5, 70);
			
			particleExplosion = new ParticleExplosion(AtlasAsset.ScratchCardAtlas, "slots/spark_blue", null, 0);
			particleExplosion.setProperties(0, 0*pxScale, 3, -0.01, 0.05, 0, 1);
			particleExplosion.setFineProperties(0.7, 1.0, 0.5, 1.2, 0.5, 2);
			particleExplosion.setDirectionAngleProperties(0.03, 20, 0.1);
			particleExplosion.setEmitDirectionAngleProperties(1, 0, 0);
			particleExplosion.x = -60 * pxScale;
			particleExplosion.y = -animationHeight/2 - 20 * pxScale;
			container.addChild(particleExplosion);
			//particleExplosion.startXAmplitude = 40 * pxScale;
			particleExplosion.startYAmplitude = 50 * pxScale;
			//particleExplosion.skewAplitude = 0.14;
			particleExplosion.play(870, 17, 5, 70);
		}
		
		private function showHellParticles():void
		{
			var particleExplosion:ParticleExplosion = new ParticleExplosion(AtlasAsset.ScratchCardAtlas, "slots/spark_yellow", null, 0);
			particleExplosion.setProperties(0, 0*pxScale, 3, -0.01, 0.05, 0, 1);
			particleExplosion.setFineProperties(0.7, 1.0, 0.5, 1.2, 0.5, 2);
			particleExplosion.setDirectionAngleProperties(0.03, 20, 0.1);
			particleExplosion.setEmitDirectionAngleProperties(1, Math.PI, 0);
			particleExplosion.x = 190 * pxScale;
			particleExplosion.y = -animationHeight/2 - 20 * pxScale;
			container.addChild(particleExplosion);
			//particleExplosion.startXAmplitude = 40 * pxScale;
			particleExplosion.startYAmplitude = 50 * pxScale;
			//particleExplosion.skewAplitude = 0.14;
			particleExplosion.play(570, 17, 5, 70);
			
			particleExplosion = new ParticleExplosion(AtlasAsset.ScratchCardAtlas, "slots/spark_yellow", null, 0);
			particleExplosion.setProperties(0, 0*pxScale, 3, -0.01, 0.05, 0, 1);
			particleExplosion.setFineProperties(0.7, 1.0, 0.5, 1.2, 0.5, 2);
			particleExplosion.setDirectionAngleProperties(0.03, 20, 0.1);
			particleExplosion.setEmitDirectionAngleProperties(1, 0, 0);
			particleExplosion.x = 190 * pxScale;
			particleExplosion.y = -animationHeight/2 - 20 *pxScale;
			container.addChild(particleExplosion);
			//particleExplosion.startXAmplitude = 40 * pxScale;
			particleExplosion.startYAmplitude = 50 * pxScale;
			//particleExplosion.skewAplitude = 0.14;
			particleExplosion.play(570, 17, 5, 70);
		}
		
		private function get currentAnimationState():String 
		{
			return animation.currentClip.gafTimeline.linkage.split('_')[1];
		}	
		
		private function addToFreeSpinsTotalItems(type:String, value:int):void
		{
			if (type in freeSpinsTotalItems) 
				freeSpinsTotalItems[type] += value;
			else 
				freeSpinsTotalItems[type] = value;
		}

		private function getFreeSpinsTotalItemsString():String
		{
			var sortedTotalStringTypes:Array = SlotMachineRewardType.sortedTotalStringTypes;
			var i:int;
			var length:int = sortedTotalStringTypes.length;
			var string:String;
			var type:String;
			for (i = 0; i < length; i++) 
			{
				type = sortedTotalStringTypes[i];
				if (!(type in freeSpinsTotalItems))
					continue;
				
				if (!string)
					string = 'TOTAL WIN: ';
				else
					string += ' + ';
					
				switch(type) {
					case SlotMachineRewardType.CASH_1:
						string += '$ ' + StringUtils.delimitThousands(freeSpinsTotalItems[type], ",");
						break;
					case SlotMachineRewardType.INSTABINGO:
						string += String(freeSpinsTotalItems[type]) + ' INSTANT BINGO';
						break;
					case SlotMachineRewardType.THREE_DAUBS:
						string += String(freeSpinsTotalItems[type]) + ' THREE DAUBS';
						break;
					case SlotMachineRewardType.GOLD_CHEST:
						string += String(freeSpinsTotalItems[type]) + ' GOLD CHEST';
						break;
					case SlotMachineRewardType.SUPER_CHEST:
						string += String(freeSpinsTotalItems[type]) + ' SUPER CHEST';
						break;
					case SlotMachineRewardType.DUST:
						string += String(freeSpinsTotalItems[type]) + ' DUST';
						break;	
				}
			}
			
			//$ 1,250 + 20 DUST + 1 SUPER CHEST 
			
			return string;
		}
		
		/*public static function getTypeByCommodityItemMessageType(type:String, value:int):String
		{
			switch(type)
			{
				
			}
		}*/
		
		private function betDisplayShowCurrentBet(animate:Boolean):void 
		{
			betDisplay.showIcon(true);
			
			if(animate)
				betDisplay.tweenText((model.betList[betIndex]).toString(), 0xFFFFFF, 62 * pxScale, false, 0.2);
			else	
				betDisplay.drawText((model.betList[betIndex]).toString(), 0xFFFFFF, 62 * pxScale);
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		private function handler_roundStartEnterFrame(e:Event):void
		{
			if (gameManager.deactivated || !Player.current)
				return;
			
			//if (!Player.current.hasCards || !Room.current || isNaN(Room.current.estimatedRoundEnd))
				//return;
			
			//var roundTimeLeft:Number = Room.current.estimatedRoundEnd - TimeService.serverTimeMs;
			var roundStartsIn:Number = Room.current.roundStartTime - TimeService.serverTimeMs;
			var bingosLeft:int = Room.current.bingosLeft;
			
			if (Room.current.currentRoundBallsCount > 0)
			{
				setRoundStartHint("ROUND IN PROGRESS: <font color=\"#FFFC00\">" + Room.current.currentRoundBallsCount.toString() + (Room.current.currentRoundBallsCount == 1 ?' BALL' : ' BALLS') + '</font>');
			}
			else
			{
				if (Room.current.roundStartTime != 0 || (Player.current && Player.current.isActivePlayer))
				{
					if (roundStartsIn < 0)
					{
						//setRoundStarted();
					}
					else
					{
						var minutesLeft:Number = int(roundStartsIn / 60 / 1000);
						var secondsLeft:Number = int((roundStartsIn / 1000) % 60);
						var secondsString:String = secondsLeft > 9 ? secondsLeft.toString() : "0" + secondsLeft.toString();
						
						timeToRoundStart = minutesLeft * 60 + secondsLeft;
						
						setRoundStartHint("ROUND STARTS IN: <font color=\"#FFFC00\">" + minutesLeft.toString() + ":" + secondsString + '</font>');
					}
				}
				else if (bingosLeft > 0)
				{
					setRoundStartHint("ROUND STARTS IN: <font color=\"#FFFC00\">" + bingosLeft + " BINGO" + (bingosLeft > 1 ? "S" : "") + '</font>');
				}
				else
				{
					setRoundStartHint("ROUND STARTS IN: <font color=\"#FFFC00\">WAIT...</font>");
				}
			}
		}
		
		private function setRoundStartHint(text:String):void 
		{
			if (roundStartHint.text == text)
				return;
			
			roundStartHint.text = text;
			
			var newX:int = (width - roundStartHint.textBounds.width)/2 + roundStartHint.pivotX + roundStartHint.textBounds.x + 25*pxScale;	
			
			if(Math.abs(roundStartHint.x - newX) > 12*pxScale)
				roundStartHint.x = newX;
		}
		
		/*private function handler_roundStartTimeout(event:Event):void 
		{
			if (int(event.data) <= 3 && !commitCloseFlag && (_state == CARD_BOUGHT || _state == SHOWING_WINNINGS)) 
			{
				if (state == CARD_BOUGHT)
				{
					scratchButton.isEnabled = false;
					scratchCardBody.touchable = false;
					scratchCardBody.finishScratch();
				}
			
				commitCloseFlag = true;	
				tryCloseDialog();
			}
		}*/
		
		private function handler_roundStarted(event:Event):void 
		{
			
			if (!model.hasAnyFreeSpins && !spinResult) {
				close();
				return;
			}
			
			timeToRoundStart = 0;
		}
		
		/******************************************************************************************************************************************
		* 
		* DEBUG:
		* 
		******************************************************************************************************************************************/
		
		private function debugShowDebugControls():void
		{
			debugControlsButtonQuad = new Quad(100, 100);
			debugControlsButtonQuad.alpha = 0;
			var j:JumpWithHintHelper = new JumpWithHintHelper(debugControlsButtonQuad, false, true);
			j.setStateCallbacks(function():void {
				debugButtonsContainer.visible = !debugButtonsContainer.visible;
			}, null);
			
			debugButtonsContainer = new Sprite();
			debugButtonsContainer.visible = false;
			container.addChild(debugButtonsContainer);
			
			debugControlsButtonQuad.x = -overWidth / 2;
			addChild(debugControlsButtonQuad);
			
			var _spinResult:SpinResult;
			
			/*debugAddDebugButton('lose twisting', function():void {
				_spinResult = new SpinResult();
				_spinResult.spinPattern = SpinPattern.TWISTING;
				//model.useSpin(SpinType.DEFAULT, betIndex, _spinResult);
				debugReleaseSpinButton(_spinResult);
			});*/
			
			debugAddDebugButton('loose simple', function():void {
				_spinResult = new SpinResult();
				_spinResult.reward = SlotMachineReward.create(SlotMachineRewardType.NO_WIN, null, 0);
				_spinResult.spinPattern = SpinPattern.SIMPLE;
				debugReleaseSpinButton(_spinResult);
			});
			
			/*debugAddDebugButton('win simple', function():void {
				_spinResult = new SpinResult();
				_spinResult.reward = model.getRandomReward();
				_spinResult.spinPattern = SpinPattern.SIMPLE;
				//model.useSpin(SpinType.DEFAULT, betIndex, _spinResult);
				debugReleaseSpinButton(_spinResult);
			});*/
			
			debugAddDebugButton('win free spins', function():void {
				_spinResult = new SpinResult();
				_spinResult.reward = SlotMachineReward.create(SlotMachineRewardType.FREE_SPINS, /*CommodityItem.create(CommodityType.SLOT_FREE_SPINS, null, 3)*/ null, 10);
				_spinResult.reward.stake = model.betList[betIndex]; 
				//_spinResult.betIndex = betIndex;
				//_spinResult.reward = SlotMachineReward.create(SlotMachineRewardType.FREE_SPINS, SlotMachineRewardType.getComboItemByString(SlotMachineRewardType.FREE_SPINS), 10);
				_spinResult.spinPattern = SpinPattern.TWISTING;
				//model.useSpin(SpinType.DEFAULT, betIndex, _spinResult);
				debugReleaseSpinButton(_spinResult);
			});
			
			debugAddDebugButton('win cash 1', function():void {
				_spinResult = new SpinResult();
				_spinResult.reward = SlotMachineReward.create(SlotMachineRewardType.CASH_1, /*model.getCommodityItemByTypeAndStake(SlotMachineRewardType.CASH_1, stake)*/ null, 10);
				_spinResult.spinPattern = SpinPattern.SIMPLE;
				//model.useSpin(SpinType.DEFAULT, betIndex, _spinResult);
				debugReleaseSpinButton(_spinResult);
			});
			
			debugAddDebugButton('win cash 2', function():void {
				_spinResult = new SpinResult();
				_spinResult.reward = SlotMachineReward.create(SlotMachineRewardType.CASH_2, /*model.getCommodityItemByTypeAndStake(SlotMachineRewardType.CASH_2, stake)*/ null, 10);
				_spinResult.spinPattern = SpinPattern.SIMPLE;
				//model.useSpin(SpinType.DEFAULT, betIndex, _spinResult);
				debugReleaseSpinButton(_spinResult);
			});
			
			debugAddDebugButton('win packs', function():void {
				_spinResult = new SpinResult();
				_spinResult.reward = SlotMachineReward.create(SlotMachineRewardType.PACKS, null, 10);
				_spinResult.spinPattern = SpinPattern.SIMPLE;
				//model.useSpin(SpinType.DEFAULT, betIndex, _spinResult);
				debugReleaseSpinButton(_spinResult);
			});
			
			debugAddDebugButton('win cases', function():void {
				_spinResult = new SpinResult();
				_spinResult.reward = SlotMachineReward.create(SlotMachineRewardType.CASES, model.getCommodityItemByTypeAndStake(SlotMachineRewardType.CASES, model.betList[betIndex]), 10);
				_spinResult.spinPattern = SpinPattern.SIMPLE;
				//model.useSpin(SpinType.DEFAULT, betIndex, _spinResult);
				debugReleaseSpinButton(_spinResult);
			});
			
			debugAddDebugButton('win sacks', function():void {
				_spinResult = new SpinResult();
				_spinResult.reward = SlotMachineReward.create(SlotMachineRewardType.SACKS, null, 10);
				_spinResult.spinPattern = SpinPattern.SIMPLE;
				//model.useSpin(SpinType.DEFAULT, betIndex, _spinResult);
				debugReleaseSpinButton(_spinResult);
			});
			
			debugAddDebugButton('win safe', function():void {
				_spinResult = new SpinResult();
				_spinResult.reward = SlotMachineReward.create(SlotMachineRewardType.VAULTS, /*model.getCommodityItemByTypeAndStake(SlotMachineRewardType.VAULTS, stake)*/ null, 10)
				_spinResult.spinPattern = SpinPattern.TWISTING;
				//model.useSpin(SpinType.DEFAULT, betIndex, _spinResult);
				debugReleaseSpinButton(_spinResult);
			});
			
			debugAddDebugButton('win dust', function():void {
				_spinResult = new SpinResult();
				_spinResult.reward = SlotMachineReward.create(SlotMachineRewardType.DUST, model.getCommodityItemByTypeAndStake(SlotMachineRewardType.DUST, model.betList[betIndex]), 10);
				_spinResult.spinPattern = SpinPattern.SIMPLE;
				//model.useSpin(SpinType.DEFAULT, betIndex, _spinResult);
				debugReleaseSpinButton(_spinResult);
			});
			
			debugAddDebugButton('win gold chest', function():void {
				_spinResult = new SpinResult();
				_spinResult.reward = SlotMachineReward.create(SlotMachineRewardType.GOLD_CHEST, CommodityItem.create(CommodityType.CHEST, ChestType.GOLD.toString(), 1), 10);
				_spinResult.spinPattern = SpinPattern.SIMPLE;
				//model.useSpin(SpinType.DEFAULT, betIndex, _spinResult);
				debugReleaseSpinButton(_spinResult);
			});
			
			debugAddDebugButton('win super chest', function():void {
				_spinResult = new SpinResult();
				_spinResult.reward = SlotMachineReward.create(SlotMachineRewardType.SUPER_CHEST, CommodityItem.create(CommodityType.CHEST, ChestType.SUPER.toString(), 1), 10);
				_spinResult.spinPattern = SpinPattern.TWISTING;
				//model.useSpin(SpinType.DEFAULT, betIndex, _spinResult);
				debugReleaseSpinButton(_spinResult);
			});
			
			debugAddDebugButton('win instabingo', function():void {
				_spinResult = new SpinResult();
				_spinResult.reward = SlotMachineReward.create(SlotMachineRewardType.INSTABINGO, model.getCommodityItemByTypeAndStake(SlotMachineRewardType.INSTABINGO, model.betList[betIndex]), 10);
				_spinResult.spinPattern = SpinPattern.SIMPLE;
				//model.useSpin(SpinType.DEFAULT, betIndex, _spinResult);
				debugReleaseSpinButton(_spinResult);
			});
			
			debugAddDebugButton('win triple daub', function():void {
				_spinResult = new SpinResult();
				_spinResult.reward = SlotMachineReward.create(SlotMachineRewardType.THREE_DAUBS, model.getCommodityItemByTypeAndStake(SlotMachineRewardType.THREE_DAUBS, model.betList[betIndex]), 10);
				_spinResult.spinPattern = SpinPattern.SIMPLE;
				//model.useSpin(SpinType.DEFAULT, betIndex, _spinResult);
				debugReleaseSpinButton(_spinResult);
			});
			
			/*debugAddDebugButton('swap cat', function():void 
			{
				commitAnimationType = _animationType == SlotsAnimationState.HEAVEN ? SlotsAnimationState.HELL : SlotsAnimationState.HEAVEN;
				handleCommitSwapCat();
			});*/
			
			debugAddDebugButton('add powerup minigame', function():void 
			{
				var p:Array = [PowerupType.SPIN_5, PowerupType.SPIN_10, PowerupType.SPIN_25, PowerupType.SPIN_50];
				var minigameDrop:Minigame = new Minigame(p[Math.floor(Math.random() * p.length)], 1);
				gameManager.slotsModel.addBonusSpin(minigameDrop);
			});
			
			/*debugAddDebugButton('tween text test 1', function():void 
			{
				indicator.showTotalText('TOTAL WIN: $ 1,250 + 20 DUST + 1 SUPER CHEST + 2 TRIPLE DOUB', 'CASH: $2,500', 0.2);
			});
			
			debugAddDebugButton('tween text test 2', function():void 
			{
				indicator.showTotalText('TOTAL WIN: $ 25', 'CASH: $2,500', 0.2);
			});
			
			debugAddDebugButton('megawin 25', function():void {
				setAnimationState(SlotsAnimationState.WIN, _animationType);
				indicator.showCashMegaWin(25, 12345, 2);
			});
			debugAddDebugButton('megawin 50', function():void {
				setAnimationState(SlotsAnimationState.WIN, _animationType);
				indicator.showCashMegaWin(50, 12345, 2);
			});
			debugAddDebugButton('megawin 100', function():void {
				setAnimationState(SlotsAnimationState.WIN, _animationType);
				indicator.showCashMegaWin(100, 12345, 2);
				
				backgroundEffects.showWinEffect(_animationType);
				Starling.juggler.delayCall(backgroundEffects.completeEffect, 3); 
			});
			debugAddDebugButton('megawin 250', function():void {
				setAnimationState(SlotsAnimationState.WIN, _animationType);
				indicator.showCashMegaWin(250, 12345, 2);
				
				backgroundEffects.showWinEffect(_animationType);
				Starling.juggler.delayCall(backgroundEffects.completeEffect, 3); 
			});
			debugAddDebugButton('megawin 500', function():void {
				setAnimationState(SlotsAnimationState.WIN, _animationType);
				indicator.showCashMegaWin(500, 12345, 2);
				
				backgroundEffects.showWinEffect(_animationType);
				Starling.juggler.delayCall(backgroundEffects.completeEffect, 3); 
			});
			debugAddDebugButton('megawin 1000', function():void {
				setAnimationState(SlotsAnimationState.WIN, _animationType);
				indicator.showCashMegaWin(1000, 12345, 2);
				
				backgroundEffects.showWinEffect(_animationType);
				Starling.juggler.delayCall(backgroundEffects.completeEffect, 6); 
			});
			debugAddDebugButton('megawin 10000', function():void {
				setAnimationState(SlotsAnimationState.WIN, _animationType);
				indicator.showCashMegaWin(10000, 12345, 2);
				
				backgroundEffects.showWinEffect(_animationType);
				Starling.juggler.delayCall(backgroundEffects.completeEffect, 10); 
			});*/
			
			
			debugAddDebugButton('tween text 1', function():void 
			{
				//indicator.showText('', 0xFFFFFF, 10);
				
				indicator.showTextSequence(["WIN: <font color=\"#ffffff\">20</font> DUST", "DUST: <font color=\"#ffffff\">230</font>", indicator.defaultMessage], 
					[SlotMachineIndicator.COLOR_GREEN, SlotMachineIndicator.COLOR_GREEN, indicator.defaultColor],
					[indicator.defaultTextSize, indicator.defaultTextSize, indicator.defaultTextSize], 
					0.0, 1.1, 0.33, false);
				
			});
			
			debugAddDebugButton('tween text 2', function():void {
				//indicator.showText(indicator.defaultMessage, 0x0075FC, 52);
				indicator.showCashMegaWin(125, 1244, 2);
			});
			
			debugAddDebugButton('tween text 3', function():void 
			{
				//indicator.showText('VERY LONG MI MI!', 0xFF0000, 60);
				
				indicator.showTextSequence(['CASH: $'+Player.current.cashCount.toString(), indicator.defaultMessage], 
					[SlotMachineIndicator.COLOR_PURPLE, indicator.defaultColor],
					[indicator.defaultTextSize, indicator.defaultTextSize], 
					0, 1.0, 0.35, false);
								
			});
			
			debugAddDebugButton('tween text 4', function():void 
			{
				//indicator.showText('micro', 0xFF00FF, 30);
				
				indicator.showTextSequence(['WIN: 20 DUST', 'DUST: 230', indicator.defaultMessage], 
					[SlotMachineIndicator.COLOR_GREEN, SlotMachineIndicator.COLOR_GREEN, indicator.defaultColor],
					[indicator.defaultTextSize, indicator.defaultTextSize, indicator.defaultTextSize], 
					2.0, 1.1, 0.33, false);
				
			});
			
			debugAddDebugButton('tween text 5', function():void 
			{
				//indicator.showText('GOOD LUCK 1 GOOD LUCK 2 GOOD LUCK 3 GOOD LUCK 4 GOOD LUCK 5 GOOD LUCK 6', 0x0075FC, 52*pxScale);
				//indicator.tweenText(2);
				/*indicator.textSequence(['Testing', 'text', 'sequence', '1', '2', '3'], 
					[0x0075FC, 0xFF0000, 0xFF00FF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF],
					[50, 55, 60, 20, 40, 60], 
					0.5, 0.7, true);*/
			});
			
			debugAddDebugButton('tween text 6', function():void 
			{
				/*indicator.textSequence(['/', '-', "\\", '|'], 
					[0x00DD00, 0x00DD00, 0x00DD00, 0x00DD00],
					[70, 70, 70, 70], 
					0.01, 0.04, true);*/
			});
			
			debugAddDebugButton('tween text 7', function():void 
			{
				/*indicator.textSequence(['*-----','-*----', '--*---', '---*--','----*-', '-----*'], 
					[0x00DD00, 0x00DD00, 0x00DD00, 0x00DD00, 0x00DD00, 0x00DD00],
					[70, 70, 70, 70, 70, 70], 
					0.001, 0.2, true);*/
			});
		}
		
		private function debugReleaseSpinButton(debugSpinResult:SpinResult):void
		{
			/*spinButton.scale = spinButtonHelper.minScale;
			spinButtonHelper.setEnabled(false, false);
			spinButton.isEnabled = false;*/
			
			Starling.juggler.delayCall(enableSpinButton, 3);
			
			spin(-1, debugSpinResult);
		}	
		
		private var debugButtonsCounter:int;
		
		private var debugButtonsContainer:Sprite;
		
		private function debugAddDebugButton(title:String, onComplete:Function):void
		{
			var button:XButton;
			button = new XButton(new XButtonStyle({upState: "buttons/gray_base", atlas:AtlasAsset.CommonAtlas, textFieldStyle:new XTextFieldStyle({fontSize:24.0, fontColor:0x000000})}), title);
			button.scale = 0.5;
			button.addEventListener(Event.TRIGGERED, function(e:Event):void {onComplete()});
			button.x = width / 2 - button.width - 6*pxScale;
			button.y = (button.height + 5*pxScale) * debugButtonsCounter++ - 300 * pxScale;
			debugButtonsContainer.addChild(button);
		}	
	}

}

import com.alisacasino.bingo.assets.AtlasAsset;
import com.alisacasino.bingo.assets.Fonts;
import com.alisacasino.bingo.assets.SoundAsset;
import com.alisacasino.bingo.components.effects.ParticleExplosion;
import com.alisacasino.bingo.controls.BingoTextFormat;
import com.alisacasino.bingo.models.slots.SlotsAnimationState;
import com.alisacasino.bingo.resize.ResizeUtils;
import com.alisacasino.bingo.utils.EffectsManager;
import com.alisacasino.bingo.utils.sounds.SoundManager;
import com.alisacasino.bingo.utils.UIUtils;
import com.alisacasino.bingo.utils.disposal.DisposalUtils;
import feathers.core.FeathersControl;
import starling.animation.Transitions;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Align;
import starling.utils.TweenHelper;

class BackgroundEffects extends FeathersControl 
{
	public function BackgroundEffects() 
	{
		background = new Sprite();
		addChild(background);
		//touchable = false;
	}
	
	private var background:Sprite;
	//private var quad:Quad;
	private var type:String;
	private var topRaysContainer:Sprite;
	private var bottomRaysContainer:Sprite;
	
	override protected function draw():void 
	{
		super.draw();
		
		if (isInvalid(INVALIDATION_FLAG_SIZE)) 
		{
			setSizeInternal(layoutHelper.stageWidth/parent.scale, layoutHelper.stageHeight/parent.scale, false);
			/*
			if (quad) {
				
				quad.width = width;
				quad.height = height;
				
				background.x = width / 2;
				background.y = height;
				
			}*/
			
			
			//trace(layoutHelper.stageWidth/parent.scale, layoutHelper.stageHeight/parent.scale, width, height);
		}
	}
	
	public function showWinEffect(type:String, short:Boolean = false):void
	{
		this.type = type;
		
		if (type == SlotsAnimationState.HELL) 
			showHellEffect(short);
		else if (type == SlotsAnimationState.HEAVEN) 
			showHeavenEffect(short);
	}
	
	public function showHeavenEffect(short:Boolean):void
	{
		addChild(background);
		
		var bg:Quad = new Quad(1, 1, 0x000066);
		bg.width = width;// * pxScale;
		bg.height = height;// * pxScale;
		bg.pivotX = 0.5;
		bg.pivotY = 0.5;
		background.addChild(bg);
		
		background.x = width / 2;
		background.y = height/2;
		background.alpha = 0;
		background.scale = 1;
		background.pivotY = 0;
		
		var puffScale:Number = 9;
		var puffColor:uint = 0x94F6FA;	
		addHeavenPuffToBackground(puffScale, puffScale, puffColor);
		addHeavenPuffToBackground(-puffScale, puffScale, puffColor);
		addHeavenPuffToBackground(puffScale, -puffScale, puffColor);
		addHeavenPuffToBackground(-puffScale, -puffScale, puffColor);
		
		topRaysContainer = new Sprite();
		topRaysContainer.x = width / 2;
		topRaysContainer.y = height/2;
		topRaysContainer.alpha = 0;
		addChild(topRaysContainer);
		
		bottomRaysContainer = new Sprite();
		bottomRaysContainer.x = width / 2;
		bottomRaysContainer.y = height/2;
		bottomRaysContainer.alpha = 0;
		addChild(bottomRaysContainer);
		
		var i:int;
		var length:int = 12;
		var ray:Image;
		var rayAngle:Number = (2 * Math.PI) / length;
		var rayScale:Number;
		for (i = 0; i < length; i++) 
		{
			ray = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/ray'));
			ray.alignPivot(Align.RIGHT, Align.CENTER);
			
			if (isNaN(rayScale))
				rayScale = (Math.pow(Math.pow(width/2, 2) + Math.pow(height/2, 2), 0.5)*1.1)/ ray.width;
			
			ray.scale = rayScale;
			ray.rotation = rayAngle * i;
			topRaysContainer.addChild(ray);
			
			ray = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/ray'));
			ray.alignPivot(Align.RIGHT, Align.CENTER);
			ray.scale = rayScale;
			ray.alpha = 0.3;
			ray.rotation = rayAngle * i;
			bottomRaysContainer.addChild(ray);
		}
		
		Starling.juggler.tween(background, 0.5, {alpha:1, delay:0.1});
		
		Starling.juggler.tween(topRaysContainer, 0.3, {alpha:1});
		Starling.juggler.tween(topRaysContainer, 6, {rotation:(2 * Math.PI), repeatCount:0});
			
		Starling.juggler.tween(bottomRaysContainer, 0.3, {alpha:1});
		Starling.juggler.tween(bottomRaysContainer, 6, {rotation:( -2 * Math.PI), repeatCount:0});	
		
		SoundManager.instance.playSfx(SoundAsset.SlotsHeavensGates, 0.2);
	}
	
	public function showHellEffect(short:Boolean):void
	{
		addChild(background);
		
		/*quad = new Quad(1, 1, 0x000066);
		quad.alpha = 0.0;
		addChild(quad);*/
		
		var image:Image = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/hell_glory'));
		image.x = -image.width;
		background.addChild(image);
		
		image = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/hell_glory'));
		image.scaleX = -1;
		image.x = image.width;
		background.addChild(image);
		
		background.pivotY = image.height;
		background.x = width / 2;
		background.y = height;
		background.scale = 0;
		background.alpha = 1;
		
		TweenHelper.tween(background, 0.3, {scale:4.8}).
			chain(background, 0.3, {scale:4.2}).
			chain(background, 0.6, {y:(height + 140*pxScale), repeatCount:0, reverse:true});
		
		showHellParticles(short ? 850 : 2000);
		
		SoundManager.instance.playSfx(SoundAsset.SlotsFireBurning, 0.2);
		SoundManager.instance.playSfx(Math.random() > 0.5 ? SoundAsset.SlotsCatMeow_1 : SoundAsset.SlotsCatMeow_2, 0.1, 0, 1);
	}
	
	public function showHellParticles(time:int):void
	{
		var particleEffect:ParticleExplosion = new ParticleExplosion(AtlasAsset.ScratchCardAtlas, new <String> ["slots/red_puff"], null);
		particleEffect.setProperties(0, 0, 12, -0.0055, 0.03, 0, 0.4);
		particleEffect.setFineProperties(0.6, 0.9, 0.4, 1.5, 0, 0);
		particleEffect.setDirectionAngleProperties(0.02, 20, 0.1);
		particleEffect.setProperties(0, 0, 12, -0.0025, 0.03, 0, 0.4);
		particleEffect.setFineProperties(0.6, 0.7, 0.4, 1.5, 0, 0);
		particleEffect.setDirectionAngleProperties(0.02, 10, 0.1);
		particleEffect.onlyPositiveSpeed = true;
		particleEffect.setAccelerationProperties(-0.13);	
		particleEffect.gravityAcceleration = 0.07;
		//particleEffect.skewAplitude = 0.2;
		//particleEffect.skewTweensDelay = 1000;
		//particleEffect.lifetime = 5000;
		//particleEffect.scaleSpeedRandomAmplitude = 0.0050;
		//particleEffect.scaleMin = 0.75;
		//particleEffect.scaleMax = 2.5;
		particleEffect.setEmitDirectionAngleProperties(1, -Math.PI/2, 120 * Math.PI / 180);

		particleEffect.startXAmplitude = width * 0.8;
		particleEffect.x = width * 0.1;
		particleEffect.y = height;
		
		addChild(particleEffect);
		particleEffect.play(time, 60, 20, 30);
	}
	
	public function completeEffect():void
	{
		if (type == SlotsAnimationState.HELL) 
		{
			Starling.juggler.removeTweens(background);
			Starling.juggler.tween(background, 0.5, {scale:0, onComplete:clean});
		}
		else if (type == SlotsAnimationState.HEAVEN) 
		{
			Starling.juggler.tween(background, 0.4, {alpha:0});
			Starling.juggler.tween(topRaysContainer, 0.2, {alpha:0, delay:0.3});
			Starling.juggler.tween(bottomRaysContainer, 0.2, {alpha:0, delay:0.3, onComplete:clean});
		}
	}
	
	private function addHeavenPuffToBackground(_scaleX:Number, _scaleY:Number, _color:uint):void 
	{
		var puff:Image = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/heaven_glory'));
		puff.alignPivot(Align.RIGHT, Align.BOTTOM);
		puff.scaleX = _scaleX;
		puff.scaleY = _scaleY;
		puff.color = _color;
		background.addChild(puff);
	}
	
	private function clean():void
	{
		DisposalUtils.destroy(this, true);
		
		//background = null;
		bottomRaysContainer = null;
		topRaysContainer = null;
		type = null;
	}
}

class BetDisplay extends Sprite
{
	private var container:Sprite;
	
	private var textField:TextField;
	private var textGlow:Image;
	
	private var betImage:Image;
	private var betImageGlow:Image;
	
	private var sequenceList:Array = [];
	private var loopSequence:int;
	private var sequenceTime:Number;
	private var sequenceDelay:Number;
	
	private var expectWidth:int;
	private var expectHeight:int;
	
	public function BetDisplay(width:int, height:int) 
	{
		var contentGap:int = 4*pxScale;
		
		container = new Sprite();
		container.x = contentGap;
		container.y = contentGap;
		addChild(container);
		
		var maskQuad:Quad = new Quad(1, 1, 0x1A1A1A);
		maskQuad.width = width - 2*contentGap;
		maskQuad.height = height - 2*contentGap;
		container.mask = maskQuad;
		
		textGlow = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/text_glow'));
		textGlow.pivotX = 60.5*pxScale;
		textGlow.pivotY = 46*pxScale;
		textGlow.alpha = 0.55;
		textGlow.scale9Grid = ResizeUtils.getScaledRect(60, 45, 1, 2);
		//textGlow.color = 0x0075FC;
		container.addChild(textGlow);
	
		
		betImageGlow = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/text_glow'));
		betImageGlow.pivotX = 60.5*pxScale;
		betImageGlow.pivotY = 46*pxScale;
		betImageGlow.alpha = 0.55;
		betImageGlow.scale9Grid = ResizeUtils.getScaledRect(60, 45, 1, 2);
		betImageGlow.color = 0x0075FC;
		container.addChild(betImageGlow);
		
		UIUtils.addTile3Images(container, AtlasAsset.ScratchCardAtlas.getTexture('slots/bet_display_mask_cross_0'), AtlasAsset.ScratchCardAtlas.getTexture('slots/bet_display_mask_cross_1'), 255*pxScale);
		
		betImage = new Image(AtlasAsset.CommonAtlas.getTexture('bars/cash'));
		betImage.alignPivot();
		betImage.x = 44 * pxScale;
		betImage.y = 36 * pxScale;
		betImage.scale = 0.85;
		container.addChild(betImage);
		
		var bingoTextFormat:BingoTextFormat = new BingoTextFormat(Fonts.MATRIX_COMPLEX, 58 * pxScale, 0x00BDFF, Align.CENTER);
		textField = new TextField(174*pxScale, 77*pxScale, '', bingoTextFormat);
		textField.alignPivot();
		textField.x = /*textField.pivotX + */165 * pxScale;
		textField.y = /*textField.pivotY + */39 * pxScale;
		container.addChild(textField);
		
		var maskDots:Image = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/bet_display_dots_mask'));
		maskDots.tileGrid = ResizeUtils.getScaledRect(0, 0, 10, 0);
		maskDots.width = 252*pxScale; 
		maskDots.x = 5 *pxScale;
		maskDots.y = 5 *pxScale;
		addChildAt(maskDots, 0);
		
		var backgroundColored:Image = new Image(AtlasAsset.CommonAtlas.getTexture('quests/inner_bg'));
		backgroundColored.scale9Grid = ResizeUtils.getScaledRect(14, 14, 2, 2);
		backgroundColored.color = 0x1A1A1A;
		backgroundColored.x = 1 * pxScale;
		backgroundColored.y = 1*pxScale;
		backgroundColored.width = width-2*pxScale;
		backgroundColored.height = height-2*pxScale;
		addChildAt(backgroundColored, 0);
		
		var borderFrame:Image = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/rounded_border'));
		borderFrame.scale9Grid = ResizeUtils.getScaledRect(13, 13, 1, 1);
		borderFrame.width = width;
		borderFrame.height = height;
		addChild(borderFrame);
		
		betImageGlow.color = 0xC252FB;
		refreshBetImageGlow();
		
		expectWidth = width;
		expectHeight = height;
	}
	
	public function textSequence(texts:Array, colors:Array, sizes:Array, time:Number, delay:Number, loop:Boolean):void 
	{
		sequenceList.splice(0, sequenceList.length);
		
		for (var i:int = 0; i < texts.length; i++) {
			sequenceList[i] = [texts[i], colors[i], sizes[i]];
		}
		
		loopSequence = loop ? 0 : -1;
		sequenceTime = time;
		sequenceDelay = delay;
		
		showNextFromSequence();
	}
	
	private function showNextFromSequence():void 
	{
		var params:Array;
		if (loopSequence == -1) {
			params = sequenceList.shift();
		}	
		else {
			params = sequenceList[loopSequence];
			loopSequence++;
			if (loopSequence >= sequenceList.length)
				loopSequence = 0;
		}
		
		if(params)
			tweenText(params[0], params[1], params[2]*pxScale, true, sequenceTime, sequenceDelay, showNextFromSequence);
	}
	
	public function tweenText(text:String, color:uint, size:int, linearScale:Boolean = false, time:Number = 0.5, delay:Number = 0, onComplete:Function = null):void 
	{
		if (textField.text == text)
			return;
		
		Starling.juggler.removeTweens(textField);
		
		if (time == 0) {
			if(delay == 0)
				changeText(text, color, size);
			//else
				//Starling.juggler.delayCall(changeText, 
			return;
		}
		
		if (text == '') {
			
			TweenHelper.tween(textField, 0.4*time, {delay:delay, scaleX:1.3, scaleY:0, transition:Transitions.EASE_IN_BACK, onUpdate:refreshTextGlow, onComplete:completeCleanText, onCompleteArgs:[onComplete]})
		}
		else 
		{
			if (textField.text == '') 
			{
				changeText(text, textField.format.color, textField.format.size);
				textField.scaleX = 1.3;
				textField.scaleY = 0;
				TweenHelper.tween(textField, 0.4*time, {delay:delay, scaleX:1, scaleY:1, transition:Transitions.EASE_OUT_BACK, onUpdate:refreshTextGlow, onComplete:onComplete})
			}
			else {
				TweenHelper.tween(textField, 0.4*time, {delay:delay, scaleX:1.3, scaleY:0, transition:Transitions.EASE_IN_BACK, onUpdate:refreshTextGlow, onComplete:changeText, onCompleteArgs:[text, color, size]})
			.chain(textField, 0.6*time, {scaleX:1, scaleY:1, onUpdate:refreshTextGlow, transition:Transitions.EASE_OUT_BACK, onComplete:onComplete});
			//textField.scale = 1;
			}
		}
	}
	
	public function tweenIntText(from:int, to:int, time:Number = 0.5):void 
	{
		EffectsManager.animateIntHelper(from, to, labelSetter, time);
	}
	
	private function completeCleanText(onComplete:Function = null):void 
	{
		changeText('', textField.format.color, textField.format.size);
		refreshTextGlow();
		if (onComplete != null)
			onComplete();
	}
	
	private function changeText(text:String, color:uint, size:int):void 
	{
		textField.text = text;
		textGlow.color = color;
		if (textField.format.color != color || textField.format.size != size) 
		{
			textField.format.size = size/* * pxScale*/;
			textField.format.color = color;
			textField.setRequiresRedraw();
		}
	}
	
	public function drawText(text:String, color:uint, size:int):void 
	{
		changeText(text, color, size)
		
		refreshTextGlow();
		
		Starling.juggler.removeTweens(textGlow);
		TweenHelper.tween(textGlow, 0.06, {alpha:0.38, repeatCount:0});
		
		Starling.juggler.removeTweens(betImageGlow);
		TweenHelper.tween(betImageGlow, 0.06, {alpha:0.38, repeatCount:0});
	}
	
	public function showIcon(value:Boolean):void 
	{
		if (value)
		{
			if (!betImage.visible)
			{
				betImageGlow.visible = true;
				betImage.visible = true;
				
				textField.width = 174 * pxScale;
				textField.height = 77 * pxScale;
				textField.alignPivot();
				textField.x = 165 * pxScale;
				textField.y = 39 * pxScale;
			}
		}
		else
		{
			if (betImage.visible)
			{
				betImageGlow.visible = false;
				betImage.visible = false;
				
				textField.width = expectWidth;
				textField.height = expectHeight;
				textField.alignPivot();
				textField.x = expectWidth/2;
				textField.y = expectHeight/2;
			}
		}
	}
	
	public function refreshTextGlow():void 
	{
		if (textField.text != '') {
			textGlow.visible = true;
			textGlow.x = textField.x;
			textGlow.width = (textField.textBounds.width + 66*pxScale) * textField.scale;
			textGlow.y = textField.y;
			textGlow.height = (textField.textBounds.height + 50*pxScale) * textField.scale;
			
			if (textField.scaleX * textField.scaleY < 1)
				textGlow.scale = textField.scaleX * textField.scaleY;
		}
		else {
			textGlow.visible = false;
		}
	}
	
	public function refreshBetImageGlow():void 
	{
		if (betImage) {
			betImageGlow.visible = true;
			betImageGlow.x = betImage.x;
			betImageGlow.width = (betImage.width + 66*pxScale)// * betImage.scale;
			betImageGlow.y = betImage.y;
			betImageGlow.height = (betImage.height + 50*pxScale)// * betImage.scale;
			//textGlow.scale = ;
		}
		else {
			betImageGlow.visible = false;
		}
	}
	
	public function labelSetter(value:int):void 
	{
		changeText(value.toString(), textField.format.color, textField.format.size);
		refreshTextGlow();
	}
	
	private function removeView(view:DisplayObject):void {
		view.removeFromParent();
	}
	
}

/*class StoredChestRenderer extends Sprite 
{
	public function StoredChestRenderer() {
		
	}
}*/