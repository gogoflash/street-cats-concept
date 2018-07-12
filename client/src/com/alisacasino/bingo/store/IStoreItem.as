package com.alisacasino.bingo.store
{
	public interface IStoreItem
	{
		function get itemId():String;
		function get value():int;
		function get totalQuantity():int; 
	}
}