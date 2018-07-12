package com.alisacasino.bingo.platform
{
	import com.alisacasino.bingo.platform.canvas.CanvasFacebookManager;
	import com.alisacasino.bingo.platform.canvas.CanvasInterceptor;
	import com.alisacasino.bingo.platform.mobile.MobileFacebookManager;
	import com.alisacasino.bingo.platform.mobile.MobileInterceptor;
	import com.alisacasino.bingo.protocol.SignInMessage.Platform;
	import com.alisacasino.bingo.store.AmazonStore;
	import com.alisacasino.bingo.store.AppleAppStore;
	import com.alisacasino.bingo.store.FacebookStore;
	import com.alisacasino.bingo.store.FakeStore;
	import com.alisacasino.bingo.store.GooglePlayStore;
	import com.alisacasino.bingo.store.IStore;
	import com.alisacasino.bingo.utils.Constants;
	
	import flash.system.Capabilities;
	
	public class PlatformServices
	{
		private static var sInterceptor:IInterceptor = null;
		private static var sFacebookManager:IFacebookManager = null;
		
		public static function get interceptor():IInterceptor
		{
			if (sInterceptor == null)
			{
				if (PlatformServices.isMobile)
				{
					sInterceptor = new MobileInterceptor();
				}
				else
				{
					sInterceptor = new CanvasInterceptor();
				}
			}
			return sInterceptor;
		}
		
		public static function get facebookManager():IFacebookManager
		{
			if (sFacebookManager == null)
			{
				if (PlatformServices.isMobile)
				{
					sFacebookManager = new MobileFacebookManager();
				}
				else
				{
					sFacebookManager = new CanvasFacebookManager();
				}
			}
			return sFacebookManager;
		}
		
		public static function get store():IStore
		{
			if (PlatformServices.isMobile)
			{
				switch (platform)
				{
					case Platform.GOOGLE_PLAY: 
						return GooglePlayStore.instance;
					case Platform.AMAZON_APP_STORE: 
						return AmazonStore.instance;
					case Platform.APPLE_APP_STORE: 
						return AppleAppStore.instance;
					default: 
						return FakeStore.instance;
				}
			}
			else
			{
				if (Constants.isLocalBuild)
				{
					return FakeStore.instance;
				}
				else
				{
					return FacebookStore.instance;
				}
			}
		}
		
		private static var cachedAndroid:int = -1;
		
		public static function get isAndroid():Boolean
		{
			if (cachedAndroid == -1)
			{
				cachedAndroid = (Capabilities.version.substr(0, 3) == "AND") ? 1 : 0;
			}
			return cachedAndroid == 1;
		}
		
		private static var cachedIOS:int = -1
		
		public static function get isIOS():Boolean
		{
			if (cachedIOS == -1)
			{
				cachedIOS = (Capabilities.version.substr(0, 3) == "IOS") ? 1 : 0;
			}
			return cachedIOS == 1;
		}
		
		private static var cachedSimulator:int = -1;
		
		public static function get isSimulator():Boolean
		{
			if (cachedSimulator == -1)
			{
				cachedSimulator = (Capabilities.playerType == "Desktop") ? 1 : 0;
			}
			return cachedSimulator == 1;
		}
		
		public static function getIOSMajorVersion():int
		{
			var iosVersion:String = Capabilities.os.match(/([0-9]\.?){2,3}/)[0];
			var majorVersion:int = int(iosVersion.substr(0, iosVersion.indexOf(".")));
			return majorVersion;
		}
		
		public static function get platform():int
		{
			if (isAndroid)
			{
				if (Constants.isAmazonBuild)
					return Platform.AMAZON_APP_STORE;
				else
					return Platform.GOOGLE_PLAY;
			}
			else if (isIOS)
			{
				
				return Platform.APPLE_APP_STORE;
			}
			else if (isSimulator)
			{
				return Platform.FACEBOOK;
			}
			else
			{
				return Platform.FACEBOOK;
			}
		}
		
		public static function get isCanvas():Boolean
		{
			return platform == Platform.FACEBOOK;
		}
		
		public static function get isMobile():Boolean
		{
			return !isCanvas;
		}
	}
}
