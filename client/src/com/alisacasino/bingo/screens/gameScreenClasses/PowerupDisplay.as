package com.alisacasino.bingo.screens.gameScreenClasses
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.commands.gameScreenCommands.UsePowerup;
	import com.alisacasino.bingo.components.effects.ParticleExplosion;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.models.powerups.PowerupModel;
	import com.alisacasino.bingo.screens.storeWindow.StoreScreen;
	import com.alisacasino.bingo.utils.DelayCallUtils;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.caurina.transitions.properties.DisplayShortcuts;
	import feathers.controls.BasicButton;
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class PowerupDisplay extends FeathersControl
	{
		private static const FULL_CHARGE_STEPS:int = 3;
		
		private var DELAY_CALLS_BUNDLE:String = 'PowerupDisplay';
		
		private var colorImage:Image;
		private var progressMask:PowerupMask;
		private var iconBackground:Image;
		private var energyIcon:Image;
		private var powerupIcon:Image;
		private var radiusLight:Image;
		private var radiusMark:Image;
		private var overlay:Image;
		private var button:BasicButton;
		
		private var particleGreen:ParticleExplosion;
		private var particleWhite:ParticleExplosion;
		private var shineImage:Image;
		
		private var charge:int;
		private var _progress:Number = 0;
		
		private var isDischarging:Boolean;
		private var activePowerup:String;
		
		private var _colorTexture:String;
		private var _iconBackgroundTexture:String;
		
		private var centerX:int;
		private var centerY:int;
		
		private var delayCallShakeCycleId:int;
		
		private var _hasPowerups:Boolean;
		
		private var usedCount:int;
		
		public function PowerupDisplay() {
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			var progressContainer:Sprite = new Sprite();
			addChild(progressContainer);
			
			centerX = 79*pxScale;
			centerY = 79*pxScale;
			
			_colorTexture = "powerup/powerup_energy";
			colorImage = new Image(AtlasAsset.CommonAtlas.getTexture(_colorTexture));
			colorImage.x = 2 * pxScale;
			colorImage.y = 1.5 * pxScale;
			colorImage.scale = 1.98;
			progressContainer.addChild(colorImage);
			
			progressMask = new PowerupMask();
			progressMask.touchable = false;
			addChild(progressMask);
			progressMask.setSize(colorImage.width / 2 * 1.1);
			progressMask.x = colorImage.width / 2;
			progressMask.y = colorImage.height / 2;
			progressContainer.mask = progressMask;
			
			radiusLight = new Image(AtlasAsset.CommonAtlas.getTexture("powerup/bar_radius_light"));
			radiusLight.pivotX = 30*pxScale;
			radiusLight.pivotY = 79*pxScale;
			radiusLight.x = centerX;
			radiusLight.y = centerY;
			addChild(radiusLight);
			
			_iconBackgroundTexture = hasPowerups ? "powerup/icon_bg" : "powerup/no_energy_icon_bg";
			iconBackground = new Image(AtlasAsset.CommonAtlas.getTexture(_iconBackgroundTexture));
			iconBackground.alignPivot();
			iconBackground.x = centerX;
			iconBackground.y = centerY - 1 * pxScale;
			addChild(iconBackground);
			
			overlay = new Image(AtlasAsset.CommonAtlas.getTexture("powerup/powerup_overlay"));
			overlay.alignPivot();
			overlay.x = overlay.pivotX;
			overlay.y = overlay.pivotY;
			addChild(overlay);
			
			radiusMark = new Image(AtlasAsset.CommonAtlas.getTexture("powerup/bar_radius_mark"));
			radiusMark.pivotX = radiusMark.width/2;
			radiusMark.pivotY = 84*pxScale;
			radiusMark.x = centerX;
			radiusMark.y = centerY;
			addChild(radiusMark);
			
			
			button = new BasicButton();
			button.useHandCursor = true;
			button.defaultSkin = new Quad(iconBackground.width, iconBackground.height, 0xFF00FF);
			button.alpha = 0;
			button.move(iconBackground.x - iconBackground.pivotX, iconBackground.y - iconBackground.pivotY);
			button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
			addChild(button);
			
			setSizeInternal(progressContainer.width, progressContainer.height, false);
			
			radiusImagesAlpha = 0;
			
			refreshIconAndBg(false);
			
			updateButton();
			
			
		}
		
		override protected function feathersControl_addedToStageHandler(event:Event):void 
		{
			super.feathersControl_addedToStageHandler(event);
			Game.addEventListener(Game.ACTIVATED, current_activatedHandler);
		}
		
		override protected function feathersControl_removedFromStageHandler(event:Event):void 
		{
			super.feathersControl_removedFromStageHandler(event);
			Game.removeEventListener(Game.ACTIVATED, current_activatedHandler);
		}
		
		private function current_activatedHandler(e:Event):void 
		{
			if (progressMask)
			{
				progressMask.progress = progress;
			}
		}
		
		public function advance():void 
		{
			if (isDischarging)
				return;
				
			if (charge >= FULL_CHARGE_STEPS)
				return;
			
			if (!hasPowerups) {
				colorTexture = "powerup/powerup_energy";
				iconBackgroundTexture = "powerup/no_energy_icon_bg";
				tweenEmptyEnergy();
				return;
			}
				
			var previousCharge:int = charge++;	
			//updateButton();
			
			if (charge >= FULL_CHARGE_STEPS) 
			{
				if(!gameManager.tutorialManager.tutorialFirstLevelPassed || !gameManager.tutorialManager.tutorialLevelsPassed)
					activePowerup = gameManager.tutorialManager.getPowerup(usedCount); //gameManager.powerupModel.getTutorialPowerup();
				else 
					activePowerup = gameManager.powerupModel.getRandomPowerup();
				
				if (!gameManager.tutorialManager.isPowerupStepPassed)
					Game.current.gameScreen.gameUI.tutorialStepShowPowerupBall();
			}
				
			colorTexture = "powerup/powerup_energy";
			
			tweenProgress(previousCharge, 0.6, 0.5, Transitions.EASE_OUT, completeChargeUpTweenProgress);
		}
		
		public function reset():void 
		{
			SoundManager.instance.stopSfxLoop(SoundAsset.PowerUpActivateLoop, 0.2);
			
			activePowerup = null;
			
			usedCount = 0;
			
			charge = 0;
			isDischarging = false;
			
			progress = 0;
			radiusImagesAlpha = 0;
			
			refreshIconAndBg(false);
			updateButton();
			
			overlay.scale = 1;
			
			Starling.juggler.removeTweens(this);
			
			if (energyIcon)
				Starling.juggler.removeTweens(energyIcon);
				
			if (powerupIcon)
				Starling.juggler.removeTweens(powerupIcon);	
				
			Starling.juggler.removeByID(delayCallShakeCycleId);
			
			if (particleGreen) {
				particleGreen.stop();
				particleWhite.stop();
				Starling.juggler.removeTweens(shineImage);
				shineImage.scale = 0;
			}
			
			DelayCallUtils.cleanBundle(DELAY_CALLS_BUNDLE);
			
			if (!gameManager.powerupModel.hasEventListener(PowerupModel.EVENT_UPDATE, handler_powerupModelUpdate))
			{
				gameManager.powerupModel.addEventListener(PowerupModel.EVENT_UPDATE, handler_powerupModelUpdate);
			}
		}
		
		public function usePowerup():void 
		{
			if (charge >= FULL_CHARGE_STEPS)
			{
				if (gameManager.powerupModel.getPowerupCount(activePowerup) > 0 || !gameManager.tutorialManager.allTutorialLevelsPassed)
				{
					new UsePowerup(activePowerup).execute();
					discharge();
				}
				else
				{
					discharge();
				}
				
				usedCount++;
				
				gameManager.tutorialManager.tutorialFirstPowerUpTaked = true;
				
				if (!gameManager.tutorialManager.isPowerupStepPassed) {
					Game.current.gameScreen.gameUI.tutorialStepHidePowerupBall();
					//gameManager.tutorialManager.completePowerupStep();
				}
				
				SoundManager.instance.stopSfxLoop(SoundAsset.PowerUpActivateLoop, 0.2);
				//SoundManager.instance.playSfx(SoundAsset.PowerUpReset);		
			}
			else
			{
				if (!hasPowerups) 
				{
					var dialog:StoreScreen = new StoreScreen(StoreScreen.POWERUPS_MODE);
					DialogsManager.addDialog(dialog);
				}
			}
		}
		
		private function button_triggeredHandler(e:Event):void 
		{
			usePowerup();
			gameManager.tutorialManager.completePowerupStep();
		}
		
		private function completeChargeUpTweenProgress():void 
		{
			if (charge >= FULL_CHARGE_STEPS)
			{
				//activePowerup = gameManager.powerupModel.getRandomPowerup();
				refreshIconAndBg(true, true);
				
				SoundManager.instance.playSfxLoop(SoundAsset.PowerUpActivateLoop, 1.99, 0.2, 0.4);
				//shakeTween(energyIcon);
			}
		}
		
		private function updateButton():void 
		{
			button.useHandCursor = charge >= FULL_CHARGE_STEPS || !hasPowerups;
		}
		
		private function set colorTexture(texture:String):void {
			if (_colorTexture == texture)
				return;
				
			_colorTexture = texture;
			colorImage.texture = AtlasAsset.CommonAtlas.getTexture(texture);
		}
		
		private function set iconBackgroundTexture(texture:String):void 
		{
			if (_iconBackgroundTexture == texture)
				return;
				
			_iconBackgroundTexture = texture;
			iconBackground.texture = AtlasAsset.CommonAtlas.getTexture(texture);
			iconBackground.readjustSize();
			iconBackground.alignPivot();
			iconBackground.x = centerX;
			iconBackground.y = centerY;
		}
		
		private function refreshIconAndBg(animate:Boolean, updateWithShake:Boolean = false):void 
		{
			_hasPowerups = hasPowerups;
			
			if (charge >= FULL_CHARGE_STEPS)
			{
				if (!powerupIcon)
				{
					powerupIcon = new Image(AtlasAsset.CommonAtlas.getTexture(Powerup.getTexture(activePowerup)));
					powerupIcon.x = centerX;
					addChildAt(powerupIcon, getChildIndex(overlay));
				}
				else {
					powerupIcon.texture = AtlasAsset.CommonAtlas.getTexture(Powerup.getTexture(activePowerup));
					powerupIcon.readjustSize();
				}
				
				powerupIcon.pivotX = powerupIcon.texture.width / 2;
				powerupIcon.pivotY = powerupIcon.texture.height / 2 + powerupIcon.texture.height / 6;
			
				powerupIcon.y = centerY + powerupIcon.texture.height / 6;
	
				if (animate) 
				{
					powerupIcon.scale = 0;
					
					if (updateWithShake) {
						Starling.juggler.removeByID(delayCallShakeCycleId);
						shakeTweenCycle(powerupIcon, 2.0);
					}
					else {
						Starling.juggler.tween(powerupIcon, 0.1, {scale:1, delay:0.04, transition:Transitions.EASE_OUT_BACK});
					}
					
					if (energyIcon) {
						Starling.juggler.removeTweens(energyIcon);
						Starling.juggler.tween(energyIcon, 0.05, {scale:0, rotation:0, transition:Transitions.LINEAR});
					}
				}
				else
				{
					powerupIcon.scale = 1;
					if (energyIcon) {
						Starling.juggler.removeTweens(energyIcon);
						energyIcon.scale = 0;
					}
				}
				
				iconBackgroundTexture = "powerup/icon_bg";
			}
			else
			{
				//DelayCallUtils.cleanBundle(DELAY_CALLS_BUNDLE);
				
				if (!energyIcon) {
					energyIcon = new Image(AtlasAsset.CommonAtlas.getTexture(_hasPowerups ? 'powerup/icons/energy' : 'powerup/icons/no_energy'));
					energyIcon.x = centerX;
					addChildAt(energyIcon, getChildIndex(overlay));
				}
				else {
					energyIcon.texture = AtlasAsset.CommonAtlas.getTexture(_hasPowerups ? 'powerup/icons/energy' : 'powerup/icons/no_energy');
					energyIcon.readjustSize();
				}
				
				energyIcon.pivotX = energyIcon.texture.width/2;
				energyIcon.pivotY = energyIcon.texture.height / 2 + energyIcon.texture.height / 6;
				energyIcon.y = centerY + energyIcon.texture.height / 6;
			
		
				Starling.juggler.removeByID(delayCallShakeCycleId);
				
				if (animate) 
				{
					energyIcon.scale = 0;
					Starling.juggler.tween(energyIcon, 0.1, {scale:1, delay:0.04, transition:Transitions.EASE_OUT_BACK});
			
					if (powerupIcon) {
						Starling.juggler.removeTweens(powerupIcon);
						Starling.juggler.tween(powerupIcon, 0.05, {scale:0, transition:Transitions.LINEAR});
					}
				}
				else
				{
					if (powerupIcon) {
						Starling.juggler.removeTweens(powerupIcon);
						powerupIcon.scale = 0;
					}
					
					energyIcon.scale = 1;
				}
				
				iconBackgroundTexture = _hasPowerups ? "powerup/icon_bg" : "powerup/no_energy_icon_bg";
			}
			
		}
		
		private function tweenProgress(previousCharge:int, time:Number, tweenOverlayTime:Number, tweenProgressTransition:String, onComplete:Function = null):void 
		{
			var chargeRatio:Number = charge / FULL_CHARGE_STEPS;
			
			Starling.juggler.removeTweens(this);
			Starling.juggler.tween(this, time, {'progress#':chargeRatio, transition:tweenProgressTransition, onComplete:onComplete});
		
			var tween_0:Tween = new Tween(this, 0.2*time, Transitions.EASE_OUT);
			var tween_1:Tween = new Tween(this, 0.2*time, Transitions.LINEAR);
			
			tween_0.delay = previousCharge == 0 ? 0.1 : 0;
			tween_0.animate('radiusImagesAlpha', 1);
			tween_0.nextTween = tween_1;
			
			tween_1.delay = 0.55 * time;
			tween_1.animate('radiusImagesAlpha', 0);
			
			Starling.juggler.add(tween_0);
			
			
			var tweenOverlayBack:Tween = new Tween(overlay, tweenOverlayTime*1/5, Transitions.EASE_IN);
			tweenOverlayBack.animate('scale', 1);
			Starling.juggler.tween(overlay, tweenOverlayTime*4/5, {scale:1.03, transition:Transitions.EASE_OUT, nextTween:tweenOverlayBack});
			
			shakeTween(energyIcon);
			
			if (previousCharge < charge && chargeRatio >= 1) 
				showFullChargeAnimations(time);
				
				
			//SoundManager.instance.playSfx(SoundAsset.PowerUpFill);		
		}
		
		private function tweenEmptyEnergy():void 
		{
			Starling.juggler.removeTweens(this);
			
			var tweenProgressBack:Tween = new Tween(this, 0.6, Transitions.LINEAR);
			tweenProgressBack.onComplete = onDischargeComplete;
			tweenProgressBack.animate('progress#', 0);
			
			Starling.juggler.tween(this, 0.15, {'progress#':0.25, transition:Transitions.EASE_OUT, nextTween:tweenProgressBack});
		
			var tween_0:Tween = new Tween(this, 0.1, Transitions.EASE_OUT);
			var tween_1:Tween = new Tween(this, 0.1, Transitions.LINEAR);
			
			tween_0.delay = 0.1;
			tween_0.animate('radiusImagesAlpha', 1);
			tween_0.nextTween = tween_1;
			
			tween_1.delay = 0.1;
			tween_1.animate('radiusImagesAlpha', 0);
			
			Starling.juggler.add(tween_0);
			
			
			var tweenOverlayBack:Tween = new Tween(overlay, 0.1, Transitions.EASE_IN);
			tweenOverlayBack.animate('scale', 1);
			Starling.juggler.tween(overlay, 0.1, {scale:1.03, transition:Transitions.EASE_OUT, nextTween:tweenOverlayBack});
			
			shakeTween(energyIcon);
			
			var particleRed:ParticleExplosion = new ParticleExplosion(AtlasAsset.CommonAtlas, "effects/puff_ball", new <uint> [0xFF3700, 0xFF3700, 0xF6D900]);
			particleRed.x = overlay.pivotX;
			particleRed.y = overlay.pivotY;
			particleRed.setProperties(0, 50*pxScale, 2.55, -0.004, 0, 0, 0.3);
			particleRed.setFineProperties(0.3, 0.4, 0.1, 2, 0, 0);
			particleRed.setDirectionAngleProperties(0.07, 18, 0);
			particleRed.setAccelerationProperties(-0.06);
			particleRed.addEventListener(Event.COMPLETE, handler_redParticleEffectComplete);
			addChildAt(particleRed, getChildIndex(iconBackground) + 1);
			Starling.juggler.delayCall(particleRed.play, 0.1, 1, 20, 20);
			
			isDischarging = true;
		}
		
		private function showFullChargeAnimations(time:Number):void
		{
			animateLightRing(time*3/5);
				
			if (!particleGreen) 
			{
				var childIndex:int = getChildIndex(iconBackground) + 1;
				
				particleGreen = new ParticleExplosion(AtlasAsset.CommonAtlas, "effects/puff_ball", new <uint> [0xBDFE31]);
				particleGreen.x = overlay.pivotX;
				particleGreen.y = overlay.pivotY;
				particleGreen.setProperties(0, 50*pxScale, 2.4, -0.010, 0, 0, 0.3);
				particleGreen.setFineProperties(0.5, 0.4, 0.1, 2, 0, 0);
				particleGreen.setDirectionAngleProperties(0.07, 18, 0);
				particleGreen.setAccelerationProperties(-0.015);
				addChildAt(particleGreen, childIndex);
				
				particleWhite = new ParticleExplosion(AtlasAsset.CommonAtlas, "effects/puff_ball", new <uint> [0xFFFFFF]);
				particleWhite.x = overlay.pivotX;
				particleWhite.y = overlay.pivotY;
				particleWhite.setProperties(0, 50*pxScale, 2.2, -0.013, 0, 0, 0.3);
				particleWhite.setFineProperties(0.5, 0.4, 0.1, 2, 0, 0);
				particleWhite.setDirectionAngleProperties(0.02, 30, 0);
				particleWhite.setAccelerationProperties(-0.013);
				addChildAt(particleWhite, childIndex);
				
				shineImage = new Image(AtlasAsset.CommonAtlas.getTexture("effects/shine"));
				shineImage.alignPivot();
				shineImage.x = overlay.pivotX;
				shineImage.y = overlay.pivotX;
				shineImage.scale = 0;
			//	shineImage.blendMode = BlendMode.ADD;
				addChildAt(shineImage, childIndex);
			}
			
			DelayCallUtils.add(Starling.juggler.delayCall(particleGreen.play, time, 850, 40, 20), DELAY_CALLS_BUNDLE);
			DelayCallUtils.add(Starling.juggler.delayCall(particleWhite.play, time + 0.4, 0, 14), DELAY_CALLS_BUNDLE);
			
			var tween_0:Tween = new Tween(shineImage, 0.2, Transitions.LINEAR);
			var tween_1:Tween = new Tween(shineImage, 0.25, Transitions.LINEAR);
			var tween_2:Tween = new Tween(shineImage, 2.6, Transitions.LINEAR);
			
			tween_0.delay = time;
			tween_0.animate('scale', 2);
			tween_0.animate('rotation', Math.PI/4);
			tween_0.nextTween = tween_1;
			
			tween_1.animate('scale', 1.1);
			tween_1.animate('rotation', Math.PI/2);
			tween_1.nextTween = tween_2;
			
			tween_2.animate('rotation', Math.PI/2 + 2*Math.PI);
			tween_2.repeatCount = 0;
			
			Starling.juggler.add(tween_0);
		}
		
		private function animateLightRing(delay:Number):void
		{
			var lightRing:Image = new Image(AtlasAsset.CommonAtlas.getTexture("powerup/bar_o"));
			lightRing.alignPivot();
			lightRing.x = centerX;
			lightRing.y = centerY - 1 * pxScale;
			lightRing.alpha = 0;
			lightRing.scale = 0.95*2;
			lightRing.touchable = false;
			//lightRing.blendMode = BlendMode.ADD;
			addChild(lightRing);
			
			Starling.juggler.tween(lightRing, 0.3, {scale:1.35*2, delay:delay, transition:Transitions.LINEAR, onStart:setAlpha, onStartArgs:[lightRing, 1]});
			Starling.juggler.tween(lightRing, 0.12, {alpha:0, delay:(delay + 0.15), transition:Transitions.LINEAR, onComplete:removeView, onCompleteArgs:[lightRing]});
		}
		
		public function get progress():Number 
		{
			return _progress;
		}
		
		public function set progress(value:Number):void 
		{
			_progress = value;
			
			radiusLight.rotation = radiusMark.rotation = 2 * Math.PI * value;
			progressMask.progress = value;
		}
		
		public function get radiusImagesAlpha():Number 
		{
			return radiusLight.alpha;
		}
		
		public function set radiusImagesAlpha(value:Number):void 
		{
			radiusLight.alpha = radiusMark.alpha = value;
		}
		
		private function stepBack():void
		{
			//icon.resetToEnergy();
			colorTexture = 'powerup/powerup_magenta';
			var previousCharge:int = charge;
			charge = FULL_CHARGE_STEPS - 1;
			refreshIconAndBg(true);
			isDischarging = true;
			tweenProgress(previousCharge, 0.3, 0.3, Transitions.EASE_OUT, onDischargeComplete);
			updateButton();
		}
		
		private function discharge():void 
		{
			DelayCallUtils.cleanBundle(DELAY_CALLS_BUNDLE);
			
			animateLightRing(0);
			
			if (particleWhite)
				particleWhite.stop();
			
			if (shineImage) {
				Starling.juggler.removeTweens(shineImage);
				
				var tween_0:Tween = new Tween(shineImage, 0.2, Transitions.LINEAR);
				var tween_1:Tween = new Tween(shineImage, 0.2, Transitions.LINEAR);
				
				//tween_0.delay = time;
				tween_0.animate('scale', 2);
				tween_0.animate('rotation', shineImage.rotation + Math.PI/4);
				tween_0.nextTween = tween_1;
				
				tween_1.animate('scale', 0);
				tween_1.animate('rotation', shineImage.rotation + Math.PI/2);
				
				Starling.juggler.add(tween_0);	
			}
			
			colorTexture = 'powerup/powerup_magenta';
			
			var previousCharge:int = charge;
			charge = 0;
			isDischarging = true;
			
			refreshIconAndBg(true);
			
			tweenProgress(previousCharge, 0.8, 0.5, Transitions.LINEAR, onDischargeComplete);
			updateButton();
		}
		
		private function onDischargeComplete():void 
		{
			isDischarging = false;
		}
		
		private function shakeTweenCycle(displayObject:DisplayObject, delay:Number):void 
		{
			shakeTween(displayObject);
			delayCallShakeCycleId = Starling.juggler.delayCall(shakeTweenCycle, delay, displayObject, delay);
		}
		
		private function shakeTween(displayObject:DisplayObject):void 
		{
			Starling.juggler.removeTweens(displayObject);
			
			var tweenScale_0:Tween = new Tween(displayObject, 0.17, Transitions.LINEAR);
			var tweenScale_1:Tween = new Tween(displayObject, 0.17, Transitions.LINEAR);
			
			tweenScale_0.animate('scale', 1.1);
			tweenScale_0.nextTween = tweenScale_1;
			
			tweenScale_1.animate('scale', 1);
			
			Starling.juggler.add(tweenScale_0);
			
			//Starling.juggler.tween(displayObject, 0.17, {scale:1.1, repeatCount:repeatCount * 2, delay:delay, reverse:true, transition:Transitions.LINEAR});
			
			var tween_0:Tween = new Tween(displayObject, 0.05, Transitions.EASE_OUT);
			var tween_1:Tween = new Tween(displayObject, 0.08, Transitions.EASE_OUT);
			var tween_2:Tween = new Tween(displayObject, 0.08, Transitions.EASE_OUT);
			var tween_3:Tween = new Tween(displayObject, 0.08, Transitions.EASE_OUT);
			var tween_4:Tween = new Tween(displayObject, 0.05, Transitions.EASE_OUT);
			
			var amplitude:Number = Math.PI * 4 / 180;
			
			tween_0.animate('rotation', -amplitude * 0.4);
			tween_0.nextTween = tween_1;
			
			//tween_1.animate('scale', 1.1);
			tween_1.animate('rotation', amplitude * 0.6);
			tween_1.nextTween = tween_2;
			
			tween_2.animate('rotation', -amplitude);
			tween_2.nextTween = tween_3;
			
			tween_3.animate('rotation', amplitude * 0.6);
			tween_3.nextTween = tween_4;
			
			tween_4.animate('rotation', 0);
			
			Starling.juggler.add(tween_0);
		}
		
		private function removeView(view:DisplayObject):void
		{
			view.removeFromParent();
		}
		
		public function setAlpha(displayObject:DisplayObject, value:Number):void
		{
			displayObject.alpha = value;
		}
		
		public function stripListeners():void 
		{
			gameManager.powerupModel.removeEventListener(PowerupModel.EVENT_UPDATE, handler_powerupModelUpdate);
		}
		
		private function get hasPowerups():Boolean {
			return gameManager.powerupModel.powerupsTotal > 0;
		}
		
		private static function handler_redParticleEffectComplete(event:Event):void 
		{
			(event.target as DisplayObject).removeFromParent();
		}
		
		private function handler_powerupModelUpdate(event:Event):void 
		{
			if(stage && !_hasPowerups && hasPowerups)
				reset();
		}
	}
}

import starling.display.DisplayObject;
import flash.geom.Rectangle;
import starling.display.Mesh;
import starling.rendering.IndexData;
import starling.rendering.VertexData;
import starling.rendering.VertexDataFormat;

class PowerupMask extends Mesh
{
	private var _progress:Number = 0;
	
	public function get progress():Number 
	{
		return _progress;
	}
	
	public function set progress(value:Number):void 
	{
		_progress = value;
		updateVertexPositions();
	}
	
	private var boundWidth:Number = 1;
	private var boundHeight:Number = 1;
	private var size:Number;
	
	public function PowerupMask() 
	{
		super(new VertexData(null, 7), new IndexData(15));
		
		color = 0xFF00FF;
		
		indexData.addTriangle(0, 1, 2);
		indexData.addTriangle(0, 2, 3);
		indexData.addTriangle(0, 3, 4);
		indexData.addTriangle(0, 4, 5);
		indexData.addTriangle(0, 5, 6);
		
		vertexData.numVertices = 7;
		
		setRequiresRedraw();
	}
	
	public function setSize(size:Number):void 
	{
		this.size = size;
		updateVertexPositions();
	}
	
	private function updateVertexPositions():void 
	{
		setVertexPosition(0, 0, 0);
		
		var calculatedAngle:Number = progress * Math.PI * 2 - Math.PI / 2;
		setVertexPosition(1, 0, -size);
		
		var verticeIndexToCenter:int = 2;
		
		if (calculatedAngle < -Math.PI / 4)
		{
			setVertexPosition(2, -size * (1 / Math.tan(calculatedAngle)), -size);
			verticeIndexToCenter = 3;
		}
		else 
		{
			setVertexPosition(2, size, -size);
			if (calculatedAngle < Math.PI / 4)
			{
				setVertexPosition(3, size, size * Math.tan(calculatedAngle));
				verticeIndexToCenter = 4;
			}
			else
			{
				setVertexPosition(3, size, size);
				if (calculatedAngle < 3 / 4 * Math.PI)
				{
					setVertexPosition(4, size * (1 / Math.tan(calculatedAngle)), size);
					verticeIndexToCenter = 5;
				}
				else
				{
					setVertexPosition(4, -size, size);
					if (calculatedAngle < 5 / 4 * Math.PI)
					{
						setVertexPosition(5, -size, -size * Math.tan(calculatedAngle));
						verticeIndexToCenter = 6;
					}
					else
					{
						setVertexPosition(5, -size, -size);
						setVertexPosition(6, -size * (1 / Math.tan(calculatedAngle)), -size);
						verticeIndexToCenter = 7;
					}
				}
			}
			
		}
		
		for (var i:int = verticeIndexToCenter; i < 7; i++) 
		{
			setVertexPosition(i, 0, 0);
		}
		
		setRequiresRedraw();
	}
	
	
}