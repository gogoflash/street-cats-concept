package com.alisacasino.bingo.screens.collectionsScreenClasses
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.commands.dialogCommands.ChestTakeOutCommand;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.BaseDialog;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.chests.ChestPartsView;
	import com.alisacasino.bingo.dialogs.chests.ChestTakeOutDialog;
	import com.alisacasino.bingo.models.chests.ChestData;
	import com.alisacasino.bingo.models.collections.CollectionItem;
	import com.alisacasino.bingo.protocol.CardType;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import feathers.controls.Button;
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
	public class ExchangeBubbleContent extends FeathersControl
	{
		private var _card:CollectionItem;
		private var headerLabel:XTextField;
		private var rarityLabel:XTextField;
		private var progressBar:ExchangeProgressBar;
		private var progressBarLabel:XTextField;
		private var nCardsLabel:XTextField;
		private var forAChestLabel:XTextField;
		private var chestImage:ChestPartsView;
		private var button:Button;
		private var grayscaleFilter:ColorMatrixFilter;
		
		public function get card():CollectionItem
		{
			return _card;
		}
		
		public function set card(value:CollectionItem):void
		{
			if (_card != value)
			{
				_card = value;
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		public function ExchangeBubbleContent()
		{
			grayscaleFilter = new ColorMatrixFilter();
			grayscaleFilter.adjustSaturation( -1);
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
			
			headerLabel = new XTextField(446 * pxScale, 60 * pxScale, XTextFieldStyle.getWalrus(36, 0xffffff, Align.CENTER).addShadow(1, 0x0, 1, 6));
			headerLabel.x = headerBackground.x;
			headerLabel.y = headerBackground.y + 3 * pxScale;
			addChild(headerLabel);
			
			rarityLabel = new XTextField(446 * pxScale, 40 * pxScale, XTextFieldStyle.getWalrus(26, 0x959595, Align.CENTER));
			rarityLabel.x = headerBackground.x;
			rarityLabel.y = headerBackground.y + 56 * pxScale;
			addChild(rarityLabel);
			
			progressBar = new ExchangeProgressBar(430 * pxScale);
			progressBar.x = 22 * pxScale;
			progressBar.y = 128 * pxScale;
			addChild(progressBar);
			
			progressBarLabel = new XTextField(430 * pxScale, 30 * pxScale, XTextFieldStyle.getWalrus(23, 0xffffff, Align.CENTER).addStroke(1, 0x0));
			progressBarLabel.x = progressBar.x;
			progressBarLabel.y = progressBar.y + 10 * pxScale;
			addChild(progressBarLabel);
			
			var exchangeLabel:XTextField = new XTextField(200 * pxScale, 100 * pxScale, XTextFieldStyle.getWalrus(23, 0xffffff, Align.LEFT, Align.TOP).addShadow(0.5, 0x0, 1, 4), "EXCHANGE");
			exchangeLabel.x = 27 * pxScale;
			exchangeLabel.y = 190 * pxScale
			addChild(exchangeLabel);
			
			nCardsLabel = new XTextField(200 * pxScale, 100 * pxScale, XTextFieldStyle.getWalrus(23, 0xfcff00, Align.LEFT, Align.TOP).addShadow(0.5, 0x0, 1, 4));
			nCardsLabel.x = 167 * pxScale;
			nCardsLabel.y = 190 * pxScale
			addChild(nCardsLabel);
			
			forAChestLabel = new XTextField(400 * pxScale, 100 * pxScale, XTextFieldStyle.getWalrus(23, 0xffffff, Align.LEFT, Align.TOP).addShadow(0.5, 0x0, 1, 4));
			forAChestLabel.x = 27 * pxScale;
			forAChestLabel.y = 224 * pxScale
			addChild(forAChestLabel);
			
			chestImage = new ChestPartsView(0, 0.88, null, 0, -14*pxScale);
			chestImage.x = 367 * pxScale;
			chestImage.y = 266 * pxScale;
			addChild(chestImage);
			
			button = new Button();
			button.x = 27 * pxScale;
			button.y = 272 * pxScale;
			button.scaleWhenDown = 0.9;
			button.useHandCursor = true;
			button.defaultSkin = createButtonSkin();
			button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
			addChild(button);
		}
		
		private function button_triggeredHandler(e:Event):void 
		{
			if (!card)
				return;
			
			if (card.duplicates >= card.numberToExchange)
			{
				card.duplicates -= card.numberToExchange;
				
				var chestData:ChestData = new ChestData(0);
				chestData.type = getChestType(card.rarity);
				chestData.seed = (Math.random() * (int.MAX_VALUE - 1)) + 1;
				new ChestTakeOutCommand(chestData, callback_chestTakeOutDialogClose, null, true, ChestTakeOutCommand.CARD_EXCHANGE).execute();
				
				dispatchEventWith(Event.CLOSE);
			}
		}
		
		private function callback_chestTakeOutDialogClose():void 
		{
			dispatchEventWith(Event.COMPLETE);
		}
		
		private function createButtonSkin():Sprite
		{
			var container:Sprite = new Sprite();
			
			var background:Image = new Image(AtlasAsset.CommonAtlas.getTexture("buttons/green_base_contoured"));
			background.scale9Grid = ResizeUtils.getScaledRect(15, 13, 175, 38);
			background.width = 205 * pxScale;
			background.height = 65 * pxScale;
			container.addChild(background);
			
			var buttonLabel:XTextField = new XTextField(background.width, 32 * pxScale, XTextFieldStyle.getWalrus(24, 0xffffff).addShadow(0.5, 0x087315, 1, 5), "EXCHANGE");
			buttonLabel.y = 16 * pxScale;
			container.addChild(buttonLabel);
			
			return container;
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
			if (!card)
				return;
			
			headerLabel.text = card.name;
			
			var rarityText:String;
			var rarityStyle:XTextFieldStyle;
			var chestRarity:int = getChestType(card.rarity);
			switch (card.rarity)
			{
				default: 
				case CardType.NORMAL: 
					rarityText = "NORMAL CARD";
					rarityStyle = XTextFieldStyle.getWalrus(23, 0x959595);
					break;
				case CardType.MAGIC: 
					rarityText = "SILVER CARD";
					rarityStyle = XTextFieldStyle.getWalrus(25, 0xcaecff).addStroke(1, 0x0);
					break;
				case CardType.RARE: 
					rarityText = "GOLD CARD";
					rarityStyle = XTextFieldStyle.getWalrus(25, 0xffe400).addStroke(1, 0x0);
					break;
			}
			
			rarityLabel.textStyle = rarityStyle;
			rarityLabel.text = rarityText;
			
			progressBar.position = Math.min(1, card.duplicates / card.numberToExchange);
			
			progressBarLabel.text = card.duplicates + " OUT OF " + card.numberToExchange;
			
			nCardsLabel.text = card.numberToExchange + " CARDS";
			
			
			var chestRarityText:String;
			//var chestTexture:Texture = AtlasAsset.CommonAtlas.getTexture(ChestData.getTexture(chestRarity));
			switch(chestRarity)
			{
				default:
				case ChestType.GOLD:
					chestRarityText = "GOLD";
					break;
				case ChestType.SUPER:
					chestRarityText = "SUPER";
					break;
			}
			
			nCardsLabel.text = card.numberToExchange + " CARDS";
			forAChestLabel.text = "FOR A " + chestRarityText + " CHEST";
			
			if (!chestImage) {
				chestImage = new ChestPartsView(chestRarity, 0.78);
				chestImage.x = 367 * pxScale;
				chestImage.y = 266 * pxScale;
				addChild(chestImage);
			}
			else {
				chestImage.type = chestRarity;
			}
			
			//chestImage.readjustSize();
			//chestImage.alignPivot();
			
			if (card.duplicates >= card.numberToExchange)
			{
				button.isEnabled = true;
				button.filter = null;
			}
			else
			{
				button.isEnabled = false;
				button.filter = grayscaleFilter;
			}
		}
		
		private function getChestType(rarity:int):int 
		{
			switch (rarity)
			{
				default: 
				case CardType.NORMAL: 
					return ChestType.GOLD;
				case CardType.MAGIC: 
				case CardType.RARE: 
					return ChestType.SUPER;
			}
			return ChestType.BRONZE;
		}
	
	}

}