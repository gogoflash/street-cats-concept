package com.alisacasino.bingo.screens.inventoryScreenClasses 
{
	import com.alisacasino.bingo.assets.ImageAsset;
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import flash.geom.Rectangle;
	import starling.display.DisplayObject;
	
	public interface ICardRenderer extends IFeathersControl
	{
		function get cardItem():ICardData
		
		function get index():int;
		
		function get cardAsset():ImageAsset;
		
		function get isSelectedView():Boolean;
		
		function invalidate(flag:String = FeathersControl.INVALIDATION_FLAG_ALL):void
	}
}