package com.alisacasino.bingo.assets.loading.nativeLoaderWrappers 
{
	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class BinaryLoaderWrapper extends URLLoaderWrapper implements IBinaryLoader
	{
		private var _binaryData:ByteArray;
		
		public function BinaryLoaderWrapper() 
		{
			super();
		}
		
		override protected function getDataFormat():String 
		{
			return URLLoaderDataFormat.BINARY;
		}
		
		override protected function urlLoader_completeHandler(e:Event):void 
		{
			_binaryData = urlLoader.data as ByteArray;
			
			super.urlLoader_completeHandler(e);
		}
		
		public function getBinaryData():ByteArray
		{
			return _binaryData;
		}
		
		override public function dispose():void 
		{
			if (getBinaryData())
			{
				getBinaryData().clear();
			}
			super.dispose();
		}
		
	}

}