package com.alisacasino.bingo.platform.mobile.goViralProxyingClasses
{
	import com.milkmangames.nativeextensions.GVFacebookAppEvent;
	import com.milkmangames.nativeextensions.GVFacebookDispatcher;
	import com.milkmangames.nativeextensions.GVMailDispatcher;
	import com.milkmangames.nativeextensions.GVShareDispatcher;
	import flash.display.BitmapData;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public interface IGoViralImplementation extends IEventDispatcher
	{
		
		function authenticateWithFacebook(readPermissions:String = "public_profile"):void;
		
		function displaySocialComposerView(serviceType:String, message:String, image:flash.display.BitmapData = null, url:String = null):com.milkmangames.nativeextensions.GVShareDispatcher;
		
		function dispose():void;
		
		function facebookPostPhoto(message:String, image:flash.display.BitmapData, graphPath:String = "me/photos"):com.milkmangames.nativeextensions.GVFacebookDispatcher;
		
		function getDeclinedFacebookPermissions():Vector.<String>;
		
		function getFbAccessExpiry():Number;
		
		function getFbAccessToken():String;
		
		function initFacebook(appId:String, urlSchemeSuffix:String = ""):void;
		
		function isEmailAvailable():Boolean;
		
		function isFacebookAuthenticated():Boolean;
		
		function isFacebookMessageDialogAvailable():Boolean;
		
		function isFacebookPermissionGranted(permission:String):Boolean;
		
		function isFacebookSupported():Boolean;
		
		function isGenericShareAvailable():Boolean;
		
		function isSocialServiceAvailable(serviceType:String):Boolean;
		
		function isTweetSheetAvailable():Boolean;
		
		function isSupported():Boolean;
		
		function logFacebookAppEvent(appEvent:GVFacebookAppEvent):void;
		
		function logoutFacebook():void;
		
		function postFacebookAchievement(achievementURL:String):com.milkmangames.nativeextensions.GVFacebookDispatcher;
		
		function postFacebookHighScore(score:Number):com.milkmangames.nativeextensions.GVFacebookDispatcher;
		
		function presentFacebookPageOrProfile(pageID:String):void;
		
		function presentTwitterProfile(twitterID:String):void;
		
		function refreshFacebookSessionPermissions():void;
		
		function requestFacebookFriends(extraParams:Object = null):com.milkmangames.nativeextensions.GVFacebookDispatcher;
		
		function requestFacebookMobileAdID():com.milkmangames.nativeextensions.GVFacebookDispatcher;
		
		function requestMyFacebookProfile():com.milkmangames.nativeextensions.GVFacebookDispatcher;
		
		function requestNewFacebookPublishPermissions(permissions:String):void;
		
		function requestNewFacebookReadPermissions(permissions:String):void;
		
		function shareGenericMessage(subject:String, message:String, isHtml:Boolean, popoverX:Number = 1024, popoverY:Number = 1024):com.milkmangames.nativeextensions.GVShareDispatcher;
		
		function shareGenericMessageWithImage(subject:String, message:String, isHtml:Boolean, image:flash.display.BitmapData, popoverX:Number = 1024, popoverY:Number = 1024):com.milkmangames.nativeextensions.GVShareDispatcher;
		
		function showEmailComposer(subject:String, toWhom:String, body:String, isBodyHtml:Boolean):com.milkmangames.nativeextensions.GVMailDispatcher;
		
		function showEmailComposerWithBitmap(subject:String, toWhom:String, body:String, isBodyHtml:Boolean, bitmapData:flash.display.BitmapData, imageFileName:String = null):com.milkmangames.nativeextensions.GVMailDispatcher;
		
		function showEmailComposerWithByteArray(subject:String, toWhom:String, body:String, isBodyHtml:Boolean, byteArray:flash.utils.ByteArray, mimeType:String, fileName:String):com.milkmangames.nativeextensions.GVMailDispatcher;
		
		function showFacebookGraphDialog(actionType:String, objectType:String, title:String, description:String, url:String = null, image:flash.display.BitmapData = null, extraObjectParams:Object = null):com.milkmangames.nativeextensions.GVFacebookDispatcher;
		
		function showFacebookMessageDialog(name:String, caption:String, description:String, linkUrl:String = null, imageUrl:String = null, extraParams:Object = null):com.milkmangames.nativeextensions.GVFacebookDispatcher;
		
		function showFacebookShareDialog(name:String, description:String, linkUrl:String = null, imageUrl:String = null, extraParams:Object = null):com.milkmangames.nativeextensions.GVFacebookDispatcher;
		
		function showTweetSheet(message:String):com.milkmangames.nativeextensions.GVTwitterDispatcher;
		
		function showTweetSheetWithImage(message:String, image:flash.display.BitmapData):com.milkmangames.nativeextensions.GVTwitterDispatcher;
		
		function showFacebookGameRequestDialog(message:String, title:String=null, data:String=null, filters:String=null, to:String=null, actionType:String=null, objectID:String=null, suggestions:String=null, frictionless:Boolean=false):com.milkmangames.nativeextensions.GVFacebookDispatcher;
		
		function create():IGoViralImplementation;
		
		function getVersion():String;
	}

}