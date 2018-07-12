package com.alisacasino.bingo.screens.inventoryScreenClasses
{
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.controls.AnimatedImageAssetContainer;
	import com.alisacasino.bingo.controls.ImageAssetContainer;
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.models.skinning.SkinningData;
	import feathers.controls.NumericStepper;
	import feathers.controls.renderers.LayoutGroupListItemRenderer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.textures.Texture;
	import starling.utils.Align;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class InventoryItemsPageRenderer extends LayoutGroupListItemRenderer
	{
		static public const HIDE_ITEM:String = "hideItem";
		static public const SHOW_ITEM:String = "showItem";
		
		private var itemRenderers:Vector.<InventoryItemRenderer>;
		//private var unknownItemTexture:Texture;
		
		public function InventoryItemsPageRenderer()
		{
			itemRenderers = new Vector.<InventoryItemRenderer>();
			
			//unknownItemTexture = AtlasAsset.CommonAtlas.getTexture("dialogs/collections/unknown_item");
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			for (var i:int = 0; i < 8; i++)
			{
				var itemRenderer:InventoryItemRenderer = new InventoryItemRenderer();
				itemRenderer.index = i;
				itemRenderers.push(itemRenderer);
				addChild(itemRenderer);
				itemRenderer.addEventListener(Event.TRIGGERED, itemRenderer_triggeredHandler);
			}
		}
		
		private function itemRenderer_triggeredHandler(e:Event):void 
		{
			//gameManager.skinningData.applyCustomizer((e.currentTarget as InventoryItemRenderer).item);
			dispatchEventWith(InventoryScreen.SHOW_CARD_OVERLAY, true, e.currentTarget as InventoryItemRenderer);
		}
		
		override protected function commitData():void
		{
			super.commitData();
			
			var contentPage:InventoryItemsPage = data as InventoryItemsPage;
			if (!contentPage)
			{
				return;
			}
			
			for (var i:int = 0; i < itemRenderers.length; i++) 
			{
				if (contentPage.length > i)
				{
					itemRenderers[i].visible = true;
					itemRenderers[i].item = contentPage.items[i];
				}
				else
				{
					itemRenderers[i].visible = false;
				}
			}
		}
		
		override protected function draw():void
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_SIZE))
			{
				for (var i:int = 0; i < itemRenderers.length; i++)
				{
					var itemRenderer:InventoryItemRenderer = itemRenderers[i];
					itemRenderer.x = getXForIndex(i);
					itemRenderer.y = getYForIndex(i);
				}
			}
		}
		
		static public function getYForIndex(i:int):Number 
		{
			return (int(i / 4) * 261 + 124) * pxScale;
		}
		
		static public function getXForIndex(i:int):Number
		{
			return (int(i % 4) * 218 + 128) * pxScale;
		}
		
		override public function get data():Object 
		{
			return super.data;
		}
		
		override public function set data(value:Object):void 
		{
			if (_data is EventDispatcher)
				removeListeners(_data as EventDispatcher);
				
			super.data = value;
			
			if (_data is EventDispatcher)
				addListeners(_data as EventDispatcher);
				
			if (data) {
				gameManager.skinningData.addEventListener(SkinningData.EVENT_CARD_SKIN_CHANGED, handler_updateSelected);
				gameManager.skinningData.addEventListener(SkinningData.EVENT_DAUBER_SKIN_CHANGED, handler_updateSelected);
				gameManager.skinningData.addEventListener(SkinningData.EVENT_VOICEOVER_CHANGED, handler_updateSelected); 
			}
			else {
				gameManager.skinningData.removeEventListener(SkinningData.EVENT_CARD_SKIN_CHANGED, handler_updateSelected);
				gameManager.skinningData.removeEventListener(SkinningData.EVENT_DAUBER_SKIN_CHANGED, handler_updateSelected);
				gameManager.skinningData.removeEventListener(SkinningData.EVENT_VOICEOVER_CHANGED, handler_updateSelected); 
			}
		}
		
		private function addListeners(data:EventDispatcher):void 
		{
			data.addEventListener(InventoryItemsPageRenderer.SHOW_ITEM, data_showItemHandler);
			data.addEventListener(InventoryItemsPageRenderer.HIDE_ITEM, data_hideItemHandler);
		}
		
		private function removeListeners(data:EventDispatcher):void 
		{
			data.removeEventListener(InventoryItemsPageRenderer.SHOW_ITEM, data_showItemHandler);
			data.removeEventListener(InventoryItemsPageRenderer.HIDE_ITEM, data_hideItemHandler);
		}
		
		private function data_hideItemHandler(e:Event):void 
		{
			for each (var itemRenderer:InventoryItemRenderer in itemRenderers) 
			{
				if (itemRenderer.item.id == (e.data as CustomizerItemBase).id)
					itemRenderer.visible = false;
			}
		}
		
		private function data_showItemHandler(e:Event):void 
		{
			for each (var itemRenderer:InventoryItemRenderer in itemRenderers) 
			{
				if (itemRenderer.item.id == (e.data as CustomizerItemBase).id)
					itemRenderer.visible = true;
			}
		}
		
		private function handler_updateSelected(e:Event):void 
		{
			for each (var itemRenderer:InventoryItemRenderer in itemRenderers) 
			{
				itemRenderer.updateSelected();
			}
		}
	
	}

}