package com.alisacasino.bingo.utils
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.commands.ShowNoMoneyPopup;
	import com.alisacasino.bingo.components.effects.ParticleExplosion;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.utils.caurina.transitions.Tweener;
	import com.theintern.beziertween.BezierTween;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import starling.animation.Tween;
	import starling.display.BlendMode;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	import starling.textures.Texture;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	

	public class EffectsManager
	{
		public function EffectsManager() {
		}
			
		public static function initialize():void {
			Tweener.registerSpecialProperty("_bright", getBright, setBright);
			Tweener.registerSpecialProperty("_brightGold", getBrightGold, setBrightGold);
		}
		
		private static function getBright(displayObject:DisplayObject, ...params):Number {
			if('filter' in displayObject) {
				if(displayObject['filter'] as ColorMatrixFilter)
					return (displayObject['filter'] as ColorMatrixFilter).matrix[0];
			}	
			
			return 0;
		}
		
		private static function setBright(displayObject:DisplayObject, value:Number, ...params):void {
			if('filter' in displayObject) {
				if(displayObject['filter'] as ColorMatrixFilter)
					(displayObject['filter'] as ColorMatrixFilter).matrix = getBrightnessMatrix(value);
			}
		}
		
		private static function getBrightGold(displayObject:DisplayObject, ...params):Number {
			if ('filter' in displayObject) {
				///trace(1+(1 - (displayObject['filter'] as ColorMatrixFilter).matrix[0]) * 3.3333);
				if(displayObject['filter'] as ColorMatrixFilter)
					return 1+(1 - (displayObject['filter'] as ColorMatrixFilter).matrix[0]) * 3.3333;
			}	
			
			return 0;
		}
		
		private static function setBrightGold(displayObject:DisplayObject, value:Number, ...params):void {
			if('filter' in displayObject) {
				if(displayObject['filter'] as ColorMatrixFilter)
					(displayObject['filter'] as ColorMatrixFilter).matrix = getGoldBrightnessMatrix(value);
			}
		}
		
		//-------------------------------------------------------------------------
		//
		//  
		//
		//-------------------------------------------------------------------------
		
		private static var jumpObjects:Dictionary = new Dictionary();
		
		public static function jump(displayObject:DisplayObject, count:int = -1, minScale:Number = 1, maxScale:Number = 1.1, timeIn:Number = 0.7, timeOut:Number = 1, delay:Number = 0, delayCount:int = 0, delayOnStart:Number = 0, brightness:Number = 1.3, overrideJump:Boolean = true, goldFilter:Boolean=false, rotation:Number = NaN):void 
		{
			if(!(displayObject as DisplayObject))
				return;
			
			if(jumpObjects[displayObject] != null)
			{
				if(!overrideJump)
					return;
				
				removeJump(displayObject);
			}
			
			var jumpData:JumpData = new JumpData();
			jumpData.maxBrightness = brightness;
			jumpData.minScale = minScale;
			jumpData.maxScale = maxScale;
			jumpData.count = count;
			jumpData.timeIn = timeIn;
			jumpData.timeOut = timeOut;
			jumpData.delay = delay;
			jumpData.delayOnStart = delayOnStart;
			jumpData.delayCount = delayCount;
			jumpData.goldFilter = goldFilter;
			jumpData.rotation = rotation;
			
			if(brightness != 0) {
				var filter:ColorMatrixFilter = new ColorMatrixFilter();
				filter.matrix = goldFilter ? getGoldBrightnessMatrix(1) : getBrightnessMatrix(1);
				displayObject.filter = gameManager.deactivated ? null : filter;
				displayObject.optionalFilter = true;
				jumpData.filter = filter;
			}
			
			jumpObjects[displayObject] = jumpData;
			
			jumpIn(displayObject, true);
		}
		
		public static function removeJump(view:DisplayObject, scaleToNormal:Boolean = true):void 
		{
			var data:JumpData = jumpObjects[view];
			
			if(!data)
				return;
			
			Tweener.removeTweens(view);
			
			if(data.minScale != data.maxScale && scaleToNormal)
				view.scale = data.minScale;
			
			if (!gameManager.deactivated || !PlatformServices.isIOS) 
			{
				if (view.filter == data.filter)
					view.filter = null;
			
				if(data.filter)
					data.filter.dispose();
			}
			
			delete jumpObjects[view];
		}
		
		public static function removeAllJumps():void {
			var view:*;
			for (view in jumpObjects) 
			{
				removeJump(view);
			}
			jumpObjects = new Dictionary();
		}
		
		public static function isJumping(view:DisplayObject):Boolean 
		{
			return view in jumpObjects;
		}
		
		private static function jumpIn(view:DisplayObject, init:Boolean = false):void
		{
			var data:JumpData = jumpObjects[view] as JumpData;
			var delay:Number = 0;
			
			if(init) {
				delay = data.delayOnStart;
			}
			else if(data.delay) 
			{
				if(data.delayCount > 1)
					delay = data.count % data.delayCount == 0 ? data.delay : 0;
				else
					delay = data.delay;
			}
			
			if(data.count > 0) {
				data.count--;
			}
			else if(data.count == 0) {
				removeJump(view);
				return;
			}
			
			if (!view.filter && data.filter && !gameManager.deactivated)
			{
				view.optionalFilter = true;
				view.filter = data.filter;
			}
			
			var properties:Object = {time:data.timeIn, onComplete:jumpOut, delay:delay, onCompleteParams:[view], transition:"linear"};
			properties[data.goldFilter ? "_brightGold" : "_bright"] = data.maxBrightness;
			if(data.minScale != data.maxScale)
				properties["scale"] = data.maxScale;
			
			if (!isNaN(data.rotation))
				properties["rotation"] = data.rotation;
			
			Tweener.addTween(view, properties);
		}
		
		private static function jumpOut(view:DisplayObject):void {
			var data:JumpData = jumpObjects[view] as JumpData;
			var properties:Object = {time:data.timeOut, onComplete:jumpIn, onCompleteParams:[view], transition:"linear" };
			
			properties[data.goldFilter ? "_brightGold" : "_bright"] = 1;
			
			if(data.minScale != data.maxScale)
				properties["scale"] = data.minScale;
			
			if (!isNaN(data.rotation))
				properties["rotation"] = 0;
				
			Tweener.addTween(view, properties);
		}
		
		private static function getBrightnessMatrix(value:Number):Vector.<Number> {
			return new <Number> [	
				value, 0, 0, 0, 0,
				0, value, 0, 0, 0,
				0, 0, value, 0, 0,
				0, 0, 0, 1, 0
			]
		}
		
		public static function getGoldBrightnessMatrix(value:Number):Vector.<Number> 
		{
			var subValue:Number = value - 1;		
			//trace("> ", value, subValue, 1 - 0.3*subValue, 1 - 0.6*subValue, 1*(1 - subValue));	
			return new <Number>[ 1 - 0.3*subValue, 0.5*subValue, 0.5*subValue, 0, 0,
								0.4*subValue, 1 - 0.6*subValue, 0.4*subValue, 0, 0,
								0, 0, 1*(1 - subValue), 0, 0,
								0, 0, 0, 1, 0];
		}
		
		//-------------------------------------------------------------------------
		//
		//  
		//
		//-------------------------------------------------------------------------
		
		public static function tweenAlphaVisibility(displayObject:DisplayObject, value:Boolean, time:Number = 0.4):void 
		{
			if(!displayObject) 
				return;
			
			if(value) {
				displayObject.visible = true;
				Starling.juggler.tween(displayObject, time, {alpha:1, transition:Transitions.EASE_IN});
			}
			else {
				displayObject.visible = false
				displayObject.alpha = 0;
			}
		}
		
		//-------------------------------------------------------------------------
		//
		//  blinkAlpha
		//
		//-------------------------------------------------------------------------
		
		public static function blinkAlpha(displayObject:DisplayObject, time:Number = 0.4, minAlpha:Number = 0, maxAlpha:Number = 1, delay:Number = 0, firstDelay:Number = 0):void 
		{
			if(!displayObject) 
				return;
			
			Starling.juggler.tween(displayObject, time, {delay:firstDelay, alpha:minAlpha, transition:Transitions.LINEAR, onComplete:blinkAlphaIn, onCompleteArgs:[displayObject, time, minAlpha, maxAlpha, delay]});
		}
		
		public static function removeBlinkAlpha(displayObject:DisplayObject):void 
		{
			Starling.juggler.removeTweens(displayObject);
		}
		
		private static function blinkAlphaIn(displayObject:DisplayObject, time:Number, minAlpha:Number, maxAlpha:Number, delay:Number = 0):void {
			Starling.juggler.tween(displayObject, time, {alpha:maxAlpha, transition:Transitions.LINEAR, onComplete:blinkAlphaOut, onCompleteArgs:[displayObject, time, minAlpha, maxAlpha, delay]});
		}
		
		private static function blinkAlphaOut(displayObject:DisplayObject, time:Number, minAlpha:Number, maxAlpha:Number, delay:Number = 0):void {
			Starling.juggler.tween(displayObject, time, {delay:delay, alpha:minAlpha, transition:Transitions.LINEAR, onComplete:blinkAlphaIn, onCompleteArgs:[displayObject, time, minAlpha, maxAlpha, delay]});
		}
		
		
		//-------------------------------------------------------------------------
		//
		//  scale jump
		//
		//-------------------------------------------------------------------------
		
		public static function scaleJumpAppearBase(view:DisplayObject, toScale:Number, time:Number = 0.6, delay:Number = 0, strength:Number = 1, onComplete:Function = null):void 
		{
			var tween_0:Tween = new Tween(view, 0.2*time, Transitions.EASE_OUT);
			var tween_1:Tween = new Tween(view, 0.8*time, Transitions.EASE_OUT_ELASTIC);
			
			tween_0.delay = delay;
			tween_0.animate('scale', toScale*1.2*strength);
			//tween_0.animate('alpha', 4);
			tween_0.nextTween = tween_1;
			
			tween_1.animate('scale', toScale);
			tween_1.onComplete = onComplete;
			
			view.scale = 0;
			
			Starling.juggler.add(tween_0);
		}
		
		public static function scaleJump(displayObject:DisplayObject, time:Number = 0.6, elastic:Boolean = true, delay:Number = 0, onComplete:Function = null):void 
		{
			var tweenScale_0:Tween = new Tween(displayObject, 0.15*time, Transitions.EASE_OUT);
			var tweenScale_1:Tween = new Tween(displayObject, 0.15*time, Transitions.EASE_OUT);
			var tweenScale_2:Tween = elastic ? new Tween(displayObject, 0.7*time, Transitions.EASE_OUT_ELASTIC) : new Tween(displayObject, 0.15*time, Transitions.EASE_OUT_BACK)//new Tween(displayObject, 0.7*time, elastic ? Transitions.EASE_OUT_ELASTIC : Transitions.EASE_OUT_BACK);
			
			displayObject.scaleY = 0;
			
			tweenScale_0.delay = delay;
			tweenScale_0.animate('scaleX', 1);
			tweenScale_0.animate('scaleY', 1.8);
			tweenScale_0.nextTween = tweenScale_1;
			
			tweenScale_1.animate('scaleX', 1.4);
			tweenScale_1.animate('scaleY', 0.6);
			tweenScale_1.nextTween = tweenScale_2;
			
			tweenScale_2.animate('scaleX', 1);
			tweenScale_2.animate('scaleY', 1);
			tweenScale_2.onComplete = onComplete;
			
			Starling.juggler.add(tweenScale_0);
		}
		
		public static function scaleJumpAppearElastic(displayObject:DisplayObject, toScale:Number, time:Number = 0.6, delay:Number = 0, strength:Number = 1, onComplete:Function = null):void 
		{
			var tweenScale_0:Tween = new Tween(displayObject, 0.2*time, Transitions.EASE_OUT);
			var tweenScale_1:Tween = new Tween(displayObject, 0.1*time, Transitions.EASE_OUT);
			var tweenScale_2:Tween = new Tween(displayObject, 0.7*time, Transitions.EASE_OUT_ELASTIC);
			
			tweenScale_0.delay = delay;
			tweenScale_0.animate('scaleX', 1.3 * toScale * strength);
			tweenScale_0.animate('scaleY', 1.3 * toScale * strength);
			tweenScale_0.nextTween = tweenScale_1;
			
			tweenScale_1.animate('scaleY', (0.7/strength) * toScale);
			//tweenScale_1.animate('scaleX', 1.3 * toScale * strength);
			tweenScale_1.nextTween = tweenScale_2;
			
			tweenScale_2.animate('scaleX', toScale);
			tweenScale_2.animate('scaleY', toScale);
			
			tweenScale_2.onComplete = onComplete;
			
			displayObject.scaleX = 0.5/strength;
			displayObject.scaleY = 0;
			
			Starling.juggler.add(tweenScale_0);
		}
		
		public static function scaleJumpDisappear(displayObject:DisplayObject, time:Number = 0.6, delay:Number = 0, onComplete:Function = null):void 
		{
			var tweenScale_0:Tween = new Tween(displayObject, 0.65 * time, Transitions.EASE_IN_BACK);
			var tweenScale_1:Tween = new Tween(displayObject, 0.35 * time, Transitions.EASE_OUT);
			
			tweenScale_0.delay = delay;
			tweenScale_0.animate('scaleX', 1.4 * displayObject.scale);
			tweenScale_0.animate('scaleY', 0.7 * displayObject.scale);
			tweenScale_0.nextTween = tweenScale_1;
			
			tweenScale_1.animate('scaleX', 0);
			tweenScale_1.animate('scaleY', 0);
			tweenScale_1.onComplete = onComplete;
			
			Starling.juggler.add(tweenScale_0);
		}
		
		//-------------------------------------------------------------------------
		//
		//  fullscreenSplash
		//
		//-------------------------------------------------------------------------
		
		private static var splashQuad:Quad;
		
		public static function showFullscreenSplash(container:DisplayObjectContainer, time:Number = 0.4, delay:Number = 0, color:uint = 0xFFFFFF):void 
		{
			clearFullscreenSplash();
			
			splashQuad = new Quad(10, 10, color);
			splashQuad.width = gameManager.layoutHelper.stageWidth;
			splashQuad.height = gameManager.layoutHelper.stageHeight;
			splashQuad.alignPivot();
			splashQuad.x = splashQuad.width/2;
			splashQuad.y = splashQuad.height/2;
			splashQuad.touchable = false;
			splashQuad.alpha = 0;
			container.addChild(splashQuad);
			
			var tween_0:Tween = new Tween(splashQuad, 0.05*time, Transitions.EASE_OUT_BACK);
			var tween_1:Tween = new Tween(splashQuad, 0.95*time, Transitions.EASE_OUT);
			
			tween_0.delay = delay;
			tween_0.animate('alpha', 1);
			//tween_0.onStart = childSplashScreen;
			//tween_0.onStartArgs = [container];
			tween_0.nextTween = tween_1;
			
			tween_1.animate('alpha', 0);
			tween_1.onComplete = clearFullscreenSplash;
			
			Starling.juggler.add(tween_0);
		}
		
		public static function clearFullscreenSplash():void 
		{
			if (splashQuad) {
				Starling.juggler.removeTweens(splashQuad);
				splashQuad.removeFromParent(true);
				splashQuad = null;
			}
		}
		
		private static function childSplashScreen(container:DisplayObjectContainer):void 
		{
			if(splashQuad)
				container.addChild(splashQuad);
		}
		
		//-------------------------------------------------------------------------
		//
		//  Particle explode color stars and squares with white rays flash
		//
		//-------------------------------------------------------------------------
		
		public static function showParticleColoredStarsAndSquares(container:DisplayObjectContainer, scale:Number, x:int, y:int):void 
		{
			var rays:Image = new Image(AtlasAsset.CommonAtlas.getTexture("effects/rays"));
			rays.alignPivot();
			rays.scale = 0;
			rays.x = x;
			rays.y = y;
			//rays.blendMode = BlendMode.ADD;
			container.addChild(rays);
			
			var tween_0:Tween = new Tween(rays, 0.1, Transitions.LINEAR);
			var tween_1:Tween = new Tween(rays, 0.17, Transitions.LINEAR);
			
			//tween_0.delay = delay;
			tween_0.animate('scale', scale*1.5);
			tween_0.nextTween = tween_1;
			
			//tween_1.delay = 0.1;
			tween_1.animate('scale', 0);
			tween_1.animate('rotation', Math.PI/4);
			tween_1.onComplete = callback_particleColoredStarsAndSquaresRaysComplete;
			tween_1.onCompleteArgs = [rays];
			
			Starling.juggler.add(tween_0);
			
			var colors:Vector.<uint> = new <uint> [0xFFFFFF,0x99FF00, 0xFF6600, 0x99FFFF, 0xFFFF00, 0x0055FD, 0xF99BE5];
			var particleEffect:ParticleExplosion = new ParticleExplosion(AtlasAsset.CommonAtlas, new <String> ["icons/star", 'icons/square', "icons/star"], colors);
			particleEffect.setProperties(0, 30*pxScale, 6.5, -0.02, 0.025, 0, 0.5);
			particleEffect.setFineProperties(0.5, 0.5, 0.2, 2, 0, 0);
			particleEffect.setAccelerationProperties(-0.19);
			particleEffect.x = x;
			particleEffect.y = y;
			particleEffect.scale = scale;
			container.addChild(particleEffect);
			particleEffect.play(170, 25, 10);
			
			particleEffect.addEventListener(Event.COMPLETE, handler_particleColoredStarsAndSquaresComplete);
		}
		
		private static function callback_particleColoredStarsAndSquaresRaysComplete(rays:Image):void 
		{
			rays.removeFromParent();
		}
		
		private static function handler_particleColoredStarsAndSquaresComplete(event:Event):void 
		{
			(event.target as DisplayObject).removeFromParent();
		}
		
		//-------------------------------------------------------------------------
		//
		//  Particle explode color stars and squares with white rays flash
		//
		//-------------------------------------------------------------------------
		
		public static const COLORED_STARS_SQUARES_LOZENGE_TYPE_MEDIUM:int = 0;
		public static const COLORED_STARS_SQUARES_LOZENGE_TYPE_BIG:int = 1;
		
		/**
		 * 
		 * @param type:int = 0 - размер эффекта в попугаях т.к. параметры подбираются эмпирически. Пока что 0 - обычный размер, 1 - побольше.
		 * 
		 * */
		public static function showParticleColoredStarsSquaresLozenge(container:DisplayObjectContainer, scale:Number, x:int, y:int, type:int = 0, childIndex:int = -1, countRatio:Number = 1):void 
		{
			if(childIndex <= -1)
				childIndex = container.numChildren;
				
			if (childIndex > container.numChildren)	
				childIndex = container.numChildren;
			
			var rays:Image = new Image(AtlasAsset.CommonAtlas.getTexture("effects/rays"));
			rays.alignPivot();
			rays.scale = 0;
			rays.x = x;
			rays.y = y;
			rays.touchable = false;
			//rays.blendMode = BlendMode.ADD;
			container.addChildAt(rays, childIndex);
			
			var tween_0:Tween = new Tween(rays, 0.10, Transitions.LINEAR);
			var tween_1:Tween = new Tween(rays, 0.11, Transitions.LINEAR);
			
			//tween_0.delay = delay;
			tween_0.animate('scale', scale * 2.0);
			tween_0.animate('rotation', Math.PI/8);
			tween_0.nextTween = tween_1;
			
			//tween_1.delay = 0.1;
			tween_1.animate('scale', 0);
			tween_1.animate('rotation', Math.PI/2);
			tween_1.onComplete = callback_particleColoredStarsSquaresLozengeRaysComplete;
			tween_1.onCompleteArgs = [rays];
			
			Starling.juggler.add(tween_0);
			
			var speed:Number;
			var scaleSpeed:Number;
			var maxCount:int;
			var speedAcceleration:Number;
			var startScale:Number;
			switch(type) {
				case COLORED_STARS_SQUARES_LOZENGE_TYPE_MEDIUM: {
					speed = 8.7;
					scaleSpeed = -0.021;
					maxCount = 17 * countRatio;
					speedAcceleration = -0.22;
					startScale = 1.1;
					break;
				}
				case COLORED_STARS_SQUARES_LOZENGE_TYPE_BIG: {
					speed = 18.2;
					scaleSpeed = -0.062;
					maxCount = 30 * countRatio;
					speedAcceleration = -0.71 - 0.07;
					startScale = 2.1;
					break;
				}
			}
			
			var colors:Vector.<uint> = new <uint> [0xFFFFFF,0x95E501, 0xFF6600, 0xFFEF00, 0x8EF3FF, 0xFFFF00/*, 0x0055FD, 0xF99BE5*/];
			var particleEffect:ParticleExplosion = new ParticleExplosion(AtlasAsset.CommonAtlas, new <String> ["icons/star", "icons/star", 'icons/square', "icons/lozenge"], colors);
			particleEffect.x = x;
			particleEffect.y = y;
			particleEffect.scale = scale;
			particleEffect.touchable = false;
			container.addChildAt(particleEffect, childIndex);
			particleEffect.addEventListener(Event.COMPLETE, handler_particleColoredStarsSquaresLozengeComplete);
		
			particleEffect.setProperties(0, 100*pxScale, speed, scaleSpeed, 0.01, 0, 0.3);
			particleEffect.setFineProperties(startScale, 0.1, 0.1, 1.2, 0.5, 4);
			particleEffect.setAccelerationProperties(speedAcceleration);
			//particleEffect.play(150, maxCount, maxCount);
			
			
			
			tween_0.onComplete = particleEffect.play;
			tween_0.onCompleteArgs = [150, maxCount, maxCount];
		}
		
		private static function callback_particleColoredStarsSquaresLozengeRaysComplete(rays:Image):void 
		{
			rays.removeFromParent();
		}
		
		private static function handler_particleColoredStarsSquaresLozengeComplete(event:Event):void 
		{
			(event.target as DisplayObject).removeFromParent();
		}
			
		//-------------------------------------------------------------------------
		//
		//  Many stars shine in Rect area
		//
		//-------------------------------------------------------------------------
		
		public static function showStarsShine(container:DisplayObjectContainer, areaRect:Rectangle, count:int = 1, nextDelay:Number = 0.3, time:Number = 0.3, scale:Number = 1):int
		{
			starsShineId++;
			
			var stars:Array = [];
			starsShines[starsShineId] = stars;
			
			var i:int;
			while (i < count) 
			{
				var star:Image = new Image(AtlasAsset.CommonAtlas.getTexture("effects/star"));
				star.alignPivot();
				star.scale = 0;
				star.x = areaRect.x + Math.random() * areaRect.width;
				star.y = areaRect.y + Math.random() * areaRect.height;
				star.blendMode = BlendMode.ADD;
				star.rotation = 2 * Math.PI * Math.random();
				container.addChild(star);
				
				var tween_0:Tween = new Tween(star, time*0.5, Transitions.EASE_IN);
				var tween_1:Tween = new Tween(star, time*0.5, Transitions.EASE_OUT);
				
				tween_0.delay = nextDelay * i;
				tween_0.animate('scale', scale * 1.2);
				tween_0.animate('rotation', star.rotation + Math.PI/4);
				tween_0.nextTween = tween_1;
				
				//tween_1.delay = 0.1;
				tween_1.animate('scale', 0);
				tween_1.animate('rotation', star.rotation + Math.PI/2);
				tween_1.onComplete = callback_StarShineComplete;
				tween_1.onCompleteArgs = [star];
				
				Starling.juggler.add(tween_0);
				i++;
				
				stars.push(star);
			}
			
			return starsShineId;
		}
		
		/**
		 * @param id:int == 0 удаляет все
		 * */
		public static function cleanStarsShine(id:int=0):void 
		{
			var stars:Array;
			var star:Image;
			
			if (id == 0) {
				for(id in starsShines) {
					stars = starsShines[id] as Array;
					while (stars.length > 0) {
						star = stars.shift();
						Starling.juggler.removeTweens(star);
						star.removeFromParent();
					}
					
					delete starsShines[id];
				}
			}
			else 
			{
				if (id in starsShines) {
					stars = starsShines[id] as Array;
					while (stars.length > 0) {
						star = stars.shift();
						Starling.juggler.removeTweens(star);
						star.removeFromParent();
					}
					delete starsShines[id];
				}
			}
		}
		
		private static var starsShines:Object = {};
		private static var starsShineId:int;
		
		private static function callback_StarShineComplete(star:Image):void 
		{
			star.removeFromParent();
		}
		
		//-------------------------------------------------------------------------
		//
		//  tweenAppearAndFly
		//
		//-------------------------------------------------------------------------
		
		public static function tweenAppearAndFly(container:DisplayObjectContainer, texture:Texture, start:Point, finish:Point, count:int = 1, nextDelay:Number = 0.3, time:Number = 0.3, scale:Number = 1):void
		{
			var i:int;
			
			var image:Image = new Image(texture);
			image.alignPivot();
			image.scale = 0;
			image.x = start.x;
			image.y = start.y;
			//image.blendMode = BlendMode.ADD;
			//image.rotation = 2 * Math.PI * Math.random();
			container.addChild(image);
			
			var tween_0:Tween = new Tween(image, 0.3, Transitions.EASE_OUT_BACK);
			var tween_1:Tween = new Tween(image, 0.5, Transitions.EASE_OUT);
			var tween_2:Tween = new Tween(image, 0.2, Transitions.EASE_IN_BACK);
			var tween_3:Tween = new Tween(image, 0.3, Transitions.LINEAR);
			
			//tween_0.delay = nextDelay * i;
			tween_0.animate('scale', 1);
			//tween_0.animate('rotation', image.rotation + Math.PI/4);
			tween_0.nextTween = tween_1;
			
			//tween_1.delay = 0.1;
			tween_1.moveTo(finish.x, finish.y);
			tween_1.animate('scale', 1.3);
			tween_1.nextTween = tween_2;
			
			tween_2.animate('scale', 1);
			tween_2.nextTween = tween_3;
			
			
			var filter:ColorMatrixFilter = new ColorMatrixFilter();
			filter.matrix = getBrightnessMatrix(1);
			image.optionalFilter = true;
			image.filter = filter;
			
			tween_3.animate('alpha', 0);
			//tween_3.animate('alpha', 0);
			
			//tween_1.animate('rotation', image.rotation + Math.PI/2);
			//tween_1.onComplete = callback_imageShineComplete;
			//tween_1.onCompleteArgs = [image];
			
			Starling.juggler.add(tween_0);
		}
		
		//-------------------------------------------------------------------------
		//
		//  
		//
		//-------------------------------------------------------------------------
		
		
		public static function particlesBezierTween(container:DisplayObjectContainer, scale:Number, iconTexture:Texture, sourcePoint:Point, targetPoint:Point, particlesCount:int, startRandomAmplitudes:Point):void
		{
			var startPoint:Point;
			var iconImage:Image;
			
			while (--particlesCount > 0)
			{	
				iconImage = new Image(iconTexture);
				iconImage.scale = 0.1;
				iconImage.alignPivot();
				container.addChild(iconImage);
				
				startPoint = new Point(sourcePoint.x + startRandomAmplitudes.x * Math.random() * scale, sourcePoint.y + startRandomAmplitudes.y * Math.random() * scale);
				
				iconImage.x = startPoint.x;
				iconImage.y = startPoint.y;
				
				var tweenTime:Number = Math.random() * 0.8 + 0.8;
				
				Starling.juggler.tween(iconImage, tweenTime / 2, {scale: Math.random() * 1.5 + 0.2});
				Starling.juggler.tween(iconImage, tweenTime / 2, {scale: 0.7, delay: tweenTime / 2});
				
				var anchorPoints:Vector.<Point> = new Vector.<Point>();
				anchorPoints.push(startPoint);
				anchorPoints.push(startPoint.add(new Point(Math.random() * 400 * pxScale * scale - 100 * pxScale * scale, Math.random() * 600 * pxScale * scale - 300 * pxScale * scale)));
				anchorPoints.push(targetPoint);
				var tween:BezierTween = new BezierTween(iconImage, tweenTime, anchorPoints, BezierTween.SPEED_DEFAULT, BezierTween.ACCURACY_FINE, Transitions.LINEAR);
				tween.delay = Math.random() * 0.1;
				tween.onComplete = removeParticle;
				tween.onCompleteArgs = [tween, iconImage];
				Starling.juggler.add(tween);
			}
		}
		
		public static function removeParticle(tween:Tween, particle:DisplayObject):void
		{
			Starling.juggler.remove(tween);
			particle.removeFromParent();
		}
		
		//-------------------------------------------------------------------------
		//
		// Flash to gray effect 
		//
		//-------------------------------------------------------------------------
		
		public static function flashToGrayscale(view:DisplayObject, time:Number = 0):void
		{
			var flashToGrayscaleItem:FlashToGrayscaleItem = new FlashToGrayscaleItem(view);
			flashToGrayscaleItem.play(time);
		}
		
		//-------------------------------------------------------------------------
		//
		//  
		//
		//-------------------------------------------------------------------------
		
		public static function animateIntHelper(from:int, to:int, updateFunction:Function, time:Number = 0, delay:Number = 0, transition:String = null):uint
		{
			return new AnimateIntHelper(updateFunction).animate(from, to, time, delay, transition);
		}
		
		//-------------------------------------------------------------------------
		//
		//  
		//
		//-------------------------------------------------------------------------
		
		public static function getConfettiParticleExplosion():ParticleExplosion 
		{
			var colors:Vector.<uint> = new <uint> [0x8BE902/*green*/,0xE80C72/*pink*/, 0x17D0FF/*blue*/, 0xFFFF00/*yellow*/, 0xDA89EB/*purple*/];
			var particleEffect:ParticleExplosion = new ParticleExplosion(AtlasAsset.CommonAtlas, new <String> ["effects/square_white"], colors);
			particleEffect.setProperties(0, 0, 9, -0.007, 0.08, 0, 0.4);
			particleEffect.setFineProperties(1.0, 0.8, 0.4, 1.5, 0, 0);
			particleEffect.setDirectionAngleProperties(0.03, 20, 0.1);
			particleEffect.onlyPositiveSpeed = true;
			particleEffect.setAccelerationProperties(-0.13);	
			particleEffect.gravityAcceleration = 0.07;
			particleEffect.skewAplitude = 0.2;
			//particleEffect.setEmitDirectionAngleProperties(1, Math.PI/2, 280 * Math.PI / 180);
			//particleEffect.play(350, 90, 90);
			return particleEffect;
		}
		
		//-------------------------------------------------------------------------
		//
		//  
		//
		//-------------------------------------------------------------------------
		
		public static function showScreenText(text:String):void
		{
			if (text == null || text == '')
				return;
				
			var point:Point = new Point(layoutHelper.stageWidth / 2, layoutHelper.stageHeight / 2);
			new ShowNoMoneyPopup(ShowNoMoneyPopup.RED, Starling.current.stage, point, text, false, 900).execute();
		}
		
		//-------------------------------------------------------------------------
		//
		//  
		//
		//-------------------------------------------------------------------------	
	}
}

import com.alisacasino.bingo.assets.AtlasAsset;
import flash.geom.Rectangle;
import starling.animation.Transitions;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.filters.ColorMatrixFilter;
import starling.utils.TweenHelper;

final class JumpData 
{
	public function JumpData()  {
	}
	public var filter:ColorMatrixFilter;
	public var maxBrightness:Number = 0;
	public var count:int = -1;
	//public var scale:Number = 1;
	public var minScale:Number = 1;
	public var maxScale:Number = 1;
	public var timeIn:Number = 0.7;
	public var timeOut:Number = 1;
	public var delay:Number = 0;
	public var delayOnStart:Number = 0;
	public var delayCount:int;
	public var goldFilter:Boolean;
	public var rotation:Number = 0;
}

class FlashToGrayscaleItem 
{
	public var view:DisplayObject;
	public var filter:ColorMatrixFilter;
	
	private var _saturation:Number = 0;
	private var _brightness:Number = 0;
	
	public function FlashToGrayscaleItem(view:DisplayObject) {
		this.view = view;
	}
	
	public function play(time:Number = 0):void 
	{
		if (!filter)
			filter = new ColorMatrixFilter();
			
		view.filter = filter;
		
		if (time > 0) 
		{
			TweenHelper.tween(this, time, { saturation:-1, transition:Transitions.EASE_OUT} )
			//TweenHelper.tween(this, time*0.25, { saturation: 1brightness:0.2, transition:Transitions.LINEAR} )
				//.chain(this, time*0.75, {saturation: -1/*, brightness:-0.2*/, transition:Transitions.LINEAR} );
		}
		else {
			saturation = -1;
		}
	}
					
	public function set saturation(value:Number):void {
		_saturation = value;
		if (filter)
			filter.adjustSaturation(_saturation);
	}
	
	public function get saturation():Number {
		return _saturation;
	}
	
	public function set brightness(value:Number):void {
		//trace('>>', value, _brightness);
		_brightness = value;
		if (filter) {
			filter.adjustBrightness(_brightness);
			view.optionalFilter = true;
			view.filter = filter;
			//trace('>1111>', _brightness);
		}	
	}
	
	public function get brightness():Number {
		return _brightness;
	}
		
}

class AnimateIntHelper
{
	private var updateFunction:Function;
	private var _value:int;
	
	public function AnimateIntHelper(updateFunction:Function) {
		this.updateFunction = updateFunction;
	}
	
	public function animate(from:int, to:int, time:Number = 0, delay:Number = 0, transition:String = null):uint {
		_value = from;
		return Starling.juggler.tween(this, time, {delay:delay, value:to, transition:(transition || Transitions.LINEAR)});
	}
	
	public function set value(v:int):void {
		if (_value == v)
			return;
			
		_value = v;
		updateFunction(_value);
	}
	
	public function get value():int {
		return _value;
	}
}
