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
	import starling.utils.TweenHelper;
	
	public class AnimatedResultsView extends Sprite
	{
		private var image:Image;
		private var titleLabel:XTextField;
		private var extraTextLabel:XTextField;
		private var valueLabel:XTextField;
		private var starsExplosion:ParticleExplosion;
		
		private var textPrefix:String;
		private var _animatedValue:int = -1;
		private var value:int;
		
		private var showOscillateCalled:Boolean;
		private var oscillateAmplitude:int;
		
		private var callbackFlyComplete:Function;
		private var needPlayValueCountSound:Boolean;
		
		
		public function AnimatedResultsView(title:String, icon:String, textPrefix:String, callbackFlyComplete:Function, imageStartShiftX:int, imageStartShiftY:int, needPlayValueCountSound:Boolean = true)
		{
			this.textPrefix = textPrefix;
			this.callbackFlyComplete = callbackFlyComplete;
			this.needPlayValueCountSound = needPlayValueCountSound;
			
			image = new Image(AtlasAsset.CommonAtlas.getTexture(icon));
			image.alignPivot();
			image.alpha = 0.6;
			image.scale = 2;
			image.x = imageStartShiftX;
			image.y = imageStartShiftY;
			addChild(image);
			
			titleLabel = new XTextField(100*pxScale, 30*pxScale, XTextFieldStyle.getChateaudeGarage(21, 0xFFFFFF, Align.LEFT), title);
			titleLabel.x = 63*pxScale;
			titleLabel.y = -24*pxScale;
			titleLabel.pivotY = titleLabel.height / 2;
			titleLabel.scaleY = 0;
			//titleLabel.border = true;
			addChild(titleLabel);
			
			valueLabel = new XTextField(165*pxScale, 40*pxScale, XTextFieldStyle.getChateaudeGarage(42, 0xFFFFFF, Align.LEFT));
			valueLabel.pivotY = valueLabel.height / 2;
			//valueLabel.border = true;
			valueLabel.x = 63*pxScale;
			valueLabel.y = 9 * pxScale;
			valueLabel.alpha = 0;
			addChild(valueLabel);
			
			starsExplosion = new ParticleExplosion(AtlasAsset.LoadingAtlas, "misc/white_star", /*new <uint> [0xFFFFFF, 0xFFFF00, 0x00F0FF]*/null, 30);
			starsExplosion.setProperties(0, 30*pxScale, 3, -0.03, 0.07, 0, 1);
			starsExplosion.setFineProperties(0.6, 0.8, 0.5, 2, 0.5, 4);
			addChildAt(starsExplosion, 0);
		}
		
		public function show(value:int, delay:Number = 0, extraValue:int = 0, extraText:String = null):void 
		{
			if (showOscillateCalled) {
				showOscillateCalled = false;
				Starling.juggler.removeTweens(this);
				Starling.juggler.tween(this, 0.6, {transition:Transitions.EASE_OUT, animatedValue:value, onComplete:showExtraValue, onCompleteArgs:[extraValue, extraText, 0.7]});
				return;
			}
			
			this.value = value;
			if(value > 0)
				tweenAppearPositiveValue(delay, true, extraValue, extraText);
			else
				tweenAppearEmptyValue(delay);
		}
		
		/**
		 * Постоянно крутит значение со средним value и амплитудой amplitude. Сделано на время ожидания реального значения аля что-то крутится и происходит.
		 * */
		public function showOscillate(value:int, amplitude:int, delay:Number):void 
		{
			showOscillateCalled = true;
			this.value = value;
			this.oscillateAmplitude = amplitude;
			if (value > 0) {
				tweenAppearPositiveValue(delay, false);
				Starling.juggler.tween(this, 0.6, {transition:Transitions.EASE_OUT, animatedValue:(value + amplitude/2), delay:(delay + 0.7), onComplete:tweenOscillateDown});
			}
			else
				tweenAppearEmptyValue(delay);
		}
		
		private function tweenOscillateDown():void 
		{
			Starling.juggler.tween(this, 0.7, {transition:Transitions.EASE_OUT, animatedValue:Math.max(1, value - oscillateAmplitude/2), onComplete:tweenOscillateUp});
		}
		
		private function tweenOscillateUp():void 
		{
			Starling.juggler.tween(this, 0.7, {transition:Transitions.EASE_OUT, animatedValue:(value + oscillateAmplitude/2), onComplete:tweenOscillateDown});
		}
		
		public function set animatedValue(value:int):void {
			if (_animatedValue == value)
				return;
				
			_animatedValue = value;
			valueLabel.text = textPrefix + value.toString();
		}
		
		public function get animatedValue():int {
			return _animatedValue;
		}
		
		private function showExtraValue(extraValue:int, extraText:String, delay:Number = 0):void
		{
			if (extraValue <= 0)
				return;
			
			//Starling.juggler.tween(this, 0.6, {transition:Transitions.EASE_OUT, animatedValue:extraValue, delay:(delay + 0.6)});	
			
			if (extraText)
			{
				extraTextLabel = new XTextField(1, 1, XTextFieldStyle.getChateaudeGarage(30, 0xD658E9, Align.LEFT), extraText);
				extraTextLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
				extraTextLabel.alignPivot(Align.LEFT, Align.CENTER);
				extraTextLabel.x = titleLabel.x + titleLabel.textBounds.x + titleLabel.textBounds.width //+ 3 * pxScale;
				extraTextLabel.y = titleLabel.y + 15*pxScale; //+ // + extraTextLabel.pivotY;
				extraTextLabel.alpha = 0;
				addChild(extraTextLabel);
				
				//Starling.juggler.tween(extraTextLabel, 1.2, {transition:Transitions.EASE_OUT, delay:(delay + 0.2), alpha:10, y:(extraTextLabel.y - 33 * pxScale)});
				//Starling.juggler.tween(extraTextLabel, 0.15, {transition:Transitions.LINEAR, delay:(delay + 1.25), alpha:0});
				
			//	TweenHelper.tween(extraTextLabel, 1.2, {transition:Transitions.EASE_OUT, delay:(delay + 0.2), alpha:10, y:(extraTextLabel.y - 33 * pxScale)}).
				//	chain(extraTextLabel, 0.15, {transition:Transitions.LINEAR, delay:(delay + 1.05), alpha:0});
			}
		
			alignValueLabel();
			
			var tween_0:Tween = new Tween(valueLabel, 0.15, Transitions.EASE_IN_BACK);
			var tween_1:Tween = new Tween(valueLabel, 0.1, Transitions.EASE_OUT);
			var tween_2:Tween = new Tween(valueLabel, 0.2, Transitions.EASE_IN);
			var tween_3:Tween = new Tween(valueLabel, 0.2, Transitions.EASE_OUT_BACK);
			
			var tween_4:Tween = new Tween(valueLabel, 0.15, Transitions.EASE_IN_BACK);
			var tween_5:Tween = new Tween(valueLabel, 0.1, Transitions.EASE_OUT);
			var tween_6:Tween = new Tween(valueLabel, 0.2, Transitions.EASE_IN);
			var tween_7:Tween = new Tween(valueLabel, 0.2, Transitions.EASE_OUT_BACK);
			
			tween_0.delay = delay + 0.75;
			tween_0.animate('scaleY', 1.5);
			tween_0.animate('scaleX', 0.6);
			tween_0.nextTween = tween_1;
			
			tween_1.animate('scaleY', 0);
			tween_1.animate('scaleX', 1.3);
			tween_1.onComplete = setValue;
			tween_1.onCompleteArgs = [/*extraValue*/extraText, /*0xD658E9*/0xFF3CDE];
			tween_1.nextTween = tween_2;
			
			tween_2.animate('scaleY', 1.5);
			tween_2.animate('scaleX', 0.6);
			tween_2.nextTween = tween_3;
			
			tween_3.animate('scaleY', 1);
			tween_3.animate('scaleX', 1);
			
			
			tween_3.nextTween = tween_4;
			
			
			tween_4.delay = 0.75;
			tween_4.animate('scaleY', 1.5);
			tween_4.animate('scaleX', 0.6);
			tween_4.nextTween = tween_5;
			
			tween_5.animate('scaleY', 0);
			tween_5.animate('scaleX', 1.3);
			tween_5.onComplete = setValue;
			tween_5.onCompleteArgs = [extraValue.toFixed(), 0xFFFFFF];
			tween_5.nextTween = tween_6;
			
			tween_6.animate('scaleY', 1.5);
			tween_6.animate('scaleX', 0.6);
			tween_6.nextTween = tween_7;
			
			tween_7.animate('scaleY', 1);
			tween_7.animate('scaleX', 1);
			
			
			Starling.juggler.add(tween_0);
			
		}
		
		private function tweenAppearPositiveValue(delay:Number, setValue:Boolean = true, extraValue:int = 0, extraText:String = null):void 
		{
			Starling.juggler.delayCall(starsExplosion.play, delay + 0.23, 150, 40, 20);
			
			Starling.juggler.tween(image, 0.23, {transition:Transitions.EASE_IN, x:0, y:0, scale:1, alpha:1, delay:delay, onComplete:callbackFlyComplete, onStart:SoundManager.instance.playSfx, onStartArgs:[SoundAsset.RoundResultsRankPointsHitV2]});
			Starling.juggler.tween(image, 0.07, {transition:Transitions.EASE_IN, delay:(delay + 0.23), scale:1.19 ,rotation:Math.PI/25});
			Starling.juggler.tween(image, 0.8, {transition:Transitions.EASE_OUT_ELASTIC, delay:(delay + 0.3), scale:1 ,rotation:0});
			
			Starling.juggler.tween(titleLabel, 0.3, {transition:Transitions.EASE_OUT_BACK, scaleY:1, delay:(delay + 0.4)});
			Starling.juggler.tween(valueLabel, 0.1, {transition:Transitions.LINEAR, alpha:1, delay:(delay + 0.6)});
			
			if(setValue)
				Starling.juggler.tween(this, 0.6, {transition:Transitions.EASE_OUT, animatedValue:value, delay:(delay + 0.7), onStart:(needPlayValueCountSound ? playValueCountSound : null), onComplete:showExtraValue, onCompleteArgs:[extraValue, extraText]});
		}
		
		private function tweenAppearEmptyValue(delay:Number):void 
		{
			image.x = 0;
			image.y = 0;
			image.scaleY = 0;
			image.rotation = 0;
			image.alpha = 1;
			Starling.juggler.tween(image, 0.2, {transition:Transitions.EASE_OUT, delay:(delay + 0.0), scale:1});
			Starling.juggler.tween(titleLabel, 0.3, {transition:Transitions.EASE_OUT_BACK, scaleY:1, delay:(delay + 0.1)});
			Starling.juggler.tween(valueLabel, 0.1, {transition:Transitions.LINEAR, alpha:1, delay:(delay + 0.1)});
			Starling.juggler.delayCall(setValue, delay + 0.2, value.toString());
		}
		
		public function setValue(value:String, color:int = -1):void 
		{
			valueLabel.text = textPrefix + value;
			if (color != -1)
				valueLabel.format.color = color;
			
			alignValueLabel();
		}
		
		private function alignValueLabel():void 
		{
			valueLabel.pivotX = valueLabel.textBounds.x + valueLabel.textBounds.width/ 2;
			valueLabel.x = 63*pxScale + valueLabel.pivotX;
		}
		
		private function playValueCountSound():void {
			SoundManager.instance.playSfx(SoundAsset.RoundResultsCount);
		}
		
	}
}