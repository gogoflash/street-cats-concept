package com.alisacasino.bingo.screens.gameScreenClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.components.effects.FFParticlesView;
	import com.alisacasino.bingo.components.effects.ParticleExplosion;
	import com.alisacasino.bingo.models.skinning.SkinningDauberData;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class CellDaubEffect 
	{
		public static const EXPLOSION:String = "explosion";
		
		public static const EXPLOSION_WAVE:String = 'explosion_wave';
		
		public static const EXPLOSION_WAVE_INSIDE:String = 'explosion_wave_inside';
		
		public static const VOLUME_SPARKLING:String = 'volume_sparkling';
		
		public static const WHIRLPOOL:String = 'whirlpool';
		
		public static const CUSTOM_FF_PARTICLES:String = 'custom_ff_particles';
		
		public static var typesList:Vector.<String> = new <String> 
		[
			EXPLOSION,
			EXPLOSION_WAVE,
			EXPLOSION_WAVE_INSIDE,
			VOLUME_SPARKLING,
			WHIRLPOOL,
			CUSTOM_FF_PARTICLES
		]
		
		public function CellDaubEffect() 
		{
			
		}
		
		public static function showCurrent(container:DisplayObjectContainer, x2:Boolean, x:Number = 0, y:Number = 0):void 
		{
			var dauberSkin:SkinningDauberData = gameManager.skinningData.dauberSkin;
			show(container, dauberSkin.atlas, dauberSkin.getParticlesTextureNames(x2), dauberSkin.particleAnimation, x, y);
		}
		
		public static function show(container:DisplayObjectContainer, atlas:AtlasAsset, textures:Object, type:String, x:Number = 0, y:Number = 0, colors:Vector.<uint> = null, getParticlesFunction:Function = null, ffParticleSettings:Array = null, callPlay:Boolean = true):DisplayObject 
		{
			var starsExplosion:ParticleExplosion;
			var ffParticlesView:FFParticlesView;
			
			switch(type)
			{
				case EXPLOSION: 
				{
					starsExplosion = new ParticleExplosion(atlas, textures, colors);
					starsExplosion.setProperties(0, 0*pxScale, 6, -0.055, 0.0, 0, 0.1);
					starsExplosion.setFineProperties(1.2, 1, 0.0, 0.0, 0, 0);
					starsExplosion.setAccelerationProperties(-0.16);
					starsExplosion.x = x;
					starsExplosion.y = y;
					starsExplosion.addEventListener(Event.COMPLETE, handler_particleExplosionComplete);
					starsExplosion.getAlisaParticleFunction = getParticlesFunction;
					
					container.addChild(starsExplosion);
					starsExplosion.setPlayProperties(150, 30, 15);
					if(callPlay)
						starsExplosion.start();
			
					return starsExplosion;
					
					break;
				}
				case EXPLOSION_WAVE_INSIDE: 
				{
					starsExplosion = new ParticleExplosion(atlas, textures, colors);
					starsExplosion.setProperties(40*pxScale, 0*pxScale, 3, -0.018, 0.03, 0, 0.1, true);
					starsExplosion.setFineProperties(1.2, 1, 0.0, 0.0, 0, 0);
					starsExplosion.setAccelerationProperties( -0.08);
					starsExplosion.setDirectionAngleProperties(0.09, 18);
					starsExplosion.x = x;
					starsExplosion.y = y;
					starsExplosion.addEventListener(Event.COMPLETE, handler_particleExplosionComplete);
					starsExplosion.getAlisaParticleFunction = getParticlesFunction;
					
					container.addChild(starsExplosion);
					starsExplosion.setPlayProperties(350, 20, 2, 20)
					if(callPlay)
						starsExplosion.start();
						
					return starsExplosion;
					
					break;
				}
				case EXPLOSION_WAVE: 
				{
					starsExplosion = new ParticleExplosion(atlas, textures, colors);
					starsExplosion.setProperties(49*pxScale, 0*pxScale, 0.9, -0.019, 0.03, 0, 0.1);
					starsExplosion.setFineProperties(1.2, 1, 0.0, 0.0, 0, 0);
					//starsExplosion.setAccelerationProperties(0.06);
					starsExplosion.setDirectionAngleProperties(0.1, 14);
					starsExplosion.x = x;
					starsExplosion.y = y;
					starsExplosion.addEventListener(Event.COMPLETE, handler_particleExplosionComplete);
					starsExplosion.getAlisaParticleFunction = getParticlesFunction;
					
					container.addChild(starsExplosion);
					starsExplosion.setPlayProperties(550, 25, 2, 60);
					if(callPlay)
						starsExplosion.start();
						
					return starsExplosion;
					
					break;
				}
				case VOLUME_SPARKLING: 
				{
					starsExplosion = new ParticleExplosion(atlas, textures, colors, 0);
					starsExplosion.setProperties(40*pxScale, 100*pxScale, -0.0, -0.043, 0.00, 0.06, 0.7, true);
					starsExplosion.setFineProperties(2.3, 0.7, 0.4, 1.6);
					starsExplosion.setEmitDirectionAngleProperties(0);
					starsExplosion.setFadeProperties(0.01);
					starsExplosion.x = x;
					starsExplosion.y = y;
					starsExplosion.addEventListener(Event.COMPLETE, handler_particleExplosionComplete);
					starsExplosion.getAlisaParticleFunction = getParticlesFunction;
					
					//starsExplosion.setProperties(70*pxScale, 3, -0.02, 0.07, 0, 1);
					//starsExplosion.setFineProperties(1, 0.2, 0.5, 2, 0.5, 4);
					
					container.addChild(starsExplosion);
					starsExplosion.setPlayProperties(950, 15, 5, 100)
					if(callPlay)
						starsExplosion.start();
						
					return starsExplosion;
					
					break;
				}
				case WHIRLPOOL: 
				{
					starsExplosion = new ParticleExplosion(atlas, textures, colors, 0);
					starsExplosion.setProperties(49*pxScale, 0*pxScale, 1, -0.019, 0.03, 0.05, 0.1);
					starsExplosion.setFineProperties(1.2, 1, 0.0, 0.0, 0, 0);
					starsExplosion.setFadeProperties(0.01);
					starsExplosion.setDirectionAngleProperties(0.4, 0, 0, 0.05);
					starsExplosion.x = x;
					starsExplosion.y = y;
					starsExplosion.addEventListener(Event.COMPLETE, handler_particleExplosionComplete);
					starsExplosion.getAlisaParticleFunction = getParticlesFunction;
					
					container.addChild(starsExplosion);
					starsExplosion.setPlayProperties(650, 25, 0, 80);
					if(callPlay)
						starsExplosion.start();
						
					return starsExplosion;
					
					break;
				}
				
				case CUSTOM_FF_PARTICLES:
				{
					var particlesTextures:Vector.<Texture> = new <Texture>[];
					var i:int;
					var length:int = textures.length;
					for (i = 0; i < length; i++) {
						//if(i == 3)
						particlesTextures.push(atlas.getTexture(textures[i]));
						
					}
					
					ffParticlesView = new FFParticlesView(particlesTextures, ffParticleSettings, handler_ffParticlesComplete);
					ffParticlesView.x = x;
					ffParticlesView.y = y;
					container.addChild(ffParticlesView);
					
					if(callPlay)
						ffParticlesView.play();
						
					return ffParticlesView;
					
					break;
				}
			}
			
			return null;
		}
		
		public static function play(view:DisplayObject):void 
		{
			if (!view)
				return;
			
			if (view is ParticleExplosion) {
				(view as ParticleExplosion).start();
			}
			else if (view is FFParticlesView) {
				(view as FFParticlesView).play();
			}
		}
		
		public static function stop(view:DisplayObject):void 
		{
			if (!view)
				return;
			
			if (view is ParticleExplosion) {
				(view as ParticleExplosion).stop();
			}
			else if (view is FFParticlesView) {
				(view as FFParticlesView).stop();
			}
		}
		
		private static function handler_particleExplosionComplete(event:Event):void 
		{
			(event.target as ParticleExplosion).removeEventListener(Event.COMPLETE, handler_particleExplosionComplete);
			(event.target as DisplayObject).removeFromParent();
		}
		
		private static function handler_ffParticlesComplete(ffParticlesView:FFParticlesView):void 
		{
			ffParticlesView.clear();
			//ffParticlesView.removeFromParent();
		}
		
		public static function getNextEffectType(type:String):String
		{
			var index:int = typesList.indexOf(type);
				
			index++;
			if (index >= typesList.length)
				index = 0;
			
			return typesList[index];	
		}
	}

}

/*var colors:Vector.<uint>;
			if (isX2Active)
				colors = new <uint> [0xff5329, 0xffff00, 0xfdd700, 0xff5329];
			else 
				colors = new <uint> [0x00baff, 0x7fe8ff, 0xbde4ff, 0x00baff];*/