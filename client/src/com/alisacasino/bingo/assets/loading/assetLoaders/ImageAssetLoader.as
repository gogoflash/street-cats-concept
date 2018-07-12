package com.alisacasino.bingo.assets.loading.assetLoaders 
{
	import com.alisacasino.bingo.assets.loading.ResourceType;
	import com.alisacasino.bingo.assets.loading.assetLoaders.AssetLoader;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.IBitmapLoader;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.ILoaderWrapper;
	import com.alisacasino.bingo.utils.LoadUtils;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ImageAssetLoader extends AssetLoader
	{
		private var bitmapLoader:IBitmapLoader;
		
		public function ImageAssetLoader(uri:String)
		{
			super(uri);
		}
		
		public function get bitmapData():BitmapData 
		{
			return bitmapLoader ? bitmapLoader.getBitmapData() : null;
		}
		
		override public function process():void 
		{
			bitmapLoader = currentLoader as IBitmapLoader;
			if (!bitmapLoader)
			{
				sosTrace("Wrong type of loader passed", SOSLog.WARNING);
				onFailedProcessing();
				return;
			}
			if (!bitmapData)
			{
				sosTrace("Bitmap is inaccessible", SOSLog.WARNING);
				onFailedProcessing();
				return;
			}
			onSuccessfulProcessing();
		}
		
		override protected function getResourceType():String 
		{
			return ResourceType.BITMAP;
		}
		
		override public function getBinaryData():ByteArray 
		{
			return bitmapLoader.getBinaryData();
		}
		
		override public function getBinaryDataThrowWorker(callback:Function):void
		{
			bitmapLoader.getBinaryDataThrowWorker(callback);
		}
		
	}

}