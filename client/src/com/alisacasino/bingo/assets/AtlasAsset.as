package com.alisacasino.bingo.assets
{
	import com.alisacasino.bingo.assets.loading.AssetBase;
	import com.alisacasino.bingo.assets.loading.assetLoaders.ATFTextureLoader;
	import com.alisacasino.bingo.assets.loading.assetLoaders.AssetLoader;
	import com.alisacasino.bingo.assets.loading.assetLoaders.ImageAssetLoader;
	import com.alisacasino.bingo.assets.loading.assetLoaders.XMLAssetLoader;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.IBitmapLoader;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.LoadUtils;
	
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
	
	public class AtlasAsset extends AssetBase implements IAsset
	{
		private var mGameManager:GameManager = GameManager.instance;
		private var mName:String;
		
		public function get name():String 
		{
			return mName;
		}
		
		private var mAtlasFilePath:String;
		private var mXmlFilePath:String;
		private var mTextureAtlas:TextureAtlas;
		private var mTextureCache:Object;
		private var mIsRemovable:Boolean;
		private var onComplete:Function;
		private var errorCallback:Function;
		private var onCompleteArgs:Array;
		private var onErrorArgs:Array;
		
		private static var notFoundTexture:Texture;
		static private var emptyTexture:Texture;
		
		private static var notLoadedTextures:Object = {};
		
		private var _loaded:Boolean;
		private var imageAssetLoader:ATFTextureLoader;
		private var xmlAssetLoader:XMLAssetLoader;
		
		public static function getNotFoundTexture(width:uint = 100, height:uint = 100):Texture
		{
			if (!notFoundTexture)
			{
				notFoundTexture = Texture.fromColor(width, height, 0x6600FFFF);
			}
			return notFoundTexture;
		}
		
		public static function getNotLoadedTexture(width:uint = 100, height:uint = 100):Texture
		{
			var textureKey:String = width.toString() + height.toString();
			if (!(textureKey in notLoadedTextures)) 
				notLoadedTextures[textureKey] = Texture.fromColor(width, height, 0xFF0099FF);
			
			return notLoadedTextures[textureKey] as Texture;
		}
		
		static public function getEmptyTexture():Texture 
		{
			if (!emptyTexture)
			{
				emptyTexture = Texture.empty(2, 2);
			}
			return emptyTexture;
		}
		
		public function getTextureAtlas():TextureAtlas
		{
			return mTextureAtlas;
		}
		
		public function AtlasAsset(path:String, isRemovable:Boolean = true)
		{
			var baseDir:String = String(int(mGameManager.layoutHelper.assetMode)) + "/";
			mAtlasFilePath = baseDir + path + ".atf";
			mXmlFilePath = baseDir + path + ".xml";
			mTextureAtlas = null;
			mName = path;
			mTextureCache = {};
			mIsRemovable = isRemovable;
		}
		
		/* INTERFACE com.alisacasino.bingo.assets.IAsset */
		
		public function clearListeners():void 
		{
			onComplete = null;
			errorCallback = null;
			onCompleteArgs = null;
			onErrorArgs = null;
		}
		
		public function load(onComplete:Function, onError:Function, onCompleteArgs:Array = null, onErrorArgs:Array = null):void
		{
			this.onComplete = onComplete;
			errorCallback = onError;
			this.onCompleteArgs = onCompleteArgs;
			this.onErrorArgs = onErrorArgs;
			
			imageAssetLoader = new ATFTextureLoader(mAtlasFilePath);
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
		
		private function xmlOrAtlasError():void 
		{
			sosTrace("AtlasAsset.xmlOrAtlasError " + this, SOSLog.ERROR);
			
			if (errorCallback != null)
			{
				errorCallback.apply(null, onErrorArgs);
				errorCallback = null;
				onErrorArgs = null;
			}
		}
		
		private function xmlOrAtlasLoaded():void
		{
			if (!imageAssetLoader || !xmlAssetLoader)
				return;
			
			var loadCompleted:Boolean = imageAssetLoader.finished && xmlAssetLoader.finished;
			
			if (loadCompleted)
			{
				var texture:Texture = imageAssetLoader.texture;
				
				var xml:XML = xmlAssetLoader.xml;
				if (texture && xml)
				{
					mTextureAtlas = new TextureAtlas(texture, xml);
				}
				else 
				{
					sosTrace("Failed to load atlas " + mName, SOSLog.ERROR);
				}
				
				_loaded = true;
				
				if (onComplete != null)
				{
					onComplete.apply(null, onCompleteArgs);
					onComplete = null;
					onCompleteArgs = null;
				}
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
			if (mTextureAtlas != null)
			{
				mTextureAtlas.dispose();
				mTextureAtlas = null;
			}
			mTextureCache = {};
			_loaded = false;
		}
		
		public function getTexture(name, stubWidth:uint = 100, stubHeight:uint = 100):Texture
		{
			if (mTextureAtlas == null)
			{
				sosTrace("Atlas " + name + " is not loaded", SOSLog.ERROR);
				return getNotLoadedTexture(stubWidth, stubHeight);
			}
			
			if (!mTextureCache.hasOwnProperty(name))
			{
				mTextureCache[name] = mTextureAtlas.getTexture(name);
			}
			
			var result:Texture = mTextureCache[name];
			if (!result)
			{
				sosTrace("Could not find texture : " + name + " in atlas " + mAtlasFilePath, SOSLog.WARNING);
				result = getNotFoundTexture(stubWidth, stubHeight);
			}
			return result;
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
			return "[AtlasAsset " + mName + " loaded=" + loaded + "]";
		}
		
		public function hasTexture(textureName:String):Boolean
		{
			if (!mTextureAtlas)
			{
				return false;
			}
			
			if (mTextureCache.hasOwnProperty(textureName))
			{
				
				return true;
			}
			
			if (mTextureAtlas.getTexture(textureName))
			{
				
				return true;
			}
			
			return false;
		}
		
		public function get uri():String
		{
			return mAtlasFilePath;
		}
		
		public static const CommonAtlas:AtlasAsset = new AtlasAsset("atlases/common", false);
		public static const LoadingAtlas:AtlasAsset = new AtlasAsset("atlases/loading", false);
		public static const ScratchCardAtlas:AtlasAsset = new AtlasAsset("atlases/scratch_card");
	
	}
}