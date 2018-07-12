package com.alisacasino.bingo.dialogs.slots 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.Fonts;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.controls.BingoTextFormat;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.slots.SlotMachineRewardType;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.utils.DelayCallUtils;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.caurina.transitions.properties.TextShortcuts;
	import feathers.core.FeathersControl;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.Align;
	import starling.utils.TweenHelper;

	public class SlotMachineIndicator extends Sprite 
	{
		public static const COLOR_ANGEL_BLUE:uint = 0x0075FC;
		
		public static const COLOR_RED:uint = 0xFF0000;
		
		public static const COLOR_GREEN:uint = 0x00DD00;
		
		public static const COLOR_PURPLE:uint = 0xFF3CEF;
		
		public static const COLOR_PINK:uint = 0xFF5096;
		
		public static const COLOR_BLUE:uint = 0x3CBEFF;
		
		public static const COLOR_YELLOW:uint = 0xFBFF2C;
		
		public static const COLOR_BLUE_LIGHT:uint = 0x59C8FA;
		
		private const BG_WIDTH:uint = 560*pxScale;
		
		private const BG_HEIGHT:uint = 84*pxScale;
		
		public var defaultColor:uint = COLOR_ANGEL_BLUE;
		
		public var defaultTextSize:uint = 52*pxScale;
		
		public var DELAY_CALL_BUNDLE:String = 'SMI';
		
		private var indicatorTextField:TextField;
	
		private var textGlow:Image;
		
		private var sequenceList:Array = [];
		
		private var loopSequence:int;
		
		private var sequenceShowTime:Number;
		private var sequenceChangeTime:Number;
		
		private var animateIntHelperId:uint;
		
		private var temporaryDisplayObjects:Array;
		
		public function SlotMachineIndicator() 
		{
			temporaryDisplayObjects = [];
			
			var bg:Quad = new Quad(1, 1, 0x1A1A1A);
			bg.width = BG_WIDTH;
			bg.height = BG_HEIGHT;
			addChild(bg);
			
			var maskDotsWidth:int = 552*pxScale;
			var maskDotsShiftX:int = 3*pxScale;
			var maskDotsShiftY:int = 3*pxScale;
			
			var maskDots:Image = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/screen_mask_dots'));
			maskDots.x = maskDotsShiftX;
			maskDots.y = maskDotsShiftY;
			addChild(maskDots);
			
			maskDots = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/screen_mask_dots_tile'));
			maskDots.tileGrid = ResizeUtils.getScaledRect(0, 0, 10, 0);
			maskDots.width = maskDotsWidth / 2 - 176*pxScale;
			maskDots.x = maskDotsShiftX + 176*pxScale;
			maskDots.y = maskDotsShiftY;
			addChild(maskDots);
			
			maskDots = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/screen_mask_dots_tile'));
			maskDots.tileGrid = ResizeUtils.getScaledRect(0, 0, 10, 0);
			maskDots.scaleX = -(maskDotsWidth / 2 - 176*pxScale)/maskDots.width;
			maskDots.x = maskDotsShiftX + maskDotsWidth / 2 + (maskDotsWidth / 2 - 176*pxScale);
			maskDots.y = maskDotsShiftY;
			addChild(maskDots);
			
			maskDots = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/screen_mask_dots'));
			maskDots.scaleX = -1;
			maskDots.x = maskDotsShiftX + maskDotsWidth;
			maskDots.y = maskDotsShiftY;
			addChild(maskDots);
			
			/*var maskDots:Image = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/screen_mask_1'));
			maskDots.x = 3;
			maskDots.y = 3;
			addChild(maskDots);*/
			
			textGlow = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/text_glow'));
			textGlow.pivotX = 60.5*pxScale;
			textGlow.pivotY = 46*pxScale;
			textGlow.alpha = 0.55;
			textGlow.scale9Grid = ResizeUtils.getScaledRect(60, 45, 1, 2);
			textGlow.color = defaultColor;
			addChild(textGlow);
		
			
			var maskCross:Image = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/screen_mask_cross'));
			maskCross.tileGrid = ResizeUtils.getScaledRect(0, 0, 55, 0);
			maskCross.width = maskDotsWidth;
			maskCross.x = 2*pxScale;
			maskCross.y = 0;
			addChild(maskCross);
			
		/*	var maskCross:Image = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/screen_mask_2'));
			maskCross.x = 3 + 1;
			maskCross.y = 3 +  5;
			addChild(maskCross);*/
			
			var bingoTextFormat:BingoTextFormat = new BingoTextFormat(Fonts.MATRIX_COMPLEX, 53 * pxScale, 0x00BDFF, Align.CENTER);
			indicatorTextField = new TextField(550*pxScale, 83*pxScale, defaultMessage, bingoTextFormat);
			indicatorTextField.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			indicatorTextField.isHtmlText = true;
			indicatorTextField.alignPivot();
			indicatorTextField.x = indicatorTextField.pivotX;
			indicatorTextField.y = indicatorTextField.pivotY + 5*pxScale;
			addChild(indicatorTextField);
			
			var maskQuad:Quad = new Quad(1, 1, 0x1A1A1A);
			maskQuad.width = 560*pxScale;
			maskQuad.height = 84*pxScale;
			mask = maskQuad;
			
			
			indicatorTextField.text = defaultMessage;
			refreshTextGlow();
			
			Starling.juggler.tween(textGlow, 0.06, {alpha:0.38, repeatCount:0});
		}
		
		public function clean():void 
		{
			Starling.juggler.removeTweens(textGlow);
			cleanTweens();
		}
		
		/******************************************************************************************************************************************
		* 
		* 
		* 
		******************************************************************************************************************************************/
		
		/**
		 * Base text show function with tweens
		 * */
		public function showText(text:String, color:uint, size:int, linearScale:Boolean = false, time:Number = 0.5, delay:Number = 0, onComplete:Function = null, onCompleteArgs:Function = null, removeTextTweens:Boolean = true):void 
		{
			if(removeTextTweens)
				Starling.juggler.removeTweens(indicatorTextField);
			
			if (indicatorTextField.text == text && indicatorTextField.format.color == color && indicatorTextField.format.size == size) 
				return;
			
			if (time == 0) 
			{
				if(delay == 0)
					changeText(text, color, size);
				//else
					//Starling.juggler.delayCall(changeText, 
				return;
			}
			
			if (text == '') {
				
				TweenHelper.tween(indicatorTextField, 0.4*time, {delay:delay, scaleX:1.3, scaleY:0, transition:Transitions.EASE_IN_BACK, onUpdate:refreshTextGlow, onComplete:completeCleanText, onCompleteArgs:[onComplete]})
			}
			else 
			{
				if (indicatorTextField.text == '') 
				{
					changeText(text, color, size);//indicatorTextField.format.color, indicatorTextField.format.size);
					indicatorTextField.scaleX = 1.3;
					indicatorTextField.scaleY = 0;
					TweenHelper.tween(indicatorTextField, 0.4*time, {delay:delay, scaleX:1, scaleY:1, transition:Transitions.EASE_OUT_BACK, onUpdate:refreshTextGlow, onComplete:onComplete})
				}
				else {
					TweenHelper.tween(indicatorTextField, 0.4*time, {delay:delay, scaleX:1.3, scaleY:0, transition:Transitions.EASE_IN_BACK, onUpdate:refreshTextGlow, onComplete:changeText, onCompleteArgs:[text, color, size]})
				.chain(indicatorTextField, 0.6*time, {scaleX:1, scaleY:1, onUpdate:refreshTextGlow, transition:Transitions.EASE_OUT_BACK, onComplete:onComplete});
				//indicatorTextField.scale = 1;
				}
			}
		}
		
		private function completeCleanText(onComplete:Function = null):void 
		{
			changeText('', indicatorTextField.format.color, indicatorTextField.format.size);
			refreshTextGlow();
			if (onComplete != null)
				onComplete();
		}
		
		private function changeText(text:String, color:uint, size:int):void 
		{
			indicatorTextField.text = text;
			textGlow.color = color;
			if (indicatorTextField.format.color != color || indicatorTextField.format.size != size) 
			{
				indicatorTextField.format.size = size/* * pxScale*/;
				indicatorTextField.format.color = color;
				indicatorTextField.setRequiresRedraw();
			}
			
			indicatorTextField.alignPivot();
			indicatorTextField.x = indicatorTextField.pivotX + (BG_WIDTH - indicatorTextField.textBounds.width)/2;
			indicatorTextField.y = indicatorTextField.pivotY + (BG_HEIGHT - indicatorTextField.textBounds.height)/2 + 5*pxScale;
		}
		
		public function showTextSequence(texts:Array, colors:Array, sizes:Array, startDelay:Number, showTime:Number, changeTime:Number, loop:Boolean = false):void 
		{
			cleanTweens();
			
			sequenceList.splice(0, sequenceList.length);
			
			for (var i:int = 0; i < texts.length; i++) {
				sequenceList[i] = [texts[i], colors[i], sizes[i]];
			}
			
			loopSequence = loop ? 0 : -1;
			sequenceShowTime = showTime;
			sequenceChangeTime = changeTime;
			
			showNextFromSequence(startDelay);
		}
		
		private function showNextFromSequence(overrideDelay:Number = NaN):void 
		{
			var params:Array;
			if (loopSequence == -1) {
				params = sequenceList.shift();
			}	
			else {
				params = sequenceList[loopSequence];
				loopSequence++;
				if (loopSequence >= sequenceList.length)
					loopSequence = 0;
			}
			
			if(params)
				showText(params[0], params[1], params[2], true, sequenceChangeTime, isNaN(overrideDelay) ? sequenceShowTime : overrideDelay, showNextFromSequence);
		}
		
		public function refreshTextGlow():void 
		{
			if (indicatorTextField.text != '') {
				textGlow.visible = true;
				textGlow.x = indicatorTextField.x;
				textGlow.width = (indicatorTextField.textBounds.width + 66*pxScale) * indicatorTextField.scale;
				textGlow.y = indicatorTextField.y;
				textGlow.height = (indicatorTextField.textBounds.height + 50*pxScale) * indicatorTextField.scale;
				//textGlow.scale = ;
			}
			else {
				textGlow.visible = false;
			}
		}
		
		public function get defaultMessage():String
		{
			return 'GOOD LUCK!';
		}
		
		public function cashLabelSetter(value:int):void 
		{
			changeText('$ ' + value.toString(), indicatorTextField.format.color, indicatorTextField.format.size);
			refreshTextGlow();
		}
		
		public function labelSetter(value:int):void 
		{
			changeText(value.toString(), indicatorTextField.format.color, indicatorTextField.format.size);
			refreshTextGlow();
		}
		
		/******************************************************************************************************************************************
		* 
		* CONCRETE EFFECTS:
		* 
		******************************************************************************************************************************************/
		
		public function showSpin():void 
		{
			showText('', defaultColor, defaultTextSize, false, 0.5, 0, showSpinTextAnimation);
		}
		
		private function showSpinTextAnimation():void 
		{
			showTextSequence(['/', '-', "\\", '|'], 
					[0x00DD00, 0x00DD00, 0x00DD00, 0x00DD00],
					[70, 70, 70, 70], 
					0, 0.04, 0.01, true);
		}
		
		public function showIdleMessage(explicit:Boolean = false):void 
		{
			if (indicatorTextField.text == defaultMessage && !explicit)
				return;
				
			showText('', defaultColor, defaultTextSize, false, 0.1, 0, completeShowRegular);
		}
		
		private function completeShowRegular():void 
		{
			showText(defaultMessage, defaultColor, defaultTextSize, false, 0.5, 0);
		}
		
		/*зачистка всех твинов всей цепочки*/
		public function cleanTweens():void 
		{
			Starling.juggler.removeByID(animateIntHelperId);
			
			Starling.juggler.removeTweens(indicatorTextField);
			
			DelayCallUtils.cleanBundle(DELAY_CALL_BUNDLE);
			
			SoundManager.instance.stopSfxLoop(SoundAsset.SlotsWinJingle, 0.1);
			
			var displayObject:DisplayObject;
			while (temporaryDisplayObjects.length > 0)  
			{
				displayObject = temporaryDisplayObjects.shift() as DisplayObject;
				Starling.juggler.removeTweens(displayObject);
				displayObject.removeFromParent();
			}
		}
		
		/******************************************************************************************************************************************
		* 
		* MEGA WIN:
		* 
		******************************************************************************************************************************************/
		
		private var megaWinDefaultColor:uint;
		private var megaWinFirstPhrase:String;
		private var megaWinFirstPhraseSize:int;
		private var megaWinStarShowsCounter:int;
		private var megaWinMaxStarCount:int;
		private var megaWinCompleteFunction:Function;
		
		private var megaWinRewardCashValue:int;
		private var megaWinTotalCashValue:int;
		//private var megaWinTotalCashValue:int;
		
		private var megaWinCommonPhrase_1:String;
		private var megaWinCommonPhrase_2:String;
		
		public function showCashMegaWin(rewardCash:int, totalCash:int, starsTotalShows:int = 2):void 
		{
			cleanTweens();
			
			megaWinFirstPhraseSize = 65*pxScale;
			megaWinFirstPhrase = 'BIG WIN!';
			megaWinDefaultColor = COLOR_GREEN;
			megaWinCompleteFunction = megaWinCashCompleteFunction;
			
			megaWinRewardCashValue = rewardCash;
			megaWinTotalCashValue = totalCash;
			
			megaWinStarShowsCounter = 0;
			megaWinMaxStarCount = starsTotalShows;
			
			showText('', megaWinDefaultColor, defaultTextSize, false, 0.1, 0, showWinStar);
		}
		
		public function showCommonMegaWin(firstPhrase:String, firstPhraseSize:int, defaultColor:uint, starsTotalShows:int, commonPhrase_1:String, commonPhrase_2:String = null):void 
		{
			cleanTweens();
			
			megaWinFirstPhrase = firstPhrase;
			megaWinFirstPhraseSize = firstPhraseSize;
			megaWinDefaultColor = defaultColor;
			megaWinCompleteFunction = megaWinCommonCompleteFunction;
			
			megaWinCommonPhrase_1 = commonPhrase_1;
			megaWinCommonPhrase_2 = commonPhrase_2;
			
			megaWinStarShowsCounter = 0;
			megaWinMaxStarCount = starsTotalShows;
			
			showText('', megaWinDefaultColor, defaultTextSize, false, 0.1, 0, showWinStar);
		}
		
		private function showWinStar():void 
		{
			var ball:Image = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/ball_glow'));
			ball.alignPivot();
			ball.x = BG_WIDTH;
			ball.y = BG_HEIGHT/2;
			ball.color = megaWinDefaultColor;
			ball.scaleX = 0;
			addChildAt(ball, getChildIndex(textGlow));
			temporaryDisplayObjects.push(ball);
			
			TweenHelper.tween(ball, 0.15, {scaleX:1, scaleY:1, x:BG_WIDTH/2, onStart:scaleSetter, onStartArgs:[ball, 4, 0.7], transition:Transitions.LINEAR, onComplete:removeView, onCompleteArgs:[ball]})
			
			ball = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/ball_glow'));
			ball.alignPivot();
			ball.x = 0;
			ball.y = BG_HEIGHT/2;
			ball.color = megaWinDefaultColor;
			ball.scaleX = 0;
			addChildAt(ball, getChildIndex(textGlow));
			temporaryDisplayObjects.push(ball);
			
			TweenHelper.tween(ball, 0.18, {scaleX:1, scaleY:1, x:BG_WIDTH / 2, onStart:scaleSetter, onStartArgs:[ball, 4, 0.7], transition:Transitions.LINEAR, onComplete:removeView, onCompleteArgs:[ball]})//.	
			
			var star:Image = new Image(AtlasAsset.ScratchCardAtlas.getTexture('slots/star_contour'));
			star.alignPivot();
			star.x = BG_WIDTH/2;
			star.y = BG_HEIGHT/2;
			star.color = megaWinDefaultColor;
			star.scale = 0;
			addChildAt(star, getChildIndex(textGlow));
			
			temporaryDisplayObjects.push(star);
				
			TweenHelper.tween(star, 0.03, {delay:0.15, scale:BG_HEIGHT / star.texture.frameHeight, onStart:scaleSetter, onStartArgs:[star, 0, 0], transition:Transitions.LINEAR}).
				chain(star, 0.29, {scale:6.5, onStart:scaleSetter, onStartArgs:[star, BG_HEIGHT/star.texture.frameHeight, BG_HEIGHT/star.texture.frameHeight], transition:Transitions.LINEAR}).
				chain(star, 0.07, {alpha:0, scale:8.5, onComplete:removeView, onCompleteArgs:[star]});
			
			Starling.juggler.removeTweens(indicatorTextField);	
			changeText(megaWinFirstPhrase, megaWinDefaultColor, megaWinFirstPhraseSize);
			indicatorTextField.scale = 0;
			Starling.juggler.tween(indicatorTextField, 0.3, {delay:0.14, scale:1.0, onUpdate:refreshTextGlow});
			
			if (megaWinStarShowsCounter >= megaWinMaxStarCount) 
			{
				if(megaWinCompleteFunction != null)
					megaWinCompleteFunction();
			}
			else {
				megaWinStarShowsCounter++;
				DelayCallUtils.add(Starling.juggler.delayCall(showText, 0.4, '', megaWinDefaultColor, defaultTextSize, false, 0.5, 0, showWinStar), DELAY_CALL_BUNDLE);
			}
		}
		
		private function megaWinCashCompleteFunction():void 
		{
			showText('$0', COLOR_PURPLE, defaultTextSize, false, 0.2, 0.7, null, null, false);
			
			var animateTime:Number = SlotMachineRewardType.getCashAnimateDuration(megaWinRewardCashValue)//Math.min(megaWinRewardCashValue/12.5, 5);
			animateIntHelperId = EffectsManager.animateIntHelper(0, megaWinRewardCashValue, cashLabelSetter, animateTime, 0.92);
			
			showText('CASH: $'+megaWinTotalCashValue, COLOR_PURPLE, defaultTextSize, false, 0.2, 1.7 + animateTime/*1.8*/, null, null, false);
			
			DelayCallUtils.add(Starling.juggler.delayCall(SoundManager.instance.playSfxLoop, 0.92, SoundAsset.SlotsWinJingle, 12.0, 0.6, 0.05, 0.6), DELAY_CALL_BUNDLE);
			DelayCallUtils.add(Starling.juggler.delayCall(completeMegaWinCashSounds, 0.92 + animateTime - 0.08), DELAY_CALL_BUNDLE);
			//SoundManager.instance.playSfxLoop(SoundAsset.SlotsWinJingle, 12.5, 0.05, 0.05, 1.0);
			
			//DelayCallUtils.add(Starling.juggler.delayCall(showRegular, 2.9), DELAY_CALL_BUNDLE);
		}
		
		private function megaWinCommonCompleteFunction():void 
		{
			if (megaWinCommonPhrase_1)
				showText(megaWinCommonPhrase_1, megaWinDefaultColor, defaultTextSize, false, 0.2, 0.7, null, null, false);
			
			if (megaWinCommonPhrase_2) {
				showText(megaWinCommonPhrase_2, megaWinDefaultColor, defaultTextSize, false, 0.2, 1.8, null, null, false);
				//DelayCallUtils.add(Starling.juggler.delayCall(showRegular, 2.4), DELAY_CALL_BUNDLE);
			}
			else {
				//DelayCallUtils.add(Starling.juggler.delayCall(showRegular, 1.9), DELAY_CALL_BUNDLE);
			}
		}
		
		private function completeMegaWinCashSounds():void 
		{
			SoundManager.instance.stopSfxLoop(SoundAsset.SlotsWinJingle, 0.1);
			SoundManager.instance.playSfx(SoundAsset.SlotsWinCompleted, 0.1);
		}
		
		/******************************************************************************************************************************************
		* 
		* TWEEN TOTAL STRING
		* 
		******************************************************************************************************************************************/
		
		private var tweenedTotalText:String;
		private var tweenedTotalFinishText:String;
		private var tweenedTotalTextVelocity:int;
		
		public function showTotalText(text:String, finishText:String, delay:Number, velocity:int = 380):void 
		{
			tweenedTotalText = text;
			tweenedTotalFinishText = finishText;
			tweenedTotalTextVelocity = velocity;
			
			cleanTweens();
			
			showText('', defaultColor, defaultTextSize, false, 0.1, delay, completeShowTotalText);
		}
		
		private function completeShowTotalText():void 
		{
			indicatorTextField.scale = 1;
			changeText(tweenedTotalText, COLOR_GREEN, defaultTextSize);
			indicatorTextField.x = BG_WIDTH + indicatorTextField.pivotX;// + (BG_WIDTH - indicatorTextField.width)/2;
			var finishX:int = -indicatorTextField.width / indicatorTextField.scaleX + indicatorTextField.pivotX;
			Starling.juggler.tween(indicatorTextField, ((indicatorTextField.x - finishX)/pxScale)/tweenedTotalTextVelocity, {x:( -indicatorTextField.width / indicatorTextField.scaleX + indicatorTextField.pivotX), onUpdate:refreshTextGlow, onComplete:showText, onCompleteArgs:[tweenedTotalFinishText, COLOR_PURPLE, defaultTextSize, false, 0.1]});
		}
		
		/******************************************************************************************************************************************
		* 
		* 
		* 
		******************************************************************************************************************************************/
		
		public function changeDefaultColor(color:uint):void 
		{
			Starling.juggler.delayCall(completeChangeDefaultColor, 0.1, color);
			showText('', defaultColor, defaultTextSize, false, 0.1, 0); 
		}
		
		private function completeChangeDefaultColor(color:uint):void 
		{
			defaultColor = color;
			completeShowRegular();
		}
		
		private function defaultColorSetter(color:uint):void 
		{
			defaultColor = color;
		}
		
		/******************************************************************************************************************************************
		* 
		* 
		* 
		******************************************************************************************************************************************/
			
		public function showCashWin(fromValue:int, toValue:int, color:uint, size:int, widthDollarPrefix:Boolean = false):void 
		{
			Starling.juggler.removeTweens(indicatorTextField);
			
			
			/*showText('', indicatorTextField.format.color, defaultTextSize, false, 0.1, 0, sequence_1);
			
			function sequence_1():void {
				Starling.juggler.removeTweens(indicatorTextField);	
				changeText('BIG WIN!', color, size);
				indicatorTextField.scale = 0;
				TweenHelper.tween(indicatorTextField, 0.3, {delay:0.05, scale:1.0, transition:Transitions.EASE_OUT_BACK, onUpdate:refreshTextGlow, onComplete:sequence_2});
			}
			
			function sequence_2():void 
			{
				var time:Number = Math.min(1.5, Math.max(0.6, Math.abs(toValue - fromValue) / 16));
				
				EffectsManager.animateIntHelper(fromValue, toValue, widthDollarPrefix ? cashLabelSetter : labelSetter, time);
				Starling.juggler.delayCall(showRegular, time + 1.3);
			}*/
		}
		
		/******************************************************************************************************************************************
		* 
		* 
		* 
		******************************************************************************************************************************************/
			
		/*public function showWinValue(fromValue:int, toValue:int, color:uint, size:int, widthDollarPrefix:Boolean = false):void 
		{
			Starling.juggler.removeTweens(indicatorTextField);
			showText('', indicatorTextField.format.color, defaultTextSize, false, 0.1, 0, sequence_1);
			
			function sequence_1():void {
				Starling.juggler.removeTweens(indicatorTextField);	
				changeText('YOU WIN!', color, size);
				indicatorTextField.scale = 0;
				TweenHelper.tween(indicatorTextField, 0.3, {delay:0.05, scale:1.0, transition:Transitions.EASE_OUT_BACK, onUpdate:refreshTextGlow, onComplete:sequence_2});
			}
			
			function sequence_2():void 
			{
				var time:Number = Math.min(1.5, Math.max(0.6, Math.abs(toValue - fromValue) / 16));
				
				EffectsManager.animateIntHelper(fromValue, toValue, widthDollarPrefix ? cashLabelSetter : labelSetter, time);
				Starling.juggler.delayCall(showRegular, time + 1.3);
			}
		}*/
		
		/******************************************************************************************************************************************
		* 
		* 
		* 
		******************************************************************************************************************************************/
			
		/*public function showWinText(text:String, color:uint, size:int):void 
		{
			Starling.juggler.removeTweens(indicatorTextField);
			showText('', indicatorTextField.format.color, defaultTextSize, false, 0.1, 0, sequence_1);
			
			function sequence_1():void {
				Starling.juggler.removeTweens(indicatorTextField);	
				changeText(text, color, size);
				indicatorTextField.scale = 0;
				TweenHelper.tween(indicatorTextField, 0.3, {delay:0.05, scale:1.0, transition:Transitions.EASE_OUT_BACK, onUpdate:refreshTextGlow, onComplete:sequence_2});
			}
			
			function sequence_2():void 
			{
				Starling.juggler.delayCall(showRegular, 1.6);
			}
		}*/
		
		
		/******************************************************************************************************************************************
		* 
		* 
		* 
		******************************************************************************************************************************************/
		
		private function removeView(view:DisplayObject):void {
			view.removeFromParent();
			
			var index:int = temporaryDisplayObjects.indexOf(view);
			if (index != -1)
				temporaryDisplayObjects.removeAt(index);
		}
		
		private function scaleSetter(view:DisplayObject, scaleX:Number, scaleY:Number):void {
			view.scaleX = scaleX;
			view.scaleY = scaleY;
		}
		
	}
	
	

}