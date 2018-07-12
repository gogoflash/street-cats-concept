package com.alisacasino.bingo.screens.inventoryScreenClasses
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.BaseDialog;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.chests.ChestPartsView;
	import com.alisacasino.bingo.dialogs.chests.ChestTakeOutDialog;
	import com.alisacasino.bingo.models.chests.ChestData;
	import com.alisacasino.bingo.models.collections.CollectionItem;
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.protocol.CardType;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.collectionsScreenClasses.ExchangeProgressBar;
	import com.alisacasino.bingo.utils.tooltips.TooltipTrigger;
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	import flash.geom.Point;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
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
	public class BubbleContentBase extends FeathersControl
	{
		protected var headerBackground:Image;
		protected var _card:ICardData;
		protected var headerLabel:XTextField;
		protected var rarityLabel:XTextField;
		protected var button:Button;
		protected var headerButton:Button;
		protected var isHeaderCloseButton:Boolean;
		protected var isHeaoseButton:String;
		protected var headerHintString:String;
		
		public function get card():ICardData
		{
			return _card;
		}
		
		public function set card(value:ICardData):void
		{
			if (_card != value)
			{
				_card = value;
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		public function BubbleContentBase()
		{
			super();
			width = 471*pxScale;
			height = 364*pxScale;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			headerBackground = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/collections/card_background"));
			headerBackground.alpha = 0.5;
			headerBackground.scale9Grid = ResizeUtils.getScaledRect(16, 16, 8, 8);
			headerBackground.width = width - 26 * pxScale;
			headerBackground.height = 102 * pxScale;
			headerBackground.x = 13 * pxScale;
			headerBackground.y = 12 * pxScale;
			addChild(headerBackground);
			
			headerLabel = new XTextField(340 * pxScale, 50 * pxScale, XTextFieldStyle.getWalrus(36, 0xffffff, Align.LEFT).addShadow(1, 0x0, 1, 6));
			headerLabel.x = headerBackground.x;
			headerLabel.y = headerBackground.y + 8 * pxScale;
			//headerLabel.border = true;
			headerLabel.touchable = false;
			headerLabel.autoScale = true;
			addChild(headerLabel);
			
			rarityLabel = new XTextField(446 * pxScale, 40 * pxScale, XTextFieldStyle.getWalrus(26, 0x959595, Align.LEFT));
			rarityLabel.x = headerBackground.x;
			rarityLabel.y = headerBackground.y + 56 * pxScale;
			//rarityLabel.border = true;
			rarityLabel.touchable = false;
			addChild(rarityLabel);
		
			if (isHeaderCloseButton || (headerHintString && headerHintString != '')) 
			{
				button = isHeaderCloseButton ? (new Button()) : (new TooltipTrigger(1, 1, headerHintString, Align.BOTTOM, null, true) as Button);
				button.defaultSkin = createButtonSkin(isHeaderCloseButton ? "buttons/circle_gray_close" : "buttons/circle_red_query");
				
				button.validate();
				button.alignPivot();
				button.x = width - 60 * pxScale;
				button.y = headerBackground.y + headerBackground.height/2;
				button.scaleWhenDown = 0.9;
				button.useHandCursor = true;
				
				button.addEventListener(Event.TRIGGERED, handler_closeOrTooltipButtonTriggered);
				addChild(button);
			}
		}
		
		private function createButtonSkin(texture:String):Sprite
		{
			var container:Sprite = new Sprite();
			
			var touchQuad:Quad = new Quad(1, 1);
			touchQuad.width = 100 * pxScale;
			touchQuad.height = 100 * pxScale;
			touchQuad.alpha = 0.0;
			//touchQuad.alignPivot();
			container.addChild(touchQuad);
			
			var background:Image = new Image(AtlasAsset.CommonAtlas.getTexture(texture));
			background.x = (touchQuad.width - background.width) / 2;
			background.y = (touchQuad.height - background.height) / 2;
			container.addChild(background);
			
			/*var buttonLabel:XTextField = new XTextField(background.width, 32 * pxScale, XTextFieldStyle.getWalrus(24, 0xffffff).addShadow(0.5, 0x087315, 1, 5), "EXCHANGE");
			buttonLabel.y = 16 * pxScale;
			container.addChild(buttonLabel);*/
			//container.alignPivot();
			return container;
		}
		
		override protected function draw():void
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				commitData();
			}
			
			alignHeaderViews();
			
		}
		
		private function commitData():void
		{
			if (!card)
				return;
			
			headerLabel.text = card.name;
			
			var rarityText:String;
			var rarityStyle:XTextFieldStyle;
			switch (card.rarity)
			{
				default: 
				case CardType.NORMAL: 
					rarityText = card.rarityString + " CARD";
					rarityStyle = XTextFieldStyle.getWalrus(23, 0x959595, Align.LEFT);
					break;
				case CardType.MAGIC: 
					rarityText = card.rarityString + " CARD";
					rarityStyle = XTextFieldStyle.getWalrus(25, 0xcaecff, Align.LEFT).addStroke(1, 0x0);
					break;
				case CardType.RARE: 
					rarityText = card.rarityString + " CARD";
					rarityStyle = XTextFieldStyle.getWalrus(25, 0xffe400, Align.LEFT).addStroke(1, 0x0);
					break;
			}
			
			rarityLabel.textStyle = rarityStyle;
			rarityLabel.text = rarityText;
			
		}
		
		protected function setHeaderButton(texture:String = null):void
		{
			if (texture && texture != null)
			{
				if (!headerButton) 
				{
					headerButton = new Button();
					headerButton.defaultSkin = createButtonSkin(texture);
					
					headerButton.validate();
					headerButton.alignPivot();
					headerButton.x = width - 60 * pxScale;
					headerButton.y = headerBackground.y + headerBackground.height/2;
					headerButton.scaleWhenDown = 0.9;
					headerButton.useHandCursor = true;
					
					headerButton.addEventListener(Event.TRIGGERED, handler_triggeredHeaderButton);
					addChild(headerButton);
				}
				else {
					headerButton.defaultSkin = createButtonSkin(texture);
				}
			}
			else
			{
				if (headerButton) {
					headerButton.removeFromParent();
					headerButton.removeEventListener(Event.TRIGGERED, handler_triggeredHeaderButton);
					headerButton = null;
				}
			}
			
			alignHeaderViews();
		}
		
		protected function alignHeaderViews():void 
		{
			var buttonDisplayObject:DisplayObject = (button || headerButton) as DisplayObject
			var headerButtonGap:int = 15 * pxScale;
			var buttonPaddingRight:int = 60 * pxScale;
			var headerShift:int;
			
			if (buttonDisplayObject) {
				headerLabel.width = 340 * pxScale
				buttonDisplayObject.x = width - buttonPaddingRight;
				headerShift = (headerBackground.width - buttonPaddingRight - buttonDisplayObject.width - headerLabel.textBounds.width) / 2 - headerButtonGap;
			}
			else {
				headerLabel.width = 430 * pxScale;
			}
			
			headerLabel.x = headerBackground.x + (headerBackground.width - headerLabel.textBounds.width)/2 + Math.min(headerShift, 0);
			rarityLabel.x = headerLabel.x + (headerLabel.textBounds.width - rarityLabel.textBounds.width)/2;
		}
		
		protected function handler_triggeredHeaderButton(e:Event):void 
		{
			
		}
		
		protected function handler_closeOrTooltipButtonTriggered(e:Event):void 
		{
			if (isHeaderCloseButton)
				dispatchEventWith(Event.CLOSE, true);
		}
	}

}