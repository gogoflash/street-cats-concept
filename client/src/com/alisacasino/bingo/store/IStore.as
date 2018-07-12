package com.alisacasino.bingo.store
{
	public interface IStore
	{
		function init():void;
		function purchaseItem(item:IStoreItem):void;
		function consumeItem(item:IStoreItem):void;
		
		function get lastPurchaseReceiptObject():Object;
		function get appStoreLink():String;
	}
}