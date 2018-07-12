package com.alisacasino.bingo.screens.inventoryScreenClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.ImageAsset;
	import com.alisacasino.bingo.components.CardSelectorView;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

	public class InventoryItemRenderer extends CardItemRenderer implements ICardRenderer
	{
		private var _item:CustomizerItemBase;
		
		private var selectorView:CardSelectorView;
		
		public function InventoryItemRenderer() 
		{
			super();
		}
		
		public function get item():CustomizerItemBase 
		{
			return _item;
		}
		
		public function set item(value:CustomizerItemBase):void 
		{
			if (_item != value)
			{
				if (_item && _item.uiAsset)
				{
					_item.uiAsset.removeCompleteCallback(onImageLoaded);
				}
				
				_item = value;
				
				if (_item) 
				{
					_item.awaitBurn = false;
				}
				
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		override public function get cardItem():ICardData
		{
			return _item;
		}
		
		override public function get cardAsset():ImageAsset
		{
			return _item ? _item.uiAsset : null;
		}
		
		override protected function get hasItem():Boolean
		{
			return item && item.quantity > 0;
		}
		
		override protected function get countBackgroundWidth():Number 
		{
			return ((item && item.defaultItem) ? 128 : 66) * pxScale;
		}

		override protected function get burnAnimationContainer():DisplayObjectContainer {
			var container:DisplayObject = DialogsManager.instance.getDialogByClass(InventoryScreen);
			return container ? (container as DisplayObjectContainer) : null;
		}
		
		override protected function get countLabelText():String {
			return countLabel.text = item.defaultItem ? "DEFAULT" : ('X ' + item.quantity.toString());
		}
		
		override protected function get cardBackSource():Object {
			return AtlasAsset.CommonAtlas.getTexture("dialogs/inventory_card_cover");
		}
		
		override protected function commitData():void 
		{
			super.commitData();
			
			if (!cardItem)
			{
				showSelected(false);
				return;
			}
			
			updateSelected();
		}
		
		protected function showSelected(value:Boolean):void 
		{
			if (value)
			{
				if (!selectorView) {
					selectorView = new CardSelectorView(138 * pxScale, 172 * pxScale);
					//selectorView.x = -1 * pxScale;
					selectorView.y = -3 * pxScale;
					addChild(selectorView);
				}
				selectorView.state = CardSelectorView.STATE_SHOW;
			}
			else
			{
				if (selectorView) {
					selectorView.state = CardSelectorView.STATE_HIDE;
				}
			}
		}
		
		public function get isSelectedView():Boolean {
			return selectorView && selectorView.state != CardSelectorView.STATE_HIDE;
		}
		
		public function updateSelected():void 
		{
			showSelected(item && item.quantity > 0 && gameManager.skinningData.checkSelected(item));
		}
		
		override protected function showCardBurn(isLast:Boolean = false):void 
		{
			super.showCardBurn(isLast);
			
			if (isSelectedView && !isLast) {
				Starling.juggler.tween(selectorView, 0.3, {delay:0.2, alpha:0});
			}
		}
		
		override protected function handler_daubCardSplashAnimationComplete(e:Event):void
		{
			super.handler_daubCardSplashAnimationComplete(e);
			
			if (cardItem && cardItem.quantity > 0)
			{
				if (isSelectedView)
					Starling.juggler.tween(selectorView, 0.3, {delay:0.6, alpha:1});
			}
		}
	}

}