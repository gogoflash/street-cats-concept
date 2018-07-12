package com.alisacasino.bingo.components 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import flash.utils.setInterval;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextFieldAutoSize;
	import starling.utils.TweenHelper;
	
	public class AlertSignView extends Sprite 
	{
		public var label:XTextField;
		
		private var background:Image;
		
		public function AlertSignView(text:String) 
		{
			super();
			background = new Image(AtlasAsset.CommonAtlas.getTexture("controls/red_bordered_circle"));
			background.alignPivot();
			//alertImage.scale = 0.8;
			addChild(background);
			
			label = new XTextField(1, 1, XTextFieldStyle.getWalrus(24), text);
			label.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			//label.border = true;
			//label.x = -2 * pxScale;
			//label.y = 1.5 * pxScale;
			label.redraw();
			label.alignPivot();
			addChild(label);
			
			this.text = text;
			
			//setInterval(debugSetValue, 3000);
		}
		
		public function set text(value:String):void 
		{
			//if (label.text == value)
				//return;
				
			var _x:int = -2 * pxScale;
			var _y:int = 1.2 * pxScale;
			switch(value) {
				case '1': _x = -1.98 * pxScale; break;
				case '2': _x = -1.7 * pxScale; _y = 0.4 * pxScale; break;
				case '3': _x = -0.98 * pxScale; _y = 1.0 * pxScale; break;
				case '4': _x = -1.8 * pxScale; _y = 0.6 * pxScale; break;
				case '5': _x = 0.0 * pxScale; _y = 1.0 * pxScale; break;
				case '6': _x = -1.0 * pxScale; _y = 1.0 * pxScale; break;
				case '7': _x = -0.7 * pxScale; break;
				case '!': _x = -1.3 * pxScale; break;
				default : _x = -2 * pxScale; break;
			}
			
			label.text = value;
			label.alignPivot();
			label.x = _x;
			label.y = _y;
		}
		
		public function get text():String
		{
			return label.text;
		}
		
		public function animateText(value:String, delay:Number = 0):void 
		{
			if (label.text == value)
				return;
			
			Starling.juggler.removeTweens(label);
			Starling.juggler.removeTweens(background);
				
			TweenHelper.tween(label, 0.15, {delay:delay, scale:0, transition:Transitions.EASE_IN_BACK, onComplete:textSetter, onCompleteArgs:[value]}).
				chain(label, 0.35, {scale:1, transition:Transitions.EASE_OUT_BACK});
				
			TweenHelper.tween(background, 0.15, {delay:delay, scale:0.7, transition:Transitions.EASE_IN_BACK}).
				chain(background, 0.35, {scale:1, transition:Transitions.EASE_OUT_BACK});
		}
		
		private function textSetter(value:String):void 
		{
			text = value;
		}
		
		private function debugSetValue():void 
		{
			if (Math.random() > 0.7) {
				text = '!';
			}
			else {
				//text = Math.floor(4 * Math.random()).toString();
				
				if (Math.random() > 0.5)
					text = Math.floor(4 * Math.random()).toString();
				else
					text = (4 + Math.floor(4 * Math.random())).toString();
			}
		}
	}

}