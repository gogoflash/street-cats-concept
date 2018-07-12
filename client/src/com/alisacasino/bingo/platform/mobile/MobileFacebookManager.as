package com.alisacasino.bingo.platform.mobile
{
	import by.blooddy.crypto.image.PNGEncoder;
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.platform.FacebookManagerBase;
	import com.alisacasino.bingo.platform.IFacebookManager;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.platform.mobile.goViralProxyingClasses.GoViralProxy;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.FacebookData;
	import com.alisacasino.bingo.utils.ScreenshotUtils;
	import com.milkmangames.nativeextensions.GVFacebookFriend;
	import com.milkmangames.nativeextensions.events.GVFacebookEvent;
	import com.alisacasino.bingo.platform.mobile.goViralProxyingClasses.IGoViralImplementation;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	public class MobileFacebookManager extends FacebookManagerBase implements IFacebookManager
	{
		private static var sInstance:MobileFacebookManager = null;
		
		private var mIsInitialized:Boolean = false;
		
		private var mFacebookId:String;
		
		private var mFacebookData:FacebookData = FacebookData.instance;
		
		private var mHasPublishPermission:Boolean = false;
		private var mHasUserFriendsPermission:Boolean = false;
		private var mConnectRequestedExplicitly:Boolean = false;
		
		private var mPublishCallback:Function = null;
		private var goViralProxy:IGoViralImplementation;
		
		public static function get instance():MobileFacebookManager
		{
			if (sInstance == null) {
				sInstance = new MobileFacebookManager();
			}
			return sInstance;
		}
		
		public function MobileFacebookManager() 
		{
			super();
			goViralProxy = GoViralProxy.getImplementation();
			init();
		}
		
		override public function get isConnected():Boolean
		{
			return goViralProxy.isFacebookAuthenticated();
		}
		
		/*
		public function dialog(method, parameters:Object, callback:Function):void
		{
			goViralProxy.showFacebookRequestDialog(parameters.message, parameters.title, null, null, parameters.to, null, true, null, null, null).addDialogListener(callback);
		}
		*/
		
		public function openSession():void
		{
			mConnectRequestedExplicitly = true;
			
			if (!goViralProxy.isFacebookAuthenticated()) 
			{
				goViralProxy.authenticateWithFacebook("public_profile, email, user_friends, publish_actions");
			}
		}
		
		public function startMeRequest():void
		{
			mHasPublishPermission = goViralProxy.isFacebookPermissionGranted("publish_actions");
			mHasUserFriendsPermission = goViralProxy.isFacebookPermissionGranted("user_friends");
			
			goViralProxy.requestMyFacebookProfile().addRequestListener(meRequestCallback);
		}
		
		public function logOut():void
		{
			goViralProxy.logoutFacebook();
			Game.dispatchEventWith(Game.FACEBOOK_LOGOUT_EVENT);
		}
		
		private function meRequestCallback(e:GVFacebookEvent):void
		{
			if (e.type != GVFacebookEvent.FB_REQUEST_RESPONSE) {
				Game.dispatchEventWith(Game.FACEBOOK_ME_REQUEST_ERROR_EVENT);
			} else {
				var myProfile:GVFacebookFriend=e.friends[0];
				mFacebookId = myProfile.id;
				requestFriendIfNotGivenUntilGiven();
			}
		}
		
		private function requestFriendIfNotGivenUntilGiven():void
		{
			mHasUserFriendsPermission = goViralProxy.isFacebookPermissionGranted("user_friends");
			if (mHasUserFriendsPermission == false) {
				goViralProxy.requestNewFacebookReadPermissions("user_friends");
			} else {
				mFacebookData.clearAndInit();
			}
		}
		
		public function get hasUserFriendsPermission():Boolean
		{
			return mHasUserFriendsPermission;
		}
		
		public function publishRoomVisitedStory(roomTypeName:String, roomTitle:String):void
		{
			if(!isConnected) {
				return;
			}
			if(mFacebookData.publishedVisitedRoomTypeNames.indexOf(roomTitle) == -1 && mHasPublishPermission) {
				publishOpengraphStoryViaHttpPost("room", roomTypeName);
				mFacebookData.publishedVisitedRoomTypeNames.push(roomTitle);
			}
		}
		
		
		public function publishItemFoundStory(itemName:String, explicitlyShared:Boolean=false):void
		{
			if(!isConnected) {
				return;
			}
			if (mHasPublishPermission) {
				publish();
			} else {
				requestPublishPermissions(publish);
			}
			
			function publish(..._):void
			{
				if (mHasPublishPermission) {
					publishOpengraphStoryViaHttpPost("item", itemName, explicitlyShared);
				}
			}
		}
		
		
		
		private function requestPublishPermissions(callback:Function):void
		{
			goViralProxy.requestNewFacebookPublishPermissions("publish_actions");
			mPublishCallback = callback;
		}
		
		public function get facebookId():String
		{
			return mFacebookId;
		}
		
		override public function get accessToken():String
		{
			return goViralProxy.getFbAccessToken();
		}
		
		public function likePage():void
		{
			goViralProxy.presentFacebookPageOrProfile(Constants.FACEBOOK_PAGE_ID);
		}
		
		
		
		public function init():void
		{
			if(mIsInitialized) {
				return;
			}
			mIsInitialized = true;
			
			// check if GoViral is supported on the machine currently running it
			if (!goViralProxy.isSupported())
			{
				trace("Extension is not supported on this platform.");
				sosTrace("Extension is not supported on this platform.", SOSLog.ERROR);
				return;
			}
			
			goViralProxy.create();
			
			trace("GoViral Extension Initialized: "+goViralProxy.getVersion());
			sosTrace("GoViral Extension Initialized: "+goViralProxy.getVersion(), SOSLog.DEBUG);
			
			// initialize facebook.		
			if (!goViralProxy.isFacebookSupported())
			{
				trace("Sorry, this device does not support Facebook with Adobe AIR.  You can get around this by compiling on a mac with instructions from https://bugbase.adobe.com/index.cfm?event=bug&id=3686856");
			}
			else
			{
				trace("Initializing facebook...");
				goViralProxy.initFacebook(getAppID(), "");
				trace("Facebook Initialized! GoViral v"+goViralProxy.getVersion());
			}
			
			// set up all the event listeners.
			// you only need the ones for the services you want to use.
			
			// facebook events
			goViralProxy.addEventListener(GVFacebookEvent.FB_LOGGED_IN,onFacebookEvent);
			goViralProxy.addEventListener(GVFacebookEvent.FB_LOGIN_FAILED,onFacebookEvent);
			goViralProxy.addEventListener(GVFacebookEvent.FB_LOGIN_CANCELED,onFacebookEvent);
			goViralProxy.addEventListener(GVFacebookEvent.FB_REQUEST_RESPONSE, goViralProxy_fbRequestResponseHandler);
			
			// facebook events for manually updating permissions
			goViralProxy.addEventListener(GVFacebookEvent.FB_READ_PERMISSIONS_UPDATED, onFacebookEvent);
			goViralProxy.addEventListener(GVFacebookEvent.FB_PUBLISH_PERMISSIONS_UPDATED, onFacebookEvent);
		}
		
		private function goViralProxy_fbRequestResponseHandler(e:GVFacebookEvent):void 
		{
			sosTrace( "MobileFacebookManager.goViralProxy_fbRequestResponseHandler > e : " + e, SOSLog.DEBUG);
		}
		
		public function dialog(method:String, parameters:Object = null, callback:Function = null, allowNativeUI:Boolean = true):void 
		{
			goViralProxy.showFacebookGameRequestDialog(parameters.message, parameters.title, null, null, parameters.to, null, null, null, false).addDialogListener(callback);
		}
		
		
		public function join():void 
		{
			if(mFacebookData.isInitialized()) {
				Game.dispatchEventWith(Game.FACEBOOK_ME_REQUEST_COMPLETED_EVENT);
				trace("join done");
			}
		}
		
		public function get hasPublishPermission():Boolean 
		{
			return mHasPublishPermission;
		}
		
		private function onFacebookEvent(e:GVFacebookEvent):void
		{
			sosTrace( "MobileFacebookManager.onFacebookEvent > e : " + e, SOSLog.DEBUG);
			if (e.errorMessage)
			{
				sosTrace( "MobileFacebookManager e.errorMessage : " + e.errorMessage, SOSLog.ERROR);
			}
			switch(e.type)
			{
				case GVFacebookEvent.FB_LOGIN_FAILED:
					Game.dispatchEventWith(Game.FACEBOOK_ME_REQUEST_ERROR_EVENT);
					break;
					
				case GVFacebookEvent.FB_LOGIN_CANCELED:
					Game.dispatchEventWith(Game.FACEBOOK_ME_REQUEST_CANCELLED_EVENT);
					break;
				
				case GVFacebookEvent.FB_LOGGED_IN:
					Game.dispatchEventWith(Game.FACEBOOK_SESSION_OPENED_EVENT);
					mConnectRequestedExplicitly = false;
					break;
				
				case GVFacebookEvent.FB_READ_PERMISSIONS_UPDATED:
					requestFriendIfNotGivenUntilGiven();
					break;
				
				case GVFacebookEvent.FB_PUBLISH_PERMISSIONS_UPDATED:
					mHasPublishPermission = goViralProxy.isFacebookPermissionGranted("publish_actions");
					if(mPublishCallback) {
						mPublishCallback();
					}
					mPublishCallback = null;
					break;
			}
		}
	}
}
