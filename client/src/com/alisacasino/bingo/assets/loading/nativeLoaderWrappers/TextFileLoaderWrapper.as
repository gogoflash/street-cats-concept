package com.alisacasino.bingo.assets.loading.nativeLoaderWrappers 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class TextFileLoaderWrapper extends FileLoaderWrapper implements ITextLoader
	{
		private var _text:String;
		
		public function TextFileLoaderWrapper() 
		{
			super();
		}
		
		
		/* INTERFACE com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.ITextLoader */
		
		public function getText():String 
		{
			return _text;
		}
		
		override protected function parseBinaryData(data:ByteArray):void 
		{
			try
			{
				_text = data.readUTFBytes(data.length);
				data.clear();
			}
			catch (e:Error)
			{
				sosTrace("Error while getting text from the binary data " + e, SOSLog.ERROR);
				fail();
				return;
			}
			
			complete();
		}
		
	}

}