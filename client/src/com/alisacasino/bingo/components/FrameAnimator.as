package com.alisacasino.bingo.components 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.screens.gameScreenClasses.CatView;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.textures.Texture;
	
	public class FrameAnimator extends Sprite
	{
		private var animations:Array;
		private var animationsByName:Object;
		private var image:Image;
		
		private var current:AnimationProperties;
		
		private var isPlaying:Boolean;
		
		private var frameTime:int;
		private var currentFrame:int;
		private var finishFrame:int;
		
		private var nextFrameTime:int;
		
		private var cycles:int;
		
		public function FrameAnimator() 
		{
			animations = [];
			animationsByName = {};
			image = new Image(Texture.empty(1,1));
			addChild(image);
		}
		
		public function add(name:String, frames:Vector.<Texture>, fps:int, shiftX:int = 0, shiftY:int = 0, framesShift:Vector.<Point> = null):void
		{
			var prop:AnimationProperties = new AnimationProperties();
			prop.name = name;
			prop.fps = fps;
			prop.frames = frames;
			prop.shiftX = shiftX;
			prop.shiftY = shiftY;
			prop.framesShift = framesShift;
			animations.push(prop);
			
			animationsByName[name] = prop;
		}
		
		public function gotoAndPlay(name:String, startFrame:int = 0, invertHorisontal:Boolean = false, cycles:int = -1, fps:Number = 3, endFrame:int = 0):void
		{
			if (!(name in animationsByName)) {
				Starling.current.stage.removeEventListener(Event.ENTER_FRAME, handler_enterFrame);
				return;
			}
			
			Starling.current.stage.removeEventListener(Event.ENTER_FRAME, handler_enterFrame);
			
			current = animationsByName[name] as AnimationProperties;	
			this.cycles = cycles;
			this.finishFrame = endFrame;
			
			var scaleXCoeff:int = invertHorisontal ? -1:1;
			
			currentFrame = startFrame;
			
			image.scaleX = scaleXCoeff;
			
			alignFrame();
			
			isPlaying = cycles == -1 || cycles > 0 || (endFrame > startFrame && endFrame != 0);
			
			frameTime = Math.max(16, 1000 / fps);
			
			nextFrameTime = getTimer() + frameTime;
			
			if (isPlaying)
				Starling.current.stage.addEventListener(Event.ENTER_FRAME, handler_enterFrame);
			else
				Starling.current.stage.removeEventListener(Event.ENTER_FRAME, handler_enterFrame);
		}
		
		public function gotoAndStop(name:String, frame:int = 0):void
		{
			if (!(name in animationsByName)) {
				return;
			}
			Starling.current.stage.removeEventListener(Event.ENTER_FRAME, handler_enterFrame);
			alignFrame();
		}
		
		private function alignFrame():void
		{
			var scaleXCoeff:int = image.scaleX < 0 ? -1:1;
		
			image.texture = current.frames[Math.min(current.frames.length-1, currentFrame)];
			image.readjustSize();
			image.x = scaleXCoeff * current.getShiftX(currentFrame);
			image.y = current.getShiftY(currentFrame);
			image.alignPivot();
		}
		
		private function handler_enterFrame(e:Event):void
		{
			if (getTimer() >= nextFrameTime) 
			{
				currentFrame++;
				var _finishFrame:int = finishFrame == 0 ? current.frames.length : Math.min(finishFrame + 1, current.frames.length);
				if (currentFrame >= _finishFrame) {
					currentFrame = finishFrame;
					cycles = Math.max(-1, cycles - 1);
				}
				
				alignFrame();
				
				if (cycles == 0)
				{
					Starling.current.stage.removeEventListener(Event.ENTER_FRAME, handler_enterFrame);
				}
				else
				{
					nextFrameTime = getTimer() + frameTime;
				}
				
			}
		}
		
		private function nextFrame():void {
			
		}
		
		public function clean():void 
		{
			Starling.current.stage.removeEventListener(Event.ENTER_FRAME, handler_enterFrame);
		}
		
		public static function getCatAnimator(index:int):FrameAnimator
		{
			var prefix:String = index == 0 ? 'blue_' : 'red_';
			
			
			var animator:FrameAnimator = new FrameAnimator();
			animator.add(CatView.STATE_IDLE, new <Texture> [getCatTexture('idle', prefix, 1)], 3);
			animator.add(CatView.STATE_WALK, new < Texture > [getCatTexture('run', prefix, 1), getCatTexture('run', prefix, 2), getCatTexture('run', prefix, 3), getCatTexture('run', prefix, 4)], 3);
			
			animator.add(CatView.STATE_WALK_HARVEST, new < Texture > [getCatTexture('run_harvest', prefix, 1), getCatTexture('run_harvest', prefix, 2), getCatTexture('run_harvest', prefix, 3), getCatTexture('run_harvest', prefix, 4)], 3);
			
			animator.add(CatView.STATE_HARVEST, new < Texture > [getCatTexture('harvest', prefix, 1), getCatTexture('harvest', prefix, 2), getCatTexture('harvest', prefix, 3), getCatTexture('harvest', prefix, 4)], 3, 0, 0, new < Point > [getP(0,0), getP(28,15), getP(0,16), getP(0,5)]);
			animator.add(CatView.STATE_HARVEST_STANDOFF, new < Texture > [getCatTexture('harvest', prefix, 1), getCatTexture('harvest', prefix, 5)], 3, 0,0,  new < Point > [new Point(0,0), new Point(-40*layoutHelper.specialScale, -40*layoutHelper.specialScale)]);
			animator.add(CatView.STATE_DAMAGE, new < Texture > [getCatTexture('damage', prefix, 1), getCatTexture('damage', prefix, 2), getCatTexture('damage', prefix, 3), getCatTexture('damage', prefix, 4)], 3);
			animator.add(CatView.STATE_FIGHT, new < Texture > [getCatTexture('idle', prefix, 1), getCatTexture('fight', prefix, 1), getCatTexture('fight', prefix, 2), getCatTexture('fight', prefix, 3)], 3);
			animator.add(CatView.STATE_FIGHT_STANDOFF, new <Texture> [getCatTexture('fight', prefix, 4)], 3);
			
			return animator;
		}
		
		private static function getCatTexture(folder:String, prefix:String, frame:int = 0):Texture {
			return AtlasAsset.CommonAtlas.getTexture('cats/' + folder + '/' + prefix + '0' + frame.toString());
		}
		
		private static function getP(x:int, y:int):Point {
			return new Point(x*layoutHelper.specialScale, y*layoutHelper.specialScale);
		}
	}
}
import flash.geom.Point;
import starling.textures.Texture;

class AnimationProperties 
{
	public var frames:Vector.<Texture>;
	public var framesShift:Vector.<Point>;
	public var name:String;
	public var fps:int;
	public var shiftX:int;
	public var shiftY:int;
	
	public function getShiftX(index:int):Number {
		return framesShift ? (shiftX + framesShift[Math.min(framesShift.length-1, index)].x) : shiftX;
	}
	
	public function getShiftY(index:int):Number {
		return framesShift ? (shiftY + framesShift[Math.min(framesShift.length-1, index)].y) : shiftY;
	}
}