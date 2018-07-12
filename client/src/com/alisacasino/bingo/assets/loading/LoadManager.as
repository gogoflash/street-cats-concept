package com.alisacasino.bingo.assets.loading 
{
	import air.update.descriptors.ApplicationDescriptor;
	import com.alisacasino.bingo.assets.ImageAsset;
	import com.alisacasino.bingo.assets.loading.assetLoaders.AssetLoader;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.BinaryFileLoaderWrapper;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.BinaryLoaderWrapper;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.BitmapFileLoaderWrapper;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.BitmapLoaderWrapper;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.IBinaryLoader;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.IBitmapLoader;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.ILoaderWrapper;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.ITextLoader;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.TextFileLoaderWrapper;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.TextLoaderWrapper;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.helpers.FileLoaderQueue;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.SignInMessage.Platform;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.LoadUtils;
	import com.alisacasino.bingo.utils.TimeService;
	import flash.utils.getTimer;
	import starling.core.Starling;
	import starling.events.Event;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class LoadManager 
	{
		static public const IMAGE_ASSETS_COUNT_LIMIT:int = 20971520;//20 MB in bytes
		private static var _instance:LoadManager;
		
		public static function get instance():LoadManager 
		{
			if (!_instance)
			{
				_instance = new LoadManager();
			}
			return _instance;
		}
		
		private var loadersByResourceType:Object;
		
		private var imageAssetByName:Object;
		private var unusedAssets:Array;
		
		public var loadQueue:FileLoaderQueue;
		
		public function LoadManager() 
		{
			loadersByResourceType = { };
			
			imageAssetByName = { };
			
			if (!PlatformServices.isCanvas)
			{
				loadQueue = new FileLoaderQueue();
			}
			
			var bitmapLoaders:Object = { };
			bitmapLoaders[LoadUtils.CACHED_LOAD] = BitmapFileLoaderWrapper;
			bitmapLoaders[LoadUtils.LOCAL_LOAD] = BitmapFileLoaderWrapper;
			bitmapLoaders[LoadUtils.REMOTE_LOAD] = BitmapLoaderWrapper;
			loadersByResourceType[ResourceType.BITMAP] = bitmapLoaders;
			
			var binaryLoaders:Object = { };
			binaryLoaders[LoadUtils.CACHED_LOAD] = BinaryFileLoaderWrapper;
			binaryLoaders[LoadUtils.LOCAL_LOAD] = BinaryFileLoaderWrapper;
			binaryLoaders[LoadUtils.REMOTE_LOAD] = BinaryLoaderWrapper;
			loadersByResourceType[ResourceType.BINARY_DATA] = binaryLoaders;
			
			var textLoaders:Object = { };
			textLoaders[LoadUtils.CACHED_LOAD] = TextFileLoaderWrapper;
			textLoaders[LoadUtils.LOCAL_LOAD] = TextFileLoaderWrapper;
			textLoaders[LoadUtils.REMOTE_LOAD] = TextLoaderWrapper;
			loadersByResourceType[ResourceType.TEXT] = textLoaders;
		}
		
		public function getBitmapLoader(loadType:String):IBitmapLoader
		{
			return getNativeLoader(ResourceType.BITMAP, loadType) as IBitmapLoader;
		}
		
		public function getBinaryLoader(loadType:String):IBinaryLoader
		{
			return getNativeLoader(ResourceType.BINARY_DATA, loadType) as IBinaryLoader;
		}
		
		public function getTextLoader(loadType:String):ITextLoader
		{
			return getNativeLoader(ResourceType.TEXT, loadType) as ITextLoader;
		}
		
		public function getNativeLoader(resourceType:String, loadType:String):ILoaderWrapper
		{
			var loaderClass:Class = loadersByResourceType[resourceType][loadType];
			var concreteLoader:ILoaderWrapper = new loaderClass();
			concreteLoader.loadType = loadType;
			return concreteLoader;
		}
		
		public function getNativeLoaderClass(resourceType:String, loadType:String):Class 
		{
			return loadersByResourceType[resourceType][loadType];
		}
		
		public function getImageAssetByName(name:String, parent:Object = null):ImageAsset 
		{
			var imageAsset:ImageAsset = imageAssetByName[name];
			if (!imageAsset)
			{
				imageAsset = new ImageAsset(name);
				imageAssetByName[name] = imageAsset;
			}
			imageAsset.addParent(parent);
			imageAsset.addParentRemoveCallback(cleanExcessImageAssets);
			
			cleanExcessImageAssets();
			
			return imageAsset;
		}
		
		public function releasePurgeLock(id:String):void
		{
			for each (var item:ImageAsset in imageAssetByName) 
			{
				item.releasePurgeLock(id);
			}
		}
		
		public function releaseParent(parent:*):void
		{
			for each (var item:ImageAsset in imageAssetByName) 
			{
				item.removeParent(parent);
			}
		}
		
		private function cleanExcessImageAssets():void
		{
			var imageAssetsListSize:Number = 0;
			
			if (!unusedAssets)
			{
				unusedAssets = [];
			}
			
			unusedAssets.length = 0;
			
			for each(var imageAsset:ImageAsset in imageAssetByName) 
			{
				if (imageAsset && !imageAsset.disposed)
				{
					imageAssetsListSize += imageAsset.imageSize;
					
					if (!imageAsset.isInUse() && !imageAsset.hasPurgeLock())
					{
						if (imageAsset.lastUsageTimestamp == 0)
						{
							imageAsset.lastUsageTimestamp = TimeService.serverTimeMs;
						}
						
						unusedAssets.push(imageAsset);
					}
					else
					{
						imageAsset.lastUsageTimestamp = 0;
					}
				}
			}
			if (imageAssetsListSize > IMAGE_ASSETS_COUNT_LIMIT)
			{
				if(!TimeService.hasOneSecondCallback(cleanExcessImageAssets))
					TimeService.addOneSecondCallback(cleanExcessImageAssets);
				
				for (var i:int = 0; i < unusedAssets.length; i++) 
				{
					(unusedAssets[i] as ImageAsset).purge();
				}
				
				//TODO: sort by last access time, remove only until we fit into the limit
			}
			else
			{
				if(TimeService.hasOneSecondCallback(cleanExcessImageAssets))
					TimeService.removeOneSecondCallback(cleanExcessImageAssets);
			}
		}
		
	}

}