package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import starling.animation.Tween;
	import starling.display.Quad;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class ReadyGo extends Sprite
	{
		private var mSoundManager:SoundManager = SoundManager.instance;
		private var ready:Image;
		private var go:Image;
		private var quad:Quad;
		
		public function ReadyGo()
		{
			init();
		}
		
		public function init():void
		{
			quad = new Quad(1, 1, 0x0);
			quad.alpha = 0;
			quad.width = gameManager.layoutHelper.stageWidth;
			quad.height = gameManager.layoutHelper.stageHeight;
			addChild(quad);
			
			ready = new Image(AtlasAsset.CommonAtlas.getTexture("game/word_ready"));
			ready.alignPivot();
			ready.x = gameManager.layoutHelper.stageWidth >> 1;
			ready.y = gameManager.layoutHelper.stageHeight >> 1;
			//ready.alpha = 0;
			ready.scale = 0;
			addChild(ready);
			
			go = new Image(AtlasAsset.CommonAtlas.getTexture("game/word_go"));
			go.alignPivot();
			go.x = gameManager.layoutHelper.stageWidth >> 1;
			go.y = gameManager.layoutHelper.stageHeight >> 1;
			//go.alpha = 0;
			go.scale = 0;
			addChild(go);
		}
		
		public function show(container:DisplayObjectContainer, delay:Number = 0):void
		{
			container.addChild(this);
			
			Starling.juggler.tween(quad, 0.17, {alpha:0.4, delay:delay, transition:Transitions.LINEAR});
		
			var tweenReady_0:Tween = new Tween(ready, 0.1, Transitions.EASE_OUT_BACK);
			var tweenReady_1:Tween = new Tween(ready, 0.3, Transitions.LINEAR);
			var tweenReady_2:Tween = new Tween(ready, 0.1, Transitions.EASE_IN);
			
			tweenReady_0.delay = delay;
			tweenReady_0.animate('scale', gameManager.layoutHelper.scaleFromEtalonMin * 1.08);
			tweenReady_0.nextTween = tweenReady_1;
			tweenReady_0.onStart = mSoundManager.playVoiceover;
			tweenReady_0.onStartArgs = ['ready'];
			
			tweenReady_1.animate('scale', gameManager.layoutHelper.scaleFromEtalonMin);
			tweenReady_1.nextTween = tweenReady_2;
			
			tweenReady_2.animate('scale', 0);
//			tweenReady_2.onComplete = onComplete;
			
			Starling.juggler.add(tweenReady_0);
			
			
			var tweenGo_0:Tween = new Tween(go, 0.15, Transitions.EASE_OUT_BACK);
			var tweenGo_1:Tween = new Tween(go, 0.4, Transitions.LINEAR);
			var tweenGo_2:Tween = new Tween(go, 0.1, Transitions.EASE_IN);
			
			tweenGo_0.delay = delay + 0.5 + 0.4;
			tweenGo_0.animate('scale', gameManager.layoutHelper.scaleFromEtalonMin * 1.08);
			tweenGo_0.nextTween = tweenGo_1;
			tweenGo_0.onStart = mSoundManager.playVoiceover;
			tweenGo_0.onStartArgs = ['go'];
			
			tweenGo_1.animate('scale', gameManager.layoutHelper.scaleFromEtalonMin);
			tweenGo_1.nextTween = tweenGo_2;
			tweenGo_1.onComplete = hideFade;
			
			tweenGo_2.animate('scale', 0);
			//tweenGo_2.onComplete = remove;
			
			Starling.juggler.add(tweenGo_0);
		}

		private function hideFade():void
		{
			Starling.juggler.tween(quad, 0.13, {alpha:0, onComplete:remove, transition:Transitions.LINEAR});
		}
			
		private function remove():void
		{
			removeFromParent();
			quad.dispose();
		}	
		
	}
}