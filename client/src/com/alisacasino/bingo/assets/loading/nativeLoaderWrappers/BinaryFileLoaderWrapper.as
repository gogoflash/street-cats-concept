package com.alisacasino.bingo.assets.loading.nativeLoaderWrappers 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class BinaryFileLoaderWrapper extends FileLoaderWrapper
	{
		public function BinaryFileLoaderWrapper() 
		{
			super();
		}
		
		override protected function parseBinaryData(data:ByteArray):void 
		{
			complete();
		}
		
	}

}