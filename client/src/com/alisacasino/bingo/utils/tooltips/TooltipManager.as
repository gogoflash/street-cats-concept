package com.alisacasino.bingo.utils.tooltips 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.utils.Align;
	import starling.utils.TweenHelper;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class TooltipManager 
	{
		private var FINGER_SHIFT:int = 15;
		
		private static var _instance:TooltipManager;
		
		public static function getInstance():TooltipManager
		{
			if (!_instance)
			{
				_instance = new TooltipManager();
			}
			
			return _instance;
		}
		
		private var currentTooltip:Tooltip;
		
		public function TooltipManager() 
		{
			
		}
		
		public function showTooltip(anchor:DisplayObject, content:String, align:String = Align.TOP, anchorShift:Point = null):void
		{
			removeCurrentTooltip();
			
			var tooltip:Tooltip = new Tooltip(anchor, content, align, anchorShift);
			currentTooltip = tooltip;
			Starling.current.stage.addChild(tooltip);
			tooltip.validate();
			
			positionTooltip(tooltip);
			
			tooltip.scale = 0;
			tooltip.alpha = 0.6;
			Starling.juggler.removeTweens(tooltip);
			Starling.juggler.tween(tooltip, 0.3, { scale:layoutHelper.newBarScale, alpha: 1, transition:Transitions.EASE_OUT_BACK } );
		}
		
		private function positionTooltip(tooltip:Tooltip):void 
		{
			switch(tooltip.align)
			{
				default:
				case Align.TOP:
					tooltipAlignTop(tooltip, tooltip.anchor, tooltip.anchorShift);
					break;
				case Align.RIGHT:
					tooltipAlignRight(tooltip, tooltip.anchor, tooltip.anchorShift);
					break;
				case Align.LEFT:
					tooltipAlignLeft(tooltip, tooltip.anchor, tooltip.anchorShift);
					break;
				case Align.BOTTOM:
					tooltipAlignBottom(tooltip, tooltip.anchor, tooltip.anchorShift);
					break;
			}
		}
		
		private function tooltipAlignBottom(tooltip:Tooltip, anchor:DisplayObject, anchorShift:Point):void 
		{
			var anchorBounds:Rectangle = anchor.getBounds(Starling.current.stage);
			
			tooltip.alignPivot(Align.CENTER, Align.TOP);
			
			tooltip.scale = layoutHelper.newBarScale;
			
			var anchorShiftX:Number = anchorShift ? anchorShift.x : 0;
			var anchorShiftY:Number = anchorShift ? anchorShift.y : 0;
			var tooltipTargetX:Number = anchorBounds.left + anchorBounds.width / 2 + anchorShiftX;
			fitTooltipHorizontal(tooltip, tooltipTargetX);
			
			
			tooltip.x = tooltipTargetX;
			tooltip.y = anchorBounds.bottom + anchorShiftY + FINGER_SHIFT*layoutHelper.newBarScale*pxScale;
		}
		
		private function tooltipAlignLeft(tooltip:Tooltip, anchor:DisplayObject, anchorShift:Point):void 
		{
			tooltip.alignPivot(Align.RIGHT, Align.CENTER);
			
			tooltip.scale = layoutHelper.barScale;
			
			var anchorShiftX:Number = anchorShift ? anchorShift.x : 0;
			var anchorShiftY:Number = anchorShift ? anchorShift.y : 0;
			
			var anchorBounds:Rectangle = anchor.getBounds(Starling.current.stage);;
			tooltip.x = anchorBounds.left - tooltip.width + anchorShiftX - FINGER_SHIFT*layoutHelper.newBarScale*pxScale;
			tooltip.y = anchorBounds.top + anchorBounds.height / 2 + anchorShiftY;
		}
		
		private function tooltipAlignRight(tooltip:Tooltip, anchor:DisplayObject, anchorShift:Point):void 
		{
			tooltip.alignPivot(Align.LEFT, Align.CENTER);
			
			tooltip.scale = layoutHelper.newBarScale;
			
			var anchorShiftX:Number = anchorShift ? anchorShift.x : 0;
			var anchorShiftY:Number = anchorShift ? anchorShift.y : 0;
			
			var anchorBounds:Rectangle = anchor.getBounds(Starling.current.stage);
			tooltip.x = anchorBounds.right + anchorShiftX + FINGER_SHIFT*layoutHelper.newBarScale*pxScale;
			tooltip.y = anchorBounds.top + anchorBounds.height / 2 + anchorShiftY;
		}
		
		private function tooltipAlignTop(tooltip:Tooltip, anchor:DisplayObject, anchorShift:Point):void 
		{
			var anchorBounds:Rectangle = anchor.getBounds(Starling.current.stage);
			
			tooltip.alignPivot(Align.CENTER, Align.BOTTOM);
			
			tooltip.scale = layoutHelper.newBarScale;
			
			var anchorShiftX:Number = anchorShift ? anchorShift.x : 0;
			var anchorShiftY:Number = anchorShift ? anchorShift.y : 0;
			var tooltipTargetX:Number = anchorBounds.left + anchorBounds.width / 2 + anchorShiftX;
			fitTooltipHorizontal(tooltip, tooltipTargetX);
			
			
			tooltip.x = tooltipTargetX;
			tooltip.y = anchorBounds.top + anchorShiftY - FINGER_SHIFT*layoutHelper.newBarScale*pxScale;
		}
		
		private function fitTooltipHorizontal(tooltip:Tooltip, tooltipTargetX:Number):void 
		{
			var tooltipPivotShift:Number = 0;
			var borderLimit:Number = 30 * pxScale * layoutHelper.newBarScale;
			if (tooltipTargetX - tooltip.width / 2 < borderLimit)
			{
				tooltipPivotShift = -tooltip.width / 2 + tooltipTargetX - borderLimit
			}
			else if (tooltipTargetX + tooltip.width / 2 > Starling.current.stage.stageWidth - borderLimit)
			{
				tooltipPivotShift = tooltip.width / 2 + tooltipTargetX + borderLimit - Starling.current.stage.stageWidth;
			}
			
			tooltip.pivotX += tooltipPivotShift / tooltip.scale;
			tooltip.moveTailX(tooltipPivotShift / tooltip.scale);
		}
		
		private function removeCurrentTooltip():void 
		{
			if (currentTooltip)
			{
				Starling.juggler.removeTweens(currentTooltip);
				TweenHelper.tween(currentTooltip, 0.2, {scale: 0, alpha: 0, onComplete:currentTooltip.removeFromParent, onCompleteArgs: [true]});
				//currentTooltip.removeFromParent(true);
				currentTooltip = null;
			}
		}
		
		public function removeTooltip(anchor:DisplayObject):void
		{
			if (currentTooltip && currentTooltip.anchor == anchor)
			{
				removeCurrentTooltip();
			}
		}
		
	}

}