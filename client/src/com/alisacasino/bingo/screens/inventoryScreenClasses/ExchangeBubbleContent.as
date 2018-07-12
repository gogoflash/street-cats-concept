package com.alisacasino.bingo.screens.inventoryScreenClasses 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.commands.ShowNoMoneyPopup;
	import com.alisacasino.bingo.commands.dialogCommands.BurnCardCommand;
	import com.alisacasino.bingo.commands.player.UpdateLobbyBarsTrueValue;
	import com.alisacasino.bingo.components.CardsIconView;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.collections.CollectionItem;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.collectionsScreenClasses.PageRewardPrizeDisplay;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import flash.geom.Point;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	
	public class ExchangeBubbleContent extends BubbleContentBase 
	{
		public function ExchangeBubbleContent() 
		{
			super();
			//isHeaderCloseButton = true;
		}
		
		private var arrowImage:Image;
		private var dustBar:PageRewardPrizeDisplay;
		private var cardsIcons:CardsIconView;
		private var burnButton:XButton;
		
		private var counterButtonEnabled:Boolean = true;
		private var plusButton:XButton;
		private var minusButton:XButton;
		private var exchangeValue:int = 1;
		
		override public function set card(value:ICardData):void
		{
			if (_card != value)
			{
				//exchangeValue = 1;
				_card = value;
			}
			else
			{
				//if (_card)
					//exchangeValue = Math.max(1, Math.min(exchangeValue, _card.quantity));
			}
			
			exchangeValue = Math.max(1, Math.min(exchangeValue, limitQuantity));
			
			invalidate(INVALIDATION_FLAG_DATA);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			arrowImage = new Image(AtlasAsset.CommonAtlas.getTexture('dialogs/inventory/green_arrow'));
			arrowImage.scale9Grid = ResizeUtils.getScaledRect(1, 0, 1, 0);
			arrowImage.width = 155 * pxScale;
			arrowImage.x = 100 * pxScale;
			arrowImage.y = 148 * pxScale;
			addChild(arrowImage);
			
			cardsIcons = new CardsIconView(CardsIconView.TWO_FLAMED_CARDS, CardsIconView.COLOR_ORANGE);
			cardsIcons.x = 24 * pxScale;
			cardsIcons.y = 110 * pxScale;
			addChild(cardsIcons);
			
			dustBar = new PageRewardPrizeDisplay(Type.DUST, -4);
			dustBar.x = 303 * pxScale;
			dustBar.y = 191 * pxScale;
			dustBar.show(0, 0);
			addChild(dustBar);
			
			burnButton = new XButton(XButtonStyle.GreenButtonContoured, 'BURN', 'BURN');
			burnButton.alignPivot();
			burnButton.x = width/2;
			burnButton.y = height - 55*pxScale;
			burnButton.addEventListener(Event.TRIGGERED, handler_burn);
			addChild(burnButton);
			
			if (counterButtonEnabled)
			{
				minusButton = new XButton(XButtonStyle.GreenCounter, '-', '-');
				minusButton.alignPivot();
				minusButton.x = width/2 - burnButton.width/2 - 67*pxScale;
				minusButton.y = burnButton.y;
				minusButton.addEventListener(Event.TRIGGERED, handler_minus);
				minusButton.enabled = false;
				addChild(minusButton);
				
				plusButton = new XButton(XButtonStyle.GreenCounter, '+', '+');
				plusButton.alignPivot();
				plusButton.x = width/2 + burnButton.width/2 + 67*pxScale;
				plusButton.y = burnButton.y;
				plusButton.addEventListener(Event.TRIGGERED, handler_plus);
				addChild(plusButton);
			}
		}	
		
		override protected function draw():void
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				if (card) 
				{
					dustBar.setValue(exchangeValue * card.dustGain);
					cardsIcons.count = exchangeValue;
					
					minusButton.enabled = exchangeValue >= 2;
					plusButton.enabled = exchangeValue < limitQuantity;
					
					if (isCollection)
					{
						cardsIcons.cardColorType = CardsIconView.COLOR_BLUE;
						setHeaderButton();
					}
					else
					{
						cardsIcons.cardColorType = CardsIconView.COLOR_ORANGE;
						setHeaderButton("buttons/circle_gray_close");
					}
					
				}
				else
				{
					minusButton.enabled = false;
					plusButton.enabled = false;
					cardsIcons.count = 0;
					setHeaderButton(null);
				}
			}
		}
		
		private function get isCollection():Boolean 
		{
			return card && card.itemData is CollectionItem;
		}
		
		private function handler_select(e:Event):void 
		{
			//gameManager.skinningData.applyCustomizer(card);
			dispatchEventWith(Event.CLOSE, true);
		}
		
		private function handler_burn(e:Event):void 
		{
			if (isCollection)
			{
				if (card.quantity <= 1) 
				{
					var point:Point = localToGlobal(new Point(width/2, height/2));
					new ShowNoMoneyPopup(ShowNoMoneyPopup.PURPLE, Starling.current.stage, point, "CAN'T BURN THE LAST CARD!", false, 690).execute();
					return;
				}
			}
			else
			{
				if (exchangeValue >= card.quantity) 
				{
					dispatchEventWith(InventoryBubbleContent.EVENT_SHOW_WARNING_CONTENT);
					return;
				}
			}
			
			new BurnCardCommand(card, exchangeValue).execute();
			
			new UpdateLobbyBarsTrueValue(0.5).execute();
			
			SoundManager.instance.playSfx(SoundAsset.CardBurning, 0, 0, 1, 0, true);
			
			dispatchEventWith(InventoryBubbleContent.EVENT_UPDATE_RENDERER, true);
			dispatchEventWith(InventoryBubbleContent.EVENT_BURN, true);
		}
		
		private function handler_minus(e:Event):void 
		{
			if (exchangeValue <= 1)
				return;
				
			exchangeValue--;
			invalidate(INVALIDATION_FLAG_DATA);
		}
		
		private function handler_plus(e:Event):void 
		{
			if (!card)
				return;
				
			if (exchangeValue >= limitQuantity)
				return;
				
			exchangeValue++;
			invalidate(INVALIDATION_FLAG_DATA);
		}
		
		override protected function handler_triggeredHeaderButton(e:Event):void 
		{
			dispatchEventWith(InventoryBubbleContent.EVENT_BACK);
		}
		
		private function get limitQuantity():int {
			return isCollection ? (card.quantity - 1) : card.quantity;
		}
	}

}