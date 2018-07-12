package com.alisacasino.bingo.assets.loading.nativeLoaderWrappers 
{
	import com.alisacasino.bingo.assets.AssetsManager;
	import com.alisacasino.bingo.assets.loading.assetIndices.AssetIndexEntry;
	import com.alisacasino.bingo.utils.Constants;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	internal class RemoteLoaderWrapperBase extends LoaderWrapperBase
	{
		static public const REMOTE_LOADER_RETRY_COUNT:int = 2;
		
		public function RemoteLoaderWrapperBase() 
		{
			super();
			retryCount = REMOTE_LOADER_RETRY_COUNT;
		}
		
		private var _remoteURI:String;
		
		public function getRemoteURI():String
		{
			if (!_remoteURI)
			{
				_remoteURI = resolveRemoteURI();
			}
			
			return _remoteURI;
		}
		
		private function resolveRemoteURI():String
		{
			var assetIndexEntry:AssetIndexEntry;
			if (randomizeResID)
			{
				assetIndexEntry = AssetsManager.instance.assetIndexManager.getRandomizedIndexEntry(Constants.assetsURL + getURI());
			}
			else 
			{
				assetIndexEntry = AssetsManager.instance.assetIndexManager.getServerAssetIndexEntryByURI(getURI());
			}
			
			var assetsUrl:String = Constants.assetsURL;
			var cdnPath:String =  assetIndexEntry.cdnPath;
			if (!cdnPath)
			{
				cdnPath = "last-cdn/";
			}
			if (Constants.USE_LOCAL_ASSETS) {
				if (getURI().indexOf('720/atlases') != -1 || getURI().indexOf('480/atlases') != -1 || getURI().indexOf('particles') != -1)
				{
					assetsUrl = Constants.localAssetsURL;
					cdnPath = "";
				}
			}
			
			if (Constants.USE_LOCAL_SKINS_ASSETS) {
				if (getURI().indexOf('720/skins') != -1 || getURI().indexOf('480/skins') != -1)
				{
					assetsUrl = Constants.localAssetsURL;
					cdnPath = "";
				}
			}
			
			if (Constants.USE_LOCAL_IMAGES_ASSETS) {
				if (getURI().indexOf('720/images') != -1 || getURI().indexOf('480/images') != -1 || getURI().indexOf('backgrounds') != -1)
				{
					assetsUrl = Constants.localAssetsURL;
					cdnPath = "";
				}
			}
			
			if (Constants.USE_LOCAL_ANIMATION_ASSETS) {
				if (getURI().indexOf('720/animations') != -1 || getURI().indexOf('480/animations') != -1) 
				{
					assetsUrl = Constants.localAssetsURL;
					cdnPath = "";
				}
			}
			
			if (Constants.USE_LOCAL_SOUND_ASSETS) {
				if (getURI().indexOf('sounds/') != -1) 
				{
					assetsUrl = Constants.localAssetsURL;
					cdnPath = "";
				}
			}
			
		/*	if (getURI().indexOf('bingo_lite') != -1)
				return assetsUrl + cdnPath + getURI().replace('720', '480') + "?res=" + assetIndexEntry.timestamp + assetIndexEntry.size;*/
			
			var pathResult:String = assetsUrl + cdnPath + getURI() + "?res=" + assetIndexEntry.timestamp + assetIndexEntry.size;
			sosTrace('load resource path: ', pathResult);
			return pathResult;
		}
		
	}

}