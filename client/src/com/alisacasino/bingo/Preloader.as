package com.alisacasino.bingo
{
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.utils.sharedObjects.SharedObjectManager;
	import flash.display.Bitmap;
	import flash.display.CapsStyle;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.utils.clearInterval;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	//[SWF(width = '1136', height = '640', frameRate = '60', backgroundColor = '#FFFFFF')] //PHONE_MODE
	//[SWF(width = '1024', height = '768', frameRate = '60', backgroundColor = '#FFFFFF')] //TABLET_MODE
	[SWF(width = '1280', height = '720', frameRate = '60', backgroundColor = '#FFFFFF')] //PHONE_MODE
	//[SWF(width='1280', height='960', frameRate='60', backgroundColor='#FFFFFF')] //CANVAS_MODE
	//[SWF(width='960', height='720', frameRate='60', backgroundColor='#FFFFFF')] // IPAD 2
	//[SWF(width='960', height='640', frameRate='60', backgroundColor='#FFFFFF')] // iPhone 4S
	//[SWF(width='1334', height='750', frameRate='60', backgroundColor='#FFFFFF')] // iPhone 6
	//[SWF(width = '2436', height = '1125', frameRate = '60', backgroundColor = '#FFFFFF')] // iPhone X
	
	public class Preloader extends MovieClip
	{
		[Embed(source="loading_bg.png")] 
		private static var preloadBitmapClass:Class;
		
		public var backgroundBitmap:Bitmap;
		public var backgroundContainer:Sprite;
		
		private var gameAdded:Boolean;
		
		private var isFacebook:Boolean;
		
		public static var _instance:Preloader;
		
		public function Preloader()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			_instance = this;
		}
		
		private function addedToStageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			isFacebook = !((Capabilities.version.substr(0, 3) == "AND") || (Capabilities.version.substr(0, 3) == "IOS") || (Capabilities.playerType == "Desktop") || (Capabilities.playerType == "StandAlone"));
				
			createBackground();
			resizeBackground();
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			stage.addEventListener(Event.RESIZE, stage_resizeHandler);
		}
		
		private function stage_resizeHandler(e:Event):void 
		{
			resizeBackground();
		}
		
		private function resizeBackground():void 
		{
			if (!backgroundBitmap)
				return;
			
			var valueWidth:Number;
			var valueHeight:Number;
			
			if (stage.stageWidth > stage.stageHeight) 
			{
				valueWidth = stage.stageWidth;
				valueHeight = stage.stageHeight;
			} else {
				valueWidth = stage.stageHeight;
				valueHeight = stage.stageWidth;
			}
			
			
			
			
			var scale:Number = Math.min(valueWidth / backgroundBitmap.bitmapData.width, valueHeight / backgroundBitmap.bitmapData.height);
			backgroundBitmap.scaleX = backgroundBitmap.scaleY = scale;
			
			backgroundBitmap.x = (valueWidth - backgroundBitmap.width) / 2;
			backgroundBitmap.y = (valueHeight - backgroundBitmap.height) / 2 ;
			
			var graphics:Graphics = backgroundContainer.graphics;
			
			graphics.clear();
			graphics.beginFill(0x000000);
			if (backgroundBitmap.x > 0)
			{
				graphics.drawRect(0, 0, backgroundBitmap.x, valueHeight);
				graphics.drawRect(backgroundBitmap.x + backgroundBitmap.width, 0, valueWidth - backgroundBitmap.x - backgroundBitmap.width , valueHeight);
			}
			else if (backgroundBitmap.y > 0)
			{
				graphics.drawRect(0, 0, valueWidth, backgroundBitmap.y);
				graphics.drawRect(0, backgroundBitmap.y + backgroundBitmap.height, valueWidth, valueHeight- backgroundBitmap.y - backgroundBitmap.height);
			}
			
			graphics.endFill();
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			createBackground();
			
			if (framesLoaded == totalFrames/* && getTimer() > 4000*/)
			{
				var clazz:Class = getDefinitionByName("com.alisacasino.bingo.Main") as Class;
				if (clazz != null)
				{
					stop();
					removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
					addChild(new clazz(this));
					gameAdded = true;
				}
				
				resizeBackground();
				//debugCreateCleanGarbageCollectorButton();
			}
		}
		
		private function createBackground():void 
		{
			if (!backgroundContainer)
			{
				backgroundContainer = new Sprite();
				addChild(backgroundContainer);
			}
			
			if (!backgroundBitmap) {
				backgroundBitmap = new preloadBitmapClass();
				backgroundBitmap.smoothing = true;
				//backgroundBitmap.alpha = 0.3;
				backgroundBitmap.visible = !isFacebook;
				backgroundContainer.addChild(backgroundBitmap);
			}
			
			if (backgroundBitmap.visible)
				return;
			
			// Магия фейсбука. флешку не сразу выравнивает он.
			if(stage.stageWidth == 1280 || stage.stageHeight == 720 || stage.stageHeight == 800)
				backgroundBitmap.visible = false;
			else
				backgroundBitmap.visible = true;
			
			//trace(' isFacebook ', isFacebook, backgroundBitmap.visible, (stage.stageWidth == 1280 || stage.stageHeight == 720));
			
			resizeBackground();
		}
		
		public function debugCreateCleanGarbageCollectorButton():void {
			if (stage.numChildren == 0 || stage.getChildAt(stage.numChildren - 1).name != 'debugGCButton') {
				var button:MovieClip = new MovieClip();
				button.y = 180;
				button.x = 0;
				button.graphics.lineStyle(2, 0);
				button.graphics.beginFill(0xFF6666, 1);
				button.graphics.drawRect(0, 0, 100, 80);
				button.graphics.endFill();
				button.name = 'debugGCButton';
				stage.addChild(button);
				button.addEventListener(MouseEvent.CLICK, function():void {System.gc(); trace('cleaned') } );
			}
		}
		
		
		public static var STATUS_MAIN_ON_STAGE:uint = 0x606060; // темно-серенький
		public static var STATUS_GAME_INIT:uint = 0xC0C0C0; // светло-серенький
		public static var STATUS_GAME_ON_STAGE:uint = 0xFFFFFF; // беленький 
		public static var STATUS_LOADING_ASSETS_COMPLETE:uint = 0x00C300; // зелененький
		public static var STATUS_SETTINGS_COMPLETE:uint = 0xF2FF00; // желтенький
		public static var STATUS_ASSET_INDICES_COMPLETE:uint = 0x00D9FF; // голубенький
		public static var STATUS_MAINTENANCE_IF_NEEDED:uint = 0xC40000; // бордовенький
		public static var STATUS_CONNECTED_TO_SERVER:uint = 0xFF7E28; // оранжевенький
		
		public static var statusPixels:Array;
		private static var STATUS_PIXELS_PROPERTY:String = 'STATUS_PIXELS_PROPERTY';
		private static var statusPixelsRefreshIntervalId:int;
		private static var statusPixelsHasTapListener:Boolean;
		public static var statusPixelsVisible:Boolean ;
		private static var statusPixelsLastTap:int;
		private static var statusPixelsTapCount:int = 10;
		
		public static function showStatusPixels(color:uint, height:int = 1):void 
		{
			//if (!SharedObjectManager.instance.getSharedProperty(STATUS_PIXELS_PROPERTY, false))
				//return;
				
			if (!statusPixels) {
				statusPixels = [];
			}
			
			var pixel:Sprite = new Sprite();
			//pixel.graphics.lineStyle(0.5, 0xFFFFFF, 1, true, 'normal', CapsStyle.NONE, JointStyle.BEVEL, 1);
			pixel.graphics.beginFill(color, 1);
			pixel.graphics.drawRect(0, 0, 1, height);
			pixel.graphics.endFill();
			//_instance.stage.addChild(pixel);
			
			//pixel.x = /*_instance.stage.stageWidth/2 +*/ statusPixels.length*20;
			//pixel.y = _instance.stage.stageHeight - height - 1;
			statusPixels.push(pixel);
			
			statusPixelsRefreshIntervalId = setInterval(refreshStatusPixels, 300);
		}
		
		public static function removeStatusPixels():void 
		{
			clearInterval(statusPixelsRefreshIntervalId);
			
			if (statusPixels) {
				var pixel:Sprite;
				while (statusPixels.length > 0) {
					pixel =	statusPixels.shift() as Sprite;
					if (pixel.parent)
						pixel.parent.removeChild(pixel);
				}
				
				statusPixels = null;
			}
		}
		
		public static function refreshStatusPixels():void 
		{
			//sosTrace('!! asd ', statusPixels , _instance.stage, statusPixelsHasTapListener);
			
			if (!statusPixels || !_instance.stage)
				return;
				
			if (!statusPixelsHasTapListener) {
				_instance.stage.addEventListener(MouseEvent.CLICK, handler_statusPixelsTap);
				statusPixelsHasTapListener = true;
			}
				
			var pixel:Sprite;
			for (var i:int = 0; i < statusPixels.length; i++ ) {
				pixel =	statusPixels[i] as Sprite;
				pixel.x = i*20;
				pixel.y = _instance.stage.stageHeight - pixel.height - 1;
				pixel.mouseEnabled = false;
				pixel.mouseChildren = false;
				pixel.visible = statusPixelsVisible;
				_instance.stage.addChild(pixel);
			}
		}
		
		public static function handler_statusPixelsTap(e:*):void 
		{
			if (e.stageX > 100 || e.stageY > 100)
				return;
			
			if (getTimer() - statusPixelsLastTap < 300) 
			{
				statusPixelsTapCount++;
				
				if (statusPixelsTapCount >= 8) {
					statusPixelsTapCount = 0;
					statusPixelsVisible = true;
				}
			}
			statusPixelsLastTap = getTimer();
		}
	}

}