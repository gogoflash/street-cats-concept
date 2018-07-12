package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextFieldAutoSize;
	
	public class StarTitle extends Sprite
	{
		private var starLeft:Image;
		private var starRight:Image;
		public var label:XTextField;
		private var _text:String;
		private var starsShiftX:int;
		private var starsShiftY:int;
		private var gap:int;
		private var onActivateCallback:Function;
		
		public function get text():String 
		{
			return _text;
		}
		
		public function set text(value:String):void 
		{
			if (_text != value)
			{
				_text = value;
				updateText();
				setStarPositions();
			}
		}
		
		public function updateText():void 
		{
			if (gameManager.deactivated || !gameManager.hasStage3D) {
				Game.addEventListener(Game.ACTIVATED, game_activatedHandler);
				return;
			}
			
			label.text = text;
			label.redraw();
		}
		
		private function game_activatedHandler(e:Event):void
		{
			Game.removeEventListener(Game.ACTIVATED, game_activatedHandler);
			updateText();
			setStarPositions();
			if(onActivateCallback != null)
				onActivateCallback();
		}
		
		public function StarTitle(text:String, style:XTextFieldStyle, gap:int = 0, starsShiftX:int = 0, starsShiftY:int = 0, onActivateCallback:Function = null)
		{
			this.gap = gap;
			this.starsShiftY = starsShiftY;
			this.starsShiftX = starsShiftX;
			this.onActivateCallback = onActivateCallback;
			
			starLeft = new Image(AtlasAsset.LoadingAtlas.getTexture("misc/white_star"));
			starLeft.color = style.fontColor;
			addChild(starLeft);
			starRight = new Image(AtlasAsset.LoadingAtlas.getTexture("misc/white_star"));
			starRight.color = style.fontColor;
			addChild(starRight);
			
			label = new XTextField(1, 1, style, "");
			label.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			label.x = starRight.width + gap*pxScale;
			addChild(label);
			
			this.text = text;
			setStarPositions();
		}
		
		private function setStarPositions():void 
		{
			starLeft.y = (label.height - starLeft.height) / 2 + starsShiftY*pxScale;
			starRight.y = starLeft.y;
			starRight.x = label.x + label.width + gap*pxScale + starsShiftX*pxScale;
		}
		
		override public function dispose():void 
		{
			if(Game.current)
				Game.removeEventListener(Game.ACTIVATED, game_activatedHandler);
			
			super.dispose();
		}
		
	}
}