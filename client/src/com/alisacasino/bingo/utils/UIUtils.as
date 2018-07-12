package com.alisacasino.bingo.utils
{
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
	import starling.display.Canvas;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.filters.ColorMatrixFilter;
	import starling.textures.Texture;
	import starling.utils.Align;
	import starling.utils.TweenHelper;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class UIUtils
	{
		
		public function UIUtils()
		{
		
		}
		
		static public function createRoundedRectMaskCanvas(width:Number, height:Number, cornerRadius:Number, shiftX:Number = 0, shiftY:Number = 0):Canvas
		{
			width *= pxScale;
			height *= pxScale;
			cornerRadius *= pxScale;
			shiftX *= pxScale;
			shiftY *= pxScale;
			
			var canvas:Canvas = new Canvas();
			canvas.drawCircle(cornerRadius + shiftX, shiftY + cornerRadius, cornerRadius);
			canvas.drawCircle(width - cornerRadius + shiftX, shiftY + cornerRadius, cornerRadius);
			canvas.drawCircle(cornerRadius + shiftX, height - cornerRadius + shiftY, cornerRadius);
			canvas.drawCircle(width - cornerRadius + shiftX, height - cornerRadius + shiftY, cornerRadius);
			canvas.drawRectangle(cornerRadius + shiftX, shiftY, width - cornerRadius * 2, height);
			canvas.drawRectangle(shiftX, shiftY + cornerRadius, width, height - cornerRadius*2);
			return canvas;
		}
		
		static public function addBoundQuad(container:DisplayObjectContainer, bounds:Rectangle, color:uint):void
		{
			var titleQuad:Quad = new Quad(bounds.width, bounds.height, color);
			titleQuad.alpha = 0.3;
			titleQuad.x = bounds.x;
			titleQuad.y = bounds.y;
			container.addChild(titleQuad);
		}
		
		static public function fitInBounds(object:DisplayObject, targetBounds:Rectangle, maxBounds:Rectangle = null, hAlign:String = Align.RIGHT, vAlign:String = Align.CENTER):void
		{
			var targetScaleX:Number = targetBounds.width / object.width;
			var targetScaleY:Number = targetBounds.height / object.height;
			var targetScale:Number = Math.max(targetScaleX, targetScaleY);
			
			if (maxBounds)
			{
				targetScaleX = maxBounds.width / object.width;
				targetScaleY = maxBounds.height / object.height;
				targetScale = Math.min(targetScale, Math.min(targetScaleX, targetScaleY));
			}
			
			if (isNaN(targetScale) || !isFinite(targetScale))
			{
				targetScale = 1;
			}
			
			object.scale = targetScale;
			
			if (hAlign == Align.RIGHT)
			{
				object.x = targetBounds.right - object.width;
			}
			else if (hAlign == Align.LEFT)
			{
				object.x = targetBounds.x;
			}
			else if (hAlign == Align.CENTER)
			{
				object.x = targetBounds.x + (targetBounds.width - object.width) / 2;
			}
			
			if (vAlign == Align.CENTER)
			{
				object.y = targetBounds.y + (targetBounds.height - object.height) / 2;
			}
			else if (vAlign == Align.TOP)
			{
				object.y = targetBounds.y;
			}
			else if (vAlign == Align.BOTTOM)
			{
				object.y = targetBounds.bottom - object.height;
			}
		}
		
		public static function addTile3Images(container:DisplayObjectContainer, sideTexture:Texture, centerTexture:Texture, width:int, x:Number = 0, y:Number = 0):void
		{
			var image:Image = new Image(sideTexture);
			image.x = x;
			image.y = y;
			container.addChild(image);
			
			image = new Image(centerTexture);
			image.tileGrid = new Rectangle(0, 0, centerTexture.width, 0);
			image.width = width - sideTexture.width * 2;
			image.x = x + sideTexture.width;
			image.y = y;
			container.addChild(image);
			
			image = new Image(sideTexture);
			image.scaleX = -1;
			image.x = width;
			image.y = y;
			container.addChild(image);
		}
		
		public static function alignPivotAndMove(displayObject:DisplayObject, horizontalAlign:String="center", verticalAlign:String="center"):void
		{
			displayObject.x -= displayObject.pivotX;
			displayObject.y -= displayObject.pivotY;
			displayObject.alignPivot(horizontalAlign, verticalAlign);
			displayObject.x += displayObject.pivotX;
			displayObject.y += displayObject.pivotY;
		}
		
		
		
		private static var quads:Object = {};
		 
		public static function drawQuad(id:String, x:Number, y:Number, width:int = 100, height:int = 100, alpha:Number = 0.4, color:int = -1):Quad 
		{
			var quad:Quad;
			
			if (id in quads) {
				quad = quads[id] as Quad;
			}
			else {
				quad = new Quad(width, height, color == -1 ? Math.random() * 0xFFFFFF : color);
				quad.touchable = false;
				quads[id] = quad;
			}
			
			quad.alpha = alpha;
			quad.x = x;
			quad.y = y;
			quad.width = width;
			quad.height = height;
			
			return quad;
		}
		
		public static function getDrawQuad(id:String):Quad 
		{
			return quads[id] as Quad;
		}
		
		public static function removeDrawQuad(id:String):void
		{
			if (quads[id] as Quad) {
				(quads[id] as Quad).removeFromParent(true);
				delete quads[id];
			}
		}
		
		/*static public function getGrayscaleFilter():ColorMatrixFilter 
		{
			var grayscaleFilter:ColorMatrixFilter = new ColorMatrixFilter();
			grayscaleFilter.adjustSaturation( -1);
			
			return grayscaleFilter;
		}*/
		
		public static function makePopTween(target:DisplayObject, delay:Number):void
		{
			target.scale = 0;
			TweenHelper.tween(target, 0.3, { delay: delay, scale: 1.2, transition: Transitions.EASE_OUT } )
				.chain(target, 0.2, { scale: 1, transition:Transitions.EASE_IN_CUBIC_OUT_BACK } );
		}
	
	}

}