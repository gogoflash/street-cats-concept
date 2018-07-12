package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.Fonts;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.disposal.DelayedDisposalUtil;
	import com.alisacasino.bingo.utils.disposal.IDisposable;
	import flash.text.TextFormat;
	import starling.animation.Tween;
	import starling.filters.BlurFilter;
	
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class XTextField extends TextField implements IDisposable
	{
		private var _textStyle:XTextFieldStyle;
		private var mNumValue:Number = 0;
		
		// starling native TextField word wrapping with cutting words. Enable flag for correct wrapping.
		public var autoSizeNativeTextField:Boolean;
		public var nativeTextField:flash.text.TextField;
		
		public function XTextField(width:int, height:int, style:XTextFieldStyle, text:String = "", overrideFontSize:int = 0, autoSizeNativeTextField:Boolean = false)
		{
			Fonts.dynamicCreateBitmapFont(style);
			_textStyle = style;
			var filteredTextFormat:BingoTextFormat = new BingoTextFormat(style.fontName, int((overrideFontSize > 0 ? overrideFontSize : style.fontSize) * pxScale), style.fontColor)
			setFiltersToFormat(style, filteredTextFormat);
			
			super(width, height, text, filteredTextFormat);
			format.bold = style.bold;
			format.horizontalAlign = style.hAlign;
			format.verticalAlign = style.vAlign;
			
			this.autoSizeNativeTextField = autoSizeNativeTextField;
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(e:Event):void
		{
			DelayedDisposalUtil.instance.dispose(this);
			setRequiresRecomposition();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			if (nativeTextField) {
				nativeTextField.embedFonts = true;
				nativeTextField = null;
			}
		}
		
		private function addedToStageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			if (!GameManager.instance.deactivated)
			{
				forceRedraw();
			}
			else 
			{
				Game.addEventListener(Game.ACTIVATED, activatedHandler);
			}
		}
		
		private function activatedHandler(e:Event):void 
		{
			Game.removeEventListener(Game.ACTIVATED, activatedHandler);
			forceRedraw();
		}
		
		private function forceRedraw():void 
		{
			setRequiresRecomposition();
			redraw();
		}
		
		public function get numValue():Number
		{
			return mNumValue;
		}
		
		public function set numValue(newValue:Number):void
		{
			mNumValue = newValue;
			text = String(int(mNumValue));
		}
		
		public function animateToValue(value:uint, duration:Number=1.0, delay:Number = 0.0, onUpdate:Function = null, onUpdateArgs:Array = null):void
		{
			Starling.juggler.tween(this, duration, {
				delay: delay,
				numValue: value,
				onUpdate : onUpdate,
				onUpdateArgs : onUpdateArgs
			});
		}
		
		public function setFiltersToFormat(style:XTextFieldStyle, format:BingoTextFormat):void
		{
			format.nativeFilters = [];
			if (!getBitmapFont(style.fontName)) 
			{
				var filters:Array = [];
				
				if (style.strokeSize > 0) {
					var strokeSize:Number = style.strokeSize*pxScale*layoutHelper.scaleFromEtalon;
					filters.push(new GlowFilter(style.strokeColor,1,4*strokeSize,4*strokeSize,12*strokeSize));
				}
				
				if (style.shadowSize > 0) {
					var k:Number = pxScale * layoutHelper.scaleFromEtalon;
					filters.push(new DropShadowFilter(style.shadowSize * k, style.shadowAngle, style.shadowColor, style.shadowAlpha, style.shadowBlur * k, style.shadowBlur * k, style.shadowStrength * k));
				}
				
				format.nativeFilters = filters;
			}
		}
		
		public function applyAutoSize(type:String):void 
		{
			autoScale = false;
			autoSize = type;
		}
		
		public function get textStyle():XTextFieldStyle
		{
			return _textStyle;
		}
		
		public function set textStyle(value:XTextFieldStyle):void
		{
			if (_textStyle === value)
			{
				return;
			}
			
			_textStyle = value;
			
			format.font = _textStyle.fontName;
			format.size = _textStyle.fontSize * pxScale;
			format.color = _textStyle.fontColor;
			format.bold = _textStyle.bold;
			format.horizontalAlign = _textStyle.hAlign;
			format.verticalAlign = _textStyle.vAlign;
			setFiltersToFormat(_textStyle, format as BingoTextFormat);
			setRequiresRedraw();
		}
		
		public function redraw():void {
			setRequiresRecomposition();
			render(Starling.painter);
		}
		
	}
}