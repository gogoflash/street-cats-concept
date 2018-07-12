package com.alisacasino.bingo.screens.questsScreenClasses
{
	import adobe.utils.CustomActions;
	import air.update.states.HSM;
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.commands.ShowNoMoneyPopup;
	import com.alisacasino.bingo.controls.DoubleTitlesButtonContent;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.quests.QuestModel;
	import com.alisacasino.bingo.models.quests.QuestType;
	import com.alisacasino.bingo.models.quests.questItems.QuestBase;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	import feathers.utils.touch.TapToTrigger;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Align;
	import starling.utils.TweenHelper;
	
	public class QuestSkipRenderer extends FeathersControl
	{
		public static var WIDTH:uint = 290 * pxScale;
		public static var HEIGHT:uint = 555 * pxScale;
		
		public function QuestSkipRenderer(index:int, type:String, quest:QuestBase, buttonsActionCallback:Function, randomPictureMode:Boolean = false)
		{
			super();
			this.index = index;
			this.type = type;
			this.buttonsActionCallback = buttonsActionCallback;
			this.randomPictureMode = randomPictureMode;
			_quest = quest;
		}
	
		public var index:int;
		public var type:String;
		private var buttonsActionCallback:Function;
		//public var isHiding:Boolean;
		public var backgroundTriggeredCallback:Function;
		private var randomPictureMode:Boolean;
		
		private var _quest:QuestBase;
		
		private var background:Image;
		private var backgroundColored:Image;
		private var backgroundContentBg:Image;
		private var loadImage:Image;
		private var animationContainer:AnimationContainer;
		private var skipButton:Button;
		private var backButton:XButton;
		private var title:XTextField;
		private var skipLabel:XTextField;
		
		private var creationTime:int;
		
		public function get quest():QuestBase
		{
			return _quest;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			var backgroundColor:uint = quest ? quest.style.backgroundColor : 0xD0D0D0;
		
			background = new Image(AtlasAsset.CommonAtlas.getTexture('quests/outer_bg'));
			background.scale9Grid = ResizeUtils.getScaledRect(19, 19, 2, 2);
			background.alignPivot();
			background.width = WIDTH;
			background.height = HEIGHT;
			addChild(background);
			
			backgroundColored = new Image(AtlasAsset.CommonAtlas.getTexture('quests/inner_bg'));
			backgroundColored.scale9Grid = ResizeUtils.getScaledRect(14, 14, 2, 2);
			backgroundColored.addEventListener(TouchEvent.TOUCH, handler_backgroundColoredTouch);
			backgroundColored.color = backgroundColor;
			backgroundColored.alignPivot();
			backgroundColored.width = WIDTH - 10*pxScale;
			backgroundColored.height = HEIGHT - 10*pxScale;
			addChild(backgroundColored);
			
			title = new XTextField(WIDTH, 40 * pxScale, XTextFieldStyle.getWalrus(33).setShadow(0.5, 0, 1, 90, 3, 4), randomPictureMode ? 'OOPS!' : 'SKIP QUEST ?');
			title.alignPivot();
			title.touchable = false;
			title.y = -HEIGHT / 2 + 43 * pxScale;
			addChild(title);
			
			skipButton = new Button();
			skipButton.scaleWhenDown = 0.9;
			skipButton.useHandCursor = true;
			
			if (!randomPictureMode)
			{
				backgroundContentBg = new Image(AtlasAsset.CommonAtlas.getTexture('quests/bordered_gray_bg'));
				backgroundContentBg.scale9Grid = ResizeUtils.getScaledRect(18, 18, 1, 1);
				backgroundContentBg.alignPivot();
				backgroundContentBg.touchable = false;
				backgroundContentBg.width = WIDTH - 26*pxScale;
				backgroundContentBg.height = 140 * pxScale;
				backgroundContentBg.y = 195 * pxScale;
				addChild(backgroundContentBg);
			
				animationContainer = new AnimationContainer(MovieClipAsset.PackCommon, true);
				animationContainer.touchable = false;
				//animationContainer.pivotX = 140 * pxScale;
				//animationContainer.pivotY = 340 * pxScale; 
				//animationContainer.scale = 0.79;
				animationContainer.x = -120 * pxScale;
				animationContainer.y = -153 * pxScale;
				addChild(animationContainer);
				animationContainer.playTimeline("cat_wash", true, true, 60);
				animationContainer.goToAndPlay(159);
				
				skipLabel = new XTextField(WIDTH, 40 * pxScale, XTextFieldStyle.getWalrus(33, 0xFFFFFF), 'SKIP FOR');
				skipLabel.alignPivot();
				skipLabel.touchable = false;
				skipLabel.y = 159*pxScale;
				addChild(skipLabel);
				
				skipButton.addEventListener(Event.TRIGGERED, handler_buttonSkipAlert);
				skipButton.defaultSkin = skipButtonPriceSkin;
			}
			else {
				skipButton.addEventListener(Event.TRIGGERED, handler_buttonBackToFront);
				skipButton.defaultSkin = DoubleTitlesButtonContent.createBuyForCashButtonContent('BACK', null, null, 5 * pxScale, WIDTH - 26 * pxScale - 28 * pxScale, -4 * pxScale, 32, 34);
				
				creationTime = getTimer();
				
				commitShowDailyBackImage();
			}
		
			skipButton.invalidate();
			skipButton.validate();
			skipButton.alignPivot();
			skipButton.y = 218*pxScale;
			
			addChild(skipButton);
		}
		
		override protected function draw():void
		{
			super.draw();
			
			if (randomPictureMode) 
				commitShowDailyBackImage();
			
			//if (isInvalid(INVALIDATION_FLAG_SIZE)) 
			//resize();
		}
		
		private function handler_buttonSkipAlert(event:Event):void 
		{
			buttonsActionCallback();
			
			if (!checkCashEnougthWidthAlert())
				return;
				
			skipButton.touchable = false;
			skipButton.removeEventListener(Event.TRIGGERED, handler_buttonSkipAlert);
			skipButton.addEventListener(Event.TRIGGERED, handler_buttonSkip);
			skipButton.defaultSkin = DoubleTitlesButtonContent.createBuyForCashButtonContent('YES', null, null, 0, backgroundContentBg.width - 24*pxScale, 0, 34);
			Starling.juggler.tween(skipButton, 0.2, {transition:Transitions.EASE_OUT, y:140*pxScale, onComplete:setViewTouchable, onCompleteArgs:[skipButton, true]});
			
			Starling.juggler.tween(backgroundContentBg, 0.2, {transition:Transitions.EASE_OUT, height:207*pxScale, y:160*pxScale});
			
			Starling.juggler.tween(skipLabel, 0.2, {transition:Transitions.EASE_OUT, y:85*pxScale});
			skipLabel.textStyle = XTextFieldStyle.getWalrus(30, 0xFFFFFF);
			skipLabel.text = 'ARE YOU SURE?';
			
			if (!backButton) {
				backButton = new XButton(XButtonStyle.RedButton, 'NO');
				backButton.width = backgroundContentBg.width - 24 * pxScale;
				backButton.height = 67 * pxScale;
				backButton.alignPivot();
				backButton.addEventListener(Event.TRIGGERED, handler_buttonBack);
				backButton.y = 218 * pxScale;
				addChild(backButton);
			}
			
			backButton.touchable = false;
			Starling.juggler.tween(backButton, 0.2, {transition:Transitions.EASE_OUT, alpha:1, onComplete:setViewTouchable, onCompleteArgs:[backButton, true]});
			
			Starling.juggler.tween(animationContainer, 0.2, {transition:Transitions.EASE_OUT, y:-200*pxScale});
			
			SoundManager.instance.playSfx(SoundAsset.ButtonClick, 0, 0, SoundAsset.DEFAULT_BUTTON_CLICK_VOLUME, 0, true);
		}
		
		private function handler_buttonBack(event:Event):void 
		{
			buttonsActionCallback();
			
			skipButton.touchable = false;
			skipButton.addEventListener(Event.TRIGGERED, handler_buttonSkipAlert);
			skipButton.removeEventListener(Event.TRIGGERED, handler_buttonSkip);
			skipButton.defaultSkin = skipButtonPriceSkin;
			Starling.juggler.tween(skipButton, 0.2, {transition:Transitions.EASE_OUT, y:218*pxScale, onComplete:setViewTouchable, onCompleteArgs:[skipButton, true]});
			
			Starling.juggler.tween(backgroundContentBg, 0.2, {transition:Transitions.EASE_OUT, height:140 * pxScale, y:195*pxScale});
			
			Starling.juggler.tween(skipLabel, 0.2, {transition:Transitions.EASE_OUT, y:159*pxScale});
			skipLabel.textStyle = XTextFieldStyle.getWalrus(33, 0xFFFFFF);
			skipLabel.text = 'SKIP FOR';
			
			if (backButton) {
				backButton.touchable = false;
				Starling.juggler.tween(backButton, 0.2, {transition:Transitions.EASE_OUT, alpha:0, onComplete:removeBackButton});
			}
			
			Starling.juggler.tween(animationContainer, 0.2, {transition:Transitions.EASE_OUT, y:-153*pxScale});
			
		}
		
		private function handler_buttonSkip(event:Event):void 
		{
			buttonsActionCallback();
			
			if (!checkCashEnougthWidthAlert())
				return;
				
			gameManager.questModel.skipQuest(quest);
		}
		
		private function handler_buttonBackToFront(event:Event):void 
		{
			if(randomPictureMode && ((getTimer() - creationTime) < 1000))
				return;
					
			buttonsActionCallback();
		}
		
		private function checkCashEnougthWidthAlert():Boolean 
		{
			if (Player.current.cashCount < quest.skipPrice) {
				var point:Point = new Point(0, 0 - 140 * pxScale);
				new ShowNoMoneyPopup(ShowNoMoneyPopup.PURPLE, this, point).execute();
				return false;
			}
			return true;
		}	
		
		private function setViewTouchable(view:DisplayObject, touchable:Boolean):void {
			view.touchable = touchable;
		}
		
		private function removeBackButton():void 
		{
			backButton.removeFromParent(true);
			backButton = null;
		}
		
		public function showSkipTweens(delay:Number, onComplete:Function, onCompleteArgs:Array):void
		{
			var effectPuffImage:Image = new Image(AtlasAsset.CommonAtlas.getTexture('effects/snowflake_2'));
			effectPuffImage.alignPivot();
			effectPuffImage.touchable = false;
			//effectPuffImage.y = -173; 
			addChild(effectPuffImage);
			
			effectPuffImage.height = 0;
			effectPuffImage.width = 700 * pxScale;
			TweenHelper.tween(effectPuffImage, 0.2, {width:490* pxScale, height:890* pxScale, transition:Transitions.EASE_OUT, delay:(delay + 0.05)})
				.chain(effectPuffImage, 0.15, {width:0, height:1050* pxScale, transition:Transitions.EASE_IN, onComplete:onComplete, onCompleteArgs:onCompleteArgs});
			
			
			var tween_0:Tween = new Tween(this, 0.07, Transitions.EASE_OUT);
			var tween_1:Tween = new Tween(this, 0.1, Transitions.EASE_OUT);
			
			tween_0.delay = delay + 0.15;
			tween_0.animate('scaleX', 1.1);
			tween_0.animate('scaleY', 0.9);
			tween_0.nextTween = tween_1;
			
			tween_1.animate('scaleX', 0);
			tween_1.animate('scaleY', 1.15);
			
			Starling.juggler.add(tween_0);
		}
		
		/*public function tweenHide(delay:Number):void
		{
			if (isHiding)
				return;
				
			isHiding = true;	
		}*/
		
		private function get skipButtonPriceSkin():DoubleTitlesButtonContent {
			return DoubleTitlesButtonContent.createBuyForCashButtonContent('SKIP', AtlasAsset.CommonAtlas.getTexture("store/cash_price_icon"), quest.skipPrice.toString(), 5*pxScale, backgroundContentBg.width - 28*pxScale, -4*pxScale, 32, 34);
		}
		
		private function handler_backgroundColoredTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(backgroundColored);
			if (touch == null)
				return;
			
			if (touch.phase == TouchPhase.ENDED)
			{
				if(randomPictureMode && ((getTimer() - creationTime) < 1500))
					return;
					
				if (backgroundTriggeredCallback != null) {
					backgroundTriggeredCallback();
					if (backButton) 
					{
						Starling.juggler.removeTweens(skipButton);
						Starling.juggler.removeTweens(backgroundContentBg);
						Starling.juggler.removeTweens(skipLabel);
						Starling.juggler.removeTweens(backButton);
						Starling.juggler.removeTweens(animationContainer);

						handler_buttonBack(null);
					}
				}
			}
		}
		
		public function colorBg(color:uint):void {
			invalidate();
			validate();
			backgroundColored.color = color;
		}
		
		private function commitShowDailyBackImage():void 
		{
			if (gameManager.questModel.dailyBackImageAsset && gameManager.questModel.dailyBackImageAsset.loaded) 
				showDailyBackImage();
			else
				gameManager.questModel.dailyBackImageAsset.load(showDailyBackImage, null);
		}
		
		private function showDailyBackImage(...args):void 
		{
			if (loadImage || !parent)
				return;
				
			loadImage = new Image(gameManager.questModel.dailyBackImageAsset.texture);
			loadImage.pivotX = loadImage.width/2;
			loadImage.pivotY = 7 * pxScale;
			loadImage.y = -150*pxScale;
			loadImage.rotation = Math.PI / 8;
			loadImage.addEventListener(TouchEvent.TOUCH, handler_loadImageTriggered);
			addChild(loadImage);
			
			TweenHelper.tween(loadImage, 0.3, {rotation:-Math.PI/14, transition:Transitions.EASE_OUT})
				.chain(loadImage, 1.7, {rotation:0, transition:Transitions.EASE_OUT_ELASTIC});
		}
		
		private function handler_loadImageTriggered(event:TouchEvent):void 
		{
			event.stopImmediatePropagation();
			
			var touch:Touch = event.getTouch(loadImage);
			if (!touch || touch.phase != TouchPhase.BEGAN)
				return;
			
			var kickAngle:Number = -20 * Math.PI / 180;
			
			if (Math.abs(loadImage.rotation) > Math.abs(0.85*kickAngle))
				return;
			
			Starling.juggler.removeTweens(loadImage);
			
			var timeRatio:Number = Math.abs(Math.abs(kickAngle-loadImage.rotation)/kickAngle);
			
			TweenHelper.tween(loadImage, timeRatio*0.2, {rotation:kickAngle, transition:Transitions.EASE_OUT})
				.chain(loadImage, 1.6, {rotation:0, transition:Transitions.EASE_OUT_ELASTIC});
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			if(randomPictureMode)
				gameManager.questModel.changeDailyBackImageIndex();	
			
			if(loadImage)
				loadImage.removeEventListener(Event.TRIGGERED, handler_loadImageTriggered);
		}
	}
}

