package com.alisacasino.bingo.screens.lobbyScreenClasses
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.Fonts;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.components.ClockTimerView;
	import com.alisacasino.bingo.components.FadeQuad;
	import com.alisacasino.bingo.controls.BingoTextFormat;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.chests.ChestOpenDialog;
	import com.alisacasino.bingo.dialogs.chests.ChestPartsView;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.TutorialManager;
	import com.alisacasino.bingo.models.chests.ChestData;
	import com.alisacasino.bingo.models.chests.ChestsData;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.JumpWithHintHelper;
	import com.alisacasino.bingo.utils.StringUtils;
	import com.alisacasino.bingo.utils.TimeService;
	import feathers.core.FeathersControl;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.utils.Timer;
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
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	import starling.text.TextField;
	import starling.utils.Align;
	
	public class ChestSlotView extends FeathersControl
	{
		static public const WIDTH:int = 206;
		static public const HEIGHT:int = 226;
		
		static private const FREE_SLOT_TEXTFIELD_ALPHA:Number = 0.70;
		
		static public const STATE_INIT:String = "STATE_INIT";
		static public const STATE_LOBBY:String = "STATE_LOBBY";
		static public const STATE_BUY_CARDS:String = "STATE_BUY_CARDS";
		static public const STATE_ACTIVATE:String = "STATE_ACTIVATE";
		static public const STATE_READY:String = "STATE_READY";
		static public const STATE_NEW_APPEAR:String = "STATE_NEW_APPEAR";
		
		private var _state:String = STATE_INIT;
		private var _previousState:String; 
		
		private var _data:ChestData;
		private var index:int;
		
		private var background:Image;
		private var freeSlotTextField:XTextField;
		private var timeoutBg:Image;
		private var backgroundAnimation:AnimationContainer;
		private var chestIcon:ChestPartsView;
		private var padlockIcon:Image;
		private var timeoutLabel:TextField;
		private var shineRaysImage:Image;
		
		private var cashTitleLabel:XTextField;
		private var cashIcon:Image;
		private var cashValueLabel:XTextField;
		
		private var openLabel:XTextField;
		
		private var timerBg:Image;
		private var clockTimerView:ClockTimerView;
		
		private var smokeExplosion:AnimationContainer;
		
		private var timer:Timer;
		
		private var lastTimeoutValue:int = int.MIN_VALUE;
		
		private var splashAnimation:AnimationContainer;
		private var	chestBackgroundTimeline:String;
		
		private var lastCashValueWidth:int;
		
		private static var STATIC_TIMEOUT_STRING_FORMAT:Vector.<String> = new < String > ['H', 'm', 'm', 'sec', 'sec', '  ', '  ', '', ''];
		
		private var tutorialChestIcon:ChestPartsView;
		
		public var jumpHelper:JumpWithHintHelper;
		
		public function ChestSlotView(index:uint, data:ChestData)
		{
			this.index = index;
			_data = data;
			setSizeInternal(WIDTH * pxScale, HEIGHT * pxScale, false);
			//addChild(new Quad(WIDTH*pxScale, HEIGHT*pxScale, 0xFF0000))
		}
		
		public function get state():String
		{
			return _state;
		}
		
		public function set state(value:String):void 
		{
			//trace('ChestSlotView set state', _data.index, _state, value);
			if (_state != value)
			{
				_previousState = _state;
				
				_state = value;
				invalidate(INVALIDATION_FLAG_STATE);
			}
		}
		
		public function get data():ChestData 
		{
			return _data;
		}
		
		public function set data(value:ChestData):void 
		{
			if (_data != value)
			{
				_data = value;
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		public function forceShowPadlockAndTime(delay:Number):void {
			Starling.juggler.delayCall(handleTimer, delay, true);
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			background = new Image(AtlasAsset.CommonAtlas.getTexture("controls/chest/chest_slot_bg"));
			background.scale9Grid = ResizeUtils.getScaledRect(25, 20, 2, 2);
			background.width = 206*pxScale;
			background.height = 226*pxScale;
			addChild(background);
			
			freeSlotTextField = new XTextField(WIDTH * pxScale, 80 * pxScale, XTextFieldStyle.FreeChestSlot);
			freeSlotTextField.y = 89 * pxScale;
			freeSlotTextField.touchable = false;
			freeSlotTextField.alpha = FREE_SLOT_TEXTFIELD_ALPHA;
			freeSlotTextField.pixelSnapping = false;
			addChild(freeSlotTextField);
			
			addEventListener(TouchEvent.TOUCH, onTouch);
			
			jumpHelper = new JumpWithHintHelper(this, true, true);
			jumpHelper.setEnabled(true);
		}
	
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				
			}
			
			//trace('ChestSlotView draw ', _data.type, _data.isNew, isInvalid(INVALIDATION_FLAG_STATE));
			
			if (!_data || _data.type == ChestType.NONE || _data.isNew) 
			{	
				Starling.juggler.removeTweens(chestIcon);
				
				showTimer(false);
				enableTimer = false;
				
				if (chestIcon) {
					Starling.juggler.tween(chestIcon, 0.3, {transition:Transitions.EASE_IN_BACK, scale:0});
					Starling.juggler.delayCall(showSplash, 0.15, 0.25);
					Starling.juggler.delayCall(removeChestIcon, 0.31);
					
					//showHideShineRaysEffect();
					//Starling.juggler.delayCall(showHideShineRaysEffect, 0.1);
				}
				
				if (padlockIcon)
					EffectsManager.scaleJumpDisappear(padlockIcon, 0.3, 0.1, removePadlockIcon);
			
				if (timeoutLabel)
					EffectsManager.scaleJumpDisappear(timeoutLabel, 0.3, 0, removeTimerLabel);
				
				showBackgroundAnimation(null);
				
				if (openLabel) {
					openLabel.removeFromParent();
					openLabel = null;
					//Starling.juggler.tween(openLabel, 0.3, {transition:Transitions.EASE_OUT_BACK, delay:0.4, scaleY:1});
				}
				
				freeSlotTextField.text = 'CHEST\nSLOT';
				return;
			}
			
			if (isInvalid(INVALIDATION_FLAG_STATE))
			{
				//Starling.juggler.removeTweens(chestIcon);
				removeAllTweens();
				
				if (state == STATE_INIT)
				{
					
				}
				else if (state == STATE_LOBBY)
				{
					tweensBackToLobby();
					jumpHelper.setEnabled(false);
				}
				else if (state == STATE_BUY_CARDS)
				{
					tutorialTrySetFreeOpenChest();
					tweensToBuyCards();
				}
				else if (state == STATE_ACTIVATE)
				{
					Starling.juggler.delayCall(tweensActivate, 0.3);
				}
				else if (state == STATE_READY)
				{
					if (gameManager.deactivated) {
						Game.addEventListener(Game.ACTIVATED, handler_gameActivated);
						return;
					}
					tweensReady();
				}
				else if (state == STATE_NEW_APPEAR)
				{
					tutorialTrySetFreeOpenChest();
					
					tweensNewAppear();
				}
			}	
		}
		
		private function tutorialTrySetFreeOpenChest():void
		{
			//trace('set ',gameManager.tutorialManager.isChestFreeOpenStepPassed, data.openTimestamp, gameManager.tutorialManager.chestFreeOpenId, data.seed);
			if (!gameManager.tutorialManager.isChestFreeOpenStepPassed && data.openTimestamp == 0 
				&& (gameManager.tutorialManager.chestFreeOpenId == -1 || gameManager.tutorialManager.chestFreeOpenId == data.seed)) {
						gameManager.tutorialManager.chestFreeOpenId = data.seed;
						Starling.juggler.removeByID(TutorialManager.TUTORIAL_SHOW_FREE_OPEN_CHEST_DELAY_CALL_ID);
						TutorialManager.TUTORIAL_SHOW_FREE_OPEN_CHEST_DELAY_CALL_ID = Starling.juggler.delayCall(tutorialStepShowFreeOpenChest, 1.6);
				}
		}
		
		private function tweensToBuyCards():void
		{
			if (data.isReadyToOpen) 
			{
				removeTimerBg();
				removeClockTimerView();
				
				showBackgroundAnimation('chest_activate_green');
				backgroundAnimation.playTimeline(chestBackgroundTimeline, true, true);
				
				createOpenLabel();
				Starling.juggler.tween(openLabel, 0.2, {transition:Transitions.EASE_OUT_BACK, delay:1.2, scaleY:1});
			}
			else if (data.openTimestamp > 0) 
			{
				showBackgroundAnimation('chest_activate_blue');
				backgroundAnimation.playTimeline(chestBackgroundTimeline, true, true);
				backgroundAnimation.addAnimationSequence('activateCycleSequence', 21, backgroundAnimation.totalFrames-1);
				backgroundAnimation.playSequence('activateCycleSequence');
				
				tweenShakeChest(2, 2);
			}
			
			createChestIcon(true);
			
			handleTimer(false, 0.7, 1.1);
			
			tweenJumpAppearChest(0.3, ((isTimerActive || data.isReadyToOpen) ? chestIconReadyY : 73 ) + chestIconShiftY);
			
			if (clockTimerView)
				clockTimerView.show(0.8);
			
			tweenCashViewsAppear(0.5);
			
			/*setInterval(function():void {
				chestIcon.y = chestIcon.pivotY + (isTimerActive ? chestIconReadyY : 73) * pxScale
				tweenJumpActivateChest(0);
			}, 10000);*/
			
		}
		
		private function tweensBackToLobby():void
		{
			if (chestIcon) 
				tweenJumpDisappearChest(0);
			
			if (padlockIcon)
				EffectsManager.scaleJumpDisappear(padlockIcon, 0.3, 0.1);
			
			if (timeoutLabel)
				EffectsManager.scaleJumpDisappear(timeoutLabel, 0.3, 0);
				
			if (clockTimerView)
				clockTimerView.hide(0.1);
				
			if (timerBg)
				Starling.juggler.tween(timerBg, 0.25, {transition:Transitions.EASE_IN_BACK, delay:0.25, scaleX:0, onComplete:removeTimerBg});
				
			if (backgroundAnimation)
				Starling.juggler.tween(backgroundAnimation, 0.05, {transition:Transitions.LINEAR, delay:0.64, alpha:0, onComplete:removeBackgroundAnimation});
		
			if (openLabel)	
				Starling.juggler.tween(openLabel, 0.15, {transition:Transitions.EASE_IN, delay:0.1, scaleY:0});	
			
			if (cashTitleLabel)	{
				Starling.juggler.tween(cashTitleLabel, 0.3, {transition:Transitions.EASE_IN, delay:0.2, scaleY:0});
				Starling.juggler.tween(cashIcon, 0.3, {transition:Transitions.EASE_IN, delay:0.1, scaleY:0});
				Starling.juggler.tween(cashValueLabel, 0.3, {transition:Transitions.EASE_IN, delay:0, scaleY:0});
			}
		}
		
		private function tweensActivate():void
		{
			showBackgroundAnimation('chest_activate_blue');
			backgroundAnimation.playTimeline(chestBackgroundTimeline, true, true);
			backgroundAnimation.addAnimationSequence('activateCycleSequence', 21, backgroundAnimation.totalFrames-1);
			backgroundAnimation.addClipEventListener("animationEvent", handler_blueAnimationEvent);
			backgroundAnimation.addEventOnFrame(backgroundAnimation.totalFrames, "animationEvent");
			
			showShineRaysEffect(0.2);
			
			handleTimer(false);
			
			if (clockTimerView)
				clockTimerView.show(0.2);
			
			tweenJumpActivateChest(0);
			tweenShakeChest(2, 4);
		}
		
		private function tweensReady():void
		{
			if (_previousState == STATE_ACTIVATE) {
				
			}
			
			showBackgroundAnimation('chest_activate_green');
			backgroundAnimation.playTimeline(chestBackgroundTimeline, true, true);
			
			tweenJumpActivateChest(0);
			
			handleTimer(false);
			
			createOpenLabel();
			
			Starling.juggler.tween(openLabel, 0.3, {transition:Transitions.EASE_OUT_BACK, delay:0.4, scaleY:1});
			
			tweenShakeChest(2, -1);
		}
		
		private function createOpenLabel():void
		{
			if (openLabel) {
				openLabel.scaleY = 0;
				return;
			}
				
			openLabel = new XTextField(width, 50*pxScale, XTextFieldStyle.getWalrus(37).setStroke(), 'OPEN');
			openLabel.alignPivot();
			openLabel.x = openLabel.pivotX/scale;
			openLabel.y = 180 * pxScale;
			openLabel.scaleY = 0;
			openLabel.pixelSnapping = false;
			addChild(openLabel);
		}
		
		private function tweensNewAppear():void
		{
			//handleTimer(true);
			createChestIcon(false);
			//trace('ChestSlotView.tweensNewAppear calls cleanNewChest:', data.index.toString());
			gameManager.chestsData.cleanNewChest(data.index);
		}
		
		private function handleTimer(jumpPadlockAndTimeoutLabel:Boolean, timerBgTweenDelay:Number = 0.3, cashViewsTweenDelay:Number = 0.2):void 
		{
			if (!_data)
				return;
				
			if (_data.openTimestamp == 0) 
			{
				// новый ящик, не открытый.
				
				enableTimer = false;
				
				if (!padlockIcon) 
				{
					timeoutBg = new Image(AtlasAsset.CommonAtlas.getTexture('controls/chest/timeout_bg'));
					timeoutBg.alignPivot();
					timeoutBg.x = timeoutBg.pivotX + (WIDTH * pxScale - timeoutBg.width) / 2;
					timeoutBg.y = timeoutBgY;
					addChild(timeoutBg);
					
					padlockIcon = new Image(AtlasAsset.CommonAtlas.getTexture("controls/chest/padlock"));
					padlockIcon.alignPivot();
					padlockIcon.x = padlockIcon.pivotX + 28 * pxScale;
					addChild(padlockIcon);
				}
				
				padlockIcon.y = padlockIconY;
				
				if (jumpPadlockAndTimeoutLabel) 
					jumpDownView(padlockIcon, 0.4, 13*pxScale);
				else 
					EffectsManager.scaleJump(padlockIcon, 0.5, true, 1);
				
				if (!timeoutLabel) {
					var timeoutTextFormat:BingoTextFormat = new BingoTextFormat(Fonts.WALRUS_BOLD, 32 * pxScale, 0xFFFFFF, Align.CENTER);
					var filterScale:Number = pxScale * layoutHelper.scaleFromEtalon;
					timeoutTextFormat.nativeFilters = [new DropShadowFilter(1*filterScale, 90, 0x1C0C31, 1, 5*filterScale, 5*filterScale, 8*filterScale)];
					
					timeoutLabel = new TextField(160 * pxScale, 40 * pxScale, StringUtils.formatTimeShort(_data.openTimeout, STATIC_TIMEOUT_STRING_FORMAT), timeoutTextFormat);
					timeoutLabel.alignPivot();
					timeoutLabel.x = timeoutLabel.pivotX + 32*pxScale;
					//timeoutLabel.border = true;
					addChild(timeoutLabel);
				}
				else {
					timeoutLabel.text = StringUtils.formatTimeShort(_data.openTimeout, STATIC_TIMEOUT_STRING_FORMAT);
				}
				
				timeoutLabel.y = timeoutBgY;
				
				if (jumpPadlockAndTimeoutLabel) 
					jumpDownView(timeoutLabel, 0.4, 13*pxScale);
				else 
					EffectsManager.scaleJump(timeoutLabel, 0.5, false, 1.2);
				
			}
			else 
			{
				// активированный ящик. либо таймер либо можно забрать
				
				if (padlockIcon)
					EffectsManager.scaleJumpDisappear(padlockIcon, 0.3, 0.1, removePadlockIcon);
			
				if (timeoutLabel)
					EffectsManager.scaleJumpDisappear(timeoutLabel, 0.3, 0, removeTimerLabel);
				
				//trace(' timer ', (_data.openTimestamp + _data.openTimeout) - TimeService.serverTime);	
				
				showTimer(isTimerActive, timerBgTweenDelay, cashViewsTweenDelay);
			}
		}
		
		private function jumpDownView(view:DisplayObject, time:Number, shiftY:int, delay:Number = 0):void
		{
			var tweenBack:Tween = new Tween(view, time * 0.7, Transitions.EASE_OUT_BACK);
			tweenBack.animate('y', view.y);
			
			Starling.juggler.tween(view, time * 0.3, {transition:Transitions.EASE_OUT, delay:delay, y:(view.y + shiftY), nextTween:tweenBack});
		}
		
		private function showTimer(value:Boolean, timerBgTweenDelay:Number = 0.3, cashViewsTweenDelay:Number = 0.2):void 
		{
			Starling.juggler.removeTweens(timerBg);
			
			if (value) 
			{
				if (!timerBg) {
					timerBg = new Image(AtlasAsset.CommonAtlas.getTexture("controls/chest/chest_timer_bg"));
					timerBg.alignPivot(Align.LEFT);
					timerBg.x = /*timerBg.pivotX/scale +*/ (width - timerBg.width*scale) / 2;
					timerBg.y = 1 * pxScale;
					//timerBg.alpha = 0;
					addChild(timerBg);
					
					clockTimerView = new ClockTimerView(115, Math.PI / 4);
					clockTimerView.x = timerBg.x - timerBg.pivotX/scale + 16 * pxScale;
					clockTimerView.y = timerBg.y - timerBg.pivotY + 23 * pxScale;
					addChild(clockTimerView);
					
					timerBg.scaleX = 0;
					Starling.juggler.tween(timerBg, 0.25, {transition:Transitions.EASE_OUT_BACK, delay:timerBgTweenDelay, scaleX:1});
				}
				
				// cash:
				if (!cashIcon) 
				{
					cashTitleLabel = new XTextField(WIDTH*pxScale, 50*pxScale, XTextFieldStyle.ChestCashTitle, 'OPEN NOW');
					cashTitleLabel.alignPivot();
					cashTitleLabel.y = 144 * pxScale;
					//cashTitleLabel.border = true;
					cashTitleLabel.x = (width / scale) / 2;
					cashTitleLabel.pixelSnapping = false;
					addChild(cashTitleLabel);
					
					cashIcon = new Image(AtlasAsset.CommonAtlas.getTexture("bars/cash"));
					cashIcon.alignPivot();
					cashIcon.scaleX = 0.7;
					cashIcon.y = cashTitleLabel.y + cashTitleLabel.height*scale + cashIcon.pivotY/scale - 45 * pxScale;
					addChild(cashIcon);
				
					cashValueLabel = new XTextField(width, 50*pxScale, XTextFieldStyle.BuyCardCash, _data.getPrice(_data.remainTime).toString());
					cashValueLabel.alignPivot();
					cashValueLabel.y = cashIcon.y;
					cashValueLabel.pixelSnapping = false;
					//cashValueLabel.border = true;
					addChild(cashValueLabel);
					
					//cashIcon.x = (cashIcon.pivotX/scale)/**cashIcon.scale*/ + (width - cashIcon.width*scale - cashValueLabel.textBounds.width*scale - 13*pxScale/scale) / 2;
					//cashValueLabel.x = cashIcon.x + (cashIcon.width*scale)/2 + cashValueLabel.pivotX*scale - cashValueLabel.textBounds.x*scale + 13*pxScale/scale;
				
					cashTitleLabel.scaleY = 0;
					cashIcon.scaleY = 0;
					cashValueLabel.scaleY = 0;
					
					alignOpenForCashViews(true);
					tweenCashViewsAppear(cashViewsTweenDelay);
				}
				else {
					alignOpenForCashViews(true);
				}
				
				enableTimer = true;
			}
			else 
			{
				enableTimer = false;
				
				if (timerBg) {
					
					Starling.juggler.tween(timerBg, 0.25, {transition:Transitions.EASE_IN_BACK, delay:0.1, scaleX:0, onComplete:removeTimerBg});
					if(clockTimerView)
						clockTimerView.hide(0, removeClockTimerView);
				}
				
				if (cashIcon) 
				{
					cashTitleLabel.removeFromParent();
					cashTitleLabel = null;
					
					cashIcon.removeFromParent();
					cashIcon = null;
						
					cashValueLabel.removeFromParent();
					cashValueLabel = null;
				}
			}	
		}
		
		private function createChestIcon(placeInStartPosition:Boolean):void 
		{
			if (_data.type == ChestType.NONE)
				return;
			
			if (!chestIcon) {
				chestIcon = new ChestPartsView(_data.type, 0.78, null, 0, -14*pxScale);
				chestIcon.touchable = false;
				//chestIcon.alignPivot();
				chestIcon.x = chestIcon.width/2 + (WIDTH*pxScale - chestIcon.width)/2;
				
				var childIndex:int = numChildren;
				if (freeSlotTextField && contains(freeSlotTextField))
					childIndex = getChildIndex(freeSlotTextField) + 1;
				else if (backgroundAnimation && contains(backgroundAnimation))
					childIndex = getChildIndex(backgroundAnimation) + 1;
				
				addChildAt(chestIcon, childIndex);
			}
			else {
				Starling.juggler.removeTweens(chestIcon);
				chestIcon.type = _data.type;
			}
			
			//var chestIconPivotY:Number = chestIcon.height * chestIcon.baseScale / 2;
			//var chestIconPivotY:Number = ((chestIcon.height / chestIcon.scale) * chestIcon.baseScale) / 2;
			if (placeInStartPosition) {
				chestIcon.y = (chestIcon.height/chestIcon.scale)/2 + 120 * pxScale + chestIconShiftY;
				chestIcon.scaleX = 0.8;
				chestIcon.scaleY = 1.2;
			}
			else {
				chestIcon.scale = 1;
				chestIcon.y = (chestIcon.height/chestIcon.scale) / 2 + 73 * pxScale + chestIconShiftY;
			}
			
			//trace(' kjh11', chestIcon.height , chestIcon.baseScale, chestIcon.scale, (chestIcon.height/chestIcon.scale) / 2);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			//event.stopImmediatePropagation();
		
			var touch:Touch = event.getTouch(this);
			if (touch == null)
				return;

			if (touch.phase == TouchPhase.BEGAN) 
			{
				Starling.juggler.removeByID(TutorialManager.TUTORIAL_SHOW_FREE_OPEN_CHEST_DELAY_CALL_ID);
				dispatchEventWith(Event.TRIGGERED, true, this);
			}
		}
		
		private function get isTimerActive():Boolean
		{
			if (!_data || _data.openTimestamp == 0)
				return false;
		
			return Math.floor(_data.openTimestamp + _data.openTimeout - TimeService.serverTime) > 0;
		}
		
		private function set enableTimer(value:Boolean):void
		{
			//trace(' enableTimer ', value);
			if (value)
			{
				if (!timer) {
					timer = new Timer(100);
					timer.addEventListener(TimerEvent.TIMER, handler_timer);
					handler_timer(null);
				}
				timer.start();
			}
			else 
			{
				if (timer) {
					timer.removeEventListener(TimerEvent.TIMER, handler_timer);
					timer = null;
				}
			}
		}
		
		private function handler_timer(event:TimerEvent):void
		{
			var timeout:int = _data.remainTime;
	
			if (gameManager.deactivated)
				return;
			
			if (lastTimeoutValue == timeout)
				return;
			
			lastTimeoutValue = timeout;
			
			if (timeout <= 0) 
			{
				timer.stop();
				lastTimeoutValue = int.MIN_VALUE;
				if (_data && !(state == STATE_INIT || state == STATE_LOBBY)) {
					state = STATE_READY;
				}
				
				gameManager.chestsData.dispatchEventWith(ChestsData.EVENT_CLOSE_CHEST_OPEN_DIALOG);
				//trace('OfferManager.handler_timer stop timer');
				//dispatchEventWith(EVENT_CHANGE);
			}
			else {
				if (!timer.running) 
					timer.start();
				
				if (!gameManager.tutorialManager.isChestFreeOpenStepPassed && data.seed == gameManager.tutorialManager.chestFreeOpenId)	
					cashValueLabel.text = 'FREE!'
				else	
					cashValueLabel.text = _data.getPrice(_data.remainTime).toString();
					
				//cashValueLabel.text = int(Math.random() > 0.5 ? (Math.random() * 200) : (Math.random()*40)).toString();
				alignOpenForCashViews();
			}
			
			clockTimerView.setTime(Math.min(_data.openTimeout - 1, timeout));
		}	
		
		private function removePadlockIcon():void
		{
			if (padlockIcon) {
				timeoutBg.removeFromParent();
				timeoutBg = null;
				
				padlockIcon.removeFromParent();
				padlockIcon = null;
			}
		}
		
		private function removeTimerLabel():void
		{
			if (timeoutLabel) {
				timeoutLabel.removeFromParent();
				timeoutLabel = null;
			}
		}
		
		private function removeChestIcon():void
		{
			if (chestIcon) {
				chestIcon.removeFromParent();
				chestIcon = null;
			}
		}
		
		override public function dispose():void 
		{
			Game.removeEventListener(Game.ACTIVATED, handler_gameActivated);
			removeEventListener(TouchEvent.TOUCH, onTouch);
			
			if (clockTimerView)
				clockTimerView.clean();
			
			enableTimer	= false;
			
			super.dispose();
		}
		
		private function showShineRaysEffect(delay:Number = 0):void 
		{
			shineRaysImage = new Image(AtlasAsset.CommonAtlas.getTexture("effects/rays_bg"));
			shineRaysImage.pivotX = 122 * pxScale;
			shineRaysImage.pivotY = 111 * pxScale;
			shineRaysImage.y = 97 * pxScale;
			shineRaysImage.x = 105 * pxScale;
			shineRaysImage.scale = 0.45;
			shineRaysImage.touchable = false;
			
			addChildAt(shineRaysImage, backgroundAnimation ? (getChildIndex(backgroundAnimation) + 1) : 2);
			
			var tween:Tween = new Tween(shineRaysImage, 0.4, Transitions.LINEAR);
			var tween_1:Tween = new Tween(shineRaysImage, 0.6, Transitions.LINEAR);
			
			tween.delay = delay;
			tween.animate('rotation', shineRaysImage.rotation + Math.PI / 4);
			tween.scaleTo(2.7);
			tween.nextTween = tween_1;
			
			tween_1.animate('rotation', shineRaysImage.rotation + Math.PI / 2);
			tween_1.scaleTo(0.5);
			tween_1.onComplete = removeShineRaysImage;
			
			Starling.juggler.add(tween);
		}
		
		private function removeShineRaysImage():void
		{
			if (shineRaysImage) {
				shineRaysImage.removeFromParent();
				shineRaysImage = null;
			}
		}
	
		private function showBackgroundAnimation(timeline:String):void
		{
			chestBackgroundTimeline = timeline;
			if (timeline)
			{
				// background выполняет роль touchable-объекта. Анимация не может ей быть т.к. слишком выходит за пределы слота
				background.alpha = 0;
				freeSlotTextField.alpha = 0;
				
				if (backgroundAnimation) {
					backgroundAnimation.removeFromParent();
					backgroundAnimation.dispose();
					backgroundAnimation = null;
				}
				
				if (!backgroundAnimation) {
					backgroundAnimation = new AnimationContainer(MovieClipAsset.PackBase, true);
					backgroundAnimation.x = WIDTH*pxScale/2 - 3 * pxScale;
					backgroundAnimation.y = HEIGHT*pxScale/2 - 12 * pxScale;
					backgroundAnimation.touchable = false;
					//backgroundAnimation.alpha = 0.5;
					addChildAt(backgroundAnimation, 0);
					//backgroundAnimation.play();
				}
				else {
					//backgroundAnimation.asset = asset;
				}
			}
			else
			{
				if (backgroundAnimation) {
					backgroundAnimation.removeFromParent();
					backgroundAnimation = null;
				}
				
				background.alpha = 1;
				freeSlotTextField.alpha = FREE_SLOT_TEXTFIELD_ALPHA;
			}
		}
		
		private function handler_blueAnimationEvent(event:Event):void {
			backgroundAnimation.removeClipEventListener("animationEvent", handler_blueAnimationEvent);
			backgroundAnimation.playSequence('activateCycleSequence');
		}
		
		public function showSmokeExplosion(delay:Number = 0):void
		{
			smokeExplosion = new AnimationContainer(MovieClipAsset.PackBase, false, true);
			smokeExplosion.touchable = false;
			smokeExplosion.x = (WIDTH*pxScale - smokeExplosion.width)/2;
			smokeExplosion.y = 165 * pxScale;
			smokeExplosion.scale = 2;
			addChildAt(smokeExplosion, contains(freeSlotTextField) ? getChildIndex(freeSlotTextField) : 0);
			
			smokeExplosion.playTimeline('smoke_explosion', false, false, 24);
			
			Starling.juggler.tween(smokeExplosion, 0.1, {transition:Transitions.LINEAR, delay:(delay + 0.3), scale:0, onComplete:removeSmokeExplosion});
		}
		
		private function removeSmokeExplosion():void {
			if (smokeExplosion) {
				smokeExplosion.removeFromParent();
				smokeExplosion = null;
			}
		}
		
		/*****************************************************************************************
		 * 
		 * CHEST TWEENS:
		 * 
		 ****************************************************************************************/
		
		private function tweenJumpAppearChest(delay:Number, chestIconY:int):void 
		{
			if(!chestIcon)
				return;
				
			chestIcon.scale = 1;	
			var tweenChest_0:Tween = new Tween(chestIcon, 0.4, Transitions.EASE_OUT_BACK);
			var tweenChest_1:Tween = new Tween(chestIcon, 0.3, Transitions.EASE_IN_BACK);
			var tweenChest_2:Tween = new Tween(chestIcon, 0.8, Transitions.EASE_OUT_ELASTIC);
			var chestIconPivotY:Number = (chestIcon.height/chestIcon.scale) / 2;
			
			//trace(' kjh2', chestIcon.height, chestIcon.baseScale, chestIcon.scale, chestIconPivotY);
			tweenChest_0.delay = delay;
			tweenChest_0.animate('scaleX', 1);
			tweenChest_0.animate('scaleY', 0.8);
			tweenChest_0.animate('y', chestIconPivotY + 30 * pxScale);
			tweenChest_0.nextTween = tweenChest_1;
			
			tweenChest_1.animate('scaleX', 0.8);
			tweenChest_1.animate('scaleY', 1.2);
			tweenChest_1.animate('y', chestIconPivotY + chestIconY * pxScale);
			tweenChest_1.nextTween = tweenChest_2;
			
			tweenChest_2.animate('scaleX', 1);
			tweenChest_2.animate('scaleY', 1);
			tweenChest_2.onComplete = enableJumpHelper;
			Starling.juggler.add(tweenChest_0);
		}
		
		private function tweenJumpDisappearChest(delay:Number):void 
		{
			if(!chestIcon)
				return;
				
			chestIcon.scale = 1;	
			var tweenChest_0:Tween = new Tween(chestIcon, 0.4, Transitions.EASE_IN);
			var tweenChest_1:Tween = new Tween(chestIcon, 0.3, Transitions.EASE_IN);
			var chestIconPivotY:Number = (chestIcon.height/chestIcon.scale) / 2;
			
			tweenChest_0.delay = delay;
			tweenChest_0.animate('scaleX', 1.2);
			tweenChest_0.animate('y', chestIconPivotY + 10 * pxScale + chestIconShiftY);
			tweenChest_0.animate('scaleY', 0.8);
			tweenChest_0.nextTween = tweenChest_1;
			
			tweenChest_1.animate('scaleX', 0.8);
			tweenChest_1.animate('scaleY', 1.2);
			tweenChest_1.animate('y', chestIconPivotY + 140 * pxScale + chestIconShiftY);
			
			Starling.juggler.add(tweenChest_0);
		}
		
		private function tweenJumpActivateChest(delay:Number):void 
		{
			if(!chestIcon)
				return;
				
			chestIcon.scale = 1;		
			var tweenChest_0:Tween = new Tween(chestIcon, 0.1, Transitions.EASE_OUT);
			var tweenChest_1:Tween = new Tween(chestIcon, 0.1, Transitions.EASE_OUT);
			var tweenChest_2:Tween = new Tween(chestIcon, 0.1, Transitions.EASE_IN);
			var tweenChest_3:Tween = new Tween(chestIcon, 0.2, Transitions.EASE_OUT_BACK);
			var chestIconPivotY:Number = (chestIcon.height/chestIcon.scale) / 2;
			
			tweenChest_0.delay = delay;
			tweenChest_0.animate('scaleX', 1.15);
			tweenChest_0.animate('scaleY', 0.85);
			tweenChest_0.animate('y',chestIconPivotY  + 90 * pxScale + chestIconShiftY);
			tweenChest_0.nextTween = tweenChest_1;
			
			tweenChest_1.animate('scaleX', 0.85);
			tweenChest_1.animate('scaleY', 1.1);
			tweenChest_1.animate('y', chestIconPivotY + 15 * pxScale + chestIconShiftY);
			tweenChest_1.nextTween = tweenChest_2;
			
			tweenChest_2.animate('scaleX', 1.1);
			tweenChest_2.animate('scaleY', 0.9);
			tweenChest_2.animate('y', chestIconPivotY + 34 * pxScale + chestIconShiftY);
			tweenChest_2.nextTween = tweenChest_3;
			
			tweenChest_3.animate('scaleX', 1);
			tweenChest_3.animate('scaleY', 1);
			tweenChest_3.animate('y', chestIconPivotY + chestIconReadyY + chestIconShiftY);
			
			Starling.juggler.add(tweenChest_0);
		}
		
		private function tweenShakeChest(delay:Number = 0, shakesCount:int = 0):void 
		{
			if(!chestIcon)
				return;
				
			var tweenChest_0:Tween = new Tween(chestIcon, 0.13, Transitions.EASE_OUT);
			var tweenChest_1:Tween = new Tween(chestIcon, 0.13, Transitions.EASE_OUT);
			var tweenChest_2:Tween = new Tween(chestIcon, 0.55, Transitions.EASE_OUT_ELASTIC);
			
			tweenChest_0.delay = delay;
			tweenChest_0.animate('scaleX', 1.04);
			tweenChest_0.animate('scaleY', 0.96);
			tweenChest_0.nextTween = tweenChest_1;
			
			tweenChest_1.animate('scaleX', 0.96);
			tweenChest_1.animate('scaleY', 1.02);
			tweenChest_1.nextTween = tweenChest_2;
			
			tweenChest_2.animate('scaleX', 1);
			tweenChest_2.animate('scaleY', 1);
			
			if (shakesCount != 0) {
				tweenChest_2.onComplete = tweenShakeChest;
				tweenChest_2.onCompleteArgs = [1, --shakesCount];
			}
			
			Starling.juggler.add(tweenChest_0);
		}
		 
		/*****************************************************************************************
		 * 
		 * 
		 * 
		 ****************************************************************************************/ 
		
		private function tweenCashViewsAppear(delay:Number):void {
			if (cashTitleLabel) {
				Starling.juggler.tween(cashTitleLabel, 0.3, {transition:Transitions.EASE_OUT_BACK, delay:delay, scaleY:1});
				Starling.juggler.tween(cashIcon, 0.3, {transition:Transitions.EASE_OUT_BACK, delay:(delay + 0.1), scaleY:0.7});
				Starling.juggler.tween(cashValueLabel, 0.3, {transition:Transitions.EASE_OUT_BACK, delay:(delay + 0.2), scaleY:1}); 
			}
		}
		
		private function removeClockTimerView():void {
			if (clockTimerView) {
				clockTimerView.removeFromParent();
				clockTimerView = null;
			}
		}
		
		private function removeTimerBg():void {
			if(timerBg) {
				timerBg.removeFromParent();
				timerBg = null;
			}	
		}
		
		private function removeBackgroundAnimation():void
		{
			if (backgroundAnimation) {
				backgroundAnimation.removeFromParent();
				backgroundAnimation.dispose();
				backgroundAnimation = null;
			}
		}
		
		private function get timeoutBgY():int
		{
			return timeoutBg.pivotY + ((data && data.isSuperTypeAssets) ? 16 : 22) * pxScale
		}
		
		private function get padlockIconY():int
		{
			return timeoutBgY + 2 * pxScale;
		}
		
		private function get chestIconShiftY():int
		{
			if (!data || !chestIcon)
				return 0;
				
			return data.chestIconShiftY;
		}
		
		private function get chestIconReadyY():int
		{
			if (!data || !chestIcon)
				return 0;
				
			return (data.isSuperTypeAssets ? 40 : 25) * pxScale
		}
		
		private function showSplash(removeDelay:Number = 0):void
		{
			splashAnimation = new AnimationContainer(MovieClipAsset.PackBase, false, true);
			splashAnimation.scale = 2;
			addChild(splashAnimation);
			
			splashAnimation.x = WIDTH * pxScale / 2;
			splashAnimation.y = HEIGHT * pxScale / 2;
			
			splashAnimation.playTimeline('splash', true, false, 24);
			splashAnimation.reverse = true;
			splashAnimation.goToAndPlay(splashAnimation.totalFrames);
			splashAnimation.touchable = false;
			
			Starling.juggler.tween(splashAnimation, 0.1, {transition:Transitions.LINEAR, delay:removeDelay, scale:0});
		}
		
		private function showHideShineRaysEffect(delay:Number = 0):void 
		{
			var image:Image = new Image(AtlasAsset.CommonAtlas.getTexture("effects/rays_0"));
			image.alignPivot();
			image.y = WIDTH * pxScale / 2;
			image.x = HEIGHT * pxScale / 2;
			image.scale = 0.2;
			//image.alpha = 0.6;
			image.blendMode = BlendMode.ADD;
			image.touchable = false;
			
			//addChildAt(image, backgroundAnimation ? (getChildIndex(backgroundAnimation) + 1) : 2);
			addChildAt(image, backgroundAnimation ? (getChildIndex(backgroundAnimation) + 1) : 2);
			
			var tween:Tween = new Tween(image, 0.3, Transitions.EASE_IN);
			var tween_1:Tween = new Tween(image, 0.2, Transitions.EASE_OUT);
			
			tween.delay = delay;
			tween.animate('rotation', image.rotation + Math.PI / 4);
			tween.scaleTo(2);
			tween.nextTween = tween_1;
			
			tween_1.animate('rotation', image.rotation + Math.PI / 2);
			tween_1.scaleTo(0.1);
			tween_1.onComplete = removeView;
			tween_1.onCompleteArgs = [image];
			
			Starling.juggler.add(tween);
		}
		
		private function removeView(displayObject:DisplayObject):void
		{
			displayObject.removeFromParent();
		}
		
		private function alignOpenForCashViews(explicitReposition:Boolean = false):void 
		{
			if (!cashIcon || gameManager.deactivated) 
				return;

			cashValueLabel.alignPivot();
			//cashValueLabel.border = true
			var cashIconAndValueGap:Number = -4 * pxScale;
			var newCashValueWidth:int = cashValueLabel.textBounds.width;
			var newCashIconX:Number = (width/scale - cashIcon.width - newCashValueWidth - cashIconAndValueGap + cashIcon.pivotX) / 2;
			
			if(cashValueLabel.x == 0)
				explicitReposition = true;
				
			if (explicitReposition || (Math.abs(lastCashValueWidth - newCashValueWidth) > 8*pxScale)) {
				cashIcon.x = newCashIconX;
				lastCashValueWidth = newCashValueWidth;
				cashValueLabel.x = cashIcon.x + cashIcon.pivotX + cashValueLabel.pivotX - cashValueLabel.textBounds.x + cashIconAndValueGap;
			}
		}
		
		private function handler_gameActivated(e:Event):void 
		{
			Game.removeEventListener(Game.ACTIVATED, handler_gameActivated);
		
			if (state == STATE_READY)
				tweensReady();
		}	
		
		private function removeAllTweens():void
		{
			if (chestIcon) 
				Starling.juggler.removeTweens(chestIcon);
			
			if (padlockIcon) {
				Starling.juggler.removeTweens(padlockIcon);
				padlockIcon.y = padlockIconY;
			}
			
			if (timeoutLabel) {
				Starling.juggler.removeTweens(timeoutLabel);
				timeoutLabel.y = timeoutBgY;
			}
				
			if (clockTimerView)
				clockTimerView.clean();
				
			if (timerBg)
				Starling.juggler.removeTweens(timerBg);
				
			if (backgroundAnimation)
				Starling.juggler.removeTweens(backgroundAnimation);
		
			if (openLabel)	
				Starling.juggler.removeTweens(openLabel);	
			
			if (cashTitleLabel)	{
				Starling.juggler.removeTweens(cashTitleLabel);
				Starling.juggler.removeTweens(cashIcon);
				Starling.juggler.removeTweens(cashValueLabel);
			}
		}
		
		private function enableJumpHelper():void {
			jumpHelper.setEnabled(true);
		}
		
		/****************************************************************************************************
		* 
		* tutorial
		* 
		****************************************************************************************************/
		
		private function tutorialStepShowFreeOpenChest():void
		{
			FadeQuad.show(Game.current.gameScreen, 0.2, 0.8, true, tutorialStepHideFreeOpenChest, 1000);
			
			chestIcon.visible = false;
			
			if (!tutorialChestIcon) {
				tutorialChestIcon = new ChestPartsView(_data.type, 0.78, null, 0, -14*pxScale);
				tutorialChestIcon.addEventListener(TouchEvent.TOUCH, handler_tutorialChestTouch);
				//tutorialChestIcon.alignPivot();
				var point:Point = localToGlobal(new Point(chestIcon.x, chestIcon.y));
				tutorialChestIcon.x = point.x;
				tutorialChestIcon.y = point.y;
				tutorialChestIcon.scale = scale;
				Game.current.gameScreen.addChild(tutorialChestIcon);
				
			}
			
			gameManager.tutorialManager.showHand(Game.current.gameScreen, tutorialChestIcon.x + 75*pxScale*scale, tutorialChestIcon.y /* + 10*gameUILayoutScale*/, 0.5, 0, -1, 1);
		}
		
		public function tutorialStepHideFreeOpenChest():void
		{
			if(tutorialChestIcon || (data && data.seed == gameManager.tutorialManager.chestFreeOpenId))
			{
				Starling.juggler.removeByID(TutorialManager.TUTORIAL_SHOW_FREE_OPEN_CHEST_DELAY_CALL_ID);
				FadeQuad.hide();
				gameManager.tutorialManager.hideHand();
				
				chestIcon.visible = true;
				
				if (tutorialChestIcon) {
					tutorialChestIcon.removeFromParent();
					tutorialChestIcon.removeEventListener(TouchEvent.TOUCH, handler_tutorialChestTouch);
					tutorialChestIcon = null;
				}
			}
		}
		
		private function handler_tutorialChestTouch(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
			var touch:Touch = event.getTouch(tutorialChestIcon);
			if (touch && touch.phase == TouchPhase.BEGAN) {
				tutorialStepHideFreeOpenChest();
				dispatchEventWith(Event.TRIGGERED, true, this);
			}
		}
		
	}
}