package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	
	public class LootAnimation extends Sprite
	{
		private static const ITEMS_COUNT:uint = 5;
		private static const ITEM_LOOT_CYCLE_DURATION:Number = 0.3;
		private static const ITEM_LOOT_DELAY:Number = 0.15;
		private static const GLOW_CYCLE_DURATION:Number = 0.3;
		private static const GLOW_FADEOUT_DURATION:Number = 1.0;
		private static const GLOW_MAX_SCALE:Number = 1.1;
		private static const SPARKLES_INTERVAL:Number = 0.12;
		private static const SPARKLE_DURATION:Number = 0.2;
		
		private var mGameManager:GameManager = GameManager.instance;
		private var mSoundManager:SoundManager = SoundManager.instance;
		private var mGlow:Image;
		private var mParams:Object;
		protected var mItems:Array;
		private var mSparkles:Array;
		private var mSparklesCount:uint;
		private var mCommonAtlas:AtlasAsset = AtlasAsset.CommonAtlas;
		protected var mItemsCount:int;
		protected var mItemsCycleDuration:Number;
		protected var mItemsStartAlpha:Number;
		
		public function LootAnimation(params:Object)
		{
			mParams = params;
			mItemsCount = 'itemsCount' in params ? parseInt(params['itemsCount']) : ITEMS_COUNT;
			mItemsCycleDuration = 'itemsCycleDuration' in params ? parseFloat(params['itemsCycleDuration']) : ITEM_LOOT_CYCLE_DURATION;
			mItemsStartAlpha = 'itemsStartAlpha' in params ? parseFloat(params['itemsStartAlpha']) : 0;
			
			mGlow = new Image(mCommonAtlas.getTexture(mParams.glow));
			mGlow.pivotX = mGlow.width / 2;
			mGlow.pivotY = mGlow.height / 2;
			mGlow.scaleX = mGlow.scaleY = mGameManager.layoutHelper.barScale;
			mItems = [ ];
			for (var i:uint = 0; i < mItemsCount; i++) {
				var item:Image = new Image(mCommonAtlas.getTexture(mParams.item));
				item.pivotX = item.width / 2;
				item.pivotY = item.height / 2;
				item.scaleX = item.scaleY = mGameManager.layoutHelper.barScale;
				mItems.push(item);
			}
			mSparkles = [ ];
			mSparklesCount = int(mParams.duration / SPARKLES_INTERVAL);
			for (i = 0; i < mSparklesCount; i++) {
				var sparkle:Image = new Image(mCommonAtlas.getTexture(mParams.sparkle));
				sparkle.pivotX = sparkle.width / 2;
				sparkle.pivotY = sparkle.height / 2;
				sparkle.scaleX = sparkle.scaleY = mGameManager.layoutHelper.barScale;
				mSparkles.push(sparkle);
			}
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			for (var i:int = 0; i < mItemsCount; i++) {
				var item:Image = mItems[i];
				addChild(item);
				item.alpha = mItemsStartAlpha;
				
				Starling.juggler.tween(item, mItemsCycleDuration, {
					onStart: function(idx:int):void {
						mItems[idx].x = mParams.fromX;
						mItems[idx].y = mParams.fromY;
						mItems[idx].alpha = 1.0;
					},
					onStartArgs: [i],
					onRepeat: function():void {
						mSoundManager.playSfx(mParams.sfx);
					},
					delay: mParams.delay + ITEM_LOOT_DELAY * i,
					transition: Transitions.EASE_OUT,
					repeatCount: Math.floor(mParams.duration / mItemsCycleDuration),
					x: mParams.toX,
					y: mParams.toY,
					alpha: 1.0
				});
			}
			
			addChild(mGlow);
			
			mGlow.x = mParams.toX;
			mGlow.y = mParams.toY;
			mGlow.alpha = 0.0;
			
			Starling.juggler.tween(mGlow, mItemsCycleDuration, {
				transition: Transitions.EASE_IN,
				delay: mParams.delay,
				alpha: 1.0
			});
			Starling.juggler.tween(mGlow, GLOW_CYCLE_DURATION, {
				transition: Transitions.EASE_IN_OUT,
				repeatCount: Math.max(Math.floor((mParams.duration - mItemsCycleDuration) / GLOW_CYCLE_DURATION), 1),
				reverse: true,
				onComplete: function():void {
					Starling.juggler.tween(mGlow, GLOW_FADEOUT_DURATION, {
						transition: Transitions.EASE_OUT,
						alpha: 0.0 
					});
				},
				delay: mParams.delay + mItemsCycleDuration,
				scaleX: GLOW_MAX_SCALE,
				scaleY: GLOW_MAX_SCALE
			});
			
			var sparkleStartCoords:Array = [];
			var sparkleFinishCoords:Array = [];
			var sparkleStartScale:Array = [];
			var sparkleFinishScale:Array = [];
			for (i = 0; i < mSparklesCount; i++) {
				var phi:Number = [ Math.PI/2, -Math.PI*3/4, -Math.PI*3/8] [i%3];
				var startX:Number = mParams.toX + mItems[0].width * 0.4 * Math.cos(phi);
				var startY:Number = mParams.toY + mItems[0].height * 0.4 * Math.sin(phi);
				sparkleStartCoords.push(new Point(startX, startY));
				var finishX:Number = mParams.toX + mItems[0].width * 0.4 * Math.cos(phi - Math.PI/8);
				var finishY:Number = mParams.toY + mItems[0].height * 0.4 * Math.sin(phi - Math.PI/8);
				sparkleFinishCoords.push(new Point(finishX, finishY));
				sparkleStartScale.push(0.4 + Math.random() * 0.3);
				sparkleFinishScale.push(1.5 + Math.random() * 0.5);
			}
			
			for (i = 0; i < mSparklesCount; i++) {
				var sparkle:Image = mSparkles[i];
				addChild(sparkle);
				sparkle.alpha = 0;
				Starling.juggler.tween(sparkle, SPARKLE_DURATION, {
					transition: Transitions.EASE_OUT,
					onStart: function(idx:int):void {
						mSparkles[idx].x = sparkleStartCoords[idx].x;
						mSparkles[idx].y = sparkleStartCoords[idx].y;
						mSparkles[idx].scaleX = mSparkles[idx].scaleX = sparkleStartScale[idx];
						mSparkles[idx].rotation = 0;
						mSparkles[idx].alpha = 0.5;
					},
					onStartArgs: [i],
					onCompleteArgs:[i],
					onComplete: function(idx:int):void {
						mSparkles[idx].alpha = 0;
					},
					delay: mParams.delay + mItemsCycleDuration + SPARKLES_INTERVAL * i,
					scaleX: sparkleFinishScale[i],
					scaleY: sparkleFinishScale[i],
					alpha: 1.0,
					x: sparkleFinishCoords[i].x,
					y: sparkleFinishCoords[i].y,
					rotation: Math.PI * 1.25 * (Math.random() > 0.5 ? 1 : -1)
				});
			}
			flash.utils.setTimeout(disappear, disappearDelay);
		}
		
		protected function get disappearDelay():Number {
			return (mParams.delay + mParams.duration + 1) * 1000;
		}
		
		protected function disappear():void {
			Starling.juggler.tween(this, 0.5, {
				transition: Transitions.EASE_OUT,
				alpha: 0,
				onComplete: function():void {
					removeFromParent(true);
				}
			});
		}
	}
}