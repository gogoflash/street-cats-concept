package com.alisacasino.bingo.screens.gameScreenClasses 
{
	import adobe.utils.CustomActions;
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.tweens.BezierTween;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.Align;
	import starling.utils.TweenHelper;
	
	public class ScreenCatScooter 
	{
		public function ScreenCatScooter() 
		{
			backContainer = new Sprite();
			frontContainer = new Sprite();
			stripsContainer = new Sprite();
			colorQuads = new <Quad>[];
			cacheStripsWidthAlpha = new <Image>[];	
			cacheStrips = new <Image>[];
			stageHeight = layoutHelper.stageHeight;
			stageWidth = layoutHelper.stageWidth;
			
			stripsContainer.addEventListener(Event.ENTER_FRAME, handler_enterFrame);
		}
		
		public static var stripsTweenTime:Number = 0.4;
		public static var catScooterScale:Number = 0.9;
		
		private var backContainer:Sprite;
		private var stripsContainer:Sprite;
		private var frontContainer:Sprite;
		
		
		private var quadFade:Quad;
		private var colorQuads:Vector.<Quad>;
		
		private var stageHeight:int;
		private var stageWidth:int;
		
		private var stripsVelocity:Number;
		
		private var timeToShowStrip:int;
		private var timeToShowStripWithAlpha:int;
		private var cacheStripsWidthAlpha:Vector.<Image>;	
		private var cacheStrips:Vector.<Image>;	
		
		private var completeStripsCreation:Boolean;
		
		
		public function show(container:DisplayObjectContainer):void
		{
			container.addChild(backContainer);
			container.addChild(stripsContainer);
			container.addChild(frontContainer);
			
			quadFade = new Quad(1, 1, 0x000000);
			quadFade.width = stageWidth;
			quadFade.height = stageHeight;
			quadFade.alpha = 0;
			backContainer.addChild(quadFade);
			Starling.juggler.tween(quadFade, 0.5, {delay:0.2, alpha:1});
			
			var quad:Quad;
			
			quad = addColorQuad(0x003C93);
			TweenHelper.tween(quad, 0.1, { height:0.93 * stageHeight})
				.chain(quad, 0.16, {height:0.519 * stageHeight})
				.chain(quad, 0.2, {height:0.885 * stageHeight, onComplete:cycleJump, onCompleteArgs:[quad, 0.87* stageHeight, 0.08]});
			
			
			quad = addColorQuad(0x4A9BFF);
			TweenHelper.tween(quad, 0.13, {delay:0.1, height:0.7 * stageHeight})
				.chain(quad, 0.16, {height:0.815 * stageHeight})
				.chain(quad, 0.2, {height:0.6 * stageHeight, onComplete:cycleJump, onCompleteArgs:[quad, 0.58* stageHeight, 0.08]});
			
			
			quad = addColorQuad(0xFFFFFF);
			TweenHelper.tween(quad, 0.12, {delay:0.26, height:0.476 * stageHeight})
				.chain(quad, 0.13, {height:0.18 * stageHeight})
				.chain(quad, 0.16, {height:0.265 * stageHeight, onComplete:cycleJump, onCompleteArgs:[quad, 0.23 * stageHeight, 0.06]});
			
			var animation:AnimationContainer = new AnimationContainer(MovieClipAsset.PackCommon, true, true);
			animation.x = stageWidth/2;
			animation.y = stageHeight/2;
			animation.scale = /*(1/0.7) **/ layoutHelper.independentScaleFromEtalonMin * catScooterScale;
			frontContainer.addChild(animation);
			animation.playTimeline('cat_scooter', false, true);
			
			if(Room.current.stakeData.multiplier == 5)
				SoundManager.instance.playSfx(SoundAsset.CatMoto, 0.0);
			else
				SoundManager.instance.playSfx(SoundAsset.CatMotoNoMeow, 0.0);
			
			animation.dispatchOnCompleteTimeline = true;
			animation.addEventListener(AnimationContainer.EVENT_COMPLETE_TIMELINE, handler_animationComplete);
			
			Starling.juggler.delayCall(completeQuadTweens, 1.9);
			
			timeToShowStripWithAlpha = getTimer() + 450;
			
			stripsVelocity = stageWidth / (60 * stripsTweenTime);
			
			var stageCenterX:int = stageWidth / 2;
			var stageCenterY:int = stageHeight / 2;
			var dropImageCoeff:Number = layoutHelper.independentScaleFromEtalonMin * catScooterScale * pxScale;
			
			switch (Room.current.stakeData.scorePowerupsDropped) 
			{
				case 2: {
					dropImageBezier(stageCenterX + 300*dropImageCoeff, stageCenterY - 88*dropImageCoeff, stageWidth + 120*pxScale, getPowerupDropfinishY(), 0.8);
					dropImageBezier(stageCenterX + 345*dropImageCoeff, stageCenterY - 75*dropImageCoeff, stageWidth + 120*pxScale, getPowerupDropfinishY(), 1.25);
					break;
				}
				case 3: {
					dropImageBezier(stageCenterX + 5*dropImageCoeff, stageCenterY - 93*dropImageCoeff, stageWidth + 120*pxScale, getPowerupDropfinishY(), 0.4);
					dropImageBezier(stageCenterX + 300*dropImageCoeff, stageCenterY - 88*dropImageCoeff, stageWidth + 120*pxScale, getPowerupDropfinishY(), 0.8);
					dropImageBezier(stageCenterX + 345*dropImageCoeff, stageCenterY - 75*dropImageCoeff, stageWidth + 120*pxScale, getPowerupDropfinishY(), 1.25);
					break;
				}
				case 5: {
					dropImageBezier(stageCenterX + 5*dropImageCoeff, stageCenterY - 93*dropImageCoeff, stageWidth + 120*pxScale, getPowerupDropfinishY(), 0.4);
					dropImageBezier(stageCenterX + 300*dropImageCoeff, stageCenterY - 88*dropImageCoeff, stageWidth + 120*pxScale, getPowerupDropfinishY(), 0.7);
					dropImageBezier(stageCenterX + 345*dropImageCoeff, stageCenterY - 75*dropImageCoeff, stageWidth + 120*pxScale, getPowerupDropfinishY(), 0.9);
					dropImageBezier(stageCenterX + 300*dropImageCoeff, stageCenterY - 88*dropImageCoeff, stageWidth + 120*pxScale, getPowerupDropfinishY(), 1.1);
					dropImageBezier(stageCenterX + 345*dropImageCoeff, stageCenterY - 75 * dropImageCoeff, stageWidth + 120 * pxScale, getPowerupDropfinishY(), 1.25);
					break;
				}
				default: {
					dropImageBezier(stageCenterX + 5*dropImageCoeff, stageCenterY - 93*dropImageCoeff, stageWidth + 120*pxScale, getPowerupDropfinishY(), 0.4);
					dropImageBezier(stageCenterX + 300*dropImageCoeff, stageCenterY - 88*dropImageCoeff, stageWidth + 120*pxScale, getPowerupDropfinishY(), 0.8);
					dropImageBezier(stageCenterX + 345*dropImageCoeff, stageCenterY - 75*dropImageCoeff, stageWidth + 120*pxScale, getPowerupDropfinishY(), 1.25);
				}
			}
		}
		
		private function getPowerupDropfinishY():int
		{
			return (0.03 + 0.27 * Math.random()) * stageHeight;
		}
		
		private function completeQuadTweens():void
		{
			Starling.juggler.tween(quadFade, 0.13, {alpha:0, onComplete:removeView, onCompleteArgs:[quadFade]});
			
			var quad:Quad;
			while (colorQuads.length > 0) {
				quad = colorQuads.pop();
				Starling.juggler.removeTweens(quad);
				Starling.juggler.tween(quad, 0.08, {height:0, onComplete:removeView, onCompleteArgs:[backContainer]});
			}
			
			completeStripsCreation = true;
		}
		
		private function removeView(displayObject:DisplayObject):void
		{
			displayObject.removeFromParent(true);
		}
		
		private function handler_animationComplete(e:Event):void 
		{
			var animationContainer:AnimationContainer = e.target as AnimationContainer; 
			animationContainer.stop();
			animationContainer.removeFromParent(true);
			
			frontContainer.removeFromParent();
			frontContainer = null;
		}
		
		private function addColorQuad(color:uint):Quad
		{
			var quad:Quad = new Quad(1, 1, color);
			quad.width = stageWidth;
			quad.alignPivot(Align.LEFT, Align.CENTER);
			quad.height = 0;
			quad.y = stageHeight / 2;
			
			colorQuads.push(quad);
			backContainer.addChild(quad);
			
			return quad;
		}	
		
		private function cycleJump(quad:Quad, height:int, time:Number):void 
		{
			Starling.juggler.tween(quad, time, {height:height, reverse:true, repeatCount:0});
		}
		
		private function handler_enterFrame(event:Event):void 
		{
			var i:int;
			var length:int = stripsContainer.numChildren;
			while (i < length) 
			{
				image = stripsContainer.getChildAt(i) as Image;
				if (image.x > stageWidth) 
				{
					stripsContainer.removeChildAt(i);
					length--;
					if (image.name == '1')
						cacheStripsWidthAlpha.push(image);
					else
						cacheStrips.push(image);
				}
				else {
					image.x += stripsVelocity;
					i++
				}
			}
			
			if (completeStripsCreation) 
			{
				if (length == 0) 
				{
					stripsContainer.removeEventListener(Event.ENTER_FRAME, handler_enterFrame);
					cacheStripsWidthAlpha = null;
					cacheStrips = null;	
					stripsContainer.removeFromParent(true);
					stripsContainer = null;
				}
				return;
			}
			
			var image:Image;
			var timerValue:int = getTimer();
			var heightAmplitude:int;
			if (timerValue > timeToShowStrip) 
			{
				image = addBlueStrip(false);
				image.x = -image.width / 2;
				
				var random:Number = Math.random();
				if (random > 0.6) {
					heightAmplitude = 0.19 * stageHeight;
					image.y = (stageHeight - heightAmplitude) * 0.5 + Math.random() * heightAmplitude;
				}
				else {
					heightAmplitude = 0.15 * stageHeight;
					
					if(random > 0.3) 
						image.y = 0.208 * stageHeight + Math.random() * heightAmplitude;
					else
						image.y = 0.615 * stageHeight + Math.random() * heightAmplitude;
				}
					
				timeToShowStrip = timerValue + 150 + Math.random() * 250;
			}
			
			if (timerValue > timeToShowStripWithAlpha) 
			{
				heightAmplitude = (0.885 - 0.6) * stageHeight * 0.5 - 20*pxScale;
				image = addBlueStrip(true);
				image.scale = (1.0 + Math.random() * 0.7) * layoutHelper.independentScaleFromEtalonMin;
				image.x = -image.width / 2 - Math.random()*300 * pxScale;
				image.y = (1 - 0.885) * 0.5 * stageHeight + Math.random() * heightAmplitude;
				
				
				image = addBlueStrip(true);
				image.scale = (1.0 + Math.random() * 0.7) * layoutHelper.independentScaleFromEtalonMin;
				image.x = -image.width / 2// - 20 * pxScale;
				image.y =  stageHeight*0.5 + 0.6 * stageHeight*0.5 + Math.random() * heightAmplitude;
				
				timeToShowStripWithAlpha = timerValue + 150 + Math.random() * 150;
			}
		}
		
		
		private function addBlueStrip(withAlpha:Boolean):Image
		{
			var image:Image;
			var cache:Vector.<Image> = withAlpha ? cacheStripsWidthAlpha : cacheStrips;
			if (cache.length > 0) {
				image = cache.pop();
			}
			else 
			{
				if (withAlpha) {
					image = new Image(AtlasAsset.CommonAtlas.getTexture('effects/strip_blue'));
					image.name = '1';
				}
				else {
					image = new Image(AtlasAsset.CommonAtlas.getTexture('effects/ball_blue'));
					image.scale9Grid = ResizeUtils.getScaledRect(12, 0, 2, 0);
				}
			}
			
			if (withAlpha) {
				//image.width = layoutHelper.stageWidth*0.8;
				//image.height = HEIGHT;
			}
			else {
				image.width = stageWidth*0.8;
				image.height = (Math.random() > 0.7 ? 10 : 24)*pxScale*layoutHelper.independentScaleFromEtalonMin;
			}
			
			stripsContainer.addChildAt(image, 0);
			
			return image;
		}	
		
		private function dropImageBezier(startX:int, startY:int, finishX:int, finishY:int, delay:Number):void 
		{
			var image:Image = new Image(AtlasAsset.CommonAtlas.getTexture('card/powerups/score'));
			image.scale = 0.45*layoutHelper.independentScaleFromEtalonMin;
			image.alpha = 0;
			image.alignPivot();
			image.x = startX;
			image.y = startY;
			var bezierTween:BezierTween = new BezierTween(image, (finishX - startX) / 1000, new <Point>[new Point(startX* pxScale, startY * pxScale), new Point((startX + (finishX - startX)/2) * pxScale, (finishY 
			) * pxScale), new Point(finishX, finishY)], BezierTween.SPEED_DEFAULT, BezierTween.ACCURACY_FINE, Transitions.LINEAR);
			bezierTween.delay = delay;
			bezierTween.animate('alpha', 10);
			bezierTween.animate('scale', 1.4*layoutHelper.independentScaleFromEtalonMin);
			
			Starling.juggler.add(bezierTween);
			
			frontContainer.addChild(image);
			
			if (marksFlySounds.length == 0) 
				marksFlySounds = new <SoundAsset> [SoundAsset.MarksFly_01, SoundAsset.MarksFly_02, SoundAsset.MarksFly_03, SoundAsset.MarksFly_04];
			
			var soundAsset:SoundAsset = marksFlySounds.splice(Math.floor(marksFlySounds.length * Math.random()), 1)[0] ;	
			SoundManager.instance.playSfx(soundAsset, delay);
		}
		
		private var marksFlySounds:Vector.<SoundAsset> = new <SoundAsset>[];
	}
}