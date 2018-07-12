package com.alisacasino.bingo.assets.loading.nativeLoaderWrappers 
{
	import flash.net.URLLoaderDataFormat;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class TextLoaderWrapper extends URLLoaderWrapper implements ITextLoader
	{
		
		
		public function TextLoaderWrapper() 
		{
			super();
		}
		
		
		/* INTERFACE com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.ITextLoader */
		
		public function getText():String 
		{
			return urlLoader.data as String;
		}
		
		override protected function getDataFormat():String 
		{
			return URLLoaderDataFormat.TEXT;
		}
		
	}

}