package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import flash.utils.setInterval;
	import starling.animation.Transitions;
	import starling.utils.Align;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class XPAnimatedProgressBar extends Sprite
	{
		private var progressBar:OverrunAnimatedProgressBar;
		private var titleLabel:XTextField;
		private var bonusLabel:XTextField;
		
		public function XPAnimatedProgressBar()
		{
			progressBar = new OverrunAnimatedProgressBar(
				"bars/score_progress", 
				"bars/score_progress_fill", 
				"bars/score_progress_edge",
				89, 1,
				79, 1,
				17.5,
				504,
				1);
				
			progressBar.pivotY = progressBar.height / 2;
			progressBar.y = progressBar.pivotY;
			progressBar.scaleY = 0;
			addChild(progressBar);
			
			titleLabel = new XTextField(150*pxScale, 26*pxScale, XTextFieldStyle.getChateaudeGarage(19, 0x00B8FF, Align.LEFT), 'EXPERIENCE');
			titleLabel.alignPivot(Align.LEFT);
			titleLabel.x = 107*pxScale;
			titleLabel.y = -6*pxScale + titleLabel.pivotY;
			addChild(titleLabel);
			
			bonusLabel = new XTextField(200 * pxScale, 26 * pxScale, XTextFieldStyle.getChateaudeGarage(24, 0x00B8FF, Align.LEFT), '+200 XP');
			bonusLabel.format.horizontalAlign = Align.RIGHT;
			bonusLabel.alignPivot(Align.LEFT, Align.BOTTOM);
			bonusLabel.x = width - bonusLabel.width - 16 * pxScale;
			bonusLabel.y = -8*pxScale + bonusLabel.pivotY;
			addChild(bonusLabel);
			
			progressBar.scaleY = 0;
			titleLabel.scaleY = 0;
			bonusLabel.scaleY = 0;
		}
		
		public function setValues(progress:Number, level:int, addXPValue:int):void
		{
			progressBar.setValues(progress, level);
			bonusLabel.text = '+' + addXPValue.toString() + ' XP';
		}
		
		public function animateValues(progress:Number, delay:Number, showOverrun:Boolean = false):void
		{
			Starling.juggler.tween(progressBar, 0.5, {transition:Transitions.EASE_OUT_ELASTIC, scaleY:1, delay:delay});
			progressBar.overrunAnimateValues(progress, 1, delay + 0.1, showOverrun);
			
			Starling.juggler.tween(titleLabel, 0.5, {transition:Transitions.EASE_OUT_ELASTIC, delay:(delay + 0.25), scaleY:1});
			
			Starling.juggler.tween(bonusLabel, 0.5, {transition:Transitions.EASE_OUT_BACK, delay:(delay + 0.55), scaleY:1});
			
			if (progress > progressBar.value) {
				Starling.juggler.delayCall(SoundManager.instance.playSfx, delay + 0.1, SoundAsset.RoundResultsXpBar);
				Starling.juggler.delayCall(SoundManager.instance.playSfx, delay + 0.55, SoundAsset.RoundResultsXpNumbers); 
			}
		}
		
		public function debugAnimateValues(hasBingosInRound:Boolean, isNewLevel:Boolean):void
		{
			if (hasBingosInRound)
			{
				if(isNewLevel)
					animateValues(1, 3.5);
				else
					animateValues(progressBar.value + (1 - progressBar.value) * Math.random(), 3.5);
				
				/*setInterval(function():void {
					if (progressBar.value > 0.00) {
						//animateValues(0.00)
					}
					else {
					//	animateValues(1)//0.99)
					}
					animateValues(Math.random(), 0)
					
				} , 5800);*/
			}
			else {
				animateValues(progressBar.value, 1.5);
			}
		}
	}
}

import com.alisacasino.bingo.assets.AtlasAsset;
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Image;
import com.alisacasino.bingo.controls.AnimatedProgressBar;

final class OverrunAnimatedProgressBar extends AnimatedProgressBar 
{
	public function OverrunAnimatedProgressBar(
											backgroundTexture:String,
											fillTexture:String,
											edgeTexture:String,
											backgroundScale9X:Number,
											backgroundScale9Width:Number,
											fillScale9X:Number,
											fill9Width:Number,
											maskX:Number,
											bgWidth:Number,
											edgeWidthShift:Number
											)
	{
		super(	backgroundTexture,
				fillTexture,
				edgeTexture,
				backgroundScale9X,
				backgroundScale9Width,
				fillScale9X,
				fill9Width,
				maskX,
				bgWidth,
				edgeWidthShift);
	}
	
	public function overrunAnimateValues(progress:Number, duration:Number=1.0, delay:Number = 0.0, showOverrun:Boolean = false):void
	{
		if (showOverrun) 
		{
			animateValues(1, duration, delay);	
			
			Starling.juggler.tween(fill.mask, 0.45, {delay:(delay + duration + 0.2), x:(maskX + fill.texture.frameWidth), transition:Transitions.LINEAR, onComplete:completeOverrunProgress, onCompleteArgs:[progress]});
			
			var flare:Image = new Image(AtlasAsset.CommonAtlas.getTexture("bars/progress_flare"));
			flare.alignPivot();
			flare.alpha = 0.4;
			flare.x = flare.pivotX + 41 * pxScale;
			flare.y = flare.pivotY + 21 * pxScale;
			
			addChildAt(flare, 0);
			
			//Starling.juggler.tween(flare, 3.2, {delay:(delay + duration + 0.3), x:(bg.width - flare.pivotX), transition:Transitions.EASE_OUT});
		
			
			var tween_0:Tween = new Tween(flare, 0.46, Transitions.LINEAR);
			var tween_1:Tween = new Tween(flare, 0.24, Transitions.LINEAR);
			
			tween_0.delay = delay + duration + 0.23;
			tween_0.animate('scaleX', 1.7);
			tween_0.animate('alpha', 1.0);
			tween_0.animate('x', (bg.width - flare.pivotX)/1.5);
			tween_0.nextTween = tween_1;
			
			//tween_1.delay = 0.1;
			tween_1.animate('scaleX', 1);
			tween_1.animate('alpha', 0);
			tween_1.animate('x', bg.width - flare.pivotX);
			
			//tween_1.onComplete = callback_particleColoredStarsAndSquaresRaysComplete;
			//tween_1.onCompleteArgs = [rays];
			
			Starling.juggler.add(tween_0);
		}
		else 
		{
			animateValues(progress, duration, delay);	
		}
	}
	
	public function completeOverrunProgress(progress:Number):void
	{
		fill.mask.x = 0;
		value = 0;
		//fill.mask.width = 0;
		animateValues(progress, 1.0, 0);	
	}
}