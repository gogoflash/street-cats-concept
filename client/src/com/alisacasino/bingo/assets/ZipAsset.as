package com.alisacasino.bingo.assets 
{
	import com.alisacasino.bingo.assets.loading.assetLoaders.BinaryAssetLoader;
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;
	import flash.utils.ByteArray;
	
	public class ZipAsset extends BinaryAssetLoader 
	{
		private var _zip:FZip;
		private var canRemoveBinaryData:Boolean;
		
		public function ZipAsset(uri:String) 
		{
			super(uri);
		}
		
		override public function process():void 
		{
			extractBinaryData();
			
			if (!getBinaryData())
			{
				onFailedProcessing();
				return;
			}
			
			try
			{
				_zip = new FZip();
				_zip.loadBytes(getBinaryData());
			}
			catch (e:Error)
			{
				sosTrace( "Error while uploading ZIP data : " + e + " - " + uri, SOSLog.ERROR);
				onFailedProcessing();
				return;
			}
			
			onSuccessfulProcessing();
		}
		
		public function get zip():FZip
		{
			return _zip;
		}
		
		public function get content():Object
		{
			var list:Object = {};
			
			if (!_zip)
				return list;
			
			var length:int = _zip.getFileCount();
			
			var i:int;	
			var zipFile:FZipFile;
			for (i = 0; i < length; i++) 
			{
				zipFile = _zip.getFileAt(i);
				list[zipFile.filename] = zipFile.content;
			}
			
			return list;
		}
		
		public function clear():void {
			canRemoveBinaryData = true;
			cleanupServiceData();
		}
		
		override protected function cleanupServiceData():void 
		{
			super.cleanupServiceData();
			
			if (canRemoveBinaryData) 
			{
				if (getBinaryData())
					getBinaryData().clear();
			
				if(_zip) {
					_zip.close();
					_zip = null;
				}	
				
				canRemoveBinaryData = false;
			}
		}
		
	}

}