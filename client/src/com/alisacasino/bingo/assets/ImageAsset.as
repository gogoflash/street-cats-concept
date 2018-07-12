package com.alisacasino.bingo.assets
{
	import com.alisacasino.bingo.assets.loading.AssetBase;
	import com.alisacasino.bingo.assets.loading.LoadManager;
	import com.alisacasino.bingo.assets.loading.assetLoaders.AssetLoader;
	import com.alisacasino.bingo.assets.loading.assetLoaders.ImageAssetLoader;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.utils.BitmapManager;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.LoadUtils;
	import com.alisacasino.bingo.utils.misc.CallbackContainer;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	import starling.display.DisplayObject;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	
	import starling.core.Starling;
	import starling.textures.Texture;
	
	public class ImageAsset extends AssetBase implements IAsset 
	{
		public var parents:Dictionary = new Dictionary(true);
		
		public var _url:String;
		public var lastUsageTimestamp:Number = 0;
		public var imageSize:Number = 0;
		public var mFilePath:String;
		private var _texture:Texture;
		private var bitmapData:BitmapData;
		private var loader:ImageAssetLoader;
		private var completeCallbackContainer:CallbackContainer;
		private var errorCallbackContainer:CallbackContainer;
		private var parentRemoveCallbackContainer:CallbackContainer;
		private var onCompleteArgs:Array;
		private var onErrorArgs:Array;
		
		private var _loaded:Boolean;
		private var _loading:Boolean;
		private var _disposed:Boolean;
		private var purgeLocks:Array = [];
		
		public function get disposed():Boolean 
		{
			return _disposed;
		}
		
		public function get loading():Boolean 
		{
			return _loading;
		}
		
		public function ImageAsset(url:String)
		{
			completeCallbackContainer = new CallbackContainer();
			errorCallbackContainer = new CallbackContainer();
			parentRemoveCallbackContainer = new CallbackContainer();
			
			_url = url;
			mFilePath = String(int(gameManager.layoutHelper.assetMode)) + "/images/" + _url;
			_texture = null;
		}
		
		public function loadForParent(onComplete:Function = null, onError:Function = null, parent:* = null, onCompleteArgs:Array = null, onErrorArgs:Array = null):void
		{
			addParent(parent);
			load(onComplete, onError, onCompleteArgs, onErrorArgs);
		}
		

		
		public function load(onComplete:Function, onError:Function, onCompleteArgs:Array = null, onErrorArgs:Array = null):void
		{
			this.onCompleteArgs = onCompleteArgs;
			this.onErrorArgs = onErrorArgs;
			
			if (loaded)
			{
				if (onComplete != null)
				{
					completeCallbackContainer.executeCallback(onComplete, onCompleteArgs);
					onCompleteArgs = null;
				}
				return;
			}
			
			if(onComplete != null)
				completeCallbackContainer.addCallback(onComplete);
			if(onError != null)
				errorCallbackContainer.addCallback(onError);
			
			if (_loading) {
				return;
			}
			
			_disposed = false;
			_loading = true;
			
			loader = new ImageAssetLoader(mFilePath);
			loader.finishOnFail = false;
			loader.load(loader_completeHandler, loader_errorHandler);
			addTrackedLoader(loader);
		}
		
		public function get url():String {
			return _url;
		}
		
		public function removeCompleteCallback(callback:Function):void
		{
			if (completeCallbackContainer)
			{
				completeCallbackContainer.removeCallback(callback);
				onCompleteArgs = null;
			}
		}
		
		public function removeErrorCallback(callback:Function):void
		{
			if (errorCallbackContainer)
			{
				errorCallbackContainer.removeCallback(callback);
				onErrorArgs = null;
			}
		}
		
		private function loader_errorHandler(assetLoader:ImageAssetLoader):void
		{
			sosTrace("ImageAsset.loader_errorHandler " + this, SOSLog.ERROR);
			
			_loading = false;
			
			completeCallbackContainer.clear();
			onCompleteArgs = null;
			errorCallbackContainer.executeAndClearAllCallbacks(onErrorArgs);
			onErrorArgs = null;
		}
		
		private function loader_completeHandler(assetLoader:ImageAssetLoader):void
		{
			if (!assetLoader)
				return;
			
			// keep bitmaps in GPU memory if context may lost
			gameManager.backgroundThreadManager.addNormalPriorityFunction(uploadTexture, assetLoader);
		}
		
		private function uploadTexture(assetLoader:ImageAssetLoader):void 
		{
			if (_disposed)
			{
				sosTrace("Trying to upload disposed asset " + _url, SOSLog.WARNING);
				assetLoader.dispose();
				return;
			}
			
			if (bitmapData)
			{
				sosTrace("Uploading texture while old bitmapData is still present " + _url, SOSLog.WARNING);
				try
				{
					bitmapData.dispose();
				}
				catch (e:Error)
				{
					
				}
				
				bitmapData = null;
			}
			
			if (_texture)
			{
				sosTrace("Uploading texture while old texture is still present " + _url, SOSLog.WARNING);
				try
				{
					_texture.dispose();
				}
				catch (e:Error)
				{
					
				}
				
				_texture = null;
			}
			
			
			var bitmapData:BitmapData = assetLoader.bitmapData;
			if (!bitmapData)
			{
				sosTrace("Could not get bitmap data from loader for " + _url, SOSLog.WARNING);
				return;
			}
			
			try
			{
				var bitmapWidth:int = bitmapData.width;
				if (bitmapData.width <= 0)
				{
					sosTrace("Trying to upload zero width bitmap " + _url, SOSLog.WARNING);
					return;
				}
			}
			catch(e:Error)
			{
				sosTrace("Error while checking bitmap width " + _url, SOSLog.WARNING);
				return;
			}
			
			imageSize = bitmapData.width * bitmapData.height * 4;
			
			if (_texture)
			{
				sosTrace( "_texture already created : " + _url, SOSLog.ERROR);
			}
			
			if (/*Starling.handleLostContext*/true)
			{
				bitmapData = bitmapData.clone();
				
				try
				{
					_texture = Texture.fromBitmapData(bitmapData, false);
				}
				catch (e:Error)
				{
					sosTrace( "Texture upload error e : " + e, SOSLog.ERROR);
				}
			}
			else
			{
				/*try
				{
					_texture = Texture.fromBitmapData(bitmapData, false);
				}
				catch (e:Error)
				{
					sosTrace( "Texture upload error e : " + e, SOSLog.ERROR);
				}
				bitmapData = null;*/
			}
			
			if (!_texture)
			{
				_texture = AtlasAsset.getNotFoundTexture();
				sosTrace( "Using fallback not-found texture for "+ _url, SOSLog.WARNING);
			}
			
			assetLoader.dispose();
			
			_loaded = true;
			_loading = false;
			errorCallbackContainer.clear();
			completeCallbackContainer.executeAndClearAllCallbacks(onCompleteArgs);
		}
		
		override public function purge():void
		{
			super.purge();
			if (bitmapData != null)
			{
				bitmapData.dispose();
				bitmapData = null;
			}
			
			if(_texture)
				_texture.dispose();
			
			_texture = null;
			
			if (loader)
			{
				loader.dispose();
			}
			imageSize = 0;
			_loading = false;
			_loaded = false;
			_disposed = true;
		}
		
		public function get texture():Texture
		{
			return _texture;
		}
		
		public function get isRemovable():Boolean
		{
			return (!isInUse() && !hasPurgeLock());
		}
		
		public function toString():String 
		{
			return "[ImageAsset " + _url + " loaded=" + loaded + "]";
		}
		
		public function get usageCount():int 
		{
			var result:int;
			
			for (var key:Object in parents) 
			{
				if (key)
					result++;
			}
			
			return result;
		}
		
		public function addPurgeLock(id:String):void
		{
			purgeLocks[id] = 0;
		}
		
		public function releasePurgeLock(id:String):void
		{
			delete purgeLocks[id];
		}
		
		public function hasPurgeLock():Boolean
		{
			for (var name:String in purgeLocks) 
			{
				return true;
			}
			
			return false;
		}
		
		/* INTERFACE com.alisacasino.bingo.assets.IAsset */
		
		public function get loaded():Boolean
		{
			return _loaded;
		}
		
		public function removeParent(parent:*):void
		{
			if (parent != null)
			{
				parents[parent] = 0;
				delete parents[parent];
			}
			
			var noParents:Boolean = true;
			for (parent in parents) 
			{
				noParents = false;
				break;
			}
			
			if (noParents)
				parentRemoveCallbackContainer.executeAllCallbacks();
		}
		
		public function addParent(parent:Object):void 
		{
			if (parent != null)
			{
				parents[parent] = 1;
			}
		}
		
		public function isInUse():Boolean
		{
			for (var key:Object in parents) 
			{
				if (key)
					return true;
			}
			return false;
		}
		
		public function addParentRemoveCallback(callback:Function):void 
		{
			if (callback != null)
				parentRemoveCallbackContainer.addCallback(callback);
		}
		
		public function get uri():String
		{
			return mFilePath;
		}
		
		/* INTERFACE com.alisacasino.bingo.assets.IAsset */
		
		public function clearListeners():void 
		{
			completeCallbackContainer.clear();
			errorCallbackContainer.clear();
			onCompleteArgs = null;
			onErrorArgs = null;
		}
	}
}

