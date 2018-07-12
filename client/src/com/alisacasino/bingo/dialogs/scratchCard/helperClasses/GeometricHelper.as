package com.alisacasino.bingo.dialogs.scratchCard.helperClasses 
{
	import flash.geom.Rectangle;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class GeometricHelper extends Sprite
	{
		private var calc:GeometricScratchCalculator;
		
		private var quads:Vector.<Quad>;
		
		public function GeometricHelper(calc:GeometricScratchCalculator) 
		{
			this.calc = calc;
			
			quads = new Vector.<Quad>();
			
			for (var i:int = 0; i < calc.rects.length; i++) 
			{
				var rect:Rectangle = calc.rects[i];
				var quad:Quad = new Quad(rect.width, rect.height, 0x0);
				quad.touchable = false;
				quad.x = rect.x;
				quad.y = rect.y;
				quads.push(quad);
				addChild(quad);
			}
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			for (var i:int = 0; i < calc.hits.length; i++) 
			{
				quads[i].color = (calc.hits[i] == true) ? 0xFF0000 :0x0;
			}
		}
		
	}

}