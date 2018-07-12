package com.alisacasino.bingo.screens.gameScreenClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class StarsEmitter extends Sprite
	{
		public var emit:Boolean;
		
		public var emitterWidth:Number = 0;
		
		public var speed:Number = 4 * pxScale;
		public var fadeSpeed:Number = 0.03;
		public var rotationSpeed:Number = 0.01*Math.PI;
		public var scaleSpeed:Number = 0;
		
		private var activeParticles:Vector.<Image>;
		private var particlePool:Vector.<Image>;
		
		
		public function StarsEmitter() 
		{
			activeParticles = new Vector.<Image>();
			particlePool = new Vector.<Image>();
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			if (emit)
			{
				var particle:Image = getParticle();
				particle.alignPivot();
				particle.scale = Math.random() * 0.5 + 1;
				particle.rotation = Math.random() * Math.PI * 2;
				particle.alpha = 1;
				particle.x = emitterWidth * Math.random();
				particle.y = 0;
				activeParticles.push(particle);
				addChild(particle);
			}
			
			
			var i:int = activeParticles.length;
			while(i--)
			{
				var activeParticle:Image = activeParticles[i];
				activeParticle.y += speed;
				activeParticle.rotation += rotationSpeed;
				activeParticle.alpha -= fadeSpeed;
				activeParticle.scale += scaleSpeed;
				if (activeParticle.alpha <= 0 || activeParticle.scale <= 0)
				{
					activeParticle.removeFromParent();
					activeParticles.removeAt(i);
					particlePool.push(activeParticle);
				}
			}
		}
		
		private function getParticle():Image 
		{
			if (particlePool.length > 0)
			{
				return particlePool.pop();
			}
			
			return new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/leaderboards/trail_star"));
		}
		
	}

}