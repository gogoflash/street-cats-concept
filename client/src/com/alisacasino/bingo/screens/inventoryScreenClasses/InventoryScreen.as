package com.alisacasino.bingo.screens.inventoryScreenClasses 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.components.FadeQuad;
	import com.alisacasino.bingo.controls.dustConversionClasses.DustBar;
	import com.alisacasino.bingo.controls.PlayerResourceBarView;
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.models.skinning.SkinningData;
	import com.alisacasino.bingo.protocol.CustomizationType;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.FullscreenDialogBase;
	import com.alisacasino.bingo.controls.dustConversionClasses.DustOverlay;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.cardBackInventoryClasses.CardBackInventoryContent;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.dauberInventoryClasses.DauberInventoryContent;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.dauberInventoryClasses.DauberOverlay;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.voiceoverInventoryClasses.VoiceoverInventoryContent;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.UIUtils;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.tooltips.TooltipTrigger;
	import com.theintern.beziertween.BezierTween;
	import feathers.controls.LayoutGroup;
	import feathers.controls.ToggleButton;
	import feathers.core.FeathersControl;
	import feathers.core.ToggleGroup;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.Align;
	import starling.utils.TweenHelper;

	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class InventoryScreen extends FullscreenDialogBase
	{
		static public const DAUBER_MODE:int = 0;
		static public const CARD_BACK_MODE:int = 1;
		static public const VOICEOVER_MODE:int = 2;
		static public const FRAME_MODE:int = 3;
		static public const CAT_MODE:int = 4;
		static public const SHOW_CARD_OVERLAY:String = "showCardOverlay";
		static public const LOCK_INTERACTION:String = "lockInteraction";
		static public const UNLOCK_INTERACTION:String = "unlockInteraction";
		
		private var _mode:int = DAUBER_MODE;
		
		public function get mode():int 
		{
			return _mode;
		}
		
		public function set mode(value:int):void 
		{
			if (_mode != value)
			{
				_mode = value;
				invalidate(INVALIDATION_FLAG_STATE);
			}
		}
		
		public var setSoundtrackVolumeOnClose:Boolean = true;
		
		private var inventoryItemsContainer:LayoutGroup;
		private var activeButtonBackground:Image;
		
		private var toggleGroup:ToggleGroup;
		public var currentContent:FeathersControl;
		private var firstDraw:Boolean = true;
		private var storeItemsBackground:Image;
		private var storeContentContainer:Sprite;
		
		private var lastShowPlayerResourceProgressType:int = -1;
		private var resourceProgressView:PlayerResourceBarView;
		private var overlay:InventoryOverlayBase;
		private var interactionLocker:Quad;
		private var dustBar:DustBar;
		private var dustOverlay:DustOverlay;
		private var dustBarY:int;
		
		
		public function InventoryScreen(mode:int) 
		{
			this.mode = mode;
			setTitle("INVENTORY");
			
			setCategoryByNewItems();
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			activeButtonBackground = new Image(AtlasAsset.CommonAtlas.getTexture("store/grey_background"));
			activeButtonBackground.x = getToggleGroupX();
			activeButtonBackground.scale9Grid = ResizeUtils.scaleRect(new Rectangle(24, 24, 2, 2)); 
			activeButtonBackground.width = 390 * pxScale;
			activeButtonBackground.height = 94 * pxScale;
			contentContainer.addChild(activeButtonBackground);
			
			createButtons();
			
			storeContentContainer = new Sprite();
			contentContainer.addChild(storeContentContainer);
			
			storeItemsBackground = new Image(AtlasAsset.CommonAtlas.getTexture("store/grey_background"));
			storeItemsBackground.scale9Grid = ResizeUtils.scaleRect(new Rectangle(24, 24, 2, 2));
			storeItemsBackground.width  = 915*pxScale;
			storeItemsBackground.height = 592 * pxScale;
			storeContentContainer.addChild(storeItemsBackground);
			
			inventoryItemsContainer = new LayoutGroup();
			inventoryItemsContainer.x = storeItemsBackground.x;
			inventoryItemsContainer.y = storeItemsBackground.y;
			inventoryItemsContainer.setSize(915*pxScale, 592*pxScale);
			storeContentContainer.addChild(inventoryItemsContainer);
			
			storeContentContainer.alignPivot(Align.CENTER, Align.BOTTOM);
			storeContentContainer.x = 323*pxScale + storeContentContainer.width / 2;
			storeContentContainer.y = 99*pxScale + storeContentContainer.height;
			
			dustBar = new DustBar();
			dustBar.addEventListener(Event.TRIGGERED, dustBar_triggeredHandler);
			addChild(dustBar);
			
			
			/*gameManager.skinningData.addEventListener(SkinningData.EVENT_CARD_SKIN_CHANGED, handler_cardSkinChanged);
			gameManager.skinningData.addEventListener(SkinningData.EVENT_DAUBER_SKIN_CHANGED, handler_dauberSkinChanged);
			gameManager.skinningData.addEventListener(SkinningData.EVENT_VOICEOVER_CHANGED, handler_voiceoverChanged);*/
			interactionLocker = new Quad(1, 1, 0xFF00FF);
			interactionLocker.alpha = 0;
			interactionLocker.touchable = false;
			addChild(interactionLocker);
			
			addEventListener(SHOW_CARD_OVERLAY, showCardOverlayHandler);
			
			addEventListener(CardItemRenderer.EVENT_CARD_BURN, handler_cardBurn);
		}
		
		private function animateAppearance():void 
		{
			//SoundManager.instance.setSoundtrackVolume(SoundManager.BACKGROUND_STORE_VOLUME);
			SoundManager.instance.playSfx(SoundAsset.CashStore);
			
			backgroundQuad.y = - backgroundQuad.height;
			Starling.juggler.tween(backgroundQuad, 0.2, { y:0 } );
			
			contentContainer.y = - contentContainer.height;
			TweenHelper.tween(contentContainer, 0.2, { y:getContentY() } )
				.chain(storeContentContainer, 0.05, {scaleX:1.2, scaleY: 0.6, transition:Transitions.EASE_OUT } )
				.chain(storeContentContainer, 0.25, {scaleX:0.9, scaleY:1.2, transition:Transitions.EASE_IN_OUT})
				.chain(storeContentContainer, 0.2, {scaleX:1, scaleY:1, transition:Transitions.EASE_OUT_BACK});
			
			activeButtonBackground.x = 350 * pxScale;
			Starling.juggler.tween(activeButtonBackground, 0.3, { delay: 0.2, x:getToggleGroupX(), transition:Transitions.EASE_OUT_BACK } );
			
			for (var i:int = 0; i < toggleGroup.numItems; i++) 
			{
				var button:DisplayObject = toggleGroup.getItemAt(i) as DisplayObject;
				button.x = 350 * pxScale;
				Starling.juggler.tween(button, 0.3, { delay: 0.25 + i*0.05, x:getToggleGroupX(), transition:Transitions.EASE_OUT_BACK } );
			}
				
			title.alpha = 0;
			Starling.juggler.tween(title, 0.2, { delay: 0.45, alpha:1, transition:Transitions.EASE_OUT } );
				
			closeButton.scale = 0;
			TweenHelper.tween(closeButton, 0.2, { delay: 0.6, scale: contentContainer.scale*1.2, transition: Transitions.EASE_OUT } )
				.chain(closeButton, 0.15, { scale: contentContainer.scale, transition:Transitions.EASE_IN_CUBIC_OUT_BACK } );
				
			dustBar.y = -(dustBar.height + dustBar.pivotY);
			Starling.juggler.tween(dustBar, 0.2, { delay:0.45, y:dustBarY, transition:Transitions.EASE_OUT } );	
		}
		
		private function createButtons():void 
		{
			toggleGroup = new ToggleGroup();
			toggleGroup.isSelectionRequired = true;
			
			toggleGroup.addItem(createButton(DAUBER_MODE, "DAUBERS"));
			toggleGroup.addItem(createButton(CARD_BACK_MODE, "CARD SKINS"));
			toggleGroup.addItem(createButton(VOICEOVER_MODE, "CALLERS"));
			toggleGroup.addItem(createButton(FRAME_MODE, "FRAMES"));
			toggleGroup.addItem(createButton(CAT_MODE, "YOUR PET"));
			
			toggleGroup.selectedIndex = mode;
			
			toggleGroup.addEventListener(Event.CHANGE, toggleGroup_changeHandler);
		}
		
		private function toggleGroup_changeHandler(e:Event):void 
		{
			mode = toggleGroup.selectedIndex;
		}
		
		private function createButton(modeIndex:int, label:String):ToggleButton 
		{
			var button:ToggleButton = new ToggleButton();
			button.x = getToggleGroupX();
			button.y = (99.05 + /*95*/124.6*modeIndex)* pxScale;
			button.defaultSkin = new SelectorButtonSkin(label);
			button.defaultSelectedSkin = new SelectorButtonSkin(label, true);
			contentContainer.addChild(button);
			return button;
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_STATE))
			{
				inventoryItemsContainer.removeChildren();
				
				if (toggleGroup.selectedIndex != mode)
				{
					toggleGroup.selectedIndex = mode;
				}
				setButtonBackgroundToIndex(mode);
				
				var animationDelay:Number = firstDraw ? 0.283 : 0;
				
				switch(mode)
				{
					case DAUBER_MODE:
						currentContent = new DauberInventoryContent();
						break;
					case CARD_BACK_MODE:
						currentContent = new CardBackInventoryContent();
						break;
					case VOICEOVER_MODE:
						currentContent = new VoiceoverInventoryContent();
						SelectBubbleContent.cleanLastPlayedVoiceoverId();
						break;
					default:
						currentContent = new UnderConstructionContent(animationDelay);//new CashStoreContent(animationDelay);
						break;
				}
				
				if (overlay)
				{
					overlay.removeFromParent();
					overlay = null;
				}
			
				//invalidate(INVALIDATION_FLAG_SIZE);
				
				removePlayerResourceProgressView();
			}
			
			if(currentContent)
				inventoryItemsContainer.addChild(currentContent);
			
			if (firstDraw)
			{
				animateAppearance();
			}
			
			firstDraw = false;
		}
		
		private function dustBar_triggeredHandler(e:Event):void 
		{
			if (!dustOverlay)
			{
				dustOverlay = new DustOverlay();
				addChild(dustOverlay);
				resizeOverlays();
			}
			
			dustOverlay.showOverlayForBar(dustBar);
		}
		
		private function showCardOverlayHandler(e:Event):void 
		{
			if (currentContent && currentContent is InventoryContentBase)
			{
				var overlayClass:Class = (currentContent as InventoryContentBase).overlayClass;
				if (overlayClass)
				{
					overlay = new overlayClass();
					addChild(overlay);
					resizeOverlays();
				}
			}
			
			if (overlay)
			{
				overlay.showOverlay(e.data as InventoryItemRenderer);
			}
		}
		
		private function getToggleGroupX():Number
		{
			return 24*pxScale;
		}
		
		
		private function setButtonBackgroundToIndex(index:int):void 
		{
			//activeButtonBackground.x = toggleGroup.getItemAt(index).x;
			activeButtonBackground.y = toggleGroup.getItemAt(index).y;
		}
		
		override public function close():void 
		{
			//if(setSoundtrackVolumeOnClose)
				//SoundManager.instance.setSoundtrackVolume(SoundManager.BACKGROUND_VOLUME);
			
			Starling.juggler.tween(backgroundQuad, 0.3, { delay: 0.2, y:-backgroundQuad.height, transition:Transitions.EASE_IN } );
			
			TweenHelper.tween(storeContentContainer, 0.15, { scaleX:1.2, scaleY:0.6, transition:Transitions.EASE_OUT} )
				.chain(storeContentContainer, 0.15, { scaleX:0.9, scaleY:1.6, transition:Transitions.EASE_IN } )
				.chain(contentContainer, 0.2, { y: - contentContainer.height } );
			
			Starling.juggler.tween(title, 0.2, { delay: 0.25, alpha:0, transition:Transitions.EASE_OUT } );
			
			Starling.juggler.tween(activeButtonBackground, 0.2, { delay: 0, x:350*pxScale, transition:Transitions.EASE_IN_BACK, onComplete: activeButtonBackground.removeFromParent} );
			
			for (var i:int = 0; i < toggleGroup.numItems; i++) 
			{
				var button:DisplayObject = toggleGroup.getItemAt(i) as DisplayObject;
				Starling.juggler.tween(button, 0.2, { delay: i*0.05, x:350*pxScale, transition:Transitions.EASE_IN_BACK, onComplete:button.removeFromParent} );
			}
			
			
			Starling.juggler.delayCall(removeDialog, 0.5); 
			
			removeEventListener(CardItemRenderer.EVENT_CARD_BURN, handler_cardBurn);
			
			TweenHelper.tween(closeButton, 0.15, { delay: 0.0, scale: contentContainer.scale*1.1, transition: Transitions.EASE_OUT } )
				.chain(closeButton, 0.15, { scale: 0, transition:Transitions.EASE_IN_CUBIC_OUT_BACK } );
			
			Starling.juggler.tween(dustBar, 0.2, { delay:0.2, y: -(dustBar.height + dustBar.pivotY), transition:Transitions.EASE_OUT} );	
			
			gameManager.skinningData.cleanUnnecessarySkins();
		}
		
		override protected function resizeContent():void 
		{
			super.resizeContent();
		
			alignPlayerResourceProgressView();
			
			var overlayScale:Number = contentContainer.scale;
			var overlayWidth:Number = layoutHelper.stageWidth / overlayScale;
			var overlayHeight:Number = layoutHelper.stageHeight/ overlayScale;
			
			var freeTopHeight:int = getContentY() + 100 * pxScale * contentContainer.scale;
			closeButton.y = freeTopHeight/2;
			title.y = closeButton.y - title.height / 2;
			
			dustBar.scale = outerScale;
			dustBarY = Math.max(50 * pxScale * dustBar.scale, closeButton.y - 9 * pxScale * dustBar.scale);
			dustBar.y = dustBarY;
			dustBar.x = 70 * pxScale * dustBar.scale;
			
			//Starling.current.stage.addChild(UIUtils.drawQuad('11questsEdge', contentContainer.x, 0, contentContainer.width, contentContainer.y + 100*pxScale*contentContainer.scale, 0.3));
			
			resizeOverlays();
			
			interactionLocker.width = layoutHelper.stageWidth;
			interactionLocker.height = layoutHelper.stageHeight;
		}
		
		private function resizeOverlays():void 
		{
			var overlayScale:Number = contentContainer.scale;
			var overlayWidth:Number = layoutHelper.stageWidth / overlayScale;
			var overlayHeight:Number = layoutHelper.stageHeight/ overlayScale;
			
			if (overlay)
			{
				overlay.scale = overlayScale;
				overlay.setSize(overlayWidth, overlayHeight);
			}
			
			if (dustOverlay)
			{
				dustOverlay.scale = overlayScale;
				dustOverlay.setSize(overlayWidth, overlayHeight);
			}
		}
		
		private function showPlayerResourceProgressView(type:int):void 
		{/*
			if (gameManager.deactivated) {
				Game.addEventListener(Game.ACTIVATED, handler_gameActivated);
				lastShowPlayerResourceProgressType = type;
				return;
			}
			
			
			if (!resourceProgressView) 
			{
				resourceProgressView = new PlayerResourceBarView(AtlasAsset.CommonAtlas, "bars/base_glow", type == Type.POWERUP ? 'bars/energy' : 'bars/cash', XTextFieldStyle.getWalrus(33, 0xFFFFFF).setShadow(), null);
				addChild(resourceProgressView);
				resourceProgressView.setProperties(15 * pxScale, -2 * pxScale, 15 * pxScale, 3 * pxScale);
			}
			else
			{
				addChild(resourceProgressView);
				if(type == Type.POWERUP)
					resourceProgressView.reInit(AtlasAsset.CommonAtlas, "bars/base_glow", 'bars/energy', XTextFieldStyle.getWalrus(33, 0xFFFFFF).setShadow());
				else if (type == Type.CASH)
					resourceProgressView.reInit(AtlasAsset.CommonAtlas, "bars/base_glow", 'bars/cash', XTextFieldStyle.getWalrus(33, 0xFFFFFF).setShadow());	
			}
			
			if (type == Type.POWERUP) {
				//resourceProgressView.setProperties( -5 * pxScale, -2 * pxScale, 36 * pxScale, 3 * pxScale);
				resourceProgressView.value = gameManager.powerupModel.powerupsTotal - gameManager.powerupModel.reservedPowerupsCount;
				resourceProgressView.animate(gameManager.powerupModel.powerupsTotal, 0.5);
			}
			else if (type == Type.CASH) {
				//resourceProgressView.setProperties( -5 * pxScale, -2 * pxScale, 36 * pxScale, 3 * pxScale);
				resourceProgressView.value = Player.current.cashCount - Player.current.reservedCashCount;
				resourceProgressView.animate(Player.current.cashCount, 0.5);
			}
			
			new UpdateLobbyBarsTrueValue(0).execute();
			
			alignPlayerResourceProgressView();
			
			resourceProgressView.show(0);
			
			resourceProgressView.hide(2.8);
			
			//contentContainer.addChild(resourceProgressView);
			*/
		}
		
		private function handler_gameActivated(e:Event):void 
		{
			Game.removeEventListener(Game.ACTIVATED, handler_gameActivated);
			if (lastShowPlayerResourceProgressType != -1) {
				showPlayerResourceProgressView(lastShowPlayerResourceProgressType);
				lastShowPlayerResourceProgressType = -1;
			}
		}
		
		private function alignPlayerResourceProgressView():void 
		{
			if (resourceProgressView) {
				resourceProgressView.scale = outerScale;
				resourceProgressView.x = title.x + title.width + (closeButton.x - title.width - title.x)/2 - resourceProgressView.width/2;
				resourceProgressView.y = closeButton.y //closeButton.y + (title.y - closeButton.y) / 2;
			}
		}
		
		private function removePlayerResourceProgressView():void 
		{
			if (resourceProgressView) {
				resourceProgressView.hide(0);
			}
		}
		
		private function handler_cardBurn(event:Event):void
		{
			FadeQuad.show(this, 0.8, 0.65, false);
			
			var sourcePoint:Point = (event.target as InventoryItemRenderer).localToGlobal(new Point( -CardItemRenderer.WIDTH / 2 + 20 * pxScale, -CardItemRenderer.HEIGHT / 2 + 20 * pxScale));
			var startRandomAmplitudes:Point = new Point(CardItemRenderer.WIDTH/1.7, CardItemRenderer.HEIGHT/1.7);
			EffectsManager.particlesBezierTween(this, contentContainer.scale, AtlasAsset.CommonAtlas.getTexture("effects/green_puff"), sourcePoint, new Point(dustBar.x, dustBar.y), 30, startRandomAmplitudes);
			
			Starling.juggler.delayCall(FadeQuad.hide, 0.8, 0.6);
		}
	
		private function setCategoryByNewItems():void 
		{
			var newItems:Vector.<CustomizerItemBase> = gameManager.skinningData.newCustomizerItems;
			if (newItems.length == 0)
				return;
				
			var categories:Array = [];
			
			for (var i:int = 0; i < newItems.length; i++) 
			{
				categories.push(getCategoryByCustomizerType(newItems[i].type));
			}
			
			categories.sort(Array.NUMERIC);
			
			if (categories[0] != -1)
				_mode = categories[0];
		}
		
		private function getCategoryByCustomizerType(customizerType:int):int
		{
			switch(customizerType) {
				case CustomizationType.DAUB_ICON: 	return DAUBER_MODE;
				case CustomizationType.CARD: 		return CARD_BACK_MODE;
				case CustomizationType.VOICEOVER: 	return VOICEOVER_MODE;
				case CustomizationType.AVATAR: 	return FRAME_MODE;
				//case CustomizerType.: return CAT_MODE;
			}
			return -1;
		}
	}

}

import com.alisacasino.bingo.assets.AtlasAsset;
import com.alisacasino.bingo.controls.XTextField;
import com.alisacasino.bingo.controls.XTextFieldStyle;
import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
import com.alisacasino.bingo.resize.ResizeUtils;
import com.alisacasino.bingo.utils.caurina.transitions.properties.DisplayShortcuts;
import feathers.core.FeathersControl;
import flash.utils.getTimer;
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
import starling.textures.Texture;

class SelectorButtonSkin extends Sprite
{
	/*
	private var _selected:Boolean;
	
	public function get selected():Boolean 
	{
		return _selected;
	}
	
	public function set selected(value:Boolean):void 
	{
		if (_selected != value)
		{
			_selected = value;
			updateState();
		}
	}
	*/
	
	public function SelectorButtonSkin(text:String, selected:Boolean = false) 
	{
		super();
		
		var quad:Quad = new Quad(299*pxScale, 94*pxScale, 0xff00ff);
		quad.alpha = 0;
		addChild(quad);
		
		var labelColor:uint = selected ? 0x3d3d3d : 0xebebeb;
		
		var label:XTextField = new XTextField(294*pxScale, 44*pxScale, XTextFieldStyle.getWalrus(60, labelColor), text);
		label.autoScale = true;
		label.y = 27 * pxScale;
		addChild(label);
	}
}

class UnderConstructionContent extends FeathersControl
{
	private var animationDelay:Number;
	private var container:Sprite;
	private var plate:Image;
	private var wall:Image;
	private var centerImage:Image;
	
	private var breakImages:Array;
	private var breakImagesPositions:Array;
	
	private var cickAmplitudeMax:Number = 65 * Math.PI/ 180;
	private var cickAmplitudeMin:Number = 10 * Math.PI/ 180;
	private var cickAmplitude:Number = 10 * Math.PI/ 180;
	private var cickAmplitudeAdd:Number = 10 * Math.PI / 180;
	
	private var cickMaxCount:int = 0;
	
	public function UnderConstructionContent(animationDelay:Number) 
	{
		this.animationDelay = animationDelay;
		breakImages = [];
		breakImagesPositions = [];
		
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		addEventListener(Event.REMOVED_FROM_STAGE, onRemovedToStage);
	}
	
	private function onAddedToStage(e:Event):void
	{
		addEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}
	
	private function onRemovedToStage(e:Event):void
	{
		removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}
	
	override protected function initialize():void 
	{
		super.initialize();
		
		container = new Sprite();
		addChild(container);
		
		wall = new Image(AtlasAsset.CommonAtlas.getTexture("store/wall"));
		wall.x = 470 * pxScale - wall.width/2 - 33 * pxScale;
		wall.y = 275 * pxScale - wall.height/2 + 20 * pxScale;
		container.addChild(wall);
		
		wall.addEventListener(TouchEvent.TOUCH, onTouch);
	
		centerImage = new Image(Texture.empty(1,1));
		centerImage.scale = 0.7;
		centerImage.alignPivot();
		centerImage.touchable = false;
		container.addChild(centerImage);
		
		plate = new Image(AtlasAsset.CommonAtlas.getTexture("store/under_construction_plate"));
		plate.x = wall.x+295 * pxScale;
		plate.y = wall.y+79 * pxScale;
		plate.pivotX = 189.3 * pxScale;
		plate.pivotY = 7.0 * pxScale;
		plate.touchable = false;
		container.addChild(plate);
		
		centerImage.x = plate.x + 15 * pxScale;
		centerImage.y = plate.y + 154 * pxScale;
		
		addBreakImage(390, (-150 * Math.PI) / 180, Math.PI)
		addBreakImage(380, (-26.5 * Math.PI) / 180, Math.PI)
		addBreakImage(364, (34 * Math.PI) / 180)
		addBreakImage(324, (150 * Math.PI) / 180)
		
		//tweenCick(7 * Math.PI / 180);
		
		plate.rotation = 7 * Math.PI / 180;
		tweenRotatePlate(0.7, -plate.rotation * 0.85);
		
		gameManager.skinningData.dauberSkin.addEventListener(CustomizerItemBase.EVENT_RESOURCES_LOADED, handler_dauberLoaded);
		handler_dauberLoaded(null);
	}
	 
	private function handler_dauberLoaded(event:Event):void 
	{
		if (gameManager.skinningData.dauberSkin.isLoaded) {
			centerImage.texture = gameManager.skinningData.dauberSkin.getTexture('magicdaub');
			centerImage.readjustSize();
			centerImage.scale = 0.7;
			centerImage.alignPivot();
		}
		else {
			centerImage.texture = Texture.empty(1, 1);
		}
	}
	
	protected function addBreakImage(distance:int, angle:Number, rotationAddAngle:Number = 0):Image
	{
		var image:Image = new Image(AtlasAsset.CommonAtlas.getTexture("store/break"));
		image.alignPivot();
		image.x = wall.x + wall.width/2 + distance * pxScale * Math.cos(angle);
		image.y = wall.y + wall.height/2 + distance * pxScale * Math.sin(angle);
		image.rotation = angle - (35 * Math.PI) / 180 + rotationAddAngle;
		image.touchable = false;
		addChild(image);
		
		breakImages.push(image);
		breakImagesPositions.push([image.x, image.y]);
		
		return image;
	}
	
	private function enterFrameHandler(e:Event):void 
	{
		cickAmplitude = Math.max(cickAmplitude - 0.45 * Math.PI/ 180, cickAmplitudeMin);
	}
	
	private function tweenCick(customAmplitude:Number = 0):void 
	{
		cickAmplitude = customAmplitude == 0 ? Math.min(cickAmplitude + cickAmplitudeAdd, cickAmplitudeMax) : customAmplitude;
		
		var ratio:Number = Math.max(cickAmplitude/(cickAmplitudeMax - 23 * Math.PI/ 180) - 1, 0) ;
		
		Starling.juggler.removeTweens(container);
		tweenShake(container, 0, 0, 0.1, 10*ratio);
		
		var i:int;
		for (i = 0; i < breakImages.length; i++ ) {
			Starling.juggler.removeTweens(breakImages[i]);
			tweenShake(breakImages[i], breakImagesPositions[i][0], breakImagesPositions[i][1], 0.1, ratio*10);
		}
	
		var clockWiseCoefficient:int = plate.rotation >= 0 ? 1 : -1;
		var localCickAmplitude:Number = cickAmplitude * clockWiseCoefficient;
		Starling.juggler.removeTweens(plate);
		
		if(cickAmplitude >= Math.abs(cickAmplitudeMax))
			cickMaxCount++;
			
		if (cickMaxCount >= 8) {
			cickMaxCount = 0;
			Starling.juggler.tween(plate, 0.5, { rotation:(localCickAmplitude + Math.PI * 2 * clockWiseCoefficient), transition:Transitions.EASE_OUT, onComplete:tweenRotatePlate, onCompleteArgs:[0.7, -localCickAmplitude*0.8]});
			return;
		}
			
		var firstTweenTimeRatio:Number = Math.min(0.3, cickAmplitudeMax - Math.abs(plate.rotation));//= //Math.max(1 - (cickAmplitude-cickAmplitudeMin) / (cickAmplitudeMax - cickAmplitudeMin), 0) ;	
		Starling.juggler.tween(plate, 0.3*firstTweenTimeRatio, { rotation:localCickAmplitude, transition:Transitions.EASE_OUT, onComplete:tweenRotatePlate, onCompleteArgs:[0.7, -localCickAmplitude*0.8]});
	}
	
	private function tweenRotatePlate(time:Number, rotation:Number, transitionIn:String = null):void 
	{
		if (Math.abs(rotation) < ((0.3 * Math.PI) / 180)) {
			Starling.juggler.tween(plate, time/2, { rotation:0, transition:Transitions.EASE_IN});
		}
		else 
		{
			var tween:Tween = new Tween(plate, time / 2, Transitions.EASE_OUT);
			tween.animate('rotation', rotation);
			tween.onComplete = tweenRotatePlate;
			tween.onCompleteArgs = [time * 0.95, -rotation * 0.8];
			
			Starling.juggler.tween(plate, time/2, { rotation:0, transition:(transitionIn || Transitions.EASE_IN), nextTween:tween});
		}
	}

	private function onTouch(event:TouchEvent):void
	{
		var touch:Touch = event.getTouch(wall);
		if (touch == null)
			return;

		if (touch.phase == TouchPhase.BEGAN) 
		{
			tweenCick();
		}
	}
	
	private function tweenShake(view:DisplayObject, x:Number, y:Number, time:Number, distance:Number):void 
	{
		var angle:Number = Math.random() * 2 * Math.PI;
		if (Math.abs(distance) < 1)
			Starling.juggler.tween(view, time/2, {x:x, y:y, transition:Transitions.EASE_OUT });
		else 
			Starling.juggler.tween(view, time, {x:(x + distance * pxScale * Math.cos(angle)), y:(y + distance * pxScale * Math.sin(angle)), transition:Transitions.EASE_OUT, onComplete:tweenShake, onCompleteArgs:[view, x, y, time * 0.75, distance * 0.5]});
	}
	
	override public function dispose():void
	{
		gameManager.skinningData.dauberSkin.removeEventListener(CustomizerItemBase.EVENT_RESOURCES_LOADED, handler_dauberLoaded);
		super.dispose();
	}
	
}