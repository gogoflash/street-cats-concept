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
		private var cycleStartFrame:int;
		private var cycleStarted:Boolean;
		
		public var cycleFps:Number = 0;
		
		private var nextFrameTime:int;
		
		private var cycles:int;
		
		public function FrameAnimator() 
		{
			animations = [];
			animationsByName = {};
			image = new Image(Texture.empty(1,1));
			addChild(image);
		}
		
		public function add(name:String, frames:Vector.<Texture>, fps:Number, shiftX:int = 0, shiftY:int = 0, framesShift:Vector.<Point> = null):void
		{
			if (name in animationsByName) {
				return;
			}
			
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
		
		public function gotoAndPlay(name:String, startFrame:int = 0, invertHorisontal:Boolean = false, cycles:int = -1, fps:Number = 3, endFrame:int = 0, cycleStartFrame:int = 0):void
		{
			if (!(name in animationsByName)) {
				Starling.current.stage.removeEventListener(Event.ENTER_FRAME, handler_enterFrame);
				return;
			}
			
			Starling.current.stage.removeEventListener(Event.ENTER_FRAME, handler_enterFrame);
			
			current = animationsByName[name] as AnimationProperties;	
			this.cycles = cycles;
			this.finishFrame = endFrame;
			this.cycleStartFrame = cycleStartFrame;
			cycleStarted = false;
			
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
			
			cycleStarted = false;
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
				if (currentFrame >= _finishFrame) 
				{
					if (cycleStartFrame > 0/* && cycleStarted*/) {
						
						if (cycleFps != 0) 
							frameTime = Math.max(16, 1000 / cycleFps);
							
						currentFrame = cycleStartFrame;
					}
					else
						currentFrame =  finishFrame;
						
					cycles = Math.max( -1, cycles - 1);
					
					//cycleStarted = true;
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
			animator.add(CatView.STATE_IDLE, getCatTextureSequence(AtlasAsset.LoadingAtlas, 'idle', prefix, 1, 17), 3);
			animator.add(CatView.STATE_HUNGRY, getCatTextureSequence(AtlasAsset.LoadingAtlas, 'hungry', prefix, 1, 9), 3);
			animator.add(CatView.STATE_ANGRY, getCatTextureSequence(AtlasAsset.ScratchCardAtlas, 'angry', prefix, 1, 5), 3);
			animator.add(CatView.STATE_DEFENCE, getCatTextureSequence(AtlasAsset.ScratchCardAtlas, 'hiding', prefix, 1, 3), 3);
			
			
			animator.add(CatView.STATE_WALK, getCatTextureSequence(AtlasAsset.CommonAtlas, 'run', prefix, 1, 4), 3);
			
			animator.add(CatView.STATE_WALK_HARVEST, getCatTextureSequence(AtlasAsset.CommonAtlas, 'run_harvest', prefix, 1, 4), 3);
			
			animator.add(CatView.STATE_HARVEST, getCatTextureSequence(AtlasAsset.CommonAtlas, 'harvest', prefix, 1, 4), 3, 0, 0, new < Point > [getP(0,0), getP(28,15), getP(0,16), getP(0,5)]);
			animator.add(CatView.STATE_HARVEST_STANDOFF, new < Texture > [getCatTexture(AtlasAsset.CommonAtlas, 'harvest', prefix, 1), getCatTexture(AtlasAsset.CommonAtlas, 'harvest', prefix, 5)], 3, 0,0,  new < Point > [new Point(0,0), new Point(-40/**layoutHelper.specialScale*/, -40/**layoutHelper.specialScale*/)]);
			animator.add(CatView.STATE_DAMAGE, getCatTextureSequence(AtlasAsset.CommonAtlas, 'damage', prefix, 1, 3), 3);
			animator.add(CatView.STATE_FIGHT, getCatTextureSequence(AtlasAsset.CommonAtlas, 'fight', prefix, 1, 3), 3);
			animator.add(CatView.STATE_FIGHT_STANDOFF, new < Texture > [getCatTexture(AtlasAsset.CommonAtlas,'idle', prefix, 1), getCatTexture(AtlasAsset.CommonAtlas,'fight', prefix, 4)], 3);
				
			
			animator.add(CatView.STATE_CONFUSE, getCatTextureSequence(AtlasAsset.CommonAtlas, 'confuse', prefix, 1, 2), 3);
			animator.add(CatView.STATE_DEAD, getCatTextureSequence(AtlasAsset.ScratchCardAtlas, 'dead', prefix, 1, 6), 3, 15, 23);
			
			
			return animator;
		}
		
		public static function getStarsAnimator():FrameAnimator
		{
			var animator:FrameAnimator = new FrameAnimator();
			animator.add(CatView.STARS_ANIM, getCatTextureSequence(AtlasAsset.ScratchCardAtlas, 'stars', '', 1, 5), 3);
			return animator;
		}	
			
		public static function getCursorAnimator():FrameAnimator
		{
			var animator:FrameAnimator = new FrameAnimator();
			animator.add(CatView.CURSOR_ANIM, getCatTextureSequence(AtlasAsset.CommonAtlas, 'cursor', '', 1, 6), 3);
			return animator;
		}	
		
		private static function getCatTexture(atlas:AtlasAsset, folder:String, prefix:String, frame:int = 0):Texture {
			var f:String = frame < 10 ? ('0' + frame.toString()) : frame.toString();
			return atlas.getTexture('cats/' + folder + '/' + prefix + f);
		}
		
		private static function getP(x:int, y:int):Point {
			return new Point(x*layoutHelper.specialScale, y*layoutHelper.specialScale);
		}
		
		private static function getCatTextureSequence(atlas:AtlasAsset, folder:String, prefix:String, frameStart:int = 0, frameFinish:int = 0):Vector.<Texture> {
			var frames:Vector.<Texture> = new < Texture > [];
			
			for (var i:int = frameStart; i <= frameFinish; i++) {
				frames.push(getCatTexture(atlas, folder, prefix, i));
			}
			
			return frames;
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
	public var fps:Number = 0 ;
	public var shiftX:int;
	public var shiftY:int;
	
	public function getShiftX(index:int):Number {
		return framesShift ? (shiftX + framesShift[Math.min(framesShift.length-1, index)].x) : shiftX;
	}
	
	public function getShiftY(index:int):Number {
		return framesShift ? (shiftY + framesShift[Math.min(framesShift.length-1, index)].y) : shiftY;
	}
}