package com.alisacasino.bingo.screens.lobbyScreenClasses {

import com.alisacasino.bingo.Game;
import com.alisacasino.bingo.assets.AnimationContainer;
import com.alisacasino.bingo.assets.AtlasAsset;
import com.alisacasino.bingo.assets.Fonts;
import com.alisacasino.bingo.assets.MovieClipAsset;
import com.alisacasino.bingo.assets.SoundAsset;
import com.alisacasino.bingo.assets.XmlAsset;
import com.alisacasino.bingo.commands.dialogCommands.ShowNoConnectionDialog;
import com.alisacasino.bingo.commands.player.CollectCommodityItem;
import com.alisacasino.bingo.commands.player.UpdateLobbyBarsTrueValue;
import com.alisacasino.bingo.components.effects.ParticleExplosion;
import com.alisacasino.bingo.controls.BingoTextFormat;
import com.alisacasino.bingo.controls.XButton;
import com.alisacasino.bingo.controls.XButtonStyle;
import com.alisacasino.bingo.controls.XTextField;
import com.alisacasino.bingo.controls.XTextFieldStyle;
import com.alisacasino.bingo.models.Player;
import com.alisacasino.bingo.models.notification.PushData;
import com.alisacasino.bingo.models.universal.CommodityItem;
import com.alisacasino.bingo.platform.PlatformServices;
import com.alisacasino.bingo.resize.ResizeUtils;
import com.alisacasino.bingo.utils.ConnectionManager;
import com.alisacasino.bingo.utils.DevUtils;
import com.alisacasino.bingo.utils.EffectsManager;
import com.alisacasino.bingo.utils.GameManager;
import com.alisacasino.bingo.utils.sounds.SoundManager;
import com.alisacasino.bingo.utils.StringUtils;
import com.alisacasino.bingo.utils.TimeService;
import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAReconnectShownEvent;
import com.alisacasino.bingo.utils.misc.TextureMaskStyle;
import feathers.controls.Button;
import starling.animation.Tween;

import flash.events.TimerEvent;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;
import flash.geom.Rectangle;
import flash.utils.Timer;
import flash.utils.setInterval;

import starling.animation.Transitions;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.text.TextFieldAutoSize;
import starling.textures.Texture;
import starling.utils.Align;


public class CashBonusProgress extends Sprite 
{
	public static var DEBUG_MODE:Boolean = false;
	
    private var progressFillImage:Image;
    private var timerLabel:TextField;
	
	private var progressBackImage:Image;
	private var progressGlassImage:Image;
    private var progressButton:Button;
	
	private var progressGlow:Image;
	private var progressLight:Image;
	private var progressParticles:ParticleExplosion;

    private var timer:Timer;
	private var oldTimerLabelX:int;
	private var waveAnimation:AnimationContainer;
	private var waveAnimationMask:Image;
	
	private var _progress:Number = 0;
	
	private static var particleEffectSerialID:int = -1; 
	
    public function CashBonusProgress() {
        init();
	}

    public function init():void 
	{
        progressBackImage = new Image(AtlasAsset.CommonAtlas.getTexture("controls/cash_bar_back"));
		progressBackImage.scale9Grid = ResizeUtils.getScaledRect(23, 22, 1, 1);
		progressBackImage.y = 25 * pxScale;
		progressBackImage.width = 380 * pxScale;
		progressBackImage.height = 88 * pxScale;
		addChild(progressBackImage);
		
		progressFillImage = new Image(AtlasAsset.CommonAtlas.getTexture("controls/cash_bar_progress"));
		/*progressFillImage.scale9Grid = ResizeUtils.getScaledRect(15, 0, 1, 0);
		progressFillImage.x = 2 * pxScale;
		progressFillImage.y = 27 * pxScale;
		progressFillImage.width = 375 * pxScale;*/
        progressFillImage.mask = new Quad(progressFillImage.width, progressFillImage.height);
        addChild(progressFillImage);
		
		progressGlassImage = new Image(AtlasAsset.CommonAtlas.getTexture("controls/cash_bar_glass"));
		progressGlassImage.scale9Grid = ResizeUtils.getScaledRect(13, 0, 1, 0);
		progressGlassImage.x = 14 * pxScale;
		progressGlassImage.y = 34 * pxScale;
		progressGlassImage.width = 355 * pxScale;
		//progressBackImage.height = 113 * pxScale;
        addChild(progressGlassImage);
		
      /*  progressButton = new XButton(new XButtonStyle({upState: "controls/cash_bar_empty", atlas: AtlasAsset.CommonAtlas}));
        progressButton.scaleWhenDown = 1.0;
        progressButton.addEventListener(Event.TRIGGERED, takeBonus);
		addChild(progressButton);*/
		
		var buttonContent:Sprite = new Sprite();
		var progressFrame:Image = new Image(AtlasAsset.CommonAtlas.getTexture("controls/cash_bar_frame"));
		progressFrame.scale9Grid = ResizeUtils.getScaledRect(23, 23, 2, 2);
		progressFrame.y = 25 * pxScale;
		progressFrame.width = 380 * pxScale;
        progressFrame.height = 88 * pxScale;
        buttonContent.addChild(progressFrame);
		
		var progressTitle:Image = new Image(AtlasAsset.CommonAtlas.getTexture("controls/cash_bonus_title"));
		progressTitle.x = (progressFrame.width - progressTitle.width)/2;
		buttonContent.addChild(progressTitle);
		
		progressButton = new Button();
		progressButton.scaleWhenDown = 1;
		progressButton.useHandCursor = true;
		progressButton.defaultSkin = buttonContent;
		progressButton.validate();
		//openButton.alignPivot(Align.CENTER, Align.BOTTOM);
		//openButton.y = -14 * pxScale;
		progressButton.addEventListener(Event.TRIGGERED, takeBonus);
		addChild(progressButton);
			
		
        var bingoTextFormat:BingoTextFormat = new BingoTextFormat(Fonts.WALRUS_BOLD, 48 * pxScale, 0xFFFFFF, Align.LEFT);
		var filterScale:Number = pxScale * layoutHelper.scaleFromEtalon;
        bingoTextFormat.nativeFilters = [new GlowFilter(0x000000, 1, 3.3 * filterScale, 3.3 * filterScale, 6 * filterScale)];

        timerLabel = new TextField(220 * pxScale, 60 * pxScale, '', bingoTextFormat);
        timerLabel.touchable = false;
		timerLabel.pivotY = 30*pxScale;
        timerLabel.x = 85 * pxScale;
        timerLabel.y = 73 * pxScale;

        addChild(timerLabel);

        timer = new Timer(100);
        timer.addEventListener(TimerEvent.TIMER, handler_timer);

        handler_timer(null);
	}

	override public function get width():Number {
		return progressButton ? progressButton.width*scale : super.width;
	}
	
	override public function get height():Number {
		return progressButton ? progressButton.height*scale : super.height;
	}
	
    private function takeBonus(e:Event):void 
	{
     	if (!Player.current) {
			new ShowNoConnectionDialog(DDNAReconnectShownEvent.OTHER, 'CashBonusProgress.takeBonus no Player').execute();
			return;
		}
		
		var timeout:Number = Math.max(0, gameManager.periodicBonusManager.nextTakeTime - TimeService.serverTimeMs);
		if (timeout > 0 && !DEBUG_MODE) 
            return;
        
        Player.current.nextPeriodicTimeValue = TimeService.serverTimeMs + gameManager.periodicBonusManager.takeInterval;

        for each (var item:CommodityItem in gameManager.periodicBonusManager.prizes)
        {
			var modifiedItem:CommodityItem = item.clone();
			modifiedItem.quantity = Math.ceil(modifiedItem.quantity * (gameManager.tournamentData.collectionEffects ? gameManager.tournamentData.collectionEffects.cashBonusMod : 1));
            var collectCommand:CollectCommodityItem = new CollectCommodityItem(item, "cashBonus", null, false);
            collectCommand.doNotSendPlayerUpdate = true;
            collectCommand.execute();
        }
		
		SoundManager.instance.playSfx(SoundAsset.CashBonus);
		
		new UpdateLobbyBarsTrueValue(1.5).execute();
		
		PlatformServices.interceptor.sendLocalNotification(
			GameManager.instance.pushData.getCashBonusPush(),
			Player.current.nextPeriodicTimeValue / 1000,
			PushData.PUSH_TITLE
		);

        Game.connectionManager.sendPlayerUpdateMessage();

        gameManager.periodicBonusManager.nextTakeTime = Player.current.nextPeriodicTimeValue;
        EffectsManager.removeJump(progressFillImage);
		EffectsManager.removeJump(timerLabel);

        playParticleEffect();
		
        if (!timer.running) 
            timer.start();
        
		if (DEBUG_MODE) 
		{
			gameManager.periodicBonusManager.takeInterval = 30*60000;	
			Player.current.nextPeriodicTimeValue = TimeService.serverTimeMs + gameManager.periodicBonusManager.takeInterval;
			gameManager.periodicBonusManager.nextTakeTime = Player.current.nextPeriodicTimeValue;	
			
			Starling.juggler.delayCall(function():void 
			{
				gameManager.periodicBonusManager.takeInterval = 2000;	
				Player.current.nextPeriodicTimeValue = TimeService.serverTimeMs + gameManager.periodicBonusManager.takeInterval;
				gameManager.periodicBonusManager.nextTakeTime = Player.current.nextPeriodicTimeValue;	
			}, 4);
		}
	}
	
	private function playParticleEffect():void 
	{
		if (particleEffectSerialID == -1)
			particleEffectSerialID = 0//Math.floor(Math.random() * 3);
		else
			particleEffectSerialID++;
		
		particleEffectSerialID = 5;
		
		var particleEffect:ParticleExplosion = new ParticleExplosion(AtlasAsset.CommonAtlas, new <String> [/*"icons/cash_0", */"icons/cash_1", "icons/cash_2"], null);
		
		if (particleEffectSerialID % 3 == 0) {
			particleEffect.setProperties(0, 0, 12, -0.0025, 0.03, 0, 0.4);
			particleEffect.setAccelerationProperties(-0.13);	
		}
		else if (particleEffectSerialID % 3 == 1) {
			particleEffect.setProperties(0, 0, 23, -0.0025, 0.03, 0, 0.4);
			particleEffect.setAccelerationProperties( -0.73);	
			particleEffect.speedAccelerationEasingSpeed = 0.025;
			particleEffect.speedAccelerationMin = -2;
			particleEffect.speedAccelerationMax = -0.1;
		}
		else if (particleEffectSerialID % 3 == 2) {
			particleEffect.setProperties(0, 0, 17, -0.0025, 0.03, 0, 0.4);
			particleEffect.setAccelerationProperties(-0.35);	
			particleEffect.speedAccelerationEasingSpeed = 0.015;
			particleEffect.speedAccelerationMin = -2;
			particleEffect.speedAccelerationMax = -0.1;
		}
		
		particleEffect.setFineProperties(0.6, 0.7, 0.4, 1.5, 0, 0);
		particleEffect.setDirectionAngleProperties(0.02, 10, 0.1);
		particleEffect.onlyPositiveSpeed = true;
		particleEffect.gravityAcceleration = 0.07;
		particleEffect.skewAplitude = 0.2;
		particleEffect.skewTweensDelay = 1000;
		particleEffect.lifetime = 5000;
		particleEffect.scaleSpeedRandomAmplitude = 0.0050;
		particleEffect.scaleMin = 0.75;
		particleEffect.scaleMax = 2.5;
		particleEffect.setEmitDirectionAngleProperties(1, -Math.PI/2, 120 * Math.PI / 180);
		
		particleEffect.startXAmplitude = 200 * pxScale;
		
		particleEffect.x = 83 * pxScale;
		particleEffect.y = 10 * pxScale;
		var maxBoundsHeight:int = layoutHelper.stageHeight * 1.6;
		var maxBoundsWidth:int = layoutHelper.stageWidth*1.3;
		particleEffect.boundsRect = new Rectangle(particleEffect.x - maxBoundsWidth / 2, particleEffect.y - maxBoundsHeight, maxBoundsWidth, maxBoundsHeight + 150 * pxScale);
		
		addChildAt(particleEffect, 0);
		particleEffect.play(750, 140, 90, 0);
		//particleEffect.play(1, 1, 1, 0);
	}
	
    private function handler_timer(event:TimerEvent):void 
	{
		if (gameManager.deactivated) {
			if (!Game.hasEventListener(Game.ACTIVATED, handler_gameActivated))
				Game.addEventListener(Game.ACTIVATED, handler_gameActivated);
			return;
		}

        var timeFinish:Number = gameManager.periodicBonusManager.nextTakeTime;

		/*if (d == 0) 
			d = TimeService.serverTimeMs + 60000;
		timeFinish = d;*/
		
        var timeout:Number = Math.max(0.0, timeFinish - TimeService.serverTimeMs);
		
        if (timeout <= 0) 
		{
            timer.stop();

			showFillViews = false;
			
			timerLabel.pivotX = timerLabel.textBounds.width / 2;
			timerLabel.x += timerLabel.pivotX;
			
			var tween_0:Tween = new Tween(timerLabel, 0.3, Transitions.EASE_IN_BACK);
			var tween_1:Tween = new Tween(timerLabel, 0.3, Transitions.EASE_OUT_BACK);
			
			tween_0.animate('scaleX', 0.3);
			tween_0.nextTween = tween_1;
			tween_0.onComplete = changeTimerLabelToReady;
			
			tween_1.animate('scaleX', 1);
			tween_1.onComplete = EffectsManager.jump;
			tween_1.onCompleteArgs = [timerLabel, 1000, 1, 1.1, 0.12, 0.12, 1.3, 2, 0, 1.3, true];
			Starling.juggler.add(tween_0);
			
            EffectsManager.jump(progressFillImage, -1, 1, 1, 0.7, 0.3, 0, 0, 0, 2, true);
		} 
		else 
		{
            if (!timer.running) 
                timer.start();
            
			showFillViews = true;

			timerLabel.pivotX = 0;
			timerLabel.text = StringUtils.formatTime(timeout / 1000, "{1}:{2}:{3}", false, false, true);
			alignTimerLabel();
        }

        var currentProgress:Number = 1.0 - timeout / gameManager.periodicBonusManager.takeInterval;

        progress(Math.max(0.0, currentProgress));
    }
	
	private function handler_gameActivated(e:Event):void 
	{
		Game.removeEventListener(Game.ACTIVATED, handler_gameActivated)
		handler_timer(null);
	}	
	
	private function alignTimerLabel():void
    {
		if (gameManager.deactivated || !gameManager.hasStage3D)
			return;
	
		var newTimerLabelX:int = (progressButton.width - timerLabel.textBounds.width)/2;
		if ((Math.abs(newTimerLabelX - oldTimerLabelX) > 8 * pxScale) || (timerLabel.x != oldTimerLabelX)) {
			timerLabel.x = newTimerLabelX;
			oldTimerLabelX = newTimerLabelX;
		}
	}
	
	private function changeTimerLabelToReady():void
    {
		if (gameManager.deactivated)
			return;
			
		timerLabel.text = "READY!";
		timerLabel.pivotX = timerLabel.textBounds.width / 2;
		timerLabel.x = timerLabel.pivotX + (progressButton.width - timerLabel.textBounds.width)/2 + 6 * pxScale;
	}

    private function progress(ratio:Number = 0):void 
	{
		_progress = ratio;
		
		var progressWidth:Number = 3 * pxScale + (progressFillImage.texture.frameWidth - 6 * pxScale) * ratio;
		
		if (progressFillImage.mask/* && !Starling.juggler.containsTweens(progressFillImage.mask)*/) {
			Starling.juggler.removeTweens(progressFillImage.mask);
			Starling.juggler.tween(progressFillImage.mask, ratio == 0 ? 1.2 : 0.5, { width: progressWidth, transition:Transitions.EASE_OUT, onUpdate:onTweenUpdateProgress });
		}
	}
	
	private function onTweenUpdateProgress():void 
	{
		if (!progressFillImage.mask)
			return;
		
		if(waveAnimation)	
			waveAnimation.x = progressFillImage.mask.width - 2 * pxScale;
	}
	
	private function set showFillViews(value:Boolean):void 
	{
		if (value)
		{
			if (!progressGlow)
			{
				var childIndex:int = progressButton ? getChildIndex(progressButton) : 0;
				//childIndex++;
				
				progressGlow = new Image(AtlasAsset.CommonAtlas.getTexture("controls/cash_bar_glow"));
				progressGlow.x = 2*pxScale;
				progressGlow.y = 27 * pxScale;
				progressGlow.scale9Grid = ResizeUtils.getScaledRect(0, 19, 0, 1);
				progressGlow.height = 84 * pxScale;
				addChildAt(progressGlow, childIndex++);
				
				waveAnimation = new AnimationContainer(MovieClipAsset.PackBase);
				//waveAnimation.alpha = 0.7;
				waveAnimation.pivotX = 42*pxScale;
				waveAnimation.pivotY = 41*pxScale;
				waveAnimation.y = 28*pxScale + 41*pxScale;
				waveAnimation.repeatCount = 0;
				waveAnimation.playTimeline('wave', false, true, 24);
				addChildAt(waveAnimation, childIndex++);
				
				waveAnimationMask = new Image(AtlasAsset.CommonAtlas.getTexture("controls/cash_bar_progress"));
				waveAnimationMask.style = new TextureMaskStyle();
				addChildAt(waveAnimationMask, childIndex++);
				waveAnimation.mask = waveAnimationMask;
				
				
				progressLight = new Image(AtlasAsset.CommonAtlas.getTexture("controls/cash_bar_light"));
				progressLight.alignPivot();
				progressLight.x = 20*pxScale;
				progressLight.y = 69 * pxScale;
				progressLight.scaleX = 0.7;
				addChildAt(progressLight, childIndex++);
				
				Starling.juggler.tween(progressGlow, 0.4, {alpha:0.6, repeatCount:0, reverse:true});
				Starling.juggler.tween(progressLight, 0.4, {scaleY:0.9, scaleX:0.55, alpha:1, repeatCount:0, reverse:true});
				//setInterval(function():void {var ss:Number = DevUtils.getNextValue('12', [0, 0.005, 0.01, 0.02, 0.03, 0.045, 0.5, 0.96, 0.97, 0.98, 0.99, 1]); progress(ss); trace(ss) },  2000);
			}
			
			if (!progressParticles) {
				progressParticles = new ParticleExplosion(AtlasAsset.CommonAtlas, new <String> ["effects/puff_ball"]);
				progressParticles.x = 15 * pxScale;
				progressParticles.y = 42 * pxScale;
				progressParticles.setProperties(0, 0, 2.8, -0.003, 0.03, -0.008/pxScale, 0.0);
				progressParticles.setFineProperties(0.4*pxScale, 0.7*pxScale, 0.0, 0.0, 0.0, 0.0, 56*pxScale);
				progressParticles.setDirectionAngleProperties(0.04, 4, 0.0);
				progressParticles.setEmitDirectionAngleProperties(1, 0, 0);
				addChildAt(progressParticles, childIndex++);// getChildIndex(progressGlassImage));
			}
			
			if(!progressParticles.isPlaying)
				progressParticles.play(0, 16, 0, 180);
		}
		else
		{
			if (progressGlow)
			{
				Starling.juggler.removeTweens(progressGlow);
				progressGlow.removeFromParent();
				progressGlow = null;
				
				Starling.juggler.removeTweens(progressLight);
				progressLight.removeFromParent();
				progressLight = null;
				
				waveAnimation.dispose();
				waveAnimation.removeFromParent();
				waveAnimation = null;
				
				waveAnimationMask.removeFromParent();
				waveAnimationMask = null;
			}
			
			if(progressParticles)
				progressParticles.stop();
		}
		
	}
	
	public override function dispose():void
	{
		Game.removeEventListener(Game.ACTIVATED, handler_gameActivated);
		
		if (timer) {
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, handler_timer);
		}
		
		EffectsManager.removeJump(progressFillImage);
		EffectsManager.removeJump(timerLabel);
		
		super.dispose();
	}

}
}