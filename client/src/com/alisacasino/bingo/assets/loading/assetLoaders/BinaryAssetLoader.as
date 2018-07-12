package com.alisacasino.bingo.assets.loading.assetLoaders 
{
	import avmplus.getQualifiedClassName;
	import com.alisacasino.bingo.assets.loading.ResourceType;
	import com.alisacasino.bingo.assets.loading.assetLoaders.AssetLoader;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.BinaryFileLoaderWrapper;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.BinaryLoaderWrapper;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.IBinaryLoader;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.ILoaderWrapper;
	import com.alisacasino.bingo.utils.LoadUtils;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class BinaryAssetLoader extends AssetLoader
	{
		
		protected var binaryLoader:IBinaryLoader;
		private var _binaryData:ByteArray;
		
		public function BinaryAssetLoader(uri:String) 
		{
			super(uri);
		}
		
		override public function getBinaryData():ByteArray 
		{
			return _binaryData;
		}
		
		override protected function getResourceType():String 
		{
			return ResourceType.BINARY_DATA;
		}
		
		override public function process():void 
		{
			extractBinaryData();
			if (_binaryData)
			{
				if (checkConcreteAsset(_binaryData))
				{
					onSuccessfulProcessing();
				}
				else
				{
					onFailedProcessing();
				}
			}
			else
			{
				onFailedProcessing();
			}
		}
		
		protected function checkConcreteAsset(binaryData:ByteArray):Boolean
		{
			return true;
		}
		
		protected function extractBinaryData():void
		{
			binaryLoader = currentLoader as IBinaryLoader;
			if (!binaryLoader)
			{
				sosTrace("Wrong type of loader passed", SOSLog.WARNING);
				return;
			}
			_binaryData = binaryLoader.getBinaryData();
			if (!_binaryData)
			{
				sosTrace("Binary data is inaccessible", SOSLog.WARNING);
			}
		}
		
		override public function dispose():void 
		{
			if (_binaryData)
			{
				_binaryData.clear();
			}
			super.dispose();
		}
		
	}

}