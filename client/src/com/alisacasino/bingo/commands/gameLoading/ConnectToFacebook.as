package com.alisacasino.bingo.commands.gameLoading 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.Main;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.platform.IFacebookManager;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.screens.LoadingScreen;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.sharedObjects.SharedObjectManager;
	import starling.core.Starling;
	import starling.events.Event;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ConnectToFacebook extends CommandBase
	{
		private var mFacebookManager:IFacebookManager;
		private var loadingScreen:LoadingScreen;
		
		public function ConnectToFacebook(loadingScreen:LoadingScreen = null) 
		{
			this.loadingScreen = loadingScreen;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			Game.addEventListener(Game.FACEBOOK_SESSION_OPENED_EVENT, facebookSessionOpenedEventHandler);
			Game.addEventListener(Game.FACEBOOK_SESSION_ERROR_EVENT, facebookSessionErrorEventHandler);
			Game.addEventListener(Game.FACEBOOK_ME_REQUEST_COMPLETED_EVENT, facebookMeRequestCompletedEventHandler);
			Game.addEventListener(Game.FACEBOOK_ME_REQUEST_ERROR_EVENT, facebookMeRequestErrorEventHandler);
			Game.addEventListener(Game.FACEBOOK_ME_REQUEST_CANCELLED_EVENT, facebookMeRequestCancelledEventHandler);
			Game.addEventListener(Game.FACEBOOK_LOGIN_CANCELLED, facebookLoginCancelledHandler);
			
			mFacebookManager = PlatformServices.facebookManager;
			
			if (mFacebookManager.isConnected)
			{
				mFacebookManager.startMeRequest();
				hideLoadingScreenLoginBlock();
			}
			else
			{
				//GameScreen.debugShowTextField(' 1 showFacebookLoginBlock', true);
				showFacebookLoginBlock();
			}
		}
		
		private function facebookLoginCancelledHandler(e:Event):void 
		{
			hideLoadingScreenLoginBlock();
			Starling.juggler.delayCall(finish, 0.5);
		}
		
		private function hideLoadingScreenLoginBlock():void 
		{
			if (loadingScreen)
			{
				loadingScreen.hideFacebookLoginBlock();
				loadingScreen.showProgress();
			}
		}
		
		public function showFacebookLoginBlock():void
		{
			// в первой сессии не показываем коннект к фейсбуку
			if (PlatformServices.isMobile && !SharedObjectManager.instance.getSharedProperty(Constants.SHARED_PROPERTY_FIRST_START)) 
			{
				if (loadingScreen) {
					loadingScreen.hideFacebookLoginBlock();	
					loadingScreen.showProgress();
				}
					
				Starling.juggler.delayCall(finish, 0.5);
					
				return;
			}
			
			if (loadingScreen)
			{
				loadingScreen.showFacebookLoginBlock();
			}
		}
		
		override protected function finish():void 
		{
			hideLoadingScreenLoginBlock();
			removeGameListeners();
			super.finish();
		}
		
		override protected function stopInternal():void 
		{
			super.stopInternal();
			removeGameListeners();
		}
		
		private function removeGameListeners():void 
		{
			Game.removeEventListener(Game.FACEBOOK_SESSION_OPENED_EVENT, facebookSessionOpenedEventHandler);
			Game.removeEventListener(Game.FACEBOOK_SESSION_ERROR_EVENT, facebookSessionErrorEventHandler);
			Game.removeEventListener(Game.FACEBOOK_ME_REQUEST_COMPLETED_EVENT, facebookMeRequestCompletedEventHandler);
			Game.removeEventListener(Game.FACEBOOK_ME_REQUEST_ERROR_EVENT, facebookMeRequestErrorEventHandler);
			Game.removeEventListener(Game.FACEBOOK_ME_REQUEST_CANCELLED_EVENT, facebookMeRequestCancelledEventHandler);
			Game.removeEventListener(Game.FACEBOOK_LOGIN_CANCELLED, facebookLoginCancelledHandler);
		}
		
		private function facebookMeRequestCancelledEventHandler(e:Event):void 
		{
			finish();
		}
		
		public function facebookSessionOpenedEventHandler(e:Event = null):void
		{
			mFacebookManager.startMeRequest();
			updateProgress(0.5);
			hideLoadingScreenLoginBlock();
		}
		
		public function facebookSessionErrorEventHandler(e:Event):void
		{
			if (PlatformServices.isMobile)
			{
				//GameScreen.debugShowTextField(' 2 showFacebookLoginBlock', true);
				showFacebookLoginBlock();
			}
			else
			{
				fail();
			}
		}
		
		public function facebookMeRequestCompletedEventHandler(e:Event):void
		{
			finish();
		}
		
		public function facebookMeRequestErrorEventHandler(e:Event):void
		{
			if (PlatformServices.isMobile)
			{
				//GameScreen.debugShowTextField(' 3 showFacebookLoginBlock', true);
				showFacebookLoginBlock();
			}
			else
			{
				fail();
			}
		}
		
		override protected function fail():void 
		{
			removeGameListeners();
			super.fail();
		}
		
	}

}