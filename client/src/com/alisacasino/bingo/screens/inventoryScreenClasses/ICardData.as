package com.alisacasino.bingo.screens.inventoryScreenClasses 
{
	public interface ICardData 
	{
		function get id():int;
		function get name():String;
		function get rarity():int;
		function get rarityString():String;
		function get type():int;
		function get quantity():int;
		function set quantity(value:int):void;
		function get dustGain():Number;
		function get baseBubbleContentClass():Class;
		
		function get setID():int;
		function get defaultItem():Boolean;
		function get itemData():*
		
		function get comingSoon():Boolean;
		function set comingSoon(value:Boolean):void;
		function get awaitBurn():Boolean;
		function set awaitBurn(value:Boolean):void;
		
		function changeQuantity(value:int):void;
	}
	
}