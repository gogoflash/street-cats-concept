package com.alisacasino.bingo.utils
{
	import feathers.controls.Button;
	
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class JumpWithHintHelper
	{
		private var _owner:DisplayObject;
		
		private var _doJump: Boolean;
		private var _doClick: Boolean;
		
		private var _enabled:Boolean;
		
		private var _isPressed: Boolean;
		
		private var _isEnded: Boolean;
		
		private var _isRolledOver: Boolean;
		
		private var isRolledOverOnce: Boolean;
		
		private var tween:Tween = new Tween(null, 1);
		
		private var timeoutId:int = -1;
		
		public var showDelay:uint;
		
		private var _minScaleX:Number = 0.97;
		private var _minScaleY:Number = 0.97;
		
		private var _maxScaleX:Number = 1.03;
		private var _maxScaleY:Number = 1.03;
		
		public var scale:Number = 1;
		
		public var mouseUpIfOutOfBounds:Boolean = true;
		
		private var uncenteredJump:Boolean;
		private var _pivotX:int;
		private var _pivotY:int;
		private var _ownerX:Number;
		private var _ownerY:Number;
		
		private var onMouseDownCallback:Function;
		private var onMouseUpCallback:Function;
		private var onTriggeredCallback:Function;
		
		public function JumpWithHintHelper(owner:DisplayObject, doJump:Boolean=false, doClick:Boolean=false)
		{
			_owner = owner;
			_doJump = doJump;
			_doClick = doClick;
			
			_owner.addEventListener(TouchEvent.TOUCH, handler_touch);
			_owner.addEventListener(Event.REMOVED_FROM_STAGE, handler_removedFromStage);
			_enabled = true;
		}
		
		public function setUncenteredJump(ownerX:Number, ownerY:Number, pivotX:int, pivotY:int):void
		{
			uncenteredJump = true;
			_ownerX = ownerX;
			_ownerY = ownerY;
			_pivotX = pivotX;
			_pivotY = pivotY;
		}
		
		public function setStateCallbacks(onMouseDownCallback:Function, onMouseUpCallback:Function = null, onTriggeredCallback:Function = null):void
		{
			this.onMouseDownCallback = onMouseDownCallback;
			this.onMouseUpCallback = onMouseUpCallback;
			this.onTriggeredCallback = onTriggeredCallback;
		}
		
		public function dispose():void
		{
			if ( !_owner ) 
				return;
			_owner.removeEventListener(TouchEvent.TOUCH, handler_touch);
			_owner.removeEventListener(Event.REMOVED_FROM_STAGE, handler_removedFromStage);
			_showHintCallback = null;
			_owner = null;
		}
		
		public function set minScale(value:Number):void
		{
			_minScaleX = value;
			_minScaleY = value;
		}
		
		public function get minScale():Number
		{
			return (_minScaleX + _minScaleY)/2;
		}
		
		public function set maxScale(value:Number):void
		{
			_maxScaleX = value;
			_maxScaleY = value;
		}
		
		public function get maxScale():Number
		{
			return (_maxScaleX + _maxScaleY)/2;
		}
		
		public function set minScaleX(value:Number):void
		{
			_minScaleX = value;
		}
		
		public function set maxScaleX(value:Number):void
		{
			_maxScaleX = value;
		}
		
		public function set minScaleY(value:Number):void
		{
			_minScaleY = value;
		}
		
		public function set maxScaleY(value:Number):void
		{
			_maxScaleY = value;
		}
		
		public function get minScaleX():Number
		{
			return _minScaleX;
		}
		
		public function get minScaleY():Number
		{
			return _minScaleY;
		}
		
		//-------------------------------------------------------------------------
		//
		//  Properties
		//
		//-------------------------------------------------------------------------
		
		public var hintClass:Class;
		
		private var _hintEvent:HintEvent;
		
		private var _hintData:Object;
		
		public function get hintData():Object
		{
			return _hintData;
		}
		
		public function set hintData(value:Object):void
		{
			if(isRolledOverOnce && hintData != value)
				_owner.dispatchEvent(new HintEvent(HintEvent.TYPE_CHANGE, value));
				
			_hintData = value;
			_hintEvent = _hintData ? (new HintEvent(0, _hintData)) : null;
		}
		
		private var _disabledHintEvent:HintEvent;
		
		private var _disabledHintData:Object;
		
		public function get disabledHintData():Object {
			return _disabledHintData;
		}
		
		public function set disabledHintData(value:Object):void 
		{
			_disabledHintData = value;
			_disabledHintEvent = _disabledHintData ? (new HintEvent(0, _disabledHintData)) : null;
		}
		
		private function get hintEvent():HintEvent
		{
			/*if (_owner is Button)
				return Button(_owner).isEnabled ? _hintEvent : _disabledHintEvent;
			else*/
				return _hintEvent;
		}
		
		//-------------------------------------------------------------------------
		//
		// 
		//
		//-------------------------------------------------------------------------
		
		private var _showHintCallback:Function;
		
		public function get showHintCallback():Function
		{
			return _showHintCallback;
		}
		
		public function set showHintCallback(value:Function):void
		{
			_showHintCallback = value;
		}
		
		
		public function get doClick():Boolean
		{
			return _doClick;
		}
		
		public function set doClick(value:Boolean):void
		{
			if(_doClick == value)
				return;
			_doClick = value;
		}
		
		public function get doJump():Boolean
		{
			return _doJump;
		}
		
		public function set doJump(value:Boolean):void
		{
			if(_doJump == value)
				return;
			_doJump = value;
		}
		
		public function showJump():void
		{
			onRollOverAnimation();
		}
		
		//-------------------------------------------------------------------------
		//
		//  
		//
		//-------------------------------------------------------------------------
		
		private function handler_touch(event:TouchEvent): void 
		{
			if (!_enabled)
				return;
			
			const touch:Touch = event.getTouch(_owner);
			if (touch) 
			{
				switch (touch.phase) 
				{
					case TouchPhase.HOVER: 
					{
						// roll over
						if (_isRolledOver) 
							return;
						
						if(_isEnded)
						{
							_isEnded = false;
							return;
						}
						
						_isRolledOver = true;
						isRolledOverOnce = true;
						onRollOver();
						break;
					}
					case TouchPhase.BEGAN: 
					{
						// press
						if (_isPressed) 
							return;
						
						_isEnded = false;
						_isPressed = true;
						onMouseDown();
						break;
					}
					case TouchPhase.ENDED: 
					{
						// click
						
						if (_isPressed && onTriggeredCallback != null) 
							onTriggeredCallback();
						
						_isEnded = true;
						_isPressed = false;
						_isRolledOver = false;
						isRolledOut();
						
						break;
					}
					case TouchPhase.MOVED: 
					{
						_isEnded = false;
						
						if(outOfBounds) {
							_isPressed = false;
							_isRolledOver = false;
							onRollOut();
						} 
						
						break;
					}
						
					default : 
					{
						break;
					}
				}
			} 
			else {
				_isRolledOver = false;
				onRollOut();
			}
		}
		
		private function isRolledOut():void 
		{
			dispatchEndHint();
			if(outOfBounds) 
			{
				_isRolledOver = false;
				onRollOut();
			}
			else
			{
				if(mouseUpIfOutOfBounds)
					onMouseUp();
			}
		}
		
		public function get outOfBounds():Boolean 
		{
			const stage: Stage = Starling.current.nativeStage;
			const mouseX: Number = stage.mouseX;
			const mouseY: Number = stage.mouseY;
			const bounds: Rectangle = _owner.getBounds(_owner);
			const point: Point = _owner.localToGlobal(new Point());
			if (mouseX > point.x &&
				mouseX < point.x + bounds.width &&
				mouseY > point.y &&
				mouseY < point.y + bounds.height) {
				
				return false;
			}
			
			return true;
		}
		
		private function dispatchHint():void {
			if ( !hintEvent ) 
				return;
			
			hintEvent.eventType = HintEvent.TYPE_START;
			hintEvent.hintClass = hintClass;
			_owner.dispatchEvent(hintEvent);
		}
		
		private function dispatchEndHint():void 
		{
			if ( !hintEvent ) 
				return;
			
			if(showDelay > 0) {
				if(timeoutId != -1) {
					clearTimeout(timeoutId);
					timeoutId = -1;
				}
			}
			hintEvent.eventType = HintEvent.TYPE_END;
			_owner.dispatchEvent(hintEvent);
		}
		
		//-------------------------------------------------------------------------
		//
		// 
		//
		//-------------------------------------------------------------------------
		
		private function onRollOut():void {
//			_owner.dispatchEvent(new Event(MouseEvent.ROLL_OUT, true));
			onMouseUp();
			dispatchEndHint();
		}
		
		private function onRollOver():void {
//			dispatchEvent(new Event(MouseEvent.ROLL_OVER, true));
			onRollOverAnimation();
			if(showDelay > 0) {
				timeoutId = setTimeout(dispatchHint, showDelay);
				return;
			}
			dispatchHint();
		}
		
		private function onMouseDown():void 
		{
			onMouseDownAnimation();
		}
		
		private function onMouseUp():void 
		{
			onMouseUpAnimation();
		}
		
		//-------------------------------------------------------------------------
		//
		//  animations
		//
		//-------------------------------------------------------------------------
		
		private function onMouseDownAnimation():void {
			if ( !_doClick ) 
				return;
			
			if(!tween.isComplete)
				Starling.juggler.remove(tween);
			
			tween.reset(_owner, 0.1, Transitions.EASE_OUT);
			tween.animate('scaleX', scale * _minScaleX);
			tween.animate('scaleY', scale * _minScaleY);
			if (uncenteredJump) 
				tween.moveTo(_ownerX + _pivotX * (scale - _minScaleX*scale), _ownerY + _pivotY * (scale - _minScaleY*scale));
			Starling.juggler.add(tween);	
			
			if (onMouseDownCallback != null)
				onMouseDownCallback();
		}
		
		private function onMouseUpAnimation():void {
			if ( !_doClick ) 
				return;
			
			if(tween && !tween.isComplete)
				Starling.juggler.remove(tween);
			
			tween.reset(_owner, 0.7, Transitions.EASE_OUT_ELASTIC);
			tween.scaleTo(scale);
			if (uncenteredJump) 
				tween.moveTo(_ownerX, _ownerY);
			Starling.juggler.add(tween);
			
			if (onMouseUpCallback != null)
				onMouseUpCallback();
		}
		
		private function onRollOverAnimation():void {
			if ( !_doJump ) 
				return;
			
			if(tween && !tween.isComplete)
				Starling.juggler.remove(tween);
			
			tween = new Tween(_owner, 0.1, Transitions.EASE_OUT);
			tween.animate('scaleX', scale * _maxScaleX);
			tween.animate('scaleY', scale * _maxScaleY);
			if (uncenteredJump) 
				tween.moveTo(_ownerX - _pivotX * (_maxScaleX*scale - scale), _ownerY - _pivotY * (_maxScaleY*scale - scale));
			
			tween.onComplete = completeRollOverAnimation;
			Starling.juggler.add(tween);
		}
		
		private function completeRollOverAnimation():void {
			tween = new Tween(_owner, 0.7, Transitions.EASE_OUT_ELASTIC);
			tween.scaleTo(scale);
			if (uncenteredJump) 
				tween.moveTo(_ownerX, _ownerY);
			Starling.juggler.add(tween);
		}
		
		private function handler_removedFromStage(event:Event):void 
		{
			onRollOut();			
			_isRolledOver = false;
		}	
		
		public function setEnabled(value:Boolean, setOwnerToBase:Boolean = false):void 
		{
			if (_enabled == value)
				return;
			
			_enabled = value;
				
			if (!_enabled)
			{
				if(tween && !tween.isComplete)
					Starling.juggler.remove(tween);
			
				_isPressed = false;
				_isRolledOver = false;	
					
				if (setOwnerToBase) 
				{
					_owner.scale = scale;
					if (uncenteredJump) {
						_owner.x = _ownerX;
						_owner.y = _ownerY;
					}
				}
			}
		}
		
	}
}
import starling.events.Event;

// stub
class HintEvent extends Event {
	public static const TYPE_START:int = 0;
	public static const TYPE_END:int = 1;
	public static const TYPE_CHANGE:int = 2;
	
	public var eventType:int;
	public var hintClass:Class;
			
	public function HintEvent(type:int, data:Object) {
		super('HintEvent', data, true);
		eventType = type;
	}
}