package com.alisacasino.bingo.dialogs.slots 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.utils.EffectsManager;
	import flash.utils.getTimer;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.TweenHelper;
	
	public class SlotMachineReel extends Sprite 
	{
		public static var REWARD_VERTICAL_GAP:int = 156 * pxScale;
		public static var REWARD_SHIFT_Y:int = 80 * pxScale;
		
		public static const LAUNCH_SPEED_DEFAULT:int = 0;
		public static const LAUNCH_SPEED_FAST:int = 1;
		
		private const SKEW_HALF_AMPLITUDE:int = 2;
		private const SCALE_Y_HALF_AMPLITUDE:Number = 0.36;
		private const SCALE_X_HALF_AMPLITUDE:Number = 0.12;
		
		private var index:int;
		private var backgroundTextures:Vector.<Texture>;
		
		private var background:Image;
		private var rewardsContainer:Sprite;
		private var scratches:Sprite;
		
		private var rewardViews:Vector.<SlotMachineRewardView>;
		private var indexesByRewardType:Object;
		
		public var isSpinning:Boolean;
		
		private var launchStartTime:int;
		private var spinDownTime:int;
		private var bgChangeTime:int;
		private var bgIndex:int;
		private var bgMaxIndex:int;
		private var scratchChangeTime:int;
		
		private var contentWidth:int;
		private var contentHeight:int;
		private var invertHorisontal:Boolean;
		
		private var _reelRotation:Number;
		
		private var reelHeightPixels:int;
		private var backgroundX:int;
		
		private var revolution:Number = 0;
		
		private var initRewardType:String;
		
		private var launchBackgroundVisibilityTimeout:int = 400;
		
		private var launchSpeed:int;
		
		public function SlotMachineReel(index:int, backgroundTexturesAssets:Array, contentWidth:int, contentHeight:int, initRewardId:String = null) 
		{
			super();
			
			/*var quad:Quad = new Quad(contentWidth, contentHeight, 0xFFFFFF * Math.random());
			quad.alpha = 0.87;
			addChild(quad);*/
			
			this.index = index;
			this.contentWidth = contentWidth;
			this.contentHeight = contentHeight;
			this.initRewardType = initRewardId;
			
			invertHorisontal = index == 2;
			
			backgroundTextures = new <Texture>[];
			while (backgroundTexturesAssets.length > 0) {
				backgroundTextures.push(backgroundTexturesAssets.shift() as Texture);
			}
			
			background = new Image(backgroundTextures[0]);
			background.x = (contentWidth - background.width) / 2;
			background.height = contentHeight;
			if (invertHorisontal) {
				background.scaleX = -1;
				background.x += background.width;
			}
			
			backgroundX = background.x;
			
			addChild(background);
			background.visible = false;
			
			scratches = new Sprite();
			addChild(scratches);
			
			rewardsContainer = new Sprite();
			addChild(rewardsContainer);
			
			//bgChangeTime = backgroundTextures.length * 5;
			bgMaxIndex = backgroundTextures.length - 1;
			
			var scratchImage:Image;
			//var count:int = 6//index == 2 ? 6 : 0;
			//var count:int = index == 1 ? 6 : 0;
			var count:int = 6;
			var scratchSlotWidth:Number = contentWidth / count;
			var scratchRelativePositions:Vector.<int> = new <int>[10, 10, 10];
			while (count > 0) 
			{
				scratchImage = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/scratches_black'));
				scratchImage.x = count * scratchSlotWidth - Math.random() * scratchSlotWidth; 
				scratchImage.scaleX = (invertHorisontal ? -1 : 1) * (0.7 + Math.random() * 0.76);
				scratchImage.alpha = 0.03 + 0.1*Math.random();
				scratches.addChild(scratchImage);
				
				count--;
			}
		}
		
		public function set rewards(value:Vector.<SlotMachineRewardView>):void 
		{
			if (rewardViews) {
				while (rewardViews.length > 0) {
					rewardViews.shift().removeFromParent();
				}
			}
			
			rewardViews = value;
			indexesByRewardType = {};
			
			var i:int;
			var rewardView:SlotMachineRewardView;
			for (i = 0; i < rewardViews.length; i++) {
				rewardView = rewardViews[i];
				//rewardView.alignPivot();
				rewardView.x = contentWidth/2;
				rewardsContainer.addChild(rewardView);
				
				indexesByRewardType[rewardView.reward.rewardType] = i;
			}
			
			reelHeightPixels = REWARD_VERTICAL_GAP * (value.length/* - 1*/);
			
			// to init position:
			var rewardViewIndex:int = initRewardType in indexesByRewardType ? (rewardViews.length - indexesByRewardType[initRewardType]) : 0;
			reelRotation = REWARD_VERTICAL_GAP * (rewardViewIndex + 1) + REWARD_SHIFT_Y;
		}
		
		public function set reelRotation(value:Number):void 
		{
			_reelRotation = value;
			revolution = _reelRotation % reelHeightPixels;
			
			var i:int;
			var rewardView:SlotMachineRewardView;
			var positionY:Number;
			var tweenRatio:Number;
			var shiftXRatio:Number;
			var skewRatio:Number;
			var normalizedRewardViewY:Number;
			
			var tweenRatioContentHeight:int = contentHeight + 2 * REWARD_SHIFT_Y;	
			
			for (i = 0; i < rewardViews.length; i++) 
			{
				rewardView = rewardViews[i];
				
				positionY = (revolution + i * REWARD_VERTICAL_GAP) % reelHeightPixels;
				
				rewardView.y = positionY - REWARD_SHIFT_Y;
				
				normalizedRewardViewY = rewardView.y + REWARD_SHIFT_Y;
				
				tweenRatio = (normalizedRewardViewY > 0 && normalizedRewardViewY < tweenRatioContentHeight) ? normalizedRewardViewY/tweenRatioContentHeight : 0;
				
				if (tweenRatio < 0.5)
					shiftXRatio = 1 - easeOutQuad(tweenRatio * 2);
				else 
					shiftXRatio = 1 - easeOutQuad((1 - tweenRatio) * 2);
					
				skewRatio = easeOutQuad((0.5 - tweenRatio)*2);
				
				/*
				if (index == 0 && i == 0) {
					trace((normalizedRewardViewY > 0 && normalizedRewardViewY < tweenRatioContentHeight), rewardView.y, normalizedRewardViewY, tweenRatioContentHeight, tweenRatio);
				}
				
				if (normalizedRewardViewY > 0 && normalizedRewardViewY < tweenRatioContentHeight)
					rewardView.x = contentWidth/2 + 50;	
				else
					rewardView.x = contentWidth / 2;	
				
				continue;	*/
					
				rewardView.scaleY = 1 - SCALE_Y_HALF_AMPLITUDE * shiftXRatio;	
				rewardView.scaleX = 1 - SCALE_X_HALF_AMPLITUDE * shiftXRatio;
					
				if (index == 0) {
					rewardView.x = contentWidth / 2 + 13 * shiftXRatio;
					rewardView.skewX = skewRatio * SKEW_HALF_AMPLITUDE * Math.PI / 180;
				}	
				else if (index == 2) {
					rewardView.x = contentWidth / 2 - 13 * shiftXRatio;	
					rewardView.skewX = -skewRatio * SKEW_HALF_AMPLITUDE * Math.PI / 180;
				}
			}
		}
		
		public function get reelRotation():Number 
		{
			return _reelRotation;
		}
		
		public function launch(delayMs:int, speed:int = 0):void 
		{
			launchStartTime = getTimer() + delayMs;
			launchSpeed = speed;
			bgChangeTime = 0;
			spinDownTime = 0;
			
			isSpinning = true;
			
			launchBackgroundVisibilityTimeout = launchSpeed == LAUNCH_SPEED_DEFAULT ? 400 : 170;
			
			//var targetReelRotation:Number = reelRotation + (reelHeightPixels*3 + winIndex*REWARD_VERTICAL_GAP	);
			Starling.juggler.tween(this, launchSpeed == LAUNCH_SPEED_DEFAULT ? 0.5 : 0.2, {reelRotation:(reelRotation + REWARD_VERTICAL_GAP), transition:Transitions.EASE_IN_BACK, delay:(delayMs / 1000)});
			
			//return;
			if(!hasEventListener(Event.ENTER_FRAME, handler_enterFrame))
				addEventListener(Event.ENTER_FRAME, handler_enterFrame);
		}
		
		public function stop(delayMs:int, rewardType:String):void 
		{
			spinDownTime = getTimer() + delayMs;
			
			// ставим тут в правильное место колесо призов, чтобы докрутить до нужного 
			var targetIndex:int = indexesByRewardType[rewardType];
			targetIndex = rewardViews.length - targetIndex;
			
			reelRotation = REWARD_VERTICAL_GAP * (targetIndex + 1) + REWARD_SHIFT_Y - REWARD_VERTICAL_GAP * Math.round(/*Math.random() **/ 3);
			Starling.juggler.tween(this, 0.25, {reelRotation:(REWARD_VERTICAL_GAP * (targetIndex + 1) + REWARD_SHIFT_Y), transition:Transitions.EASE_OUT_BACK, delay:(delayMs / 1000), onComplete:completeSpinning});
			
			//trace('reel stop, ', index, targetIndex);
		}
		
		//public function 
		
		private function completeSpinning():void 
		{
			isSpinning = false;
			dispatchEventWith(Event.COMPLETE, false);
		}
		
		public function shake(time:Number = 0.25, delay:Number = 0):void 
		{
			return;
			
			TweenHelper.tween(this, time , {reelRotation:(Math.random() * 25), transition:Transitions.EASE_OUT, delay:delay}).
				chain(this, 1.5 , {reelRotation:0, transition:Transitions.EASE_OUT_ELASTIC});
			
			//Starling.juggler.tween(this, 0.5 , {reelRotation:(targetReelRotation * (0.5 / 3.6)), transition:Transitions.EASE_IN_BACK, delay:(delay / 1000)});
		}
		
		public function showWin(rewardType:String, delay:Number):void 
		{
			var targetIndex:int = indexesByRewardType[rewardType];
			var rewardView:SlotMachineRewardView = rewardViews[targetIndex];
			
			playEffect(rewardView, delay);
			Starling.juggler.delayCall(playEffect, delay + 0.35, rewardView, 0);
			Starling.juggler.delayCall(playEffect, delay + 0.7, rewardView, 0);
		}
		
		private function playEffect(view:DisplayObject, delay:Number):void 
		{
			EffectsManager.removeJump(view, false);
			Starling.juggler.removeTweens(view);
			
			EffectsManager.jump(view, 1, 1, 1.15, 0.2, 0.1, 0, 0, delay, 2.2, true);
			
			var backTween:Tween = new Tween(view, 1.8, Transitions.EASE_OUT_ELASTIC);
			backTween.animate("rotation", 0);
			
			var pullTween:Tween = new Tween(view, 0.3, Transitions.EASE_IN);
			pullTween.animate("rotation", Math.PI /56);
			//pullTween.delay = 0.1;
			pullTween.nextTween = backTween;
			
			Starling.juggler.add(pullTween);
		}
		
		private function handler_enterFrame(e:Event):void
		{
			var time:int = getTimer();
			var playTime:int = getTimer() - launchStartTime;
			
			if (playTime < 0)
			{
				return;
			}
			else if (playTime < launchBackgroundVisibilityTimeout)
			{
				// tween rewards start
				//rewardsContainer.visible = true;
			}
			else if (spinDownTime <= 0 || spinDownTime > time)
			{
				if (rewardsContainer.visible)
					changeScratchTextures(false);
				
				rewardsContainer.visible = false;
				
				if ((playTime - bgChangeTime) >= 23) 
				{
					background.visible = true;
					background.texture = backgroundTextures[bgIndex];
					background.x = backgroundX + 3 - 6*Math.random();
				
					bgChangeTime = playTime;
					bgIndex++;
					if (bgIndex > bgMaxIndex)
						bgIndex = 0;
						
					if (Math.random() > 0.3) {
						scratches.x = 7 - 14*Math.random();
					}
				}
			}
			else
			{
				spinDownTime = 0;
				removeEventListener(Event.ENTER_FRAME, handler_enterFrame);
				
				if (!rewardsContainer.visible)  {
					rewardsContainer.visible = true;
					changeScratchTextures(true);
					background.visible = false;
				}
			}
		}
		
		private function easeOutQuad(ratio:Number):Number
        {
           return -ratio * (ratio - 2)
        } 
		
		private function changeScratchTextures(black:Boolean):void
		{
			var i:int;
			var scratchImage:Image;	
			for (i = 0; i < scratches.numChildren; i++) 
			{
				scratchImage = scratches.getChildAt(i) as Image;
				if (!black && (scratchImage.x < 15 || scratchImage.x > (contentWidth - 15)))
					return;
				
				if (!black && Math.random() > 0.7)	
					return;
				
				scratchImage.texture = AtlasAsset.ScratchCardAtlas.getTexture(black ? 'slots/scratches_black' : 'slots/scratches');
				scratchImage.alpha = black ? (0.03 + 0.1*Math.random()) : (0.13 + 0.4*Math.random());
			}	
		}
	}

}