package com.alisacasino.bingo.models.scratchCard 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ScratchCell 
	{
		public var attachedMultiplier:int;
		public var scratchItem:ScratchItem;
		
		public function ScratchCell(scratchItem:ScratchItem, attachedMultiplier:int = 1) 
		{
			this.attachedMultiplier = attachedMultiplier;
			this.scratchItem = scratchItem;
		}
		
		public function toString():String 
		{
			return "[ScratchCell attachedMultiplier=" + attachedMultiplier + " scratchItem=" + scratchItem + "]";
		}
		
	}

}