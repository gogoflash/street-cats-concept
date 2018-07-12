package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.components.effects.ParticleExplosion;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextFieldAutoSize;
	import starling.utils.Align;
	
	public class PlayerValueView extends Sprite
	{
		private var bg:Image;
		private var image:Image;
		private var valueLabel:XTextField;
		
		private var extraValueLabel:XTextField;
		private var soundAsset:SoundAsset;
		
		public function PlayerValueView(icon:String, iconShiftY:int, soundAsset:SoundAsset = null)
		{
			bg = new Image(AtlasAsset.CommonAtlas.getTexture('bars/base_frameless'));
			bg.alignPivot(Align.LEFT);
			bg.scaleX = 0;
			addChild(bg);
			
			image = new Image(AtlasAsset.CommonAtlas.getTexture(icon));
			image.alignPivot();
			image.y = iconShiftY*pxScale;
			image.scaleY = 0;
			addChild(image);
			
			valueLabel = new XTextField(1, 1, XTextFieldStyle.getChateaudeGarage(50));
			valueLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			valueLabel.alignPivot();
			//valueLabel.border = true;
			valueLabel.x = 105 * pxScale;
			valueLabel.y = 0 * pxScale;
			valueLabel.scaleY = 0;
			addChild(valueLabel);
			
			this.soundAsset = soundAsset;
		}
		
		public function show(value:int, delay:Number):void {
			valueLabel.text = value.toString();
			valueLabel.alignPivot();
			tweenAppear(delay);
		}
		
		// uses for new level
		public function showExtraValue(value:int, extraValue:int, delay:Number=0, animate:Boolean = false):void 
		{
			if (gameManager.deactivated)
				return;
				
			if (!animate) 
			{
				if (extraValueLabel) {
					Starling.juggler.removeTweens(extraValueLabel);
					extraValueLabel.removeFromParent();
					extraValueLabel = null;
				}
				
				Starling.juggler.removeTweens(valueLabel);
				valueLabel.scale = 1;
				valueLabel.text = value.toString();
				valueLabel.alignPivot();
				
				return;
			}
			
			extraValueLabel = new XTextField(1, 1, XTextFieldStyle.getChateaudeGarage(52, 0xFDFE08), '+' + extraValue.toString());
			extraValueLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			extraValueLabel.alignPivot(Align.LEFT);
			//valueLabel.border = true;
			extraValueLabel.x = valueLabel.x - valueLabel.pivotX + valueLabel.textBounds.x + valueLabel.textBounds.width;
			extraValueLabel.y = -12*pxScale;
			extraValueLabel.alpha = 0;
			addChild(extraValueLabel);
			
			//extraValueLabel.text = value.toString();
			
			var tween_0:Tween = new Tween(valueLabel, 0.15, Transitions.EASE_IN_BACK);
			var tween_1:Tween = new Tween(valueLabel, 0.1, Transitions.EASE_OUT);
			var tween_2:Tween = new Tween(valueLabel, 0.2, Transitions.EASE_IN);
			var tween_3:Tween = new Tween(valueLabel, 0.2, Transitions.EASE_OUT_BACK);
			
			tween_0.delay = delay + 0.75;
			tween_0.animate('scaleY', 1.5);
			tween_0.animate('scaleX', 0.6);
			tween_0.nextTween = tween_1;
			
			tween_1.animate('scaleY', 0);
			tween_1.animate('scaleX', 1.5);
			tween_1.onComplete = setValue;
			tween_1.onCompleteArgs = [value];
			tween_1.nextTween = tween_2;
			
			tween_2.animate('scaleY', 1.5);
			tween_2.animate('scaleX', 0.6);
			tween_2.nextTween = tween_3;
			
			tween_3.animate('scaleY', 1);
			tween_3.animate('scaleX', 1);
			
			Starling.juggler.add(tween_0);
			
			Starling.juggler.tween(extraValueLabel, 1, {transition:Transitions.EASE_OUT, delay:delay, alpha:10, y:(extraValueLabel.y - 18 * pxScale)});
			Starling.juggler.tween(extraValueLabel, 0.15, {transition:Transitions.LINEAR, delay:(delay + 0.85), alpha:0});
		}
		
		public function setValue(value:int):void {
			valueLabel.text = value.toString();
			valueLabel.alignPivot();
		}
		
		private function tweenAppear(delay:Number):void 
		{
			Starling.juggler.tween(image, 0.9, {transition:Transitions.EASE_OUT_ELASTIC, delay:delay, scaleY:1});
			
			Starling.juggler.tween(bg, 0.5, {transition:Transitions.EASE_OUT_BACK, delay:(delay + 0.2), scaleX:1, onStart:SoundManager.instance.playSfx, onStartArgs:[soundAsset]});
			
			Starling.juggler.tween(valueLabel, 0.5, {transition:Transitions.EASE_OUT_BACK, delay:(delay + 0.4), scaleY:1});
		}
	}
}