package com.alisacasino.bingo.controls
{
	import starling.display.Image;
	import starling.filters.ColorMatrixFilter;
	import starling.textures.Texture;

	public class BingoAnimationItem extends Image 
	{
		public function BingoAnimationItem(texture:Texture) {
			super(texture);
		}
		
		public var positionX:int;
		public var positionY:int;
		public var phaseShift:Number = 0;
		public var maxShiftX:int;
		public var maxShiftY:int;
		public var appearTweenRatioShift:Number = 0;
		public var initAngle:Number = 0;
		
		public var backImage:Image;
		public var waveTweenEnabled:Boolean;
		
		public static function create(backTexture:Texture, texture:Texture, positionX:int, positionY:int, phaseShift:Number, maxShiftX:int, maxShiftY:int = 0, appearTweenRatioShift:Number = 0, initAngle:Number = 0):BingoAnimationItem {
			var item:BingoAnimationItem = new BingoAnimationItem(texture);
			item.backImage = new Image(backTexture);
			item.backImage.touchable = false;
			item.positionX = positionX * pxScale;
			item.positionY = positionY * pxScale;
			item.phaseShift = phaseShift;
			item.rotation = initAngle;
			item.initAngle = initAngle;
			item.touchable = false;
			//item.maxShiftX = maxShiftX * pxScale;
			//item.maxShiftY = maxShiftY * pxScale;
			item.appearTweenRatioShift = appearTweenRatioShift;
			return item;
		}
		
		public function remove():void {
			removeFromParent(true);
			backImage.removeFromParent(true);
		}
		
		override public function set x(value:Number):void {
			super.x = value;
			backImage.x = value;
		}
		
		override public function set y(value:Number):void {
			super.y = value;
			backImage.y = value;
		}
		
		override public function set scale(value:Number):void {
			super.scale = value;
			backImage.scale = value;
		}
		
		override public function set rotation(value:Number):void {
			super.rotation = value;
			backImage.rotation = value;
		}
		
		public function set brightness(value:Number):void {
			(filter as ColorMatrixFilter).matrix = getBrightnessMatrix(value);
		}
		
		public function getBrightnessMatrix(value:Number):Vector.<Number> {
			return new <Number> [	
				value, 0, 0, 0, 0,
				0, value, 0, 0, 0,
				0, 0, value, 0, 0,
				0, 0, 0, 1, 0
			]
		}
	}
}
