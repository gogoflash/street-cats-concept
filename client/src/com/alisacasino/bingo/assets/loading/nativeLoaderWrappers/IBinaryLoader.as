package com.alisacasino.bingo.assets.loading.nativeLoaderWrappers 
{
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public interface IBinaryLoader extends ILoaderWrapper 
	{
		function getBinaryData():ByteArray;
	}
	
}