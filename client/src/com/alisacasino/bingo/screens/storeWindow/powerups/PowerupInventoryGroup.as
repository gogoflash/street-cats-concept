package com.alisacasino.bingo.screens.storeWindow.powerups 
{
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import feathers.controls.LayoutGroup;
	import feathers.core.FeathersControl;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.HorizontalLayout;
	import starling.animation.Transitions;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.Align;
	import starling.utils.TweenHelper;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class PowerupInventoryGroup extends FeathersControl
	{
		private var background:Image;
		private var contentBackground:Image;
		private var totalCountLabel:XTextField;
		
		
		protected var powerups:Vector.<String>;
		protected var backgroundTexture:Texture;
		protected var contentBackgroundTexture:Texture;
		protected var rarityIcon:Texture;
		protected var rarityText:String;
		protected var countTexture:Texture;
		protected var textColor:uint;
		
		private var iconsByPowerup:Object;
		private var rarityLabel:XTextField;
		private var iconsContainer:LayoutGroup;
		private var rarityImage:Image;
		
		public function PowerupInventoryGroup() 
		{
			iconsByPowerup = { };
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			background = new Image(backgroundTexture);
			background.scale9Grid = ResizeUtils.getScaledRect(18, 18, 2, 2);
			background.width = 370 * pxScale;
			background.height = 164* pxScale;
			addChild(background);
			
			contentBackground = new Image(contentBackgroundTexture);
			contentBackground.scale9Grid = ResizeUtils.getScaledRect(18, 18, 2, 2);
			contentBackground.x = 4 * pxScale;
			contentBackground.y = 54 * pxScale;
			contentBackground.width = background.width - contentBackground.x * 2;
			contentBackground.height = background.height - contentBackground.y - 4 * pxScale;
			addChild(contentBackground);
			
			rarityImage = new Image(rarityIcon);
			rarityImage.alignPivot();
			rarityImage.x = 9*pxScale + rarityImage.pivotX;
			rarityImage.y = -16 * pxScale + rarityImage.pivotY;
			addChild(rarityImage);
			
			iconsContainer = new LayoutGroup();
			iconsContainer.y = 62 * pxScale;
			iconsContainer.width = contentBackground.width;
			iconsContainer.height = 100 * pxScale;
			addChild(iconsContainer);
			
			var iconsLayout:HorizontalLayout = new HorizontalLayout();
			iconsLayout.horizontalAlign = HorizontalAlign.CENTER;
			iconsLayout.gap = 32*pxScale
			iconsContainer.layout = iconsLayout;
			
			var totalCount:int = 0;
			
			for (var i:int = 0; i < powerups.length; i++) 
			{
				var icon:PowerupIcon = new PowerupIcon(powerups[i], countTexture);
				iconsContainer.addChild(icon);
				
				iconsByPowerup[powerups[i]] = icon;
				
				icon.addEventListener(Event.CHANGE, icon_changeHandler);
				
				totalCount += gameManager.powerupModel.getPowerupCount(powerups[i]);
			}
			
			rarityLabel = new XTextField(background.width, 36 * pxScale, XTextFieldStyle.getWalrus(28, textColor), rarityText);
			rarityLabel.y = 10 * pxScale;
			addChild(rarityLabel);
			
			totalCountLabel = new XTextField(200 * pxScale, 36 * pxScale, XTextFieldStyle.getWalrus(28, textColor, Align.RIGHT), totalCount.toString());
			totalCountLabel.x = background.width - totalCountLabel.width - 10 * pxScale;
			totalCountLabel.y = 10 * pxScale;
			addChild(totalCountLabel);
			
			recountFromIcons();
		}
		
		public function animateAppearance(delay:Number):void 
		{
			if (!isInitialized)
				initializeNow();
				
			rarityLabel.alpha = 0;
			TweenHelper.tween(rarityLabel, 0.4, { delay: delay + 0.2, alpha:1, transition:Transitions.EASE_OUT } );
			
			totalCountLabel.alpha = 0;
			TweenHelper.tween(totalCountLabel, 0.4, { delay: delay + 0.2, alpha:1, transition:Transitions.EASE_OUT } );
			
			rarityImage.scale = 0;
			TweenHelper.tween(rarityImage, 0.1, { delay: delay, scale: 1.5, transition:Transitions.EASE_OUT } )
				.chain(rarityImage, 0.08, { scale: 1, transition:Transitions.EASE_OUT} );
			
			for (var i:int = 0; i < iconsContainer.numChildren; i++) 
			{
				var icon:PowerupIcon = iconsContainer.getChildAt(i) as PowerupIcon;
				if (icon)
				{
					icon.animateAppearance(delay + 0.1 + i * 0.04);
				}
			}
		}
		
		private function icon_changeHandler(e:Event):void 
		{
			recountFromIcons();
		}
		
		private function recountFromIcons():void 
		{
			var totalCount:int = 0;
			
			for each (var item:PowerupIcon in iconsByPowerup) 
			{
				totalCount += item.value;
			}
			
			totalCountLabel.text = totalCount.toString();
		}
		
		public function getIcon(powerup:String):PowerupIcon 
		{
			return iconsByPowerup[powerup];
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			var totalCount:int = 0;
			
			for (var i:int = 0; i < powerups.length; i++) 
			{
				totalCount += gameManager.powerupModel.getPowerupCount(powerups[i]);
			}
			
			totalCountLabel.text = totalCount.toString();
		}
		
	}

}