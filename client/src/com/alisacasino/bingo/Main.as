package com.alisacasino.bingo
{
	import com.alisacasino.bingo.commands.gameLoading.AddErrorHandlers;
	import com.alisacasino.bingo.controls.BingoTrueTypeCompositor;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.SignInMessage.Platform;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.IPhoneModelDecoder;
	import com.alisacasino.bingo.utils.analytics.events.LoadingStateEvent;
	import com.alisacasino.bingo.utils.keyboard.KeyboardController;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.text.ITextCompositor;
	import starling.text.TextField;
	
	public class Main extends Sprite
	{
		private var mStarling:Starling;
		private var mGameManager:GameManager = GameManager.instance;
		public static var instance:Main;
		
		public function Main(preloader:Preloader)
		{
			gameManager.preloader = preloader;
			
			new AddErrorHandlers(preloader.loaderInfo).execute();
			
			PlatformServices.interceptor.loadPolicyFiles();
			instance = this;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
			
		public function onAddedToStage(e:Event):void
		{
			
			if (PlatformServices.isCanvas)
			{
				if (Constants.isLocalBuild)
				{
					setDebugAccessToken();
				}
				else
				{
					readLoaderParameters();
				}
			}
			else 
			{
				PlatformServices.interceptor.initFullscreen(stage);
			}
			
			mGameManager.appDomain = this.loaderInfo.applicationDomain;
			mGameManager.stage = stage;
			
			/*if (PlatformServices.isAndroid || Constants.isLocalBuild)
				Starling.handleLostContext = true;
			else
				Starling.handleLostContext = false;*/
				//return;
			if (PlatformServices.isCanvas)
			{
				stage.scaleMode = StageScaleMode.NO_SCALE; // otherwise stage.stageWidth, stage.stageHeight will be incorrect
				mGameManager.layoutHelper.initScreen(stage.stageWidth, stage.stageHeight);
			}
			
			gameManager.analyticsManager.sendEvent(new LoadingStateEvent(LoadingStateEvent.INITIALIZED));
			
			var viewPort:Rectangle = new Rectangle(0, 0, mGameManager.layoutHelper.realScreenWidth, mGameManager.layoutHelper.realScreenHeight);
			
			Preloader.showStatusPixels(Preloader.STATUS_MAIN_ON_STAGE);
			//return;
			mStarling = new Starling(Game, stage, viewPort);
			mStarling.stage.stageWidth = mGameManager.layoutHelper.stageWidth;
			mStarling.stage.stageHeight = mGameManager.layoutHelper.stageHeight;
			//mStarling.antiAliasing = 1;
			mStarling.skipUnchangedFrames = true;
			
			DisplayObject.optionalFiltersDisabled = IPhoneModelDecoder.needToDisableFilters(PlatformServices.interceptor.getDeviceModelRaw());
			
			var rootSprite:Sprite = Starling.current.nativeStage.getChildAt(0) as Sprite;
			rootSprite.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, Game.uncaughtErrorHandler);
			
			if (PlatformServices.isCanvas && !Constants.isLocalBuild)
			{
				ExternalInterface.addCallback('exportScreenshot', PlatformServices.interceptor.exportScreenshot);
				ExternalInterface.addCallback('exportScreenshotHalfSized', PlatformServices.interceptor.exportScreenshotHalfSized);
			}
				
			mStarling.start();
			
			new KeyboardController(stage);
			EffectsManager.initialize();
			TextField.defaultCompositor = new BingoTrueTypeCompositor();
			
			//stage.addEventListener(Event.RESIZE, stage_resizeHandler);
		}
		
		private function readLoaderParameters():void 
		{
			mGameManager.accessToken = stage.loaderInfo.parameters["access_token"];
			mGameManager.facebookId = stage.loaderInfo.parameters["facebook_id"];
			
			// freebies
			mGameManager.freebiesManager.parseFreebies(stage.loaderInfo.parameters["offer_ref"]);
			
			if (PlatformServices.isCanvas)
			{
				storeTrackingData();
			}
		}
		
		private function storeTrackingData():void 
		{
			var trackingData:Object = {};
			for (var fieldName:String in stage.loaderInfo.parameters) 
			{
				if (fieldName == "access_token" || fieldName == "facebook_id")
					continue;
				
				
				trackingData[fieldName] = stage.loaderInfo.parameters[fieldName];
			}
			
			gameManager.trackingData = JSON.stringify(trackingData);
			gameManager.trackingDataAppOpen = gameManager.trackingData;
		}
		
		private function setDebugAccessToken():void
		{
			mGameManager.accessToken = "CAAHdlrvprbIBAKLL5gblAYCjlhsTzKlBSuuuAiLhfhrcbAkRC9rdEwJICfw8fbZBnSwTM5QUvtPfDYmT6wVpD9j8Jd97m0NEgYX53Uua2FxdT56t7qsvLCgllnPXBKAo7PdXSvL6IZCOcKeKHuZAM0LV0Q3upJOyHmuhBIQYMyZBjP6sE62VmzPxM2NUSN0ZD";
			mGameManager.facebookId = "100004649500056";
		}
		
		private function stage_resizeHandler(e:Event):void 
		{
			sosTrace('Main.resize ' + stage.stageWidth + " " + stage.stageHeight,SOSLog.SYSTEM);
		}
		
			
	}
}