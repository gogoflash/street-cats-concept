package com.alisacasino.bingo.commands.gameLoading 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.Preloader;
	import com.alisacasino.bingo.assets.AssetsManager;
	import com.alisacasino.bingo.assets.loading.AssetQueue;
	import com.alisacasino.bingo.commands.ICommand;
	import com.alisacasino.bingo.commands.ParallelCommandSet;
	import com.alisacasino.bingo.commands.SequentialCommandSet;
	import com.alisacasino.bingo.commands.assetIndex.LoadAssetIndices;
	import com.alisacasino.bingo.commands.gameLoading.PreloadCollectionCards;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.SignInMessage.Platform;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.screens.LoadingScreen;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.ServerConnection;
	import com.alisacasino.bingo.utils.Settings;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.analytics.events.LoadingStateEvent;
	import com.alisacasino.bingo.utils.sharedObjects.SharedObjectManager;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.utils.getTimer;
	import starling.core.Starling;
	import starling.events.Event;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class LoadGame extends CommandBase
	{
		private var loadingScreen:LoadingScreen;
		private var loadingStopped:Boolean;
		private var connectToServerCommand:ICommand;
		private var loadSettingsAndIndices:ParallelCommandSet;
		private var id:String;
		private var connectToFacebook:ConnectToFacebook;
		
		public function LoadGame(loadingScreen:LoadingScreen) 
		{
			id = int(Math.random() * int.MAX_VALUE).toString(36);
			this.loadingScreen = loadingScreen;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			gameManager.analyticsManager.sendEvent(new LoadingStateEvent(LoadingStateEvent.LOADING_STARTED));
			
			SoundManager.instance.stopSoundtrack();
			
			hidePreloader();
			
			startLoading();
		}
		
		private function hidePreloader():void 
		{
			if (!gameManager.preloader || !gameManager.preloader.backgroundContainer)
			{
				sosTrace("Could not find preloader background", SOSLog.WARNING);
			}
			
			
			var backgroundContainer:Sprite = gameManager.preloader.backgroundContainer;
			if (!backgroundContainer.parent)
			{
				return;
			}
			
			backgroundContainer.parent.removeChild(backgroundContainer);
		}
		
		public function startLoading():void
		{
			sosTrace( "LoadGame.startLoading" );
			loadingStopped = false;
			
			if (PlatformServices.isCanvas)
			{
				loadStaticSettings();
			}
			else
			{
				AssetsManager.instance.loadAssetsIfNeeded(loadingScreen.getAssetsForDisplay(), loadSettingsOnMobile);
				//loadLoadingScreenAssets(showLoadingScreenOnMobile);
			}
		}
		
		private function loadSettingsOnMobile():void 
		{
			sosTrace( "LoadGame.loadSettingsOnMobile" );
			Preloader.showStatusPixels(Preloader.STATUS_LOADING_ASSETS_COMPLETE, loadingStopped ? 3 : 1);
			if (loadingStopped)
				return;
				
			var loadSettingsCommand:LoadSettings = new LoadSettings();
			loadSettingsCommand.execute(showLoadingScreenOnMobile, showLoadingScreenOnMobile);
			
			preloadStaticAssets();
		}
		
		private function showLoadingScreenOnMobile():void 
		{
			sosTrace( "LoadGame.showLoadingScreenOnMobile" );
			Preloader.showStatusPixels(Preloader.STATUS_SETTINGS_COMPLETE, loadingStopped ? 3 : 1);
			if (loadingStopped)
				return;
				
			loadingScreen.showContents(false, ' 2 ');
			
			if (PlatformServices.facebookManager.isConnected || !SharedObjectManager.instance.getSharedProperty(Constants.SHARED_PROPERTY_FIRST_START))
				loadingScreen.showProgress();
			else
				loadingScreen.showFacebookLoginBlock();
				
			loadingScreen.preloaderPosition = LoadingScreen.SETTINGS_LOADED_POSITION;
			
			loadStaticSettings(false);
		}
		
		private function loadStaticSettings(loadSettings:Boolean = true):void 
		{
			sosTrace( "LoadGame.loadStaticSettings" );
			loadSettingsAndIndices = new ParallelCommandSet();
			
			loadSettingsAndIndices.addCommandToSet(createLoadRequiredContentChain(loadSettings));
			
			loadSettingsAndIndices.execute(staticSettingsLoaded, retryLoading);
		}
		
		private function createLoadRequiredContentChain(loadSettings:Boolean = true):ICommand
		{
			var loadRequiredContentChain:SequentialCommandSet = new SequentialCommandSet();
			if(loadSettings)
				loadRequiredContentChain.addCommandToSet(new LoadSettings().addCompleteCallback(onSettingsLoaded));
			loadRequiredContentChain.addCommandToSet(new LoadAssetIndices().addCompleteCallback(onAssetIndicesLoaded));
			
			return loadRequiredContentChain;
		}
		
		private function onSettingsLoaded():void 
		{
			Preloader.showStatusPixels(Preloader.STATUS_SETTINGS_COMPLETE, loadingStopped ? 3 : 1);
			sosTrace( "LoadGame.onSettingsLoaded");
			loadingScreen.preloaderPosition = LoadingScreen.SETTINGS_LOADED_POSITION;
		}
		
		private function onAssetIndicesLoaded():void 
		{
			Preloader.showStatusPixels(Preloader.STATUS_ASSET_INDICES_COMPLETE, loadingStopped ? 3 : 1);
			sosTrace( "LoadGame.onAssetIndicesLoaded" );
			loadingScreen.preloaderPosition = LoadingScreen.ASSET_INDICES_LOADED_POSITION;
		}
		
		private function retryLoading():void 
		{
			sosTrace( "LoadGame.retryLoading");
			if (loadingStopped)
				return;
			
			stopRunningCommands();
			
			ServerConnection.current = null;
			
			startExecution();
		}
		
		private function staticSettingsLoaded():void 
		{
			sosTrace( "LoadGame.staticSettingsLoaded" );
			if (loadingStopped)
				return;
			
			//GameScreen.debugShowTextField('LoadGame 0 load LoadingScreenAssets', true);
			
			loadLoadingScreenAssets(showMaintenanceIfNeeded);
		}
		
		private function loadLoadingScreenAssets(onComplete:Function):void 
		{
			sosTrace( "LoadGame.loadLoadingScreenAssets > onComplete : ");
			AssetsManager.instance.loadAssetsIfNeeded(loadingScreen.getAssetsForDisplay(), onComplete);
		}
		
		private function showMaintenanceIfNeeded():void 
		{
			if (PlatformServices.isCanvas)
				Preloader.showStatusPixels(Preloader.STATUS_LOADING_ASSETS_COMPLETE, loadingStopped ? 3 : 1);
			
			Preloader.showStatusPixels(Preloader.STATUS_MAINTENANCE_IF_NEEDED, loadingStopped ? 3 : 1);
			
			sosTrace( "LoadGame.showMaintenanceIfNeeded" );
			if (Settings.instance.maintenance && !Settings.instance.isAdmin)
			{
				if (loadingScreen)
					loadingScreen.showMaintenanceDialog();
				return;
			}
			
			if (loadingScreen && PlatformServices.isCanvas)
			{
				//GameScreen.debugShowTextField('LoadGame showMaintenanceIfNeeded loadingScreen.showContents()', true);
				loadingScreen.showContents(false, ' 1 ');
			
				if(!Constants.isLocalBuild)
					loadingScreen.showProgress();
			}
			
			//GameScreen.debugShowTextField('LoadGame 1', true);
			
			if (Constants.isLocalBuild)
			{
				new LocalStartSettings().execute(function():void {
					connectToFacebook = new ConnectToFacebook(loadingScreen);
					connectToFacebook.execute(connectToServer, connectToServer);
				});
			}
			else
			{
				connectToFacebook = new ConnectToFacebook(loadingScreen);
				connectToFacebook.execute(connectToServer, connectToServer);
			}
			
			if (PlatformServices.isCanvas)
			{
				preloadStaticAssets();
			}
		}
		
		private function preloadStaticAssets():void 
		{
			sosTrace( "LoadGame.preloadStaticAssets", SOSLog.FINER);
			Game.current.staticAssetPreloadQueue = AssetsManager.instance.loadAssetsIfNeeded(GameScreen.getFirstSessionPreload(), null, "staticPreload");
		}
		
		private function connectToServer():void 
		{
			sosTrace(id + " LoadGame.connectToServer" );
			gameManager.analyticsManager.sendEvent(new LoadingStateEvent(LoadingStateEvent.SERVER_CONNECTION_STARTED));
			connectToServerCommand = new ConnectToServer().execute(onServerConnect, retryLoading);
		}
		
		private function onServerConnect():void 
		{
			Preloader.showStatusPixels(Preloader.STATUS_CONNECTED_TO_SERVER, loadingStopped ? 3 : 1);
			sosTrace( "LoadGame.onServerConnect" );
			gameManager.analyticsManager.sendEvent(new LoadingStateEvent(LoadingStateEvent.ASSET_LOADING));
			finish();
		}
		
		override protected function stopInternal():void 
		{
			sosTrace( "LoadGame.stopInternal", new Error().getStackTrace(), SOSLog.DEBUG);
			super.stopInternal();
			loadingStopped = true;
			stopRunningCommands();
		}
		
		private function stopRunningCommands():void 
		{
			if (connectToServerCommand)
			{
				connectToServerCommand.stop();
				connectToServerCommand = null;
			}
			
			if (loadSettingsAndIndices)
			{
				loadSettingsAndIndices.stop();
				loadSettingsAndIndices = null;
			}
			
			if (connectToFacebook)
			{
				connectToFacebook.stop();
				connectToFacebook = null;
			}
		}
		
	}

}