package com.alisacasino.bingo.dialogs.chests
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.commands.ShowNoMoneyPopup;
	import com.alisacasino.bingo.components.CardsIconView;
	import com.alisacasino.bingo.components.ClockTimerView;
	import com.alisacasino.bingo.controls.DoubleTitlesButtonContent;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.IDialog;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.chests.ChestData;
	import com.alisacasino.bingo.models.chests.ChestDropCounts;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.lobbyScreenClasses.ChestSlotView;
	import com.alisacasino.bingo.screens.storeWindow.chests.DescriptionItemRenderer;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.RelativePixelMovingHelper;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.TimeService;
	import com.alisacasino.bingo.utils.UIUtils;
	import feathers.controls.Button;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.Align;
	
	
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.display.Image;
	
	public class ChestOpenDialog extends Sprite implements IDialog
	{
		private static var WIDTH:uint = 477;
		public static var HEIGHT:uint = 294;
		private var _backgroundWidth:Number;
		
		private var dialogBg:Image;
		private var dialogTail:Image;
		private var chestView:ChestPartsView;
		private var grayBg:Image;
		private var title:XTextField;		
		
		private var tailShiftX:int;
		
		private var energyGoodView:ChestGoodView;
		private var cardsGoodView:ChestCardsGoodView;
		private var customizersGoodView:ChestCardsGoodView;
		
		private var openButton:Button;
		private var buttonContent:DoubleTitlesButtonContent;
		
		private var clockTimerView:ClockTimerView;
		
		private var _chestSlotView:ChestSlotView;
		private var data:ChestData;
		
		private var forMoney:Boolean;
		private var resultCallback:Function;
		
		private var isHiding:Boolean;
		
		private var hasCustomizerCards:Boolean;
		private var chestDropCounts:ChestDropCounts;
		
		private var timer:Timer;
		private var lastTimeoutValue:int = int.MIN_VALUE;
		
		public function ChestOpenDialog(chestSlotView:ChestSlotView, forMoney:Boolean, resultCallback:Function, tailShiftX:int) 
		{
			_chestSlotView = chestSlotView;
			data = chestSlotView.data;
			this.forMoney = forMoney;
			this.resultCallback = resultCallback;
			this.tailShiftX = tailShiftX;
			
			chestDropCounts = gameManager.chestsData.getChestDropCount(data.type) || new ChestDropCounts();
			hasCustomizerCards = chestDropCounts.customizerMaxCount > 0;
			_backgroundWidth = hasCustomizerCards ? 547 : 477; 
			WIDTH = hasCustomizerCards ? 547 : 477; 
			
			initialize();
		}
		
		public function get fadeStrength():Number {
			return 0.8;
		}
		
		public function get blockerFade():Boolean {
			return true;
		}
		
		public function get fadeClosable():Boolean {
			return true;
		}
		
		public function get chestSlotView():ChestSlotView {
			return _chestSlotView;
		}
		
		public function set chestSlotView(value:ChestSlotView):void {
			if (_chestSlotView == value)
				return;
				
			_chestSlotView = value;
			//refresh();
		}
		
		public function get align():String {
			return null;
		}
		
		public function get backgroundWidth():Number {
			return _backgroundWidth;
		}
		
		public function reposition(tailShiftX:int):void {
			this.tailShiftX = tailShiftX;
			
			if (dialogTail)
				dialogTail.x = tailShiftX;
		}
		
		protected function initialize():void 
		{
			dialogBg = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/chest/window_white_bg"));
			dialogBg.scale9Grid = new Rectangle(25*pxScale, 25*pxScale, 55*pxScale, 55*pxScale);
			dialogBg.alignPivot(Align.CENTER, Align.BOTTOM);
			dialogBg.height = 13 * pxScale;
			dialogBg.width = 0;
			addChild(dialogBg);
			
			dialogTail = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/chest/window_white_corner"));
			dialogTail.alignPivot(Align.CENTER, Align.TOP);
			dialogTail.scaleY = 0;
			dialogTail.y = -7 * pxScale;
			dialogTail.x = tailShiftX;
			addChild(dialogTail);
			
			grayBg = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/chest/gray_tile_bg"));
			grayBg.scale9Grid = new Rectangle(15*pxScale, 15*pxScale, 35*pxScale, 35*pxScale);
			grayBg.alignPivot(Align.CENTER);
			grayBg.width = 0//WIDTH*pxScale - 2*13*pxScale;
			grayBg.height = 103*pxScale;
			grayBg.y = -HEIGHT*pxScale + grayBg.pivotY + (grayBg.height - grayBg.texture.frameHeight)/2 + 13*pxScale;
			addChild(grayBg);
			
			chestView = new ChestPartsView(data.type, 1, ChestPartsView.STATE_CHEST_PRE_JUMP);
			chestView.y = -HEIGHT * pxScale - 46 * pxScale;
			addChild(chestView);
			
			title = new XTextField(WIDTH * pxScale, 40 * pxScale, XTextFieldStyle.WalrusWhite33Shadowed, data.title);
			title.alignPivot();
			title.y = -HEIGHT*pxScale + 90*pxScale;
			title.scaleX = 0;
			addChild(title);
	
			var itemsViewsBgWidth:int = (hasCustomizerCards ? 125 : 175) * pxScale;
			
			energyGoodView = new ChestGoodView(AtlasAsset.CommonAtlas, 'buy_cards/gray_bg', ResizeUtils.getScaledRect(27, 0, 2, 0), itemsViewsBgWidth, 'bars/energy', XTextFieldStyle.getWalrus(33, 0xFDFF1B).setShadow(), ChestGoodView.TWEEN_TYPE_ALL, chestDropCounts.powerupsFromToString());
			energyGoodView.setProperties(-30, 0, 22, 2);
			energyGoodView.x = 46 * pxScale - WIDTH*pxScale/2;
			energyGoodView.y = -128 * pxScale;
			addChild(energyGoodView);
			
			cardsGoodView = new ChestCardsGoodView(itemsViewsBgWidth + 7*pxScale, CardsIconView.TWO_MINI_CARDS_QUERY_MARK_2, CardsIconView.COLOR_BLUE, XTextFieldStyle.getWalrus(33, 0xB1EEFF).setShadow(), chestDropCounts.сollectionsFromToString());
			cardsGoodView.setProperties(0, 0, 16, 2);
			cardsGoodView.x = (hasCustomizerCards ? 220 : 279) * pxScale - WIDTH*pxScale/2;
			cardsGoodView.y = -128 * pxScale;
			addChild(cardsGoodView);
			
			if (hasCustomizerCards) {
				customizersGoodView  = new ChestCardsGoodView(itemsViewsBgWidth + 7*pxScale, CardsIconView.TWO_MINI_CARDS_QUERY_MARK_2, CardsIconView.COLOR_ORANGE, XTextFieldStyle.getWalrus(33, 0xFFDE00).setShadow(), chestDropCounts.сustomizersFromToString());
				customizersGoodView.setProperties(0, 0, 14, 2);
				customizersGoodView.x = 400 * pxScale - WIDTH*pxScale/2;
				customizersGoodView.y = -128 * pxScale;
				addChild(customizersGoodView);
			}
			
			if (forMoney) {
				//if (!gameManager.tutorialManager.isChestFreeOpenStepPassed && data.seed == gameManager.tutorialManager.chestFreeOpenId)	
					//buttonContent = DoubleTitlesButtonContent.createBuyForCashButtonContent('OPEN', AtlasAsset.CommonAtlas.getTexture("store/cash_price_icon"), 'FREE', 5);
				//else	
					buttonContent = DoubleTitlesButtonContent.createBuyForCashButtonContent('OPEN', AtlasAsset.CommonAtlas.getTexture("store/cash_price_icon"), data.getPrice(data.remainTime).toString(), 5);
			}
			else {
				buttonContent = DoubleTitlesButtonContent.createBuyForCashButtonContent('START UNLOCK');
			}
				
			openButton = new Button();
			openButton.scaleWhenDown = 0.93;
			openButton.useHandCursor = true;
			openButton.defaultSkin = buttonContent;
			openButton.validate();
			openButton.alignPivot(Align.CENTER, Align.BOTTOM);
			openButton.y = -14 * pxScale;
			openButton.addEventListener(Event.TRIGGERED, handler_openButtonClick);
			addChild(openButton);
			
			
			
			if (!(data.openTimestamp == 0 && forMoney)) {
				clockTimerView = new ClockTimerView(115, Math.PI / 4, 0);
				clockTimerView.y = -45 * pxScale;
				addChild(clockTimerView);
			}
			
			if (clockTimerView) 
			{
				//openButton.addIcon();
				
				if (data.openTimestamp == 0) 
				{
					clockTimerView.setTime(data.openTimeout, false);
					clockTimerView.x = (WIDTH / 2) * pxScale - clockTimerView.contentWidth - (hasCustomizerCards ? 25 : 15) * pxScale;
					
					openButton.x = Math.min(0, clockTimerView.x - openButton.width / 2 -35 * pxScale);
				}
				else 
				{
					timer = new Timer(100);
					timer.addEventListener(TimerEvent.TIMER, handler_timer);
					handler_timer(null);
					timer.start();
					
					openButton.x = -100 * pxScale;
					clockTimerView.x = (WIDTH/2) * pxScale - 185 * pxScale;
				}
			}
			
			tweenOpen();
		}
		
		private function tweenOpen():void
		{
			SoundManager.instance.playSfx(SoundAsset.ChestClickWindowPopUp, 0, 0, 0.7);
			
			var tweenBg_0:Tween = new Tween(dialogBg, 0.25, Transitions.EASE_OUT_BACK);
			var tweenBg_1:Tween = new Tween(dialogBg, 0.3, Transitions.EASE_OUT_BACK);
			tweenBg_0.animate('width', WIDTH * pxScale);
			tweenBg_0.nextTween = tweenBg_1;
			tweenBg_1.animate('height', HEIGHT * pxScale);
			Starling.juggler.add(tweenBg_0);
			
			
			var tweenButton_0:Tween = new Tween(openButton, 0.2, Transitions.EASE_IN);
			var tweenButton_1:Tween = new Tween(openButton, 0.5, Transitions.EASE_OUT_ELASTIC);
			tweenButton_0.delay = 0.2;
			tweenButton_0.animate('scaleY', 1.15);
			tweenButton_0.animate('scaleX', 0.85);
			tweenButton_0.nextTween = tweenButton_1;
			tweenButton_1.animate('scaleY', 1);
			tweenButton_1.animate('scaleX', 1);
			Starling.juggler.add(tweenButton_0);
			
			Starling.juggler.tween(dialogTail, 0.3, {transition:Transitions.EASE_OUT_BACK, delay:0.2, scaleY:1});
			
			//EffectsManager.scaleJumpAppearElastic(openButton, 1, 0.35, 0.15);
			
			var goodShowTimeIncrement:Number = 0.4 / (hasCustomizerCards ? 3 : 2); 
			energyGoodView.show(0.2, 0.35);
			cardsGoodView.show(0.2, 0.35 + goodShowTimeIncrement);
			if (customizersGoodView)
				customizersGoodView.show(0.2, 0.35 + 2 * goodShowTimeIncrement);
			
			Starling.juggler.tween(grayBg, 0.1, {transition:Transitions.EASE_IN, delay:0.37, width:(WIDTH*pxScale - 2*13*pxScale)});
			
			Starling.juggler.tween(title, 0.3, {transition:Transitions.EASE_OUT_BACK, delay:0.45, scaleX:1});
			
			chestView.show(0.3);
			
			if(clockTimerView)
				clockTimerView.show(0.3);
		}
			
		private function tweenHide():void
		{
			if (isHiding)
				return;
				
			isHiding = true;
			
			openButton.touchable = false;
			
			Starling.juggler.tween(dialogBg, 0.31, {transition:Transitions.EASE_IN_BACK, onComplete:completeRemove, scaleY:0});
			Starling.juggler.tween(dialogTail, 0.3, {transition:Transitions.EASE_IN_BACK, scaleY:0});
			
			Starling.juggler.tween(grayBg, 0.05, {transition:Transitions.EASE_IN_BACK, width:0});
			
			Starling.juggler.tween(title, 0.1, {transition:Transitions.EASE_IN_BACK, scaleX:1.3, scaleY:0});
			
			Starling.juggler.tween(openButton, 0.15, {transition:Transitions.EASE_IN_BACK, delay:0.1, scale:0});
			
			energyGoodView.hide(0.1);
			cardsGoodView.hide(0.1);
			if (customizersGoodView)
				customizersGoodView.hide(0.1);
			
			chestView.hide(0);
			
			if(clockTimerView)
				clockTimerView.hide(0.1);
		}
		
		private function handler_openButtonClick(e:Event):void 
		{
			if (forMoney && !isTutorialFreeOpenChest)
			{
				if (Player.current.cashCount < data.getPrice(data.remainTime))
				{
					/*
					var point:Point = data.index >= 2 ?
						new Point(-440*pxScale, -140*pxScale) :
						new Point(440 * pxScale, -140 * pxScale);
					*/
						
					var point:Point = new Point(0, -140 * pxScale);
					new ShowNoMoneyPopup(ShowNoMoneyPopup.PURPLE, this, point).execute();
					return;
				}
			}
			
			if (isTutorialFreeOpenChest)
				gameManager.analyticsManager.sendTutorialEvent('freeOpenChest', data.seed);
			
			resultCallback(chestSlotView, forMoney);
			close();
		}
		
		private function completeRemove():void
		{
			removeFromParent();
		}
		
		public function close():void 
		{
			if (timer) {
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, handler_timer);
				timer = null;
			}
				
			tweenHide();
		}
		
		/* INTERFACE com.alisacasino.bingo.dialogs.IDialog */
		
		public function get selfScaled():Boolean 
		{
			return false;
		}
		
		public function get baseScale():Number
		{
			return layoutHelper.independentScaleFromEtalonMin;
		}
		
		private function handler_timer(event:TimerEvent):void
		{
			var timeout:int = data.remainTime;
			
			if (lastTimeoutValue == timeout)
				return;
			
			lastTimeoutValue = timeout;
			
			if (timeout <= 0) 
			{
				timer.stop();
				close();
			}
			else {
				if (!timer.running) 
					timer.start();
				
				if (buttonContent && buttonContent.label2) {
					buttonContent.label2.text = isTutorialFreeOpenChest ? 'FREE!' : data.getPrice(timeout).toString();
					buttonContent.align();
				}
			}
			
			clockTimerView.setTime(Math.min(data.openTimeout - 1, timeout));
		}
		
		private function get isTutorialFreeOpenChest():Boolean {
			return !gameManager.tutorialManager.isChestFreeOpenStepPassed && data.seed == gameManager.tutorialManager.chestFreeOpenId;
		}
	}	
}
