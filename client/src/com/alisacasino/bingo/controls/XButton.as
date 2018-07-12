package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import starling.display.ButtonState;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	
	import flash.geom.Rectangle;
	
	import starling.display.Button;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class XButton extends Button
	{
		private static const MAX_DRAG_DIST:Number = 50;
		protected var mTextField:XTextField;
		protected var mDisabledTextField:XTextField;
		private var mIsDown:Boolean = false;
		protected var mStyle:XButtonStyle;
		private var iconImage:Image;
		private var reactTriggerBounds:Rectangle;
		protected var expectedWidth:Number = 0;
		protected var expectedHeight:Number = 0;
		
		protected var _maxDragDist:Number;
		
		private var _text:String;
		private var _disabledText:String;
			
		public function XButton(style:XButtonStyle, text:String="", disabledText:String="")
		{
			super(style.atlas.getTexture(style.upStateTextureName) || Texture.empty(style.emptyTextureWidth, style.emptyTextureHeight));
			
			_maxDragDist = MAX_DRAG_DIST;
			
			setStyle(style, text, disabledText);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		protected function onRemovedFromStage(e:Event):void 
		{
			
		}
		
		public function setStyle(style:XButtonStyle, text:String = '', disabledText:String="", checkIsSameStyle:Boolean = false):void 
		{
			if (checkIsSameStyle && mStyle == style)
				return;
			
			_text = text;
			_disabledText = disabledText == "" ? text : disabledText;
			
			mStyle = style;
			upState = style.atlas.getTexture(style.upStateTextureName, style.emptyTextureWidth, style.emptyTextureHeight);
			downState = style.downStateTextureName ? style.atlas.getTexture(style.downStateTextureName) : null;
			disabledState = style.disabledStateTextureName ? style.atlas.getTexture(style.disabledStateTextureName) : null;
			
			if (disabledState)
				this.alphaWhenDisabled = 1.0;
				
			scale9Grid = style.scale9Rect ? ResizeUtils.getScaledRect(style.scale9Rect.x, style.scale9Rect.y, style.scale9Rect.width, style.scale9Rect.height) : null;
			
			readjustSize();
			
			if (style.width > 0)
				width = style.width * pxScale;
			
			if (style.height > 0)
				height = style.height * pxScale;
	
			var textFieldWidth:Number = style.width > 0 ? style.width * pxScale : upState.width;
			var textFieldHeight:Number = style.height > 0 ? style.height * pxScale : upState.height;	
			
			if (mTextField) {
				mTextField.removeFromParent(true);
				mTextField = null;
			}
			
			if (style.textFieldStyle) {
				mTextField = new XTextField(textFieldWidth, textFieldHeight, style.textFieldStyle, gameManager.deactivated ? '' : _text);
				//mTextField.border = true;
				addChild(mTextField);
			}
			
			if (mDisabledTextField) {
				mDisabledTextField.removeFromParent(true);
				mDisabledTextField = null;
			}
				
			if (style.disabledTextFieldStyle) {
				mDisabledTextField = new XTextField(textFieldWidth, textFieldHeight, style.disabledTextFieldStyle, gameManager.deactivated ? '' : _disabledText);
				addChild(mDisabledTextField);
			}
			
			if (iconImage) {
				iconImage.removeFromParent();
				iconImage = null;
			}
			
			if (style.icon) {
				iconImage = new Image(style.atlas.getTexture(style.icon));
				addChild(iconImage);
			}
			
			if(style.soundAsset)
				addEventListener(Event.TRIGGERED, playButtonSound);
			else
				removeEventListener(Event.TRIGGERED, playButtonSound);
				
			invalidateReposition();
		}
		
		public function addReactDisplayObject(displayObject:DisplayObject):void {
			displayObject.addEventListener(TouchEvent.TOUCH, onReactTouch);
		}
		
		protected function invalidateReposition():void 
		{
			if (GameManager.instance.deactivated) {
				if (!Game.hasEventListener(Game.ACTIVATED, activatedHandler))
					Game.addEventListener(Game.ACTIVATED, activatedHandler);
				return;
			}
			
			reposition();
		}
		
		protected function reposition():void 
		{
			var textFieldWidth:Number;
			var textFieldHeight:Number;	
			
			if (expectedWidth > 0)
				textFieldWidth = expectedWidth;
			else
				textFieldWidth = mStyle.width > 0 ? mStyle.width * pxScale : upState.width;
				
			if (expectedHeight > 0)
				textFieldHeight = expectedHeight;
			else
				textFieldHeight = mStyle.height > 0 ? mStyle.height * pxScale : upState.height;
			
			if (mTextField)
			{
				mTextField.redraw();
				mTextField.alignPivot();
				mTextField.x = textFieldWidth / 2 + (textBounds.width - textFieldWidth)/2;
				
				if (buttonStyle.topAligned)
					mTextField.y = mTextField.height / 2;
				else if (buttonStyle.bottomAligned)
					mTextField.y = textFieldHeight - mTextField.height * 0.35;
				else
					mTextField.y = textFieldHeight / 2;
				
				mTextField.x += buttonStyle.labelXShift * pxScale;
				mTextField.y += buttonStyle.labelYShift * pxScale;
			}
			
			if (mDisabledTextField)
			{
				mDisabledTextField.alignPivot();
				mDisabledTextField.x = textFieldWidth / 2;
				if (buttonStyle.topAligned)
					mDisabledTextField.y = mDisabledTextField.height / 2;
				else if (buttonStyle.bottomAligned)
					mDisabledTextField.y = textFieldHeight - mDisabledTextField.height * 0.35;
				else
					mDisabledTextField.y = textFieldHeight / 2;
				mDisabledTextField.visible = false;
				
				mDisabledTextField.x += buttonStyle.labelXShift * pxScale;
				mDisabledTextField.y += buttonStyle.labelYShift * pxScale;
			}
			
			if (iconImage) {
				iconImage.x = (width/scale - iconImage.width) / 2 + mStyle.iconXShift * pxScale;
				iconImage.y = (height/scale - iconImage.height)/2 + mStyle.iconYShift * pxScale;
			}
		}
		
		private function activatedHandler(e:Event):void 
		{
			Game.removeEventListener(Game.ACTIVATED, activatedHandler);
			if (stage)
			{
				if (mStyle.textFieldStyle)
					mTextField.text = _text;
			
				if (mStyle.disabledTextFieldStyle)
					mDisabledTextField.text = _disabledText;
				
				reposition();
			}
		}
		
		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			if (mDisabledTextField) {
				addChild(mDisabledTextField);
			}
			if (mTextField) {
				addChild(mTextField);
			}
			
			if (iconImage)
				addChild(iconImage);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			
			if (!enabled || touch == null)
				return;
			if (touch.phase == TouchPhase.BEGAN && !mIsDown) 
			{
				scaleOnDown();
				mIsDown = true;
			} else if (touch.phase == TouchPhase.MOVED && mIsDown) {
				var buttonRect:Rectangle = getBounds(stage);
				if (touch.globalX < buttonRect.x - _maxDragDist ||
					touch.globalY < buttonRect.y - _maxDragDist ||
					touch.globalX > buttonRect.x + buttonRect.width + _maxDragDist ||
					touch.globalY > buttonRect.y + buttonRect.height + _maxDragDist)
				{
					resetContents();
				}
			} else if (touch.phase == TouchPhase.ENDED && mIsDown) {
				resetContents();
			}
		}
		
		protected function scaleOnDown():void 
		{
			if (mTextField) {
				mTextField.scaleX = 0.94;
				mTextField.scaleY = 0.94;
			}
			
			if (iconImage)
				iconImage.scale = 0.94;
		}
		
		private function onReactTouch(event:TouchEvent):void
        {
            var touchTarget:DisplayObject = event.currentTarget as DisplayObject;
            var touch:Touch = event.getTouch(touchTarget);
            var isWithinBounds:Boolean;

            if (!enabled)
            {
                return;
            }
            else if (touch == null)
            {
                state = ButtonState.UP;
            }
            else if (touch.phase == TouchPhase.HOVER)
            {
                state = ButtonState.OVER;
            }
            else if (touch.phase == TouchPhase.BEGAN && state != ButtonState.DOWN)
            {
                reactTriggerBounds = touchTarget.getBounds(stage, reactTriggerBounds);
                reactTriggerBounds.inflate(_maxDragDist, _maxDragDist);
                state = ButtonState.DOWN;
            }
            else if (touch.phase == TouchPhase.MOVED)
            {
                isWithinBounds = reactTriggerBounds.contains(touch.globalX, touch.globalY);

                if (state == ButtonState.DOWN && !isWithinBounds)
                    state = ButtonState.UP;
                else if (state == ButtonState.UP && isWithinBounds)
                    state = ButtonState.DOWN;
            }
            else if (touch.phase == TouchPhase.ENDED && state == ButtonState.DOWN)
            {
                state = ButtonState.UP;
                if (!touch.cancelled) 
					dispatchEventWith(Event.TRIGGERED, true);
            }
        }
		
		public function resetContents():void
		{
			mIsDown = false;
			if (mTextField) {
				mTextField.scaleX = 1.0;
				mTextField.scaleY = 1.0;
			}
			
			if (iconImage)
				iconImage.scale = 1.0;
		}
		
		public function resize():void 
		{
			ResizeUtils.resize(this);
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			expectedWidth = value;
			
			if (mStyle.scale9Rect) {
				
				if (mTextField) 
					mTextField.width = width * (mStyle.bottomAligned ? 1.2 : 0.9);
					
				if (mDisabledTextField) 
					mDisabledTextField.width = width * (mStyle.bottomAligned ? 1.2 : 0.9);
			}
			
			invalidateReposition();
		}
		
		public function get textField():XTextField
		{
			return mTextField;
		}
		
		public function get disabledTextField():XTextField
		{
			return mDisabledTextField;
		}
		
		override public function get text():String
		{
			if (mTextField == null) return null;
			return mTextField.text;
		}
		
		override public function set text(value:String):void
		{
			if (!mTextField || mTextField.text == value)
				return;
			
			_text = value;
			
			if (!gameManager.deactivated)  
				mTextField.text = value;			
			
			invalidateReposition();
		}
		
		public function get disabledText():String
		{
			if (mDisabledTextField == null) return null;
			return mDisabledTextField.text;
		}
		
		public function set disabledText(value:String):void
		{
			if (mDisabledTextField == null) 
				return;
			
			_disabledText = value;	
				
			if (!gameManager.deactivated)  
				mDisabledTextField.text = value;
			
			invalidateReposition();	
		}
		
		public function get buttonStyle():XButtonStyle
		{
			return mStyle;
		}
		
		override public function get enabled():Boolean
		{
			return super.enabled;
		}
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			if (mTextField && mDisabledTextField) {
				mTextField.visible = value;
				mDisabledTextField.visible = !value;
			}
			/*if (disabledState) {
				super.upState = value ? upState : disabledState;
			}*/
			
		}
		
		private function playButtonSound(e:Event):void
		{
			SoundManager.instance.playSfx(mStyle.soundAsset, 0, 0, mStyle.soundVolume, 0, true);
		}
		
		public function get maxDragDist():Number
		{
			return _maxDragDist;
		}
		
		public function set maxDragDist(value:Number):void
		{
			_maxDragDist = value;
		}
	}
}