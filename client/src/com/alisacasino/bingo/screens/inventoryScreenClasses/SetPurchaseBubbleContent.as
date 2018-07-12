package com.alisacasino.bingo.screens.inventoryScreenClasses 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.commands.ShowNoMoneyPopup;
	import com.alisacasino.bingo.commands.player.UpdateLobbyBarsTrueValue;
	import com.alisacasino.bingo.controls.DoubleTitlesButtonContent;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.models.skinning.CustomizerSet;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.protocol.CustomizationType;
	import com.alisacasino.bingo.screens.collectionsScreenClasses.CollectionsScreen;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNACustomizerSetTransactionEvent;
	import feathers.controls.Button;
	import flash.geom.Point;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.Align;
	
	public class SetPurchaseBubbleContent extends BubbleContentBase 
	{
		private var buyButton:Button;
		private var descriptionTextField:XTextField;
		private var setFlipImage:Card3DFlipView;
		private var buttonContent:DoubleTitlesButtonContent;
		
		private var customizerSet:CustomizerSet;
		
		private var textItemIndex:int;
		
		public function SetPurchaseBubbleContent() 
		{
			super();
			isHeaderCloseButton = true;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			/*headerLabel = new XTextField(446 * pxScale, 60 * pxScale, XTextFieldStyle.getWalrus(41, 0xFFE400, Align.CENTER).setShadow(), 'WARNING!');
			headerLabel.x = headerBackground.x;
			headerLabel.y = headerBackground.y + 20 * pxScale;
			headerLabel.touchable = false;
			addChild(headerLabel);*/
			
			addTextItem('• UNIQUE  STYLE');
			addTextItem('• BINGO  ALERT');
			
			buttonContent = DoubleTitlesButtonContent.createBuyForCashButtonContent(/*null*/'BUY', AtlasAsset.CommonAtlas.getTexture("store/cash_price_icon"), '1000', 4, 204 * pxScale, -2, 24, 26);
			
			buyButton = new Button();
			buyButton.scaleWhenDown = 0.93;
			buyButton.useHandCursor = true;
			buyButton.defaultSkin = buttonContent;
			buyButton.validate();
			buyButton.alignPivot();
			buyButton.x = 135*pxScale;
			buyButton.y = height - 55*pxScale;
			buyButton.addEventListener(Event.TRIGGERED, handler_buyButtonClick);
			addChild(buyButton);
			
			var completeTextField:XTextField = new XTextField(270*pxScale, 160 * pxScale, XTextFieldStyle.getWalrus(24, 0xFFFFFF, Align.LEFT, Align.TOP).setShadow(), "COMPLETE SET:");
			completeTextField.x = 37*pxScale;
			completeTextField.y = buyButton.y - buyButton.height/2 - 39 * pxScale;
			completeTextField.touchable = false;
			addChild(completeTextField);
			
			setFlipImage = new Card3DFlipView();
			setFlipImage.x = width - Card3DFlipView.WIDTH/2*pxScale - 1*pxScale;
			setFlipImage.y = height - Card3DFlipView.HEIGHT/2*pxScale + 2*pxScale;
			addChild(setFlipImage);
		}	
		
		private function addTextItem(text:String):void 
		{
			var textField:XTextField = new XTextField(242*pxScale, 160 * pxScale, XTextFieldStyle.getWalrus(24, 0xFFF000, Align.LEFT, Align.TOP).setShadow(), text);
			textField.x = 27*pxScale;
			textField.y = 96 * pxScale + ++textItemIndex*40*pxScale;
			textField.touchable = false;
			addChild(textField);
		}
		
		override protected function draw():void
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				if (card)
				{
					customizerSet = gameManager.skinningData.getSetByID(card.setID);
					
					headerLabel.text = customizerSet.name;
					rarityLabel.textStyle = XTextFieldStyle.getWalrus(25, 0xffe400, Align.LEFT).addStroke(1, 0x0);
					rarityLabel.text = card.name;
					
					buttonContent.label2.text = getPrice().toString();
					
					setFlipImage.item = card.type == CustomizationType.DAUB_ICON ? customizerSet.cardBack : customizerSet.dauber;
					
					alignHeaderViews();
					
				}
				else
				{
					setFlipImage.item = null;
				}
			}
		}
		
		private function getPrice():int 
		{
			if (customizerSet && card)
			{
				if (card.type == CustomizationType.DAUB_ICON) 
					return customizerSet.cardBack ? customizerSet.cardBack.setPrice : 999;
				else if (card.type == CustomizationType.CARD) 
					return customizerSet.dauber ? customizerSet.dauber.setPrice : 999;
			}
			
			return 999;
		}
		
		private function handler_buyButtonClick(e:Event):void 
		{
			var priceValue:int = getPrice();
			if (Player.current.cashCount < priceValue)
			{
				var point:Point = new Point(width/2, height/2);
				//new ShowNoMoneyPopup(ShowNoMoneyPopup.PURPLE, this, point, 'NOT ENOUGTH CARDS').execute();
				new ShowNoMoneyPopup(ShowNoMoneyPopup.PURPLE, this, point).execute();
				return;
			}
			
			Player.current.reservedCashCount -= priceValue;
			Player.current.updateCashCount(-priceValue, "customizerSetBuy");
			var inventoryDialog:InventoryScreen = DialogsManager.instance.getDialogByClass(InventoryScreen) as InventoryScreen;
			
			var toPurchase:CustomizerItemBase;
			if (customizerSet && card)
			{
				if (card.type == CustomizationType.DAUB_ICON && customizerSet.cardBack) 
				{
					customizerSet.cardBack.quantity++;
					toPurchase = customizerSet.cardBack;
					gameManager.skinningData.newCustomizerItems.push(customizerSet.cardBack);
					if(inventoryDialog)
						inventoryDialog.mode = InventoryScreen.CARD_BACK_MODE;
				}
				else if (card.type == CustomizationType.CARD && customizerSet.dauber) 
				{
					customizerSet.dauber.quantity++;
					toPurchase = customizerSet.dauber;
					gameManager.skinningData.newCustomizerItems.push(customizerSet.dauber);
					if(inventoryDialog)
						inventoryDialog.mode = InventoryScreen.DAUBER_MODE;
				}
			}
			
			if (toPurchase)
			{
				gameManager.questModel.cardCollected(toPurchase);
				gameManager.analyticsManager.sendDeltaDNAEvent(new DDNACustomizerSetTransactionEvent(priceValue, toPurchase));
			}
			
			
			gameManager.analyticsManager.sendCommodityAddedEvent(CommodityType.CUSTOMIZER_SET, 1, "set_dialog" + '.' + customizerSet.id.toString());
			
			Game.connectionManager.sendPlayerUpdateMessage();
			new UpdateLobbyBarsTrueValue(0.5).execute();
			
			// TAKE OUT REAL SET ITEM!
			
			//dispatchEventWith(InventoryBubbleContent.EVENT_BURN, true);
			
			dispatchEventWith(Event.CLOSE, true);
		}
		
		override protected function handler_closeOrTooltipButtonTriggered(e:Event):void 
		{
			dispatchEventWith(InventoryBubbleContent.EVENT_BACK);
		}
	}

}