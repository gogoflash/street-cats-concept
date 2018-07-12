package com.alisacasino.bingo.dialogs.scratchCard 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.dialogs.scratchCard.helperClasses.GeometricHelper;
	import com.alisacasino.bingo.dialogs.scratchCard.helperClasses.GeometricScratchCalculator;
	import com.alisacasino.bingo.dialogs.scratchCard.helperClasses.ScratchHelper;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import feathers.core.FeathersControl;
	import flash.geom.Point;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	import starling.utils.TweenHelper;
	import treefortress.sound.SoundInstance;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ScratchLayer extends FeathersControl
	{
		private const SCRATCH_SOUND_VOLUME:Number = 0.55;
		
		static public const FINISHED:String = "finished";
		
		static private const TOUCHING_IN_BOUNDS:String = "touchingInBound";
		static private const TOUCHING_OUT_OF_BOUNDS:String = "touchingOutOfBounds";
		static private const NOT_TOUCHING:String = "notTouching";
		
		private var autoDraw:Boolean;
		
		private var _currentState:String;
		
		public function get currentState():String 
		{
			return _currentState;
		}
		
		public function set currentState(value:String):void 
		{
			if (!dispatchedFirstTouch && value == TOUCHING_IN_BOUNDS)
			{
				dispatchEventWith(Event.TRIGGERED);
				dispatchedFirstTouch = true;
			}
			_currentState = value;
		}
		
		private var scratchHelper:ScratchHelper;
		private var _scratchLayerTexture:Texture;
		private var scratchLayerImage:Image;
		private var touchLocation:Point;
		private var touchPointID:int = -1;
		private var scratchTexture:RenderTexture;
		private var geomCalc:GeometricScratchCalculator;
		private var sourceScratchLayerImage:Image;
		private var soundPlaying:Boolean;
		private var touchPadding:Number;
		
		private var dispatchedFinish:Boolean;
		private var dispatchedFirstTouch:Boolean;
		private var autoDrawXY:AutoDrawXY;
		
		public function ScratchLayer(scratchLayerTexture:Texture) 
		{
			_scratchLayerTexture = scratchLayerTexture;
			touchPadding = 30 * pxScale;
			autoDrawXY = new AutoDrawXY();
		}
		
		public function set scratchLayerTexture(value:Texture):void
		{
			if (_scratchLayerTexture == value)
				return;
				
			_scratchLayerTexture = value;	
			
			sourceScratchLayerImage.texture = _scratchLayerTexture;
			sourceScratchLayerImage.readjustSize();
			
			width = scratchLayerTexture.width;
			height = scratchLayerTexture.height;
			
			//reset();
			
			redrawScratchLayer();
		}
		
		public function get scratchLayerTexture():Texture
		{
			return _scratchLayerTexture;
		}		
		
		public function reset():void
		{
			if(scratchTexture)
				scratchTexture.draw(sourceScratchLayerImage);
			
			dispatchedFirstTouch = false;
			dispatchedFinish = false;
			geomCalc.reset();
			
			stopSound();
		}
		
		private function getScratchSound():SoundInstance
		{
			return SoundAsset.SfxScratchCardScratch.instance;
		}
		
		
		override protected function initialize():void 
		{
			//TODO: handle activate/deactivate
			
			super.initialize();
			
			scratchHelper = new ScratchHelper(pxScale);
			
			touchLocation = new Point();
			
			sourceScratchLayerImage = new Image(scratchLayerTexture);
			//sourceScratchLayerImage.blendMode = BlendMode.NONE;
			
			width = scratchLayerTexture.width;
			height = scratchLayerTexture.height;
			
			geomCalc = new GeometricScratchCalculator(pxScale, scratchLayerTexture.width, scratchLayerTexture.height);
			
			scratchTexture = new RenderTexture(scratchLayerTexture.width, scratchLayerTexture.height, true);
			
			scratchTexture.draw(sourceScratchLayerImage);
			
			var geomHelper:GeometricHelper = new GeometricHelper(geomCalc);
			geomHelper.alpha = 0.1;
			
			scratchLayerImage = new Image(scratchTexture);
			addChild(scratchLayerImage);
			
			Starling.current.addEventListener(Event.CONTEXT3D_CREATE, starling_context3dCreateHandler);
			
			stage.addEventListener(TouchEvent.TOUCH, touchHandler);
		}
		
		private function starling_context3dCreateHandler(e:Event):void 
		{
			redrawScratchLayer();
		}
		
		private function redrawScratchLayer():void 
		{
			scratchTexture = new RenderTexture(scratchLayerTexture.width, scratchLayerTexture.height, true);
			scratchLayerImage.texture = scratchTexture;
			reset();
		}
		
		private function updateDraw():void 
		{
			if (!isEnabled)
			{
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				updateSound(false);
				return;
			}
			
			var needToPlaySound:Boolean;
			
			if (currentState == NOT_TOUCHING)
			{
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
			else
			{
				var distance:Number = geomCalc.track(touchLocation.x, touchLocation.y);
				scratchHelper.drawAtMouse(scratchTexture, touchLocation.x, touchLocation.y);
				
				if (currentState == TOUCHING_IN_BOUNDS)
				{
					var distanceSufficient:Boolean = distance > 5 * pxScale;
					needToPlaySound = distanceSufficient;
				}
				else
				{
					needToPlaySound = false;
				}
			}
			
			updateSound(needToPlaySound);
			
			if (geomCalc.checkAllHits() && !dispatchedFinish)
			{
				dispatchEventWith(FINISHED);
				dispatchedFinish = true;
			}
		}
		
		public function stopSound():void 
		{
			
			var sound:SoundInstance = getScratchSound();
			if (sound && sound.isPlaying)
			{
				sound.stop();
			}
			
		}
		
		private function updateSound(needToPlaySound:Boolean):void 
		{
			
			var sound:SoundInstance = getScratchSound();
			if (!sound)
				return;
			
			if (needToPlaySound)
			{
				if (!soundPlaying)
				{
					if (SoundManager.instance.canPlaySfx)
					{
						if (sound.isPlaying)
						{
							sound.fadeTo(SCRATCH_SOUND_VOLUME*SoundManager.SOUNDS_VOLUME, 100);
						}
						else
						{
							sound.play(SCRATCH_SOUND_VOLUME*SoundManager.SOUNDS_VOLUME, 0, -1, false);
						}
						soundPlaying = true;
					}
					else
					{
						stopSound();
					}
				}
			}
			else
			{
				if (soundPlaying)
				{
					sound.fadeTo(0, 300);
					soundPlaying = false;
				}
			}
			
		}
		
		private function touchHandler(event:TouchEvent):void 
		{
			var touch1:Touch = event.getTouch(stage, null);
			if (!touch1 || touch1.phase == TouchPhase.HOVER)
				return;
			
			if(!_isEnabled)
			{
				
				touchPointID = -1;
				return;
			}
			
			if (autoDraw)
				return;

			if(touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(stage, null, touchPointID);
				if(!touch)
				{
					//this should never happen
					return;
				}

				touch.getLocation(this, touchLocation);
				
				if (locationInBounds(touchLocation))
				{
					currentState = TOUCHING_OUT_OF_BOUNDS;
				}
				else
				{
					currentState = TOUCHING_IN_BOUNDS;
				}
				
				if(touch.phase == TouchPhase.ENDED)
				{
					currentState = NOT_TOUCHING;
					touchPointID = -1;
				}
				return;
			}
			else //if we get here, we don't have a saved touch ID yet
			{
				touch = event.getTouch(stage, TouchPhase.BEGAN);
				
				if (!touch)
					touch = event.getTouch(stage, TouchPhase.MOVED);
				
				if (!touch)
					touch = event.getTouch(stage, TouchPhase.STATIONARY);
				
				if(touch)
				{
					touch.getLocation(this, touchLocation);
					startTrackingTouch(touchLocation);
					touchPointID = touch.id;
					return;
				}
				
				currentState = NOT_TOUCHING;
			}
		}
		
		private function locationInBounds(touchLocation:Point):Boolean 
		{
			return	touchLocation.x < -touchPadding ||
					touchLocation.x > width + touchPadding ||
					touchLocation.y < -touchPadding ||
					touchLocation.y > height + touchPadding;
		}
		
		private function startTrackingTouch(touchLocation:Point):void 
		{
			if (locationInBounds(touchLocation))
			{
				currentState = TOUCHING_IN_BOUNDS;
			}
			else
			{
				currentState = TOUCHING_OUT_OF_BOUNDS;
			}
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			geomCalc.startTracking(touchLocation.x, touchLocation.y);
			scratchHelper.resetDrawPoint(scratchTexture, touchLocation.x, touchLocation.y);
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			if (autoDraw)
			{
				updateAutoDraw();
			}
			else
			{
				updateDraw();
			}
			
			setRequiresRedraw();
		}
		
		private function updateAutoDraw():void 
		{
			geomCalc.track(autoDrawXY.drawX, autoDrawXY.drawY);
			scratchHelper.drawAtMouse(scratchTexture, autoDrawXY.drawX, autoDrawXY.drawY);
			updateSound(true);
		}
		
		override public function dispose():void 
		{
			sosTrace( "ScratchLayer.dispose" );
			super.dispose();
			
			Starling.current.removeEventListener(Event.CONTEXT3D_CREATE, starling_context3dCreateHandler);
			
			if (scratchTexture)
			{
				scratchTexture.dispose();
				scratchTexture = null;
			}
			
			if (scratchHelper)
			{
				scratchHelper.dispose();
				scratchHelper = null;
			}
			
		}
		
		public function autoScratch():void 
		{
			autoDraw = true;
			
			Starling.juggler.delayCall(startAutoDraw, 0.15);
		}
		
		private function startAutoDraw():void 
		{
			autoDrawXY.drawX = width/3;
			autoDrawXY.drawY = -touchPadding;
			
			geomCalc.startTracking(autoDrawXY.drawX, autoDrawXY.drawY);
			scratchHelper.resetDrawPoint(scratchTexture, autoDrawXY.drawX, autoDrawXY.drawY);
			
			
			TweenHelper.tween(autoDrawXY, 0.10, { drawX: -touchPadding, drawY: height/3, transition:Transitions.EASE_IN_OUT_SINE} )
				.chain(autoDrawXY, 0.10, { drawX: width + touchPadding, drawY: -touchPadding, transition:Transitions.EASE_IN_OUT_SINE})
				.chain(autoDrawXY, 0.10, { drawX: -touchPadding, drawY: 2/3*height, transition:Transitions.EASE_IN_OUT_SINE} )
				.chain(autoDrawXY, 0.10, { drawX: width, drawY: 1/3*height, transition:Transitions.EASE_IN_OUT_SINE})
				.chain(autoDrawXY, 0.10, { drawX: -touchPadding, drawY: height, transition:Transitions.EASE_IN_OUT_SINE} )
				.chain(autoDrawXY, 0.10, { drawX: width + touchPadding, drawY: height / 2, transition:Transitions.EASE_IN_OUT_SINE})
				.chain(autoDrawXY, 0.10, { drawX: width/3, drawY: height+touchPadding, transition:Transitions.EASE_IN_OUT_SINE} )
				.chain(autoDrawXY, 0.10, { drawX: width+touchPadding, drawY: 3/4*height, transition:Transitions.EASE_IN_OUT_SINE,onComplete: onAutodrawComplete } );
			
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function onAutodrawComplete():void 
		{
			finishAutoScratch();
		}
		
		public function finishAutoScratch():void 
		{
			Starling.juggler.removeTweens(autoDrawXY);
			updateSound(false);
			autoDraw = false;
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			dispatchEventWith(FINISHED);
			dispatchedFinish = true;
		}
		
		
		
	}

}

class AutoDrawXY
{
	private var _drawX:Number;
		
	public function get drawX():Number 
	{
		return _drawX;
	}
	
	public function set drawX(value:Number):void 
	{
		_drawX = value;
	}
	
	private var _drawY:Number;
	
	
	public function get drawY():Number 
	{
		return _drawY;
	}
	
	public function set drawY(value:Number):void 
	{
		_drawY = value;
	}
	
	public function AutoDrawXY() 
	{
		super();
	}
}