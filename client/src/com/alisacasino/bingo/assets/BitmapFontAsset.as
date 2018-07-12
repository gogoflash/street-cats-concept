package com.alisacasino.bingo.assets
{
	import com.alisacasino.bingo.assets.loading.AssetBase;
	import com.alisacasino.bingo.assets.loading.assetLoaders.ATFTextureLoader;
	import com.alisacasino.bingo.assets.loading.assetLoaders.AssetLoader;
	import com.alisacasino.bingo.assets.loading.assetLoaders.ImageAssetLoader;
	import com.alisacasino.bingo.assets.loading.assetLoaders.XMLAssetLoader;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.IBitmapLoader;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.LoadUtils;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.TextureSmoothing;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import starling.core.Starling;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class BitmapFontAsset extends AssetBase implements IAsset
	{
		private var mGameManager:GameManager = GameManager.instance;
		private var mName:String;
		private var mAtlasFilePath:String;
		private var mXmlFilePath:String;
		private var mTextureAtlas:TextureAtlas;
		private var mTextureCache:Object;
		private var mIsRemovable:Boolean;
		private var callback:Function;
		private var errorCallback:Function;
		private var onCompleteArgs:Array;
		private var onErrorArgs:Array;
		
		private var fontName:String;
		
		private static var notFoundTexture:Texture;
		static private var emptyTexture:Texture;
		
		private var _loaded:Boolean;
		private var imageAssetLoader:ImageAssetLoader;
		private var xmlAssetLoader:XMLAssetLoader;
		
		public static function getNotFoundTexture():Texture
		{
			if (!notFoundTexture)
			{
				notFoundTexture = Texture.fromColor(100, 100, 0x6600FFFF);
			}
			return notFoundTexture;
		}
		
		static public function getEmptyTexture():Texture 
		{
			if (!emptyTexture)
			{
				emptyTexture = Texture.empty(2, 2);
			}
			return emptyTexture;
		}
		
		
		public function BitmapFontAsset(name:String, isRemovable:Boolean = true)
		{
			var baseDir:String = "fonts/";
			mAtlasFilePath = baseDir + name + ".png";
			mXmlFilePath = baseDir + name + ".fnt";
			mName = name;
			mTextureCache = {};
			mIsRemovable = isRemovable;
		}
		
		public function load(onComplete:Function, onError:Function, onCompleteArgs:Array = null, onErrorArgs:Array = null):void
		{
			callback = onComplete;
			errorCallback = onError;
			this.onCompleteArgs = onCompleteArgs;
			this.onErrorArgs = onErrorArgs;
			
			imageAssetLoader = new ImageAssetLoader(mAtlasFilePath)
			imageAssetLoader.addErrorCallback(xmlOrAtlasError);
			imageAssetLoader.finishOnFail = false;
			imageAssetLoader.load(xmlOrAtlasLoaded);
			addTrackedLoader(imageAssetLoader);
			
			xmlAssetLoader = new XMLAssetLoader(mXmlFilePath);
			xmlAssetLoader.addErrorCallback(xmlOrAtlasError);
			xmlAssetLoader.finishOnFail = false;
			xmlAssetLoader.load(xmlOrAtlasLoaded);
			addTrackedLoader(xmlAssetLoader);
		}
		
		private function xmlOrAtlasLoaded():void
		{
			if (!imageAssetLoader || !xmlAssetLoader)
				return;
			
			var loadCompleted:Boolean = imageAssetLoader.finished && xmlAssetLoader.finished;
			
			if (loadCompleted)
			{
				var texture:Texture = Texture.fromBitmapData(imageAssetLoader.bitmapData);
				
				var xml:XML = xmlAssetLoader.xml;
				if (texture && xml)
				{
					var bitmapFont:BitmapFont = new BitmapFont(texture, xml);
					//bitmapFont.lineHeight = 78;
					bitmapFont.smoothing = TextureSmoothing.TRILINEAR;
					fontName = bitmapFont.name;
					TextField.registerCompositor(bitmapFont, bitmapFont.name);
				}
				else 
				{
					sosTrace("Failed to create font atlas " + mName, SOSLog.ERROR);
				}
				
				_loaded = true;
				
				if (callback != null)
				{
					callback.apply(null, onCompleteArgs);
					callback = null;
					onCompleteArgs = null;
				}
			}
		}
				
		private function xmlOrAtlasError():void 
		{
			sosTrace("BitmapFontAsset.xmlOrAtlasError " + this, SOSLog.ERROR);
			
			if (errorCallback != null)
			{
				errorCallback.apply(null, onErrorArgs);
				errorCallback = null;
				onErrorArgs = null;
			}
		}
		
		override public function purge():void
		{
			super.purge();
			if (imageAssetLoader != null)
			{
				imageAssetLoader.dispose();
				imageAssetLoader = null;
			}
			if (xmlAssetLoader != null)
			{
				xmlAssetLoader.dispose();
				xmlAssetLoader = null;
			}
			mTextureAtlas = null;
			mTextureCache = {};
			_loaded = false;
			if (fontName)
			{
				TextField.unregisterCompositor(fontName, true);
			}
		}
		
		public function get isRemovable():Boolean
		{
			return mIsRemovable;
		}
		
		public function get loaded():Boolean
		{
			return _loaded;
		}
		
		public function toString():String 
		{
			return "[BitmapFontAsset " + mName + " loaded=" + loaded + "]";
		}
		
		
		/* INTERFACE com.alisacasino.bingo.assets.IAsset */
		
		public function clearListeners():void 
		{
			callback = null;
			errorCallback = null;
			onCompleteArgs = null;
			onErrorArgs = null;
		}
		
		public function get uri():String
		{
			return mAtlasFilePath;
		}
		
		public static const SharkLatin:BitmapFontAsset = new BitmapFontAsset("SharkLatin");
	
	}
}