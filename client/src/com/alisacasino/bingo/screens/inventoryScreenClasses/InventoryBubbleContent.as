package com.alisacasino.bingo.screens.inventoryScreenClasses 
{
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.protocol.CustomizationType;
	import feathers.core.FeathersControl;
	import starling.events.Event;
	
	public class InventoryBubbleContent extends FeathersControl
	{
		public static const EVENT_CHANGE_CONTENT:String = 'EVENT_CHANGE_CONTENT';
		public static const EVENT_UPDATE_RENDERER:String = 'EVENT_UPDATE_RENDERER';
		public static const EVENT_SHOW_BURN_CONTENT:String = 'EVENT_SHOW_BURN_CONTENT';
		public static const EVENT_SHOW_SET_PURCHASE_CONTENT:String = 'EVENT_SHOW_SET_PURCHASE_CONTENT';
		public static const EVENT_BACK:String = 'EVENT_BACK';
		public static const EVENT_BURN:String = 'EVENT_BURN';
		public static const EVENT_SHOW_WARNING_CONTENT:String = 'EVENT_SHOW_WARNING_CONTENT';
		public static const EVENT_BUY_SET:String = 'EVENT_BUY_SET';
		
		private var content:BubbleContentBase;
		
		private var _card:ICardData;
		
		private var _contentClass:Class;
		
		public function InventoryBubbleContent() 
		{
			_contentClass = SelectBubbleContent;
		}
		
		public function get card():ICardData
		{
			return _card;
		}
		
		public function set card(value:ICardData):void
		{
			if (_card != value)
			{
				_card = value;
				
				_contentClass = _card ? _card.baseBubbleContentClass : SelectBubbleContent;
				
				
			}
			
			invalidate(INVALIDATION_FLAG_DATA);
		}
		
		public function get contentClass():Class
		{
			return _contentClass;
		}
		
		public function set contentClass(value:Class):void
		{
			if (_contentClass != value)
			{
				_contentClass = value;
				invalidate(INVALIDATION_FLAG_DATA);
				validate();
			}
		}
		
		override protected function draw():void
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				if (contentClass)
				{
					if (content)
					{
						if (!(content is _contentClass)) {
							removeContent();
							
							dispatchEventWith(EVENT_CHANGE_CONTENT);
							
							createContent();
						}
					}
					else
					{
						createContent();
					}
					
					content.card = _card;		
				}
				else
				{
					if (content)
					{
						content.removeFromParent();
						content = null;
					}
				}
			}
		}
		
		private function createContent():void 
		{
			content = new _contentClass();	
			width = content.width;
			height = content.height;
			addChild(content);
			
			if (content is SelectBubbleContent) {
				content.addEventListener(EVENT_SHOW_BURN_CONTENT, handler_showExchangeContent);
				content.addEventListener(EVENT_SHOW_SET_PURCHASE_CONTENT, handler_showSetPurchaseContent);
			}
			else if (content is ExchangeBubbleContent) {
				content.addEventListener(EVENT_BURN, handler_burn);
				content.addEventListener(EVENT_SHOW_WARNING_CONTENT, handler_showWarningContent);
				content.addEventListener(EVENT_BACK, handler_back);
			}
			else if (content is WarningBubbleContent) {
				content.addEventListener(EVENT_BURN, handler_burn);
				content.addEventListener(EVENT_BACK, handler_back);
			}
			else if (content is SetPurchaseBubbleContent) {
				content.addEventListener(EVENT_BUY_SET, handler_buySet);
				content.addEventListener(EVENT_BACK, handler_back);
			}
		}

		private function removeContent():void 
		{
			if (!content)
				return;
				
			content.removeFromParent();
			
			if (content is SelectBubbleContent) {
				content.removeEventListener(EVENT_SHOW_BURN_CONTENT, handler_showExchangeContent);
				content.removeEventListener(EVENT_SHOW_SET_PURCHASE_CONTENT, handler_showSetPurchaseContent);
			}
			else if (content is ExchangeBubbleContent) {
				content.removeEventListener(EVENT_BURN, handler_burn);
				content.removeEventListener(EVENT_SHOW_WARNING_CONTENT, handler_showWarningContent);
				content.removeEventListener(EVENT_BACK, handler_back);
			}
			else if (content is WarningBubbleContent) {
				content.removeEventListener(EVENT_BURN, handler_burn);
				content.removeEventListener(EVENT_BACK, handler_back);
			}
			else if (content is SetPurchaseBubbleContent) {
				content.removeEventListener(EVENT_BUY_SET, handler_buySet);
				content.removeEventListener(EVENT_BACK, handler_back);
			}
			
			content = null;
		}

		private function handler_showExchangeContent(e:Event):void 
		{
			contentClass = ExchangeBubbleContent;
		}
		
		private function handler_showSetPurchaseContent(e:Event):void 
		{
			contentClass = SetPurchaseBubbleContent;
		}
		
		private function handler_showWarningContent(e:Event):void 
		{
			contentClass = WarningBubbleContent;
		}
		
		private function handler_buySet(e:Event):void 
		{
			contentClass = SetPurchaseBubbleContent;
		}
		
		private function handler_burn(e:Event):void 
		{
			dispatchEventWith(Event.CLOSE);
			//bubbleContent.removeEventListener(Event.CLOSE, exchangeBubbleContent_closeHandler);
			//bubbleContent.removeEventListener(EVENT_BURN, handler_burn);
			//hide();
		}
		
		private function handler_back(e:Event):void 
		{
			if (!content)
				return;
			
			if (content is ExchangeBubbleContent) {
				contentClass = SelectBubbleContent;
			}
			else if (content is WarningBubbleContent) {
				contentClass = ExchangeBubbleContent;
			}
			else if (content is SetPurchaseBubbleContent) {
				contentClass = SelectBubbleContent;
			}	
		}
	}
}