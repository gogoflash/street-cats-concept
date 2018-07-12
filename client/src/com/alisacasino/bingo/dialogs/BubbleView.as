package com.alisacasino.bingo.dialogs
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.RelativePixelMovingHelper;
	import flash.geom.Rectangle;
	import starling.display.Sprite;
	import starling.utils.Align;
	;
	
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.display.Image;
	
	public class BubbleView extends Sprite
	{
		protected var bubbleBg:Image;
		protected var bubbleTail:Image;
		protected var textField:XTextField;
		
		protected var _text:String;
		
		protected var _width:int;
		protected var _height:int;
		protected var _fontSize:int;
		
		public function BubbleView(text:String = '', width:int = 200, height:int = 100, fontSize:int = 0) {
			_text = text;
			_width = width;
			_height = height;
			_fontSize = fontSize;
			initialize();
		}
				
		public function get text():String {
			return _text;
		}
		
		public function set text(value:String):void {
			if (_text == value)
				return;
				
			_text = value;
			refresh();
		}
		
		public function setSize(width:int, height:int):void {
			_width = width;
			_height = height;
			refresh();
		}
		
		protected function initialize():void 
		{
			bubbleBg = new Image(AtlasAsset.LoadingAtlas.getTexture("misc/bubble_body"));
			bubbleBg.scale9Grid = new Rectangle(72*pxScale,27*pxScale,2*pxScale,5*pxScale);
			addChild(bubbleBg);
			//RelativePixelMovingHelper.add(bubbleBg, mBack.width, mBack.height);
			
			bubbleTail = new Image(AtlasAsset.LoadingAtlas.getTexture("misc/bubble_tail"));
			bubbleTail.alignPivot();
			addChild(bubbleTail);
			
			var fontSize:int = _fontSize == 0 ? XTextFieldStyle.InviteFriendsDialogHintTextFieldStyle.fontSize : _fontSize; 
			
			textField = new XTextField(1, 1, XTextFieldStyle.InviteFriendsDialogHintTextFieldStyle, _text, fontSize * (1/pxScale));
			textField.autoSize = TextFieldAutoSize.VERTICAL;
			textField.format.horizontalAlign = Align.CENTER;
			
			addChild(textField);
			
			refresh();
		}
		
		protected function refresh():void
		{
			bubbleBg.width = _width;

			
			textField.width = bubbleBg.width - 42;
			textField.text = _text;
			textField.x = bubbleBg.x + 23;
			
			
			bubbleBg.height = Math.max(_height, textField.height + 30);
			
			bubbleTail.x = bubbleBg.x - 8;
			bubbleTail.y = bubbleBg.y + (bubbleBg.height)/2;
			bubbleTail.rotation = Math.PI / 2;
			
			textField.y = (bubbleBg.height - textField.height) / 2 - 5;
		}
	}	
}
