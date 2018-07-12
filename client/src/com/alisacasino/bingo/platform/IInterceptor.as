package com.alisacasino.bingo.platform
{
	import com.alisacasino.bingo.store.IStoreItem;
	import com.netease.protobuf.UInt64;
	import flash.display.Stage;
	
	public interface IInterceptor
	{
		function startAppsFlyer():void;
		function activatePushwoosh():void;
		function registerForPushNotifications():void;
		function trackInstall():void;
		function trackOpen():void;
		function trackPurchase(item:IStoreItem):void;
		function addNativeEventListener(type:String, listener:Function):void;
		function loadPolicyFiles():void;
		function get backgroundMusicEnabled():Boolean;
		function set backgroundMusicEnabled(value:Boolean):void;
		function get sfxEnabled():Boolean;
		function set sfxEnabled(value:Boolean):void;
		function get voiceoverEnabled():Boolean;
		function set voiceoverEnabled(value:Boolean):void;
		function get playerId():UInt64;
		function set playerId(playerId:UInt64):void;
		function get pwdHash():String;
		function set pwdHash(pwdHash:String):void;
		function get currentRoomTypeName():String;
		function set currentRoomTypeName(roomTypeName:String):void;
		function get hasLiked():Boolean;
		function set hasLiked(value:Boolean):void;
		function get hasRated():Boolean;
		function set hasRated(value:Boolean):void;
		function setSystemIdleModeKeepAwake():void;
		function setSystemIdleModeNormal():void;
		function get deviceId():String;
		function get pushToken():String;
		function exportScreenshot():String;
		function exportScreenshotHalfSized():String;
		function initFullscreen(stage:Stage):void;
		
		function setDefaultSoundType():void;
		
		function clearPlayerID():void;
		
		function clearPasswordHash():void;
		
		function getScreenWidth():Number;
		function getScreenHeight():Number;
		
		function sendLocalNotification(message:String, timestamp:int, title:String, recurrenceType:int = 0, notificationId:int = 0, deepLinkPath:String = null, androidLargeIconResourceId:String = null):void;
		function cancelLocalNotification(notificationId:int = 0):void;
		
		function getDeviceModel():String
		function getDeviceModelRaw():String
		function getOS():String
		
		function setBackgroundMode():void;
		
		function listenOrientation():void;
		
		function listenForPushSource():void;
		function get deviceOrientation():String;
		
		function get isIphone():Boolean;
	}
}
