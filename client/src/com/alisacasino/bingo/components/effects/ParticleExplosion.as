package com.alisacasino.bingo.components.effects
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.screens.lobbyScreenClasses.CashBonusProgress;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import starling.events.Event;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class ParticleExplosion extends Sprite
	{
		public function ParticleExplosion(atlasAsset:AtlasAsset, textures:/*Vector.<String>*/Object, colors:Vector.<uint> = null, startParticlesCount:uint = 0) 
		{
			super();
			touchable = false;
			
			this.atlasAsset = atlasAsset;
			this.startParticlesCount = startParticlesCount;
			
			if (textures is String)
				this.texture = String(textures);
			else if (textures is Vector.<String>)	
				this.textures = textures as Vector.<String>;
				
			texturesCount = textures.length;
			
			this.colors = colors || new Vector.<uint>();
			colorsLength = this.colors.length;
			
			activeParticles = new Vector.<AlisaParticleItem>();
			particlePool = new Vector.<AlisaParticleItem>();
			
			setProperties();
			while (--startParticlesCount > 0) {
				createParticle(true);
			}
		
			addEventListener(Event.REMOVED_FROM_STAGE, handler_removedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, handler_addedToStage);
		}
		
		//-------------------------------------------------------------------------
		//
		//  
		//
		//-------------------------------------------------------------------------
		
		public var activeParticles:Vector.<AlisaParticleItem>;
		public var particlePool:Vector.<AlisaParticleItem>;
		public var colors:Vector.<uint>;
		public var colorsLength:uint;
		
		public var texture:String;
		public var textures:Vector.<String>;
		public var texturesCount:uint;
		public var atlasAsset:AtlasAsset;
		
		public var startParticlesCount:uint;
		public var playMilliseconds:uint;
		public var emitStartTime:uint;
		public var emitFinishTime:uint;
		public var maxParticles:uint;
		public var minEmissionTime:uint;
		public var lastCreateTime:uint;
		public var lifetime:int = int.MAX_VALUE;
		
		public var _minEmitterRadius:int = 0;
		public var _maxEmitterRadius:int = 0;
		private var emitterRadius:int = 0;
		public var speed:Number = 0;
		public var fadeSpeed:Number = 0;
		private var _rotationSpeed:Number = 0.01*Math.PI;
		public var randomMultiplier:Number;
		
		public var fastParticlesRatio:Number = 0;
		public var fastRandomMultiplier:Number = 0;
		public var fastRotationRatio:Number = 0;
		public var fastRotationMultiplier:Number = 0;
		
		public var scaleSpeed:Number = 0;
		public var startScale:Number = 1;
		public var startScaleRandomMultiplier:Number = 0;
		public var scaleSpeedRandomAmplitude:Number = 0;
		public var scaleMax:Number = 1000;
		public var scaleMin:Number = 0;
		public var startFade:Number = 1;
		public var startFadeRandomMultiplier:Number = 0;
		
		
		public var startAngleMultiplier:Number = 1;
		private var _directionAngleShiftSpeed:Number = 0;
		private var _directionAngleShiftAmplitide:Number = 0;
		public var directionAngleShiftAmplitideRandomMultiplier:Number = 0;
		public var directionAngleSpeed:Number = 0;
		
		public var skewAplitude:Number = 0;
		public var skewTweensDelay:int;
		
		private var _emitDirectionAngle:Number = 0;
		private var _emitAngleAmplitude:Number = DOUBLE_PI;
		
		public var speedAcceleration:Number = 0;
		public var scaleAcceleration:Number = 0;
		public var gravityAcceleration:Number = 0;
		
		
		public var speedAccelerationMin:Number = 0;
		public var speedAccelerationMax:Number = 0;
		public var speedAccelerationEasingSpeed:Number = 0; 
		
		public var onlyPositiveDistance:Boolean;
		
		public var onlyPositiveSpeed:Boolean = true;
		
		public const DOUBLE_PI:Number = Math.PI * 2;
		
		public var startXAmplitude:int;
		public var startYAmplitude:int;
		
		public var boundsRect:Rectangle;
		
		public var getAlisaParticleFunction:Function;
		
		//-------------------------------------------------------------------------
		//
		//  
		//
		//-------------------------------------------------------------------------
		
		/**
		 * 
		 * */
		public function setProperties(minEmitterRadius:int = 0, maxEmitterRadius:int = 0, speed:Number = 4, scaleSpeed:Number = -0.02, rotationSpeed:Number = 0.03, fadeSpeed:Number = 0, randomMultiplier:Number = 0, onlyPositiveDistance:Boolean = false):void 
		{
			_minEmitterRadius = minEmitterRadius;
			_maxEmitterRadius = maxEmitterRadius;
			calculateEmitterRadius();
			this.speed = speed;
			this.scaleSpeed = scaleSpeed;
			_rotationSpeed = rotationSpeed;
			this.fadeSpeed = fadeSpeed;
			this.randomMultiplier = randomMultiplier;
			this.onlyPositiveDistance = onlyPositiveDistance;
		}
		
		/**
		 * @param fastParticlesRatio:Number = 0 - 1. Шансы появления быстрых частиц.
		 * @param fastRandomMultiplier:Number Множитель насколько быстрые частицы быстры.
		 * @param fastRotationRatio:Number = 0 - 1. Шансы появления быстрых по вращению частиц.
		 * @param fastRotationMultiplier:Number Множитель насколько быстрые по вращению частицы быстры.
		 * */
		public function setFineProperties(startScale:Number = 1, startScaleRandomMultiplier:Number = 0, fastParticlesRatio:Number = 0.5, fastRandomMultiplier:Number = 2, fastRotationRatio:Number = 0.5, fastRotationMultiplier:Number = 4, startYAmplitude:int = 0, startXAmplitude:int = 0):void 
		{
			this.startScale = startScale;
			this.startScaleRandomMultiplier = startScaleRandomMultiplier;
			this.fastParticlesRatio = fastParticlesRatio;
			this.fastRandomMultiplier = fastRandomMultiplier;
			this.fastRotationRatio = fastRotationRatio;
			this.fastRotationMultiplier = fastRotationMultiplier;
			this.startXAmplitude = startXAmplitude;
			this.startYAmplitude = startYAmplitude;
		}
		
		/**
		 * @param speed:Number = 0 - max.
		 * @param amplitude:int Множитель насколько быстрые частицы быстры.
		 * @param randomMultiplier:Number
		 * */
		public function setDirectionAngleProperties(speed:Number = 0.03, amplitude:int = 10, randomMultiplier:Number = 0, directionAngleSpeed:Number = 0):void 
		{
			_directionAngleShiftSpeed = speed;
			directionAngleShiftAmplitide = amplitude;
			directionAngleShiftAmplitideRandomMultiplier = randomMultiplier;
			this.directionAngleSpeed = directionAngleSpeed;
		}
		
		/**
		 * @param startAngleMultiplier:Number - угол при рождении
		 * @param emitDirectionAngle:Number - стартовый угол направления разброса
		 * @param emitAngleAmplitude:Number - амплитуда разброса 
		 * */
		public function setEmitDirectionAngleProperties(startAngleMultiplier:Number = 1, emitDirectionAngle:Number = 0, emitAngleAmplitude:Number = -1):void 
		{
			this.startAngleMultiplier = startAngleMultiplier;
			_emitDirectionAngle = emitDirectionAngle;
			_emitAngleAmplitude = emitAngleAmplitude == -1 ? DOUBLE_PI : emitAngleAmplitude;
		}
		
		public function setFadeProperties(startFade:Number = 1, startFadeRandomMultiplier:Number = 0):void 
		{
			this.startFade = startFade;
			this.startFadeRandomMultiplier = startFadeRandomMultiplier;
		}
		
		public function setAccelerationProperties(speedAcceleration:Number = 0, scaleAcceleration:Number = 0):void 
		{
			this.speedAcceleration = speedAcceleration;
			this.scaleAcceleration = scaleAcceleration;
		}
		
		public function play(playMilliseconds:uint, maxParticles:uint, startParticlesCount:uint = 0, minEmissionTime:uint = 0):void 
		{
			setPlayProperties(playMilliseconds, maxParticles, startParticlesCount, minEmissionTime);
			
			emitStartTime = getTimer();
			emitFinishTime = playMilliseconds == 0 ? uint.MAX_VALUE : (emitStartTime + playMilliseconds);
			
			addEventListener(Event.ENTER_FRAME, handler_enterFrame);
			
			while (--startParticlesCount > 0) {
				createParticle();
			}
		}
		
		public function stop():void 
		{
			maxParticles = 0;
		}
		
		public function setPlayProperties(playMilliseconds:uint, maxParticles:uint, startParticlesCount:uint = 0, minEmissionTime:uint = 0):void {
			this.playMilliseconds = playMilliseconds;
			this.maxParticles = maxParticles;
			this.startParticlesCount = startParticlesCount;
			this.minEmissionTime = minEmissionTime;
		}
		
		public function start():void {
			play(playMilliseconds, maxParticles, startParticlesCount, minEmissionTime);
		}
		
		public function get isPlaying():Boolean
		{
			//trace('asdc as', (maxParticles != 0 || activeParticles.length > 0) && hasEventListener(Event.ENTER_FRAME, handler_enterFrame), maxParticles , activeParticles.length, hasEventListener(Event.ENTER_FRAME, handler_enterFrame));
			return (maxParticles != 0 || activeParticles.length > 0) && hasEventListener(Event.ENTER_FRAME, handler_enterFrame);
		}
		
		private function createParticle(forPool:Boolean = false):void 
		{
			var particle:AlisaParticleItem = getParticle();
			particle.createTime = getTimer();
			particle.scale = startScale + Math.random() * startScaleRandomMultiplier;
			particle.rotation = Math.random() * DOUBLE_PI * startAngleMultiplier;
			particle.alpha = startFade + Math.random() * startFadeRandomMultiplier;
			particle.speedAcceleration = speedAcceleration;
			particle.scaleAcceleration = scaleAcceleration;
			particle.gravityAcceleration = 0;
			particle.gravityAccelerationValue = 0;
			particle.valueRatio = 0;
			particle.directionAngle = _emitDirectionAngle - _emitAngleAmplitude / 2 + _emitAngleAmplitude * Math.random();
			
			if (_directionAngleShiftSpeed) {
				particle.directionAngleShiftAmplitude = _directionAngleShiftAmplitide + Math.random() * directionAngleShiftAmplitideRandomMultiplier;
				particle.directionAngleShiftValue = DOUBLE_PI * Math.random();
			}
			
			particle.startX = startXAmplitude * Math.random();
			particle.startY = startYAmplitude * Math.random();
			
			particle.distance = _minEmitterRadius + emitterRadius * Math.random();
			particle.x = particle.startX + particle.distance * Math.cos(particle.directionAngle);
			particle.y = particle.startY + particle.distance * Math.sin(particle.directionAngle);
			
			if (skewAplitude > 0) {
				particle.skewSpeedX = skewAplitude/2 - skewAplitude * Math.random();
				particle.skewSpeedY = skewAplitude/2 - skewAplitude * Math.random();
				particle.skewX = 0;
				particle.skewY = 0;
				particle.startSkewTweenTime = particle.createTime + skewTweensDelay;
			}
			else {
				particle.startSkewTweenTime = int.MAX_VALUE;
			}
			
			if (colors.length > 0)
				particle.color = colors[Math.floor(colorsLength * Math.random())]; 
				
			if (Math.random() < fastParticlesRatio) {
				particle.speed = fastRandomMultiplier * speed + speed * Math.random() * randomMultiplier;
				particle.scaleSpeed = scaleSpeed * (fastRandomMultiplier + Math.random() * randomMultiplier) + Math.random() * scaleSpeedRandomAmplitude;
			}
			else {
				particle.speed = speed + speed * Math.random() * randomMultiplier;
				particle.scaleSpeed = scaleSpeed * (1 + Math.random() * randomMultiplier) + Math.random() * scaleSpeedRandomAmplitude;
			}
			
			if(Math.random() < fastRotationRatio)
				particle.rotationSpeed = fastRotationMultiplier * _rotationSpeed + _rotationSpeed * Math.random() * randomMultiplier;
			else
				particle.rotationSpeed = _rotationSpeed + _rotationSpeed * Math.random() * randomMultiplier;
			
			if (forPool) {
				particlePool.push(particle);
			}
			else {
				activeParticles.push(particle);
				addChild(particle);
			}
		}
		
		protected function easeIn(ratio:Number):Number
        {
            return ratio * ratio * ratio;
        }    
		
		private function handler_enterFrame(e:Event):void 
		{
			var timerValue:int = getTimer();
			if (activeParticles.length < maxParticles && timerValue < emitFinishTime && (timerValue - lastCreateTime > minEmissionTime)) {
				lastCreateTime = timerValue;
				createParticle();
			}
			
			var i:int; 
			var length:int = i = activeParticles.length; 
			
			while(i--)
			{
				var activeParticle:AlisaParticleItem = activeParticles[i];
				
				if (speedAccelerationEasingSpeed != 0) {
					activeParticle.valueRatio = Math.min(1, activeParticle.valueRatio + speedAccelerationEasingSpeed);
					
					if (activeParticle.speedAcceleration > speedAccelerationMin && activeParticle.speedAcceleration < speedAccelerationMax)
						activeParticle.speedAcceleration = Math.min(Math.max(speedAcceleration - speedAcceleration * activeParticle.easeInValueRatio, speedAccelerationMin), speedAccelerationMax);
				}
				
				activeParticle.speed = onlyPositiveSpeed ? Math.max(0, activeParticle.speed + activeParticle.speedAcceleration) : (activeParticle.speed + activeParticle.speedAcceleration);
				activeParticle.scaleSpeed += activeParticle.scaleAcceleration;
				if (gravityAcceleration != 0) {
					activeParticle.gravityAcceleration += gravityAcceleration;
					activeParticle.gravityAccelerationValue += activeParticle.gravityAcceleration;
				}
				
				activeParticle.distance = onlyPositiveDistance ? Math.max(0, activeParticle.distance + activeParticle.speed) : (activeParticle.distance + activeParticle.speed);	
			
				activeParticle.directionAngle += directionAngleSpeed;	
					
				if(_directionAngleShiftSpeed) {
					activeParticle.directionAngleShiftValue += _directionAngleShiftSpeed;
					activeParticle.directionAngleShift = activeParticle.directionAngleShiftAmplitude * Math.sin(activeParticle.directionAngleShiftValue);
				}
				
				activeParticle.x = activeParticle.startX + activeParticle.distance * Math.cos(activeParticle.overallDirectionAngle);
				activeParticle.y = activeParticle.startY + activeParticle.distance * Math.sin(activeParticle.overallDirectionAngle) + activeParticle.gravityAccelerationValue;
				activeParticle.rotation += activeParticle.rotationSpeed;
				activeParticle.alpha += fadeSpeed;
				activeParticle.scale = Math.max(scaleMin, Math.min(activeParticle.scale + activeParticle.scaleSpeed, scaleMax));
				
				if (activeParticle.startSkewTweenTime < timerValue) {
					activeParticle.skewX += activeParticle.skewSpeedX;
					activeParticle.skewY += activeParticle.skewSpeedY;
				}
				
				if (activeParticle.scale <= 0 || activeParticle.alpha <= 0 || (timerValue - activeParticle.createTime) > lifetime || (boundsRect && !boundsRect.contains(activeParticle.x, activeParticle.y)))
				{
					activeParticle.removeFromParent();
					activeParticles.removeAt(i);
					particlePool.push(activeParticle);
				}
			}
			
			if (length == 0) {
				removeEventListener(Event.ENTER_FRAME, handler_enterFrame);
				dispatchEventWith(Event.COMPLETE);
			}
		}
		
		private function getParticle():AlisaParticleItem
		{
			if (particlePool.length > 0)
				return particlePool.pop();
			
			if (getAlisaParticleFunction != null) {
				return getAlisaParticleFunction() as AlisaParticleItem;
			}
				
			if (texture)
				return new AlisaParticleItem(atlasAsset.getTexture(texture));
			else
				return new AlisaParticleItem(atlasAsset.getTexture(textures[Math.floor(texturesCount * Math.random())]));
		}
		
		public function cleanParticlesPool():void
		{
			while (particlePool.length > 0) {
				particlePool.pop();
			}
		}
		
		private function handler_removedFromStage(event:Event):void
		{
			//removeEventListener(Event.REMOVED_FROM_STAGE, handler_removedFromStage);
			removeEventListener(Event.ENTER_FRAME, handler_enterFrame);
		}
		
		private function handler_addedToStage(event:Event):void
		{
			//removeEventListener(Event.REMOVED_FROM_STAGE, handler_removedFromStage);
			if(activeParticles.length > 0)
				addEventListener(Event.ENTER_FRAME, handler_enterFrame);
		}
		
		public function set minEmitterRadius(value:int):void {
			_minEmitterRadius = value;
			calculateEmitterRadius();
		}
		
		public function set maxEmitterRadius(value:int):void {
			_maxEmitterRadius = value;
			calculateEmitterRadius();
		}
		
		public function get minEmitterRadius():int {
			return _minEmitterRadius;
		}
		
		public function get maxEmitterRadius():int {
			return _maxEmitterRadius;
		}
		
		private function calculateEmitterRadius():void {
			emitterRadius = Math.max(_maxEmitterRadius, _maxEmitterRadius - _minEmitterRadius);
		}
		
		
		
		public function get emitDirectionAngle():int {
			return (_emitDirectionAngle*180)/Math.PI;
		}
		
		public function set emitDirectionAngle(value:int):void {
			_emitDirectionAngle = (value * Math.PI) / 180;
		}
		
		
		public function get emitAngleAmplitude():int {
			return (_emitAngleAmplitude*180)/Math.PI;
		}
		
		public function set emitAngleAmplitude(value:int):void {
			_emitAngleAmplitude = (value * Math.PI) / 180;
		}
		
		public function get directionAngleShiftSpeed():int {
			return (_directionAngleShiftSpeed*180)/Math.PI;
		}
		
		public function set directionAngleShiftSpeed(value:int):void {
			_directionAngleShiftSpeed = (value * Math.PI) / 180;
		}
		
		public function get rotationSpeed():int {
			return (_rotationSpeed*180)/Math.PI;
		}
		
		public function set rotationSpeed(value:int):void {
			_rotationSpeed = (value * Math.PI) / 180;
		}
		
		public function get directionAngleShiftAmplitide():int {
			return (_directionAngleShiftAmplitide*180)/Math.PI;
		}
		
		public function set directionAngleShiftAmplitide(value:int):void {
			_directionAngleShiftAmplitide = (value * Math.PI) / 180;
		}
		
		
	}
}