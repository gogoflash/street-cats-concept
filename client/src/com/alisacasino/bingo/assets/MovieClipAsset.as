package com.alisacasino.bingo.assets
{
	import com.alisacasino.bingo.assets.loading.AssetBase;
	import com.alisacasino.bingo.assets.loading.GAFClipWrapper;
	import com.alisacasino.bingo.assets.loading.assetLoaders.GAFBundleLoader;
	import com.alisacasino.bingo.assets.loading.assetLoaders.ImageAssetLoader;
	import com.alisacasino.bingo.assets.loading.assetLoaders.XMLAssetLoader;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.disposal.DelayedDisposalUtil;
	import com.catalystapps.gaf.core.ZipToGAFAssetConverter;
	import com.catalystapps.gaf.data.GAFBundle;
	import com.catalystapps.gaf.data.GAFTimeline;
	import flash.events.ErrorEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import starling.core.Starling;
	import starling.textures.Texture;
	
	public class MovieClipAsset extends AssetBase implements IAsset
	{
		private var mGameManager:GameManager = GameManager.instance;
		private var mName:String;
		private var linkage:String;
		private var mPackagePath:String;
		private var mPool:Array;
		private var mIsRemovable:Boolean;
		private var callback:Function;
		private var errorCallback:Function;
		private var onCompleteArgs:Array;
		private var onErrorArgs:Array;
		private var _loaded:Boolean;
		private var packageLoader:GAFBundleLoader;
		private var mConvertedMovieClip:GAFClipWrapper;
		private var zipToGAFAssetConverter:ZipToGAFAssetConverter;
		private var gafBundle:GAFBundle;
		
		public function get name():String
		{
			return mName;
		}
		
		public function MovieClipAsset(name:String, isRemovable:Boolean = true, linkage:String = "rootTimeline")
		{
			var baseDir:String;
			if (PlatformServices.isMobile)
			{
				baseDir = String(int(mGameManager.layoutHelper.assetMode)) + "/animations/";
			}
			else
			{
				baseDir = String(int(mGameManager.layoutHelper.assetMode)) + "/animations/";
			}
			mPackagePath = baseDir + name + ".zip";
			mName = name;
			mPool = [];
			mIsRemovable = isRemovable;
			this.linkage = linkage;
		}
		
		public function load(onComplete:Function, onError:Function, onCompleteArgs:Array = null, onErrorArgs:Array = null):void
		{
			callback = onComplete;
			errorCallback = onError;
			this.onCompleteArgs = onCompleteArgs;
			this.onErrorArgs = onErrorArgs;
			
			packageLoader = new GAFBundleLoader(mPackagePath, mName);
			packageLoader.finishOnFail = false;
			packageLoader.addErrorCallback(packageLoadError);
			packageLoader.load(packageLoaded);
			addTrackedLoader(packageLoader);
		}
		
		private function packageLoadError():void
		{
			sosTrace("MovieClipAsset.packageLoadError " + this, SOSLog.ERROR);
			
			if (errorCallback != null)
			{
				errorCallback.apply(null, onErrorArgs);
				errorCallback = null;
				onErrorArgs = null;
			}
		}
		
		private function packageLoaded():void
		{
			if (!packageLoader)
				return;
			
			var loadCompleted:Boolean = packageLoader.finished;
			
			_loaded = true;
			
			if (loadCompleted)
			{
				gafBundle = packageLoader.gafBundle;
				if (gafBundle)
				{
					mConvertedMovieClip = new GAFClipWrapper(gafBundle.getGAFTimeline(mName, linkage), -1, false);
					mConvertedMovieClip.asset = this;
					mConvertedMovieClip.loop = false;
				}
				doCallback();
			}
		}
		
		private function doCallback():void 
		{
			if (callback != null)
			{
				callback.apply(null, onCompleteArgs);
				callback = null;
				onCompleteArgs = null;
			}
		}
		
		
		override public function purge():void
		{
			super.purge();
			if (mConvertedMovieClip)
			{
				mConvertedMovieClip.dispose();
				mConvertedMovieClip = null;
			}
			while (mPool.length)
			{
				(mPool.pop() as GAFClipWrapper).dispose();
			}
			if (packageLoader)
			{
				packageLoader.dispose();
				packageLoader = null;
			}
			
			_loaded = false;
		}
		
		public function get isRemovable():Boolean
		{
			return mIsRemovable;
		}
		
		public function getFromPool(linkageID:String = "rootTimeline", loop:Boolean = false):GAFClipWrapper
		{
			//trace("ConvertedMovieClip::getFromPool, " + mName + " size=" + mPool.length);
			if (!_loaded)
			{
				//throw new Error(mName + " is not loaded, cannot execute getFromPool()");
				sosTrace('MovieClipAsset.getFromPool clip is not loaded: ' + String(mName), SOSLog.ERROR);
				return null;
			}
			
			if (linkageID != "rootTimeline")
			{
				return getClipByLinkage(linkageID, loop);
			}
			
			if (!mConvertedMovieClip)
			{
				return null;
			}
			
			if (mPool.length > 0)
			{
				var clip:GAFClipWrapper = mPool.pop();
				resetClipProperties(clip);
				return clip;
			}
				
			var clone:GAFClipWrapper = mConvertedMovieClip.clone() as GAFClipWrapper;
			clone.loop = false;
			return clone;
		}
		
		private function resetClipProperties(clip:GAFClipWrapper):void 
		{
			clip.scale = 1;
			clip.pivotX = 0;
			clip.pivotY = 0;
			clip.x = 0;
			clip.y = 0;
			clip.gotoAndStop(1);
			clip.loop = false;
		}
		
		public function getClipByLinkage(linkageID:String, loop:Boolean = false):GAFClipWrapper
		{
			var clip:GAFClipWrapper = new GAFClipWrapper(gafBundle.getGAFTimeline(mName, linkageID));
			clip.asset = this;
			clip.loop = loop;
			return clip;
		}
		
		public function getGAFTimelineByLinkage(linkageID:String = "rootTimeline"):GAFTimeline
		{
			return gafBundle ? gafBundle.getGAFTimeline(mName, linkageID) : null;
		}
		
		public function putToPool(movieClip:GAFClipWrapper):void
		{
			if (!movieClip)
				return;
			
			movieClip.removeEventListeners();
			
			if (!_loaded)
			{
				DelayedDisposalUtil.instance.dispose(movieClip);
				return;
			}
      
			if (GameManager.instance.deactivated)
			{
				DelayedDisposalUtil.instance.dispose(movieClip);
				return;
			}
			
			movieClip.gotoAndStop(1);
      
			if (movieClip.gafTimeline.linkage != "rootTimeline")
			{
				DelayedDisposalUtil.instance.dispose(movieClip);
				return;
			}
			
			mPool.push(movieClip);
		}
		
		public function toString():String
		{
			return "[MovieClipAsset '" + mName + "', loaded=" + loaded + "]";
		}
		
		public function getDefaultTimelineID():String
		{
			return "rootTimeline";
		}
		
		public function clearListeners():void 
		{
			callback = null;
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
			return mPackagePath;
		}
		
		static public const PackBase:MovieClipAsset = new MovieClipAsset("pack_base", false);
		static public const PackCommon:MovieClipAsset = new MovieClipAsset("pack_common", false);
		
		//static public const LoadingWheelMovieClip:MovieClipAsset = new MovieClipAsset("loading_white", false);
		//static public const DaubHint:MovieClipAsset = new MovieClipAsset("daub_hint");
		//static public const StarPulse:MovieClipAsset = new MovieClipAsset("star_pulse");
		
		//static public const ChestBronzeOpen:MovieClipAsset = new MovieClipAsset("chest_bronze_open");
		//static public const ChestGoldOpen:MovieClipAsset = new MovieClipAsset("chest_gold_open");
		//static public const ChestSilverOpen:MovieClipAsset = new MovieClipAsset("chest_silver_open");
		//static public const ChestSuperOpen:MovieClipAsset = new MovieClipAsset("chest_super_open");
		//static public const ChestActivateBlue:MovieClipAsset = new MovieClipAsset("chest_activate_blue");
		//static public const ChestActivateGreen:MovieClipAsset = new MovieClipAsset("chest_activate_green");
		//static public const LogoFire:MovieClipAsset = new MovieClipAsset("logo_fire");
		//static public const Splash:MovieClipAsset = new MovieClipAsset("splash");
		//static public const SmokeExplosion:MovieClipAsset = new MovieClipAsset("smoke_explosion");
		//static public const BadBingo:MovieClipAsset = new MovieClipAsset("bad_bingo");
		//static public const MagicSlash:MovieClipAsset = new MovieClipAsset("magic_slash_20");
		//static public const MagicFx:MovieClipAsset = new MovieClipAsset("magic_fx_25");
		//static public const Cats:MovieClipAsset = new MovieClipAsset("cats");
		static public const CatDisconnect:MovieClipAsset = new MovieClipAsset("cat_disconnect");
		static public const CatIdle:MovieClipAsset = new MovieClipAsset("cat_idle");
		
		//static public const X2Fuse:MovieClipAsset = new MovieClipAsset("2xfuze");
		//static public const X2Flame:MovieClipAsset = new MovieClipAsset("2xflame");
		
		//static public const InboxNotify:MovieClipAsset = new MovieClipAsset("inbox_notify");
		//static public const TutorHand:MovieClipAsset = new MovieClipAsset("tutor_hand");
		//static public const Wave:MovieClipAsset = new MovieClipAsset("wave");
		
		//static public const Bulb:MovieClipAsset = new MovieClipAsset("bulb");
		//static public const CardSplash:MovieClipAsset = new MovieClipAsset("card_splash");
		//static public const QuestTablet:MovieClipAsset = new MovieClipAsset("quest_tablet");
		//static public const FunCats:MovieClipAsset = new MovieClipAsset("fun_cats");
		//static public const CatScooter:MovieClipAsset = new MovieClipAsset("cat_scooter", true, "cat_scooter");
		
		//static public const SlotPreview:MovieClipAsset = new MovieClipAsset("slot_preview", true, "slot_preview");
	}
}