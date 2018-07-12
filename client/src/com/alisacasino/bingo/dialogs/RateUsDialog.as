package com.alisacasino.bingo.dialogs
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.RateDialogManager;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.RelativePixelMovingHelper;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import starling.animation.Transitions;
	import starling.display.MeshBatch;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Align;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.display.Image;
	
	import starling.events.Event;
	
	public class RateUsDialog extends BaseDialog
	{
		private var STARS_COUNT:int = 5;
		
		public static var MODE_RATE:uint = 0;
		public static var MODE_AFTER_RATE:uint = 1;
		
		private var mode:uint;
		private var currentStarsCount:int;
		private var starsList:Array;
		private var starStartX:int;
		private var starSlotSize:int;
		
		private var animationContainer:AnimationContainer;
		
		private var textField:XTextField;
		private var progressBarAwardIcon:Image;
		private var starsContainer:Sprite;
		private var starAnimation:AnimationContainer;
		private var starsTouchPoint:Point;
		
		private var startStarsEnabled:int;
		
		private var _playingTimeline:String;
		
		public function RateUsDialog(mode:uint = 0, startStarsEnabled:int = -1)
		{
			this.mode = mode;
			this.startStarsEnabled = startStarsEnabled;
			
			starsTouchPoint = new Point();
			
			super(DialogProperties.RATE_US_DIALOG);
			
			bottomButtonRelativeY = 0.92;
			
			dialogProperties.starTitleTextStyle.fontSize = 55;
		}
		
		override protected function initialize():void 
		{
			super.initialize();

			addBackImage(0.156, 0.68, 0.08);
				
			animationContainer = new AnimationContainer(MovieClipAsset.PackBase, true);
			animationContainer.scale = 0.87;
			animationContainer.validate();
			addChild(animationContainer);
			addToFadeList(animationContainer);
			
			//bottomButton.y = backImage.height - bottomButton.height * (gameManager.layoutHelper.isLargeScreen ? 0.8 : 0.9);
				
			textField = new XTextField(1, 1, XTextFieldStyle.getChateaudeGarage(36));
			textField.autoSize = TextFieldAutoSize.VERTICAL;
			textField.format.horizontalAlign = Align.CENTER;
			textField.format.leading = 28 * pxScale;
			textField.width = 420 * pxScale;
			textField.touchable = false;
			addToFadeList(textField);
			addChild(textField);
			//RelativePixelMovingHelper.add(textField, backImageWidth, backImage.height);
			
			var starSlot:Image = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/rate_star_slot"));
			var starSlotWidth:int = starSlot.texture.width + 15 * pxScale;
			starStartX = 40 * pxScale + (backImageWidth - starSlotWidth * STARS_COUNT) / 2;
			starSlotSize = (starSlotWidth * STARS_COUNT) / STARS_COUNT;
			
			starsContainer = new Sprite();
			addToFadeList(starsContainer);
			starsContainer.addEventListener(TouchEvent.TOUCH, onTouch);
			addChild(starsContainer);
			
			var touchQuad:Quad = new Quad(backImageWidth, starSlotWidth);
			touchQuad.alpha = 0;
			starsContainer.addChild(touchQuad);
				
			var starsQuadBatch:MeshBatch = new MeshBatch();
			starsContainer.addChild(starsQuadBatch);
			starsList = [];
				
			var star:Image;
			var i:int;
			for (i = 0; i < STARS_COUNT; i++ ) 
			{
				starSlot.x = starStartX + (starSlot.texture.width + (i != 0 ? 15 : 0)*pxScale) * i;
				starsQuadBatch.addMesh(starSlot);
				
				if (i == STARS_COUNT - 1)
					break;
					
				star = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/rate_star"));
				star.pivotX = star.width / 2;
				star.pivotY = star.height / 2;
				star.x = starSlot.x + star.pivotX;
				star.y = star.pivotY;
				
				star.alpha = 0;
				star.scale = 0;
				starsContainer.addChild(star);
				starsList.push(star);
			}
				
			starAnimation = new AnimationContainer(MovieClipAsset.PackBase, false, true);
			starAnimation.touchable = false;
			starAnimation.stop();
			starAnimation.visible = false;
			addChild(starAnimation);
			
			starAnimation.pivotX = 74*pxScale//starAnimation.width * pxScale / 2; 
			starAnimation.pivotY = 72*pxScale//starAnimation.height * pxScale / 2;
			//starAnimation.scale = 0.64;
			starAnimation.x = starStartX + starSlotWidth * (STARS_COUNT-1) + starAnimation.pivotX - 26 * pxScale// - starAnimation.width*0.29 * pxScale;
			addToFadeList(starAnimation);
				
			refresh();
			playStarsAnimation(startStarsEnabled);
			
			//trace(">>> ", Game.connectionManager.currentServerTime - RateDialogManager.instance.lastShowTimeStamp, RateDialogManager.instance.ratedStars);
			//trace( (RateDialogManager.instance.lastShowTimeStamp != 0 && (Game.connectionManager.currentServerTime - RateDialogManager.instance.lastShowTimeStamp < 10*1000)))
			//gameManager.clientDataManager.setValue("rateUsDialogShowTimestamp", Game.connectionManager.currentServerTime);
		}
		
		override public function resize():void
		{
			super.resize();
			
			starsContainer.y = backImage.y + backImage.height - 126*pxScale;
			starAnimation.y = starsContainer.y + starAnimation.pivotY - 88 * 0.29 * pxScale;
			
			textField.x = 332 * pxScale;
			textField.y = backImage.y + (backImage.height - textField.height - 130 * pxScale) / 2;
			
			animationContainer.x = 82 * pxScale;
			animationContainer.y = backImage.y + (starsContainer.y - backImage.y - animationContainer.height * pxScale)/2;
		}	
		
		override protected function handler_bottomButton(e:Event):void
		{
			dispatchEventWith(DIALOG_OK_EVENT);
		
			if (mode == MODE_AFTER_RATE) {
				close();
				return;
			}
			
			bottomButton.enabled = false;
			
			RateDialogManager.instance.rate(currentStarsCount);
			
			if (PlatformServices.isIOS)
			{
				openNativeRating();
				close();
				return;
			}
			
			mode = RateUsDialog.MODE_AFTER_RATE;
			refresh();
			
			if (currentStarsCount > getMinStarsByPlatform()) {
				openNativeRating();
			}
		}
		
		private function openNativeRating():void 
		{
			navigateToURL(new URLRequest(RateDialogManager.instance.getRateUsURL()));
		}
		
		private function getMinStarsByPlatform():int
		{
			if (PlatformServices.isIOS)
			{
				return 0;
			}
			return 3;
		}
			
		private function playStarsAnimation(count:int = -1):void
		{
			var i:int;
			var star:Image;
			count = count < 0 ? starsList.length : count;
			for (i = 0; i < count; i++ ) 
			{
				star = starsList[i];
				
				Starling.juggler.tween(star, 0.13, {
						transition: Transitions.EASE_OUT_BACK,
						onComplete: (i == starsList.length-1) ? function():void { 
							starAnimation.visible = true;
							starAnimation.playTimeline("star_pulse", true, false, 24);
							starAnimation.repeatCount = 3;
							starAnimation.addEventListener(Event.COMPLETE, handlers_starAnimationComplete);
							
						} : null,
						scale: 1,
						delay:i * 0.09 + 0.3,
						alpha: 1
					});
			}
		}
				
		private function handlers_starAnimationComplete(...a):void
		{
			starAnimation.removeEventListener(Event.COMPLETE, handlers_starAnimationComplete);
			
			var i:int;
			for (i = 0; i < starsList.length; i++ ) {
				Starling.juggler.tween(starsList[i], 0.2, { transition: Transitions.EASE_IN_BACK, scale: 0, alpha: 0});
			}
			
			Starling.juggler.tween(starAnimation, 0.2, {
						transition: Transitions.EASE_IN_BACK,
						onComplete: function():void { 
							starAnimation.visible = false;
							starAnimation.stop();
						}
					});
		}
		
		private function setStars(count:int):void
		{
			if (mode != MODE_RATE || currentStarsCount == count)
				return;
				
			SoundManager.instance.playMark();	
			
			currentStarsCount = count;
			
			bottomButton.visible = count > 0;
			
			removeStarAnimations();
			
			var i:int;
			var star:Image;
			for (i = 0; i < starsList.length; i++ ) {
				star = starsList[i];
				
				if (count > i) 
					Starling.juggler.tween(star, 0.1, {transition: Transitions.EASE_OUT_BACK, scale: 1, alpha: 1});
				else 
					Starling.juggler.tween(star, 0.1, {transition: Transitions.EASE_OUT, scale: 0, alpha: 0});
			}
			
			if (count >= STARS_COUNT) {
				Starling.juggler.removeTweens(starAnimation);
				starAnimation.repeatCount = 1;
				starAnimation.playTimeline("star_pulse", true, false, 24);
				starAnimation.visible = true;
				starAnimation.scale = 1.05;
				starAnimation.alpha = 1;
				//Starling.juggler.tween(starAnimation, 0.2, {transition: Transitions.EASE_IN_BACK});
				
				//playingTimeline = "RateHeart";
			}
			else {
				Starling.juggler.tween(starAnimation, 0.15, { transition: Transitions.EASE_OUT_BACK, onComplete: function():void { 
							starAnimation.visible = false;
							starAnimation.stop();
						},
						scale:0,
						alpha:0
					});
					
				//playingTimeline = "Rate";
			}
		}
		
		private function refresh():void
		{
			playingTimeline = mode == MODE_RATE ? "cat_rate" : "cat_rate_heart";
			
			if (mode == MODE_RATE) {
				bottomButton.text = Constants.RATE_US_DIALOG_BUTTON_SEND;
				bottomButton.disabledText = Constants.RATE_US_DIALOG_BUTTON_SEND;
				textField.text = Constants.RATE_US_DIALOG_BUBBLE_RATE;
				bottomButton.visible = currentStarsCount > 0;
			}
			else {
				bottomButton.text = Constants.RATE_US_DIALOG_BUTTON_OKAY;
				bottomButton.disabledText = Constants.RATE_US_DIALOG_BUTTON_OKAY;
				textField.text = Constants.RATE_US_DIALOG_BUBBLE_AFTER_RATE;
				bottomButton.enabled = true;
				bottomButton.visible = true;
			}
		}
			
		private function removeStarAnimations():void
		{
			starAnimation.removeEventListener(Event.COMPLETE, handlers_starAnimationComplete);
				
			var i:int;
			var star:Image;
			var count:int = starsList.length;
			for (i = 0; i < count; i++ ) {
				star = starsList[i];
				Starling.juggler.removeTweens(star);
			}
			
			//Starling.juggler.removeTweens(starAnimation);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(starsContainer);
			if (!touch)
				return;
				
			if (touch.phase == TouchPhase.BEGAN || touch.phase == TouchPhase.MOVED) {
				var rect:Rectangle = starsContainer.getBounds(starsContainer);	
				
				touch.getLocation(starsContainer, starsTouchPoint)
				
				var normalizedTouchX:Number = starsTouchPoint.x;
				
				var starCount:int = Math.floor((normalizedTouchX - starStartX) / starSlotSize) + 1;
				setStars(Math.min(Math.max(0, starCount), STARS_COUNT));
			}
		}
		
		private function set playingTimeline(value:String):void {
			if (_playingTimeline == value)
				return;
				
			_playingTimeline = value;	
			animationContainer.playTimeline(_playingTimeline, true, true, 25);	
		}
		
		private function debugDrawQuadCell(i:int, starSlotSize:int):void 
		{
			var quad:Quad = new Quad(1, 1, Math.random()*0xFF00FF);
			
			quad.alpha = 0.6;
			addChild(quad);
			quad.width = starSlotSize;
			quad.height = starSlotSize;
			quad.x = starsContainer.x + i * starSlotSize;
			quad.y = starsContainer.y;
			quad.touchable = false;
			
			setTimeout(function():void { quad.removeFromParent() }, 2000);
		}
	}	
}
