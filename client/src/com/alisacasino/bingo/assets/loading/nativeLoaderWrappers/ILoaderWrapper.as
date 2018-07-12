package com.alisacasino.bingo.assets.loading.nativeLoaderWrappers 
{
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public interface ILoaderWrapper 
	{
		function getURI():String;
		function dispose():void;				
		function addErrorCallback(callback:Function):ILoaderWrapper;
		function addCompleteCallback(callback:Function):ILoaderWrapper;
		function load(uri:String, callback:Function = null, errorCallback:Function = null):void;
		
		function get progress():Number;
		
		function set randomizeResID(value:Boolean):void;
		function get randomizeResID():Boolean;
		
		function set loadType(value:String):void;
		function get loadType():String;
		
		function set retryCount(value:int):void;
		function get retryCount():int;
		
		function get shouldCache():Boolean;
		
		function get disposed():Boolean;
		
		function get transferRate():Number
	}
	
}