package com.alisacasino.bingo.assets
{
	public interface IAsset
	{
		function load(onComplete:Function, onError:Function, onCompleteArgs:Array = null, onErrorArgs:Array = null):void;
		function purge():void;
		function get isRemovable():Boolean;
		function get loaded():Boolean;
		function getTransferRate():Number;
		
		function get progress():Number;
		function get uri():String;
		function clearListeners():void;
	}
}
