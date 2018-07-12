package com.alisacasino.bingo.assets.loading 
{
	import avmplus.getQualifiedClassName;
	import com.alisacasino.bingo.assets.AssetsManager;
	import com.alisacasino.bingo.assets.IAsset;
	import com.alisacasino.bingo.platform.PlatformServices;
	import flash.utils.getTimer;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class AssetQueue extends EventDispatcher
	{
		private var name:String;
		protected var loadingAssets:Vector.<IAsset>;
		
		protected var onComplete:Function;
		protected var assetsToLoad:Array;
		
		protected var concurrentLoadLimit:int = 1;
		
		protected var _progess:Number = 0.;
		
		public function get progess():Number 
		{
			return _progess;
		}
		
		public function AssetQueue(name:String) 
		{
			this.name = name;
			concurrentLoadLimit = PlatformServices.isCanvas ? 2 : 2;
			loadingAssets = new Vector.<IAsset>();
		}
		
		public function load(assetsToLoad:Array, onComplete:Function = null):AssetQueue 
		{
			sosTrace(name + " AssetQueue.load > assetsToLoad : ", assetsToLoad, SOSLog.FINER);
			this.assetsToLoad = assetsToLoad;
			this.onComplete = onComplete;
			
			Starling.current.stage.addEventListener(Event.ENTER_FRAME, stage_enterFrameHandler);
			
			return this;
		}
		
		private function stage_enterFrameHandler(e:Event):void 
		{
			var time:int = getTimer();
			while (getTimer() - time < 50)
			{
				if (getCurrentLoadNumber() >= concurrentLoadLimit)
				{
					break;
				}
				if (assetsToLoad.length)
				{
					loadNext();
				}
			}
			
			checkQueue();
		}
		
		private function getCurrentLoadNumber():int
		{
			var result:int = 0;
			for each (var item:IAsset in loadingAssets) 
			{
				if (!item.loaded)
				{
					result++;
				}
			}
			return result;
		}
		
		private function loadNext():void 
		{
			if (assetsToLoad.length)
			{
				var item:IAsset = assetsToLoad.shift();
				if (item && !item.loaded)
				{
					if (loadingAssets.indexOf(item) == -1)
					{
						loadingAssets.push(item);
						item.load(assetLoaded, assetFailed, null, [item.uri]);
						sosTrace(name + "loading item : " + item, SOSLog.FINER);
					}
				}
			}
		}
		
		
		private function assetFailed(uri:String):void 
		{
			sosTrace("Asset failed", SOSLog.DEBUG);
			AssetsManager.instance.dispatchEvent(new AssetLoadingEvent(AssetLoadingEvent.FAIL, false, uri));
			stop();
		}
		
		private function assetLoaded():void 
		{
			checkQueue(true);
		}
		
		private function checkQueue(logProgress:Boolean = false):void 
		{
			var totalAssets:int = assetsToLoad.length + loadingAssets.length;
			var loaded:int = 0;
			
			var assetProgress:Number = 1 / totalAssets;
			var currentProgress:Number = 0;
			for each (var item:IAsset in loadingAssets) 
			{
				if (item.loaded)
				{
					loaded++;
					currentProgress += assetProgress;
				}
				else
				{
					currentProgress += assetProgress * item.progress;
				}
			}
			
			updateProgress(currentProgress);
			
			if (assetsToLoad.length)
			{
				if(logProgress)
					sosTrace(name + " Assets are not fully added", SOSLog.DEBUG);
				return;
			}
			
			if (logProgress)
			{
				sosTrace(name + " AssetQueue.checkQueue loadingAssets : " + loadingAssets, SOSLog.DEBUG);
				sosTrace(name + " loaded : " + loaded, SOSLog.DEBUG);
				sosTrace(name + " totalAssets : " + totalAssets, SOSLog.DEBUG);
			}
			
			if (loaded >= totalAssets)
			{
				removeFrameListener();
				sosTrace(name + " AssetQueue.onComplete : " + getQualifiedClassName(onComplete), SOSLog.DEBUG);
				if (onComplete != null)
				{
					onComplete();
					onComplete = null;
				}
			}
		}
		
		private function removeFrameListener():void 
		{
			Starling.current.stage.removeEventListener(Event.ENTER_FRAME, stage_enterFrameHandler);
		}
		
		public function stop():void
		{
			removeFrameListener();
			assetsToLoad.length = 0;
			for each (var item:IAsset in loadingAssets) 
			{
				if (item.isRemovable)
				{
					item.purge();
				}
			}
			onComplete = null;
		}
		
		public function emptyUnloadedAndRemoveListeners():void 
		{
			assetsToLoad.length = 0;
			onComplete = null;
			removeFrameListener();
		}
		
		private function updateProgress(value:Number):void 
		{
			if (_progess != value)
			{
				_progess = value;
				dispatchEventWith(Event.CHANGE);
			}
		}
		
	}

}