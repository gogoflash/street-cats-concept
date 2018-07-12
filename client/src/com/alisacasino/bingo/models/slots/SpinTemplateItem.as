package com.alisacasino.bingo.models.slots 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class SpinTemplateItem 
	{
		public var type:String;
		public var associatedSlotItem:String;
		public var maxRepeat:int;
		
		static public const ALISA:SpinTemplateItem = new SpinTemplateItem(CONCRETE_ITEM, SlotItem.ALISA_ICON);
		static public const COIN:SpinTemplateItem = new SpinTemplateItem(CONCRETE_ITEM, SlotItem.COIN);
		static public const NOT_COIN:SpinTemplateItem = new SpinTemplateItem(NOT_CONCRETE_ITEM, SlotItem.COIN);
		static public const ENERGY:SpinTemplateItem = new SpinTemplateItem(CONCRETE_ITEM, SlotItem.ENERGY);
		static public const TICKET:SpinTemplateItem = new SpinTemplateItem(CONCRETE_ITEM, SlotItem.TICKET);
		static public const KEY:SpinTemplateItem = new SpinTemplateItem(CONCRETE_ITEM, SlotItem.KEY);
		static public const STAR:SpinTemplateItem = new SpinTemplateItem(CONCRETE_ITEM, SlotItem.STAR);
		
		static public const CONCRETE_ITEM:String = "concreteItem";
		static public const NOT_CONCRETE_ITEM:String = "notConcreteItem";
		
		public function SpinTemplateItem(type:String, associatedSlotItem:String, maxRepeat:int = 2) 
		{
			super();
			this.type = type;
			this.associatedSlotItem = associatedSlotItem;
			this.maxRepeat = maxRepeat;
		}
		
		public function toString():String 
		{
			return "[SpinTemplateItem type=" + type + " associatedSlotItem=" + associatedSlotItem + " maxRepeat=" + maxRepeat + 
						"]";
		}
		
	}

}