package com.alisacasino.bingo.screens.questsScreenClasses
{
	import adobe.utils.CustomActions;
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.commands.assetIndex.SaveLocalAssetIndex;
	import com.alisacasino.bingo.commands.player.CollectCommodityItems;
	import com.alisacasino.bingo.components.Scale9Image;
	import com.alisacasino.bingo.components.Scale9Textures;
	import com.alisacasino.bingo.components.SimpleProgressBar;
	import com.alisacasino.bingo.components.effects.ParticleExplosion;
	import com.alisacasino.bingo.controls.Scale9ProgressBar;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.offers.SaleBadgeView;
	import com.alisacasino.bingo.models.offers.OfferBadgeType;
	import com.alisacasino.bingo.models.quests.QuestModel;
	import com.alisacasino.bingo.models.quests.QuestType;
	import com.alisacasino.bingo.models.quests.questItems.QuestBase;
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.models.universal.ValueDataTable;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.ItemViewHelper;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.StringUtils;
	import com.alisacasino.bingo.utils.TimeService;
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
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
	
	public class QuestRenderer extends FeathersControl
	{
		public static var WIDTH:uint = 290 * pxScale;
		public static var HEIGHT:uint = 555 * pxScale;
		
		public static var ACTION_EXPIRED:String = 'ACTION_EXPIRED';
		public static var ACTION_CLAIMED:String = 'ACTION_CLAIMED';
		public static var ACTION_SKIPPED:String = 'ACTION_SKIPPED';
		
		
		//public static var STATE_COMPLETE:String = 'STATE_COMPLETE';
		
		public function QuestRenderer(index:int, type:String, quest:QuestBase)
		{
			super();
			this.index = index;
			this.type = type;
			_quest = quest;
		}
	
		public var index:int;
		public var type:String;
		public var isHiding:Boolean;	
		public var backgroundTriggeredCallback:Function;
		
		private var _quest:QuestBase;
		
		private var background:Image;
		private var backgroundColored:Image;
		private var descriptionBg:Image;
		private var rewardContainer:Sprite;
		private var rewardBackground:Image;
		private var rewardBackgroundDashContour:Scale9Image;
		
		private var rewardView:DisplayObject;
		private var rewardAnimation:AnimationContainer;
		private var rewardCountLabel:XTextField;
		
		private var claimButton:XButton;
		private var title:XTextField;
		public var description:XTextField;
		private var rewardTitle:XTextField;
		
		private var timerBg:Image;
		private var timerArrow:Image;
		private var timerLabelBg:Image;
		private var timerLabel:XTextField;
		
		private var progressTitle:XTextField;
		private var progressBar:Scale9ProgressBar;
		
		private var newBadge:SaleBadgeView;
		private var effectBg:Image;
		private var effectPuffImage:Image;	
		
		
		private var finishTime:int;
		
		private var timer:Timer;
		private var lastTimeoutValue:int;
		private var lastTimerLabelWidth:int;
		private var timerLabelBgWidth:int;
		
		public function get quest():QuestBase
		{
			return _quest;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			var titleString:String = 'NO QUEST';
			switch (type)
			{
				case QuestType.EVENT_QUEST: 
				{
					titleString = 'EVENT QUEST';
					break;
				}
				case QuestType.DAILY_QUEST: 
				{
					titleString = 'DAILY QUEST';
					break;
				}
				case QuestType.BONUS_QUEST: 
				{
					titleString = 'BONUS QUEST';
					break;
				}
				default: 
				{
					titleString = 'NO QUEST';
				}
			}
			
			var backgroundColor:uint = quest ? quest.style.backgroundColor : 0x9D9D9D;
			//UIUtils.addBoundQuad(this, bounds, 0xFFFF00 * Math.random());
			
			background = new Image(AtlasAsset.CommonAtlas.getTexture('quests/outer_bg'));
			background.scale9Grid = ResizeUtils.getScaledRect(19, 19, 2, 2);
			background.addEventListener(TouchEvent.TOUCH, handler_backgroundTouch);
			background.alignPivot();
			background.width = WIDTH;
			background.height = HEIGHT;
			addChild(background);
			
			backgroundColored = new Image(AtlasAsset.CommonAtlas.getTexture('quests/inner_bg'));
			backgroundColored.scale9Grid = ResizeUtils.getScaledRect(14, 14, 2, 2);
			//backgroundColored.addEventListener(TouchEvent.TOUCH, handler_backgroundColoredTouch);
			backgroundColored.touchable = false;
			backgroundColored.color = backgroundColor;
			backgroundColored.alignPivot();
			backgroundColored.width = WIDTH - 10*pxScale;
			backgroundColored.height = HEIGHT - 10*pxScale;
			addChild(backgroundColored);
			
			descriptionBg = new Image(AtlasAsset.CommonAtlas.getTexture('quests/bordered_gray_bg'));
			descriptionBg.scale9Grid = ResizeUtils.getScaledRect(18, 18, 1, 1);
			descriptionBg.alignPivot();
			descriptionBg.touchable = false;
			descriptionBg.width = WIDTH - 26*pxScale;
			descriptionBg.height = 74 * pxScale;
			descriptionBg.y = -241 * pxScale;
			addChild(descriptionBg);
			
			rewardContainer = new Sprite();
			rewardContainer.y = -50 * pxScale;
			rewardContainer.touchable = QuestsScreen.DEBUG_COLORIZE_QUESTS;
			addChild(rewardContainer);
			
			rewardBackground = new Image(AtlasAsset.CommonAtlas.getTexture("quests/shadowed_bg"));
			rewardBackground.scale9Grid = ResizeUtils.getScaledRect(17, 19, 2, 2);
			rewardBackground.alignPivot();
			rewardBackground.x = 0 * pxScale;
			rewardBackground.width = 267 * pxScale;
			rewardBackground.height = 263 * pxScale;
			rewardBackground.touchable = false;
			rewardContainer.addChild(rewardBackground);
			
			rewardBackgroundDashContour = new Scale9Image(new Scale9Textures(AtlasAsset.CommonAtlas.getTexture("dialogs/inventory/dot_square"), ResizeUtils.getScaledRect(13, 14, 61, 59)));//ResizeUtils.getScaledRect(26, 22, 20, 20)));
			rewardBackgroundDashContour.isTiled = true;
			rewardBackgroundDashContour.touchable = false;
			rewardBackgroundDashContour.color = backgroundColor;
			rewardBackgroundDashContour.x = 0 * pxScale;
			rewardBackgroundDashContour.y = rewardBackground.y - 1 * pxScale;
			rewardBackgroundDashContour.width = rewardBackground.width - 22 * pxScale;
			rewardBackgroundDashContour.height = rewardBackground.height - 18 * pxScale;
			rewardBackgroundDashContour.pivotX = rewardBackgroundDashContour.width / 2;
			rewardBackgroundDashContour.pivotY = rewardBackgroundDashContour.height / 2;
			rewardContainer.addChild(rewardBackgroundDashContour);
			
			title = new XTextField(WIDTH, 40 * pxScale, XTextFieldStyle.getWalrus(33).setShadow(0.5, 0, 1, 90, 3, 4), titleString);
			title.alignPivot();
			title.y = -HEIGHT / 2 - 140 * pxScale;
			title.touchable = false;
			addChild(title);
			
			if (quest)
			{
				rewardTitle = new XTextField(WIDTH, 40 * pxScale, XTextFieldStyle.getWalrus(30, backgroundColor), 'REWARD');
				rewardTitle.alignPivot();
				rewardTitle.y = -rewardBackground.height / 2 + 37 * pxScale;
				rewardTitle.touchable = false;
				rewardContainer.addChild(rewardTitle);
			
				rewardCountLabel = new XTextField(204 * pxScale, 50 * pxScale, XTextFieldStyle.getWalrus(41, 0xFFFFFF, Align.RIGHT).setShadow(1.2), 'X' + _quest.reward.quantity.toString());
				rewardCountLabel.alignPivot();
				rewardCountLabel.touchable = false;
				rewardCountLabel.y = 80 * pxScale;
				
				rewardView = ItemViewHelper.getQuestRewardView(_quest.reward, rewardCountLabel);
				if (rewardView) {
					rewardView.touchable = false;
					rewardContainer.addChild(rewardView);
				}
				
				rewardContainer.addChild(rewardCountLabel);
			}
			else
			{
				rewardView = new Image(AtlasAsset.CommonAtlas.getTexture('controls/chest/no_slot_sign'));
				rewardView.scale = 1.17;
				rewardView.alignPivot();
				rewardView.touchable = false;
				rewardView.y = -30 * pxScale;
				rewardContainer.addChild(rewardView);
				
				rewardCountLabel = new XTextField(descriptionBg.width, 70 * pxScale, XTextFieldStyle.getWalrus(24, 0x737373), Constants.COME_BACK_TOMORROW);
				rewardCountLabel.alignPivot();
				rewardCountLabel.touchable = false;
				rewardCountLabel.y = 67 * pxScale;
				rewardContainer.addChild(rewardCountLabel);
			}
			
			description = new XTextField(descriptionBg.width - 12*pxScale, descriptionBg.height - 10*pxScale, XTextFieldStyle.getWalrus(24).addStroke(0.55, 0x00000), quest ? quest.targetString : Constants.NO_MORE_QUESTS_FOR_TODAY);
			//description = new XTextField(descriptionBg.width - 12*pxScale, descriptionBg.height - 10*pxScale, XTextFieldStyle.getWalrus(24), Math.random() > 0.5 ? quest.targetString : 'OBTAIN 10 POWERUPS FROM CHEST AND SMILE VERY MUCH');
			//description = new XTextField(descriptionBg.width - 12*pxScale, descriptionBg.height - 10*pxScale, XTextFieldStyle.getWalrus(24).addStroke(0.55, 0x00000), Math.random() > 0.5 ? quest.targetString : 'OB TA IN 10 PO  WE RU PS FR OM CH EST A ND SM IL E VE RY M U CH SM IL E VE RY M U CH SM IL E VE RY M U CH SM IL E VE RY M U CH SM IL E VE RY M U CH');
			//description.border = true;
			description.touchable = false;
			description.isHtmlText = true;
			description.autoScale = true;
			description.alignPivot();
			description.y = descriptionBg.y + 2*pxScale;
			addChild(description);
			
			progressBar = new Scale9ProgressBar(AtlasAsset.CommonAtlas.getTexture('quests/progress_glass'), ResizeUtils.getScaledRect(12, 0, 1, 0), AtlasAsset.CommonAtlas.getTexture('quests/progress_fill'), ResizeUtils.getScaledRect(12, 0, 1, 31), 265 * pxScale, 0, 0, 0, false, true);
			progressBar.setBackgroundImage(AtlasAsset.CommonAtlas.getTexture('quests/progress_fill'), ResizeUtils.getScaledRect(12, 0, 1, 31), 265 * pxScale, 0x000000, 0.2);
			progressBar.setProperties(quest ? quest.style.progressColor : 0xA0A0A0);
			progressBar.setLabel(XTextFieldStyle.getWalrus(25, 0xFFFFFF).setStroke(0.55), 0, 3 * pxScale);
			progressBar.touchable = false;
			progressBar.pivotX = progressBar.width / 2;
			progressBar.y = HEIGHT / 2 - 156 * pxScale;
			addChild(progressBar);
			
			timerLabelBgWidth = 252 * pxScale,
			
			timerLabelBg = new Image(AtlasAsset.CommonAtlas.getTexture('quests/bordered_bg'));
			timerLabelBg.scale9Grid = ResizeUtils.getScaledRect(17, 18, 2, 2);
			timerLabelBg.alignPivot(Align.LEFT, Align.CENTER);
			timerLabelBg.touchable = false;
			timerLabelBg.width = timerLabelBgWidth;
			timerLabelBg.height = 57 * pxScale;
			timerLabelBg.x = -120 * pxScale;
			timerLabelBg.y = -175 * pxScale;
			addChild(timerLabelBg);
			
			if (QuestModel.DEBUG_MODE || QuestsScreen.DEBUG_COLORIZE_QUESTS) {
				progressBar.touchable = true;
				timerLabelBg.touchable = true;
				progressBar.addEventListener(TouchEvent.TOUCH, handler_progressTouch);
				timerLabelBg.addEventListener(TouchEvent.TOUCH, handler_timeTouch);
				
				if (QuestsScreen.DEBUG_COLORIZE_QUESTS) {
					descriptionBg.addEventListener(TouchEvent.TOUCH, handler_descriptionBgTouch);
					descriptionBg.touchable = true;
					
					rewardBackground.touchable = true;
					rewardBackground.addEventListener(TouchEvent.TOUCH, handler_bgRewardTouch);
				}
			}
			
			timerBg = new Image(AtlasAsset.CommonAtlas.getTexture('controls/clock_bg'));
			timerBg.alignPivot();
			timerBg.touchable = false;
			timerBg.x = -104 * pxScale;
			timerBg.y = timerLabelBg.y;
			addChild(timerBg);
			
			timerArrow = new Image(AtlasAsset.CommonAtlas.getTexture('controls/clock_arrow'));
			timerArrow.touchable = false;
			timerArrow.pivotX = 13 * pxScale;
			timerArrow.pivotY = 12 * pxScale;
			timerArrow.x = timerBg.x;
			timerArrow.y = timerLabelBg.y;
			timerArrow.rotation = Math.PI/4;
			addChild(timerArrow);
			
			timerLabel = new XTextField(225 * pxScale, 40 * pxScale, XTextFieldStyle.getWalrus(36, 0x153549, Align.LEFT), '');
			timerLabel.pivotY = timerLabel.height / 2;
			timerLabel.touchable = false;
			timerLabel.y = timerLabelBg.y + 2 * pxScale;
			addChild(timerLabel);
			
			
			if (quest) 
			{
				if (quest.isCompleted(true)) 
				{
					changeToCompleteViews(false, true);
				}
				else
				{
					finishTime = quest.timeStart + quest.duration;
					
					if (finishTime > TimeService.serverTime) {
						enableTimer = true;
					}
					else {
						enableTimer = false;
						updateTime(0, false);
					}
					
					var progress:int = int(quest.getProgress());
					var progressRatio:Number = Math.min(1, (progress - quest.reservedProgress)/quest.goal);
					
					progressBar.animateValues(progressRatio, 0);
					setProgressLabel(Math.min(quest.goal, progress - quest.reservedProgress));
				}
			}
			else
			{
				if (type == QuestType.DAILY_QUEST) {
					finishTime = Math.ceil(gameManager.tournamentData.endsAt / 1000);
					if (finishTime > TimeService.serverTime) 
						enableTimer = true;
				}
			}
			
			// in start position after first positioning if timer is enabled
			timerLabelBg.width = 0;
			timerLabelBg.height = 33 * pxScale;
			
			timerLabel.scaleX = 1.5;
			timerLabel.scaleY = 0;
			
			/*if(index == 0)
				finishTime = TimeService.serverTime + 60*60*24 + 20;
			else if(index == 1)
				finishTime = TimeService.serverTime + 200000;
			else if(index == 2)
				finishTime = TimeService.serverTime + 1000000;*/
			
			//trace(' >> 2 ', quest.type, quest.targetString, quest.timeStart + quest.duration - TimeService.serverTime);
			
			//if(Math.random() > 0.5)
				//showNewBadge();
		}
		
		override protected function draw():void
		{
			super.draw();
			
			//if (isInvalid(INVALIDATION_FLAG_SIZE)) 
			//resize();
		
			//tweenAppear();
		}
		
		public function tweenAppear(delay:Number, withNewBadge:Boolean = false):void
		{
			var isCompleted:Boolean = quest && quest.isCompleted(true);
			
			// тайтл вниз
			Starling.juggler.tween(title, 0.2, {delay:(delay + 0.2), y:(-HEIGHT / 2 + 43 * pxScale), transition:Transitions.EASE_OUT_BACK});
			
			// таймер вниз и вылет вбок
			Starling.juggler.tween(timerLabelBg, 0.2, {transition: Transitions.EASE_OUT_BACK, delay:(delay + 0.3), width:timerLabelBgWidth, height:57 * pxScale});
			
			if (isCompleted) 
			{
				Starling.juggler.tween(timerBg, 0.25, {transition: Transitions.EASE_OUT_BACK, delay:delay, y:(-HEIGHT / 2 + 102 * pxScale), width:380 * pxScale});
				Starling.juggler.tween(timerLabel, 0.2, {transition: Transitions.EASE_OUT_BACK, delay:(delay + 0.1), y:(-HEIGHT / 2 + 102 * pxScale), scaleX:1, scaleY:1});
			}	
			else 
			{
				Starling.juggler.tween(timerLabel, 0.2, {transition: Transitions.EASE_OUT_BACK, delay:(delay + 0.5), scaleX:1, scaleY:1});
				
				TweenHelper.tween(timerBg, 0.25, {transition: Transitions.EASE_OUT_BACK, delay:(delay + 0.1), y:timerLabelBg.y}).chain(timerBg, 0.1, {scale:1.3, transition:Transitions.EASE_OUT}).chain(timerBg, 0.1, {scale:1, transition:Transitions.EASE_OUT});
				//Starling.juggler.tween(timerBg, 0.3, {transition: Transitions.EASE_OUT_BACK, delay:(delay), y:timerLabelBg.y});
				Starling.juggler.tween(timerArrow, 0.25, {transition: Transitions.EASE_OUT_BACK, delay:delay, y:timerLabelBg.y});
			}
			
			// описание с бэкграундом вниз
			if (descriptionBg) 
				Starling.juggler.tween(descriptionBg, 0.2, {transition: Transitions.EASE_OUT_BACK, delay:(delay + 0.08), y:-101 * pxScale});
			
			if(description)
				Starling.juggler.tween(description, 0.2, {transition: Transitions.EASE_OUT_BACK, delay:(delay + 0.08), y:(isCompleted ? -109 : -99) * pxScale});
			
			// ревард вниз
			Starling.juggler.tween(rewardContainer, 0.2, {delay:(delay + 0.05), y:(isCompleted ? 56 : 78) * pxScale, transition:Transitions.EASE_OUT_BACK});
			
			// прогресс или кнопка комплита вниз
			
			if (progressBar)
				Starling.juggler.tween(progressBar, 0.2, {delay:delay, y:(HEIGHT / 2 - 56 * pxScale), transition:Transitions.EASE_OUT_BACK});
			
			if (claimButton)
				EffectsManager.scaleJumpAppearBase(claimButton, 1, 0.750, delay, 0.9);
			
			// после появления апдейт состояния:протух, прогресс апдейт, прогресс апдейт + комплит
			Starling.juggler.delayCall(handleCompleteAppear, delay + 0.38);
			
			if(quest && withNewBadge)
				showNewBadge(delay + 1.1);
		}
		
		private function handleCompleteAppear():void
		{
			if (!quest)
				return;
				
			var progress:int = int(quest.getProgress());
			
			if (quest.reservedProgress > 0 && ((progress - quest.reservedProgress) < quest.goal)) 
			{
				var progressRatio:Number = Math.min(1, progress/quest.goal);
				progressBar.animateValues(progressRatio, 0.6, 0.0, Transitions.EASE_OUT);
				
				EffectsManager.animateIntHelper(Math.min(progress - quest.reservedProgress, quest.goal), Math.min(progress, quest.goal), setProgressLabel, 0.6);
				
				quest.cleanReservedProgress();
				
				if (quest.isCompleted(false)) 
				{
					showComplete(0.6);
					
					SoundManager.instance.setSoundtrackVolume(0.25);
					Starling.juggler.delayCall(SoundManager.instance.setSoundtrackVolume, 4.2, SoundManager.BACKGROUND_VOLUME);
					SoundManager.instance.playSfx(SoundAsset.QuestComplete, 0.65);
				}
			}
		}
		
		public function setProgressLabel(value:int):void {
			progressBar.labelText = value.toString() + '/' + quest.goal.toString();
		}
		
		public function tweenHide(delay:Number):void
		{
			if (isHiding)
				return;
				
			isHiding = true;
			//enableTimer = false;
			
			//if(description)
				//EffectsManager.removeJump(description); 
		}
		
		public function clean():void
		{
			enableTimer = false;
		}
		
		public function showComplete(delay:Number):void
		{
			Starling.juggler.removeTweens(this);
			enableTimer = false;
			
			var tweenAppear:Tween = new Tween(this, 1.0, Transitions.EASE_OUT_ELASTIC);
			tweenAppear.animate('scaleX', 1);
			tweenAppear.animate('scaleY', 1);
			
			EffectsManager.showFullscreenSplash(Game.current.gameScreen.frontLayer, 0.15, delay-0.05, 0x000000);
			EffectsManager.showFullscreenSplash(Game.current.gameScreen.frontLayer, 0.5, delay + 0.05, 0xFFFFFF);
			
			createEffectImages();
			
			effectBg.alpha = 0;
			Starling.juggler.tween(effectBg, 0.05, {alpha:1, transition:Transitions.LINEAR, delay:delay})
			
			effectPuffImage.scale = 0;
			TweenHelper.tween(effectPuffImage, 0.15, {width:800* pxScale, height:280* pxScale, transition:Transitions.EASE_OUT, delay:(delay + 0.15)}).chain(effectPuffImage, 0.1, {width:300* pxScale, height:0, transition:Transitions.EASE_OUT});
			
			tweenDisappear(delay, changeToCompleteViews, [true, false], tweenAppear);
		}
		
		public function showClaimTweens(delay:Number, onComplete:Function, onCompleteArgs:Array):void
		{
			//Starling.juggler.removeTweens(this);
			enableTimer = false;
			
			Starling.juggler.tween(timerBg, 0.4, {width:0, transition:Transitions.EASE_IN_BACK, delay:delay})
			
			createEffectImages();
			
			effectBg.alpha = 0;
			Starling.juggler.tween(effectBg, 0.4, {alpha:1, transition:Transitions.LINEAR, delay:delay})
			
			effectPuffImage.height = 0;
			effectPuffImage.width = 700 * pxScale;
			TweenHelper.tween(effectPuffImage, 0.2, {width:900* pxScale, height:280* pxScale, transition:Transitions.EASE_OUT, delay:(delay + 0.05)}).chain(effectPuffImage, 0.15, {width:600* pxScale, height:0, transition:Transitions.EASE_IN});
			
			if(claimButton)
				EffectsManager.scaleJumpDisappear(claimButton, 0.4, delay);
			
			tweenDisappear(delay + 0.15, onComplete, onCompleteArgs, null, 0.07, 0.1);
		}
		
		private function handler_claimButton(e:Event):void
		{
			claimButton.touchable = false;
			gameManager.questModel.claimQuestReward(quest);
			//claimRewards(0);
			
			callHideFunCats();
		}
		
		private function tweenDisappear(delay:Number, onComplete:Function, onCompleteArgs:Array, nextTween:Tween, time1:Number = 0.03, time2:Number = 0.07):void
		{
			Starling.juggler.removeTweens(this);
			enableTimer = false;
			
			var tween_0:Tween = new Tween(this, time1, Transitions.EASE_OUT);
			var tween_1:Tween = new Tween(this, time2, Transitions.EASE_OUT);
			
			tween_0.delay = delay;
			tween_0.animate('scaleX', 1.1);
			tween_0.animate('scaleY', 0.9);
			tween_0.nextTween = tween_1;
			
			tween_1.animate('scaleX', 0);
			tween_1.animate('scaleY', 1.15);
			tween_1.onComplete = onComplete;
			tween_1.onCompleteArgs = onCompleteArgs;
			tween_1.nextTween = nextTween;
			
			Starling.juggler.add(tween_0);
		}
		
		private function changeToCompleteViews(widthTweens:Boolean, placeInStartPosition:Boolean):void
		{
			if(effectBg && widthTweens)
				Starling.juggler.tween(effectBg, 0.55, {alpha:0, transition:Transitions.LINEAR/*, delay:delay*/})
			
			descriptionBg.visible = false;
			
			description.y = -(placeInStartPosition ? 0 : 109) * pxScale;
			
			rewardContainer.y = (placeInStartPosition ? -70 : 56) * pxScale;
			
			claimButton = new XButton(XButtonStyle.GreenButton, 'CLAIM');
			claimButton.alignPivot();
			claimButton.addEventListener(Event.TRIGGERED, handler_claimButton);
			claimButton.y = HEIGHT / 2 - 45 * pxScale;
			addChild(claimButton);
			
			if (widthTweens) {
				var particleExplosion:ParticleExplosion = EffectsManager.getConfettiParticleExplosion();
				particleExplosion.y = -180 * pxScale;
				addChild(particleExplosion);
				particleExplosion.play(400, 150, 110, 0);
				//Starling.juggler.delayCall(particleExplosion.play, 0.0, 350, 90, 90);
				addChild(particleExplosion);
				Starling.juggler.delayCall(dispatchEventWith, 0.6, QuestsScreen.EVENT_COMPLETE_EXPLODE_TO_TOP, true, {index:index, particleExplosion:particleExplosion});
			}
			
			timerBg.removeFromParent();
			timerBg = new Image(AtlasAsset.CommonAtlas.getTexture('quests/red_ribbon'));
			timerBg.scale9Grid = ResizeUtils.getScaledRect(50, 0, 2, 0);
			timerBg.alignPivot();
			timerBg.y = -HEIGHT / 2 + (placeInStartPosition ? 0 : 102) * pxScale;
			addChild(timerBg);
			
			if(effectPuffImage)
				addChild(effectPuffImage);
			
			timerArrow.removeFromParent();
			timerArrow = null;
			
			timerLabel.removeFromParent();
			timerLabel = new XTextField(WIDTH + 30 * pxScale, 50 * pxScale, XTextFieldStyle.getWalrus(44, 0xFFFFFF).setStroke(1), 'COMPLETED');
			timerLabel.pivotY = timerLabel.height / 2;
			timerLabel.pivotX = timerLabel.width / 2;
			timerLabel.y = -HEIGHT / 2 + (placeInStartPosition ? 0 : 102) * pxScale;
			addChild(timerLabel);
			
			progressBar.removeFromParent();
			progressBar = null;
			
			if (widthTweens) 
			{
				EffectsManager.scaleJumpAppearBase(claimButton, 1, 0.7, 0.3);
				
				timerBg.width = 0;
				Starling.juggler.tween(timerBg, 0.6, {width:380 * pxScale, transition:Transitions.EASE_OUT_ELASTIC, delay:0.1})
			}
			else 
			{
				timerBg.width = (placeInStartPosition ? 0 : 380) * pxScale;
			}
			
			//addChild(particleExplosion);
			dispatchEventWith(QuestsScreen.EVENT_RENDERER_TO_TOP, true, index);
		}
		
		private function showNewBadge(delay:Number):void
		{
			newBadge = new SaleBadgeView(SaleBadgeView.TYPE_SMALL_BORDERED, null, 100, AtlasAsset.ScratchCardAtlas.getTexture('offers/badge_bordered_red'), 'NEW', null, 0.545);
			newBadge.touchable = false;
			newBadge.x = WIDTH / 2 - 5*pxScale;
			newBadge.y = -HEIGHT / 2 + 5*pxScale;
			newBadge.showAppear(delay);
			addChild(newBadge);
			
			newBadge.showJump((delay + 0.5) * 1000 + 1500, 3, 4000); 
		}
			
		private function tweenRoundClock(displayObject:DisplayObject):void
		{
			var tween:Tween = new Tween(displayObject, 1.2, Transitions.EASE_OUT_ELASTIC);
			tween.delay = 0.1;
			tween.animate('rotation', displayObject.rotation + 2 * Math.PI / 5 + 0.00000000000011);
			//tween.onComplete = tweenRoundClock;
			//tween.onCompleteArgs = [displayObject];
			Starling.juggler.add(tween);
		}
		
		public function tweenShowTimesUp(delay:Number):void
		{
			TweenHelper.tween(rewardContainer, 0.1, {transition: Transitions.EASE_IN_BACK, delay:delay, scale: 0.7}).
				chain(rewardContainer, 0.06, {scale:1, transition:Transitions.EASE_OUT} );
			
			if (rewardTitle) {
				var tweenReward_0:Tween = new Tween(rewardTitle, 0.1, Transitions.EASE_OUT);
				var tweenReward_1:Tween = new Tween(rewardTitle, 0.12, Transitions.EASE_OUT_BACK);
				
				tweenReward_0.delay = delay;
				tweenReward_0.animate('scaleX', 0);
				tweenReward_0.animate('scaleY', 0.7);
				tweenReward_0.onComplete = changeRewardTitleToTimesUp;
				tweenReward_0.nextTween = tweenReward_1;
				
				tweenReward_1.animate('scaleX', 1);
				tweenReward_1.animate('scaleY', 1);
				
				Starling.juggler.add(tweenReward_0);
			}
			
			if(rewardCountLabel)
				Starling.juggler.tween(rewardCountLabel, 0.1, {transition:Transitions.EASE_IN_BACK, delay:delay, x: -50 * pxScale, y:0, scale:0.0});
			
			if(rewardView)
				Starling.juggler.tween(rewardView, 0.1, {transition:Transitions.EASE_OUT, delay:delay, scale:0.0});
			
			var leftClock:Image = new Image(AtlasAsset.CommonAtlas.getTexture('quests/clock_cleaved_left'));
			leftClock.alignPivot(Align.RIGHT, Align.BOTTOM);
			leftClock.y = 59 * pxScale;
			leftClock.rotation = 25 * Math.PI / 180;
			leftClock.scale = 0.8;
			leftClock.alpha = 0;
			rewardContainer.addChild(leftClock);
			
			var rightClock:Image = new Image(AtlasAsset.CommonAtlas.getTexture('quests/clock_cleaved_right'));
			rightClock.alignPivot(Align.LEFT, Align.BOTTOM);
			rightClock.rotation = -25 * Math.PI / 180;
			rightClock.y = 59 * pxScale;
			rightClock.scale = 0.8;
			rightClock.alpha = 0;
			rewardContainer.addChild(rightClock);
			
			var clockTrash:Image = new Image(AtlasAsset.CommonAtlas.getTexture('quests/clock_trash'));
			clockTrash.alignPivot(Align.CENTER, Align.TOP);
			clockTrash.x = -6 * pxScale;
			clockTrash.y = 48 * pxScale;
			clockTrash.scale = 0;
			rewardContainer.addChild(clockTrash);
			
			Starling.juggler.tween(leftClock, 0.96, {transition:Transitions.EASE_OUT_ELASTIC, rotation:0, delay:(delay + 0.1), scale:1, alpha:10});
			Starling.juggler.tween(rightClock, 0.96, {transition:Transitions.EASE_OUT_ELASTIC, rotation:0, delay:(delay + 0.1), scale:1, alpha:10});
			Starling.juggler.tween(clockTrash, 0.16, {transition:Transitions.EASE_OUT_BACK, delay:(delay + 0.1), scale:1});
		}
		
		/*public function jumpDescription():void {
			EffectsManager.jump(description, 10003, 1, 1.12, 0.12, 0.12, 2, 2, 1, 3); 
		}*/
		
		private function set enableTimer(value:Boolean):void
		{
			//trace(' enableTimer ', value);
			if (value)
			{
				if (!timer)
				{
					timer = new Timer(100);
					timer.addEventListener(TimerEvent.TIMER, handler_timer);
					handler_timer(null);
				}
				
				timer.start();
			}
			else
			{
				if (timer)
				{
					timer.removeEventListener(TimerEvent.TIMER, handler_timer);
					timer.stop();
					timer = null;
				}
			}
		}
		
		private function handler_timer(event:TimerEvent):void
		{
			var timeout:int = finishTime - TimeService.serverTime;
			
			if (lastTimeoutValue == timeout)
				return;
			
			lastTimeoutValue = timeout;
			
			if (timeout <= 0)
			{
				updateTime(0);
				timer.stop();
				lastTimeoutValue = int.MIN_VALUE;
				enableTimer = false;
				//tweenShowTimesUp();
			}
			else
			{
				if (!timer.running)
					timer.start();
				
				updateTime(timeout);
			}
		}
		
		private function updateTime(time:int, doClockRoundTween:Boolean = true):void
		{
			if (gameManager.deactivated || !parent || !timerLabel)
				return;
			
			var oneDay:uint = 86400;
			var d:int = Math.floor(time / oneDay);
			
			timerLabel.format.size = (d == 0 ? 36 : (d < 10 ? 31 : 29)) * pxScale;
			
			if (d < 1)
				timerLabel.text = StringUtils.formatTime(time, "{1}:{2}:{3}", false, false);
			else
				timerLabel.text = d + "d" + " " + StringUtils.formatTime(time, "{1}:{2}:{3}", false, false);
			
			var newTimerLabelWidth:int = timerLabel.textBounds.width;
			
			if (Math.abs(lastTimerLabelWidth - newTimerLabelWidth) > 14*pxScale) {
			   lastTimerLabelWidth = newTimerLabelWidth;
			   //timerLabel.border = true;
			   timerLabel.x = timerLabelBg.x + (timerLabelBgWidth - timerLabel.textBounds.width) / 2 - timerLabel.textBounds.x + (d == 0 ? 18 : 20) * pxScale;
			}  
			
			if(doClockRoundTween)
				tweenRoundClock(timerArrow);
		}
		
		private function createEffectImages():void 
		{
			if (effectBg)
				return;
				
			effectBg = new Image(AtlasAsset.CommonAtlas.getTexture('quests/outer_bg'));
			effectBg.scale9Grid = ResizeUtils.getScaledRect(19, 19, 2, 2);
			effectBg.alignPivot();
			effectBg.touchable = false;
			effectBg.width = WIDTH;
			effectBg.height = HEIGHT;
			effectBg.touchable = false;
			addChild(effectBg);
			
			effectPuffImage = new Image(AtlasAsset.CommonAtlas.getTexture('effects/snowflake_2'));
			effectPuffImage.alignPivot();
			effectPuffImage.touchable = false;
			effectPuffImage.y = -173*pxScale; 
			addChild(effectPuffImage);
		}
		
		private function handler_backgroundTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(background);
			if (touch == null)
				return;
			
			if (touch.phase == TouchPhase.ENDED)
			{
				if (!_quest || _quest.expired || _quest.isCompleted(false))
					return;
				
				if (backgroundTriggeredCallback != null)
					backgroundTriggeredCallback();
			}
		}
		
		private function changeRewardTitleToTimesUp():void { 
			rewardTitle.format.color = 0xFF0066; 
			rewardTitle.text = "TIME'S UP!"; 
		};
		
		override public function dispose():void {
			super.dispose();
			
			//if(description)
				//EffectsManager.removeJump(description); 
		}
		
		private function callHideFunCats():void
		{
			if (DialogsManager.instance.getDialogByClass(QuestsScreen))
				(DialogsManager.instance.getDialogByClass(QuestsScreen) as QuestsScreen).hideFunCats();
		}				
		
		
		
		
		
		
		
		private var lastTouchTimeout:uint;
		
		private function handler_progressTouch(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
			
			var touch:Touch = event.getTouch(progressBar);
			if (touch == null)
				return;
			
			if (touch.phase == TouchPhase.ENDED)
			{
				if (!_quest)
					return;
				
				if (QuestsScreen.DEBUG_COLORIZE_QUESTS) {
					colorizeProgress(true);
					return;
				}
				
				if ((getTimer() - lastTouchTimeout) < 200)
				{
					quest.updateProgress(quest.goal - quest.getProgress());
					showComplete(0);
					
					callHideFunCats();
				}
				
				lastTouchTimeout = getTimer();
			}
		}
		
		private var lastTimeTouchTimeout:uint;
		
		private function handler_timeTouch(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
			
			var touch:Touch = event.getTouch(timerLabelBg);
			if (touch == null)
				return;
			
			if (touch.phase == TouchPhase.ENDED)
			{
				if (!_quest)
					return;
				
				if (QuestsScreen.DEBUG_COLORIZE_QUESTS) {
					colorizeProgress(false);
					return;
				}	
					
				if ((getTimer() - lastTimeTouchTimeout) < 200)
				{
					quest.timeStart = TimeService.serverTime - quest.duration - 1;
					finishTime = quest.timeStart + quest.duration;
					gameManager.questModel.refreshQuests();
					//tweenShowTimesUp();
				}
				
				lastTimeTouchTimeout = getTimer();
			}
		}
		
		private function handler_bgRewardTouch(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
			
			var touch:Touch = event.getTouch(rewardBackground);
			if (touch == null)
				return;
			
			if (touch.phase == TouchPhase.ENDED)
			{
				if (!_quest)
					return;
				
				colorizeBg(true);
			}
		}
		
		private function handler_descriptionBgTouch(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
			
			var touch:Touch = event.getTouch(descriptionBg);
			if (touch == null)
				return;
			
			if (touch.phase == TouchPhase.ENDED)
			{
				if (!_quest)
					return;
				
				colorizeBg(false);
			}
		}
		
		private function colorizeBg(increase:Boolean):uint
		{
			var colorsArray:Array;
			var colorIndex:int;
			var color:int;
			if (quest.type in QuestModel.debugBgColorsList) {
				colorsArray = QuestModel.debugBgColorsList[quest.type] as Array;
				colorIndex = QuestModel.debugBgColorsIndex[quest.type] as int;
			}
			else {
				colorsArray = [];
				QuestModel.debugBgColorsList[quest.type] = colorsArray;
				QuestModel.debugBgColorsIndex[quest.type] = colorIndex;
			}
			
			if (increase)
			{
				if (colorsArray.length == 0 || (colorIndex >= (colorsArray.length - 1))) {
					color = 0xFFFF00 * Math.random();
					colorIndex = colorsArray.push(color) - 1;
				}
				else {
					colorIndex++;
					color = colorsArray[colorIndex];
				}
			}
			else 
			{
				colorIndex--;
				if (colorIndex < 0) {
					colorIndex = colorsArray.length - 1;
				}
				
				color = colorsArray[colorIndex];
			}
			
			QuestModel.debugBgColorsIndex[quest.type] = colorIndex;
			
			backgroundColored.color = color;
			rewardBackgroundDashContour.color = color;
			if(rewardTitle)
				rewardTitle.format.color = color;
				
			return color;
		}
		
		
		private function colorizeProgress(increase:Boolean):uint
		{
			var colorsArray:Array;
			var colorIndex:int;
			var color:int;
			if (quest.type in QuestModel.debugProgressColorsList) {
				colorsArray = QuestModel.debugProgressColorsList[quest.type] as Array;
				colorIndex = QuestModel.debugProgressColorsIndex[quest.type] as int;
			}
			else {
				colorsArray = [];
				QuestModel.debugProgressColorsList[quest.type] = colorsArray;
				QuestModel.debugProgressColorsIndex[quest.type] = colorIndex;
			}
			
			if (increase)
			{
				if (colorsArray.length == 0 || (colorIndex >= (colorsArray.length - 1))) {
					color = 0xFFFF00 * Math.random();
					colorIndex = colorsArray.push(color) - 1;
				}
				else {
					colorIndex++;
					color = colorsArray[colorIndex];
				}
			}
			else 
			{
				colorIndex--;
				if (colorIndex < 0) {
					colorIndex = colorsArray.length - 1;
				}
				
				color = colorsArray[colorIndex];
			}
			
			QuestModel.debugProgressColorsIndex[quest.type] = colorIndex;
			
			progressBar.setProperties(color);	
			progressBar.animateValues( 0.2 + Math.random() * 0.8, 0.3);
				
			return color;
		}
	}
}

