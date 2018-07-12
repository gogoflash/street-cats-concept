package  
{
	import avmplus.getQualifiedClassName;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Stage;
	import starling.events.TouchEvent;
	/**
	 * ...
	 * @author 
	 */
	public class ViewClassExplorer 
	{
		static private var _previousSX:Number;
		static private var _previousSY:Number;
		
		static private var _active:Boolean;
		
		static public function get isActive():Boolean {	return _active;	}
		static public function changeState():void
		{
			if (_active)
				deactivate();
			else
				activate();
		}
		
		static public function activate():void
		{
			_active = true;
			Starling.current.nativeStage.addEventListener(Event.ENTER_FRAME, handler_mm);
		}
		
		static public function deactivate():void
		{
			_active = false;
			Starling.current.nativeStage.removeEventListener(Event.ENTER_FRAME, handler_mm);
		}
		
		static private function handler_mm(e:Event):void 
		{
			var sx:Number = Starling.current.nativeStage.mouseX;
			var sy:Number = Starling.current.nativeStage.mouseY;
			
			if (sx == _previousSX && sy == _previousSY)
				return;
			_previousSX = sx;
			_previousSY = sy;
			
			var sstage:Stage = Starling.current.stage;
			var sviewport:Rectangle = Starling.current.viewPort;
			
			var globalX:Number = sstage.stageWidth  * (sx - sviewport.x) / sviewport.width;
            var globalY:Number = sstage.stageHeight * (sy - sviewport.y) / sviewport.height;
			
			var o:DisplayObject = sstage.hitTest(new Point(globalX, globalY));
			var indent:int = 1;
			var s:String;
			while (o)
			{
				s = "";
				for (var i:int = 0; i < indent; i++)
					s += "  ";
				
				trace(s, getQualifiedClassName(o), o);
				o = o.parent;
				indent++;
			}
		}
	}

}