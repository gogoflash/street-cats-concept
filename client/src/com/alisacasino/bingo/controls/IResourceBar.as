package com.alisacasino.bingo.controls 
{
	import flash.geom.Rectangle;
	import starling.display.DisplayObject;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public interface IResourceBar 
	{
		
		
		function animateToValue(resultQuantity:uint, animationDuration:Number = 1.0, animationDelay:Number = 0.0):void 
		
		function getImageRect(targetSpace:DisplayObject):Rectangle;
		
	}

}