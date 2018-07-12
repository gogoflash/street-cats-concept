package com.alisacasino.bingo.assets
{
	import com.alisacasino.bingo.assets.loading.AssetBase;
	import com.alisacasino.bingo.assets.loading.assetLoaders.ImageAssetLoader;
	import com.alisacasino.bingo.commands.ICommand;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.utils.BitmapManager;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.LoadUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	
	import starling.core.Starling;
	import starling.textures.Texture;
	
	public class BackgroundAsset extends AssetBase implements IAsset
	{
		private var mGameManager:GameManager = GameManager.instance;
		private var mName:String;
		
		public function get name():String 
		{
			return mName;
		}
		private var mFilePath:String;
		private var mTexture:Texture;
		private var mBitmapData:BitmapData;
		private var _loaded:Boolean;
		private var loadType:int;
		private var onComplete:Function;
		private var errorCallback:Function;
		private var onCompleteArgs:Array;
		private var onErrorArgs:Array;
		private var removable:Boolean;
		
		public function BackgroundAsset(path:String, removable:Boolean = true)
		{
			this.removable = removable;
			mName = path;
			mFilePath = path;
			mTexture = null;
		}
		
		public function load(onComplete:Function, onError:Function, onCompleteArgs:Array = null, onErrorArgs:Array = null):void
		{
			this.onComplete = onComplete;
			this.errorCallback = onError;
			this.onCompleteArgs = onCompleteArgs;
			this.onErrorArgs = onErrorArgs;
			var assetLoader:ImageAssetLoader = new ImageAssetLoader(mFilePath);
			assetLoader.load(loader_completeHandler, loader_errorHandler);
			addTrackedLoader(assetLoader);
		}
		
		private function loader_errorHandler(assetLoader:ImageAssetLoader):void
		{
			sosTrace("BackgroundAsset.loader_errorHandler " + this, SOSLog.ERROR);
			
			if (errorCallback != null)
			{
				errorCallback.apply(null, onErrorArgs);
				errorCallback = null;
				onErrorArgs = null;
			}
		}
		
		private function loader_completeHandler(assetLoader:ImageAssetLoader):void
		{
			var bitmapData:BitmapData = assetLoader.bitmapData;
			if (!bitmapData) {
				_loaded = false;
			
				if (errorCallback != null)
				{
					errorCallback.apply(null, onErrorArgs);
					errorCallback = null;
					onErrorArgs = null;
				}
				
				return;
			}
			
			mBitmapData = bitmapData.clone() ;
			assetLoader.dispose();
			
			var scaleX:Number = mGameManager.layoutHelper.stageWidth / mBitmapData.width;
			var scaleY:Number = mGameManager.layoutHelper.stageHeight / mBitmapData.height;
			var scale:Number = Math.max(scaleX, scaleY);
			
			if (scale == 1.0 || (layoutHelper.canvasLayoutMode && layoutHelper.isLargeScreen))
			{
				mTexture = Texture.fromBitmapData(mBitmapData, false);
			}
			else
			{
				var scaledBitmapData:BitmapData = BitmapManager.resampleBitmapData(mBitmapData, scale);
				mBitmapData.dispose();
				mBitmapData = scaledBitmapData;
				mTexture = Texture.fromBitmapData(mBitmapData, false);
			}
			
			// no need to keep bitmaps in GPU memory if context is never lost
			/*if (!Starling.handleLostContext)
			{
				mBitmapData.dispose();
				mBitmapData = null;
			}*/
			
			_loaded = true;
			
			if (onComplete != null)
			{
				onComplete.apply(null, onCompleteArgs);
				onComplete = null;
				onCompleteArgs = null;
			}
		}
		
		override public function purge():void
		{
			super.purge();
			if (mBitmapData != null)
			{
				mBitmapData.dispose();
				mBitmapData = null;
			}
			if (mTexture)
			{
				mTexture.dispose();
			}
			mTexture = null;
			_loaded = false;
		}
		
		public function get texture():Texture
		{
			return mTexture;
		}
		
		public function get isRemovable():Boolean
		{
			return removable;
		}
		
		public function toString():String 
		{
			return "[BackgroundAsset " + mName + " loaded=" + loaded + "]";
		}
		
		
		/* INTERFACE com.alisacasino.bingo.assets.IAsset */
		
		public function clearListeners():void 
		{
			onComplete = null;
			errorCallback = null;
			onCompleteArgs = null;
			onErrorArgs = null;
		}
		
		/* INTERFACE com.alisacasino.bingo.assets.IAsset */
		
		public function get loaded():Boolean
		{
			return _loaded;
		}
		
		public function get uri():String
		{
			return mFilePath;
		}
	}
}

