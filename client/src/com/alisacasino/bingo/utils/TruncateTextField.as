package com.alisacasino.bingo.utils 
{
	import starling.text.BitmapChar;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	
	public class TruncateTextField extends TextField 
	{
        public function TruncateTextField(width:int, height:int, text:String, fontName:String="Verdana", fontSize:Number=12, color:uint=0x0, bold:Boolean=false, truncateString:String = '…')
		{
			// стоит различать '…' и '...'
			this.truncateString = truncateString;
			super(width, height, null, fontName, fontSize, color, bold);
			this.text = text;
		}
		
		private var truncateString:String = '…';
		private var _isTruncate:Boolean;
		
		private static const CHAR_SPACE:int           = 32;
		private static const CHAR_TAB:int             =  9;
		private static const CHAR_NEWLINE:int         = 10;
		private static const CHAR_CARRIAGE_RETURN:int = 13;
		
		
		public function get isTruncate():Boolean 
		{
			return _isTruncate;
		}
		
		override public function get text():String 
		{
			return super.text;
		}
		
		override public function set text(value:String):void 
		{
			var cutIndex:int = getTruncateIndex(value, width, height, fontSize, fontName, truncateString, kerning);
			
			var bitmapFont:BitmapFont = TextField.getBitmapFont(fontName);
			if (bitmapFont && bitmapFont.lineHeight > height)
			{
				super.text = value;
				return;
			}
						
			if(cutIndex >= 0) {
				super.text = value.slice(0, cutIndex) + truncateString;
				_isTruncate = true;
			}
			else {
				super.text = value;
				_isTruncate = false;
			}
		}
		
		public static function getTruncateIndex(text:String, width:int, height:int, fontSize:Number=12, fontName:String="SharkLatin", truncateString:String = '...', kerning:Boolean = true):int 
		{
			var cutIndex:int= -1;
			var bitmapFont:BitmapFont = TextField.getBitmapFont(fontName);
			
			if(!bitmapFont || !text || text =='') {
				return cutIndex;
			}
			
			var scale:Number = fontSize / bitmapFont.size;
			var containerWidth:Number = width// / scale;
			var containerHeight:Number = height// / scale;
			
			//if (bitmapFont.lineHeight > containerHeight)
				//return cutIndex;
				
			var truncateParameters:TruncateParameters;// = getTruncateWidth(this, truncateString);
			var truncateWidth:Number = 0;
			
			var lines:Array = [];
			var charLocation:CharLocation;
			var numChars:int = text.length;
						
			var lastWhiteSpace:int = -1;
			var lastCharID:int = -1;
			var currentX:Number = 0;
			var currentY:Number = 0;
			var currentLine:Vector.<CharLocation> = new <CharLocation>[];
			
			for (var i:int=0; i<numChars; ++i)
			{
				var lineFull:Boolean = false;
				var charID:int = text.charCodeAt(i);
				var char:BitmapChar = bitmapFont.getChar(charID);
				
				if (charID == CHAR_NEWLINE || charID == CHAR_CARRIAGE_RETURN)
				{
					lineFull = true;
				}
				else if (char == null)
				{
					trace("TruncatedTextField Missing character: " + charID);
				}
				else
				{
					if (charID == CHAR_SPACE || charID == CHAR_TAB)
						lastWhiteSpace = i;
					
					if (kerning)
						currentX += char.getKerning(lastCharID);
					
					charLocation = new CharLocation(char);
					
					charLocation.char = char;
					charLocation.x = currentX + char.xOffset;
					charLocation.y = currentY + char.yOffset;
					currentLine.push(charLocation);
					
					currentX += char.xAdvance;
					lastCharID = charID;
					
					truncateParameters = getTruncateWidth(fontName, kerning, truncateString, charID);
					
					if(truncateParameters.lastChar)
						truncateWidth = truncateParameters.getKerning(charID) + truncateParameters.currentX + truncateParameters.lastChar.xOffset + truncateParameters.lastChar.width;
					//trace('>>>>> ',scale*(currentX + truncateWidth), char.width, char.xAdvance, char.xOffset);
					if (scale*(currentX + truncateWidth) > containerWidth)
					{
						cutIndex = i;
						
						// При достаточной высоте работает механизм переноса строк: 
						if (containerHeight >= 2*bitmapFont.lineHeight)
						{
							// remove characters and add them again to next line
							var numCharsToRemove:int = lastWhiteSpace == -1 ? 1 : i - lastWhiteSpace;
							var removeIndex:int = currentLine.length - numCharsToRemove;
							
							currentLine.splice(removeIndex, numCharsToRemove);
							
							if (currentLine.length == 0)
								break;
							
							i -= numCharsToRemove;
							lineFull = true;
						}
						else
						{
							// иначе возвращаем покромсанное слово с единственной строки
							break;
						}
					}
				}
				
				if (i == numChars - 1)
				{
					lines.push(currentLine);
					cutIndex = -1;
				}
				else if (lineFull)
				{
					lines.push(currentLine);
					
					if (lastWhiteSpace == i)
						currentLine.pop();
					
					if (currentY + 2*bitmapFont.lineHeight <= containerHeight)
					{
						currentLine = new <CharLocation>[];
						currentX = 0;
						currentY += bitmapFont.lineHeight;
						lastWhiteSpace = -1;
						lastCharID = -1;
					}
					else
					{
						cutIndex = i + 1;
						break;
					}
				}
			} 
			
			return cutIndex;
			/*if(cutIndex >= 0)
				trace('s', text.slice(0, cutIndex));*/
		}
		
		private static function getTruncateWidth(fontName:String, kerning:Boolean, text:String, previousCharID:int):TruncateParameters 
		{
			var bitmapFont:BitmapFont = getBitmapFont(fontName);
			if (bitmapFont == null) {
				trace('TruncateTextField no bitmap font!');
				return new TruncateParameters(null, 0);
			}
			
			//var scale:Number = instance.fontSize / bitmapFont.size;
			var currentX:Number = 0;
			var lastCharID:int = -1;
			
			for (var i:int=0; i<text.length; ++i)
			{
				var charID:int = text.charCodeAt(i);
				var char:BitmapChar = bitmapFont.getChar(charID);
				
				if(!char)
					continue;
				
				if (kerning && i == 0) 
					currentX += char.getKerning(previousCharID); 
				
				if (kerning)
					currentX += char.getKerning(lastCharID);
				
				//trace('sadasda', char.xAdvance);
				lastCharID = charID;
				
				if(i < (text.length - 1))
					currentX += char.xAdvance;
			}
			
			return new TruncateParameters(char, currentX);
		}
		
		
		public static function getTextWidth(text:String, fontSize:Number=12, fontName:String="SharkLatin", kerning:Boolean = true):int 
		{
			var bitmapFont:BitmapFont = TextField.getBitmapFont(fontName);
			
			if(!bitmapFont || !text || text =='') {
				return 0;
			}
			
			var scale:Number = fontSize / bitmapFont.size;
			//var containerWidth:Number = width// / scale;
			//var containerHeight:Number = height// / scale;
							
			var truncateParameters:TruncateParameters;// = getTruncateWidth(this, truncateString);
			var truncateWidth:Number = 0;
			
			var charLocation:CharLocation;
			var numChars:int = text.length;
						
			var lastWhiteSpace:int = -1;
			var lastCharID:int = -1;
			var currentX:Number = 0;
			var currentY:Number = 0;
			var currentLine:Vector.<CharLocation> = new <CharLocation>[];
			
			for (var i:int=0; i<numChars; ++i)
			{
				var lineFull:Boolean = false;
				var charID:int = text.charCodeAt(i);
				var char:BitmapChar = bitmapFont.getChar(charID);
				
				if (charID == CHAR_NEWLINE || charID == CHAR_CARRIAGE_RETURN)
				{
					return scale * currentX;
				}
				else if (char == null)
				{
					trace("TruncatedTextField Missing character: " + charID);
				}
				else
				{
					if (charID == CHAR_SPACE || charID == CHAR_TAB)
						lastWhiteSpace = i;
					
					if (kerning)
						currentX += char.getKerning(lastCharID);
					
					charLocation = new CharLocation(char);
					
					charLocation.char = char;
					charLocation.x = currentX + char.xOffset;
					charLocation.y = currentY + char.yOffset;
					currentLine.push(charLocation);
					
					currentX += char.xAdvance;
					lastCharID = charID;
					
				//	truncateParameters = getTruncateWidth(fontName, kerning, truncateString, charID);
					
					/*if(truncateParameters.lastChar)
						truncateWidth = truncateParameters.getKerning(charID) + truncateParameters.currentX + truncateParameters.lastChar.xOffset + truncateParameters.lastChar.width;
					if (scale*(currentX + truncateWidth) > containerWidth)
					{
						
					}*/
				}
				
				
			} 
			
			return Math.ceil(scale * currentX);
			
		}
	}

}

import starling.text.BitmapChar;

class CharLocation
{
	public var char:BitmapChar;
	public var scale:Number;
	public var x:Number;
	public var y:Number;
	
	public function CharLocation(char:BitmapChar)
	{
		this.char = char;
	}
}

class TruncateParameters
{
	public var currentX:Number;
	public var lastChar:BitmapChar;
	
	public function TruncateParameters(lastChar:BitmapChar, currentX:Number)
	{
		this.currentX = currentX;
		this.lastChar = lastChar;
	}
	
	public function getKerning(charId:int):Number
	{
		if(lastChar)
			return lastChar.getKerning(charId);
		
		return 0;
	}
}