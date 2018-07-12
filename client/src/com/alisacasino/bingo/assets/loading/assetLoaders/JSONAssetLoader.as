package com.alisacasino.bingo.assets.loading.assetLoaders 
{
	import com.alisacasino.bingo.assets.loading.ResourceType;
	import com.alisacasino.bingo.assets.loading.assetLoaders.AssetLoader;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.IBinaryLoader;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.ILoaderWrapper;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.ITextLoader;
	import com.alisacasino.bingo.utils.LoadUtils;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class JSONAssetLoader extends AssetLoader
	{
		private var textLoader:ITextLoader;
		
		private var _object:Object;
		private var _rawData:String;
		
		public function JSONAssetLoader(uri:String)
		{
			super(uri);
		}
		
		public function get rawJSONData():String
		{
			return _rawData;
		}
		
		public function get object():Object
		{
			return _object;
		}
		
		override protected function getResourceType():String 
		{
			return ResourceType.TEXT;
		}
		
		override public function process():void 
		{
			textLoader = currentLoader as ITextLoader;
			if (!textLoader)
			{
				sosTrace("Wrong type of loader passed", SOSLog.WARNING);
				onFailedProcessing();
				return;
			}
			_rawData = textLoader.getText();
			if (!_rawData)
			{
				sosTrace("Text data is inaccessible", SOSLog.WARNING);
				onFailedProcessing();
				return;
			}
			
			try
			{
				_object = JSON.parse(rawJSONData);
			}
			catch (e:Error)
			{
				sosTrace("Error while parsing JSON : " + e.name + ", " + e.message, SOSLog.WARNING);
				onFailedProcessing();
				return;
			}
			
			onSuccessfulProcessing();
		}
		
		override public function getBinaryData():ByteArray 
		{
			if (getCurrentLoaderAsIBinaryLoader())
			{
				return getCurrentLoaderAsIBinaryLoader().getBinaryData();
			}
			else 
			{
				var byteArray:ByteArray = new ByteArray();
				byteArray.writeUTFBytes(_rawData);
				return byteArray;
			}
		}
		
		private function getCurrentLoaderAsIBinaryLoader():IBinaryLoader
		{
			return currentLoader as IBinaryLoader;
		}
		
		override protected function cleanupServiceData():void 
		{
			super.cleanupServiceData();
			if (getCurrentLoaderAsIBinaryLoader())
			{
				if (getCurrentLoaderAsIBinaryLoader().getBinaryData())
				{
					getCurrentLoaderAsIBinaryLoader().getBinaryData().clear();
				}
			}
		}
		
		override public function dispose():void 
		{
			_rawData = null;
			_object = null;
			super.dispose();
		}
		
	}

}