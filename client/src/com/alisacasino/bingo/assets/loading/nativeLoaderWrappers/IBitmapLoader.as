package com.alisacasino.bingo.assets.loading.nativeLoaderWrappers 
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public interface IBitmapLoader extends ILoaderWrapper
	{
		
		function getBitmapData():BitmapData;
		function getBinaryData():ByteArray;
		function getBinaryDataThrowWorker(callback:Function):void;
	}
	
}