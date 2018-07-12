package com.alisacasino.bingo.controls.dustConversionClasses
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.commands.dialogCommands.ChestTakeOutCommand;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.BaseDialog;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.chests.ChestPartsView;
	import com.alisacasino.bingo.dialogs.chests.ChestTakeOutDialog;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.chests.ChestData;
	import com.alisacasino.bingo.models.collections.CollectionItem;
	import com.alisacasino.bingo.models.universal.Price;
	import com.alisacasino.bingo.protocol.CardType;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.collectionsScreenClasses.PageRewardPrizeDisplay;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNADustConversionTransaction;
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
	public class DustBubbleContent extends FeathersControl
	{
		private var _card:CollectionItem;
		private var headerLabel:XTextField;
		private var rarityLabel:XTextField;
		private var progressBarLabel:XTextField;
		private var firstLine:XTextField;
		private var forAChestLabel:XTextField;
		private var chestImage:ChestPartsView;
		private var button:Button;
		private var grayscaleFilter:ColorMatrixFilter;
		private var dustPlayerValueView:PageRewardPrizeDisplay;
		
		public function DustBubbleContent()
		{
			width = 453*pxScale;
			height = 350*pxScale;
			grayscaleFilter = new ColorMatrixFilter();
			grayscaleFilter.adjustSaturation( -1);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			var headerBackground:Image = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/collections/card_background"));
			headerBackground.alpha = 0.5;
			headerBackground.scale9Grid = ResizeUtils.getScaledRect(16, 16, 8, 8);
			headerBackground.width = 428 * pxScale;
			headerBackground.height = 74 * pxScale;
			headerBackground.x = 13 * pxScale;
			headerBackground.y = 11 * pxScale;
			addChild(headerBackground);
			
			headerLabel = new XTextField(428 * pxScale, 60 * pxScale, XTextFieldStyle.getWalrus(32, 0xffffff, Align.CENTER).addShadow(1, 0x0, 1, 6));
			headerLabel.x = headerBackground.x;
			headerLabel.y = headerBackground.y + 10 * pxScale;
			addChild(headerLabel);
			
			firstLine = new XTextField(400 * pxScale, 100 * pxScale, XTextFieldStyle.getWalrus(22, 0xFFFFFF, Align.CENTER, Align.TOP).addShadow(0.5, 0x0, 1, 4));
			firstLine.isHtmlText = true;
			firstLine.x = 27 * pxScale;
			firstLine.y = 100 * pxScale
			addChild(firstLine);
			
			forAChestLabel = new XTextField(400 * pxScale, 100 * pxScale, XTextFieldStyle.getWalrus(22, 0xffffff, Align.CENTER, Align.TOP).addShadow(0.5, 0x0, 1, 4));
			forAChestLabel.x = 27 * pxScale;
			forAChestLabel.y = 134 * pxScale
			addChild(forAChestLabel);
			
			dustPlayerValueView = new PageRewardPrizeDisplay(Type.DUST, -4);
			dustPlayerValueView.show(gameManager.gameData.dustCostChestConversion, 0);
			dustPlayerValueView.x = 72 * pxScale;
			dustPlayerValueView.y = 220 * pxScale;
			addChild(dustPlayerValueView);
			
			chestImage = new ChestPartsView(ChestType.SUPER, 0.88, null, 0, -14*pxScale);
			chestImage.x = 340 * pxScale;
			chestImage.y = 246 * pxScale;
			addChild(chestImage);
			
			button = new Button();
			button.x = 27 * pxScale;
			button.y = 258 * pxScale;
			button.scaleWhenDown = 0.9;
			button.useHandCursor = true;
			button.defaultSkin = createButtonSkin();
			button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
			addChild(button);
		}
		
		private function button_triggeredHandler(e:Event):void 
		{	
			SoundManager.instance.playSfx(SoundAsset.ButtonClick, 0, 0, SoundAsset.DEFAULT_BUTTON_CLICK_VOLUME, 0, true);
			
			if (Player.current.dustCount >= gameManager.gameData.dustCostChestConversion)
			{
				Player.current.updateDustCount( -gameManager.gameData.dustCostChestConversion, "chestConversion");
				
				var chestData:ChestData = new ChestData(0);
				chestData.type = ChestType.SUPER;
				chestData.seed = (Math.random() * (int.MAX_VALUE - 1)) + 1;
				new ChestTakeOutCommand(chestData, callback_chestTakeOutDialogClose, null, true, ChestTakeOutCommand.DUST_CONVERSION, new Price(Type.DUST, gameManager.gameData.dustCostChestConversion)).execute();
				
				gameManager.analyticsManager.sendDeltaDNAEvent(new DDNADustConversionTransaction(gameManager.gameData.dustCostChestConversion, ChestType.SUPER));
				
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
			headerLabel.text = "EMERALD DUST";
			
			firstLine.text = "EXCHANGE  <font color=\"#f6ff00\">" + gameManager.gameData.dustCostChestConversion + "</font>  <font color=\"#A9FF22\">EMERALD  DUST</font>";
			forAChestLabel.text = "FOR  A  SUPER  CHEST";
			
			if (!chestImage) {
				chestImage = new ChestPartsView(ChestType.SUPER, 0.78);
				chestImage.x = 367 * pxScale;
				chestImage.y = 266 * pxScale;
				addChild(chestImage);
			}
			
			if (Player.current.dustCount >= gameManager.gameData.dustCostChestConversion)
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
		
	}

}