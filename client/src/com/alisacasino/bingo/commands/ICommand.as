package com.alisacasino.bingo.commands 
{
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public interface ICommand 
	{
		
		function execute(callback:Function = null, errorCallback:Function = null):ICommand;
		function stop():void;
		function addCompleteCallback(callback:Function):ICommand;
		function addProgressCallback(callback:Function):ICommand;
		function addErrorCallback(callback:Function):ICommand;
		function removeCompleteCallback(callback:Function):ICommand;
		function removeErrorCallback(callback:Function):ICommand;
		function removeProgressCallback(callback:Function):ICommand;
		
		function get failed():Boolean;
		function set finishOnFail(value:Boolean):void;
		function get finishOnFail():Boolean;
		function get finished():Boolean;
		function get running():Boolean;
		function get progress():Number;
	}
	
}