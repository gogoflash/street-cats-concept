package com.alisacasino.bingo.screens.inventoryScreenClasses 
{
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.controls.FlipImageAssetContainer;
	import com.alisacasino.bingo.controls.ImageAssetContainer;
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import feathers.core.FeathersControl;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Sprite3D;
	import starling.filters.ColorMatrixFilter;
	import starling.utils.Align;
	import starling.utils.TweenHelper;
	
	public class Card3DFlipView extends FeathersControl
	{
		static public const APPEAR_ANIMATION_COMPLETE:String = "appearAnimationComplete";
		public static var WIDTH:int = 217;
		public static var HEIGHT:int = 259;
		
		private var assetContainer:FlipImageAssetContainer;
		private var placeholder:ImageAssetContainer;
		private var loadingAnimation:AnimationContainer;
		private var loadingCardBack:ImageAssetContainer;
		private var placeholder3DSprite:Sprite3D;
		
		private var _item:CustomizerItemBase;
		
		public function Card3DFlipView() 
		{
			setSizeInternal(176 * pxScale, 214 * pxScale, false);
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			placeholder3DSprite = new Sprite3D();
			addChild(placeholder3DSprite);
			
			placeholder = new ImageAssetContainer();
			placeholder.scale = 0.85;
			placeholder.setPivot(Align.CENTER, Align.CENTER);
			placeholder3DSprite.addChild(placeholder);
			
			assetContainer = new FlipImageAssetContainer(/*SoundAsset.CardShowV2*/);
			//assetContainer.forceAnimationOnSet = true;
			assetContainer.scale = 0.85;
			
			var invisQuad:Quad = new Quad(WIDTH * pxScale, HEIGHT * pxScale, 0x0);
			invisQuad.alpha = 0;
			
			var loadingSkin:Sprite = new Sprite();
			loadingSkin.addChild(invisQuad);
			
			loadingCardBack = new ImageAssetContainer();
			loadingSkin.addChild(loadingCardBack);
			
			loadingAnimation = new AnimationContainer(MovieClipAsset.PackBase);
            loadingAnimation.move(64 * pxScale, 84 * pxScale);
			loadingSkin.addChild(loadingAnimation);
			assetContainer.loadingSkin = loadingSkin;
			
			assetContainer.setPivot(Align.CENTER, Align.CENTER);
			addChild(assetContainer);
		}	
		
		public function get item():CustomizerItemBase 
		{
			return _item;
		}
		
		public function set item(value:CustomizerItemBase):void 
		{
			if (_item != value)
			{
				if (_item && _item.uiAsset)
				{
					_item.uiAsset.removeCompleteCallback(onImageLoaded);
				}
				
				_item = value;
				//animateNew();
				invalidate(INVALIDATION_FLAG_DATA);
			}
			
		}
		
		private function onImageLoaded():void 
		{
			launchAppearAnimation();
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				Starling.juggler.removeTweens(assetContainer);
				assetContainer.scale = 0.85
				assetContainer.forceAnimationOnSet = false;
				
				if (!item)
				{
					assetContainer.visible = false;
					placeholder.visible = false;
					return;
				}
				
				placeholder.source = AtlasAsset.CommonAtlas.getTexture("dialogs/inventory_card_cover");
				
				loadingCardBack.source = AtlasAsset.CommonAtlas.getTexture("dialogs/inventory_card_cover");
				loadingCardBack.validate();
				
				var loadAnimationNeeded:Boolean = false;
				
				if (true/*item.quantity > 0*/)
				{
					hidePlaceholder();
					assetContainer.source = null;
					assetContainer.source = item.uiAsset;
					
					if (!item.uiAsset.loaded)
					{
						loadAnimationNeeded = true;
					}
				}
				else
				{
					showPlaceholder();
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
			}
		}
		
		public function showPlaceholder():void 
		{
			placeholder.visible = true;
			assetContainer.visible = false;
		}
		
		public function animateNew():void 
		{
			assetContainer.debugMode = true;
			assetContainer.forceAnimationOnSet = true;
			assetContainer.source = null;
			assetContainer.source = item.uiAsset;
			assetContainer.validate();
			if (item.uiAsset.loaded)
			{
				launchAppearAnimation();
				SoundManager.instance.playSfx(SoundAsset.CardShowV2, 0, 0, 1, 0, true);
			}
			else
			{
				hidePlaceholder();
				item.uiAsset.load(onImageLoaded, null);
			}
		}
		
		private function hidePlaceholder():void 
		{
			placeholder.visible = false;
			assetContainer.visible = true;
		}
		
		private function launchAppearAnimation():void 
		{
			hidePlaceholder();
			assetContainer.validate();
			TweenHelper.tween(assetContainer, 0.6, {scale: 1.2, transition: Transitions.EASE_OUT})
				.chain(assetContainer, 0.4, { scale: 0.85, transition: Transitions.EASE_OUT_BOUNCE, delay: 0.1, onComplete: onAppearAnimationComplete } );
		}
		
		private function onAppearAnimationComplete():void 
		{
		//	dispatchEventWith(APPEAR_ANIMATION_COMPLETE);
		}
	}

}