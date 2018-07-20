package com.alisacasino.bingo.platform.canvas
{
	import com.alisacasino.bingo.platform.IInterceptor;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.store.IStoreItem;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.DeviceOrientation;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.HttpCookies;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.netease.protobuf.UInt64;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import starling.display.Stage;
	import starling.rendering.Painter;
	
	import flash.display.BitmapData;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.system.Security;
	import flash.utils.ByteArray;
	
	import by.blooddy.crypto.Base64;
	import by.blooddy.crypto.image.JPEGEncoder;
	
	import starling.core.Starling;
	
	public class CanvasInterceptor implements IInterceptor
	{
		
		private var mBackgroundMusicEnabled:Boolean;
		private var mBackgroundMusicEnabledSet:Boolean;
		private var mSfxEnabled:Boolean;
		private var mSfxEnabledSet:Boolean;
		private var mVoiceoverEnabled:Boolean;
		private var mVoiceoverEnabledSet:Boolean;
		
		private var mCurrentRoomTypeName:String;
		private var mCurrentRoomTypeNameSet:Boolean;
		
		public function startAppsFlyer():void
		{
			// deliberately empty implementation
		}
		
		public function activatePushwoosh():void
		{
			// deliberately empty implementation
		}
		
		public function trackInstall():void
		{
			
		}
		
		public function trackOpen():void
		{
			// deliberately empty implementation
		}
		
		public function trackPurchase(item:IStoreItem):void
		{
			// deliberately empty implementation
		}
		
		public function addNativeEventListener(type:String, listener:Function):void
		{
			// deliberately empty implementation
		}
		
		public function loadPolicyFiles():void
		{
			//if (!Constants.isLocalBuild)
				Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			Security.loadPolicyFile('http://54.146.172.237:8080/crossdomain.xml');
			return;	
			Security.loadPolicyFile('https://fbcdn-profile-a.akamaihd.net/crossdomain.xml');
			Security.loadPolicyFile("https://graph.facebook.com/crossdomain.xml");
			Security.loadPolicyFile("https://lookaside.facebook.com/crossdomain.xml");
			Security.loadPolicyFile("https://profile.ak.fbcdn.net/crossdomain.xml");
			Security.loadPolicyFile('https://fbcdn-profile-a.akamaihd.net/crossdomain.xml');
			Security.loadPolicyFile('https://fbcdn-photos-a.akamaihd.net/crossdomain.xml');
			Security.loadPolicyFile('https://scontent-a.xx.fbcdn.net/crossdomain.xml');
			Security.loadPolicyFile('https://scontent-b.xx.fbcdn.net/crossdomain.xml');
			Security.loadPolicyFile('https://static.xx.fbcdn.net/crossdomain.xml');
			Security.loadPolicyFile('https://m.ak.fbcdn.net/crossdomain.xml');
			Security.loadPolicyFile('https://z-n.ak.fbcdn.net/crossdomain.xml');
			Security.loadPolicyFile('https://scontent.xx.fbcdn.net/crossdomain.xml');
		}
		
		public function get backgroundMusicEnabled():Boolean
		{
			if(mBackgroundMusicEnabledSet == false) {
				var fromCookie:String = HttpCookies.getCookie(SoundManager.BACKGROUND_MUSIC_ENABLED_KEY);
				if (fromCookie == null) {
					mBackgroundMusicEnabled = true;
				} else {
					mBackgroundMusicEnabled = fromCookie != "false";
				}
				mBackgroundMusicEnabledSet = true;
			}
			
			return mBackgroundMusicEnabled;
		}
		
		public function set backgroundMusicEnabled(value:Boolean):void
		{
			mBackgroundMusicEnabled = value;
			mBackgroundMusicEnabledSet = true;
			HttpCookies.setCookie(SoundManager.BACKGROUND_MUSIC_ENABLED_KEY, String(value));
		}
		
		public function get sfxEnabled():Boolean
		{
			if(mSfxEnabledSet == false) {
				var fromCookie:String = HttpCookies.getCookie(SoundManager.SFX_ENABLED_KEY);
				if (fromCookie == null) {
					mSfxEnabled = true;
				} else {
					mSfxEnabled = fromCookie != "false";
				}
				mSfxEnabledSet = true;
			}
			
			return mSfxEnabled;
		}
		
		public function set sfxEnabled(value:Boolean):void
		{
			mSfxEnabled = value;
			mSfxEnabledSet = true;
			HttpCookies.setCookie(SoundManager.SFX_ENABLED_KEY, String(value));
		}
		
		public function get voiceoverEnabled():Boolean
		{
			if(mVoiceoverEnabledSet == false) {
				var fromCookie:String = HttpCookies.getCookie(SoundManager.VOICEOVER_ENABLED_KEY);
				if (fromCookie == null) {
					mVoiceoverEnabled = true;
				} else {
					mVoiceoverEnabled = fromCookie != "false";
				}
				mVoiceoverEnabledSet = true;
			}
			
			return mVoiceoverEnabled;
		}
		
		public function set voiceoverEnabled(value:Boolean):void
		{
			mVoiceoverEnabled = value;
			mVoiceoverEnabledSet = true;
			HttpCookies.setCookie(SoundManager.VOICEOVER_ENABLED_KEY, String(value));
		}
		
		public function get playerId():UInt64
		{
			// deliberately empty implementation
			return UInt64.parseUInt64("9999");
		}
		
		public function set playerId(playerId:UInt64):void
		{
			// deliberately empty implementation
		}
		
		public function get pwdHash():String
		{
			// deliberately empty implementation
			return "5f4dcc3b5aa765d61d8327deb882cf99";
		}
		
		public function set pwdHash(pwdHash:String):void
		{
			// deliberately empty implementation
		}
		
		public function get currentRoomTypeName():String
		{
			if(mCurrentRoomTypeNameSet == false) {
				var fromCookie:String = HttpCookies.getCookie(GameManager.CURRENT_ROOM_TYPE_NAME_KEY);
				if (fromCookie != null) {
					mCurrentRoomTypeName = fromCookie;
				} else {
					mCurrentRoomTypeName = "farm";
				}
				mCurrentRoomTypeNameSet = true;
			}
			
			return mCurrentRoomTypeName;
		}
		
		public function set currentRoomTypeName(roomTypeName:String):void
		{
			if(roomTypeName) {
				mCurrentRoomTypeName = roomTypeName;
				mCurrentRoomTypeNameSet = true;
				HttpCookies.setCookie(GameManager.CURRENT_ROOM_TYPE_NAME_KEY, roomTypeName);
			}
		}
		
		public function get hasLiked():Boolean
		{
			// deliberately empty implementation
			return false;
		}
		
		public function set hasLiked(value:Boolean):void
		{
			// deliberately empty implementation
		}
		
		public function get hasRated():Boolean
		{
			// deliberately empty implementation
			return false;
		}
		
		public function set hasRated(value:Boolean):void
		{
			// deliberately empty implementation
		}
		
		public function setSystemIdleModeKeepAwake():void
		{
			// deliberately empty implementation
		}
		
		public function setSystemIdleModeNormal():void
		{
			// deliberately empty implementation
		}
		
		public function get deviceId():String
		{
			return PlatformServices.facebookManager.facebookId.toString();
		}
		
		public function exportScreenshot():String {
			return exportScreenshot_intrnl(false);
		}
		
		public function exportScreenshotHalfSized():String {
			return exportScreenshot_intrnl(true);
		}
		
		
		public function registerForPushNotifications():void 
		{
			
		}
		
		
		/* INTERFACE com.alisacasino.bingo.platform.IInterceptor */
		
		public function setDefaultSoundType():void 
		{
			
		}
		
		
		/* INTERFACE com.alisacasino.bingo.platform.IInterceptor */
		
		public function clearPlayerID():void 
		{
			
		}
		
		public function clearPasswordHash():void 
		{
			
		}
		
		public function initFullscreen(stage:flash.display.Stage):void
		{
			
		}
		
		
		/* INTERFACE com.alisacasino.bingo.platform.IInterceptor */
		
		public function getScreenWidth():Number 
		{
			if(Starling.current && Starling.current.nativeStage)
				return Starling.current.nativeStage.stageWidth;
			
			return Constants.STAGE_START_WIDTH;
		}
		
		public function getScreenHeight():Number 
		{
			if(Starling.current && Starling.current.nativeStage)
				return Starling.current.nativeStage.stageHeight;
				
			return Constants.STAGE_START_HEIGHT;
		}
		
		private function exportScreenshot_intrnl(isShrink:Boolean):String {
			var encodedPic:String;
			
			var bData:BitmapData;
			try {
				bData = prepareStarlingStageBinaryData();
				
				if (isShrink) {
					bData = scaleHalfDown(bData);
				}
				
				blur(bData);
				
				encodedPic = encodeJPEG(bData);
			} catch (err:Error) {
				encodedPic = "||||ERROR. " + err.name + "||\n" + err.message + "||\n" + err.getStackTrace();
			}
			
			if (bData)
			{
				bData.dispose();
			}
			
			return encodedPic;
		}
		
		private function prepareStarlingStageBinaryData():BitmapData
		{
			/*var starling:Starling = Starling.current;
			var stage:starling.display.Stage = starling.stage;
			
			var canvasWidth:int = stage.stageWidth;
			var canvasHeight:int  = stage.stageHeight;
			var projectionWidth:int = starling.stage.stageWidth;
			var projectionHeight:int  = starling.stage.stageHeight;
			
			var support:RenderSupport = new RenderSupport();
			
			var bData:BitmapData = new BitmapData(canvasWidth, canvasHeight, false, 0x0);
			
			support.renderTarget = null;
			support.setProjectionMatrix(0, 0, projectionWidth, projectionHeight);
			//support.setOrthographicProjection(0, 0, projectionWidth, projectionHeight);
			support.clear(0, 1);
			starling.stage.render(support, 1.0);
			support.finishQuadBatch();
			
			Starling.current.context.drawToBitmapData(bData);
			Starling.current.context.present(); // required on some platforms to avoid flickering
			
			return bData;*/
			
			var bounds:Rectangle = Starling.current.stage.getBounds(Starling.current.stage);
			var result:BitmapData = new BitmapData(bounds.width, bounds.height, true);
			var stage:starling.display.Stage = Starling.current.stage;
			var painter:Painter = Starling.current.painter;
		 
			painter.pushState();
			painter.state.renderTarget = null;
			painter.state.setProjectionMatrix(bounds.x, bounds.y, stage.stageWidth, stage.stageHeight, stage.stageWidth, stage.stageHeight, stage.cameraPosition);
			painter.clear();
			Starling.current.stage.render(painter);
			painter.finishMeshBatch();
			painter.context.drawToBitmapData(result);
			painter.context.present();
			painter.popState();
			return result;
		}
		
		/*public static function copyToBitmap(starling:Starling, displayObject:DisplayObject):BitmapData
		{
			var bounds:Rectangle = displayObject.getBounds(displayObject);
			var result:BitmapData = new BitmapData(bounds.width, bounds.height, true);
			var stage:Stage = starling.stage;
			var painter:Painter = starling.painter;
		 
			painter.pushState();
			painter.state.renderTarget = null;
			painter.state.setProjectionMatrix(bounds.x, bounds.y, stage.stageWidth, stage.stageHeight, stage.stageWidth, stage.stageHeight, stage.cameraPosition);
			painter.clear();
			displayObject.render(painter);
			painter.finishMeshBatch();
			painter.context.drawToBitmapData(result);
			painter.context.present();
			painter.popState();
		 
			return result;
		}*/
		
		private function scaleHalfDown(bData:BitmapData):BitmapData
		{
			var scale:Number = 0.5;
			var bDataScaled:BitmapData = new BitmapData(bData.width*scale, bData.height*scale, false, 0x0);
			var matrix:Matrix = new Matrix();
			matrix.scale(scale, scale);
			
			bDataScaled.draw(bData, matrix);
			bData.dispose();
			return bDataScaled;
		}
		
		private function blur(bData:BitmapData):void
		{
			var blurFilter:BlurFilter = new BlurFilter(3, 3, BitmapFilterQuality.HIGH);
			bData.applyFilter(bData, bData.rect, new Point(0, 0), blurFilter);
		}
		
		private function encodeJPEG(bData:BitmapData):String
		{
			var encodedPic:String;
			
			var jpgBytes:ByteArray = JPEGEncoder.encode(bData, 80);
			
			if (jpgBytes) {
				var screenshotBase64:String = Base64.encode(jpgBytes);
				if (screenshotBase64) {
					encodedPic = screenshotBase64;
				}
			}
			
			return encodedPic;
		}

        public function get pushToken():String {
            return "";
        }
		
		public function sendLocalNotification(message:String, timestamp:int, title:String, recurrenceType:int=0, notificationId:int=0, deepLinkPath:String=null, androidLargeIconResourceId:String=null):void {
		}	
		
		public function cancelLocalNotification(notificationId:int = 0):void {
		}
		
		public function getDeviceModel():String 
		{
			return Capabilities.playerType + " " + Capabilities.version;
		}
		
		public function getDeviceModelRaw():String 
		{
			return Capabilities.playerType + " " + Capabilities.version;
		}
		
		
		public function getOS():String 
		{
			return Capabilities.os;
		}
		
		
		public function setBackgroundMode():void 
		{
			
		}
		
		public function listenOrientation():void {			
		}
		
		/* INTERFACE com.alisacasino.bingo.platform.IInterceptor */
		
		public function listenForPushSource():void 
		{
			
		}
		
		public function get deviceOrientation():String {
			return DeviceOrientation.UNKNOWN;
		}
		
		public function get isIphone():Boolean 
		{
			return false;
		}
		
    }
}
