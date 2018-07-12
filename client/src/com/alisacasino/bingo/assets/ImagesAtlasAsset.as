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
	import com.alisacasino.bingo.utils.emibap.textureAtlas.DynamicAtlas;
	import com.alisacasino.bingo.utils.misc.CallbackContainer;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	import starling.display.DisplayObject;
	import starling.textures.TextureAtlas;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	
	import starling.core.Starling;
	import starling.textures.Texture;
	
	public class ImagesAtlasAsset extends AssetBase implements IAsset 
	{
		public var parents:Dictionary = new Dictionary(true);
		
		public var assetName:String;
		public var lastUsageTimestamp:Number = 0;
		public var imageSize:Number = 0;
		public var mFilePath:String;
		private var _texture:Texture;
		//private var bitmapData:BitmapData;
		//private var loader:ImageAssetLoader;
		private var completeCallbackContainer:CallbackContainer;
		private var errorCallbackContainer:CallbackContainer;
		private var parentRemoveCallbackContainer:CallbackContainer;
		private var onCompleteArgs:Array;
		private var onErrorArgs:Array;
		private var _loaded:Boolean;
		private var _loading:Boolean;
		private var _disposed:Boolean;
		private var purgeLocks:Array = [];
	
		//private var loadingIndex:int;
		private var loadersByName:Object;//Vector.<ImageAssetLoader>;
		private var storedBitmapDatas:Object;///Vector.<BitmapData>;
		private var names:Vector.<String>;
		private var texturesByNames:Object;
		
		private var textureAtlas:TextureAtlas;
		
		public function get disposed():Boolean 
		{
			return _disposed;
		}
		
		public function ImagesAtlasAsset(names:Vector.<String>)
		{
			completeCallbackContainer = new CallbackContainer();
			errorCallbackContainer = new CallbackContainer();
			parentRemoveCallbackContainer = new CallbackContainer();
			
			this.names = names;
			assetName = names[0];
			
			
			
			//mFilePath = String(int(gameManager.layoutHelper.assetMode)) + "/images/" + name;
			textureAtlas = null;
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
		
			var i:int;
			var length:int = names.length;
			var loader:ImageAssetLoader;
			loadersByName = {};
			for (i = 0; i < length; i++) {
				loader = new ImageAssetLoader(getFullUrl(names[i]));
				loader.finishOnFail = false;
				loader.load(loader_completeHandler, loader_errorHandler);
				addTrackedLoader(loader);
				loadersByName[names[i]] = loader;
			}
			
			//loadNext();
		}
		
		private function getFullUrl(url:String):String {
			return String(int(gameManager.layoutHelper.assetMode)) + "/images/" + url;
		}
		
		/*private function loadNext():void
		{
			loaders[loadingNameIndex]
		}*/
		
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
			
			var loader:ImageAssetLoader;
			for each(loader in loadersByName) {
				loader.stop();
			}

			completeCallbackContainer.clear();
			errorCallbackContainer.executeAndClearAllCallbacks(onErrorArgs);
			onErrorArgs = null;
		}
		
		private function loader_completeHandler(assetLoader:ImageAssetLoader):void
		{
			if (!assetLoader)
				return;
			
			var loader:ImageAssetLoader;
			for each(loader in loadersByName) {
				if (!loader.finished)
					return;
			}
			
			// keep bitmaps in GPU memory if context may lost
			gameManager.backgroundThreadManager.addNormalPriorityFunction(uploadTexture);
		}
		
		private function disposeLoaders():void 
		{
			if (!loadersByName)
				return;
				
			var loader:ImageAssetLoader;
			for each(loader in loadersByName) {
				loader.dispose();
			}
		}
		
		private function uploadTexture():void 
		{
			var i:int;
			var length:int;
			var loader:ImageAssetLoader;
			var bitmapData:BitmapData;
			
			if (_disposed)
			{
				sosTrace("Trying to upload disposed asset " + assetName, SOSLog.WARNING);
				disposeLoaders();
				return;
			}
			
			if (storedBitmapDatas)
			{
				sosTrace("Uploading texture while old bitmapData is still present " + assetName, SOSLog.WARNING);
				try
				{
					for each(bitmapData in storedBitmapDatas) {
						bitmapData.dispose();
					}
				}
				catch (e:Error)
				{
					
				}
				
				storedBitmapDatas = [];
			}
			else {
				storedBitmapDatas = [];
			}
			
			
			if (textureAtlas)
			{
				sosTrace("Uploading texture while old texture is still present " + assetName, SOSLog.WARNING);
				try
				{
					textureAtlas.dispose();
				}
				catch (e:Error)
				{
					
				}
				
				textureAtlas = null;
			}
			
			if (textureAtlas)
			{
				sosTrace( "_texture already created : " + assetName, SOSLog.ERROR);
			}
			
			var name:String;
			length = names.length;
			var container:MovieClip = new MovieClip();
			for (i = 0; i < length; i++) 
			{
				name = names[i];
				loader = loadersByName[name];
				
				if (!loader)
					continue;
				
				bitmapData = loader.bitmapData;
				if (!bitmapData)
				{
					sosTrace("Could not get bitmap data from loader for " + loader.uri, SOSLog.WARNING);
					return;
				}
				
				try
				{
					if (bitmapData.width <= 0)
					{
						sosTrace("Trying to upload zero width bitmap " + loader.uri, SOSLog.WARNING);
						return;
					}
				}
				catch(e:Error)
				{
					sosTrace("Error while checking bitmap width " + loader.uri, SOSLog.WARNING);
					return;
				}
				
				imageSize += bitmapData.width * bitmapData.height * 4;
				
				storedBitmapDatas[loader.uri] = bitmapData.clone();
				
				var bitmap:Bitmap = new Bitmap(storedBitmapDatas[loader.uri]);
				bitmap.name = name;
				
				Starling.current.nativeStage.addChild(bitmap)
				
				container.addChild(bitmap);
			}
			
			try
			{
				textureAtlas = DynamicAtlas.fromMovieClipContainer(container, 1, 0, true, true);
			}
			catch (e:Error)
			{
				sosTrace( "Texture upload error e : " + e, SOSLog.ERROR);
			}
			
			if (!textureAtlas)
			{
				//textureAtlas = AtlasAsset.getNotFoundTexture();
				sosTrace( "Using fallback not-found texture for "+ assetName, SOSLog.WARNING);
			}
			
			disposeLoaders();
			
			_loaded = true;
			_loading = false;
			errorCallbackContainer.clear();
			completeCallbackContainer.executeAndClearAllCallbacks(onCompleteArgs);
			onErrorArgs = null;
			onCompleteArgs = null;
		}
		
		override public function purge():void
		{
			super.purge();
			/*if (bitmapData != null)
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
			}*/
			imageSize = 0;
			_loading = false;
			_loaded = false;
			_disposed = true;
		}
		
		public function getTexture(name:String):Texture
		{
			return textureAtlas.getTexture(name);
		}
		
		public function get isRemovable():Boolean
		{
			return (!isInUse() && !hasPurgeLock());
		}
		
		public function toString():String 
		{
			return "[ImageAsset " + assetName + " loaded=" + loaded + "]";
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
			return names ? names.join(', ') : 'null';
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

