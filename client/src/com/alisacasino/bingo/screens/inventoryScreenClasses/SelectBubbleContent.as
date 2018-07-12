package com.alisacasino.bingo.screens.inventoryScreenClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.commands.ShowNoMoneyPopup;
	import com.alisacasino.bingo.components.CardsIconView;
	import com.alisacasino.bingo.components.Scale9Image;
	import com.alisacasino.bingo.components.Scale9Textures;
	import com.alisacasino.bingo.controls.XButton;
	import com.alisacasino.bingo.controls.XButtonStyle;
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.models.skinning.CustomizerSet;
	import com.alisacasino.bingo.models.skinning.SkinningDauberData;
	import com.alisacasino.bingo.models.skinning.VoiceoverData;
	import com.alisacasino.bingo.protocol.CustomizationType;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.utils.tooltips.TooltipTrigger;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class SelectBubbleContent extends BubbleContentBase 
	{
		public function SelectBubbleContent() 
		{
			super();
			//isHeaderCloseButton = true
			//headerHintString = "Bla bla\n blaaaaa bla bla <font color=\"#ff5846\">BLA</font> in your bla.\n\nBla-s are used in the bla of Bla\nto give you a little bit of bla!";
		}
		
		private var selectButton:XButton;
		private var selectFrame:Scale9Image;
		
		private var dauberPreview:DauberPreview;
		private var cardPreview:CardPreview;
		private var voiceoverPreview:VoiceoverPreview;
		private var selectCommonView:Image;
		
		public static var lastPlayedVoiceoverId:int = -1;
		public static var sampleVoiceoverPlayed:Boolean;
		
		private var burnButton:XButton;
		private var burnFrame:Scale9Image;
		private var burnCardsView:CardsIconView;
		
		override protected function initialize():void
		{
			super.initialize();
			
			var frameTexture:Texture = AtlasAsset.CommonAtlas.getTexture("dialogs/inventory/dot_square");
			selectFrame = new Scale9Image(new Scale9Textures(frameTexture, ResizeUtils.getScaledRect(13, 14, 61, 59)));
			selectFrame.color = 0xDDDDDD;
			selectFrame.touchable = false;
			selectFrame.isTiled = true;
			selectFrame.width = 204 * pxScale;
			selectFrame.height = 201 * pxScale;
			selectFrame.x = 23 * pxScale;
			selectFrame.y = 122 * pxScale;
			addChild(selectFrame);
			
			selectButton = new XButton(XButtonStyle.GreenSelect, 'SELECT', 'SELECT');
			selectButton.alignPivot();
			selectButton.x = 125*pxScale;
			selectButton.y = 307*pxScale;
			selectButton.addEventListener(Event.TRIGGERED, handler_select);
			addChild(selectButton);
			
			burnFrame = new Scale9Image(new Scale9Textures(frameTexture, ResizeUtils.getScaledRect(13, 14, 61, 59)));
			burnFrame.color = 0xDDDDDD;
			burnFrame.isTiled = true;
			burnFrame.width = 204 * pxScale;
			burnFrame.height = 201 * pxScale;
			burnFrame.x = 245 * pxScale;
			burnFrame.y = 122 * pxScale;
			burnFrame.touchable = false;
			addChild(burnFrame);
			
			burnCardsView = new CardsIconView(CardsIconView.ONE_FLAMED_CARD, CardsIconView.COLOR_ORANGE);
			//burnCardsView = new CardsIconView(int(Math.random()*3), int(Math.random()*2), int(Math.random()*15));
			burnCardsView.x = 295 * pxScale;
			burnCardsView.y = 138 * pxScale;
			addChild(burnCardsView);
			
			burnButton = new XButton(XButtonStyle.OrangeBurn, 'BURN', 'BURN');
			burnButton.alignPivot();
			burnButton.x = 347*pxScale;
			burnButton.y = 307*pxScale;
			burnButton.addEventListener(Event.TRIGGERED, handler_burn);
			addChild(burnButton);
		}	
		
		override protected function draw():void
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				if (card) 
				{
					setHeaderButton();
					
					if (card.type == CustomizationType.DAUB_ICON) 
					{
						removePreview(false, true, true);
						var skinningDauberData:SkinningDauberData = gameManager.skinningData.loadDauberSkin(card.id);
						if (!dauberPreview) {
							dauberPreview = new DauberPreview(skinningDauberData);
							dauberPreview.x = 123 * pxScale;
							dauberPreview.y = 204 * pxScale;
							addChild(dauberPreview);
						}
						else {
							dauberPreview.skinningDauberData = skinningDauberData;
						}
						
						setHeaderButton(canBuySet ? "buttons/circle_red_query" : null);
					}
					else if (card.type == CustomizationType.CARD) 
					{
						removePreview(true, false, true);
						if (!cardPreview) {
							cardPreview = new CardPreview(gameManager.skinningData.loadCardSkin(card.id));
							cardPreview.x = 41 * pxScale;
							cardPreview.y = 140 * pxScale;
							addChildAt(cardPreview, getChildIndex(selectButton)-1);
						}
						setHeaderButton(canBuySet ? "buttons/circle_red_query" : null);
					}
					else if (card.type == CustomizationType.VOICEOVER) 
					{
						removePreview(true, true);
						if (!voiceoverPreview) {
							voiceoverPreview = new VoiceoverPreview(gameManager.skinningData.loadVoiceover(card.id));
							voiceoverPreview.x = 125 * pxScale;
							voiceoverPreview.y = 203 * pxScale;
							addChildAt(voiceoverPreview, getChildIndex(selectButton)-1);
						}
						
					}
					else if (card.type == CustomizationType.AVATAR) 
					{
						removePreview(true, true, true);
					}
					
					burnCardsView.count = card.quantity;
				}
				else
				{
					setHeaderButton();
					
					removePreview(true, true, true);
					burnCardsView.count = 0;
				}
			}
		}
		
		private function get canBuySet():Boolean 
		{
			if (!card || card.defaultItem)
				return false;
			
			var customizerSet:CustomizerSet = gameManager.skinningData.getSetByID(card.setID);
			if (!customizerSet)
				return false;
			
			if (card.type == CustomizationType.DAUB_ICON) 
				return customizerSet.cardBack && customizerSet.cardBack.quantity <= 0;
			else if (card.type == CustomizationType.CARD) 
				return customizerSet.dauber && customizerSet.dauber.quantity <= 0;
			
			return false;	
		}
		
		override public function dispose():void
		{
			removePreview(true, true, true);
			super.dispose();
		}
		
		private function removePreview(dauber:Boolean = false, card:Boolean = false, voiceover:Boolean = false):void 
		{
			if (dauber && dauberPreview) {
				dauberPreview.clean();
				dauberPreview.removeFromParent();
				dauberPreview = null;
			}
			
			if (card && cardPreview) {
				cardPreview.clean();
				cardPreview.removeFromParent();
				cardPreview = null;
			}
			
			if (card && voiceoverPreview) {
				voiceoverPreview.clean();
				voiceoverPreview.removeFromParent();
				voiceoverPreview = null;
			}
		}
		
		private function handler_select(e:Event):void 
		{
			gameManager.skinningData.applyCustomizer(card);
			dispatchEventWith(Event.CLOSE, true);
		}
		
		private function handler_burn(e:Event):void 
		{
			if (card && card.defaultItem) {
				var point:Point = localToGlobal(new Point(width/2, height/2));
				new ShowNoMoneyPopup(ShowNoMoneyPopup.PURPLE, Starling.current.stage, point, "YOU CAN'T BURN DEFAULTS!", false, 590).execute();
				return;	
			}
			
			dispatchEventWith(InventoryBubbleContent.EVENT_SHOW_BURN_CONTENT);
		}
		
		override protected function handler_triggeredHeaderButton(e:Event):void 
		{
			dispatchEventWith(InventoryBubbleContent.EVENT_SHOW_SET_PURCHASE_CONTENT);
		}
		
		public static function cleanLastPlayedVoiceoverId():void {
			lastPlayedVoiceoverId = -1;
		}
		
		public static function stopCurrentPreviewVoiceover(time:uint = 400):void 
		{
			var voiceoverData:VoiceoverData = gameManager.skinningData.getVoiceoverById(SelectBubbleContent.lastPlayedVoiceoverId);
			if (voiceoverData && voiceoverData.isSampleLoaded && voiceoverData.sampleAsset) 
			{
				voiceoverData.sampleAsset.stop(time == 0, time);
				lastPlayedVoiceoverId = -1;
			}
		}
		
		
	}

}

import adobe.utils.CustomActions;
import air.update.states.HSM;
import com.alisacasino.bingo.assets.AnimationContainer;
import com.alisacasino.bingo.assets.AtlasAsset;
import com.alisacasino.bingo.assets.MovieClipAsset;
import com.alisacasino.bingo.assets.SoundAsset;
import com.alisacasino.bingo.components.effects.ParticleExplosion;
import com.alisacasino.bingo.controls.XButton;
import com.alisacasino.bingo.controls.XButtonStyle;
import com.alisacasino.bingo.controls.XTextField;
import com.alisacasino.bingo.controls.XTextFieldStyle;
import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
import com.alisacasino.bingo.models.skinning.SkinningCardData;
import com.alisacasino.bingo.models.skinning.SkinningDauberData;
import com.alisacasino.bingo.models.skinning.VoiceoverData;
import com.alisacasino.bingo.screens.gameScreenClasses.CellDaubEffect;
import com.alisacasino.bingo.screens.inventoryScreenClasses.SelectBubbleContent;
import com.alisacasino.bingo.utils.Constants;
import com.alisacasino.bingo.utils.sounds.SoundManager;
import feathers.controls.Button;
import flash.utils.clearInterval;
import flash.utils.setInterval;
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.filters.ColorMatrixFilter;
import starling.utils.Align;

final class DauberPreview extends Sprite 
{
	private var _skinningDauberData:SkinningDauberData;
	private var dauberImage:Image;
	private var particlesView:DisplayObject;
	private var intervalId:int = -1;
	private var loadingAnimation:AnimationContainer;
	private var touchButton:Button;
	private var daubEffectType:String;
	
	private var debugDaubEffectTypeTextField:XTextField;
	
	public function DauberPreview(skinningDauberData:SkinningDauberData) 
	{
		this.skinningDauberData = skinningDauberData;
		
		var quad:Quad = new Quad(206*pxScale, 145*pxScale, 0);
		touchButton = new Button();
		touchButton.defaultSkin = quad;
		touchButton.addEventListener(Event.TRIGGERED, onTriggered);
		touchButton.alpha = 0.0;
		touchButton.invalidate();
		touchButton.validate();
		touchButton.alignPivot();
		touchButton.y = -15 * pxScale; 
		addChild(touchButton);
		
		if (Constants.isDevFeaturesEnabled) 
		{
			debugDaubEffectTypeTextField = new XTextField(212 * pxScale, 20 * pxScale, XTextFieldStyle.getWalrus(14, 0), skinningDauberData.particleAnimation);
			debugDaubEffectTypeTextField.x = 2*pxScale;
			debugDaubEffectTypeTextField.y = -107*pxScale;
			debugDaubEffectTypeTextField.autoScale = true;
			addChild(debugDaubEffectTypeTextField);
			debugDaubEffectTypeTextField.addEventListener(TouchEvent.TOUCH, onDebugTextFieldTouch);
		}
	}
	
	public function set skinningDauberData(value:SkinningDauberData):void 
	{
		if (_skinningDauberData == value)
			return;
		
		if (intervalId != -1) {
			clearInterval(intervalId);	
			intervalId = -1;
		}	
			
		if (particlesView) {
			CellDaubEffect.stop(particlesView);
			particlesView.removeFromParent();
			particlesView = null;
		}	
		
		if (dauberImage)
			Starling.juggler.removeTweens(dauberImage);
			
		if (_skinningDauberData)
			_skinningDauberData.removeEventListener(CustomizerItemBase.EVENT_RESOURCES_LOADED, handler_loaded);
		
		_skinningDauberData = value;
		
		if (_skinningDauberData) {
			daubEffectType = _skinningDauberData.particleAnimation;
			_skinningDauberData.addEventListener(CustomizerItemBase.EVENT_RESOURCES_LOADED, handler_loaded);
		}
			
		handler_loaded(null);	
	}
	
	private function handler_loaded(event:Event):void 
	{
		if (_skinningDauberData) {
			if (_skinningDauberData.isLoaded)
				createView();
			else
				showPreloader(true);
		}
		else {
			showPreloader(false);
		}
	}
	
	private function createView():void 
	{
		if (!dauberImage) {
			dauberImage = new Image(_skinningDauberData.atlas.getTexture("magicdaub"));
			dauberImage.alignPivot();
			//dauberImage.alpha = 0.3;
			dauberImage.touchable = false;
			addChild(dauberImage);
		}
		else {
			Starling.juggler.removeTweens(dauberImage);
			dauberImage.texture = _skinningDauberData.atlas.getTexture("magicdaub");
		}
		
		showPreloader(false);
		
		animate();
		
		if (intervalId != -1) {
			clearInterval(intervalId);
			intervalId = -1;
		}
		
		intervalId = setInterval(animate, 2000);
	}
	
	public function animate():void 
	{
		dauberImage.scaleX = 0;
		dauberImage.scaleY = 0.68;
			
		var tween_0:Tween = new Tween(dauberImage, 0.09, Transitions.EASE_OUT);
		var tween_1:Tween = new Tween(dauberImage, 0.07, Transitions.EASE_IN);
		var tween_2:Tween = new Tween(dauberImage, 0.06, Transitions.EASE_IN);
		var tween_3:Tween = new Tween(dauberImage, 0.46, Transitions.EASE_OUT_ELASTIC);
		
		//tween_0.delay = nextDelay * i;
		tween_0.animate('scaleX', 1.82);
		tween_0.animate('scaleY', 1.32);
		tween_0.nextTween = tween_1;
		
		tween_1.animate('scaleX', 0.87);
		tween_1.animate('scaleY', 1.36);
		tween_1.nextTween = tween_2;
		
		tween_2.animate('scaleX', 1.22);
		tween_2.animate('scaleY', 0.81);
		tween_2.nextTween = tween_3;
		
		tween_3.animate('scaleX', 1);
		tween_3.animate('scaleY', 1);
		
		//tween_2.onComplete = animateParticles;
		
		Starling.juggler.add(tween_0);
		
		
		animateParticles();
	}
	
	public function clean():void 
	{
		if (intervalId != -1) {
			clearInterval(intervalId);
			intervalId = -1;
		}
		
		if(dauberImage)
			Starling.juggler.removeTweens(dauberImage);
		
		if (particlesView) {
			CellDaubEffect.stop(particlesView);
			particlesView.removeFromParent();
			particlesView = null;
		}	
		
		if (_skinningDauberData)
			_skinningDauberData.removeEventListener(CustomizerItemBase.EVENT_RESOURCES_LOADED, handler_loaded);
	}
	
	private function animateParticles():void
	{
		if (_skinningDauberData && _skinningDauberData.atlas) {
			particlesView = CellDaubEffect.show(this, _skinningDauberData.atlas, _skinningDauberData.getParticlesTextureNames(false), daubEffectType);
		}
		else {
			
		}
	}
	
	private function onTriggered(event:Event):void
	{
		if (_skinningDauberData && _skinningDauberData.isLoaded) 
			animate();
	}
	
	private function onTouch(event:TouchEvent):void
	{
		event.stopImmediatePropagation();
	
		var touch:Touch = event.getTouch(this);
		if (touch == null)
			return;

		if (touch.phase == TouchPhase.BEGAN) 
		{
			/*if (_skinningDauberData && _skinningDauberData.isLoaded) 
				animate();*/
		}
		else if (touch.phase == TouchPhase.ENDED) 
		{
			if (_skinningDauberData && _skinningDauberData.isLoaded) 
				animate();
		}
	}
	
	private function showPreloader(value:Boolean):void
	{
		if (value)
		{
			if (!loadingAnimation) {
				loadingAnimation = new AnimationContainer(MovieClipAsset.PackBase);
				loadingAnimation.pivotX = 42 * pxScale;
				loadingAnimation.pivotY = 42 * pxScale;
				
				var colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter();
				colorMatrixFilter.adjustContrast( -0.5);
				colorMatrixFilter.adjustBrightness(-0.5);
				loadingAnimation.filter = colorMatrixFilter;
				//loadingAnimation.move(64 * pxScale, 84 * pxScale);
				addChild(loadingAnimation);
			}
			loadingAnimation.playTimeline('loading_white', true, true, 24);
			loadingAnimation.visible = true;
		}
		else
		{
			if (loadingAnimation) {
				loadingAnimation.stop();
				loadingAnimation.visible = false;
			}
		}
	}
	
	private function onDebugTextFieldTouch(event:TouchEvent):void
	{
		event.stopImmediatePropagation();
	
		var touch:Touch = event.getTouch(debugDaubEffectTypeTextField);
		if (touch == null)
			return;

		if (touch.phase == TouchPhase.ENDED) 
		{
			daubEffectType = CellDaubEffect.getNextEffectType(daubEffectType);	
			debugDaubEffectTypeTextField.text = daubEffectType;
			_skinningDauberData.particleAnimation = daubEffectType;
			animate();
		}
		
	}	
	/*private static function handler_particleStarsComplete(event:Event):void 
	{
		(event.target as ParticleExplosion).removeEventListener(Event.COMPLETE, handler_particleStarsComplete);
		(event.target as DisplayObject).removeFromParent();
	}*/
}

class CardPreview extends Sprite 
{
	private var _skinningCardData:SkinningCardData;
	private var cardImage:Image;
	private var markImage:Image;
	
	public function CardPreview(skinningCardData:SkinningCardData) {
		this.skinningCardData = skinningCardData;
		createView();
	}
	
	public function set skinningCardData(value:SkinningCardData):void 
	{
		/*if (_skinningCardData == value)
			return;
		
		if (_skinningCardData)
			_skinningCardData.removeEventListener(CustomizerItemBase.EVENT_RESOURCES_LOADED, handler_loaded);
		
		_skinningCardData = value;
		
		if (_skinningCardData)
			_skinningCardData.addEventListener(CustomizerItemBase.EVENT_RESOURCES_LOADED, handler_loaded);
			
		handler_loaded(null);	*/
	}
	
	private function handler_loaded(event:Event):void 
	{
		/*if (_skinningCardData && _skinningCardData.isLoaded) {
			createView();
		}*/
	}
	
	private function createView():void 
	{
		if (!cardImage) {
			cardImage = new Image(AtlasAsset.CommonAtlas.getTexture("buy_cards/card_green"));
			cardImage.scale = 0.77;
			addChild(cardImage);
			
			markImage = new Image(AtlasAsset.CommonAtlas.getTexture("buy_cards/checkmark"));
			markImage.scale = 0.72;
			markImage.x = 42 * pxScale;
			markImage.y = 33 * pxScale;
			addChild(markImage);
		}
		else {
			//cardImage.texture = _skinningCardData.atlas.getTexture("magicdaub");
		}
	}
	
	public function clean():void 
	{
		if (_skinningCardData)
			_skinningCardData.removeEventListener(CustomizerItemBase.EVENT_RESOURCES_LOADED, handler_loaded);
	}
}

class VoiceoverPreview extends Sprite 
{
	private var _voiceoverData:VoiceoverData;
	//private var cardImage:Image;
	private var playButton:XButton;
	
	public function VoiceoverPreview(voiceoverData:VoiceoverData) {
		this.voiceoverData = voiceoverData;
		createView();
	}
	
	public function set voiceoverData(value:VoiceoverData):void 
	{
		if (_voiceoverData == value)
			return;
		
		if (_voiceoverData) {
			_voiceoverData.removeEventListener(CustomizerItemBase.EVENT_RESOURCES_LOADED, handler_loaded);
			_voiceoverData.removeEventListener(VoiceoverData.EVENT_SAMPLE_LOADED, handler_sampleLoaded);
			
		}	
		
		_voiceoverData = value;
		
		if (_voiceoverData) {
			_voiceoverData.addEventListener(CustomizerItemBase.EVENT_RESOURCES_LOADED, handler_loaded);
			_voiceoverData.addEventListener(VoiceoverData.EVENT_SAMPLE_LOADED, handler_sampleLoaded);
		}
			
		handler_loaded(null);
		handler_sampleLoaded(null);
	}
	
	private function handler_sampleLoaded(event:Event):void 
	{
		if (_voiceoverData && _voiceoverData.isSampleLoaded) 
		{
			if (SelectBubbleContent.lastPlayedVoiceoverId == -1 || SelectBubbleContent.lastPlayedVoiceoverId != _voiceoverData.id || !SelectBubbleContent.sampleVoiceoverPlayed)
			{
				var previousVoiceoverData:VoiceoverData = gameManager.skinningData.getVoiceoverById(SelectBubbleContent.lastPlayedVoiceoverId);
				if (previousVoiceoverData && previousVoiceoverData.isSampleLoaded && previousVoiceoverData.sampleAsset) 
				{
					previousVoiceoverData.sampleAsset.stop(!event, 200);
					
					_voiceoverData.sampleAsset.play(null, true, 0);
					_voiceoverData.sampleAsset.setVolume(_voiceoverData.volume, 200);
				}
				else {
					_voiceoverData.sampleAsset.play(null, true, _voiceoverData.volume);
				}
				
				SelectBubbleContent.sampleVoiceoverPlayed = true;
				SelectBubbleContent.lastPlayedVoiceoverId = _voiceoverData.id;
			}
		}
	}

	private function handler_loaded(event:Event):void 
	{
		if (_voiceoverData && _voiceoverData.isLoaded) {
			
		}
	}
	
	private function createView():void 
	{
		if (!playButton) {
			playButton = new XButton(XButtonStyle.getStyle(AtlasAsset.CommonAtlas, "dialogs/inventory/play_button"));
			playButton.alignPivot();
			playButton.addEventListener(Event.TRIGGERED, playButton_triggeredHandler);
			addChild(playButton);
		}
		else {
			
		}
	}
	
	private function playButton_triggeredHandler(e:Event):void 
	{
		//if(_voiceoverData)
		//	handler_sampleLoaded(null);
		if (!_voiceoverData || !_voiceoverData.isSampleLoaded)
			return;
		
		//_voiceoverData.sampleAsset.stop(true);
		_voiceoverData.sampleAsset.play(null, true, _voiceoverData.volume);
		
		//SelectBubbleContent.voiceoverSampleAsset.sound.
		
		//if(_voiceoverData)
			//_voiceoverData.playSample();
	}
		
	public function clean():void 
	{
		if (_voiceoverData)
			_voiceoverData.removeEventListener(CustomizerItemBase.EVENT_RESOURCES_LOADED, handler_loaded);
	}
}
