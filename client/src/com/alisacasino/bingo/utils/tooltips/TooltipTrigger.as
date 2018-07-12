package com.alisacasino.bingo.utils.tooltips 
{
	import feathers.controls.Button;
	import feathers.controls.ButtonState;
	import flash.geom.Point;
	import starling.display.Quad;
	import starling.utils.Align;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class TooltipTrigger extends Button
	{
		private var triggerWidth:Number;
		private var triggerHeight:Number;
		public var anchorShift:Point;
		public var align:String;
		public var text:String;
		private var showingTooltip:Boolean;
		private var useButtonBehavior:Boolean;
		
		public function TooltipTrigger(triggerWidth:Number, triggerHeight:Number, text:String, align:String = Align.TOP, anchorShift:Point = null, useButtonBehavior:Boolean = false) 
		{
			this.anchorShift = anchorShift;
			this.align = align;
			this.text = text;
			this.triggerHeight = triggerHeight;
			this.triggerWidth = triggerWidth;
			this.useButtonBehavior = useButtonBehavior;
			useHandCursor = true;
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			if (!useButtonBehavior) {
				var quad:Quad = new Quad(triggerWidth, triggerHeight);
				quad.visible = false;
				defaultSkin = quad;
				setSizeInternal(triggerWidth, triggerHeight, false);
			}
		}
		
		
		override protected function changeState(state:String):void 
		{
			super.changeState(state);
			var needToShowTooltip:Boolean = false;
			switch(state)
			{
				case ButtonState.DOWN_AND_SELECTED:
				case ButtonState.DOWN:
					needToShowTooltip = true;
					break;
			}
			
			
			if (!showingTooltip && needToShowTooltip)
			{
				showTooltip();
			}
			if (showingTooltip && !needToShowTooltip)
			{
				hideTooltip();
			}
		}
		
		private function hideTooltip():void 
		{
			showingTooltip = false;
			TooltipManager.getInstance().removeTooltip(this);
		}
		
		private function showTooltip():void 
		{
			showingTooltip = true;
			TooltipManager.getInstance().showTooltip(this, text, align, anchorShift);
		}
		
	}

}