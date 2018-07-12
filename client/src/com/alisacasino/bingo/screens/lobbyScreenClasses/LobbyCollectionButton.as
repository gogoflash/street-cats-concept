package com.alisacasino.bingo.screens.lobbyScreenClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.components.AlertSignView;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import starling.display.Image;
	import starling.display.Quad;
	
	public class LobbyCollectionButton extends XButton 
	{
		
		public function LobbyCollectionButton(style:XButtonStyle, text:String="", disabledText:String="") 
		{
			super(style, text, disabledText);
		}
		
		private var _newCount:int;
		
		private var alertSignView:AlertSignView;
		
		public function set newCount(value:int):void 
		{
			_newCount = value;
			//_newCount = 1;			
			if (_newCount > 0) 
			{
				if (!alertSignView) {
					alertSignView = new AlertSignView(_newCount.toString());
					alertSignView.touchable = false;
					addChild(alertSignView);
				}
				else {
					alertSignView.text = _newCount.toString();
				}
				
				repositionNewCount();
			}
			else 
			{
				if (alertSignView) {
					alertSignView.removeFromParent(true);
					alertSignView = null;
				}
			}
		}
		
		public function get newCount():int
		{
			return _newCount;
		}	
		
		override public function get width():Number
		{
			return expectedWidth;
		}	
		
		override public function get height():Number
		{
			return 79*pxScale*scale;
		}	
		
		override protected function reposition():void 
		{
			super.reposition();
			repositionNewCount();
		}
		
		private function repositionNewCount():void 
		{
			if (alertSignView) {
				alertSignView.x = width/scale - 9 * pxScale;
				alertSignView.y = 3 * pxScale;
			}
		}
	}

}