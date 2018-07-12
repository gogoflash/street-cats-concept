package com.alisacasino.bingo.components
{
	import starling.display.Sprite;
	public class FixedSizeSprite extends Sprite
	{
		private var _width:Number;
		private var _height:Number;
		
		public function FixedSizeSprite(width:Number = 0, height:Number = 0):void
		{
			_width = width;
			_height = height;
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function get height():Number
		{
			return _height;
		}
	}
}