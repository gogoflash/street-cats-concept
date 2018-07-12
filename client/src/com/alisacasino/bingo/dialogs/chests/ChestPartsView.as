package com.alisacasino.bingo.dialogs.chests
{
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.components.AlertSignView;
	import com.alisacasino.bingo.components.effects.ParticleExplosion;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import flash.geom.Point;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.Align;
	import starling.textures.Texture;
	import starling.display.Image;
	
	public class ChestPartsView extends Sprite
	{
		public static var STATE_CHEST_PRE_JUMP:String = 'STATE_CHEST_PRE_JUMP';
		
		public var data:*;
		
		private var topImage:Image;
		private var bottomImage:Image;
		private var chestType:int;
		
		private var initState:String;
		
		private var bottomX:int;
		private var bottomY:int;
		
		private var jumpDelayCallId:int = -1;
		
		private var jumpsCount:int = 0;
		private var maxJumpsCount:int = 3;
		
		private var _baseScale:Number = 1;
		private var shiftX:Number;
		private var shiftY:Number;
		
		private var superchestGlowImage:Image;
		private var superchestGlowContourImage:Image;
		private var superchestGlowKeyholeImage:Image;
		private var superchestShadowImage:Image;
		private var superchestParticles:ParticleExplosion;
		private var superchestStarsParticles:ParticleExplosion;
		
		public function ChestPartsView(chestType:int, baseScale:Number = 1, initState:String = null, shiftX:Number = 0, shiftY:Number = 0) {
			this.chestType = chestType;
			_baseScale = baseScale;
			this.initState = initState;
			this.shiftX = shiftX * pxScale;
			this.shiftY = shiftY * pxScale;
			
			initialize();
		}
		
		public function get baseScale():Number{
			return _baseScale;
		}
		
		override public function get scale():Number{
			return super.scale / _baseScale;
		}
		
		override public function set scaleX(value:Number):void {
			super.scaleX = value * _baseScale;
		}
		
		override public function get scaleX():Number{
			return super.scaleX / _baseScale;
		}
		
		override public function set scaleY(value:Number):void {
			super.scaleY = value * _baseScale;
		}
		
		override public function get scaleY():Number{
			return super.scaleY / _baseScale;
		}
		
		public function set type(value:int):void {
			if (chestType == value)
				return;
				
			chestType = value;	
			Starling.juggler.removeTweens(topImage);
			Starling.juggler.removeTweens(bottomImage);	
			initialize();
		}
		
		public function get type():int {
			return chestType;
		}		
		
		private function initialize():void 
		{
			var topTexture:String;
			var bottomTexture:String;
			var localShiftY:int;
			
			bottomX = 1* pxScale + shiftX;
			bottomY = 65* pxScale + shiftY;
			
			switch(chestType) {
				case ChestType.BRONZE: {
					topTexture = 'dialogs/chest/chest_bronze_top';
					bottomTexture = 'dialogs/chest/chest_bronze_bottom';
					bottomX = 1* pxScale + shiftX;
					bottomY = 56 * pxScale + shiftY;
					localShiftY = -5;
					break;
				}
				case ChestType.SILVER: {
					topTexture = 'dialogs/chest/chest_silver_top';
					bottomTexture = 'dialogs/chest/chest_silver_bottom';
					bottomX = 1* pxScale + shiftX;
					bottomY = 65* pxScale + shiftY;
					break;
				}
				case ChestType.GOLD: {
					topTexture = 'dialogs/chest/chest_gold_top';
					bottomTexture = 'dialogs/chest/chest_gold_bottom';
					bottomX = 2* pxScale + shiftX;
					bottomY = 66* pxScale + shiftY;
					break;
				}
				case ChestType.PREMIUM:
				case ChestType.SUPER: {
					topTexture = 'dialogs/chest/chest_super_top';
					bottomTexture = 'dialogs/chest/chest_super_bottom';
					bottomX = 1* pxScale + shiftX;
					bottomY = 79 * pxScale + shiftY;
					localShiftY = 15 * pxScale;
					break;
				}
			}
			
			if (!bottomImage) {
				bottomImage = new Image(AtlasAsset.CommonAtlas.getTexture(bottomTexture));
				addChild(bottomImage);
			}
			else {
				bottomImage.texture = AtlasAsset.CommonAtlas.getTexture(bottomTexture);
				bottomImage.readjustSize();
			}
			bottomImage.alignPivot();
			bottomImage.pivotY = bottomImage.height/2 + localShiftY;
			bottomImage.x = bottomX;
			bottomImage.y = bottomY;
			
			if (!topImage) {
				topImage = new Image(AtlasAsset.CommonAtlas.getTexture(topTexture));
				addChild(topImage);
			}
			else {
				topImage.texture = AtlasAsset.CommonAtlas.getTexture(topTexture);
				topImage.readjustSize();
			}
			
			topImage.alignPivot();
			topImage.pivotY = topImage.height / 2 + localShiftY;
			topImage.x = shiftX;
			topImage.y = shiftY;
			
			
			if (initState == STATE_CHEST_PRE_JUMP) {
				topImage.alpha = 0;
				bottomImage.alpha = 0;
				topImage.scaleX = 0.77;
				topImage.scaleY = 1.1;
				bottomImage.scaleX = 0.77;
				bottomImage.scaleY = 1.1;
				
				topImage.y = 33 * pxScale + shiftY; 
				bottomImage.y = bottomY + 33 * pxScale;
			}
			
			scale = _baseScale;
		}
		
		public function show(delay:Number):void
		{
			//return;
			if (initState == STATE_CHEST_PRE_JUMP) {
				var tweenTop_1:Tween = new Tween(topImage, 0.13, Transitions.EASE_OUT);
				var tweenTop_2:Tween = new Tween(topImage, 0.15, Transitions.EASE_OUT);
				var tweenTop_3:Tween = new Tween(topImage, 0.15, Transitions.EASE_OUT_BACK);
				
				var tweenBottom_1:Tween = new Tween(bottomImage, 0.15, Transitions.EASE_OUT);
				var tweenBottom_2:Tween = new Tween(bottomImage, 0.1, Transitions.EASE_OUT);
				var tweenBottom_3:Tween = new Tween(bottomImage, 0.15, Transitions.EASE_OUT_BACK);
				
				tweenTop_1.delay = delay;
				tweenTop_1.animate('scaleX', 0.86);
				tweenTop_1.animate('scaleY', 1.2);
				tweenTop_1.animate('y', shiftY-40 * pxScale);
				tweenTop_1.animate('alpha', 30);
				tweenTop_1.nextTween = tweenTop_2;
				
				tweenTop_2.animate('scaleX', 1.12);
				tweenTop_2.animate('scaleY', 0.92);
				tweenTop_2.animate('y', shiftY+43 * pxScale);
				tweenTop_2.nextTween = tweenTop_3;
				//tweenTop_2.onStart = SoundManager.instance.playSfx;
				//tweenTop_2.onStartArgs = [SoundAsset.ChestClickHit];
				
				tweenTop_3.animate('scaleX', 1);
				tweenTop_3.animate('scaleY', 1);
				tweenTop_3.animate('y', shiftY);
				
				tweenBottom_1.delay = delay;
				tweenBottom_1.animate('scaleX', 0.96);
				tweenBottom_1.animate('scaleY', 1.1);
				tweenBottom_1.animate('y', bottomY + 5 * pxScale);
				tweenBottom_1.animate('alpha', 30);
				tweenBottom_1.nextTween = tweenBottom_2;
				
				tweenBottom_2.animate('scaleX', 1.12);
				tweenBottom_2.animate('scaleY', 0.92);
				tweenBottom_2.animate('y', bottomY + 33 * pxScale);
				tweenBottom_2.nextTween = tweenBottom_3;
				
				tweenBottom_3.animate('scaleX', 1);
				tweenBottom_3.animate('scaleY', 1);
				tweenBottom_3.animate('y', bottomY);
				
				Starling.juggler.add(tweenTop_1);
				Starling.juggler.add(tweenBottom_1);	
			
				jumpsCount++;
			}
			
			jumpDelayCallId = Starling.juggler.delayCall(jump, delay + 1.0, 0);
		}
		
		public function hide(delay:Number):void
		{
			if(jumpDelayCallId >= 0)
				Starling.juggler.removeByID(jumpDelayCallId);
				
			Starling.juggler.removeTweens(topImage);
			Starling.juggler.removeTweens(bottomImage);
			
			var tweenTop_1:Tween = new Tween(topImage, 0.05, Transitions.EASE_OUT);
			tweenTop_1.animate('y', shiftY + 90 * pxScale);
			tweenTop_1.animate('alpha', 0);
			
			var tweenBottom_1:Tween = new Tween(bottomImage, 0.05, Transitions.EASE_OUT);
			tweenBottom_1.animate('y', bottomY + 100 * pxScale);
			tweenBottom_1.animate('alpha', 0);
			
			Starling.juggler.tween(topImage, 0.3, {transition:Transitions.EASE_IN_BACK, delay:delay, scaleX:0.2, y:(shiftY + 60*pxScale), nextTween:tweenTop_1});
			Starling.juggler.tween(bottomImage, 0.3, {transition:Transitions.EASE_IN_BACK, delay:delay, scaleX:0.2, y:(bottomY + 70*pxScale), nextTween:tweenBottom_1});
		}
		
		public function jump(delay:Number, playSound:Boolean = true):void
		{
			var tweenTop_1:Tween = new Tween(topImage, 0.15, Transitions.EASE_OUT);
			var tweenTop_2:Tween = new Tween(topImage, 0.2, Transitions.EASE_OUT);
			var tweenTop_3:Tween = new Tween(topImage, 0.2, Transitions.EASE_OUT_BACK);
			
			var tweenBottom_1:Tween = new Tween(bottomImage, 0.15, Transitions.EASE_OUT);
			var tweenBottom_2:Tween = new Tween(bottomImage, 0.19, Transitions.EASE_OUT);
			var tweenBottom_3:Tween = new Tween(bottomImage, 0.23, Transitions.EASE_OUT_BACK);
			
			tweenTop_1.delay = delay;
			tweenTop_1.animate('scaleX', 0.86);
			tweenTop_1.animate('scaleY', 1.1);
			tweenTop_1.animate('y', shiftY-36 * pxScale);
			tweenTop_1.nextTween = tweenTop_2;
			
			tweenTop_2.animate('scaleX', 1.12);
			tweenTop_2.animate('scaleY', 0.92);
			tweenTop_2.animate('y', shiftY+22 * pxScale);
			tweenTop_2.nextTween = tweenTop_3;
			if (playSound) {
				tweenTop_2.onStart = SoundManager.instance.playSfx;
				tweenTop_2.onStartArgs = [SoundAsset.ChestClickHit];
			}
			
			tweenTop_3.animate('scaleX', 1);
			tweenTop_3.animate('scaleY', 1);
			tweenTop_3.animate('y', shiftY);
			
			tweenBottom_1.delay = delay;
			tweenBottom_1.animate('scaleX', 0.86);
			tweenBottom_1.animate('scaleY', 1.1);
			tweenBottom_1.animate('y', bottomY -20 * pxScale);
			tweenBottom_1.nextTween = tweenBottom_2;
			
			tweenBottom_2.animate('scaleX', 1.12);
			tweenBottom_2.animate('scaleY', 0.92);
			tweenBottom_2.animate('y', bottomY + 10 * pxScale);
			tweenBottom_2.nextTween = tweenBottom_3;
			
			tweenBottom_3.animate('scaleX', 1);
			tweenBottom_3.animate('scaleY', 1);
			tweenBottom_3.animate('y', bottomY);
			
			Starling.juggler.add(tweenTop_1);
			Starling.juggler.add(tweenBottom_1);	
			
			jumpsCount++;
			
			if(jumpsCount < maxJumpsCount)
				jumpDelayCallId = Starling.juggler.delayCall(jump, 1.0, 0, playSound);
		}
		
		public function showSuperChestShine():void
		{
			if (superchestGlowContourImage)
				return;
			
			superchestGlowContourImage = new Image(AtlasAsset.CommonAtlas.getTexture('dialogs/chest/superchest_glow_contour'));
			superchestGlowContourImage.alignPivot();
			superchestGlowContourImage.scale = 2;
			superchestGlowContourImage.x = bottomImage.x;
			superchestGlowContourImage.y = bottomImage.y - 47*pxScale;
			addChild(superchestGlowContourImage);
			
			superchestGlowImage = new Image(AtlasAsset.CommonAtlas.getTexture('dialogs/chest/superchest_glow'));
			superchestGlowImage.alignPivot();
			superchestGlowImage.scale = 2;
			superchestGlowImage.x = bottomImage.x;
			superchestGlowImage.y = bottomImage.y - 53*pxScale;
			addChildAt(superchestGlowImage, getChildIndex(topImage))
			
			superchestGlowKeyholeImage = new Image(AtlasAsset.CommonAtlas.getTexture('dialogs/chest/superchest_glow_keyhole'));
			superchestGlowKeyholeImage.alignPivot();
			superchestGlowKeyholeImage.scale = 2;
			superchestGlowKeyholeImage.x = bottomImage.x + 68*pxScale;
			superchestGlowKeyholeImage.y = bottomImage.y - 14.5*pxScale;
			addChild(superchestGlowKeyholeImage)
			
			superchestShadowImage = new Image(AtlasAsset.CommonAtlas.getTexture('dialogs/chest/superchest_shadow'));
			//superchestShadowImage.alignPivot();
			superchestShadowImage.scale = 2;
			superchestShadowImage.x = bottomImage.x - 147*pxScale;
			superchestShadowImage.y = bottomImage.y - 0*pxScale;
			addChildAt(superchestShadowImage, 0)
			superchestShadowImage.alpha = 0;
			Starling.juggler.tween(superchestShadowImage, 0.15, {alpha:1});
			
			superchestParticles = new ParticleExplosion(AtlasAsset.CommonAtlas, "effects/green_puff", new <uint> [0xFFFFFF]);
			superchestParticles.x = topImage.x;
			superchestParticles.y = topImage.y;
			superchestParticles.setProperties(30*pxScale, 0, 3.8, -0.001, 0, 0, 0);
			superchestParticles.setFineProperties(0.5, 0.0, 0.0, 0, 0, 0);
			superchestParticles.setAccelerationProperties(-0.06, -0.00025);
			superchestParticles.emitAngleAmplitude = 235;
			superchestParticles.emitDirectionAngle = 90;
			superchestParticles.directionAngleShiftSpeed = 3;
			superchestParticles.directionAngleShiftAmplitide = 7;
			addChildAt(superchestParticles, getChildIndex(topImage));
			superchestParticles.play(0, 16, 3, 250);
			
			superchestStarsParticles = new ParticleExplosion(AtlasAsset.CommonAtlas, new <String> ["effects/star"], new <uint> [0xFFFFFF]);
			superchestStarsParticles.setProperties(0, 110*pxScale, 0.0, -0.025, 0.0, 0, 0.04, true);
			superchestStarsParticles.setFineProperties(0.8, 0.1, 0.1, 1);
			superchestStarsParticles.setAccelerationProperties(0, 0.0);
			//superchestStarsParticles.y = -20 * pxScale;
			addChild(superchestStarsParticles);
			superchestStarsParticles.play(0, 14, 3, 120);
			
			superchestGlowContourImage.alpha = 0;
			updateSuperchestShine();
			
			tweenSuperchestShine();
			
		}
		
		private function tweenSuperchestShine():void
		{
			var tweenShine_1:Tween = new Tween(superchestGlowContourImage, 0.8, Transitions.LINEAR);
			var tweenShine_2:Tween = new Tween(superchestGlowContourImage, 1.3, Transitions.EASE_IN);
			
			//tweenTop_1.delay = delay;
			//tweenTop_1.animate('scaleY', 1.1);
			tweenShine_1.animate('alpha', 1);
			tweenShine_1.onUpdate = updateSuperchestShine;
			tweenShine_1.nextTween = tweenShine_2;
			
			//tweenTop_2.animate('scaleY', 0.92);
			tweenShine_2.animate('alpha', 0.3);
			tweenShine_2.onComplete = tweenSuperchestShine;
			tweenShine_2.onUpdate = updateSuperchestShine;
			//tweenTop_2.onUpdateArgs = [SoundAsset.ChestClickHit];
			
			Starling.juggler.add(tweenShine_1);
			
			
			var tweenTop_1:Tween = new Tween(topImage, 0.8, Transitions.LINEAR);
			var tweenTop_2:Tween = new Tween(topImage, 1.3, Transitions.EASE_OUT);
			
			//tweenTop_1.delay = delay;
			tweenTop_1.animate('y', shiftY - 3 * pxScale);
			tweenTop_1.nextTween = tweenTop_2;
			
			tweenTop_2.animate('y', shiftY);
			tweenTop_2.nextTween = tweenTop_1;
			
			Starling.juggler.add(tweenTop_1);
		}
		
		private function updateSuperchestShine():void
		{
			if (superchestGlowContourImage)
			{
				superchestGlowImage.alpha = superchestGlowContourImage.alpha;
				superchestGlowKeyholeImage.alpha = superchestGlowContourImage.alpha;
				//superchestShadowImage.alpha = superchestGlowContourImage.alpha;
			}
		}
		
		public function clean():void
		{
			if (superchestGlowContourImage)
			{
				Starling.juggler.removeTweens(superchestGlowContourImage);
				superchestParticles.stop();
				superchestStarsParticles.stop();
			}
		}
	
		
		
		
		
		private var alertSignView:AlertSignView;
		private var _countValue:int;
		
		private var countScale:Number = 1;
		private var countX:int;
		private var countY:int;
		
		public function setCountValueProperties(_x:int, _y:int, scale:Number = 1):void {
			countX = _x;
			countY = _y;
			countScale = scale;
		}
		
		public function set countValue(value:int):void 
		{
			if (_countValue == value)
				return;
				
			_countValue = value;
			
			if (_countValue > 0) 
			{
				if (!alertSignView) 
				{
					var overridedScale:Number = 1 / (_baseScale * _baseScale);
					alertSignView = new AlertSignView(_countValue.toString());
					alertSignView.touchable = false;
					alertSignView.scale = 0;//overridedScale * countScale;
					alertSignView.x = overridedScale*countX;
					alertSignView.y = overridedScale * countY;
					addChild(alertSignView);
					
					Starling.juggler.tween(alertSignView, 0.25, {delay:0, scale:overridedScale * countScale, transition:Transitions.EASE_OUT_BACK});
				}
				else {
					//alertSignView.text = _countValue.toString();
					alertSignView.animateText(_countValue.toString(), 0);
				}
				
				//repositionNewCount();
			}
			else 
			{
				if (alertSignView) {
					alertSignView.removeFromParent(true);
					alertSignView = null;
				}
			}
		}
		
		public function get countValue():int
		{
			return _countValue;
		}	
		
		private var smokeExplosion:AnimationContainer;
		
		public function showSmokeExplosion():void
		{
			smokeExplosion = new AnimationContainer(MovieClipAsset.PackBase, true, true);
			//smokeExplosion.pivotX = 125 * pxScale;
			//smokeExplosion.pivotY = 50 * pxScale;
			smokeExplosion.touchable = false;
			smokeExplosion.scale = 2;
			addChildAt(smokeExplosion, 0);
			//addChild(smokeExplosion);
			
			var overridedScale:Number = 1 / (_baseScale * _baseScale);
			//smokeExplosion.x = overridedScale*10*pxScale;
			smokeExplosion.y = overridedScale*60*pxScale;
			
			smokeExplosion.playTimeline('smoke_explosion', false, true, 24);
			
			smokeExplosion.dispatchOnCompleteTimeline = true;
			smokeExplosion.addEventListener(AnimationContainer.EVENT_COMPLETE_TIMELINE, handler_handAnimationComplete);
			smokeExplosion.repeatCount = 1000;
			
			//Starling.juggler.tween(smokeExplosion, 0.1, {transition:Transitions.LINEAR, delay:(delay + 0.3), scale:0, onComplete:removeSmokeExplosion});
		}
		
		private function handler_handAnimationComplete(e:Event):void 
		{
			if (smokeExplosion) {
				smokeExplosion.removeFromParent();
				smokeExplosion = null;
			}
		}
		
		private function removeSmokeExplosion():void 
		{
			if (smokeExplosion) {
				smokeExplosion.removeFromParent();
				smokeExplosion = null;
			}
		}
	}	
}
