package com.alisacasino.bingo.screens.collectionsScreenClasses
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.ImageAssetContainer;
	import com.alisacasino.bingo.controls.PlayerValueView;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.BaseDialog;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.models.chests.ChestData;
	import com.alisacasino.bingo.models.collections.CollectionItem;
	import com.alisacasino.bingo.models.collections.CollectionPage;
	import com.alisacasino.bingo.protocol.CardType;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.ModificatorMessage;
	import com.alisacasino.bingo.protocol.ModificatorType;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.utils.StringUtils;
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	import feathers.core.FeathersControl;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.utils.Align;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class PageRewardBubbleContent extends FeathersControl
	{
		private var _collectionPage:CollectionPage;
		private var headerLabel:XTextField;
		private var pageNameLabel:XTextField;
		private var cashPlayerValueView:PageRewardPrizeDisplay;
		private var energyPlayerValueView:PageRewardPrizeDisplay;
		private var trophyImage:ImageAssetContainer;
		private var permanentBonusLabel:XTextField;
		
		public function get collectionPage():CollectionPage
		{
			return _collectionPage;
		}
		
		public function set collectionPage(value:CollectionPage):void
		{
			if (_collectionPage != value)
			{
				_collectionPage = value;
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		public function PageRewardBubbleContent()
		{
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			var headerBackground:Image = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/collections/card_background"));
			headerBackground.alpha = 0.5;
			headerBackground.scale9Grid = ResizeUtils.getScaledRect(16, 16, 8, 8);
			headerBackground.width = 446 * pxScale;
			headerBackground.height = 102 * pxScale;
			headerBackground.x = 15 * pxScale;
			headerBackground.y = 13 * pxScale;
			addChild(headerBackground);
			
			headerLabel = new XTextField(446 * pxScale, 60 * pxScale, XTextFieldStyle.getWalrus(36, 0xffffff, Align.CENTER).addShadow(1, 0x0, 1, 6), "COLLECTION BONUS");
			headerLabel.x = headerBackground.x;
			headerLabel.y = headerBackground.y + 3 * pxScale;
			addChild(headerLabel);
			
			pageNameLabel = new XTextField(446 * pxScale, 40 * pxScale, XTextFieldStyle.getWalrus(26, 0xAF5555, Align.CENTER));
			pageNameLabel.x = headerBackground.x;
			pageNameLabel.y = headerBackground.y + 56 * pxScale;
			addChild(pageNameLabel);
			
			var rewardLabel:XTextField = new XTextField(200 * pxScale, 100 * pxScale, XTextFieldStyle.getWalrus(30, 0xf6ff00, Align.CENTER, Align.TOP).addShadow(0.5, 0x0, 1, 4), "REWARD");
			rewardLabel.x = 25 * pxScale;
			rewardLabel.y = 126 * pxScale
			addChild(rewardLabel);
			
			cashPlayerValueView = new PageRewardPrizeDisplay(Type.CASH, -4);
			cashPlayerValueView.show(0, 0);
			cashPlayerValueView.x = 66 * pxScale;
			cashPlayerValueView.y = 220 * pxScale;
			addChild(cashPlayerValueView);
				
			energyPlayerValueView = new PageRewardPrizeDisplay(Type.ENERGY, 0);
			energyPlayerValueView.show(0, 0);
			energyPlayerValueView.x = 66 * pxScale;
			energyPlayerValueView.y = 297 * pxScale;
			addChild(energyPlayerValueView);
			
			trophyImage = new ImageAssetContainer(null);
			trophyImage.setPivot(Align.CENTER, Align.CENTER);
			trophyImage.x = 350 * pxScale;
			trophyImage.y = 190 * pxScale;
			addChild(trophyImage);
			
			permanentBonusLabel = new XTextField(240 * pxScale, 40 * pxScale, XTextFieldStyle.getChateaudeGarage(25, 0x5487C0, Align.CENTER, Align.TOP), "+10% SCORE");
			permanentBonusLabel.autoScale = true;
			permanentBonusLabel.x = 220 * pxScale;
			permanentBonusLabel.y = 294 * pxScale
			addChild(permanentBonusLabel);
		}
		
		override protected function draw():void
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				commitData();
			}
		}
		
		private function commitData():void
		{
			if (!collectionPage)
				return;
			
			cashPlayerValueView.setValue(collectionPage.getCashReward());
			energyPlayerValueView.setValue(collectionPage.getPowerupReward());
			
			var permanentEffect:ModificatorMessage = collectionPage.getPermanentEffect();
			if (permanentEffect)
			{
				var template:String = "";
				switch(permanentEffect.type)
				{
					case ModificatorType.CASH_MOD:
						template = "+{0}% CASH BONUS";
						break;
					case ModificatorType.DISCOUNT_MOD:
						template = "{0}% CARD DISCOUNT";
						break;
					case ModificatorType.EXP_MOD:
						template = "+{0}% XP";
						break;
					case ModificatorType.SCORE_MOD:
						template = "+{0}% SCORE";
						break;
				}
				permanentBonusLabel.text = StringUtils.substitute(template, permanentEffect.quantity);
			}
			else
			{
				permanentBonusLabel.text = "";
			}
			
			//headerLabel.text = collectionPage.collection.name;
			pageNameLabel.text = collectionPage.name;
			
			trophyImage.source = collectionPage.trophyImage
		}
	
	}

}