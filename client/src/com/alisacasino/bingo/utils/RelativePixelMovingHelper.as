package com.alisacasino.bingo.utils  {

import com.alisacasino.bingo.controls.XTextField;
import com.alisacasino.bingo.controls.XTextFieldStyle;
import flash.ui.Keyboard;
import starling.display.DisplayObjectContainer;

import starling.display.DisplayObject;
import starling.events.KeyboardEvent;
import starling.text.TextField;

/**
 * User: artem.kolesnikov
 * Date: 14.01.14
 * Descr: гениальный класс
 * вешается на любой дисплей обджект после чего можно его можно двигать и сайзить. (координаты и размер выводятся в трейс);
 * стрелки - двигать; стрелки+ctrl - ресайзить. зажатый шифт увеличивает шаг.
 * кнопка B - включает border у TextField
 * PixelMovingHelper.MovePixelNow(%дисплейобджект%);
 */
public class RelativePixelMovingHelper {

	//private static var x:Number = 0;
	//private static var y:Number = 0;
	private static var scale:Number = 0;
	private static var rotation:Number = 0;
	
	public static function add(displayObject:DisplayObject, coefficientX:Number = 0, coefficientY:Number = 0, startX:Number = 0, startY:Number =0, coefficientScale:Number = 0 ):void 
	{
		if (!displayObject)
			return;
		
		//x = displayObject.x;
		//y = displayObject.y;
		scale = displayObject.scaleX;
		rotation = displayObject.rotation;
		
		if(displayObject is XTextField) 
			trace("fontStyle=[" + XTextFieldStyle.getInfo(XTextField(displayObject).textStyle) + "]");
				
		
		displayObject.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		function onKeyDown(event:KeyboardEvent):void 
		{
			// move
			var mode:Boolean = event.ctrlKey;  // move или resize или смена шрифта
			var rotate:Boolean = event.ctrlKey && event.shiftKey;
			var changeDeep:Boolean = event.ctrlKey && event.altKey;
			
			var speed:Number = event.shiftKey && event.altKey ? 1 : ( event.shiftKey ? 0.1: 0.01 );
						
			if (changeDeep)
			{
				var prnt:DisplayObjectContainer = displayObject.parent;
				var index:int = prnt.getChildIndex(displayObject);
				if (event.keyCode == Keyboard.UP)
				{
					if(index < prnt.numChildren - 1)
						prnt.setChildIndex(displayObject, ++index);
				}
				if (event.keyCode == Keyboard.DOWN) 
				{
					if(index > 0)
						prnt.setChildIndex(displayObject, --index);
				}
			}
			else if (rotate) 
			{
				if(event.keyCode == Keyboard.LEFT) {
					displayObject.rotation -= speed * (Math.PI / 180);
				} else if (event.keyCode == Keyboard.RIGHT) {
					displayObject.rotation += speed * (Math.PI / 180);
				}
			} 
			else 
			{
				//trace((displayObject.x - startX) / coefficientX)
				
				if(!mode && event.keyCode == Keyboard.LEFT) {displayObject.x = startX + ((displayObject.x - startX) / coefficientX - speed) * coefficientX;}
				if(!mode && event.keyCode == Keyboard.RIGHT) {displayObject.x = startX + ((displayObject.x - startX) / coefficientX + speed) * coefficientX;}
				if(!mode && event.keyCode == Keyboard.UP) {displayObject.y = startY + ((displayObject.y - startY) / coefficientY - speed) * coefficientY;}
				if(!mode && event.keyCode == Keyboard.DOWN) {displayObject.y = startY + ((displayObject.y - startY) / coefficientY + speed) * coefficientY;}
								
				if (displayObject is XTextField) 
				{
					// font size
					var style:XTextFieldStyle;
					if(mode && event.keyCode == Keyboard.LEFT) { style = XTextFieldStyle.getNext(XTextField(displayObject).textStyle); }
					if(mode && event.keyCode == Keyboard.RIGHT) { style = XTextFieldStyle.getPrevious(XTextField(displayObject).textStyle); }
					if(mode && event.keyCode == Keyboard.UP) { XTextField(displayObject).format.size++; }
					if(mode && event.keyCode == Keyboard.DOWN) { XTextField(displayObject).format.size--; }
					
					if(style) {
						XTextField(displayObject).textStyle = style;
						XTextField(displayObject).redraw();
						trace("fontStyle=[" + XTextFieldStyle.getInfo(style) + "]" + " fontSize=[" + XTextField(displayObject).format.size + "]");
					}
					else {
						trace("fontStyle=[" + XTextFieldStyle.getInfo(XTextField(displayObject).textStyle) + "]" + " fontSize=[" + XTextField(displayObject).format.size + "]");
					}
				}
				else {
					// resize
					//if(mode && event.keyCode == Keyboard.LEFT ) {displayObject.width -= speed;}
					//if(mode && event.keyCode == Keyboard.RIGHT ) {displayObject.width += speed;}
					if(mode && event.keyCode == Keyboard.UP) {displayObject.scaleX = displayObject.scaleY += speed;}
					if(mode && event.keyCode == Keyboard.DOWN) {displayObject.scaleX = displayObject.scaleY -= speed;}
				}
	            
			}
			
			// show border on text field
			if(event.keyCode == Keyboard.B && displayObject is TextField) {
				(displayObject as TextField).border =!(displayObject as TextField).border;
			}
			
			
			trace(displayObject, "position=[" + ((displayObject.x - startX) / coefficientX) + "," + ((displayObject.y - startY) / coefficientY) + "]", "scale=[" + displayObject.scaleX + "]");
		}
	}
	
	
}
}
