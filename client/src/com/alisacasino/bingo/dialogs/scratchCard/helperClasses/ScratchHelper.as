package com.alisacasino.bingo.dialogs.scratchCard.helperClasses 
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ScratchHelper 
	{
		
		private var lastMousePosX:Number;
		private var lastMousePosY:Number;
		private var scratchCircle:Sprite;
		private var mtx:Matrix;
		
		private var scratchWidth:Number = 100;
		private var eraseQuad:Quad;
		private var eraseSprite:Sprite;
		private var circleBMPD:BitmapData;
		private var circleTexture:Texture;
		
		public function ScratchHelper(scale:Number) 
		{
			scratchWidth = 80 * scale;
			
			mtx = new Matrix();
			
			eraseQuad = new Quad(scratchWidth, scratchWidth);
			eraseQuad.blendMode = BlendMode.ERASE;
			eraseQuad.alignPivot();
			
			eraseSprite = new Sprite();
			eraseSprite.addChild(eraseQuad);
			
			var scratchRadius:Number = scratchWidth / 2;
			
			scratchCircle = new Sprite();
			scratchCircle.blendMode = BlendMode.ERASE;
			
			circleBMPD = BmpdHelper.getCircleBMPD(scratchRadius);
			circleTexture = Texture.fromBitmapData(circleBMPD)
			var circleImage:Image = new Image(circleTexture);
			circleImage.alignPivot();
			scratchCircle.addChild(circleImage);
			
		}
		
		public function resetDrawPoint(texture:RenderTexture, x:Number, y:Number):void
		{
			lastMousePosX = x;
			lastMousePosY = y;
			
			mtx.identity();
			mtx.translate(lastMousePosX, lastMousePosY);
			texture.draw(scratchCircle, mtx);
		}
		
		public function drawAtMouse(texture:RenderTexture, x:Number, y:Number):void 
		{
			if (x == lastMousePosX && y == lastMousePosY)
			{
				return;
			}
			
			mtx.identity();
			mtx.translate(x, y);
			texture.draw(scratchCircle, mtx);
			
			var diffX:Number = x - lastMousePosX;
			var diffY:Number = y - lastMousePosY;
			
			var scratchPosX:Number = lastMousePosX + diffX / 2;
			var scratchPosY:Number = lastMousePosY + diffY / 2;
			
			var angle:Number = Math.atan2(diffY, diffX);
			
			var distance:Number = Math.sqrt(diffX * diffX + diffY * diffY);
			
			mtx.identity();
			mtx.scale(distance / eraseQuad.width, 1);
			mtx.rotate(angle);
			mtx.translate(scratchPosX, scratchPosY);
			
			lastMousePosX = x;
			lastMousePosY = y;
			
			texture.draw(eraseSprite, mtx);
		}
		
		public function dispose():void 
		{
			if (circleTexture)
			{
				circleTexture.dispose();
				circleTexture = null;
			}
			
			if (circleBMPD)
			{
				circleBMPD.dispose();
				circleBMPD = null;
			}
		}
		
	}

}

import flash.display.BitmapData;
import flash.display.Sprite;

class BmpdHelper
{
	public static function getCircleBMPD(scratchRadius:Number):BitmapData
	{
		var bitmapData:BitmapData = new BitmapData(scratchRadius * 2, scratchRadius * 2, true, 0x0);
		var scratchCircle:Sprite = new Sprite();
		scratchCircle.graphics.beginFill(0xFF000000, 1);
		scratchCircle.graphics.drawCircle(scratchRadius, scratchRadius, scratchRadius);
		scratchCircle.graphics.endFill();
		bitmapData.draw(scratchCircle);
		return bitmapData;
	}
}