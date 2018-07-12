package com.alisacasino.bingo.platform.mobile.goViralProxyingClasses 
{
	import com.milkmangames.nativeextensions.GVFacebookAppEvent;
	import flash.events.Event;
	import com.milkmangames.nativeextensions.GVTwitterDispatcher;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import com.milkmangames.nativeextensions.GVMailDispatcher;
	import com.milkmangames.nativeextensions.GVFacebookDispatcher;
	import flash.display.BitmapData;
	import com.milkmangames.nativeextensions.GVShareDispatcher;
	import com.milkmangames.nativeextensions.GoViral;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class GoViralSWCMirror extends EventDispatcher implements IGoViralImplementation
	{
		private function get goViral():GoViral
		{
			return GoViral.goViral;
		}
		
		public function GoViralSWCMirror() 
		{
			
		}
		
		public function create():IGoViralImplementation
		{
			GoViral.create();
			
			new GoViralRedispatcher(GoViral.goViral, this);
			
			return this;
		}
		
		/* DELEGATE com.milkmangames.nativeextensions.GoViral */
		
		public function authenticateWithFacebook(readPermissions:String = "public_profile"):void 
		{
			goViral.authenticateWithFacebook(readPermissions);
		}
		
		public function displaySocialComposerView(serviceType:String, message:String, image:flash.display.BitmapData = null, url:String = null):com.milkmangames.nativeextensions.GVShareDispatcher 
		{
			return goViral.displaySocialComposerView(serviceType, message, image, url);
		}
		
		public function dispose():void 
		{
			goViral.dispose();
		}
		
		public function facebookGraphRequest(graphPath:String, httpMethod:String = "GET", params:Object = null, publishPermissions:String = null):com.milkmangames.nativeextensions.GVFacebookDispatcher 
		{
			return goViral.facebookGraphRequest(graphPath, httpMethod, params, publishPermissions);
		}
		
		public function facebookPostPhoto(message:String, image:flash.display.BitmapData, graphPath:String = "me/photos"):com.milkmangames.nativeextensions.GVFacebookDispatcher 
		{
			return goViral.facebookPostPhoto(message, image, graphPath);
		}
		
		public function getDeclinedFacebookPermissions():Vector.<String> 
		{
			return goViral.getDeclinedFacebookPermissions();
		}
		
		public function getFbAccessExpiry():Number 
		{
			return goViral.getFbAccessExpiry();
		}
		
		public function getFbAccessToken():String 
		{
			return goViral.getFbAccessToken();
		}
		
		public function initFacebook(appId:String, urlSchemeSuffix:String = ""):void 
		{
			goViral.initFacebook(appId, urlSchemeSuffix);
		}
		
		public function isEmailAvailable():Boolean 
		{
			return goViral.isEmailAvailable();
		}
		
		public function isFacebookAuthenticated():Boolean 
		{
			return goViral.isFacebookAuthenticated();
		}
		
		public function isFacebookMessageDialogAvailable():Boolean 
		{
			return goViral.isFacebookMessageDialogAvailable();
		}
		
		public function isFacebookPermissionGranted(permission:String):Boolean 
		{
			return goViral.isFacebookPermissionGranted(permission);
		}
		
		public function isFacebookSupported():Boolean 
		{
			return goViral.isFacebookSupported();
		}
		
		public function isGenericShareAvailable():Boolean 
		{
			return goViral.isGenericShareAvailable();
		}
		
		public function isSocialServiceAvailable(serviceType:String):Boolean 
		{
			return goViral.isSocialServiceAvailable(serviceType);
		}
		
		public function isTweetSheetAvailable():Boolean 
		{
			return goViral.isTweetSheetAvailable();
		}
		
		public function logFacebookAppEvent(appEvent:GVFacebookAppEvent):void 
		{
			goViral.logFacebookAppEvent(appEvent);
		}
		
		public function logoutFacebook():void 
		{
			goViral.logoutFacebook();
		}
		
		public function postFacebookAchievement(achievementURL:String):com.milkmangames.nativeextensions.GVFacebookDispatcher 
		{
			return goViral.postFacebookAchievement(achievementURL);
		}
		
		public function postFacebookHighScore(score:Number):com.milkmangames.nativeextensions.GVFacebookDispatcher 
		{
			return goViral.postFacebookHighScore(score);
		}
		
		public function presentFacebookPageOrProfile(pageID:String):void 
		{
			goViral.presentFacebookPageOrProfile(pageID);
		}
		
		public function presentTwitterProfile(twitterID:String):void 
		{
			goViral.presentTwitterProfile(twitterID);
		}
		
		public function refreshFacebookSessionPermissions():void 
		{
			goViral.refreshFacebookSessionPermissions();
		}
		
		public function requestFacebookFriends(extraParams:Object = null):com.milkmangames.nativeextensions.GVFacebookDispatcher 
		{
			return goViral.requestFacebookFriends(extraParams);
		}
		
		public function requestFacebookMobileAdID():com.milkmangames.nativeextensions.GVFacebookDispatcher 
		{
			return goViral.requestFacebookMobileAdID();
		}
		
		public function requestMyFacebookProfile():com.milkmangames.nativeextensions.GVFacebookDispatcher 
		{
			return goViral.requestMyFacebookProfile();
		}
		
		public function requestNewFacebookPublishPermissions(permissions:String):void 
		{
			goViral.requestNewFacebookPublishPermissions(permissions);
		}
		
		public function requestNewFacebookReadPermissions(permissions:String):void 
		{
			goViral.requestNewFacebookReadPermissions(permissions);
		}
		
		public function shareGenericMessage(subject:String, message:String, isHtml:Boolean, popoverX:Number = 1024, popoverY:Number = 1024):com.milkmangames.nativeextensions.GVShareDispatcher 
		{
			return goViral.shareGenericMessage(subject, message, isHtml, popoverX, popoverY);
		}
		
		public function shareGenericMessageWithImage(subject:String, message:String, isHtml:Boolean, image:flash.display.BitmapData, popoverX:Number = 1024, popoverY:Number = 1024):com.milkmangames.nativeextensions.GVShareDispatcher 
		{
			return goViral.shareGenericMessageWithImage(subject, message, isHtml, image, popoverX, popoverY);
		}
		
		public function showEmailComposer(subject:String, toWhom:String, body:String, isBodyHtml:Boolean):com.milkmangames.nativeextensions.GVMailDispatcher 
		{
			return goViral.showEmailComposer(subject, toWhom, body, isBodyHtml);
		}
		
		public function showEmailComposerWithBitmap(subject:String, toWhom:String, body:String, isBodyHtml:Boolean, bitmapData:flash.display.BitmapData, imageFileName:String = null):com.milkmangames.nativeextensions.GVMailDispatcher 
		{
			return goViral.showEmailComposerWithBitmap(subject, toWhom, body, isBodyHtml, bitmapData, imageFileName);
		}
		
		public function showEmailComposerWithByteArray(subject:String, toWhom:String, body:String, isBodyHtml:Boolean, byteArray:flash.utils.ByteArray, mimeType:String, fileName:String):com.milkmangames.nativeextensions.GVMailDispatcher 
		{
			return goViral.showEmailComposerWithByteArray(subject, toWhom, body, isBodyHtml, byteArray, mimeType, fileName);
		}
		
		public function showFacebookGraphDialog(actionType:String, objectType:String, title:String, description:String, url:String = null, image:flash.display.BitmapData = null, extraObjectParams:Object = null):com.milkmangames.nativeextensions.GVFacebookDispatcher 
		{
			return goViral.showFacebookGraphDialog(actionType, objectType, title, description, url, image, extraObjectParams);
		}
		
		public function showFacebookMessageDialog(name:String, caption:String, description:String, linkUrl:String = null, imageUrl:String = null, extraParams:Object = null):com.milkmangames.nativeextensions.GVFacebookDispatcher 
		{
			return goViral.showFacebookMessageDialog(name, caption, description, linkUrl, imageUrl, extraParams);
		}
		
		public function showFacebookShareDialog(name:String, description:String, linkUrl:String = null, imageUrl:String = null, extraParams:Object = null):com.milkmangames.nativeextensions.GVFacebookDispatcher 
		{
			return goViral.showFacebookShareDialog(name, description, linkUrl, imageUrl, extraParams);
		}
		
		public function showTweetSheet(message:String):com.milkmangames.nativeextensions.GVTwitterDispatcher 
		{
			return goViral.showTweetSheet(message);
		}
		
		public function showTweetSheetWithImage(message:String, image:flash.display.BitmapData):com.milkmangames.nativeextensions.GVTwitterDispatcher 
		{
			return goViral.showTweetSheetWithImage(message, image);
		}
		
		public function isSupported():Boolean 
		{
			return GoViral.isSupported();
		}
		
		public function getVersion():String 
		{
			return GoViral.VERSION;
		}
		
		public function showFacebookGameRequestDialog(message:String, title:String = null, data:String = null, filters:String = null, to:String = null, actionType:String = null, objectID:String = null, suggestions:String = null, frictionless:Boolean = false):com.milkmangames.nativeextensions.GVFacebookDispatcher 
		{
			return goViral.showFacebookGameRequestDialog(message, title, data, filters, to, actionType, objectID, suggestions, frictionless);
		}
		
	}

}