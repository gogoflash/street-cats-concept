package com.alisacasino.bingo.screens.inventoryScreenClasses 
{
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import starling.events.EventDispatcher;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class InventoryItemsPage extends EventDispatcher
	{
		
		public var items:Vector.<CustomizerItemBase>;
		public var itemsById:Object;
		public var pageIndex:int;
		
		public function InventoryItemsPage() 
		{
			items = new Vector.<CustomizerItemBase>();
			itemsById = {};
		}
		
		public function addItem(item:CustomizerItemBase):InventoryItemsPage
		{
			items.push(item);
			if(item)
				itemsById[item.id] = item;
			return this;
		}
		
		public function get length():int
		{
			return items.length;
		}
		
	}

}