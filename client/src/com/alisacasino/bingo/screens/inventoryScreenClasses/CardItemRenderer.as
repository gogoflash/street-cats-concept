package com.alisacasino.bingo.screens.inventoryScreenClasses 
{
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.ImageAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.components.CardSelectorView;
	import com.alisacasino.bingo.controls.FlipImageAssetContainer;
	import com.alisacasino.bingo.controls.ImageAssetContainer;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.FullscreenDialogBase;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import feathers.controls.BasicButton;
	import feathers.core.FeathersControl;
	import flash.geom.Point;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Sprite3D;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	import starling.utils.Align;
	import starling.utils.TweenHelper;
	
	public class CardItemRenderer extends FeathersControl
	{
		static public const EVENT_CARD_BURN:String = "EVENT_CARD_BURN";
		static public const APPEAR_ANIMATION_COMPLETE:String = "appearAnimationComplete";
		public static var WIDTH:int = 217;
		public static var HEIGHT:int = 259;
		public static var CARD_SCALE:Number = 0.85;
		
		protected var _index:int;
		protected var assetContainer:FlipImageAssetContainer;
		protected var placeholder:ImageAssetContainer;
		protected var countBackground:Image;
		protected var countLabel:XTextField;
		protected var loadingAnimation:AnimationContainer;
		protected var loadingCardBack:ImageAssetContainer;
		protected var comingSoonImage:Image;
		protected var placeholder3DSprite:Sprite3D;
		
		protected var burnAnimation:AnimationContainer;
		protected var burnMask:Quad;
		protected var grayBg:Image;
		
		public function CardItemRenderer() 
		{
			super();
			setSizeInternal(176 * pxScale, 214 * pxScale, false);
		}
		
		public function get index():int
		{
			return _index;
		}
		
		public function set index(value:int):void
		{
			_index = value;
		}
		
		protected function onImageLoaded():void 
		{
			launchAppearAnimation();
		}
		
		public function animateNew():void 
		{
			assetContainer.debugMode = true;
			assetContainer.forceAnimationOnSet = true;
			assetContainer.source = null;
			assetContainer.source = cardAsset;
			assetContainer.validate();
			if (cardAsset.loaded)
			{
				launchAppearAnimation();
				SoundManager.instance.playSfx(SoundAsset.CardShowV2, 0, 0, 1, 0, true);
			}
			else
			{
				hidePlaceholder();
				cardAsset.load(onImageLoaded, null);
			}
		}
		
		private function launchAppearAnimation():void 
		{
			hidePlaceholder();
			assetContainer.validate();
			TweenHelper.tween(assetContainer, 0.6, {scale: 1.2, transition: Transitions.EASE_OUT})
				.chain(assetContainer, 0.4, { scale: CARD_SCALE, transition: Transitions.EASE_OUT_BOUNCE, delay: 0.1, onComplete: onAppearAnimationComplete } );
			
			popCount();
		}
		
		private function onAppearAnimationComplete():void 
		{
			dispatchEventWith(APPEAR_ANIMATION_COMPLETE);
		}
		
		/*********************************************************************************************************************
		*
		*	For override 
		* 
		*********************************************************************************************************************/		
		
		public function get cardAsset():ImageAsset
		{
			return null;
		}
		
		public function get cardItem():ICardData
		{
			return null;
		}
		
		protected function get hasItem():Boolean
		{
			return false;
		}
		
		protected function get countBackgroundWidth():Number 
		{
			return 1;
		}
		
		protected function get burnAnimationContainer():DisplayObjectContainer {
			return null;
		}
		
		protected function get countLabelText():String {
			return '';
		}
		
		protected function get cardBackSource():Object {
			return null;
		}
		
		/*********************************************************************************************************************
		*
		*	
		* 
		*********************************************************************************************************************/		
		
		override protected function initialize():void 
		{
			super.initialize();
			
			placeholder3DSprite = new Sprite3D();
			addChild(placeholder3DSprite);
			
			placeholder = new ImageAssetContainer();
			placeholder.scale = CARD_SCALE;
			placeholder.setPivot(Align.CENTER, Align.CENTER);
			placeholder3DSprite.addChild(placeholder);
			
			assetContainer = new FlipImageAssetContainer(/*SoundAsset.CardShowV2*/);
			//assetContainer.forceAnimationOnSet = true;
			assetContainer.scale = CARD_SCALE;
			
			
			var loadingSkin:Sprite = new Sprite();
			var invisQuad:Quad = new Quad(WIDTH * pxScale, HEIGHT * pxScale, 0x0);
			invisQuad.alpha = 0;
			loadingSkin.addChild(invisQuad);
			loadingCardBack = new ImageAssetContainer();
			loadingSkin.addChild(loadingCardBack);
			loadingAnimation = new AnimationContainer(MovieClipAsset.PackBase);
            loadingAnimation.move(64 * pxScale, 84 * pxScale);
			loadingSkin.addChild(loadingAnimation);
			assetContainer.loadingSkin = loadingSkin;
			
			countBackground = new Image(null);
			countBackground.scale9Grid = ResizeUtils.getScaledRect(15, 0, 1, 0);
			countBackground.width = 68 * pxScale;
			countBackground.y = 128 * pxScale;
			addChild(countBackground);
			
			countLabel = new XTextField(50 * pxScale, 33 * pxScale, XTextFieldStyle.InventoryRendererCount);
			countLabel.autoScale = true;
			countLabel.y = 129 * pxScale;
			countLabel.format.kerning = -2;
			addChild(countLabel);
			
			assetContainer.setPivot(Align.CENTER, Align.CENTER);
			addChild(assetContainer);
			
			var overlayButton:BasicButton = new BasicButton();
			var overlayQuad:Quad = new Quad(200 * pxScale, 220 * pxScale);
			overlayQuad.alpha = 0;
			overlayButton.defaultSkin = overlayQuad;
			overlayButton.x = -100 * pxScale;
			overlayButton.y = -110 * pxScale;
			addChild(overlayButton);
			overlayButton.addEventListener(Event.TRIGGERED, overlayButton_triggeredHandler);
		}
		
		protected function overlayButton_triggeredHandler(e:Event):void 
		{
			if (hasItem)
			{
				dispatchEventWith(Event.TRIGGERED);
			}
			else if (cardItem)
			{
				SoundManager.instance.playSfx(SoundAsset.CardShutter, 0, 0, 0.5, 0, false);
				
				Starling.juggler.removeTweens(placeholder3DSprite);
				if (placeholder3DSprite.rotationY != 0)
				{
					placeholder3DSprite.rotationY += Math.PI / 12;
				}
				TweenHelper.tween(placeholder3DSprite, 0.15, { rotationY:Math.PI / 12, transition:Transitions.EASE_OUT } )
					.chain(placeholder3DSprite, 0.2, { rotationY:-Math.PI/24, transition:Transitions.EASE_IN_OUT} )
					.chain(placeholder3DSprite, 0.15, { rotationY:Math.PI/36, transition:Transitions.EASE_OUT} )
					.chain(placeholder3DSprite, 0.1, { rotationY:0, transition:Transitions.EASE_OUT } );
			}
		}
		
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				commitData();
			}
		}
		
		protected function commitData():void 
		{
			Starling.juggler.removeTweens(assetContainer);
			assetContainer.scale = CARD_SCALE;
			assetContainer.forceAnimationOnSet = false;
			
			if (!cardItem)
			{
				assetContainer.visible = false;
				placeholder.visible = false;
				countBackground.visible = countLabel.visible = false;
				return;
			}
			
			placeholder.source = cardBackSource;
			
			if (cardItem.comingSoon)
			{
				showPlaceholder();
				showComingSoon();
				return;
			}
			
			hideComingSoon();
			
			loadingCardBack.source = cardBackSource;
			loadingCardBack.validate();
			
			var loadAnimationNeeded:Boolean = false;
			
			if (cardItem.awaitBurn) 
			{
				cardItem.awaitBurn = false;
				showCardBurn(cardItem.quantity <= 0);
			}
			else
			{
				if (hasItem)
				{
					hidePlaceholder();
					assetContainer.source = null;
					assetContainer.source = cardAsset;
					
					if (!cardAsset.loaded)
					{
						loadAnimationNeeded = true;
					}
					
					countBackground.texture = AtlasAsset.CommonAtlas.getTexture("dialogs/collections/blue_badge");
					
					countBackground.alignPivot();
					countBackground.width = countBackgroundWidth;
					
					countLabel.scale = 1;
					countLabel.width = countBackground.width - 10 * pxScale;
					countLabel.alignPivot();
					
					countLabel.text = countLabelText;
				}
				else
				{
					showPlaceholder();
				}
			}
			
			if (loadAnimationNeeded)
			{
				loadingAnimation.playTimeline('loading_white', true, true, 24);
				loadingAnimation.goToAndPlay(1);
				loadingAnimation.visible = true;
				var darkenFilter:ColorMatrixFilter = new ColorMatrixFilter();
				darkenFilter.adjustBrightness( -0.5);
				darkenFilter.adjustContrast( -0.5);
				loadingCardBack.filter = darkenFilter;
			}
			else
			{
				loadingAnimation.visible = false;
				loadingCardBack.filter = null;
			}
			
			popCount(0.1 + index * 0.05);
		}
		
		private function popCount(delay:Number = 0):void 
		{
			Starling.juggler.removeTweens(countBackground);
			Starling.juggler.removeTweens(countLabel);
			//makePopTween(countBackground, delay, countBackground.texture.frameWidth);
			
			countBackground.width = 0;
			TweenHelper.tween(countBackground, 0.2, { delay: delay, width:(countBackgroundWidth + 16*pxScale), transition: Transitions.EASE_OUT } )
				.chain(countBackground, 0.15, { width: countBackgroundWidth, transition:Transitions.EASE_IN_CUBIC_OUT_BACK } );
			
			makePopTween(countLabel, delay);
		}
		
		protected function makePopTween(target:DisplayObject, delay:Number, scaleStart:Number = 1.2, scaleTarget:Number = 1):void
		{
			target.scale = 0;
			TweenHelper.tween(target, 0.2, { delay: delay, scale: scaleStart, transition: Transitions.EASE_OUT } )
				.chain(target, 0.15, { scale: scaleTarget, transition:Transitions.EASE_IN_CUBIC_OUT_BACK } );
		}
		
		private function hidePlaceholder():void 
		{
			placeholder.visible = false;
			assetContainer.visible = true;
			countBackground.visible = countLabel.visible = true;
		}
		
		public function showPlaceholder():void 
		{
			placeholder.visible = true;
			assetContainer.visible = false;
			countBackground.visible = countLabel.visible = false;
		}
		
		private function hideComingSoon():void 
		{
			if (comingSoonImage)
				comingSoonImage.removeFromParent();
		}
		
		private function showComingSoon():void 
		{
			if (!comingSoonImage)
			{
				comingSoonImage = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/collections/coming_soon_badge"));
				comingSoonImage.x = -28 * pxScale;
				comingSoonImage.y = -80 * pxScale;
			}
			placeholder3DSprite.addChild(comingSoonImage);
		}
		
		protected function showCardBurn(isLast:Boolean = false):void 
		{
			grayBg = new Image(AtlasAsset.CommonAtlas.getTexture('store/grey_background'));
			grayBg.scale9Grid = ResizeUtils.getScaledRect(24, 24, 1, 1);
			grayBg.color = 0x000000;
			grayBg.width = 180 * pxScale;
			grayBg.height = 218 * pxScale;
			grayBg.alpha = 0.15;
			addChildAt(grayBg, getChildIndex(assetContainer));
			grayBg.alignPivot();
			//grayBg.x = ;
			//grayBg.y = ;
			
			var burnMaskAngle:Number = 52 * Math.PI / 180 - Math.PI;
			var burnMaskDistance:Number = 300 * pxScale;
			var animationContainer:DisplayObjectContainer = burnAnimationContainer;
			if (!burnAnimation) 
			{
				burnAnimation = new AnimationContainer(MovieClipAsset.PackBase, false, true);
				burnAnimation.scale = (animationContainer is FullscreenDialogBase ? (animationContainer as FullscreenDialogBase).outerScale : 1) * (1/0.65);
				burnAnimation.dispatchOnCompleteTimeline = true;
				burnAnimation.addEventListener(Event.COMPLETE, handler_daubCardSplashAnimationComplete);
				
				burnMask = new Quad(300*pxScale, 300*pxScale);
				//burnMask.alpha = 0.6;
				burnMask.alignPivot();
				burnMask.rotation = burnMaskAngle;
				addChild(burnMask);
				
				assetContainer.mask = burnMask;
			}
			
			handler_enterFrame(null);
			burnAnimation.playTimeline('card_splash', true, false, 24);
			addEventListener(Event.ENTER_FRAME, handler_enterFrame);
			
			Starling.juggler.tween(burnMask, 0.84, {delay:0, x:Math.cos(burnMaskAngle) * burnMaskDistance, y:Math.sin(burnMaskAngle) * burnMaskDistance});
			
			placeholder.visible = false;
			
			dispatchEventWith(EVENT_CARD_BURN, true);
			
			countLabel.text = countLabelText;
			
			animationContainer.addChild(burnAnimation);
		}
		
		private function handler_enterFrame(event:Event):void 
		{
			if (burnAnimation) 
			{
				var globalPoint:Point = parent.localToGlobal(new Point(x, y));
				burnAnimation.x = globalPoint.x;
				burnAnimation.y = globalPoint.y;
			}
			else
			{
				removeEventListener(Event.ENTER_FRAME, handler_enterFrame);
			}
		}
		
		protected function handler_daubCardSplashAnimationComplete(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, handler_enterFrame);
			
			if (!burnAnimation)
				return;
			
			burnAnimation.removeEventListener(Event.COMPLETE, handler_daubCardSplashAnimationComplete);
			burnAnimation.stop();
			burnAnimation.removeFromParent();
			burnAnimation = null;
		
			assetContainer.mask = null;
			burnMask.removeFromParent(true);
			burnMask = null;
			
			if (hasItem)
			{
				assetContainer.visible = true;
				assetContainer.source = null;
				assetContainer.validate();
				assetContainer.setLoading();
				
				placeholder.visible = false;
			
				assetContainer.alpha = 0;
				
				TweenHelper.tween(assetContainer, 0.13, {scaleX:CARD_SCALE*1.35, scaleY:CARD_SCALE*1.35, alpha:1.4, transition: Transitions.EASE_OUT, onComplete:completeBurn})
							.chain(assetContainer, 0.18, {scaleX:CARD_SCALE, scaleY:CARD_SCALE, transition: Transitions.EASE_IN});
			}
			else
			{
				assetContainer.visible = true;
				assetContainer.source = null;
				assetContainer.validate();
				assetContainer.setLoading();
				
				countBackground.visible = countLabel.visible = false;
				placeholder.visible = false;
			
				assetContainer.alpha = 0;
				
				TweenHelper.tween(assetContainer, 0.18, {scaleX:CARD_SCALE*1.35, scaleY:CARD_SCALE*1.35, alpha:1.4, transition: Transitions.EASE_OUT, onComplete:removeGrayBg})
							.chain(assetContainer, 0.18, {scaleX:CARD_SCALE*1.25, scaleY:CARD_SCALE*0.85, transition: Transitions.EASE_IN})
							.chain(assetContainer, 0.5, { scale:CARD_SCALE, transition: Transitions.EASE_OUT_ELASTIC} );
			}
		}
		
		private function completeBurn():void 
		{
			assetContainer.forceAnimationOnSet = true;
			assetContainer.source = cardAsset;
			assetContainer.validate();
			
			removeGrayBg();
		}
		
		private function removeGrayBg():void 
		{
			if (grayBg) {
				grayBg.removeFromParent();
				grayBg = null;
			}
		}
		
	}

}