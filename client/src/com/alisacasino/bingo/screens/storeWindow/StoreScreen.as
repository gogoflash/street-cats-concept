package com.alisacasino.bingo.screens.storeWindow 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.commands.player.UpdateLobbyBarsTrueValue;
	import com.alisacasino.bingo.controls.PlayerResourceBarView;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.IDialog;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.FullscreenDialogBase;
	import com.alisacasino.bingo.screens.storeWindow.chests.ChestStoreContent;
	import com.alisacasino.bingo.screens.storeWindow.powerups.PowerupsStoreContent;
	import com.alisacasino.bingo.store.IStoreItem;
	import com.alisacasino.bingo.store.items.CashStoreItem;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.FriendsManager;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.UIUtils;
	import com.alisacasino.bingo.utils.tooltips.TooltipTrigger;
	import feathers.controls.BasicButton;
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.controls.ToggleButton;
	import feathers.core.FeathersControl;
	import feathers.core.ToggleGroup;
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.Align;
	import starling.utils.TweenHelper;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class StoreScreen extends FullscreenDialogBase
	{
		static public const CASH_MODE:int = 0;
		static public const POWERUPS_MODE:int = 1;
		static public const CHESTS_MODE:int = 2;
		
		private var storeItemsContainer:LayoutGroup;
		private var activeButtonBackground:Image;
		
		private var _mode:int = CASH_MODE;
		private var toggleGroup:ToggleGroup;
		private var animationContainer:AnimationContainer;
		private var currentContent:FeathersControl;
		private var firstDraw:Boolean = true;
		private var storeItemsBackground:Image;
		private var storeContentContainer:Sprite;
		private var resourceProgressView:PlayerResourceBarView;
		
		private var lastShowPlayerResourceProgressType:int = -1;
		private var catTooltipTrigger:TooltipTrigger;
		
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
		
		public function StoreScreen(mode:int) 
		{
			this.mode = mode;
			setTitle("STORE");
		}
		
		public function playCashBuyAnimation():void 
		{
			if (animationContainer)
			{
				animationContainer.playTimeline("cat_dollar", true, false);
				animationContainer.repeatCount = 3;
				animationContainer.addEventListener(Event.COMPLETE, animationContainer_completeHandler);
			}
		}
		
		public function handlePurchaseCompleted(item:IStoreItem, purchasedPowerups:Object = null):void 
		{
			if (gameManager.storeData.isCashItem(item.itemId))
			{
				playCashBuyAnimation();
				showPlayerResourceProgressView(Type.CASH);
			}
			else
			{
				playPowerupBuyAnimation();
				if (currentContent && currentContent is PowerupsStoreContent)
				{
					(currentContent as PowerupsStoreContent).showBuyAnimation(item, purchasedPowerups);
				}
				showPlayerResourceProgressView(Type.POWERUP);
			}
		}
		
		public function handlePowerupPurchaseComplete():void {
			showPlayerResourceProgressView(Type.POWERUP);
			playPowerupBuyAnimation();
		}
		
		public function playPowerupBuyAnimation():void 
		{
			if (animationContainer)
			{
				animationContainer.playTimeline("cat_happy", true, false);
				animationContainer.repeatCount = 3;
				animationContainer.addEventListener(Event.COMPLETE, animationContainer_completeHandler);
			}
		}
		
		private function animationContainer_completeHandler(e:Event):void 
		{
			animationContainer.playTimeline("cat_idle", false, true);
			animationContainer.removeEventListener(Event.COMPLETE, animationContainer_completeHandler);
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
			
			storeItemsContainer = new LayoutGroup();
			storeItemsContainer.x = storeItemsBackground.x;
			storeItemsContainer.y = storeItemsBackground.y;
			storeItemsContainer.setSize(915*pxScale, 592*pxScale);
			storeContentContainer.addChild(storeItemsContainer);
			
			storeContentContainer.alignPivot(Align.CENTER, Align.BOTTOM);
			storeContentContainer.x = 323*pxScale + storeContentContainer.width / 2;
			storeContentContainer.y = 99*pxScale + storeContentContainer.height;
			
			animationContainer = new AnimationContainer(MovieClipAsset.PackBase, true);
			animationContainer.pivotX = 140 * pxScale;
			animationContainer.pivotY = 340 * pxScale;
			animationContainer.x = 160 * pxScale;
			animationContainer.y = 360 * pxScale;
			contentContainer.addChild(animationContainer);
			animationContainer.playTimeline("cat_idle", true, true, 60);
			
			catTooltipTrigger = new TooltipTrigger(280 * pxScale, 340 * pxScale, "", Align.RIGHT);
			catTooltipTrigger.x = 20 * pxScale;
			catTooltipTrigger.y = 20 * pxScale;
			contentContainer.addChild(catTooltipTrigger);
		}
		
		private function getToggleGroupX():Number
		{
			return 24*pxScale;
		}
		
		private function animateAppearance():void 
		{
			SoundManager.instance.setSoundtrackVolume(SoundManager.BACKGROUND_STORE_VOLUME);
			SoundManager.instance.playSfx(mode == POWERUPS_MODE ? SoundAsset.PowerUpStore : SoundAsset.CashStore);
			
			backgroundQuad.y = - backgroundQuad.height;
			Starling.juggler.tween(backgroundQuad, 0.23, { y:0 } );
			
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
			
			animationContainer.y = -500 * pxScale;
			animationContainer.alpha = 0;
			animationContainer.scaleY = 2;
			
			TweenHelper.tween(animationContainer, 0.1, { alpha:1 } );
			
			TweenHelper.tween(animationContainer, 0.3, { delay: 0.2, y:360 * pxScale } )
				.chain(animationContainer, 0.1, {scaleX: 1.4, scaleY:0.6} )
				.chain(animationContainer, 0.3, {scaleX: 0.8, scaleY:1.2, transition:Transitions.EASE_IN_OUT} )
				.chain(animationContainer, 0.2, { scaleX: 1, scaleY:1, transition:Transitions.EASE_OUT_BACK } );
				
			title.alpha = 0;
			Starling.juggler.tween(title, 0.2, { delay: 0.45, alpha:1, transition:Transitions.EASE_OUT } );
				
			closeButton.scale = 0;
			TweenHelper.tween(closeButton, 0.2, { delay: 0.6, scale: contentContainer.scale*1.2, transition: Transitions.EASE_OUT } )
				.chain(closeButton, 0.15, { scale: contentContainer.scale, transition:Transitions.EASE_IN_CUBIC_OUT_BACK } );
		}
		
		
		private function createButtons():void 
		{
			toggleGroup = new ToggleGroup();
			toggleGroup.isSelectionRequired = true;
			
			toggleGroup.addItem(createButton(CASH_MODE, "CASH"));
			toggleGroup.addItem(createButton(POWERUPS_MODE, "POWER-UPS"));
			toggleGroup.addItem(createButton(CHESTS_MODE, "CHESTS"));
			
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
			button.y = (394 + 95*modeIndex)* pxScale;
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
				storeItemsContainer.removeChildren();
				
				if (toggleGroup.selectedIndex != mode)
				{
					toggleGroup.selectedIndex = mode;
				}
				setButtonBackgroundToIndex(mode);
				
				var animationDelay:Number = firstDraw ? 0.283 : 0;
				
				switch(mode)
				{
					default:
					case CASH_MODE:
						catTooltipTrigger.touchable = false;
						currentContent = new CashStoreContent(animationDelay);
						break;
					case POWERUPS_MODE:
						catTooltipTrigger.touchable = true;
						catTooltipTrigger.text = Constants.POWERUPS_CAT_TOOLTIP_TEXT;
						currentContent = new PowerupsStoreContent(this, animationDelay);
						break;
					case CHESTS_MODE:
						catTooltipTrigger.touchable = false;
						currentContent = new ChestStoreContent(this, animationDelay);
						break;
				}
				
				removePlayerResourceProgressView();
			}
			
			if(currentContent)
				storeItemsContainer.addChild(currentContent);
			
			if (firstDraw)
			{
				animateAppearance();
			}
			
			firstDraw = false;
		}
		
		private function setButtonBackgroundToIndex(index:int):void 
		{
			//activeButtonBackground.x = toggleGroup.getItemAt(index).x;
			activeButtonBackground.y = toggleGroup.getItemAt(index).y;
		}
		
		override public function close():void 
		{
			SoundManager.instance.setSoundtrackVolume(SoundManager.BACKGROUND_VOLUME);
			
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
			
			TweenHelper.tween(animationContainer, 0.2, {delay: 0.2, alpha:0 } );
			
			TweenHelper.tween(animationContainer, 0.15, { scaleX:1.2, scaleY:0.6, transition:Transitions.EASE_OUT} )
				.chain(animationContainer, 0.15, { scaleX:0.9, scaleY:1.6, transition:Transitions.EASE_IN } )
			
			Starling.juggler.delayCall(removeDialog, 0.5); 
			
			removePlayerResourceProgressView();
			
			if (Player.current)
			{
				if (!Player.current.isActivePlayer && 
				(Player.current.cashCount <= Constants.CRITICAL_VALUE_CASH || gameManager.powerupModel.powerupsTotal <= Constants.CRITICAL_VALUE_ENERGY))
					FriendsManager.instance.showInviteFriendsDialog(FriendsManager.DIALOG_MODE_GET_FREE_CASH, false);
			}
			
		}
		
		override protected function resizeContent():void 
		{
			super.resizeContent();
			
			title.y = closeButton.y - title.height/2 + 3 * pxScale * outerScale;
			
			var freeTopHeight:int = getContentY() + 100 * pxScale * contentContainer.scale;
			closeButton.y = freeTopHeight/2;
			title.y = closeButton.y - title.height / 2;
			
			
			alignPlayerResourceProgressView();
		}
		
		private function showPlayerResourceProgressView(type:int):void 
		{
			if (gameManager.deactivated) {
				Game.addEventListener(Game.ACTIVATED, handler_gameActivated);
				lastShowPlayerResourceProgressType = type;
				return;
			}
			
			if (!resourceProgressView) 
			{
				resourceProgressView = new PlayerResourceBarView(type);
				addChild(resourceProgressView);
				resourceProgressView.setProperties(15 * pxScale, -2 * pxScale, 15 * pxScale, 3 * pxScale);
			}
			else
			{
				addChild(resourceProgressView);
				resourceProgressView.type = type;
			}
			
			if (type == Type.POWERUP) {
				//resourceProgressView.setProperties( -5 * pxScale, -2 * pxScale, 36 * pxScale, 3 * pxScale);
				resourceProgressView.value = gameManager.powerupModel.powerupsTotal - gameManager.powerupModel.reservedPowerupsCount;
				resourceProgressView.animate(gameManager.powerupModel.powerupsTotal, 1.5, 0.5);
			}
			else if (type == Type.CASH) {
				//resourceProgressView.setProperties( -5 * pxScale, -2 * pxScale, 36 * pxScale, 3 * pxScale);
				resourceProgressView.value = Player.current.cashCount - Player.current.reservedCashCount;
				resourceProgressView.animate(Player.current.cashCount, 1.5, 0.5);
			}
			
			new UpdateLobbyBarsTrueValue(0).execute();
			
			alignPlayerResourceProgressView();
			
			resourceProgressView.show(0);
			
			resourceProgressView.hide(2.8);
			
			//contentContainer.addChild(resourceProgressView);
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
		
	}

}

import com.alisacasino.bingo.assets.AtlasAsset;
import com.alisacasino.bingo.controls.XTextField;
import com.alisacasino.bingo.controls.XTextFieldStyle;
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
		
		var centralCell:Image = new Image(gameManager.skinningData.dauberSkin.getTexture("magicdaub"));
		centralCell.scale = 0.7;
		centralCell.alignPivot();
		centralCell.touchable = false;
		container.addChild(centralCell);
		
		plate = new Image(AtlasAsset.CommonAtlas.getTexture("store/under_construction_plate"));
		plate.x = wall.x+295 * pxScale;
		plate.y = wall.y+79 * pxScale;
		plate.pivotX = 189.3 * pxScale;
		plate.pivotY = 7.0 * pxScale;
		plate.touchable = false;
		container.addChild(plate);
		
		centralCell.x = plate.x + 15 * pxScale;
		centralCell.y = plate.y + 154 * pxScale;
		
		addBreakImage(390, (-150 * Math.PI) / 180, Math.PI)
		addBreakImage(380, (-26.5 * Math.PI) / 180, Math.PI)
		addBreakImage(364, (34 * Math.PI) / 180)
		addBreakImage(324, (150 * Math.PI) / 180)
		
		//tweenCick(7 * Math.PI / 180);
		
		plate.rotation = 7 * Math.PI / 180;
		tweenRotatePlate(0.7, -plate.rotation * 0.85);
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
}