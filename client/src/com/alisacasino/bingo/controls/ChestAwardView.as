package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.ITextLoader;
	import com.alisacasino.bingo.components.effects.ParticleExplosion;
	import com.alisacasino.bingo.models.chests.ChestData;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.utils.DelayCallUtils;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	
	public class ChestAwardView extends Sprite
	{
		private var DELAY_CALLS_BUNDLE:String = 'ChestAwardView';
		
		private var delayParticleEffect:ParticleExplosion;
		
		private var starsExplosion:ParticleExplosion;
		
		private var chestTypesSequence:Vector.<int>;
		private var chestTypes:Vector.<int>;
		private var _currentShowChestIndex:int = -1;
		private var completeShowFunction:Function;
		
		private var splashAnimation:AnimationContainer;
		
		private var winChestType:int;
		
		private var _skipFinishEffect:Boolean;
		private var isBlocked:Boolean;
		private var showAlertSign:Boolean;
		
		public function ChestAwardView(completeShowFunction:Function)
		{
			this.completeShowFunction = completeShowFunction;
			
			starsExplosion = new ParticleExplosion(AtlasAsset.LoadingAtlas, "misc/white_star", /*new <uint> [0xFFFFFF, 0xFFFF00, 0x00F0FF]*/null, 30);
			starsExplosion.setProperties(0, 70*pxScale, 3, -0.02, 0.07, 0, 1);
			starsExplosion.setFineProperties(1, 0.2, 0.5, 2, 0.5, 4);
			addChildAt(starsExplosion, 0);
			
			delayParticleEffect = new ParticleExplosion(AtlasAsset.CommonAtlas, new <String> ["icons/star"], new <uint> [0xFFFFFF]);
			delayParticleEffect.setProperties(0, 80*pxScale, -0.1, -0.018, 0.01, 0, 0.7, true);
			delayParticleEffect.setFineProperties(0.2, 0.1, 0.2, 1.6);
			delayParticleEffect.setAccelerationProperties(-0.02);
			addChild(delayParticleEffect);
			
			chestTypesSequence = new Vector.<int>();
			chestTypes = new <int>[ChestType.BRONZE, ChestType.SILVER, ChestType.GOLD, ChestType.SUPER];
			
			//addChild(new Quad(150, 150, 0xFF0000));
		}
		
		public function show(winChestType:int, timeout:Number, iterations:int, delay:Number, showAlertSign:Boolean = false, isBlocked:Boolean = false):void 
		{
			this.winChestType = winChestType;
			this.showAlertSign = showAlertSign;
			this.isBlocked = isBlocked;
			
			/*var count:int;
			var currentChestTypeIndex:int;
			var chestType:int;
			while (--iterations > 0 || chestType != winChestType) {
				count++;
				var index:int = count % (chestTypes.length);
				chestType = chestTypes[index];
				chestTypesSequence.push(chestType);
				
				if (iterations < -50)
					break;
			}*/
			
			//Starling.juggler.tween(this, timeout, {transition:Transitions.EASE_OUT, delay:delay, currentShowChestIndex:chestTypesSequence.length-1});
			
		 	//DelayCallUtils.add( Starling.juggler.delayCall(EffectsManager.showStarsShine, delay - 4, this, new Rectangle(-50, -50, 100*pxScale, 100*pxScale), 45, 0.1, 0.8, 1), DELAY_CALLS_BUNDLE);
			//EffectsManager.showStarsShine(this, new Rectangle(-50, -50, 100*pxScale, 100*pxScale), 30, 0.1, 0.8, 1);
			
			//chestTypesSequence[index];
			chestTypesSequence = new Vector.<int>();
			chestTypesSequence.push(winChestType);
			
			if (winChestType != ChestType.NONE)  {
				delayParticleEffect.play(0, 20, 0);
				
				if(!showAlertSign && !isBlocked)
					DelayCallUtils.add(Starling.juggler.delayCall(SoundManager.instance.playSfx, delay - 2.0, SoundAsset.RoundResultsChestsV3, 0, 0, 1), DELAY_CALLS_BUNDLE);	
			}
			
			Starling.juggler.delayCall(showChestByIndex, delay, 0);
		}
		
		public function appear(delay:Number, finishScale:Number):void {
			scaleY = 0;
			Starling.juggler.tween(this, 0.05, {transition:Transitions.EASE_IN, delay:(delay+0.05), scaleY:finishScale*1.3});
			Starling.juggler.tween(this, 0.05, {transition:Transitions.EASE_IN, delay:(delay+0.05), scaleY:finishScale*0.8, scaleX:finishScale*1.2});
			Starling.juggler.tween(this, 0.05, {transition:Transitions.EASE_IN, delay:(delay+0.1), scaleY:finishScale, scaleX:finishScale});
		}
		
		public function hide(delay:Number):void 
		{
			SoundManager.instance.stopSfx(SoundAsset.RoundResultsChestsV3);
			
			DelayCallUtils.cleanBundle(DELAY_CALLS_BUNDLE);
			
			Starling.juggler.removeTweens(this);
			
			for (var i:int = 0; i < numChildren; i++) {
				Starling.juggler.tween(getChildAt(i), 0.3, {transition:Transitions.EASE_IN_BACK, delay:delay, scale:0});
			}
			
			Starling.juggler.delayCall(showSplash, delay + 0.05);
		}
		
		public function set currentShowChestIndex(value:int):void 
		{
			if (_currentShowChestIndex == value)
				return;
				
			_currentShowChestIndex = value;
			
			showChestByIndex(_currentShowChestIndex);
		}
		
		public function get currentShowChestIndex():int
		{
			return _currentShowChestIndex;
		}
		
		public function skipFinishEffect():void {
			_skipFinishEffect = true;
			//SoundManager.instance.stopSfx(SoundAsset.RoundResultsChestsV3);
		}
		
		private function showChestByIndex(index:int):void 
		{
			//trace(">> ", index, chestTypesSequence.length);
			
			if (index == chestTypesSequence.length) 
				return;
			
			var image:ChestImage;
			for (var i:int = 1; i < numChildren; i++ ) {
				image = getChildAt(i) as ChestImage;
				if (image)
				{
					if (Starling.juggler.containsTweens(image))
						break;
					Starling.juggler.tween(image, 0.1, {transition:Transitions.EASE_OUT, scale:0, onComplete:removeView, onCompleteArgs:[image]});
				}
			}
			
			image = new ChestImage(chestTypesSequence[index], showAlertSign, isBlocked);
			image.alignPivot();
			image.scale = 0.4;
			image.alpha = 0;
			addChild(image);
			
			Starling.juggler.tween(image, 0.2, {transition:Transitions.EASE_OUT_BACK, scale:1, alpha:1/*, onStart:(_skipFinishEffect ? null : playSoundChestAppear)*/});
			
			if (winChestType != ChestType.NONE && !showAlertSign && !isBlocked && index == chestTypesSequence.length - 1) 
			{
				Starling.juggler.delayCall(starsExplosion.play, 0.01, 250, 70, 20);
				if (!_skipFinishEffect && completeShowFunction != null)
					completeShowFunction();
			}
			
			delayParticleEffect.stop();
		}
		
		/*private function playSoundChestAppear():void
		{
			SoundManager.instance.playSfx(SoundAsset.RoundResultsChests, 0, 0, 1, 2980);
		}*/
		
		private function showSplash(delay:Number = 0):void
		{
			///return;
			
			splashAnimation = new AnimationContainer(MovieClipAsset.PackBase, false, true);
			splashAnimation.scale = 2;
			addChild(splashAnimation);
			
			splashAnimation.playTimeline('splash', true, false, 24);
			splashAnimation.reverse = true;
			splashAnimation.goToAndPlay(splashAnimation.totalFrames);
			
			Starling.juggler.tween(splashAnimation, 0.1, {transition:Transitions.LINEAR, delay:(delay + 0.25), scale:0});
		}
		
		private function removeView(displayObject:DisplayObject):void
		{
			displayObject.removeFromParent();
		}
		
	}
}

import com.alisacasino.bingo.assets.AtlasAsset;
import com.alisacasino.bingo.dialogs.chests.ChestPartsView;
import com.alisacasino.bingo.models.chests.ChestData;
import com.alisacasino.bingo.protocol.ChestType;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

final class ChestImage extends Sprite
{
	//private var image:Image;
	//private var chains:Image;
	private var showAlertSign:Boolean;
	private var chestType:int;
	
	public function ChestImage(chestType:int, showAlertSign:Boolean, showChains:Boolean):void
	{
		this.chestType = chestType;
		this.showAlertSign = showAlertSign;
		var chestView:DisplayObject;
		var textureString:String;
		
		if (showAlertSign)
			textureString = 'controls/chest/no_chest';
		else if (chestType == ChestType.NONE)
			textureString = 'controls/chest/no_chest';
		else {
			chestView = new ChestPartsView(chestType, 0.78, null, 0, -28 * pxScale);
			(chestView as ChestPartsView).scale = 1;
			//textureString = ChestData.getTexture(chestType);
		}
		
		if (textureString)
			chestView = new Image(AtlasAsset.CommonAtlas.getTexture(textureString));
			
		
		addChild(chestView);
		
		if (showAlertSign) 
		{
			var alertSign:Image = new Image(AtlasAsset.CommonAtlas.getTexture('controls/chest/no_slot_sign'));
			alertSign.x = 77 * pxScale;
			alertSign.y = 57*pxScale;
			addChild(alertSign);
		}	
		
		/*if (showChains) 
		{
			var chains:Image = new Image(AtlasAsset.CommonAtlas.getTexture('controls/chest/chains'));
			addChild(chains);
			
			switch(chestType) {
				case ChestType.BRONZE: {
					chains.x = -6*pxScale;
					chains.y = 8*pxScale;
					chains.scale = 0.9;
					break;
				}	
				case ChestType.SILVER: {
					chains.x = -5*pxScale;
					chains.y = 10*pxScale;
					chains.scale = 0.9;
					break;
				}
				case ChestType.GOLD: {
					chains.x = -5*pxScale;
					chains.y = 6*pxScale;
					chains.scale = 0.924;
					break;
				}
				case ChestType.SUPER: {
					chains.x = -1*pxScale;
					chains.y = 16*pxScale;
					break;
				}
			}
		}*/
	}
	
	override public function alignPivot(horizontalAlign:String="center", verticalAlign:String="center"):void 
	{
		if (showAlertSign) {
			pivotX = width / 2 - 17*pxScale;
			pivotY = height / 2 - 5*pxScale;
		}
		else if (chestType == ChestType.NONE) {
			pivotX = width / 2;
			pivotY = height / 2;
		}
	}
}