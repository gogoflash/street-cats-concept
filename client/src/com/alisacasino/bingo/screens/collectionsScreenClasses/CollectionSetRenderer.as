package com.alisacasino.bingo.screens.collectionsScreenClasses
{
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.controls.AnimatedImageAssetContainer;
	import com.alisacasino.bingo.controls.ImageAssetContainer;
	import com.alisacasino.bingo.dialogs.CollectionPageRewardDialog;
	import com.alisacasino.bingo.models.collections.Collection;
	import com.alisacasino.bingo.models.collections.CollectionItem;
	import com.alisacasino.bingo.models.collections.CollectionPage;
	import feathers.controls.NumericStepper;
	import feathers.controls.renderers.LayoutGroupListItemRenderer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.textures.Texture;
	import starling.utils.Align;
	;
	;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CollectionSetRenderer extends LayoutGroupListItemRenderer
	{
		private var itemRenderers:Vector.<CollectionItemRenderer>;
		//private var unknownItemTexture:Texture;
		
		public function CollectionSetRenderer()
		{
			itemRenderers = new Vector.<CollectionItemRenderer>();
			
			//unknownItemTexture = AtlasAsset.CommonAtlas.getTexture("dialogs/collections/unknown_item");
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			for (var i:int = 0; i < 8; i++)
			{
				var itemRenderer:CollectionItemRenderer = new CollectionItemRenderer();
				itemRenderer.index = i;
				itemRenderers.push(itemRenderer);
				addChild(itemRenderer);
				itemRenderer.addEventListener(Event.TRIGGERED, itemRenderer_triggeredHandler);
			}
		}
		
		private function itemRenderer_triggeredHandler(e:Event):void 
		{
			dispatchEventWith(CollectionsScreen.SHOW_CARD_OVERLAY, true, e.currentTarget as CollectionItemRenderer);
		}
		
		override protected function commitData():void
		{
			super.commitData();
			
			var collection:CollectionPage = data as CollectionPage;
			if (!collection)
			{
				return;
			}
			
			for (var i:int = 0; i < itemRenderers.length; i++) 
			{
				itemRenderers[i].item = collection.items[i];
			}
		}
		
		override protected function draw():void
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_SIZE))
			{
				for (var i:int = 0; i < itemRenderers.length; i++)
				{
					var itemRenderer:CollectionItemRenderer = itemRenderers[i];
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
			return (int(i % 4) * 218 + 121) * pxScale;
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
		}
		
		private function addListeners(data:EventDispatcher):void 
		{
			data.addEventListener(CollectionPage.SHOW_ITEM, data_showItemHandler);
			data.addEventListener(CollectionPage.HIDE_ITEM, data_hideItemHandler);
		}
		
		private function removeListeners(data:EventDispatcher):void 
		{
			data.removeEventListener(CollectionPage.SHOW_ITEM, data_showItemHandler);
			data.removeEventListener(CollectionPage.HIDE_ITEM, data_hideItemHandler);
		}
		
		private function data_hideItemHandler(e:Event):void 
		{
			for each (var itemRenderer:CollectionItemRenderer in itemRenderers) 
			{
				if (itemRenderer.item.id == (e.data as CollectionItem).id)
					itemRenderer.visible = false;
			}
		}
		
		private function data_showItemHandler(e:Event):void 
		{
			for each (var itemRenderer:CollectionItemRenderer in itemRenderers) 
			{
				if (itemRenderer.item.id == (e.data as CollectionItem).id)
					itemRenderer.visible = true;
			}
		}
	
	}

}