package com.alisacasino.bingo.resize
{
	import com.alisacasino.bingo.controls.LoadingWheel;
	import com.alisacasino.bingo.utils.GameManager;
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	
	public class ResizeUtils	
	{
		public static var SHAKE_Y_ELASTIC	:String = 'SHAKE_Y_ELASTIC';
		public static var SHAKE_Y_LINEAR	:String = 'SHAKE_Y_LINEAR';
		public static var SHAKE_X_Y_SHRINK	:String = 'SHAKE_X_Y_SHRINK';
		public static var SHAKE_X_Y_DOWN	:String = 'SHAKE_X_Y_DOWN';
		
		/** resize DisplayObject according to stage size.<br/>
		 * Method does so, not distorting the DisplayObject. */
		public static function resize(dOb:DisplayObject):void {
			dOb.scaleX = dOb.scaleY = gameManager.layoutHelper.scaleFromEtalonMin;
		}
		
		/** resize image to fit all awailable stage stage.<br/>
		 * Method does so, not distorting the image.  */
		public static function resizeBackground(img:Image):void {
			img.scale = getBackgroundScale(img);
		}
		
		public static function getBackgroundScale(img:Image):Number {
			var scaleX:Number = gameManager.layoutHelper.stageWidth / img.texture.width;
			var scaleY:Number = gameManager.layoutHelper.stageHeight / img.texture.height;
			return Math.max(scaleX, scaleY);
		}
		
		public static function resizeChildDialogs(dObC:DisplayObjectContainer):void {
			for (var i:int = 0; i < dObC.numChildren; i++) {
				var child:DisplayObject = dObC.getChildAt(i);
				if (child is LoadingWheel) {
					(child as IResizable).resize();
				}
			}
		}
		
		public static function scaleRect(sourceRect:Rectangle):Rectangle
		{
			return new Rectangle(
				sourceRect.x * pxScale,
				sourceRect.y * pxScale,
				sourceRect.width * pxScale,
				sourceRect.height * pxScale
				);
		}
		
		public static function getScaledRect(x:Number, y:Number, width:Number, height:Number):Rectangle
		{
			return new Rectangle(x * pxScale, y * pxScale, width * pxScale, height * pxScale);
		}
		
		public static function shakeBackground(image:Image, shakeType:String):void 
		{
			Starling.juggler.removeTweens(image);
			var baseScale:Number = getBackgroundScale(image);
			var tween_0:Tween;
			var tween_1:Tween;
			//shakeType = SHAKE_X_Y_DOWN;
			switch(shakeType) 
			{
				case SHAKE_Y_LINEAR: 
				{
					tween_0 = new Tween(image, 0.05, Transitions.LINEAR);
					tween_1 = new Tween(image, 0.2, Transitions.LINEAR);
					
					tween_0.animate('scaleY', baseScale*1.05);
					tween_0.nextTween = tween_1;
					
					tween_1.animate('scaleY', baseScale);
					Starling.juggler.add(tween_0);
					break;
				}
				case SHAKE_Y_ELASTIC: 
				{
					tween_0 = new Tween(image, 0.06, Transitions.EASE_OUT);
					tween_1 = new Tween(image, 0.3, Transitions.EASE_OUT_ELASTIC);
					
					tween_0.animate('scaleY', baseScale*1.04);
					tween_0.nextTween = tween_1;
					
					tween_1.animate('scaleY', baseScale);
					Starling.juggler.add(tween_0);
					break;
				}
				case SHAKE_X_Y_SHRINK: 
				{
					tween_0 = new Tween(image, 0.04, Transitions.LINEAR);
					tween_1 = new Tween(image, 0.06, Transitions.LINEAR);
					
					tween_0.animate('scale', baseScale*0.983);
					tween_0.nextTween = tween_1;
					
					tween_1.animate('scale', baseScale);
					Starling.juggler.add(tween_0);
					break;
				}
				case SHAKE_X_Y_DOWN: 
				{
					tween_0 = new Tween(image, 0.07, Transitions.EASE_IN);
					tween_1 = new Tween(image, 0.08, Transitions.LINEAR);
					
					tween_0.animate('scaleY', baseScale * 1.1);
					tween_0.animate('scaleX', baseScale * 1.03);
					tween_0.animate('pivotY', image.texture.frameHeight/2 - 25 * pxScale);
					tween_0.nextTween = tween_1;
					
					tween_1.animate('pivotY', image.texture.frameHeight / 2);
					tween_1.animate('scaleY', baseScale);
					tween_1.animate('scaleX', baseScale);
					
					Starling.juggler.add(tween_0);
					break;
				}
				default: 
				{
					image.scale = baseScale;
				}
			}
		}
		
	}
}
