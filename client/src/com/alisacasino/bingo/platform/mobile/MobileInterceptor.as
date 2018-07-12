package com.alisacasino.bingo.platform.mobile
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.notification.PushData;
	import com.alisacasino.bingo.platform.IInterceptor;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.SignInMessage.Platform;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.store.IStoreItem;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.DeviceOrientation;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.IPhoneModelDecoder;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.TimeService;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNANotificationServicesEvent;
	import com.digitalstrawberry.ane.deviceutils.DeviceUtils;
	import com.freshplanet.ane.AirPushNotification.PushNotification;
	import com.freshplanet.ane.AirPushNotification.PushNotificationEvent;
	import flash.display.StageOrientation;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	import flash.system.ApplicationDomain;
	import starling.core.Starling;

	import com.mesmotronic.ane.AndroidFullScreen;
	import com.netease.protobuf.UInt64;
	import flash.display.Stage;
	import flash.media.AudioPlaybackMode;
	import flash.media.SoundMixer;
	import flash.system.Capabilities;

	import flash.data.EncryptedLocalStore;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.utils.ByteArray;

public class MobileInterceptor implements IInterceptor
	{
		private var mAppsFlyerInterface:AppsFlyerInterface = new AppsFlyerInterface();
		private var mAppsFlyerTrackingData:String;
		private var mPushToken:String = "";
		private var mDeviceId:String = "";

		public function startAppsFlyer():void
		{
			if (PlatformServices.isIOS)
				mAppsFlyerInterface.setDeveloperKey(Constants.AF_DEV_KEY, Constants.APPLE_ID);
			else
				mAppsFlyerInterface.setDeveloperKey(Constants.AF_DEV_KEY, "");
			
			
			mAppsFlyerInterface.addEventListener(AppsFlyerEvent.APP_OPEN_ATTRIBUTION, mAppsFlyerInterface_appOpenAttributionHandler);
			mAppsFlyerInterface.addEventListener(AppsFlyerEvent.ATTRIBUTION_FAILURE, afeHandler);
			mAppsFlyerInterface.addEventListener(AppsFlyerEvent.INSTALL_CONVERSATION_DATA_LOADED, mAppsFlyerInterface_installConversationDataLoadedHandler);
			mAppsFlyerInterface.addEventListener(AppsFlyerEvent.INSTALL_CONVERSATION_FAILED, afeHandler);
			
			mAppsFlyerInterface.registerConversionListener();
		}
		
		private function mAppsFlyerInterface_appOpenAttributionHandler(e:AppsFlyerEvent):void 
		{
			gameManager.trackingDataAppOpen = e.data;
			
		}
		
		private function mAppsFlyerInterface_installConversationDataLoadedHandler(e:AppsFlyerEvent):void 
		{
			gameManager.analyticsManager.sendInstallConversationData(e.data);
			gameManager.trackingData = e.data;
		}
		
		private function afeHandler(e:AppsFlyerEvent):void 
		{
			sosTrace( "MobileInterceptor.afeHandler > e : " + e.type + " : " + e.data, SOSLog.INFO);
		}

		private var mPushwooshActivated:Boolean;
		
		public function getOrientation():String
		{
			if (PlatformServices.isIOS)
				return PushNotification.instance.deviceOrientation;
			
			return "unknown";
		}
		
		public function listenForPushSource():void 
		{
			PushNotification.instance.addEventListener(PushNotificationEvent.APP_STARTING_FROM_NOTIFICATION_EVENT, instance_appStartingFromNotificationEventHandler);
		}

		public function activatePushwoosh():void
		{
			if (mPushwooshActivated)
				return;
			if (PlatformServices.isAndroid) 
			{
				if (PlatformServices.platform == Platform.AMAZON_APP_STORE)
				{
					PushNotification.instance.registerForPushNotification();
				}
				else
				{
					PushNotification.instance.registerForPushNotification(Constants.ANDROID_PUSH_SENDER_ID);
				}
			} else if(PlatformServices.isIOS) {
                PushNotification.instance.registerForPushNotification();
			} else {
				return;
			}

            PushNotification.instance.addEventListener(PushNotificationEvent.PERMISSION_GIVEN_WITH_TOKEN_EVENT, onPushNotificationToken);
            PushNotification.instance.addEventListener(PushNotificationEvent.NOTIFICATION_RECEIVED_WHEN_IN_FOREGROUND_EVENT, onPushReceived);
            PushNotification.instance.addEventListener(PushNotificationEvent.APP_BROUGHT_TO_FOREGROUND_FROM_NOTIFICATION_EVENT, instance_appBroughtToForegroundFromNotificationEventHandler);
			PushNotification.instance.addEventListener(PushNotificationEvent.APP_STARTING_FROM_NOTIFICATION_EVENT, instance_appStartingFromNotificationEventHandler);
			PushNotification.instance.addEventListener(PushNotificationEvent.APP_STARTED_IN_BACKGROUND_FROM_NOTIFICATION_EVENT, instance_appStartedInBackgroundFromNotificationEventHandler);
			PushNotification.instance.addEventListener(PushNotificationEvent.COMING_FROM_NOTIFICATION_EVENT, instance_comingFromNotificationEventHandler);
			PushNotification.instance.addListenerForStarterNotifications(starterEventListener);
			mPushwooshActivated = true;
		}
		
		private function instance_comingFromNotificationEventHandler(e:PushNotificationEvent):void 
		{
		}
		
		private function starterEventListener(e:PushNotificationEvent):void 
		{
		}
		
		private function instance_appStartedInBackgroundFromNotificationEventHandler(e:PushNotificationEvent):void 
		{
		}
		
		private function instance_appBroughtToForegroundFromNotificationEventHandler(e:PushNotificationEvent):void 
		{
		}
		
		private function instance_appStartingFromNotificationEventHandler(e:PushNotificationEvent):void 
		{
		}
		
		private function onPushReceived(e:PushNotificationEvent):void
		{
			sosTrace( "MobileInterceptor.onPushReceived > e : ", e.type, e.parameters, SOSLog.INFO);
		}
		
		private function onError(e:PushNotificationEvent):void
		{
			sosTrace( "MobileInterceptor.onError > e : " + e.errorCode + " : " + e.errorMessage, SOSLog.INFO);
		}
		
		private function onPushNotificationToken(e:PushNotificationEvent):void
		{
            mPushToken = e.token;
			
			if (Player.current)
			{
				gameManager.analyticsManager.sendDeltaDNAEvent(new DDNANotificationServicesEvent(e.token));
			}
			
			PushNotification.instance.setIsAppInForeground(true);
			rescheduleRetentionNotification();
        }
		
		private function rescheduleRetentionNotification():void {
			// Cancel old notifications
			PlatformServices.interceptor.cancelLocalNotification(PushData.RETENTION_PUSH_ID + 1);
			PlatformServices.interceptor.cancelLocalNotification(PushData.RETENTION_PUSH_ID + 2);
			PlatformServices.interceptor.cancelLocalNotification(PushData.RETENTION_PUSH_ID + 3);
			PlatformServices.interceptor.cancelLocalNotification(PushData.RETENTION_PUSH_ID + 4);
			PlatformServices.interceptor.cancelLocalNotification(PushData.RETENTION_PUSH_ID + 5);
			
			// schedule new
			// three days retention
            PlatformServices.interceptor.sendLocalNotification(
                    GameManager.instance.pushData.getRetentionThreeDaysPush(),
                    TimeService.serverTime + (3 * 24 * 60 * 60),
                    PushData.PUSH_TITLE,
                    0,
                    PushData.RETENTION_PUSH_ID + 1
            );
			
            PlatformServices.interceptor.sendLocalNotification(
                    GameManager.instance.pushData.getRetentionWeekPush(),
                    TimeService.serverTime + (7 * 24 * 60 * 60),
                    PushData.PUSH_TITLE,
                    0,
                    PushData.RETENTION_PUSH_ID + 2
            );
			
			PlatformServices.interceptor.sendLocalNotification(
                    GameManager.instance.pushData.getRetentionTwoWeekPush(),
                    TimeService.serverTime + (14 * 24 * 60 * 60),
                    PushData.PUSH_TITLE,
                    0,
                    PushData.RETENTION_PUSH_ID + 3
            );
			
			PlatformServices.interceptor.sendLocalNotification(
                    GameManager.instance.pushData.getRetentionOneDayPush(),
                    TimeService.serverTime + (1 * 24 * 60 * 60),
                    PushData.PUSH_TITLE,
                    0,
                    PushData.RETENTION_PUSH_ID + 4
            );
			
			PlatformServices.interceptor.sendLocalNotification(
                    GameManager.instance.pushData.getRetentionOneMonthPush(),
                    TimeService.serverTime + (30 * 24 * 60 * 60),
                    PushData.PUSH_TITLE,
                    0,
                    PushData.RETENTION_PUSH_ID + 5
            );
		}
		
		private function onDeviceIdReceved(deviceId:String):void {
            mDeviceId = deviceId;
		}
		
		public function trackInstall():void
		{
		}
		
		public function trackOpen():void
		{
			mAppsFlyerInterface.trackAppLaunch();
			//mMobileAppTracker.trackAction("open", 0, "USD", String(Player.current.playerId));
		}
		
		public function trackPurchase(item:IStoreItem):void
		{
			//mMobileAppTracker.trackAction("purchase", revenue, "USD", String(Player.current.playerId));
		}
		
		public function addNativeEventListener(type:String, listener:Function):void
		{
			NativeApplication.nativeApplication.addEventListener(type, listener);
		}
		
		public function loadPolicyFiles():void
		{
			// deliberately empty implementation
		}
		
		public function get backgroundMusicEnabled():Boolean
		{
			var ba:ByteArray = EncryptedLocalStore.getItem(SoundManager.BACKGROUND_MUSIC_ENABLED_KEY);
			if (ba != null)
				return ba.readBoolean();
			else
				return true;
		}
		
		public function set backgroundMusicEnabled(value:Boolean):void
		{
			var ba:ByteArray = new ByteArray();
			ba.writeBoolean(value);
			EncryptedLocalStore.setItem(SoundManager.BACKGROUND_MUSIC_ENABLED_KEY, ba);
		}
		
		public function get sfxEnabled():Boolean
		{
			var ba:ByteArray = EncryptedLocalStore.getItem(SoundManager.SFX_ENABLED_KEY);
			if (ba != null)
				return ba.readBoolean();
			else
				return true;
		}
		
		public function set sfxEnabled(value:Boolean):void
		{
			var ba:ByteArray = new ByteArray();
			ba.writeBoolean(value);
			EncryptedLocalStore.setItem(SoundManager.SFX_ENABLED_KEY, ba);
		}
		
		public function get voiceoverEnabled():Boolean
		{
			var ba:ByteArray = EncryptedLocalStore.getItem(SoundManager.VOICEOVER_ENABLED_KEY);
			if (ba != null)
				return ba.readBoolean();
			else
				return true;
		}
		
		public function set voiceoverEnabled(value:Boolean):void
		{
			var ba:ByteArray = new ByteArray();
			ba.writeBoolean(value);
			EncryptedLocalStore.setItem(SoundManager.VOICEOVER_ENABLED_KEY, ba);
		}
		
		public function get playerId():UInt64
		{
			var ba:ByteArray = EncryptedLocalStore.getItem(GameManager.PLAYER_ID_KEY);
			if (ba != null) {
				return UInt64.parseUInt64(ba.readUTFBytes(ba.length));
			} else
				return null;
		}
		
		public function set playerId(playerId:UInt64):void
		{
			if (playerId != null) {
				var ba:ByteArray = new ByteArray();
				ba.writeUTFBytes(playerId.toString());
				EncryptedLocalStore.setItem(GameManager.PLAYER_ID_KEY, ba);
			} else {
				EncryptedLocalStore.removeItem(GameManager.PLAYER_ID_KEY);
			}
		}
		
		public function get pwdHash():String
		{
			var ba:ByteArray = EncryptedLocalStore.getItem(GameManager.PWD_HASH_KEY);
			if (ba != null) {
				return ba.readUTFBytes(ba.length);
			} else
				return null;
		}
		
		public function set pwdHash(pwdHash:String):void
		{
			if (pwdHash != null) {
				var ba:ByteArray = new ByteArray();
				ba.writeUTFBytes(pwdHash);
				EncryptedLocalStore.setItem(GameManager.PWD_HASH_KEY, ba);
			} else {
				EncryptedLocalStore.removeItem(GameManager.PWD_HASH_KEY);
			}
		}
		
		public function get currentRoomTypeName():String
		{
			var ba:ByteArray = EncryptedLocalStore.getItem(GameManager.CURRENT_ROOM_TYPE_NAME_KEY);
			if (ba != null) {
				return ba.readUTFBytes(ba.length);
			} else
				return null;
		}
		
		public function set currentRoomTypeName(roomTypeName:String):void
		{
			if (roomTypeName != null) {
				var ba:ByteArray = new ByteArray();
				ba.writeUTFBytes(roomTypeName);
				EncryptedLocalStore.setItem(GameManager.CURRENT_ROOM_TYPE_NAME_KEY, ba);
			} else {
				EncryptedLocalStore.removeItem(GameManager.CURRENT_ROOM_TYPE_NAME_KEY);
			}
		}
		
		public function get hasLiked():Boolean
		{
			var ba:ByteArray = EncryptedLocalStore.getItem(GameManager.HAS_LIKED);
			if (ba != null) {
				return ba.readUTFBytes(ba.length);
			} else
				return false;
		}
		
		public function set hasLiked(value:Boolean):void
		{
			if (value) {
				var ba:ByteArray = new ByteArray();
				ba.writeUTFBytes(value.toString());
				EncryptedLocalStore.setItem(GameManager.HAS_LIKED, ba);
			} else {
				EncryptedLocalStore.removeItem(GameManager.HAS_LIKED);
			}
		}
		
		public function get hasRated():Boolean
		{
			var ba:ByteArray = EncryptedLocalStore.getItem(GameManager.HAS_RATED);
			if (ba != null) {
				return ba.readUTFBytes(ba.length);
			} else
				return false;
		}
		
		public function set hasRated(value:Boolean):void
		{
			if (value) {
				var ba:ByteArray = new ByteArray();
				ba.writeUTFBytes(value.toString());
				EncryptedLocalStore.setItem(GameManager.HAS_RATED, ba);
			} else {
				EncryptedLocalStore.removeItem(GameManager.HAS_RATED);
			}
		}
		
		public function setSystemIdleModeKeepAwake():void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
		}
		
		public function setSystemIdleModeNormal():void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
		}
		
		public function get deviceId():String
		{
            return mDeviceId;
		}
		
		public function exportScreenshot():String {
			// deliberately empty implementation
			return "";
		}
		public function exportScreenshotHalfSized():String {
			// deliberately empty implementation
			return "";
		}
		
		public function setDefaultSoundType():void
		{
			if (PlatformServices.isIOS)
			{
				SoundMixer.audioPlaybackMode = AudioPlaybackMode.AMBIENT;
			}
		}
		
		public function clearPlayerID():void
		{
			EncryptedLocalStore.removeItem(GameManager.PLAYER_ID_KEY);
		}
		
		public function clearPasswordHash():void
		{
			EncryptedLocalStore.removeItem(GameManager.PWD_HASH_KEY);
		}
		
		public function initFullscreen(stage:Stage):void
		{
			if (PlatformServices.isAndroid)
			{
				AndroidFullScreen.stage = stage;
				AndroidFullScreen.fullScreen();
			}
		}
		
		public function getScreenWidth():Number
		{
			if (PlatformServices.isAndroid)
			{
				return AndroidFullScreen.fullScreenWidth;
			}
			return Capabilities.screenResolutionX;
		}
		
		public function getScreenHeight():Number
		{
			if (PlatformServices.isAndroid)
			{
				return AndroidFullScreen.fullScreenHeight;
			}
			return Capabilities.screenResolutionY;
		}
		
        public function get pushToken():String {
            return mPushToken;
        }
		
		public function sendLocalNotification(message:String, timestamp:int, title:String, recurrenceType:int=0, notificationId:int=0, deepLinkPath:String=null, androidLargeIconResourceId:String=null):void
		{
			if (!PushNotification.isSupported)
				return;
			
			PushNotification.instance.sendLocalNotification(message, timestamp, title, recurrenceType, notificationId, deepLinkPath, androidLargeIconResourceId);
		}
		
		public function cancelLocalNotification(notificationId:int = 0):void {
			if (!PushNotification.isSupported)
				return;
			
			PushNotification.instance.cancelLocalNotification(notificationId);
		}
		
		public function getDeviceModel():String 
		{
			if (DeviceUtils.isSupported)
			{
				var model:String = DeviceUtils.model;
				if (PlatformServices.isIOS)
				{
					model = IPhoneModelDecoder.decode(model);
				}
				return model;
			}
			else
			{
				return "-";
			}
		}
		
		public function getDeviceModelRaw():String
		{
			if (DeviceUtils.isSupported)
			{
				return(DeviceUtils.model);
			}
			return "-";
		}
		
		public function getOS():String
		{
			if (DeviceUtils.isSupported)
			{
				return DeviceUtils.systemName + " " + DeviceUtils.systemVersion;
			}
			else
			{
				return Capabilities.os;
			}
		}
		
		public function setBackgroundMode():void 
		{
			PushNotification.instance.setIsAppInForeground(false);
		}
		
		
		public function registerForPushNotifications():void 
		{
			
		}
		
		public function get isIphone():Boolean 
		{
			return (DeviceUtils.model && DeviceUtils.model.indexOf("iPhone") != -1)
		}
		
		public function listenOrientation():void {
			//sosTrace( "DeviceModel: ", getDeviceModel(), ' supportsOrientationChange:', Stage.supportsOrientationChange);
			sosTrace( "MobileInterceptor.listenOrientation", Stage.supportsOrientationChange, SOSLog.DEBUG);
			//if(Stage.supportsOrientationChange)
			Starling.current.nativeStage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, handler_orientationChanged);
			
			var stub:String = deviceOrientation;
		}
		
		private var lastNonDefaultDeviceOrientation:String = "rotatedLeft";
		
		public function get deviceOrientation():String 
		{
			if (PlatformServices.isIOS)
			{
				if (PushNotification.isSupported)
					sosTrace( "PushNotification.instance.deviceOrientation : " + PushNotification.instance.deviceOrientation, SOSLog.DEBUG);
			}
			if (Stage.supportsOrientationChange) 
			{
				sosTrace( "MobileInterceptort.get deviceOrientation ", (Starling.current && Starling.current.nativeStage) ? (DeviceOrientation.getByString(Starling.current.nativeStage.deviceOrientation) + " " + Starling.current.nativeStage.deviceOrientation) : 'UNKNOWN', SOSLog.DEBUG);
				
				if (Starling.current && Starling.current.nativeStage)
				{
					var newDeviceOrientation:String = DeviceOrientation.getByString(Starling.current.nativeStage.deviceOrientation);
					
					if(newDeviceOrientation == DeviceOrientation.ROTATED_LEFT || newDeviceOrientation == DeviceOrientation.ROTATED_RIGHT)
						lastNonDefaultDeviceOrientation = newDeviceOrientation;
					
					return lastNonDefaultDeviceOrientation;
				}
				else
				{
					return lastNonDefaultDeviceOrientation;
				}
				
				//return (Starling.current && Starling.current.nativeStage) ? DeviceOrientation.getByString(Starling.current.nativeStage.deviceOrientation) : DeviceOrientation.UNKNOWN;
			}
			else {
				sosTrace( "MobileInterceptort.get deviceOrientation Stage.supportsOrientationChange FALSE!", SOSLog.DEBUG);
			}
			
			return lastNonDefaultDeviceOrientation;
		}
		
		private function handler_orientationChanged(event:StageOrientationEvent):void 
		{
			var stub:String = deviceOrientation;
			
			if (Game.current && !gameManager.deactivated)
				Game.current.dispatchEventWith(Game.EVENT_ORIENTATION_CHANGED);
			
			sosTrace( "MobileInterceptort.orientationChanged", (Starling.current && Starling.current.nativeStage) ? Starling.current.nativeStage.deviceOrientation : 'no stage', Game.current, SOSLog.DEBUG);
		}
		
	}
}
