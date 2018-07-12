package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.utils.GameManager;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.textures.Texture;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Ball
	{
		private var mGameAtlas:AtlasAsset = AtlasAsset.CommonAtlas;
		public var ballImage:Image;
		public var label:XTextField;
		private var mNumber:uint;
		
		private var labelStartX:Number = 0;
		private var shadowStartX:Number = 0;
		private var _x:Number = 0;
		private var _alpha:Number = 1;
		
		
		public function Ball(number:uint)
		{
			mNumber = number;
			init();
		}	
		
		private static const TEXTURE_NAMES:Array = [
			"balls/b",
			"balls/i",
			"balls/n",
			"balls/g",
			"balls/o",
		];
		
		private function init():void
		{
			var textureIndex:uint = (mNumber - 1) / 15;
			ballImage = new Image(mGameAtlas.getTexture(TEXTURE_NAMES[textureIndex]) || Texture.empty(1, 1));
			ballImage.alignPivot();
			ballImage.alpha = alpha;
			
			label = new XTextField(100*pxScale, 80*pxScale, XTextFieldStyle.BallTextFieldStyle, String(mNumber));
			label.alignPivot();
			label.alpha = alpha;
			label.batchable = true;
			//label.border = true;
			
			//Label is rendered when trying to read width. This causes errors on iOS when executing in background.
			positionLabel();
		}
		
		private function positionLabel():void 
		{
			if (GameManager.instance.deactivated)
				Game.addEventListener(Game.ACTIVATED, activatedHandler);
			
			label.x = x + ballImage.pivotX - 6 * pxScale * scaleX// + 25 * pxScale * scale// + label.pivotX;
			label.y = y + ballImage.pivotY + 5 * pxScale * scaleY; // + 47 * pxScale * scale// + label.pivotY;
			//label.scale = scale;
			label.scaleX = scaleX;
			label.scaleY = scaleY;
			
			label.redraw();
		}
		
		private function activatedHandler(e:Event):void 
		{
			Game.removeEventListener(Game.ACTIVATED, activatedHandler);
			positionLabel();
		}
		
		public function set x(value:Number):void {
			_x = value;
			ballImage.x = ballImage.pivotX + value;
			positionLabel();
		}
		
		public function get x():Number {
			return _x;
		}
		
		private var _y:Number = 0;
		
		public function get y():Number 
		{
			return _y;
		}
		
		public function set y(value:Number):void 
		{
			_y = value;
			ballImage.y = ballImage.pivotY + _y;
			positionLabel();
		}
		
		public function set alpha(value:Number):void {
			_alpha = value;
			ballImage.alpha = value;
			label.alpha = value;
		}
		
		public function get alpha():Number {
			return _alpha;
		}
		
		private var _scale:Number = 1;
		
		public function get scale():Number 
		{
			return _scale;
		}
		
		public function set scale(value:Number):void 
		{
			_scale = value;
			_scaleX = value;
			_scaleY = value;
			ballImage.scale = value;
			positionLabel();
		}
		
		private var _scaleX:Number = 1;
		
		public function get scaleX():Number 
		{
			return _scaleX;
		}
		
		public function set scaleX(value:Number):void 
		{
			_scaleX = value;
			ballImage.scaleX = value;
			positionLabel();
		}
		
		private var _scaleY:Number = 1;
		
		public function get scaleY():Number 
		{
			return _scaleY;
		}
		
		public function set scaleY(value:Number):void 
		{
			_scaleY = value;
			ballImage.scaleY = value;
			positionLabel();
		}
		
		public function removeChildren():void 
		{
			ballImage.removeFromParent();
			label.removeFromParent();
		}
		
		public function labelAlphaTween():void 
		{
			label.alpha = 0;
			Starling.juggler.tween(label, 0.15, {alpha:1, delay:0.15 , transition: Transitions.EASE_IN});
			
			/*var tween_0:Tween = new Tween(label, 0.05, Transitions.LINEAR);
			var tween_1:Tween = new Tween(label, 0.15, Transitions.EASE_OUT);
			
			tween_0.animate('alpha', 0);
			tween_0.nextTween = tween_1;
			
			tween_1.delay = 0.1;
			tween_1.animate('alpha', 1);
			
			Starling.juggler.add(tween_0);*/
		}
	}
}