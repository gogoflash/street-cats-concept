package com.alisacasino.bingo.assets.loading.assetLoaders 
{
	import avmplus.getQualifiedClassName;
	import com.alisacasino.bingo.assets.AssetsManager;
	import com.alisacasino.bingo.assets.loading.LoadManager;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.ILoaderWrapper;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.LoaderQueueEntry;
	import com.alisacasino.bingo.commands.ICommand;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.utils.InternalStorageAPI;
	import com.alisacasino.bingo.utils.LoadUtils;
	import com.alisacasino.bingo.utils.backgroundThread.BackgroundThreadManager;
	import com.alisacasino.bingo.utils.misc.CallbackContainer;
	import flash.utils.ByteArray;
	import starling.core.Starling;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class AssetLoader extends CommandBase
	{
		protected var _uri:String;
		protected var _disposed:Boolean;
		
		private var callbackContainer:CallbackContainer;
		private var loaderQueue:Vector.<LoaderQueueEntry>;
		private var forceCacheSave:Boolean;
		private var savingCache:Boolean;
		private var disposeAfterCacheSave:Boolean;
		protected var currentLoader:ILoaderWrapper;
		
		public var randomizeResID:Boolean = false;
		
		public function AssetLoader(uri:String) 
		{
			super();
			warnOnStop = false;
			finishOnFail = true;
			_uri = uri;
			callbackContainer = new CallbackContainer();
		}
		
		public function get disposed():Boolean 
		{
			return _disposed;
		}
		
		public function get uri():String 
		{
			return _uri;
		}
		
		public function load(callback:Function = null, errorCallback:Function = null):ICommand
		{
			execute(callback, errorCallback);
			return this;
		}
		
		override protected function startExecution():void 
		{
			if (disposed)
			{
				throw new Error("Trying to load a disposed asset loader");
				return;
			}
			super.startExecution();
			getLoaderQueueAndLoad();
		}
		
		protected function getLoaderQueueAndLoad():void 
		{
			loaderQueue = LoadUtils.getLoaderPreferenceQueue(getResourceType(), uri);
			tryNextSource();
		}
		
		private function tryNextSource():void 
		{
			if (loaderQueue && loaderQueue.length)
			{
				var loaderQueueEntry:LoaderQueueEntry = loaderQueue.shift();
				var loaderClass:Class = loaderQueueEntry.loaderClass
				currentLoader = new loaderClass() as ILoaderWrapper;
				currentLoader.randomizeResID = randomizeResID;
				currentLoader.loadType = loaderQueueEntry.loadType;
				loadWithLoader(currentLoader);
				//sosTrace("AssetLoader.tryNextSource URI: ", loaderQueueEntry.loadType, uri, SOSLog.INFO);
			}
			else 
			{
				//sosTrace("AssetLoader All loader variants exhausted, failing. URI: " + uri, SOSLog.ERROR);
				fail();
			}
		}
		
		public function getTransferRate():Number
		{
			if (currentLoader)
				return currentLoader.transferRate;
			
			return -1;
		}
		
		private function loadWithLoader(loader:ILoaderWrapper):void 
		{
			loader.load(uri, onComplete, onError);
		}
		
		protected function onError(loaderWrapper:ILoaderWrapper):void 
		{
			//sosTrace( "AssetLoader.onError " + uri + " > loaderWrapper : " + getQualifiedClassName(loaderWrapper) + ", loadType : " + loaderWrapper.loadType, SOSLog.WARNING);
			if (canRetry(currentLoader))
			{
				retry(currentLoader);
				return;
			}
			if (loaderWrapper.loadType == LoadUtils.CACHED_LOAD)
			{
				forceCacheSave = true;
			}
			disposeLoaderAndTryNext();
		}
		
		private function canRetry(currentLoader:ILoaderWrapper):Boolean 
		{
			return currentLoader && currentLoader.retryCount > 0;
		}
		
		private function retry(currentLoader:ILoaderWrapper):void 
		{
			//sosTrace( "AssetLoader Retrying " + uri + " > currentLoader : " + currentLoader.loadType, SOSLog.DEBUG);
			if (!currentLoader)
			{
				sosTrace( "AssetLoader.retry called with no currentLoader.", SOSLog.ERROR);
				disposeLoaderAndTryNext();
				return;
			}
			currentLoader.retryCount--;
			currentLoader.dispose();
			Starling.current.juggler.delayCall(loadWithLoader, 0.001, currentLoader);
		}
		
		private function disposeLoaderAndTryNext():void 
		{
			if(currentLoader)
				currentLoader.dispose();
			
			tryNextSource();
		}
		
		protected function onComplete(loaderWrapper:ILoaderWrapper):void 
		{
			//sosTrace( "AssetLoader.onComplete " + uri + " > loaderWrapper : " + getQualifiedClassName(loaderWrapper) + ", loadType : " + loaderWrapper.loadType, SOSLog.DEBUG);
			addToProcessQueue();
		}
		
		private function addToProcessQueue():void 
		{
			gameManager.backgroundThreadManager.addNormalPriorityFunction(process);
		}
		
		public function process():void
		{
			throw new Error("AssetLoader.process() must be overridden in subclasses");
		}
		
		protected function onSuccessfulProcessing():void
		{
			if (!currentLoader)
			{
				fail();
				return;
			}
			if (currentLoader.loadType == LoadUtils.REMOTE_LOAD || currentLoader.shouldCache)
			{
				cacheAsset();
			}
			else
			{
				cleanupServiceData();
			}
			finish();
		}
		
		protected function cleanupServiceData():void 
		{
			
		}
		
		override public function get progress():Number 
		{
			if (currentLoader)
			{
				return currentLoader.progress;
			}
			return 0;
		}
		
		protected function onFailedProcessing():void
		{
			//sosTrace("AssetLoader Failed to process finished loader wrapper " + getQualifiedClassName(currentLoader), canRetry(currentLoader), uri, SOSLog.WARNING);
			if (canRetry(currentLoader))
			{
				retry(currentLoader);
				return;
			}
			if (currentLoader && currentLoader.loadType == LoadUtils.CACHED_LOAD)
			{
				//If cache load fails for whatever reason, force loader to overwrite corrupted cache
				forceCacheSave = true;
			}
			
			disposeLoaderAndTryNext();
		}
		
		protected function getResourceType():String
		{
			throw new Error("AssetLoader.getResourceType() must be overridden in subclasses");
		}
		
		protected function cacheAsset():void
		{
			if (PlatformServices.isCanvas)
			{
				cleanupServiceData();
				return;
			}
			
			if (AssetsManager.instance.assetIndexManager.cachedFileIsUpToDate(uri) && !forceCacheSave)
			{
				cleanupServiceData();
				return;
			}
			
			if (currentLoader.disposed)
			{
				cleanupServiceData();
				return;
			}
			
			forceCacheSave = false;
			savingCache = true;
			//gameManager.backgroundThreadManager.addFunction(BackgroundThreadManager.PRIORITY_LOW, getCacheData);
			gameManager.backgroundThreadManager.addTimingPriorityFunction(getCacheData);
		}
		
		private function getCacheData():void 
		{
			if (disposed)
			{
				return;
			}
			
			//sosTrace("AssetLoader.caching ", uri, SOSLog.DEBUG);
			
			getBinaryDataThrowWorker(callback_receiveCacheData);
		}
		
		private function callback_receiveCacheData(binaryData:ByteArray):void 
		{
			//sosTrace("AssetLoader.callback_receiveCacheData ", uri, binaryData, SOSLog.DEBUG);
			if (binaryData)
				gameManager.backgroundThreadManager.addTimingPriorityFunction(saveCacheFile, binaryData);
		}
		
		private function saveCacheFile(binaryData:ByteArray):void 
		{
			InternalStorageAPI.saveFile(uri, binaryData, onCacheComplete);
		}
		
		private function onCacheComplete():void 
		{
			AssetsManager.instance.assetIndexManager.updateLocalIndexToServer(uri);
			//sosTrace("onCacheComplete ", uri, SOSLog.DEBUG);
			savingCache = false;
			
			cleanupServiceData();
			gameManager.backgroundThreadManager.addTimingPriorityFunction(deferredDispose);
			
			/*cleanupServiceData();
			if (disposeAfterCacheSave)
			{
				disposeAfterCacheSave = false;
				dispose();
			}*/
		}
		
		public function deferredDispose():void {
			
			if (disposeAfterCacheSave)
			{
				//sosTrace("cacheClean", uri, SOSLog.DEBUG);
				disposeAfterCacheSave = false;
				dispose();
			}
		}
		
		public function getBinaryData():ByteArray
		{
			throw new Error("AssetLoader.getBinaryData() must be overridden in subclasses");
		}
		
		public function getBinaryDataThrowWorker(callback:Function):void
		{
			callback(getBinaryData());
		}
		
		override protected function stopInternal():void 
		{
			if (currentLoader)
			{
				currentLoader.dispose();
				currentLoader = null;
			}
		}
		
		public function dispose():void
		{
			if (_disposed)
			{
				return;
			}
			
			if (savingCache)
			{
				disposeAfterCacheSave = true;
				return;
			}
			
			stop();
			
			if (currentLoader)
			{
				currentLoader.dispose();
			}
			completeCallbackContainer.clear();
			errorCallbackContainer.clear();
			loaderQueue = null;
			_disposed = true;
			//throw new Error( "AssetLoader.dispose() must be overridden in subclasses");
		}
		
		override public function toString():String 
		{
			return "[" + getQualifiedClassName(this) + " disposed=" + disposed + " uri=" + uri + "]";
		}
		
	}

}