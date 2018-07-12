package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	
	public class LoadingBar extends Sprite
	{
		private var mAtlas:AtlasAsset = AtlasAsset.LoadingAtlas;
		private var mBack:Image;
		private var mGlass:Image;
		private var mFillStart:Image;
		private var mFillCenter:Image;
		private var mFillEnd:Image;
		private var mPosition:Number = 0.;
		private var mParticlesContainer:Sprite;
		private var mParticlesContainerWidth:Number;
		private var mPositionToAdvance:Number = 0.;
		
		public function get positionToAdvance():Number 
		{
			return mPositionToAdvance;
		}
		private var mSpeed:Number;
		
		private static const PARTICLES_COUNT:int = 4;
		
		public function LoadingBar()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(starling.events.Event.ENTER_FRAME, onEnterFrame);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		private function removedFromStageHandler(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			while (mParticlesContainer.numChildren)
			{
				var particle:LoadingParticle = mParticlesContainer.getChildAt(0) as LoadingParticle;
				if (!particle)
				{
					mParticlesContainer.removeChildAt(0, true);
					continue;
				}
				Starling.juggler.removeTweens(particle);
				particle.removeFromParent(true);
			}
		}
		
		public function onAddedToStage(e:Event):void
		{
			mBack = new Image(mAtlas.getTexture("loading_bar/loading_bck"));
			addChild(mBack);
			
			mParticlesContainer = new Sprite();
			addChild(mParticlesContainer);
			
			mFillStart = new Image(mAtlas.getTexture("loading_bar/loader_fill_start"));
			mFillCenter = new Image(mAtlas.getTexture("loading_bar/loader_fill_mid"));
			mFillCenter.tileGrid = new Rectangle();
			mFillEnd = new Image(mAtlas.getTexture("loading_bar/loader_fill_end"));
			addChild(mFillStart);
			addChild(mFillCenter);
			addChild(mFillEnd);
			
			mParticlesContainerWidth = mFillEnd.width * 2;
			for (var i:int = 0; i < PARTICLES_COUNT; i++) {
				var particle:LoadingParticle = new LoadingParticle();
				mParticlesContainer.addChild(particle);
				particle.pivotX = particle.width >> 1;
				particle.pivotY = particle.height >> 1;
				particle.scaleX = particle.scaleY = 0.5;
				particle.x = -particle.width/2;
				particle.y = 1 + (mFillStart.height - particle.width - 2) * i / (PARTICLES_COUNT - 1) + particle.width * 0.5;
				var duration:Number = 0.4 + Math.random() * 0.3;
				var scaleTo:Number = 0.3 + Math.random() * 0.2;
				var toX:Number = mParticlesContainerWidth - particle.width / 2;
				Starling.juggler.tween(particle, duration, {
					repeatCount: 999,
					x: toX,
					alpha: 0.0,
					scaleX: scaleTo,
					scaleY: scaleTo,
					rotation: Math.PI * Math.random()
				});
			}
			
			mGlass = new Image(mAtlas.getTexture("loading_bar/loader_glass"));
			addChild(mGlass);
			mGlass.x = mBack.width - mGlass.width >> 1;
			mGlass.y = mBack.height * 0.33 - mGlass.height * 0.5;
			
			this.position = 0.0;
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void
		{
			if (position < mPositionToAdvance)
				position += mSpeed * e.passedTime * 1000;
		}
		
		public function get position():Number
		{
			return mPosition;
		}
		
		public function set position(value:Number):void
		{
			if (value < 0) value = 0;
			if (value > 1.0) value = 1.0;
			mPosition = value;
			var maxFillWidth:Number = 0.85 * mBack.width;
			var minFillWidth:Number = mFillStart.width + mFillEnd.width;
			var fillWidth:int = minFillWidth + (maxFillWidth - minFillWidth) * value;
			
			mFillStart.x = mBack.width - maxFillWidth >> 1;
			mFillCenter.x = mFillStart.x + mFillStart.width;
			mFillCenter.width = fillWidth - mFillStart.width - mFillEnd.width;
			mFillEnd.x = mFillCenter.x + mFillCenter.width;
			
			mFillStart.y = mFillCenter.y = mFillEnd.y = mParticlesContainer.y = mBack.height - mFillStart.height >> 1;
			mParticlesContainer.x = Math.min(mFillEnd.x + mFillEnd.width, mFillStart.x + maxFillWidth - mParticlesContainerWidth);
		}
		
		public function advanceToPosition(toPosition:Number, timeIntervalMillis:Number):void
		{
			sosTrace("advanceToPosition:"+toPosition);
			mPositionToAdvance = toPosition;
			if (mPositionToAdvance < mPosition)
				mPositionToAdvance = mPosition;
			else if (mPositionToAdvance > 1.0)
				mPositionToAdvance = 1.0;
			if (timeIntervalMillis == 0) {
				position = mPositionToAdvance;
				mSpeed = 0;
				return;
			}
			mSpeed = (mPositionToAdvance - mPosition) / timeIntervalMillis;
		}
	}
}

import starling.display.Image;
import com.alisacasino.bingo.assets.AtlasAsset;

class LoadingParticle extends Image {
	public function LoadingParticle() {
		super(AtlasAsset.LoadingAtlas.getTexture("loading_bar/particle"));
	}
	override public function get alpha():Number {
		return super.alpha;
	}
	override public function set alpha(value:Number):void {
		if (value < 0.5) {
			super.alpha = value * 2;
		} else
			super.alpha = 1.0;
	}
}