package com.alisacasino.bingo.components.effects 
{
	import de.flintfabrik.starling.extensions.FFParticleSystem;
	import de.flintfabrik.starling.extensions.FFParticleSystem.SystemOptions;
	import de.flintfabrik.starling.extensions.FFParticleSystem.styles.FFParticleStyle;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class FFParticlesView extends DisplayObjectContainer
	{
		private var ffParticleSystems:Vector.<FFParticleSystem>;
		private var particlesTextures:Vector.<Texture>;
		private var particleSettings:Array;
		private var callback_playComplete:Function;
		private var particlesCount:int;
		
		public function FFParticlesView(particlesTextures:Vector.<Texture>, particleSettings:Array, callback_playComplete:Function = null) 
		{
			super();
			
			this.particlesTextures = particlesTextures || new <Texture>[];
			this.particleSettings = particleSettings || [];
			this.callback_playComplete = callback_playComplete;
			
			ffParticleSystems = new <FFParticleSystem>[];
			
			// сеттинг может быть один на ввсех или свой на каждую текстуру 
			// могут быть свои уникальные настройки рандомайза при куче текстур и одном сеттинге чтобы они не летели все одновременно и учитывались как будто 
			// create and child all
			create();
		}
		
		public function play():void 
		{
			var i:int;
			for (i = 0; i < particlesCount; i++)
			{
				ffParticleSystems[i].start();
			}
		}
		
		public function stop():void 
		{
			var i:int;
			for (i = 0; i < particlesCount; i++)
			{
				ffParticleSystems[i].stop();
			}
		}
		
		public function setProperties(systemOptions:SystemOptions):void 
		{
			var i:int;
			for (i = 0; i < particlesCount; i++) {
				systemOptions.texture = ffParticleSystems[i].texture;
				ffParticleSystems[i].parseSystemOptions(systemOptions);
			}
			
			/*
			var ffParticleSystem:FFParticleSystem;
			var key:String;
			for (key in propertiesRaw) 
			{
				if (key in ffParticleSystem)
					ffParticleSystem[key] = propertiesRaw[key];
			}*/
		}
		
		public function getParticleSystemByIndex(index:int):FFParticleSystem
		{
			return ffParticleSystems.length > index ? ffParticleSystems[index] : null;
		}
		
		private function create():void 
		{
			var i:int;
			particlesCount = particlesTextures.length;
			
			if (particleSettings.length == 0 || particlesCount == 0)
				return;
			
			var systemOptions:SystemOptions;
			var ffParticleSystem:FFParticleSystem;
			var ffParticleStyle:FFParticleStyle;
			for (i = 0; i < particlesCount; i++)
			{
				systemOptions = new SystemOptions(particlesTextures[i]);
				//systemOptions.appendFromObject(particleSettings[Math.min(i, particleSettings.length - 1)]);
				SystemOptions.fromXML(new XML(particleSettings[Math.min(i, particleSettings.length - 1)]), particlesTextures[i], null, systemOptions);
				
				ffParticleStyle = new FFParticleSystem.defaultStyle();
				ffParticleStyle.effectType.createBuffers(100, 16);
				
				ffParticleSystem = new FFParticleSystem(systemOptions, ffParticleStyle);
				ffParticleSystem.addEventListener(Event.COMPLETE, handler_ffParticleSystemComplete);
				ffParticleSystems.push(ffParticleSystem);
				
				addChild(ffParticleSystem);
			}
			
			
			
			/*var psConfig:XML = XML(XmlAsset.CashPeriodicParticlesCfg.xml);//Snow.xml);
			var sysOpt:SystemOptions = SystemOptions.fromXML(psConfig, AtlasAsset.CommonAtlas.getTexture("buy_cards/gray_padlock"));
			FFParticleSystem.initPool();
			
			var ffpsStyle:FFParticleStyle = new FFParticleSystem.defaultStyle();
			ffpsStyle.effectType.createBuffers(4096, 16);
			//FFParticleStyleClone.effectType.createBuffers(4096, 16);
			
			
			var ps:FFParticleSystem = new FFParticleSystem(sysOpt, ffpsStyle);
			 
			Game.current.gameScreen.addChild(ps);
			
			ps.emitterX = 200;
			ps.emitterY = 200;
			 
			sysOpt.appendFromObject();
			
			//ps.advanceTime(20);
			
			ps.start();
			ps.touchable = false;*/
		}
		
	
		private function handler_ffParticleSystemComplete():void 
		{
			var i:int;
			for (i = 0; i < particlesCount; i++)
			{
				if (!ffParticleSystems[i].completed)
					return;
			}
			
			if (callback_playComplete != null)
				callback_playComplete(this);
		}
		
		public function clear():void 
		{
			var i:int;
			for (i = 0; i < particlesCount; i++)
			{
				ffParticleSystems[i].stop();
			}
		}
		
	}

}