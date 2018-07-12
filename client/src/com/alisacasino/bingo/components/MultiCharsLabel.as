package com.alisacasino.bingo.components
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.Fonts;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import flash.utils.setInterval;
	import starling.display.Quad;
	import starling.events.Event;
	
	public class MultiCharsLabel
	{
		private var label:XTextField;
		private var style:XTextFieldStyle;
		private var systemFontStyle:XTextFieldStyle;
		private var _text:String;
		private var isTextLatinChars:Boolean;
		private var upperCase:Boolean;
		
		public function MultiCharsLabel(style:XTextFieldStyle, width:Number, height:Number, text:String = '', upperCase:Boolean = false):void
		{
			this.style = style;
			this.upperCase = upperCase;
			
			systemFontStyle = style.clone();
			systemFontStyle.fontName = '';
			
			_text = text;
			isTextLatinChars = Fonts.allCharsInFont(style.fontName, _text);
			
			label = new XTextField(width, height, isTextLatinChars ? style : systemFontStyle);
			label.autoScale = true;
			
			updateText();
		}
		
		public function get textField():XTextField
		{
			return label;
		}
		
		public function get text():String
		{
			return _text;
		}
		
		public function set text(value:String):void
		{
			if (_text == value)
				return;
			
			_text = value;
			
			isTextLatinChars = Fonts.allCharsInFont(style.fontName, _text);
			updateText();
		}
		
		public function setStyle(style:XTextFieldStyle = null, redraw:Boolean = false):void
		{
			if (this.style == style)
				return;
			
			this.style = style;
			systemFontStyle = style.clone();
			systemFontStyle.fontName = '';	
		
			if (redraw) {
				isTextLatinChars = Fonts.allCharsInFont(style.fontName, _text);
				updateText();
			}
		}
		
		private function updateText():void 
		{
			if (gameManager.deactivated) {
				if(!Game.hasEventListener(Game.ACTIVATED, handler_gameActivated)) 
					Game.addEventListener(Game.ACTIVATED, handler_gameActivated);
				return;	
			}
			
			if (isTextLatinChars)
			{
				label.textStyle = style;
				label.format.bold = style.bold;	
			}
			else
			{
				label.textStyle = systemFontStyle;
				label.format.bold = true;	
			}
			
			label.text = isTextLatinChars ? (upperCase ? (_text ? _text.toUpperCase() : '' ) : _text) : _text;
		}
		
		private function handler_gameActivated(e:Event):void 
		{
			Game.removeEventListener(Game.ACTIVATED, handler_gameActivated);
			updateText();
		}	
		
		public function clean(dispose:Boolean):void
		{
			label.removeFromParent(dispose);
			label = null;
			if (Game.hasEventListener(Game.ACTIVATED, handler_gameActivated))
				Game.removeEventListener(Game.ACTIVATED, handler_gameActivated);
		}	
		
		public function debugTest(showBgQuad:Boolean = false):void 
		{
			var names:Array = [
				"Хом", "Donna", "Konstantin", "Алексей", 'Васисуалий', "Рулон Обоев", "Margarita", "Коровка Говорит Муууууууууу", "Maria Moconini", "Лопасть Изменяемого Шага", "Very long name Very long name Very long name "
				//"Алексей", "Сергей", "Федор", "Вероника", "Наталья", 'Диана', 'Васисуалий', 
				//'Марк Мопедович', 'Принцеса Амидала', "Длинннноеиммяяяяяя", "Лопасть Изменяемого Шага", "Рулон Обоев", "Забег Дебилов", "Марафон изгоев", "Коровка Говорит Муууууууууу",
				//"Konstantin", "Donna", "Diana", "Barbara", "Holly",
				//"Ashot", "Ekaterina", "Maria", "Margarita", , "Maria Moconini", "Very long name Very long name Very long name "
				];
			var i:int;
			
			setInterval(function():void {
				text = names[i];
				
				i++;
				if (i >= names.length)
					i = 0;
			}, 2000);
			
			if (showBgQuad && label.parent) {
				var r:Quad = new Quad(textField.width, textField.height, 0x000000);
				r.alpha = 0.4;
				r.x = label.x;
				r.y = label.y;
				label.parent.addChildAt(r, label.parent.getChildIndex(label)-1);
			}
			
		}
	}
}