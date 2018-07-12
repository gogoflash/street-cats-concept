package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.disposal.DelayedDisposalUtil;
	import com.alisacasino.bingo.utils.disposal.IDisposable;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class XImage extends Image implements IDisposable
	{
		private var mLoader:Loader;
		private var mIsLoaded:Boolean = true;
		private var mImageURL:String = null;
		
		private var _defaultTexture:Texture;
		
		private var showPreloaderCallback:Function;
		private var hidePreloaderCallback:Function;
		
		private var _idleColor:uint;
		
		public function get defaultTexture():Texture 
		{
			return _defaultTexture;
		}
		
		public function set defaultTexture(value:Texture):void 
		{
			_defaultTexture = value;
		}
		
		public function XImage(defaultTexture:Texture, imageURL:String=null, showPreloaderCallback:Function = null, hidePreloaderCallback:Function = null, idleColor:uint = 0xFFFFFF)
		{
			super(defaultTexture);
			this.showPreloaderCallback = showPreloaderCallback;
			this.hidePreloaderCallback = hidePreloaderCallback;
			this.defaultTexture = defaultTexture;
			_idleColor = idleColor;
			this.imageURL = imageURL;
			addEventListener(starling.events.Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(..._):void
		{
			if (hidePreloaderCallback != null)
				hidePreloaderCallback();
				
			if (imageURL != null && mIsLoaded) {
				DelayedDisposalUtil.instance.dispose(this);
			}
		}
		
		override public function dispose():void 
		{
			if (hidePreloaderCallback != null)
				hidePreloaderCallback();
				
			super.dispose();
			if (imageURL != null && mIsLoaded && texture)
			{
				mIsLoaded = false;
				texture.dispose();
			}
		}
		
		private function onComplete(e:flash.events.Event):void
		{
			mLoader.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE, onComplete);
			try {
				texture = Texture.fromBitmap(mLoader.content as Bitmap);
			} catch (e:Error) {
				// deliberately swallow to avoid overlogging
				return;
			}
			mIsLoaded = true;
			color = 0xFFFFFF;
			sBitmapCache[mImageURL] = mLoader.content;
			
			if (hidePreloaderCallback != null)
				hidePreloaderCallback();
			
			dispatchEventWith(starling.events.Event.COMPLETE);
		}
		
		public function get loaded():Boolean
		{
			return mIsLoaded;
		}
		
		public function hasInCache(imageURL:String):Boolean
		{
			return imageURL in sBitmapCache;
		}
				
		public function get imageURL():String
		{
			return mImageURL;
		}
		
		public function set imageURL(value:String):void
		{
			mImageURL = value;
			if (imageURL != null) 
			{
				clearLoader();
				
				if (sBitmapCache[mImageURL]) {
					texture = Texture.fromBitmap(sBitmapCache[mImageURL]);
					return;
				}
				
				color = _idleColor;
				mIsLoaded = false;
				texture = defaultTexture;
				
				mLoader = new Loader();
				
				var context:LoaderContext;
				if (PlatformServices.isCanvas)
				{
					context = new LoaderContext(true);
				}
				
				mLoader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, onComplete);
				mLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, mLoader_ioErrorHandler, false, 0, true);
				mLoader.load(new URLRequest(imageURL), context);
				
				if (showPreloaderCallback != null)
					showPreloaderCallback();
			}
			else
			{
				if (hidePreloaderCallback != null)
					hidePreloaderCallback();
				
				clearLoader();
				texture = defaultTexture;
				color = _idleColor;
			}
		}
		
		private function clearLoader():void 
		{
			if (hidePreloaderCallback != null)
				hidePreloaderCallback();
				
			if (!mLoader)
				return;
			
			try
			{
				mLoader.unloadAndStop(true);
			}
			catch (e:Error)
			{
				sosTrace( "XImage.clearLoader error : " + e, SOSLog.ERROR);
			}
			mLoader.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE, onComplete);
		}
		
		private function mLoader_ioErrorHandler(e:IOErrorEvent):void 
		{
			e.preventDefault();
			e.stopImmediatePropagation();
			sosTrace( "XImage.mLoader_ioErrorHandler > e : " + e, SOSLog.ERROR);
			
			if (hidePreloaderCallback != null)
				hidePreloaderCallback();
		}
		
		private static var sBitmapCache:Dictionary = new Dictionary();
	}
}