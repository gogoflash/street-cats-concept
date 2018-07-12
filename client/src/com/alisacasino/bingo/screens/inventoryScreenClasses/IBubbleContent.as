package com.alisacasino.bingo.screens.inventoryScreenClasses 
{
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public interface IBubbleContent 
	{
		
		function get card():CustomizerItemBase;		
		function set card(value:CustomizerItemBase):void;
	}
	
}