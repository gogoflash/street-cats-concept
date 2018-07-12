package com.alisacasino.bingo.utils
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.controls.LoadingWheel;
	import com.alisacasino.bingo.controls.SharingScreenBlock;
	import starling.display.BlendMode;
	import starling.rendering.Painter;
	import starling.utils.RenderUtil;
	
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class ScreenshotUtils
	{
		private static var sTexture:Texture;
		private static var sBitmapData:BitmapData;
		static private var screenshotImage:Image;
		
		public static function dispose():void {
			
			if (screenshotImage)
			{
				screenshotImage.removeFromParent(true);
				screenshotImage = null;
			}
			
			if (sTexture != null) {
				sTexture.dispose();
				sTexture = null;
			}
			
			if (sBitmapData != null) {
				sBitmapData.dispose();
				sBitmapData = null;
			}
		} 
		
		public static function screenshot():void {
			if(!Game.current || !Game.current.currentScreen) {
				return;
			}
			
			if (screenshotImage || sTexture || sBitmapData)
			{
				dispose();
			}
			
			sBitmapData = drawStageToBD();
			
			var currentScreenAsDOC:DisplayObjectContainer = Game.current.currentScreen as DisplayObjectContainer;
			if (!sBitmapData)
			{
				return;
			}
			sTexture = Texture.fromBitmapData(sBitmapData, false);
			
			screenshotImage = new Image(sTexture);
			screenshotImage.scale = layoutHelper.stageEtalonHeight/sBitmapData.height;
			currentScreenAsDOC.addChild(screenshotImage);
		}
		
		static public function drawStageToBD(removeBlocks:Boolean = true):BitmapData
		{
			if (removeBlocks)
			{
				LoadingWheel.removeIfAny();
				SharingScreenBlock.removeIfAny();
			}
			return Game.current.stage.drawToBitmapData(null, true);
		}
	}
}
