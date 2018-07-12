package com.alisacasino.bingo.screens.questsScreenClasses 
{
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.commands.player.ShowReservedDrops;
	import com.alisacasino.bingo.components.effects.AlphaMask;
	import com.alisacasino.bingo.components.effects.ParticleExplosion;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.IDialog;
	import com.alisacasino.bingo.models.quests.QuestModel;
	import com.alisacasino.bingo.models.quests.QuestType;
	import com.alisacasino.bingo.models.quests.questItems.QuestBase;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.UIConstructor;
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	import feathers.utils.touch.TapToTrigger;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Sprite3D;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextFieldAutoSize;
	import starling.utils.Align;
	import starling.utils.TweenHelper;
	
	public class QuestsScreen extends FeathersControl implements IDialog 
	{
		public static var WIDTH:uint = 1280;
		public static var HEIGHT:uint = 720;
		
		public static var DEBUG_COLORIZE_QUESTS:Boolean = false;
		
		public static var EVENT_RENDERER_TO_TOP:String = 'EVENT_RENDERER_TO_TOP';
		public static var EVENT_COMPLETE_EXPLODE_TO_TOP:String = 'EVENT_COMPLETE_EXPLODE_TO_TOP';
		
		public function QuestsScreen() 
		{
			debugShowCatCycleIndex = 0;
		}
		
		private const FUN_CAT_SHOW_INTERVAL:int = 2000;
		
		public static const AUTO_RETURN_RENDERERS_TO_FRONT_STATE_TIMEOUT:Number = 6.3;
		
		private var storedIsFirstStart:Boolean;
		
		private var closeButton:Button;
		
		private var fadeQuad:Quad;
		private var isShowing:Boolean = true;
		private var isHiding:Boolean;
		private var childrenCreated:Boolean;
		public var callShowReservedDropsOnClose:Boolean = true;
		
		private var rewardsContainer:Sprite;
		private var bottomLabel:XTextField;
		
		private var refreshQuestsDelayCallId:uint;
		
		private var catAnimationsTimer:Timer;
		//private var nextAnimationPriorityTargetRenderer:int;
		private var initCatAnimationShowed:Boolean;
		private var animationsParamsList:Array;
		private var catDisappearTime:uint;
		
		private var skipHintShowsCount:uint;
		
		private var isTutorMode:Boolean;
		private var alphaMask:AlphaMask;
		private var tutorStep:int;
		private var tutorNextStepDelayCallId:int = -1;
		
		public function get fadeStrength():Number 
		{
			return 0.00;
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
		}
		
		override protected function initialize():void 
		{
			super.initialize();
		
			//sosTrace("QuestScreen.initialize 1");
			
			storedIsFirstStart = gameManager.questModel.isFirstStart;
			
			if (gameManager.questModel.isFirstStart) 
			{
				gameManager.questModel.isFirstStart = false;
				gameManager.questModel.refreshQuests();
			}
			
			var quest:QuestBase = gameManager.questModel.getActiveQuestByType(QuestType.DAILY_QUEST);
			isTutorMode = quest && quest.isTutor && (int(quest.getProgress()) == 0) && !quest.rendererAction && !DEBUG_COLORIZE_QUESTS; 
			
			fadeQuad = new Quad(1, 1, 0x0);
			fadeQuad.addEventListener(TouchEvent.TOUCH, handler_touchFadeQuad);
			addChild(fadeQuad);
			
			//sosTrace("QuestScreen.initialize 2");
			
			skipHintShowsCount = int(gameManager.clientDataManager.getValue(QuestModel.KEY_HINT_SKIP_SHOWS_COUNT, 0));
			if (!isTutorMode && (skipHintShowsCount < QuestModel.SHOW_HINT_SKIP_MAX_COUNT) || DEBUG_COLORIZE_QUESTS) {
				bottomLabel = new XTextField(WIDTH*pxScale, 50*pxScale, XTextFieldStyle.getWalrus(34, 0xFFFFFF, Align.CENTER), "TAP ON QUEST TO VIEW SKIP OPTION");
				bottomLabel.touchable = false;
				bottomLabel.alpha = 0;
				addChild(bottomLabel);
				
				if (DEBUG_COLORIZE_QUESTS) {
					bottomLabel.touchable = true;
					bottomLabel.addEventListener(TouchEvent.TOUCH, handler_bottomLabelTouch);
				}
			}
			
			rewardsContainer = new Sprite();
			rewardsContainer.addEventListener(EVENT_RENDERER_TO_TOP, handler_rendererToTop);
			rewardsContainer.addEventListener(EVENT_COMPLETE_EXPLODE_TO_TOP, handler_completeExplodeToTop);
			addChild(rewardsContainer);
			//sosTrace("QuestScreen.initialize 3");
			closeButton = UIConstructor.dialogCloseButton(60, 30, AtlasAsset.CommonAtlas.getTexture('quests/go'));
			closeButton.addEventListener(Event.TRIGGERED, handler_closeButton);
			addChild(closeButton);
			
			catAnimationsTimer = new Timer(1000);
			catAnimationsTimer.addEventListener(TimerEvent.TIMER, handler_catAnimationsTimer);
			catAnimationsTimer.start();
			
			catDisappearTime = gameManager.questModel.isAnyQuestExpired ? (getTimer()/* + 200*/) : 0;
			//sosTrace("QuestScreen.initialize 4");
			
			gameManager.questModel.createQuestStyles();
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_DATA)) 
			{
				createChildren();
			}
			
			if (isInvalid(INVALIDATION_FLAG_SIZE)) 
				resize();
				
			tweenAppear();
			
			if (isTutorMode && !alphaMask) 
			{
				var questContainer:QuestRenderer3DContainer = getQuestContainerByQuestType(QuestType.DAILY_QUEST);
				if (questContainer)
				{
					//trace('sadsad', layoutHelper.stageWidth/scale, width/scale + 2*overWidth, width/scale + 2*overWidth/scale);
					alphaMask = new AlphaMask(overWidth + (width / scale) / 2, overHeight + (height/scale) / 2, width / 2, height / 2, layoutHelper.stageWidth / scale, layoutHelper.stageHeight / scale);
					alphaMask.alpha = 0.0;
					alphaMask.x = -overWidth;
					alphaMask.y = -overHeight;
					addChild(alphaMask);
					
					var tapToTrigger:TapToTrigger = new TapToTrigger(alphaMask);
					alphaMask.addEventListener(Event.TRIGGERED, handler_alphaMaskTriggered);
					
					tutorNextStepDelayCallId = Starling.juggler.delayCall(showTutorNextStep, 2.2);
				}
			}	
		}
		
		private function createChildren():void
		{
			if (childrenCreated)
				return;
			//sosTrace("QuestScreen.createChildren 1");
				
			childrenCreated = true;	
			
			gameManager.questModel.addEventListener(QuestModel.EVENT_UPDATE, handler_questsUpdate);
			
			gameManager.questModel.cleanQuestRendererActions();
			
			createQuestView(QuestType.EVENT_QUEST, gameManager.questModel.getActiveQuestByType(QuestType.EVENT_QUEST));
			createQuestView(QuestType.DAILY_QUEST, gameManager.questModel.getActiveQuestByType(QuestType.DAILY_QUEST));
			createQuestView(QuestType.BONUS_QUEST, gameManager.questModel.getActiveQuestByType(QuestType.BONUS_QUEST));
			
			addChild(closeButton);
			
			if (QuestModel.DEBUG_MODE) {
				var debugTouchLeftTopQuad:Quad = new Quad(140 * pxScale, 150 * pxScale, 0xFF0000);
				debugTouchLeftTopQuad.alpha = 0.0;
				debugTouchLeftTopQuad.x = -overWidth;
				debugTouchLeftTopQuad.addEventListener(TouchEvent.TOUCH, handler_debugShowNextCat);
				addChild(debugTouchLeftTopQuad);
			}
			//sosTrace("QuestScreen.createChildren 2");
			//setInterval(tween3D, 4000);
		}
		
		public function resize():void
		{
			var overHeight:int = this.overHeight;
			//sosTrace("QuestScreen.resize 1");
			if (fadeQuad) {
				fadeQuad.x = -overWidth-2;
				fadeQuad.y = -overHeight-2;
				fadeQuad.width = gameManager.layoutHelper.stageWidth/scale + 4;
				fadeQuad.height = gameManager.layoutHelper.stageHeight/scale + 4;
			}
			
			if (closeButton) {
				closeButton.x = width/scale + overWidth - closeButton.width / 2 + (layoutHelper.isIPhoneX ? 30 : 40) * pxScale;
				closeButton.y = 55*pxScale - overHeight / 2;
			}
			
			var i:int;
			var questContainer:QuestRenderer3DContainer;
			var length:int = rewardsContainer ? rewardsContainer.numChildren : 0;
			var packsWidth:int = length * QuestRenderer.WIDTH + (length - 1) * 63*pxScale;
			var rendererWidth:int = QuestRenderer.WIDTH;
			var packsPaddingLeft:int = (width/scale - packsWidth)/2 //Math.max(packsPaddingLeft, packsPivotX - packsWidth/2);
			for (i = 0; i < length; i++) 
			{
				questContainer = rewardsContainer.getChildAt(i) as QuestRenderer3DContainer;
				if (!questContainer || questContainer.questRenderer.isHiding)
					continue;
				
				alignQuestContainer(questContainer, isShowing);
			}
			
			if (bottomLabel/* && !isShowing*/) 
				bottomLabel.y = 663*pxScale + overHeight / 2;
		}
		
		public function alignQuestContainer(questContainer:QuestRenderer3DContainer, startYPosition:Boolean, tween:Boolean = false):void 
		{
			var maxQuestCount:int = 3;
			var packsWidth:int = maxQuestCount * QuestRenderer.WIDTH + (maxQuestCount - 1) * 63*pxScale;
			var rendererWidth:int = QuestRenderer.WIDTH;
			var packsPaddingLeft:int = (width / scale - packsWidth) / 2;
			
			var _x:int = packsPaddingLeft + questContainer.questRenderer.index * (rendererWidth + 63*pxScale) + rendererWidth/2;
			var _y:int = startYPosition ? ( -overHeight - QuestRenderer.HEIGHT / 2 - 50 * pxScale) : (QuestRenderer.HEIGHT / 2 + 94 * pxScale);
			if (tween) {
				Starling.juggler.tween(questContainer, 0.2, {x:_x, y:_y});
			}
			else {
				questContainer.x = _x;
				questContainer.y = _y;
			}
		}
		
		private function handler_questsUpdate(event:Event):void 
		{
			var quest:QuestBase;
			var questContainer:QuestRenderer3DContainer;
			var rendererQuest:QuestBase;
			var newQuestViewAppearDelay:Number = 0;
		//sosTrace("QuestScreen.handler_questsUpdate 1");
			var type:String;
			var i:int;
			var length:int = QuestType.allTypes.length;
			for (i = 0; i < length; i++)
			{
				type = QuestType.allTypes[i];
				//новый квест, старый либо клайм, либо таймаут 
				quest = gameManager.questModel.getActiveQuestByType(type);
				questContainer = getQuestContainerByQuestType(type);
				rendererQuest = questContainer ? questContainer.questRenderer.quest: null;
				
				if (!rendererQuest) 
				{
					if (quest)
					{
						if (questContainer) {
							questContainer.questRenderer.tweenHide(0);
							tweenDropDownDisappearQuestView(questContainer);
						}
					
						createAndShowNewQuestView(type, quest, 1, true);
					}
				}
				else if (rendererQuest != quest || rendererQuest.rendererAction) 
				{
					newQuestViewAppearDelay = 1.6;
					questContainer.questRenderer.tweenHide(0);
					
					if (rendererQuest.rendererAction == QuestRenderer.ACTION_CLAIMED) 
					{
						questContainer.questRenderer.showClaimTweens(0, removeQuestContainer, [questContainer]);
						tweenShowRewardText(questContainer.questRenderer, 0.15);	
						//questContainer.questRenderer.quest.rewardClaimed = false;
					}
					else if (rendererQuest.rendererAction == QuestRenderer.ACTION_EXPIRED) 
					{
						questContainer.questRenderer.tweenShowTimesUp(questContainer.isBackState ? 0.35 : 0);
						if (questContainer.isBackState)
							questContainer.showFrontState();
						tweenDropDownDisappearQuestView(questContainer, 1);
					}
					else if (rendererQuest.rendererAction == QuestRenderer.ACTION_SKIPPED) 
					{
						if (questContainer.isBackState) {
							questContainer.questSkipRenderer.showSkipTweens(0, removeQuestContainer, [questContainer]);
							newQuestViewAppearDelay = 0.45;
						}
						else {
							tweenDropDownDisappearQuestView(questContainer);
						}
					}
					else {
						questContainer.questRenderer.tweenHide(0);
						tweenDropDownDisappearQuestView(questContainer);
					}
					
					rendererQuest.rendererAction = null;
					
					createAndShowNewQuestView(type, quest, newQuestViewAppearDelay, true);
				}
				
				/*if (questContainer && questContainer.questRenderer.quest) {
					questContainer.questRenderer.tweenHide(0);
					tweenDropDownDisappearQuestView(questContainer);
					//questContainer.questRenderer.questContainer.questRenderer.quest.rendererAction = null;
					newQuestViewAppearDelay = 0.45;
					hideFunCats(true);
				}*/
			}
		}
		
		private function createAndShowNewQuestView(type:String, quest:QuestBase, delay:Number, widthNewBadge:Boolean):void 
		{
			var questContainer:QuestRenderer3DContainer = createQuestView(type, quest);
			alignQuestContainer(questContainer, true);
			questContainer.questRenderer.tweenAppear(delay + 0.15, widthNewBadge);
			tweenDropDownAppear(questContainer, 94 * pxScale + QuestRenderer.HEIGHT / 2, delay);
			
			hideFunCats(true);
		}
		
		private function createQuestView(type:String, quest:QuestBase):QuestRenderer3DContainer
		{
			var questContainer:QuestRenderer3DContainer = new QuestRenderer3DContainer(this, new QuestRenderer(getQuestRendererIndexByQuestType(type), type, quest), type != QuestType.DAILY_QUEST);
			//questContainer.alpha = 0.5;
			rewardsContainer.addChild(questContainer);
			return questContainer;
		}
		
		private function removeQuestContainer(questContainer:QuestRenderer3DContainer):void {
			questContainer.questRenderer.clean();
			questContainer.removeFromParent(true);
		}
		
		private function getQuestContainerByQuestType(type:String):QuestRenderer3DContainer
		{
			var i:int;
			var questContainer:QuestRenderer3DContainer;
			var length:int = rewardsContainer ? rewardsContainer.numChildren : 0;
			for (i = 0; i < length; i++) 
			{
				questContainer = rewardsContainer.getChildAt(i) as QuestRenderer3DContainer;
				if(questContainer && questContainer.questRenderer.type == type && !questContainer.questRenderer.isHiding)
					return questContainer;
			}
			
			return null;
		}
		
		private function getQuestRendererIndexByQuestType(type:String):int 
		{
			switch(type) {
				case QuestType.EVENT_QUEST: return 0;
				case QuestType.DAILY_QUEST: return 1;
				case QuestType.BONUS_QUEST: return 2;
			}
			
			return 0;
		}
		
		private function tweenAppear():void
		{
			if (!isShowing)
				return;
				
			isShowing = false;
			
			SoundManager.instance.playSfx(SoundAsset.RoundResultsPopup);
			
			var overHeight:int = this.overHeight;
			var overWidth:int = this.overWidth;
			
			if (fadeQuad) {
				fadeQuad.y = -fadeQuad.height - overHeight;
				Starling.juggler.tween(fadeQuad, 0.23, {y:-overHeight - 2});
			}
			
			var rendererHeight:int = QuestRenderer.HEIGHT;
			var i:int;
			var questContainer:QuestRenderer3DContainer;
			var delay:Number;
			var length:int = rewardsContainer ? rewardsContainer.numChildren : 0;
			for (i = 0; i < length; i++) 
			{
				questContainer = rewardsContainer.getChildAt(i) as QuestRenderer3DContainer;
				//questContainer.y = -overHeight - rendererHeight / 2 - 50 * pxScale;
				delay = 0.2 + i * 0.05;
				questContainer.questRenderer.tweenAppear(delay + 0.15, storedIsFirstStart);
				tweenDropDownAppear(questContainer, 94*pxScale + rendererHeight / 2, delay);
			}
			
			//closeButton.alpha = 0;
			EffectsManager.scaleJumpAppearElastic(closeButton, 1, 1, 1.5);
			//Starling.juggler.tween(closeButton, 0.4, {delay:2.0, alpha:1, transition:Transitions.LINEAR});
			
			refreshQuestsDelayCallId = Starling.juggler.delayCall(gameManager.questModel.refreshQuests, 1.6, true); 
			
			if (bottomLabel) {
				//bottomLabel.y = 300 * pxScale;
				Starling.juggler.tween(bottomLabel, 0.7, {delay:1.0, alpha:1, /*y:(663*pxScale + overHeight / 2),*/ transition:Transitions.LINEAR});
				EffectsManager.blinkAlpha(bottomLabel, 0.6, 0.5, 1, 0, 2);
			}
			
			if(!tutorStep)
				Starling.juggler.delayCall(gameManager.questModel.loadCurrentDailyBackImageAsset, 1.6); 
		}
		
		private function tweenHide():void
		{
			if (isHiding)
				return;	
				
			isHiding = true;
			
			var overHeight:int = this.overHeight;
			var overWidth:int = this.overWidth;
			
			if (fadeQuad) 
				Starling.juggler.tween(fadeQuad, 0.2, { delay: 0.27, y:(-fadeQuad.height-overHeight), transition:Transitions.EASE_IN });
			
			if (closeButton) {
				Starling.juggler.removeTweens(closeButton);
				closeButton.touchable = false;
				EffectsManager.scaleJumpDisappear(closeButton, 0.4);
			}
			
			var i:int;
			var questContainer:QuestRenderer3DContainer;
			var length:int = rewardsContainer ? rewardsContainer.numChildren : 0;
			for (i = 0; i < length; i++) 
			{
				questContainer = rewardsContainer.getChildAt(i) as QuestRenderer3DContainer;
				if (questContainer) 
				{
					Starling.juggler.removeTweens(questContainer);
					Starling.juggler.tween(questContainer, 0.2, {transition:Transitions.EASE_IN_BACK, scaleY:1.1, scaleX:0.8, y:( -overHeight - QuestRenderer.HEIGHT / 2 - 50 * pxScale), delay:questContainer.questRenderer.index * 0.1});
					
					questContainer.cleanDelayedShowFrontState();
					questContainer.questRenderer.tweenHide(0);
				}
				else {
					tweenUpAndRemoveCatAnimation(rewardsContainer.getChildAt(i) as AnimationContainer);
				}
			}
			
			length = numChildren;
			for (i = 0; i < length; i++) {
				tweenUpAndRemoveCatAnimation(getChildAt(i) as AnimationContainer);
			}
			
			if (bottomLabel) {
				Starling.juggler.removeTweens(bottomLabel);
				Starling.juggler.tween(bottomLabel, 0.3, {alpha:0, transition:Transitions.LINEAR});
			}
			
			Starling.juggler.delayCall(removeDialog, 0.75);
			
		}
		
		private function tweenDropDownAppear(view:DisplayObject, finishY:int, delay:Number = 0, onComplete:Function = null, onCompleteArgs:Array = null):void 
		{
			var tween_0:Tween = new Tween(view, 0.17, Transitions.EASE_IN);
			var tween_1:Tween = new Tween(view, 0.11, Transitions.EASE_OUT);
			var tween_2:Tween = new Tween(view, 0.25, Transitions.EASE_OUT_BACK);
			
			view.scaleX = 0.75;
			view.scaleY = 1.1;
			tween_0.delay = delay;
			tween_0.animate('y', finishY - 20*pxScale);
			tween_0.nextTween = tween_1;
			
			tween_1.animate('scaleX', 1.1);
			tween_1.animate('scaleY', 0.95);
			tween_1.animate('y', finishY + 15 * pxScale);
			tween_1.nextTween = tween_2;
			
			tween_2.animate('scaleX', 1);
			tween_2.animate('scaleY', 1);
			tween_2.animate('y', finishY);
			tween_2.onComplete = onComplete;
			tween_2.onCompleteArgs = onCompleteArgs;
			
			Starling.juggler.add(tween_0);
		}
		
		private function tweenDropDownDisappearQuestView(questContainer:QuestRenderer3DContainer, delay:Number = 0):void 
		{
			var tween_0:Tween = new Tween(questContainer, 0.14, Transitions.EASE_IN);
			var tween_1:Tween = new Tween(questContainer, 0.14, Transitions.EASE_OUT);
			var tween_2:Tween = new Tween(questContainer, 0.25, Transitions.EASE_IN);
			
			tween_0.delay = delay;
			tween_0.animate('scaleX', 0.92);
			tween_0.animate('scaleY', 1.08);
			tween_0.animate('y', questContainer.y - 35*pxScale);
			tween_0.nextTween = tween_1;
			
			tween_1.animate('scaleX', 1.10);
			tween_1.animate('scaleY', 0.90);
			tween_1.animate('y', questContainer.y - 75*pxScale);
			tween_1.nextTween = tween_2;
			
			tween_2.animate('scaleX', 0.72);
			tween_2.animate('scaleY', 1.15);
			tween_2.animate('y', height / scale + overHeight + QuestRenderer.HEIGHT / 2 + 50 * pxScale);
			tween_2.onComplete = removeQuestContainer;
			tween_2.onCompleteArgs = [questContainer];
			
			Starling.juggler.add(tween_0);
		}
		
		private function tweenShowRewardText(questRenderer:QuestRenderer, delay:Number = 0):void
		{
			var labelTopString:String = '';
			var labelBottomString:String = '';
			var labelTopColor:uint = 0xFFFFFF;
			var labelBottomColor:uint = 0xFFFFFF;
			var labelTopSize:uint = 97;
			var labelBottomSize:uint = 63;
			var labelBottomShiftY:int;
			var labelBottomLeading:int;
			var quest:QuestBase = questRenderer.quest;
			
			labelTopSize = 120;
			labelBottomSize = 43;
			
			
			
			switch(quest.reward.type)
			{
				case CommodityType.CASH: {
					labelTopSize = 97;
					labelBottomSize = 62;
					labelTopString = '+' + quest.reward.quantity.toString();
					labelBottomString = 'CASH';
					labelBottomColor = 0xF6A9FF;
					labelBottomShiftY = 25;
					break;
				}
				case CommodityType.DUST: {
					labelTopSize = 96;
					labelBottomSize = 42;
					labelTopString = '+' + quest.reward.quantity.toString();
					labelBottomString = 'EMERALD\nDUST';
					labelBottomColor = 0x2AFF00;
					labelBottomShiftY = 52;
					labelBottomLeading = -6;
					break;
				}
				case CommodityType.COLLECTION: {
					labelTopString = '+' + quest.reward.quantity.toString();
					labelBottomString = 'COLLECTION';
					labelBottomColor = 0x7DE9F4;
					break;
				}
				case CommodityType.CUSTOMIZER: {
					labelTopString = '+' + quest.reward.quantity.toString();
					labelBottomString = 'CUSTOMIZER';
					labelBottomColor = 0xFFE64E;
					break;
				}
				case CommodityType.POWERUP: {
					labelTopSize = 118;
					labelBottomSize = 41;
					labelTopString = '+' + quest.reward.quantity.toString();
					labelTopColor = 0xFFF600;
					labelBottomString = 'POWER-UPS';//quest.reward.subType.toUpperCase();
					labelBottomColor = 0xFF4B4B;
					labelBottomShiftY = -3;
					break;
				}
				case CommodityType.POWERUP_CARD: {
					labelTopSize = 118;
					labelBottomSize = 41;
					labelTopString = '+' + quest.reward.quantity.toString();
					labelTopColor = 0xFFF600;
					labelBottomString = 'POWER-UPS';
					labelBottomColor = 0xFF4B4B;
					labelBottomSize = 43;
					labelBottomShiftY = -3;
					break;
				}
			}
			
			var quest3DContainer:Sprite3D = questRenderer.parent as Sprite3D;
			
			var container:Sprite = new Sprite();
			addChild(container);
			
			var labelTop:XTextField = new XTextField(QuestRenderer.WIDTH, 135 * pxScale, XTextFieldStyle.getWalrus(labelTopSize, labelTopColor), labelTopString);
			labelTop.autoScale = true;
			labelTop.alignPivot();
			labelTop.y = 0;
			//labelTop.border = true;
			container.addChild(labelTop);
			
			var labelBottom:XTextField = new XTextField(QuestRenderer.WIDTH, 100 * pxScale, XTextFieldStyle.getWalrus(labelBottomSize, labelBottomColor), labelBottomString);
			if (labelBottomLeading != 0) 
				labelBottom.format.leading = labelBottomLeading * pxScale;
			//labelBottom.autoScale = true;
			labelBottom.alignPivot();
			
			//labelBottom.border = true;
			labelBottom.y = labelTop.y - labelTop.textBounds.y + labelTop.textBounds.height - labelBottom.textBounds.y - labelBottom.textBounds.height / 2 - 3*pxScale + labelBottomShiftY*pxScale;
			container.addChild(labelBottom);
			
			container.x = quest3DContainer.x;
			container.y = quest3DContainer.y + 10*pxScale;
			container.scale = 0;
			//trace(labelTop.textBounds.y , labelTop.textBounds.height, labelBottom.textBounds.y , labelBottom.textBounds.height);
			TweenHelper.tween(container, 1.18, {y:(container.y - 135 * pxScale), transition:Transitions.LINEAR, delay:delay});
			
			TweenHelper.tween(container, 0.19, {scaleX:0.75, scaleY:1.84, transition:Transitions.EASE_OUT, delay:delay}).
				chain(container, 0.15, {scaleX:1, scaleY:1, transition:Transitions.EASE_OUT}).
				chain(container, 0.09, {delay:0.75, alpha:0, transition:Transitions.LINEAR, onComplete:removeView, onCompleteArgs:[container, true]});
		}
		
		private function removeView(view:DisplayObject, dispose:Boolean):void 
		{
			view.removeFromParent(dispose);
		}
		
		private function removeDialog():void 
		{
			removeFromParent();
			
			if(callShowReservedDropsOnClose)
				new ShowReservedDrops(0.5).execute();	
			
			gameManager.questModel.unloadDailyBackImageAsset();	
		}
		
		private function get overHeight():int
		{
			return (Math.max(0, gameManager.layoutHelper.stageHeight - height) / 2) / scale;
		}
		
		private function get overWidth():int
		{
			return (Math.max(0, gameManager.layoutHelper.stageWidth - width) / 2) / scale;
		}
		
		private function handler_closeButton(e:Event):void
		{
			SoundManager.instance.playSfx(SoundAsset.ButtonClick, 0, 0, SoundAsset.DEFAULT_BUTTON_CLICK_VOLUME, 0, true);
			close();
		}
		
		public function get canRemoveExpiredQuests():Boolean {
			return refreshQuestsDelayCallId != 0 && !isHiding;
		}
		
		public function close():void 
		{
			catAnimationsTimer.removeEventListener(TimerEvent.TIMER, handler_catAnimationsTimer);
			catAnimationsTimer.stop();
			
			gameManager.questModel.removeEventListener(QuestModel.EVENT_UPDATE, handler_questsUpdate);
			if(refreshQuestsDelayCallId > 0)
				Starling.juggler.removeByID(refreshQuestsDelayCallId);
				
			tweenHide();
			
			if(tutorNextStepDelayCallId != -1)
				Starling.juggler.removeByID(tutorNextStepDelayCallId);
				
			EffectsManager.removeJump(closeButton); 	
			
			rewardsContainer.removeEventListener(EVENT_RENDERER_TO_TOP, handler_rendererToTop);
			rewardsContainer.removeEventListener(EVENT_COMPLETE_EXPLODE_TO_TOP, handler_completeExplodeToTop);
		}
		
		private function handler_alphaMaskTriggered():void 
		{
			showTutorNextStep();
		}
		
		private function showTutorNextStep():void 
		{
			tutorStep++;
			
			Starling.juggler.removeByID(tutorNextStepDelayCallId);
			
			var questContainer:QuestRenderer3DContainer = getQuestContainerByQuestType(QuestType.DAILY_QUEST);
			if (!questContainer)
				return;
				
			if (tutorStep == 0) {
				
			}
			else if (tutorStep == 1) {
				Starling.juggler.tween(alphaMask, 0.35, {alpha:0.78});
				alphaMask.tween(questContainer.x + overWidth, questContainer.y - 99 * pxScale + overHeight, 300 * pxScale, 110 * pxScale, false, 0.35, 0);
				tutorNextStepDelayCallId = Starling.juggler.delayCall(showTutorNextStep, 1.8);
				
				alphaMask.removeEventListener(Event.TRIGGERED, handler_alphaMaskTriggered);
			}
			else if (tutorStep == 2) {
				alphaMask.tween(questContainer.x + overWidth, questContainer.y + 79 * pxScale + overHeight, 300 * pxScale, 300 * pxScale, false, 0.3);
				tutorNextStepDelayCallId = Starling.juggler.delayCall(showTutorNextStep, 1.8);
			}
			else if (tutorStep == 3) {
				alphaMask.tween(questContainer.x + overWidth, questContainer.y + 240 * pxScale + overHeight, 310 * pxScale, 72 * pxScale, false, 0.3);
				tutorNextStepDelayCallId = Starling.juggler.delayCall(showTutorNextStep, 1.8);
			}
			else if (tutorStep == 4) {
				Starling.juggler.tween(alphaMask, 0.301, {alpha:0, onComplete:removeAlphaMask});
				alphaMask.tween(overWidth + (width / scale) / 2, overHeight + (height/scale) / 2, width / scale, height/scale, false, 0.3);
				
				//questContainer.questRenderer.jumpDescription();
				isTutorMode = false;
				
				EffectsManager.jump(closeButton, 10003, 1, 1.2, 0.12, 0.12, 2.5, 2, 2, 2.2); 
			}
		}
		
		private function removeAlphaMask():void {
			alphaMask.removeFromParent(true);
			alphaMask = null;
		}
		
		/*********************************************************************************************************************
		*
		* CAT
		* 
		*********************************************************************************************************************/		
		
		private const CAT_WALK:String = 'cat_walk';
		private const CAT_ARM:String = 'cat_arm';
		private const CAT_FACE:String = 'cat_face';
		private const CAT_POINTING:String = 'cat_pointing';
		private const CAT_POPUP:String = 'cat_popup';
		
		private function handler_catAnimationsTimer(event:TimerEvent):void
		{
			if (!initCatAnimationShowed) 
			{
				if (getTimer() >= (catDisappearTime + FUN_CAT_SHOW_INTERVAL))
				{
					if(Math.random() > 0.5)
						showCat(0, CAT_WALK);
					else 
						showCat(2, CAT_WALK, true);
					
					initCatAnimationShowed = true;
				}
				
				return;
			}
			
			playNextCatAnimation();
		}
		
		public function showCat(rendererIndex:int, catType:String, invert:Boolean = false):void
		{
			var questContainer:QuestRenderer3DContainer = getQuestRenderer3DContainerByIndex(rendererIndex);	
			if(!questContainer || !questContainer.questRenderer.quest || isAnyRendererInAction || isTutorMode)
				return;
				
			switch(catType) {
				case CAT_WALK:		showWalkCat(questContainer, rendererIndex, catType, invert); break;
				case CAT_FACE:		showCatFace(questContainer, rendererIndex, catType, invert); break;
				case CAT_ARM:		showCatArm(questContainer, rendererIndex, catType, invert); break;
				case CAT_POPUP:		showCatPopup(questContainer, rendererIndex, catType, invert); break;
				case CAT_POINTING:	showCatPointing(questContainer, rendererIndex, catType, invert); break;
			}
		}
		
		public function hideFunCats(hardHide:Boolean = false):void
		{
			var i:int;
			var questContainer:QuestRenderer3DContainer;
			var animationContainer:AnimationContainer;
			var length:int = rewardsContainer ? rewardsContainer.numChildren : 0;
			for (i = 0; i < length; i++) 
			{
				questContainer = rewardsContainer.getChildAt(i) as QuestRenderer3DContainer;
				if (questContainer/* && !questContainer.questRenderer.isHiding*/) 
					hideCatAnimation(questContainer.getCatAnimation(), hardHide);
				else 
					hideCatAnimation(rewardsContainer.getChildAt(i) as AnimationContainer, hardHide);
			}
			
			length = numChildren;
			for (i = 0; i < length; i++) {
				hideCatAnimation(getChildAt(i) as AnimationContainer, hardHide);
			}
			
			catDisappearTime = getTimer(); //+ 2000;
		}
		
		private function showWalkCat(questContainer:QuestRenderer3DContainer, rendererIndex:int, catType:String, invert:Boolean = false):void
		{
			var helperQuestContainer:QuestRenderer3DContainer;
			
			if (rendererIndex == 0 || rendererIndex == 2)
				helperQuestContainer = getQuestRenderer3DContainerByIndex(1);
			else if (rendererIndex == 1)
				helperQuestContainer = getQuestRenderer3DContainerByIndex(invert ? 2 : 0);
			
			if (!helperQuestContainer)
					return;	
					
			var animationContainer:AnimationContainer = getCatAnimation(true);
			animationContainer.pivotX = 110 * pxScale;
			animationContainer.y = questContainer.y - 50 * pxScale;
			addChildAt(animationContainer, getChildIndex(fadeQuad) + 1);
			
			animationContainer.scaleX = invert ? -1 : 1;
			
			if (rendererIndex == 0)
			{
				animationContainer.x = invert ? helperQuestContainer.x : (-overWidth - 110*pxScale);
			}
			else if (rendererIndex == 2)
			{
				animationContainer.x = invert ? (width / scale + overWidth + 110 * pxScale) : helperQuestContainer.x ;
			}
			else if (rendererIndex == 1)
			{
				animationContainer.x = helperQuestContainer.x;
			}
			
			var time:Number = Math.abs(questContainer.x - animationContainer.x) / 200;
			
			catDisappearTime = getTimer() + time * 1000;
			
			animationContainer.data = questContainer.x;
			
			Starling.juggler.tween(animationContainer, time, {x:questContainer.x, onComplete:removeView, onCompleteArgs:[animationContainer, true]});
			
			animationContainer.playTimeline(catType, true, true, 60);	
		}
		
		private function showCatFace(questContainer:QuestRenderer3DContainer, rendererIndex:int, catType:String, invert:Boolean = false):void
		{
			var animationContainer:AnimationContainer = getCatAnimation();
			animationContainer.scale = 0.84;
			animationContainer.y = questContainer.y - 50 * pxScale;
			rewardsContainer.addChildAt(animationContainer, rewardsContainer.getChildIndex(questContainer));
			
			animationContainer.scaleX = invert ? -1 : 1;
			animationContainer.x = questContainer.x + (invert ? ( -QuestRenderer.WIDTH / 2) : (QuestRenderer.WIDTH / 2));
			animationContainer.playTimeline(catType, true, true, 60);	
			
			var cyclingTime:Number = 0//animationContainer.cycle(30, 165, 1);
			
			catDisappearTime = getTimer() + 1500 + int(cyclingTime*1000);
		}
		
		private function showCatArm(questContainer:QuestRenderer3DContainer, rendererIndex:int, catType:String, invert:Boolean = false):void
		{
			var helperQuestContainer:QuestRenderer3DContainer;
			
			if (rendererIndex == 0 || rendererIndex == 2)
				helperQuestContainer = getQuestRenderer3DContainerByIndex(1, true);
			else if (rendererIndex == 1)
				helperQuestContainer = getQuestRenderer3DContainerByIndex(invert ? 0 : 2, true);
			
			if (!helperQuestContainer)
					return;	
			
			var animationContainer:AnimationContainer = getCatAnimation();
			animationContainer.y = questContainer.y + 35 * pxScale;
			rewardsContainer.addChildAt(animationContainer, rewardsContainer.getChildIndex(questContainer) + 1);
			
			if (rendererIndex == 0)
			{
				animationContainer.x = helperQuestContainer.x - QuestRenderer.WIDTH / 2;
			}
			else if (rendererIndex == 2)
			{
				animationContainer.scaleX = -1
				animationContainer.x = helperQuestContainer.x + QuestRenderer.WIDTH/2;
			}
			else if (rendererIndex == 1)
			{
				if (invert)
				{
					animationContainer.scaleX = -1
					animationContainer.x = helperQuestContainer.x + QuestRenderer.WIDTH/2;
				}
				else
				{
					animationContainer.x = helperQuestContainer.x - QuestRenderer.WIDTH / 2;
				}
			}
			
			animationContainer.playTimeline(catType, true, true, 60);	
			
			var cyclingTime:Number = 0//animationContainer.cycle(55, 130, 2);
			
			catDisappearTime = getTimer() + 1800 + int(cyclingTime*1000);
		}
		
		private function showCatPopup(questContainer:QuestRenderer3DContainer, rendererIndex:int, catType:String, invert:Boolean = false):void
		{
			var animationContainer:AnimationContainer = getCatAnimation();
			
			questContainer.addChild(animationContainer);
			
			animationContainer.playTimeline(catType, true, true, 60);	
			animationContainer.data = questContainer//.questRenderer.index;
			
			var cyclingTime:Number = 0//animationContainer.cycle(55, 190, 1);
			
			if (invert) 
			{
				animationContainer.scaleY = -1;
				animationContainer.y = QuestRenderer.HEIGHT/2;
			}
			else 
			{
				animationContainer.y = -QuestRenderer.HEIGHT/2;
			}
			
			TweenHelper.tween(questContainer, 0.3, { y:(questContainer.y + (invert ? -10 : 20)*pxScale), delay:0.1, transition:Transitions.EASE_IN} )
				.chain(questContainer, 0.6, {y:questContainer.y, transition:Transitions.EASE_OUT_BACK, delay:(3.1 + cyclingTime) } );	
		
			catDisappearTime = getTimer() + 3600 + int(cyclingTime*1000);	
		}
		
		private function showCatPointing(questContainer:QuestRenderer3DContainer, rendererIndex:int, catType:String, invert:Boolean = false):void
		{
			var helperQuestContainer:QuestRenderer3DContainer;
			
			if (rendererIndex == 0 || rendererIndex == 2)
				helperQuestContainer = getQuestRenderer3DContainerByIndex(1, true);
			else if (rendererIndex == 1)
				helperQuestContainer = getQuestRenderer3DContainerByIndex(invert ? 0 : 2, true);
			
			if (!helperQuestContainer)
					return;
			
			var animationContainer:AnimationContainer = getCatAnimation();	
			animationContainer.y = 30 * pxScale;
			
			if (rendererIndex == 0)
			{
				helperQuestContainer.addChild(animationContainer);
				animationContainer.x = -QuestRenderer.WIDTH / 2;
			}
			else if (rendererIndex == 2)
			{
				animationContainer.scaleX = -1;
				helperQuestContainer.addChild(animationContainer);
				animationContainer.x = QuestRenderer.WIDTH/2;
			}
			else if (rendererIndex == 1)
			{
				if (invert)
				{
					animationContainer.scaleX = -1;
					helperQuestContainer.addChild(animationContainer);
					animationContainer.x = QuestRenderer.WIDTH/2;
				}
				else
				{
					helperQuestContainer.addChild(animationContainer);
					animationContainer.x = -QuestRenderer.WIDTH / 2;
				}
			}
			
			animationContainer.playTimeline(catType, true, true, 60);	
			
			var cyclingTime:Number = animationContainer.cycle(catType, 50, 110, 1, true);
			
			catDisappearTime = getTimer() + 2100 + int(cyclingTime*1000);	
		}
		
		private function getCatAnimation(loop:Boolean = false):AnimationContainer
		{
			var animationContainer:AnimationContainer = new AnimationContainer(MovieClipAsset.PackCommon, loop, true);
			//animationContainer.touchable = false;
			animationContainer.currentClip.showBounds(true)
			animationContainer.addEventListener(TouchEvent.TOUCH, handler_catTouch);
			if (!loop) {
				animationContainer.dispatchOnCompleteTimeline = true;
				animationContainer.addEventListener(AnimationContainer.EVENT_COMPLETE_TIMELINE, handler_catAnimationComplete);
			}
			return animationContainer;
		}	
		
		private function handler_catTouch(event:TouchEvent):void 
		{
			event.stopImmediatePropagation();
			
			var touch:Touch = event.getTouch(event.target as DisplayObject);
			if (!touch || touch.phase != TouchPhase.BEGAN)
				return;
			
			hideFunCats();
			
			catDisappearTime = getTimer() - FUN_CAT_SHOW_INTERVAL + 250;
			Starling.juggler.delayCall(playNextCatAnimation, 0.26);
		}		
		
		private function hideCatAnimation(animation:AnimationContainer, hardHide:Boolean = false):void 
		{
			if (!animation)
				return;
				
			animation.removeEventListener(TouchEvent.TOUCH, handler_catTouch);
				
			if (animation.currentTimelineID == CAT_POPUP) 
			{
				Starling.juggler.removeTweens(animation);
				/*if (hardHide) {
					Starling.juggler.tween(animation, 0.1, {scaleX:0, onComplete:removeView, onCompleteArgs:[animation, true]});
				}
				else {*/
					animation.playTimeline(CAT_POPUP, true, true, 120);	
					animation.goToAndPlay(189);
					//Starling.juggler.tween(animation, 0.1, {scaleX:0, onComplete:removeView, onCompleteArgs:[animation, true]});
					
					alignQuestContainer(animation.data as QuestRenderer3DContainer, false, true);
				//}
			}
			else if (animation.currentTimelineID == CAT_WALK) {
				Starling.juggler.removeTweens(animation);
				animation.playTimeline(CAT_WALK, true, true, 120);	
				Starling.juggler.tween(animation, hardHide ? 0.1 : 0.3, {x:int(animation.data), onComplete:removeView, onCompleteArgs:[animation, true]});
			}
			else {
				Starling.juggler.removeTweens(animation);
				Starling.juggler.tween(animation, 0.1, {scaleX:0, onComplete:removeView, onCompleteArgs:[animation, true]});
			}
		}
		
		private function tweenUpAndRemoveCatAnimation(animation:AnimationContainer):void 
		{
			if (!animation)
				return;
			
			Starling.juggler.removeTweens(animation);
			Starling.juggler.tween(animation, 0.2, {y:(-overHeight - QuestRenderer.HEIGHT / 2 - 50 * pxScale), delay:0.2, onComplete:removeView, onCompleteArgs:[animation, true]});
		}
		
		private function handler_catAnimationComplete(e:Event):void 
		{
			var animationContainer:AnimationContainer = e.target as AnimationContainer; 
			animationContainer.stop();
			animationContainer.removeFromParent(true);
		}
		
		private function getQuestRenderer3DContainerByIndex(index:int, makeTop:Boolean = false):QuestRenderer3DContainer
		{
			var i:int;
			var questContainer:QuestRenderer3DContainer;
			var length:int = rewardsContainer ? rewardsContainer.numChildren : 0;
			for (i = 0; i < length; i++) 
			{
				questContainer = rewardsContainer.getChildAt(i) as QuestRenderer3DContainer;
				if (questContainer && questContainer.questRenderer.index == index /*&& questContainer.questRenderer.quest*/ && !questContainer.questRenderer.isHiding) {
					if (makeTop)
						rewardsContainer.addChild(questContainer);
					return questContainer;
				}
			}
			
			return null;
		}
		
		private function get isAnyRendererInAction():Boolean
		{
			var i:int;
			var questContainer:QuestRenderer3DContainer;
			var length:int = rewardsContainer ? rewardsContainer.numChildren : 0;
			for (i = 0; i < length; i++) 
			{
				questContainer = rewardsContainer.getChildAt(i) as QuestRenderer3DContainer;
				if (questContainer) {
					if (questContainer.questRenderer.isHiding)
						continue;
					
					if (!questContainer.backStateAvailable && ((questContainer.rotationY%(Math.PI/2)) == 0))
						continue;
						
					if (questContainer.isBackState || Starling.juggler.containsTweens(questContainer))
						return true;
				}
			}
			
			return false;
		}
		
		
		private function playNextCatAnimation():void 
		{
			if (getTimer() < (catDisappearTime + FUN_CAT_SHOW_INTERVAL))
				return;
			
			if (!animationsParamsList || animationsParamsList.length == 0)
				fillAnimationParamsList();
				
			var length:int = animationsParamsList.length;
			var randomIndex:int = Math.floor(length * Math.random());
			var params:Array = animationsParamsList.splice(randomIndex, 1)[0];
			
			if (params[0] == 1 && (params[1] == CAT_ARM || params[1] == CAT_POINTING)) {
				var questContainer:QuestRenderer3DContainer = getQuestContainerByQuestType(QuestType.DAILY_QUEST);
				if (questContainer && questContainer.questRenderer.quest && questContainer.isBackState)
					return;
			}
			
			showCat.apply(null, params);
			//nextAnimationPriorityTargetRenderer
		}
		
		public function fillAnimationParamsList():void
		{
			animationsParamsList = [
				[1, CAT_WALK, false],
				[1, CAT_WALK, true],
				[0, CAT_WALK, true],
				[2, CAT_WALK, false],
				[0, CAT_FACE, false],
				[0, CAT_FACE, true],
				[1, CAT_FACE, false],
				[1, CAT_FACE, true],
				[2, CAT_FACE, false],
				[2, CAT_FACE, true],
				[0, CAT_ARM, false],
				[1, CAT_ARM, true],
				[1, CAT_ARM, false],
				[2, CAT_ARM, true],
				[0, CAT_POPUP, false],
				[1, CAT_POPUP, false],
				[2, CAT_POPUP, false],
				/*[0, CAT_POPUP, true],
				[1, CAT_POPUP, true],
				[2, CAT_POPUP, true],*/
				[0, CAT_POINTING, true],
				[1, CAT_POINTING, false],
				[1, CAT_POINTING, true],
				[2, CAT_POINTING, false]
			];
			
			/*animationsParamsList = [
				[0, CAT_POPUP, false],
				[1, CAT_POPUP, false],
				[2, CAT_POPUP, false]//,
				//[0, CAT_POPUP, true],
				//[1, CAT_POPUP, true],
				//[2, CAT_POPUP, true]//,
				//[0, CAT_POINTING, true],
				//[1, CAT_POINTING, false],
				//[1, CAT_POINTING, true],
				//[2, CAT_POINTING, false]
			];*/
		}
		
		public function hideSkipHintLabel():void 
		{
			if (!bottomLabel || isHiding || isShowing)
				return;
				
			skipHintShowsCount++;
			gameManager.clientDataManager.setValue(QuestModel.KEY_HINT_SKIP_SHOWS_COUNT, skipHintShowsCount);
			Starling.juggler.removeTweens(bottomLabel);
			Starling.juggler.tween(bottomLabel, 0.15, {alpha:0, onComplete:removeView, onCompleteArgs:[bottomLabel, true]});
		}
		
		public function questRenderersToFrontState(excludeContainer:QuestRenderer3DContainer = null):void 
		{
			var i:int;
			var questContainer:QuestRenderer3DContainer;
			var length:int = rewardsContainer ? rewardsContainer.numChildren : 0;
			for (i = 0; i < length; i++) 
			{
				questContainer = rewardsContainer.getChildAt(i) as QuestRenderer3DContainer;
				if (questContainer) {
					if (!questContainer.isBackState || questContainer.questRenderer.isHiding || questContainer == excludeContainer)
						continue;
					
					questContainer.showFrontState(true);
				}
			}
		}
		
		private function handler_touchFadeQuad(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.target as DisplayObject);
			if (touch && touch.phase == TouchPhase.ENDED) 
			{
				var questHalfWidth:int = (QuestRenderer.WIDTH / 2) * scale;
				var questHalfHeight:int = (QuestRenderer.HEIGHT / 2) * scale;
				if (touch.globalX > (layoutHelper.stageWidth / 2 - questHalfWidth) && touch.globalX < (layoutHelper.stageWidth / 2 + questHalfWidth) && 
					touch.globalY > (layoutHelper.stageHeight / 2 - questHalfHeight) && touch.globalY < (layoutHelper.stageHeight / 2 + questHalfHeight))
				{
					var questContainer:QuestRenderer3DContainer = getQuestRenderer3DContainerByIndex(getQuestRendererIndexByQuestType(QuestType.DAILY_QUEST));
					if(questContainer)
						questContainer.tweenCick();
				}
				else {
					questRenderersToFrontState();
				}
			}
		}
		
		private function handler_rendererToTop(event:Event):void
		{
			getQuestRenderer3DContainerByIndex(int(event.data), true);
		}
		
		private function handler_completeExplodeToTop(event:Event):void
		{
			var questContainer:QuestRenderer3DContainer = getQuestRenderer3DContainerByIndex(int(event.data.index));
			var particleExplosion:ParticleExplosion = event.data.particleExplosion;
			particleExplosion.x += rewardsContainer.x + questContainer.x;
			particleExplosion.y += rewardsContainer.y + questContainer.y;
			addChild(particleExplosion);
		}
		
		/********************************************************************************************************************************
		* 
		* DEBUG:
		* 
		********************************************************************************************************************************/
		
		private static var debugShowCatCycleIndex:int;
		
		public function debugShowCatCycle():void
		{
			var params:Array = [
				[0, CAT_WALK, false],
				[2, CAT_WALK, true],
				[1, CAT_WALK, false],
				[1, CAT_WALK, true],
				[0, CAT_WALK, true],
				[2, CAT_WALK, false]
			];
			
			params = params.concat([
				[0, CAT_FACE, false],
				[0, CAT_FACE, true],
				[1, CAT_FACE, false],
				[1, CAT_FACE, true],
				[2, CAT_FACE, false],
				[2, CAT_FACE, true]
			]);
			
			params = params.concat([
				[0, CAT_ARM, false],
				[1, CAT_ARM, true],
				[1, CAT_ARM, false],
				[2, CAT_ARM, true]
			]);
			
			params = params.concat([
				[0, CAT_POPUP, false],
				[1, CAT_POPUP, false],
				[2, CAT_POPUP, false],
				[0, CAT_POPUP, true],
				[1, CAT_POPUP, true],
				[2, CAT_POPUP, true]
			]);
			
			params = params.concat([
				[0, CAT_POINTING, true],
				[1, CAT_POINTING, false],
				[1, CAT_POINTING, true],
				[2, CAT_POINTING, false]
			]);
			
			//params = [ [0, CAT_POINTING, true]];
			//params = [ [0, CAT_POPUP, true]];
			/*
			params = [
				[0, CAT_POPUP, false],
				[1, CAT_POPUP, false],
				[2, CAT_POPUP, false]
			];
			
			params = [
				[0, CAT_POINTING, true],
				[1, CAT_POINTING, false],
				[1, CAT_POINTING, true],
				[2, CAT_POINTING, false]
			];
			
			params = [
				[0, CAT_FACE, false],
				[0, CAT_FACE, true],
				[1, CAT_FACE, false],
				[1, CAT_FACE, true],
				[2, CAT_FACE, false],
				[2, CAT_FACE, true]
			];
			
			params = [
				[0, CAT_ARM, false],
				[1, CAT_ARM, true],
				[1, CAT_ARM, false],
				[2, CAT_ARM, true]
			];*/
			
			params = [
				[1, CAT_POINTING, true],
				[2, CAT_POINTING, false],
				[1, CAT_POPUP, false],
				[2, CAT_POPUP, false],
				[1, CAT_FACE, false],
				[1, CAT_FACE, true],
				[0, CAT_ARM, false],
				[1, CAT_ARM, true]
			];
			
			showCat.apply(null, params[debugShowCatCycleIndex]);
			
			debugShowCatCycleIndex++;
			if (debugShowCatCycleIndex >= params.length)
				debugShowCatCycleIndex = 0;
		}
		
		private function handler_debugShowNextCat(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
			
			var touch:Touch = event.getTouch(event.target as DisplayObject);
			if (touch == null)
				return;
			
			if (touch.phase == TouchPhase.ENDED)
			{
				catAnimationsTimer.stop();
				catAnimationsTimer.removeEventListener(TimerEvent.TIMER, handler_catAnimationsTimer);
				
				debugShowCatCycle();
			}
		}
		
		private function handler_bottomLabelTouch(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
			
			var touch:Touch = event.getTouch(bottomLabel);
			if (touch == null)
				return;
			
			if (touch && touch.phase == TouchPhase.BEGAN)
			{
				Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				
				function onMouseUp(e:MouseEvent):void {
					Starling.current.nativeStage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					
					gameManager.questModel.toClipboardDebugColors();
					EffectsManager.scaleJump(closeButton);
				}
			}	
		}
		
		/*private function tween3D():void
		{
			var i:int;
			var questContainer:QuestRenderer3DContainer;
			var length:int = (rewardsContainer ? rewardsContainer.numChildren : 0) - 1;
			var mult:int;
			for (i = 0; i < length; i++) 
			{
				questContainer = rewardsContainer.getChildAt(i) as QuestRenderer3DContainer;
				
				mult = i%2 == 0 ? 1 : (-1);
				
				Starling.juggler.removeTweens(questContainer);
				if (questContainer.rotationY != 0)
				{
					questContainer.rotationY += mult*Math.PI / 12;
				}
				
				TweenHelper.tween(placeholder3DSprite, 0.35, { rotationY:mult*Math.PI / 4, transition:Transitions.EASE_OUT } )
					.chain(placeholder3DSprite, 1.5, { rotationY:0, transition:Transitions.EASE_OUT_ELASTIC } );
			}
		}*/
	}

}

import com.alisacasino.bingo.Game;
import com.alisacasino.bingo.assets.AnimationContainer;
import com.alisacasino.bingo.assets.AtlasAsset;
import com.alisacasino.bingo.assets.SoundAsset;
import com.alisacasino.bingo.models.quests.QuestModel;
import com.alisacasino.bingo.resize.ResizeUtils;
import com.alisacasino.bingo.screens.questsScreenClasses.QuestsScreen;
import com.alisacasino.bingo.utils.sounds.SoundManager;
import starling.animation.Transitions;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.display.Sprite3D;
import com.alisacasino.bingo.screens.questsScreenClasses.QuestRenderer;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.TweenHelper;
import com.alisacasino.bingo.screens.questsScreenClasses.QuestSkipRenderer;

class QuestRenderer3DContainer extends Sprite3D 
{
	private var questsScreen:QuestsScreen;
	public var questRenderer:QuestRenderer;
	public var questSkipRenderer:QuestSkipRenderer;
	private var commitShowBackState:Boolean;
	private var _backStateAvailable:Boolean;
	
	private var delayedShowFrontStateId:int = -1;
	
	public function QuestRenderer3DContainer(questsScreen:QuestsScreen, questRenderer:QuestRenderer, backStateAvailable:Boolean = true) 
	{
		this.questsScreen = questsScreen;
		this.questRenderer = questRenderer;
		_backStateAvailable = backStateAvailable;
		
		questRenderer.backgroundTriggeredCallback = callbackQuestRendererTriggered;
		addChild(questRenderer);
		
		if (!backStateAvailable) {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedToStage);
		}
	}
	
	public function get isBackState():Boolean {
		return /*(questSkipRenderer && questSkipRenderer.parent) || */commitShowBackState;
	}
	
	public function get backStateAvailable():Boolean {
		return _backStateAvailable;
	}
	
	public function getCatAnimation():AnimationContainer 
	{
		var i:int;
		var animationContainer:AnimationContainer;
		var length:int = numChildren;
		for (i = 0; i < length; i++) 
		{
			animationContainer = getChildAt(i) as AnimationContainer;
			if (animationContainer) 
				return animationContainer;
		}
		
		return null;
	}
	
	public function showFrontState(callAlignQuestContainer:Boolean = false):void 
	{
		SoundManager.instance.playSfx(SoundAsset.CardShutter, 0, 0, 0.5, 0, true);
		
		if (_backStateAvailable) 
			cleanDelayedShowFrontState();
		
		Starling.juggler.removeTweens(this);
		commitShowBackState = false;
		TweenHelper.tween(this, 0.3, { rotationY:Math.PI/2, transition:Transitions.EASE_IN, onComplete:changeViewToFront} )
			.chain(this, 0.4, { rotationY:0, transition:Transitions.EASE_OUT_BACK } );	
			
		questsScreen.alignQuestContainer(this, false, true);
	}
	
	private function callbackQuestRendererTriggered():void
	{
		if (!questRenderer.quest) {
			return;
		}
		
		SoundManager.instance.playSfx(SoundAsset.CardShutter, 0, 0, 0.5, 0, true);
		
		questsScreen.hideFunCats();
		
		if (!backStateAvailable)
		{
			tweenCick();
			return;
		}
		
		resetDelayedShowFrontState();
		
		questsScreen.questRenderersToFrontState(this);
		questsScreen.hideSkipHintLabel();
		
		Starling.juggler.removeTweens(this);
		commitShowBackState = true;
		TweenHelper.tween(this, 0.3, { rotationY:Math.PI/2, transition:Transitions.EASE_IN, onComplete:changeViewToBack} )
			.chain(this, 0.4, { rotationY:Math.PI, transition:Transitions.EASE_OUT_BACK } );	
	}

	private function callbackQuestSkipRendererTriggered():void
	{
		showFrontState();
	}

	private function changeViewToBack():void 
	{
		var animationContainer:AnimationContainer;
		var i:int;
		while (i < numChildren) {
			animationContainer = getChildAt(i) as AnimationContainer;
			if (animationContainer) {
				animationContainer.stop();
				animationContainer.removeFromParent(true);
			}
			else {
				i++; 
			}
		}
		
		questsScreen.alignQuestContainer(this, false, true);
		
		questRenderer.visible = false;
		
		if (!questSkipRenderer) {
			questSkipRenderer = new QuestSkipRenderer(questRenderer.index, questRenderer.type, questRenderer.quest, backStateAvailable ? resetDelayedShowFrontState : showFrontState, !backStateAvailable);
			questSkipRenderer.backgroundTriggeredCallback = callbackQuestSkipRendererTriggered;
		}
			
		questSkipRenderer.scaleX = -1;	
			
		if (QuestsScreen.DEBUG_COLORIZE_QUESTS && questRenderer.quest && questRenderer.quest.type in QuestModel.debugBgColorsList) {
			questSkipRenderer.colorBg(((QuestModel.debugBgColorsList[questRenderer.quest.type] as Array)[QuestModel.debugBgColorsIndex[questRenderer.quest.type]] as uint));
		}
		
		addChild(questSkipRenderer);
	}
	
	private function changeViewToFront():void {
		questRenderer.visible = true;
		
		if (questSkipRenderer) {
			questSkipRenderer.removeFromParent(true);
			questSkipRenderer = null;
		}	
	}
	
	private function resetDelayedShowFrontState():void
	{
		cleanDelayedShowFrontState();
		delayedShowFrontStateId = Starling.juggler.delayCall(showFrontState, QuestsScreen.AUTO_RETURN_RENDERERS_TO_FRONT_STATE_TIMEOUT);
	}
		
	public function cleanDelayedShowFrontState():void
	{
		if (delayedShowFrontStateId != -1) {
			Starling.juggler.removeByID(delayedShowFrontStateId);
			delayedShowFrontStateId = -1;
		}
	}
	
	override public function dispose():void 
	{
		if (!backStateAvailable) {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedToStage);
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		super.dispose();
	}
	
	/********************************************************************************************************************************
	* 
	* 
	* 
	********************************************************************************************************************************/
	
	private var cickAmplitudeMax:Number = 55 * Math.PI/ 180;
	private var cickAmplitudeMin:Number = 7 * Math.PI/ 180;
	private var cickAmplitude:Number = 10 * Math.PI/ 180;
	private var cickAmplitudeAdd:Number = 12 * Math.PI / 180;
	
	private var cickMaxCount:int = 0;
	
	private function onAddedToStage(e:Event):void
	{
		addEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}
	
	private function onRemovedToStage(e:Event):void
	{
		removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}
	
	private function enterFrameHandler(e:Event):void 
	{
		cickAmplitude = Math.max(cickAmplitude - 0.45 * Math.PI / 180, cickAmplitudeMin);
		//trace(cickAmplitude, cickAmplitude - 0.45 * Math.PI / 180, Math.max(cickAmplitude - 0.45 * Math.PI / 180, cickAmplitudeMin));
		
	}
	
	public function tweenCick(customAmplitude:Number = 0):void 
	{
		if(commitShowBackState || (questSkipRenderer && questSkipRenderer.parent))
			return;
			
		cickAmplitude = customAmplitude == 0 ? Math.min(cickAmplitude + cickAmplitudeAdd, cickAmplitudeMax) : customAmplitude;
		
		//var ratio:Number = Math.max(cickAmplitude/(cickAmplitudeMax - 23 * Math.PI/ 180) - 1, 0) ;
		
		Starling.juggler.removeTweens(this);
		
		var clockWiseCoefficient:int = 1//rotationY >= 0 ? 1 : -1;
		var localCickAmplitude:Number = cickAmplitude * clockWiseCoefficient;
		
		
		if(cickAmplitude >= Math.abs(cickAmplitudeMax))
			cickMaxCount++;
			
		//trace('>> ', cickMaxCount, cickAmplitude*180/Math.PI);	
		
		
		if (cickMaxCount >= 1) 
		{
			gameManager.questModel.loadCurrentDailyBackImageAsset();
		}
			
		if (cickMaxCount >= 5 && gameManager.questModel.dailyBackImageAsset && gameManager.questModel.dailyBackImageAsset.loaded) 
		{
			cickMaxCount = 0;
			
			//resetDelayedShowFrontState();
			cleanDelayedShowFrontState();
		
			//trace('>> переворот');	
			
			Starling.juggler.removeTweens(this);
			commitShowBackState = true;
			
			TweenHelper.tween(this, 0.1, { rotationY:Math.PI/2, transition:Transitions.EASE_IN, onComplete:changeViewToBack} )
				.chain(this, 0.4, { rotationY:Math.PI, transition:Transitions.EASE_OUT_BACK } );	
			
			return;
		}
			
		var firstTweenTimeRatio:Number = Math.min(0.3, cickAmplitudeMax - Math.abs(rotationY));
		TweenHelper.tween(this, 0.3*firstTweenTimeRatio, {rotationY:localCickAmplitude, transition:Transitions.EASE_OUT}).chain(this, 1.7, { rotationY:0, transition:Transitions.EASE_OUT_ELASTIC });
	}
	
}
