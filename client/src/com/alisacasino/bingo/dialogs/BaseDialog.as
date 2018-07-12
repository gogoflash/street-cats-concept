package com.alisacasino.bingo.dialogs
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.controls.ImageAssetContainer;
	import com.alisacasino.bingo.controls.StarTitle;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.resize.IResizable;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.disposal.DisposalUtils;
	import com.alisacasino.bingo.utils.layoutHelperClasses.LayoutHelper;
	import feathers.core.FeathersControl;
	import flash.geom.Rectangle;
	import starling.animation.Tween;
	import starling.display.DisplayObject;
	import starling.utils.Align;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class BaseDialog extends FeathersControl implements IDialog
	{
		protected var heightBound:Number = 720 * pxScale;
		protected var widthBound:Number = 1280 * pxScale;
		
		public static const DIALOG_CLOSED_EVENT:String = "DialogClosedEvent";
		public static const DIALOG_OK_EVENT:String = "DialogOkEvent";
		public static const DIALOG_CANCEL_EVENT:String = "DialogCancelEvent";
		public static const DIALOG_REMOVED_EVENT:String = "dialogRemovedEvent";
		
		protected var background:Image;
		protected var backImage:Image;
		protected var starTitle:StarTitle;
		protected var closeButton:XButton;
		protected var bottomButton:XButton;
		
		protected var isShowing:Boolean = true;
		protected var isHiding:Boolean;
		
		protected var _dialogProperties:DialogProperties;
		protected var fadeList:Array = [];
		protected var _fadeListAlpha:Number = 0;
		
		protected var backImageRelativeY:Number = 0;
		protected var backImageRelativeHeight:Number = 0;
		protected var backImageAlpha:Number = 0.1;
		
		protected var bottomButtonRelativeY:Number = 0.9;
		
		public function BaseDialog(dialogProperties:DialogProperties = null)
		{
			_dialogProperties = dialogProperties || DialogProperties.EMPTY;
		}
		
		public function get fadeStrength():Number {
			return _dialogProperties.fadeStrength;
		}
		
		public function get blockerFade():Boolean {
			return _dialogProperties.blockerFade;
		}
		
		public function get fadeClosable():Boolean {
			return _dialogProperties.fadeClosable;
		}
		
		public function get align():String {
			return Align.CENTER;
		}
		
		public function get dialogProperties():DialogProperties 
		{
			return _dialogProperties;
		}
		
		protected function get bottomButtonStyle():XButtonStyle {
			return AtlasAsset.CommonAtlas.loaded ? XButtonStyle.DialogBigGreenButtonStyle : XButtonStyle.LoadAtlasDialogBigGreen;
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			background = new Image(AtlasAsset.LoadingAtlas.getTexture("dialogs/window_bg"));
			background.scale9Grid = ResizeUtils.getScaledRect(10, 1, 2, 2);
			background.pivotX = background.texture.frameWidth / 2 - background.pivotX;
			background.alpha = 1;
			background.width = 0;
			addChildAt(background, 0);
			
			if (dialogTitle) {
				starTitle = new StarTitle(dialogTitle, dialogProperties.starTitleTextStyle, 8, 0, -4, starTitleActivateCallback);
				starTitle.alignPivot();
				addChild(starTitle);
				addToFadeList(starTitle, 0);
			}

			if (dialogProperties.hasCloseButton) {
				closeButton = new XButton(XButtonStyle.DialogCloseButtonStyle);
				closeButton.alignPivot();
				closeButton.addEventListener(Event.TRIGGERED, handler_closeButton);
				closeButton.scale = 0;
				addChild(closeButton);
			}
			
			if (bottomButtonTitle) {
				bottomButton = new XButton(bottomButtonStyle, bottomButtonTitle, bottomButtonTitle);
				bottomButton.addEventListener(Event.TRIGGERED, handler_bottomButton);
				bottomButton.alignPivot();
				addChild(bottomButton);
				addToFadeList(bottomButton, 0);
			}
			setSizeInternal(dialogProperties.expectWidth == 0 ? background.texture.nativeWidth : dialogProperties.expectWidth * pxScale, dialogProperties.expectHeight == 0 ? 720 * pxScale : dialogProperties.expectHeight, false);
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_SIZE)) 
				resize();
				
			tweenAppear();
		}
		
		public function resize():void
		{
			var _backgroundWidth:int = backgroundWidth;
			
			background.width = isShowing ? 0 : _backgroundWidth;
			background.height = heightBound;
			background.x = _backgroundWidth / 2;
			background.y = (actualHeight - heightBound) / 2;
			
			if (backImage) {
				backImage.width = isShowing ? 0 : backImageWidth;
				backImage.x = _backgroundWidth / 2;
				
				if (_dialogProperties.autoCenteringContent) {
					correctBackImageHeight(1.182, true);
					backImage.y = (background.height - backImage.height) / 2 + background.y;
				}
				else {
					backImage.height = actualHeight * backImageRelativeHeight;
					backImage.y = actualHeight * backImageRelativeY;
				}
			}
			
			alignStarTitle();

			if (closeButton) {
				closeButton.x = _backgroundWidth + closeButton.pivotX + 8*pxScale;
				if (_dialogProperties.autoCenteringContent && starTitle)
					closeButton.y = starTitle.y;
				else
					closeButton.y = actualHeight * 0.057;
			}
			
			if (bottomButton) {
				bottomButton.x = _backgroundWidth / 2;
				if (_dialogProperties.autoCenteringContent) {
					var backImageBottomY:Number = backImage ? (backImage.y + backImage.height) : (background.y + background.height);
					bottomButton.y = backImageBottomY + (background.y + background.height - backImageBottomY - bottomButton.height)/2 + bottomButton.pivotY + 3*pxScale;
				}
				else {
					bottomButton.y = actualHeight * bottomButtonRelativeY;
				}
				//bottomButton.enabled = false;
			}
		}
		
		private function alignStarTitle():void
		{
			if (starTitle) {
				starTitle.x = backgroundWidth / 2;
				if (_dialogProperties.autoCenteringContent)
					starTitle.y = ((backImage ? backImage.y : 0) - background.y - starTitle.height)/2 + starTitle.pivotY + background.y;
				else
					starTitle.y = actualHeight * _dialogProperties.starTitleRelativeY;
			}
		}
		
		protected function tweenAppear():void
		{
			if (!isShowing)
				return;
			
			playAppearSound();	
				
			isShowing = false;
			
			var tweenBg_0:Tween = new Tween(background, 0.2, Transitions.EASE_IN);
			var tweenBg_1:Tween = new Tween(background, 0.5, Transitions.EASE_OUT_BACK);
			
			tweenBg_0.delay = 0.1;
			tweenBg_0.animate('width', gameManager.layoutHelper.stageWidth);
			tweenBg_0.animate('alpha', 5);
			tweenBg_0.nextTween = tweenBg_1;
			
			tweenBg_1.animate('width', backgroundWidth);
			
			Starling.juggler.add(tweenBg_0);
			
			if (backImage) {
				var tweenBack_0:Tween = new Tween(backImage, 0.2, Transitions.EASE_IN);
				var tweenBack_1:Tween = new Tween(backImage, 0.5, Transitions.EASE_OUT_BACK);
				
				tweenBack_0.delay = 0.1;
				tweenBack_0.animate('width', backgroundWidth);
				tweenBack_0.animate('alpha', backImageAlpha);
				tweenBack_0.nextTween = tweenBack_1;
				
				tweenBack_1.animate('width', backImageWidth);
				
				Starling.juggler.add(tweenBack_0);
			}
			
			if (closeButton) {
				var tweenCloseButton_0:Tween = new Tween(closeButton, 0.2, Transitions.EASE_IN);
				var tweenCloseButton_1:Tween = new Tween(closeButton, 0.5, Transitions.EASE_OUT_BACK);
				
				tweenCloseButton_0.delay = 0.1;
				tweenCloseButton_0.animate('scale', 2);
				tweenCloseButton_0.nextTween = tweenCloseButton_1;
				
				tweenCloseButton_1.animate('scale', 1);
				
				Starling.juggler.add(tweenCloseButton_0);
			}
			
			Starling.juggler.tween(this, 0.1, {delay:0.2, fadeListAlpha:1, transition:Transitions.EASE_IN});
		}
		
		protected function tweenHide():void
		{
			if (isHiding)
				return;	
				
			isHiding = true;
			
			if (background) {
				Starling.juggler.removeTweens(background);
				Starling.juggler.tween(background, 0.25, {transition:Transitions.EASE_IN_BACK, scaleX:0, delay:0.0});
			}
			
			if (backImage) {
				Starling.juggler.removeTweens(backImage);
				Starling.juggler.tween(backImage, 0.17, {transition:Transitions.EASE_IN_BACK, scaleX:0, delay:0.0});
			}
			
			if (closeButton) {
				Starling.juggler.removeTweens(closeButton);
				Starling.juggler.tween(closeButton, 0.25, {transition:Transitions.EASE_IN_BACK, scale:0, delay:0.0});
			}
			
			Starling.juggler.removeTweens(this);
			Starling.juggler.tween(this, 0.15, {delay:0.0, fadeListAlpha:0, transition:Transitions.EASE_IN});	
				
			Starling.juggler.delayCall(removeDialog, 0.26);
		}
		
		protected function handler_closeButton(e:Event):void
		{
			close();
		}
		
		public function close():void
		{
			dispatchEventWith(DIALOG_CLOSED_EVENT);
			tweenHide();
		}	
		
		
		public function setWidthBound(widthBound:Number):void 
		{
			this.widthBound = widthBound;
			invalidate(INVALIDATION_FLAG_SIZE);
		}
		
		public function setHeightBound(heightBound:Number):void 
		{
			this.heightBound = heightBound;
			invalidate(INVALIDATION_FLAG_SIZE);
		}
		
		/* INTERFACE com.alisacasino.bingo.dialogs.IDialog */
		
		public function get selfScaled():Boolean 
		{
			return false;
		}
		
		public function get baseScale():Number
		{
			return layoutHelper.independentScaleFromEtalonMin;
		}
		
		protected function removeDialog():void 
		{
			if (starTitle)
				starTitle.dispose();
				
			removeFromParent();
			//DisposalUtils.destroy(this);
			dispatchEventWith(DIALOG_REMOVED_EVENT);
		}
		
		protected function handler_bottomButton(e:Event):void
		{
			dispatchEventWith(DIALOG_OK_EVENT);
			close();
		}
		
		/**
		 * @param relativeY:Number - коэффициент положения Y. Реальное положение будет вычислено: background.y + background.height * relativeY;
		 * @param relativeHeight:Number - коэффициент размера height. Реальный размер будет вычислен: background.height * relativeHeight; 
		 **/
		protected function addBackImage(relativeY:Number, relativeHeight:Number, alpha:Number):void
		{
			backImageRelativeY = relativeY;
			backImageRelativeHeight = relativeHeight;
			backImageAlpha = alpha;
			
			backImage = new Image(AtlasAsset.LoadingAtlas.getTexture("dialogs/back_bg"));
			backImage.scale9Grid = ResizeUtils.getScaledRect(15, 15, 2, 2);
			backImage.pivotX = backImage.texture.frameWidth / 2 - backImage.pivotX;
			backImage.alpha = 0;
			backImage.width = 0;
			
			if(background && contains(background))
				addChildAt(backImage, getChildIndex(background) + 1);
			else	
				addChild(backImage);
		}
		
		protected function addToFadeList(displayObject:DisplayObject, alpha:Number = 0):void
		{
			fadeList.push(displayObject);
			if (alpha != -1)
				displayObject.alpha = alpha;
		}
		
		public function set fadeListAlpha(value:Number):void {
			if (_fadeListAlpha == value)
				return;
			
			_fadeListAlpha = value;
			
			var i:int;
			var length:int = fadeList.length;
			for (i = 0; i < length; i++) {
				(fadeList[i] as  DisplayObject).alpha = _fadeListAlpha;
			}
		}
		
		public function get fadeListAlpha():Number {
			return _fadeListAlpha;
		}
		
		public function get backgroundWidth():int {
			return dialogProperties.expectWidth * pxScale;
		}
		
		public function get backImageWidth():int {
			return backgroundWidth - 46 * pxScale;
		}
		
		protected function playAppearSound():void {
			SoundManager.instance.playSfx(SoundAsset.RoundResultsPopup);
		}
		
		protected function get dialogTitle():String
		{
			return dialogProperties.title;
		}
		
		protected function get bottomButtonTitle():String
		{
			return dialogProperties.bottomButtonTitle;
		}
		
		protected function correctBackImageHeight(coefficient:Number = 1.182, setByOriginalAlпorithm:Boolean = false):void 
		{
			if (background.height / actualHeight > coefficient) 
				backImage.height = actualHeight * backImageRelativeHeight + (background.height - actualHeight*coefficient);
			else if(setByOriginalAlпorithm)
				backImage.height = actualHeight * backImageRelativeHeight;
		}
		
		private function starTitleActivateCallback():void {
			if (starTitle) {
				starTitle.alignPivot();
				alignStarTitle();
			}
		}
	}
}