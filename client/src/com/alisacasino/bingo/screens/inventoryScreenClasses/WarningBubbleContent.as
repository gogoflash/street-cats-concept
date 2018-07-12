package com.alisacasino.bingo.screens.inventoryScreenClasses 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.commands.dialogCommands.BurnCardCommand;
	import com.alisacasino.bingo.commands.player.UpdateLobbyBarsTrueValue;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import starling.events.Event;
	import starling.utils.Align;
	
	public class WarningBubbleContent extends BubbleContentBase 
	{
		private var yesButton:XButton;
		private var noButton:XButton;
		private var descriptionTextField:XTextField;
		
		public function WarningBubbleContent() 
		{
			super();
			isHeaderCloseButton = true;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			headerLabel = new XTextField(446 * pxScale, 60 * pxScale, XTextFieldStyle.getWalrus(41, 0xFFE400, Align.CENTER).setShadow(), 'WARNING!');
			headerLabel.x = headerBackground.x;
			headerLabel.y = headerBackground.y + 20 * pxScale;
			headerLabel.touchable = false;
			addChild(headerLabel);
			
			yesButton = new XButton(XButtonStyle.GreenButtonContouredSliced, 'YES', 'YES');
			yesButton.alignPivot();
			yesButton.height = 70*pxScale;
			yesButton.x = 347*pxScale;
			yesButton.y = height - 57*pxScale;
			yesButton.addEventListener(Event.TRIGGERED, handler_yes);
			addChild(yesButton);
			
			noButton = new XButton(XButtonStyle.RedButton, 'NO', 'NO');
			noButton.width = 206 * pxScale;
			noButton.alignPivot();
			noButton.x = 124*pxScale;
			noButton.y = height - 55*pxScale;
			noButton.addEventListener(Event.TRIGGERED, handler_no);
			addChild(noButton);
			
			descriptionTextField = new XTextField(width, 160 * pxScale, XTextFieldStyle.getWalrus(28, 0xFFFFFF, Align.CENTER).setShadow());
			descriptionTextField.x = 0*pxScale;
			descriptionTextField.y = 115 * pxScale;
			descriptionTextField.touchable = false;
			descriptionTextField.format.leading = 10;
			addChild(descriptionTextField);
		}	
		
		override protected function draw():void
		{
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				descriptionTextField.text = card.quantity > 1 ? Constants.LAST_CARDS_BURN_WARNING : Constants.LAST_CARD_BURN_WARNING;
			}
		}
		
		private function handler_yes(e:Event):void 
		{
			new BurnCardCommand(card, card.quantity).execute();
			
			dispatchEventWith(InventoryBubbleContent.EVENT_UPDATE_RENDERER, true);
			dispatchEventWith(InventoryBubbleContent.EVENT_BURN, true);
			
			new UpdateLobbyBarsTrueValue(0.5).execute();
			
			SoundManager.instance.playSfx(SoundAsset.CardBurning, 0, 0, 1, 0, true);
			
			dispatchEventWith(Event.CLOSE, true);
		}
		
		private function handler_no(e:Event):void 
		{
			dispatchEventWith(InventoryBubbleContent.EVENT_BACK, true);
		}
		
		override protected function handler_closeOrTooltipButtonTriggered(e:Event):void 
		{
			dispatchEventWith(InventoryBubbleContent.EVENT_BACK, true);
		}
		
	}

}