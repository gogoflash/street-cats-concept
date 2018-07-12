package com.alisacasino.bingo.assets
{
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.utils.emibap.textureAtlas.DynamicAtlas;
	import starling.text.TextField;
	public class Fonts
	{
		[Embed(source="../../../../../assets/fonts/Walrus-Alisa.ttf",fontFamily="Walrus Bold",advancedAntiAliasing="true",mimeType="application/x-font-truetype",embedAsCFF="false")]
		public static const WalrusAlisa:Class;
		public static const WALRUS_BOLD:String = "Walrus Bold";
		
		[Embed(source="../../../../../assets/fonts/ChateaudeGarage.ttf",fontFamily="Chateau de Garage",advancedAntiAliasing="true",mimeType="application/x-font-truetype",embedAsCFF="false")]
		public static const ChateaudeGarage:Class;
		public static const CHATEAU_DE_GARAGE:String = "Chateau de Garage";
		
		[Embed(source="../../../../../assets/fonts/HouseHolidaySans.otf",fontFamily="House Holiday Sans", advancedAntiAliasing="true", mimeType="application/x-font",embedAsCFF="false")]
		public static const HouseHolidaySans:Class;
		public static const HOUSE_HOLIDAY_SANS:String = "House Holiday Sans";
		
		[Embed(source="../../../../../assets/fonts/MatrixComplexNC.ttf",fontFamily="Matrix Complex NC",advancedAntiAliasing="true",mimeType="application/x-font-truetype",embedAsCFF="false")]
		public static const MatrixComplexNC:Class;
		public static const MATRIX_COMPLEX:String = "Matrix Complex NC";
		
		public static const CHATEAU_DE_GARAGE_FONT_CHARSET:String = "!'()*+,-./0123456789:;=?ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz " + '"';
		public static const WALRUS_BOLD_FONT_CHARSET:String = "!'()*+,-./0123456789:;=?ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz " + '"';
		public static const DEBUG_CYRILLIC_CHARSET:String = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯабвгдеёжзийклмнопрстуфхцчшщьыъэюя";
		
		private static var chateauDeGarageFontCharsetHash:Object;
		private static var fontCharsetsHash:Object;
		private static var registeredBitmapFonts:Object = {};
		
		public static function initHash():void {
			fontCharsetsHash = {};
			addCharsetToHash(WALRUS_BOLD, WALRUS_BOLD_FONT_CHARSET);
			addCharsetToHash(CHATEAU_DE_GARAGE, CHATEAU_DE_GARAGE_FONT_CHARSET);
		}
		
		public static function createBitmapFonts():void {
			dynamicCreateBitmapFont(XTextFieldStyle.NumbersTableTextFieldStyle);
			dynamicCreateBitmapFont(XTextFieldStyle.CardNumberMarkedTextFieldStyle);
			dynamicCreateBitmapFont(XTextFieldStyle.CardNumberTextFieldStyle);
		}
		
		public static function allCharsInFont(fontName:String, string:String):Boolean {
			if (!string)
				return true;
			
			var i:int;
			var length:int = string.length;
			var charsetHash:Object = fontCharsetsHash[fontName];
			for (i = 0; i < length; i++) {
				if (!(string.charAt(i) in charsetHash)) {
					return false;
				}
			}	
			
			return true;
		}
		
		public static function dynamicCreateBitmapFont(style:XTextFieldStyle):void {
			
			if (!style.charset || 
				style.charset == "" || 
				style.fontName in registeredBitmapFonts) 
				return;
			//DynamicAtlas.bitmapFontFromString("1234567890C", embeddedFont1.fontName, 30, false, false, -2, 'NumbersTableTextFieldStyle');
			
			DynamicAtlas.bitmapFontFromString(style.charset, style.charsetSourceFontName, style.fontSize, false, false, style.charMargin, style.fontName);
			registeredBitmapFonts[style.fontName] = true;
		}
		
		public static function disposeDynamicBitmapFont(name:String):void {
			
			if (name in registeredBitmapFonts) 
				delete registeredBitmapFonts[name];
			
			TextField.unregisterCompositor(name, true);
		}
		
		private static function addCharsetToHash(name:String, charset:String):void 
		{
			var charsetObject:Object = {};
			fontCharsetsHash[name] = charsetObject;
			
			var i:int;
			var length:int = charset.length;
			for (i = 0; i < length; i++) {
				charsetObject[charset.charAt(i)] = true;
			}
		}
	}
}