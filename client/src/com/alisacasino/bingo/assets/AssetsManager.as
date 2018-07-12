package com.alisacasino.bingo.assets
{
	import com.alisacasino.bingo.assets.loading.assetIndices.AssetIndexEntry;
	import com.alisacasino.bingo.assets.loading.assetIndices.AssetIndexManager;
	import com.alisacasino.bingo.assets.loading.AssetQueue;
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.screens.IScreen;
	import com.alisacasino.bingo.screens.LoadingScreen;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.NumberUtils;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	import starling.events.EventDispatcher;
	
	public class AssetsManager extends EventDispatcher
	{
		private static var sAssetsManager:AssetsManager = null;
		
		private var trackedAssets:Array = [];
		public var assetIndexManager:AssetIndexManager;
		
		public function AssetsManager() 
		{
			super();
			assetIndexManager = new AssetIndexManager();
		}
		
		public static function get instance():AssetsManager
		{
			if (sAssetsManager == null) {
				sAssetsManager = new AssetsManager();
			}
			return sAssetsManager;
		}
		
		public function checkIfAssetsLoaded(assetList:Array):Boolean
		{
			if (!assetList)
				return false;
			
			for each (var item:IAsset in assetList) 
			{
				if (!item)
					continue;
					
				if (trackedAssets.indexOf(item) == -1)
				{
					return false;
				}
				if (!item.loaded)
				{
					return false;
				}
			}
			return true;
		}
		
		public function loadAssetsForScreen(screen:IScreen, onComplete:Function = null, name:String = "unnamed"):AssetQueue
		{
			sosTrace( "AssetsManager.loadAssetsForScreen: " + screen, SOSLog.DEBUG);
			var assetsToRemove:Array = [];
			var assetsToLoad:Array = screen.requiredAssets;
			
			for each (var asset:IAsset in trackedAssets) {
				if (!asset) 
					continue;
		
				var indexOfAsset:int = assetsToLoad.indexOf(asset);
				if (indexOfAsset == -1) 
				{
					if (asset.isRemovable) assetsToRemove.push(asset);
				} 
				else 
				{
					if (asset.loaded)
					{
						assetsToLoad.splice(indexOfAsset, 1);
					}
				}
			}
			
			if (!PlatformServices.isCanvas)
			{
				!(Game.current.currentScreen is LoadingScreen) ? removeAssets(assetsToRemove) : null;
			}
			
			var assetQueue:AssetQueue = null;
			
			if (assetsToLoad.length > 0)
				assetQueue = loadAssets(assetsToLoad, assetsWasLoaded, name);
			else
				assetsWasLoaded();
			
			function assetsWasLoaded():void
			{
				sosTrace( "AssetsManager.assetsWasLoaded", SOSLog.DEBUG);
				if (PlatformServices.isCanvas)
				{
					removeAssets(assetsToRemove);
				}
				else
				{
					(Game.current.currentScreen is LoadingScreen) ? removeAssets(assetsToRemove) : null;
				}
				
				if (onComplete != null)
				{
					onComplete.call();
				}
			}
			
			return assetQueue;
		}
		
		public function loadAssetsIfNeeded(assetList:Array, onComplete:Function, name:String = "unnamed"):AssetQueue
		{
			var assetsToLoad:Array = [];
			for each (var asset:IAsset in assetList) {
				if (trackedAssets.indexOf(asset) == -1 &&
					assetsToLoad.indexOf(asset) == -1)
					assetsToLoad.push(asset);
			}
			
			if (assetsToLoad.length > 0)
			{
				return loadAssets(assetsToLoad, onComplete, name);
			}
			else
			{
				if (onComplete != null)
				{
					onComplete.call();
				}
			}
			
			return null;
		}
		
		private function loadAssets(assetList:Array, onComplete:Function=null, name:String = "unnamed"):AssetQueue
		{
			for each (var asset:IAsset in assetList) 
			{
				if (trackedAssets.indexOf(asset) == -1)
				{
					if (asset)
						trackedAssets.push(asset);
				}
			}
			
			return new AssetQueue(name).load(assetList, onComplete);
		}
		
		public function stopAllLoading():void
		{
			var i:int = trackedAssets.length;
			while (i--)
			{
				var asset:IAsset = trackedAssets[i];
				if (!asset.loaded)
				{
					asset.clearListeners();
					trackedAssets.removeAt(i);
				}
			}
		}
		
		private function removeAssets(assetList:Array):void
		{
			for each (var asset:IAsset in assetList) 
			{
				if (!asset.isRemovable)
				{
					continue;
				}
				asset.purge();
				var indexOfAsset:int = trackedAssets.indexOf(asset);
				if (indexOfAsset != -1) {
					trackedAssets.splice(indexOfAsset, 1);
				} else
					throw Error("removing asset that is not loaded");
			}
		}
	}
}