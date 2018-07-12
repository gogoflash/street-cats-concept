package com.alisacasino.bingo.platform.canvas
{
	import by.blooddy.crypto.image.JPEGEncoder;
	import by.blooddy.crypto.image.PNGEncoder;
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.platform.FacebookManagerBase;
	import com.alisacasino.bingo.platform.IFacebookManager;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.FacebookData;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.ScreenshotUtils;
	import com.jonas.net.Multipart;
	import flash.display.BitmapData;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequestHeader;
	
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.setTimeout;
	
	import starling.core.Starling;
	
	public class CanvasFacebookManager extends FacebookManagerBase implements IFacebookManager
	{
		private var mFacebookData:FacebookData = FacebookData.instance;
		
		private var mHasPublishPermission:Boolean = false;
		private var mHasUserFriendsPermission:Boolean = false;
		private var permissionsCallback:Function;
		
		public function CanvasFacebookManager() 
		{
			super();
		}
		
		override public function get isConnected():Boolean
		{
			if (Constants.isLocalBuild)
			{
				return false;
			}
			return true;
		}
		
		public function login(parameters:Object, callback:Function=null):void
		{
			ExternalInterface.addCallback('facebookCallback', callback);
			showFbDialog("fbLogin", parameters);
		}
		
		public function dialog(method:String, parameters:Object=null, callback:Function=null, allowNativeUI:Boolean=true):void
		{
			if(ExternalInterface.available)
				ExternalInterface.addCallback('facebookCallback', callback);
			
			if(parameters) {
				parameters.frictionless = "1";
				parameters.method = method;
			}
			showFbDialog("fbUI", parameters);
		}
		
		public function openSession():void
		{
		}
		
		public function startMeRequest():void
		{
			meRequestCallback();
		}
		
		public function logOut():void
		{
		}
		
		private function openSessionCallback(success:Boolean, userCancelled:Boolean, error:String = null):void
		{
			if (success) {
				Game.dispatchEventWith(Game.FACEBOOK_SESSION_OPENED_EVENT);
			} else {
				Game.dispatchEventWith(Game.FACEBOOK_SESSION_ERROR_EVENT);
			}
		}
		
		private function meRequestCallback():void
		{
			requestPermissionsIfNotGiven(join);
		}
		
		public function join():void {
			trace("join: mFacebookData.isInitialized()="+mFacebookData.isInitialized());
			if(mFacebookData.isInitialized() || Constants.isLocalBuild) {
				Game.dispatchEventWith(Game.FACEBOOK_ME_REQUEST_COMPLETED_EVENT);
				trace("join done");
			}
		}
		
		public function get hasPublishPermission():Boolean
		{
			return mHasPublishPermission;
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
			if(mFacebookData.publishedVisitedRoomTypeNames.indexOf(roomTitle) == -1  && hasPublishPermission) {
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
				rerequestPermissions('publish_actions', publish);
			}
			
			function publish(..._):void
			{
				publishOpengraphStoryViaHttpPost("item", itemName, explicitlyShared);
			}
		}
		
		private function requestPermissionsIfNotGiven(callback:Function):void
		{
			permissionsCallback = callback;
			try {
				var loader : URLLoader = new URLLoader();
				var httpRequest : URLRequest = new URLRequest("https://graph.facebook.com/v2.7/me/permissions" +
					"?access_token=" + PlatformServices.facebookManager.accessToken + "&method=GET");
				
				httpRequest.method = URLRequestMethod.GET;
				loader.addEventListener(Event.COMPLETE, onComplete);
				if (Constants.isLocalBuild)
				{
					loader.addEventListener(IOErrorEvent.IO_ERROR, loader_ioErrorHandlerLocal);
				}
				else 
				{
					loader.addEventListener(IOErrorEvent.IO_ERROR, loader_ioErrorHandler);
				}
				
				loader.dataFormat = URLLoaderDataFormat.TEXT;
				loader.load(httpRequest);
				
				function onComplete (event:Event):void {
					var response:Object = JSON.parse(event.target.data);
					
					parsePermissionsResponse(response);
					
					// User hasn't granted "user_friends" permissions
					if (mHasUserFriendsPermission == false) {
						rerequestPermissions('user_friends');
					} else {
						mFacebookData.clearAndInit();
					}
					
					function parsePermissionsResponse(arg:Object):void
					{
						mHasPublishPermission = false;
						mHasUserFriendsPermission = false;
						
						//sosTrace('Facebook permittions: ', arg);		
						
						if (arg.hasOwnProperty("data") && arg.data.length > 0) {
							for each (var entry:Object in arg.data) {
								
								if (entry.permission == "publish_actions" && entry.status == "granted") {
									mHasPublishPermission = true;
								}
								
								if (entry.permission == "user_friends" && entry.status == "granted") {
									mHasUserFriendsPermission = true;
								}
							}
						}
					}
					
					if(callback) {
						callback();
					}
				}
				
			} catch (e:Error) {
				trace(e);
				Game.connectionManager.sendClientMessage(e.getStackTrace());
			}
		}
		
		private function loader_ioErrorHandler(e:IOErrorEvent):void 
		{
			sosTrace( "CanvasFacebookManager.loader_ioErrorHandler > e : " + e, SOSLog.ERROR);
		}
		
		private function loader_ioErrorHandlerLocal(e:IOErrorEvent):void 
		{
			sosTrace( "CanvasFacebookManager.loader_ioErrorHandlerLocal > e : " + e, SOSLog.ERROR);
			mHasPublishPermission = true;
			mHasUserFriendsPermission = true;
			
			if (permissionsCallback != null)
			{
				permissionsCallback();
			}
		}
		
		public function get facebookId():String
		{
			return GameManager.instance.facebookId;
		}
		
		override public function get accessToken():String
		{
			return GameManager.instance.accessToken;
		}
		
		public function likePage():void
		{
			ExternalInterface.addCallback("onLikeDialogClose", null);
			showFbDialog("showLikeBox");
		}
		
		private function showFbDialog(extFuncName:String, extFuncParams:Object=null):void {
			var nativeStage:Stage = Starling.current.nativeStage;
			//выйти из полноэкр режима, если в нем
			if (nativeStage.displayState == StageDisplayState.FULL_SCREEN) {
				nativeStage.displayState = StageDisplayState.NORMAL;
				// let browser resize the content. (better approach - catching event after resize is done - heven't helped)
				setTimeout(callExtFunc, 200);
			} else {
				
				callExtFunc();
			}
			
			function callExtFunc():void 
			{
				if (ExternalInterface.available) {
					if (extFuncParams)
						ExternalInterface.call(extFuncName, extFuncParams);
					else
						ExternalInterface.call(extFuncName);
				}
			}
		}
		
		private function rerequestPermissions(perm:String, callback:Function = null):void
		{
			var params:Object = {scope: perm, auth_type: 'rerequest'};
			login(params, function():void {
				requestPermissionsIfNotGiven(callback);
			});
		}
		
	}
}