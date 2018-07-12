package com.alisacasino.bingo.assets.loading 
{
	import com.alisacasino.bingo.assets.loading.assetLoaders.AssetLoader;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class AssetBase 
	{
		private var trackedLoaders:Vector.<AssetLoader>;
		
		public function AssetBase() 
		{
			trackedLoaders = new Vector.<AssetLoader>();
		}
		
		protected function addTrackedLoader(loader:AssetLoader):void
		{
			trackedLoaders.push(loader);
		}
		
		protected function clearTrackedLoaders():void
		{
			while (trackedLoaders.length)
			{
				trackedLoaders.pop();
			}
		}
		
		public function getTransferRate():Number
		{
			var speed:Number = -1;
			for each (var item:AssetLoader in trackedLoaders) 
			{
				var loaderTransferRate:Number = item.getTransferRate();
				if (loaderTransferRate != -1)
				{
					if (speed == -1)
					{
						speed = loaderTransferRate;
					}
					else
					{
						speed += loaderTransferRate;
					}
				}
			}
			return speed;
		}
		
		public function purge():void 
		{
			clearTrackedLoaders();
		}
		
		public function get progress():Number
		{
			if (trackedLoaders.length <= 0)
			{
				return 0;
			}
			
			//TODO: count actual size
			var totalProgress:Number = 0;
			for each (var item:AssetLoader in trackedLoaders) 
			{
				totalProgress += item.progress;
			}
			
			return totalProgress / trackedLoaders.length;
		}
		
	}

}