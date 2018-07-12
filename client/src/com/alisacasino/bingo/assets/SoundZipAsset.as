package com.alisacasino.bingo.assets 
{
	import com.alisacasino.bingo.assets.loading.AssetBase;
	import com.alisacasino.bingo.utils.misc.CallbackContainer;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	import starling.events.Event;
	import treefortress.sound.SoundAS;
	
	public class SoundZipAsset extends AssetBase implements IAsset 
	{
		private var completeCallbackContainer:CallbackContainer;
		private var errorCallbackContainer:CallbackContainer;
		private var onCompleteArgs:Array;
		private var onErrorArgs:Array;
		
		private var _loaded:Boolean;
		private var _loading:Boolean;
		private var _disposed:Boolean;
		public var _uri:String;
		private var zipAsset:ZipAsset;
		private var _soundsList:Object;
		
		public function SoundZipAsset(uri:String, completeCallback:Function = null) 
		{
			super();
			completeCallbackContainer = new CallbackContainer();
			errorCallbackContainer = new CallbackContainer();
			
			if(completeCallback != null)
				completeCallbackContainer.addCallback(completeCallback);
			
			_uri = uri;
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
		
			if (zipAsset) {
				zipAsset.stop();
				zipAsset.dispose();
			}
			
			zipAsset = new ZipAsset(_uri);
			zipAsset.finishOnFail = false;
			zipAsset.load(loader_completeHandler, loader_errorHandler);
			//addTrackedLoader(loader);
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
		
		private function loader_errorHandler(assetLoader:ZipAsset):void
		{
			sosTrace("SoundZipAsset.loader_errorHandler " + this, SOSLog.ERROR);
			
			_loading = false;
			
			completeCallbackContainer.clear();
			errorCallbackContainer.executeAndClearAllCallbacks(onErrorArgs);
			onErrorArgs = null;
		}
		
		private function loader_completeHandler(assetLoader:ZipAsset):void
		{
			_loading = false;
			_loaded = true;
			
			_soundsList = {};	
				
			var content:Object = assetLoader.content;	
			var key:String;	
			var soundName:String;	
			var sound:Sound;
			var soundRaw:ByteArray;	
			for (key in content)
			{
				sound = new Sound();
				//sound.addEventListener(Event.COMPLETE, sound_completeHandler);
				soundRaw = content[key] as ByteArray;
				try
				{
					sound.loadCompressedDataFromByteArray(soundRaw, soundRaw.length);
				}
				catch (e:Error)
				{
					sound = null;
				}
				
				if (sound) {
					_soundsList[key.replace('.mp3', '')] = sound;
				}
			}
			
			//addSounds();
			
			if (zipAsset) {
				zipAsset.clear();
				zipAsset = null;
			}
			
			sosTrace("SoundZipAsset.loader_completeHandler " + this, SOSLog.INFO);
			
			errorCallbackContainer.clear();
			completeCallbackContainer.executeAndClearAllCallbacks(onCompleteArgs);
			onCompleteArgs = null;
			onErrorArgs = null;
		}
		
		public function get soundsList():Object
		{
			return _soundsList;
		}
		
		/*private function sound_completeHandler(e:Event):void 
		{
			trace('> ', (e.target as Sound).bytesTotal, (e.target as Sound).url, (e.target as Sound).length);
			checkIfCanDisposeByteArray();
		}*/
		
		/*private function disposeLoaders():void 
		{
			if (!loadersByName)
				return;
				
			var loader:ImageAssetLoader;
			for each(loader in loadersByName) {
				loader.dispose();
			}
		}
		eAndClearAllCallbacks(this);
		}*/
		
		override public function purge():void
		{
			super.purge();
			
			_loading = false;
			_loaded = false;
			_disposed = true;
			_soundsList = null;
			
			if (zipAsset) {
				zipAsset.clear();
				zipAsset = null;
			}
			
			clearListeners();
		}
		
		public function toString():String 
		{
			return "[SoundZipAsset " + _uri + " loaded=" + loaded + "]";
		}
	
		/* INTERFACE com.alisacasino.bingo.assets.IAsset */
		
		public function get loaded():Boolean
		{
			return _loaded;
		}
		
		public function get uri():String
		{
			return _uri;
		}
		
		/* INTERFACE com.alisacasino.bingo.assets.IAsset */
		
		public function clearListeners():void 
		{
			completeCallbackContainer.clear();
			errorCallbackContainer.clear();
			onCompleteArgs = null;
			onErrorArgs = null;
		}
		
		public function get isRemovable():Boolean
		{
			return false/*(!isInUse() && !hasPurgeLock())*/;
		}
	}

}



