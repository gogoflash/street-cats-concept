package com.alisacasino.bingo.screens.storeWindow.chests 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.components.CardsIconView;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.chests.ChestDropCounts;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import feathers.controls.LayoutGroup;
	import feathers.core.FeathersControl;
	import feathers.layout.VerticalLayout;
	import starling.animation.Transitions;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.utils.TweenHelper;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DescriptionPanel extends FeathersControl
	{
		private var background:Image;
		private var contentBackground:Image;
		private var titleLabel:XTextField;
		private var itemsContainer:LayoutGroup;
		
		
		public function DescriptionPanel() 
		{
			width = 500 * pxScale;
			height = 552 * pxScale;
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			background = new Image(AtlasAsset.CommonAtlas.getTexture("store/dark_purple_background"));
			background.scale9Grid = ResizeUtils.getScaledRect(18, 18, 2, 2);
			background.width = width;
			background.height = height;
			addChild(background);
			
			contentBackground = new Image(AtlasAsset.CommonAtlas.getTexture("store/light_purple_background"));
			contentBackground.scale9Grid = ResizeUtils.getScaledRect(18, 18, 2, 2);
			contentBackground.x = 4 * pxScale;
			contentBackground.y = 54 * pxScale;
			contentBackground.width = background.width - contentBackground.x * 2;
			contentBackground.height = background.height - contentBackground.y - 4 * pxScale;
			addChild(contentBackground);
			
			titleLabel = new XTextField(background.width, 36 * pxScale, XTextFieldStyle.getWalrus(28, 0xf5f2ff), "INCLUDES:");
			titleLabel.y = 10 * pxScale;
			addChild(titleLabel);
			
			var hLayout:VerticalLayout = new VerticalLayout();
			hLayout.gap = 18 * pxScale;
			
			itemsContainer = new LayoutGroup();
			itemsContainer.x = 12 * pxScale;
			itemsContainer.y = 70 * pxScale;
			itemsContainer.layout = hLayout;
			addChild(itemsContainer);
			
			var chestDropCount:ChestDropCounts = gameManager.chestsData.getChestDropCount(ChestType.PREMIUM);
			
			
			var powerupIcon:Image = new Image(AtlasAsset.CommonAtlas.getTexture("powerup/icons/energy"));
			powerupIcon.scale = 0.85;
			var powerupContained:Sprite = new Sprite();
			powerupContained.addChild(powerupIcon);
			itemsContainer.addChild(new DescriptionItemRenderer(powerupContained, "<font color=\"#FFFC00\">" + chestDropCount.powerupsFromToString(true) + "</font>  <font color=\"#FFFFFF\">Powerups</font>"))
			
			var cashIcon:Image = new Image(AtlasAsset.CommonAtlas.getTexture("powerup/icons/cash"));
			cashIcon.scale = 0.9;
			var cashContained:Sprite = new Sprite();
			cashContained.addChild(cashIcon);
			itemsContainer.addChild(new DescriptionItemRenderer(cashContained, "<font color=\"#FFFC00\">" + chestDropCount.cashFromToString(true) + "</font>  <font color=\"#FFFFFF\">Cash</font>"))
			
			var cards:CardsIconView = new CardsIconView(CardsIconView.TWO_MINI_CARDS_QUERY_MARK, CardsIconView.COLOR_BLUE);
			itemsContainer.addChild(new DescriptionItemRenderer(cards, "<font color=\"#FFFC00\">" + chestDropCount.сollectionsFromToString(true) + "</font>  <font color=\"#FFFFFF\">Random\nCollection  Cards</font>"))
			
			var cardsCustom:CardsIconView = new CardsIconView(CardsIconView.TWO_MINI_CARDS_QUERY_MARK, CardsIconView.COLOR_ORANGE);
			itemsContainer.addChild(new DescriptionItemRenderer(cardsCustom, "<font color=\"#FFFC00\">" + chestDropCount.сustomizersFromToString(true) + "</font>  <font color=\"#FFFFFF\">Random\nCustomization  Items</font>"))
		}
		
		public function animateAppearance(delay:Number):void 
		{
			if (!isInitialized)
				initializeNow();
				
			titleLabel.alpha = 0;
			TweenHelper.tween(titleLabel, 0.4, { delay: delay + 0.2, alpha:1, transition:Transitions.EASE_OUT } );
			
			for (var i:int = 0; i < itemsContainer.numChildren; i++) 
			{
				var renderer:DescriptionItemRenderer = itemsContainer.getChildAt(i) as DescriptionItemRenderer;
				if (renderer)
					renderer.animateAppearance(delay + 0.03 * i);
			}
		}
		
		override protected function draw():void 
		{
			super.draw();
		}
		
		
	}

}