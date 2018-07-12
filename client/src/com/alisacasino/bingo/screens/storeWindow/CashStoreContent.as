package com.alisacasino.bingo.screens.storeWindow 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.storeWindow.cash.BigBlueItem;
	import com.alisacasino.bingo.screens.storeWindow.cash.CashStorePlaque;
	import com.alisacasino.bingo.screens.storeWindow.cash.SmallBlueItem;
	import com.alisacasino.bingo.store.items.CashStoreItem;
	import feathers.core.FeathersControl;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CashStoreContent extends FeathersControl
	{
		private var animationDelay:Number;
		private var background:Image;
		private var items:Array;
		
		public function CashStoreContent(animationDelay:Number) 
		{
			this.animationDelay = animationDelay;
			items = [];
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			background = new Image(AtlasAsset.CommonAtlas.getTexture("store/grey_background_white_frame"));
			background.scale9Grid = ResizeUtils.getScaledRect(28, 23, 2, 2);
			background.x = 11 * pxScale;
			background.y = 4 * pxScale;
			background.width = 895 * pxScale;
			background.height = 590 * pxScale;
			addChild(background);
			
			var cashItems:Vector.<CashStoreItem> = gameManager.storeData.cashItems;
			
			for (var i:int = 0; i < 3; i++) 
			{
				if (cashItems.length > i)
				{
					addItem(SmallBlueItem, cashItems[i], AtlasAsset.CommonAtlas.getTexture("store/cash_icons/icon" + (i + 1)), (21 + 300 * i) * pxScale , 11 * pxScale).animateAppearance(animationDelay + 0.1 + i * 0.05);
				}
			}
			
			for (i = 0; i < 3; i++) 
			{
				if (cashItems.length > i+3)
				{
					addItem(BigBlueItem, cashItems[i+3], AtlasAsset.CommonAtlas.getTexture("store/cash_icons/icon" + (i+4)), (21 + 300*i)*pxScale , 250*pxScale).animateAppearance(animationDelay + 0.25 + i * 0.05);
				}
			}
			
			if (animationDelay > 0)
			{
				Starling.juggler.delayCall(addChildren, animationDelay);
			}
			else
			{
				addChildren();
			}
		}
		
		private function addChildren():void 
		{
			addChild(background);
			for each (var item:CashStorePlaque in items) 
			{
				addChild(item);
			}
		}
		
		private function addItem(itemClass:Class, cashStoreItem:CashStoreItem, icon:Texture, itemX:Number = 0, itemY:Number = 0):CashStorePlaque 
		{
			var item:CashStorePlaque = new itemClass();
			item.storeItem = cashStoreItem;
			item.icon = icon;
			item.x = itemX;
			item.y = itemY;
			items.push(item);
			item.validate();
			return item;
		}
		
	}

}