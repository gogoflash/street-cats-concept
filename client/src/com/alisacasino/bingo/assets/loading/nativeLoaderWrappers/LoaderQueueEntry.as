package com.alisacasino.bingo.assets.loading.nativeLoaderWrappers 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class LoaderQueueEntry 
	{
		public var loadType:String;
		public var loaderClass:Class;
		
		public function LoaderQueueEntry(loaderClass:Class, loadType:String) 
		{
			this.loadType = loadType;
			this.loaderClass = loaderClass;
		}
		
	}

}