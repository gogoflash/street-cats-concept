package  {

import flash.ui.Keyboard;
import starling.display.DisplayObjectContainer;

import starling.display.DisplayObject;
import starling.events.KeyboardEvent;
import starling.text.TextField;

public class ViewPositionUtil{

	public static function movePixelNow(displayObject:DisplayObject):void {
		if (!CONFIG::debug) 
			return;
		
		displayObject.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		function onKeyDown(event:KeyboardEvent):void {
			// move
			var mode:Boolean = event.ctrlKey;  // move или resize
			var rotate:Boolean = event.ctrlKey && event.shiftKey;
			var changeDeep:Boolean = event.ctrlKey && event.altKey;
			var speed:int = event.shiftKey ? 10: 1;
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
			else if (rotate) {
				if(event.keyCode == Keyboard.LEFT) {
					displayObject.rotation -= speed * (Math.PI / 180);
				} else if (event.keyCode == Keyboard.RIGHT) {
					displayObject.rotation += speed * (Math.PI / 180);
				}
			} else {
				if(!mode && event.keyCode == Keyboard.LEFT) {displayObject.x-=speed * pxScale;}
				if(!mode && event.keyCode == Keyboard.RIGHT) {displayObject.x+=speed * pxScale;}
				if(!mode && event.keyCode == Keyboard.UP) {displayObject.y-=speed * pxScale;}
				if(!mode && event.keyCode == Keyboard.DOWN) {displayObject.y+=speed * pxScale;}
				// resize
	            if(mode && event.keyCode == Keyboard.LEFT ) {displayObject.width -= speed * pxScale;}
	            if(mode && event.keyCode == Keyboard.RIGHT ) {displayObject.width += speed * pxScale;}
	            if(mode && event.keyCode == Keyboard.UP) {displayObject.height-=speed * pxScale;}
	            if(mode && event.keyCode == Keyboard.DOWN) {displayObject.height+=speed * pxScale;}
			}
			
			// font size
			/*if(displayObject is TextField) {
				if(event.keyCode == Keyboard.NUMPAD_ADD) {TextField(displayObject).fontSize+=speed;}
				if(event.keyCode == Keyboard.NUMPAD_SUBTRACT) {TextField(displayObject).fontSize-=speed;}
				trace("fontSize=["+TextField(displayObject).fontSize+"]");
			}
			// show border on text field
			if(event.keyCode == Keyboard.B && displayObject is TextField) {
				(displayObject as TextField).border =!(displayObject as TextField).border;
			}*/
			trace(displayObject, "position=["+displayObject.x / pxScale +"," + displayObject.y / pxScale +"]"/*, "size=["+displayObject.width+","+displayObject.height+"]"*/);
            //sosTrace("position=["+displayObject.x+","+displayObject.y+"]", "size=["+displayObject.width+","+displayObject.height+"]");
		}
	}
}
}
