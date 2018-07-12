package com.alisacasino.bingo.screens.collectionsScreenClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.ImageAsset;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.models.collections.CollectionItem;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.CardItemRenderer;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.ICardData;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.ICardRenderer;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CollectionItemRenderer extends CardItemRenderer implements ICardRenderer
	{
		private var _item:CollectionItem;
		
		public function CollectionItemRenderer() 
		{
			setSizeInternal(176 * pxScale, 214 * pxScale, false);
		}
		
		public function get item():CollectionItem 
		{
			return _item;
		}
		
		public function set item(value:CollectionItem):void 
		{
			if (_item != value)
			{
				if (_item && _item.image)
				{
					_item.image.removeCompleteCallback(onImageLoaded);
				}
				
				_item = value;
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		override public function get cardItem():ICardData
		{
			return _item;
		}
		
		override public function get cardAsset():ImageAsset
		{
			return _item ? _item.image : null;
		}
		
		public function get isSelectedView():Boolean {
			return false;
		}
		
	
		override protected function get hasItem():Boolean
		{
			return item && item.owned;
		}
		
		override protected function get countBackgroundWidth():Number 
		{
			return 68 * pxScale;
		}

		override protected function get burnAnimationContainer():DisplayObjectContainer {
			var container:DisplayObject = DialogsManager.instance.getDialogByClass(CollectionsScreen);
			return container ? (container as DisplayObjectContainer) : null;
		}
		
		override protected function get countLabelText():String {
			return 'X ' + (item ? item.duplicates.toString() : '');
		}
		
		override protected function get cardBackSource():Object {
			return (item && item.collection) ? item.collection.cardBack : null;
		}
		
		override protected function commitData():void 
		{
			super.commitData();
			
			if (item && item.owned)
			{
				countBackground.texture = AtlasAsset.CommonAtlas.getTexture(item.duplicates >= 2 ? "dialogs/collections/green_badge" : "dialogs/collections/blue_badge");
			}	
		}	
	}

}