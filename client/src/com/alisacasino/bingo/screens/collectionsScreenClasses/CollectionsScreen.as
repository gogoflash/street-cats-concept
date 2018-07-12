package com.alisacasino.bingo.screens.collectionsScreenClasses 
{
	import avmplus.getQualifiedClassName;
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.components.FadeQuad;
	import com.alisacasino.bingo.controls.StarTitle;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.controls.dustConversionClasses.DustBar;
	import com.alisacasino.bingo.controls.dustConversionClasses.DustOverlay;
	import com.alisacasino.bingo.dialogs.IDialog;
	import com.alisacasino.bingo.models.collections.Collection;
	import com.alisacasino.bingo.models.collections.CollectionPage;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.FullscreenDialogBase;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.CardItemRenderer;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.InventoryOverlayBase;
	import com.alisacasino.bingo.utils.EffectsManager;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.UIUtils;
	import com.alisacasino.bingo.utils.tooltips.TooltipTrigger;
	import feathers.controls.BasicButton;
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.controls.SpinnerList;
	import feathers.controls.ToggleButton;
	import feathers.core.FeathersControl;
	import feathers.core.ToggleGroup;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalSpinnerLayout;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
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
	public class CollectionsScreen extends FullscreenDialogBase
	{
		static public const SHOW_CARD_OVERLAY:String = "showCardOverlay";
		static public const SHOW_PAGE_PRIZE_OVERLAY:String = "showPagePrizeOverlay";
		static public const LOCK_INTERACTION:String = "lockInteraction";
		static public const UNLOCK_INTERACTION:String = "unlockInteraction";
		
		private var activeOptionBackground:Image;
		private var spinnerList:SpinnerList;
		private var collectionContainer:CollectionContainer;
		
		private var _spinnerIndex:int = 0;
		private var animationContainer:AnimationContainer;
		private var pageRewardOverlay:PageRewardOverlay;
		private var interactionLocker:Quad;
		private var firstDraw:Boolean;
		private var collectionContainerSprite:Sprite;
		private var scrollDownButton:Button;
		private var scrollUpButton:Button;
		private var catTooltipTrigger:TooltipTrigger;
		
		private var overlay:InventoryOverlayBase;
		private var dustOverlay:DustOverlay;
		private var dustBar:DustBar;
		private var dustBarY:int;
		
		private function get spinnerIndex():int 
		{
			return _spinnerIndex;
		}
		
		private function set spinnerIndex(value:int):void 
		{
			if (_spinnerIndex != value)
			{
				_spinnerIndex = value;
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		public function CollectionsScreen() 
		{
			setTitle("COLLECTIONS");
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			animationContainer = new AnimationContainer(MovieClipAsset.PackBase, true);
			animationContainer.playTimeline("cat_reading", true, true, 60);
			animationContainer.validate();
			animationContainer.pivotX = 140 * pxScale;
			animationContainer.pivotY = 340 * pxScale;
			animationContainer.x = 160 * pxScale;
			animationContainer.y = 360 * pxScale;
			contentContainer.addChild(animationContainer);
			
			catTooltipTrigger = new TooltipTrigger(280 * pxScale, 340 * pxScale, "Hello there! This is your Collections\nscreen. All of the cards you get from\nchests end up here!\n\nCards can be <font color=\"#47cdbc\">Normal</font>, <font color=\"#00ccff\">Silver</font> or <font color=\"#ffc000\">Gold</font>.\n\nCollect all <font color=\"#f440ff\">8 cards</font> on one page to earn\nthe trophy and a nice reward! You can also\nconvert excess cards into <font color=\"#24E734\">Emerald Dust</font>\nto spend on a Super chest!", Align.RIGHT);
			catTooltipTrigger.x = 20 * pxScale;
			catTooltipTrigger.y = 20 * pxScale;
			contentContainer.addChild(catTooltipTrigger);

			activeOptionBackground = new Image(AtlasAsset.CommonAtlas.getTexture("store/grey_background"));
			activeOptionBackground.scale9Grid = ResizeUtils.scaleRect(new Rectangle(24, 24, 2, 2)); 
			activeOptionBackground.width = 460 * pxScale;
			activeOptionBackground.height = SelectorListRenderer.HEIGHT * pxScale;
			activeOptionBackground.x = 17 * pxScale;
			activeOptionBackground.y = (426 + SelectorListRenderer.HEIGHT) * pxScale;
			contentContainer.addChild(activeOptionBackground);
			
			var spinnerListLayout:VerticalSpinnerLayout = new VerticalSpinnerLayout();
			//spinnerListLayout.requestedRowCount = 3;s
			spinnerListLayout.gap = 6 * pxScale;
			spinnerListLayout.repeatItems = true;
			
			spinnerList = new SpinnerList();
			spinnerList.y = 420 * pxScale;
			spinnerList.width = 340 * pxScale;
			spinnerList.height = SelectorListRenderer.HEIGHT * 3 * pxScale + spinnerListLayout.gap * 2;
			spinnerList.layout = spinnerListLayout;
			spinnerList.itemRendererType = SelectorListRenderer;
			spinnerList.addEventListener(Event.CHANGE, spinnerList_changeHandler);
			contentContainer.addChild(spinnerList);
			
			scrollUpButton = new Button();
			scrollUpButton.defaultSkin = createArrowSkin( -1);
			scrollUpButton.scaleWhenDown = 0.7;
			scrollUpButton.x = -3 * pxScale;
			scrollUpButton.y = 323 * pxScale;
			scrollUpButton.addEventListener(Event.TRIGGERED, scrollUpButton_triggeredHandler);
			contentContainer.addChild(scrollUpButton);
			scrollUpButton.validate();
			UIUtils.alignPivotAndMove(scrollUpButton);
			
			scrollDownButton = new Button();
			scrollDownButton.defaultSkin = createArrowSkin(1);
			scrollDownButton.scaleWhenDown = 0.7;
			scrollDownButton.x = -3 * pxScale;
			scrollDownButton.y = 571 * pxScale;
			scrollDownButton.addEventListener(Event.TRIGGERED, scrollDownButton_triggeredHandler);
			contentContainer.addChild(scrollDownButton);
			scrollDownButton.validate();
			UIUtils.alignPivotAndMove(scrollDownButton);
			
			collectionContainerSprite = new Sprite();
			collectionContainerSprite.x = 357*pxScale;
			collectionContainerSprite.y = 115*pxScale;
			contentContainer.addChild(collectionContainerSprite);
			
			var collectionContainerBackground:Image = new Image(AtlasAsset.CommonAtlas.getTexture("store/grey_background"));
			collectionContainerBackground.scale9Grid = ResizeUtils.scaleRect(new Rectangle(24, 24, 2, 2));
			collectionContainerBackground.width  = 900*pxScale;
			collectionContainerBackground.height = 586*pxScale;
			collectionContainerSprite.addChild(collectionContainerBackground);
			
			collectionContainer = new CollectionContainer();
			collectionContainer.x = collectionContainerBackground.x;
			collectionContainer.y = collectionContainerBackground.y;
			collectionContainer.setSize(collectionContainerBackground.width, collectionContainerBackground.height);
			//collectionContainerSprite.addChild(collectionContainer);
			
			UIUtils.alignPivotAndMove(collectionContainerSprite, Align.CENTER, Align.BOTTOM);
			
			collectionContainer.addEventListener(SHOW_CARD_OVERLAY, collectionContainer_showCardOverlayHandler);
			collectionContainer.addEventListener(SHOW_PAGE_PRIZE_OVERLAY, collectionContainer_showPagePrizeOverlayHandler);
			collectionContainer.addEventListener(LOCK_INTERACTION, collectionContainer_lockInteractionHandler);
			collectionContainer.addEventListener(UNLOCK_INTERACTION, collectionContainer_unlockInteractionHandler);
			collectionContainer.addEventListener(CollectionContainer.PAGE_CHANGE, collectionContainer_pageChangeHandler);
			
			var data:ListCollection = new ListCollection(gameManager.collectionsData.collectionList);
			spinnerList.dataProvider = data;
			
			dustBar = new DustBar();
			dustBar.addEventListener(Event.TRIGGERED, dustBar_triggeredHandler);
			addChild(dustBar);
			
			pageRewardOverlay = new PageRewardOverlay();
			addChild(pageRewardOverlay);
			
			interactionLocker = new Quad(1, 1, 0xFF00FF);
			interactionLocker.alpha = 0;
			interactionLocker.touchable = false;
			addChild(interactionLocker);
			
			spinnerList.selectedItem = gameManager.tournamentData.collection;
			spinnerList.scrollToDisplayIndex(spinnerList.selectedIndex, 0);
			_spinnerIndex = spinnerList.selectedIndex;
			
			firstDraw = true;
			
			addEventListener(CardItemRenderer.EVENT_CARD_BURN, handler_cardBurn);
		}
		
		private function collectionContainer_pageChangeHandler(e:Event):void 
		{
			pageRewardOverlay.updateData(collectionContainer.selectedPage);
		}
		
		private function collectionContainer_unlockInteractionHandler(e:Event):void 
		{
			interactionLocker.touchable = false;
		}
		
		private function collectionContainer_lockInteractionHandler(e:Event):void 
		{
			interactionLocker.touchable = true;
		}
		
		private function collectionContainer_showPagePrizeOverlayHandler(e:Event):void 
		{
			var collectionPage:CollectionPage = e.data as CollectionPage;
			if (!collectionPage)
			{
				return;
			}
			
			pageRewardOverlay.showOverlayForPage(collectionPage, collectionContainer);
		}
		
		private function collectionContainer_showCardOverlayHandler(e:Event):void 
		{
			var renderer:CollectionItemRenderer = e.data as CollectionItemRenderer;
			if (!renderer)
			{
				return;
			}
			
			if(!overlay) {
				overlay = new InventoryOverlayBase();
				addChild(overlay);
			}
			resizeOverlays();
			
			overlay.showOverlay(renderer);
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
		
		
		private function createArrowSkin(arrowScale:Number):DisplayObject
		{
			var skin:Sprite = new Sprite();
			var quad:Quad = new Quad(380 * pxScale, 180 * pxScale, 0xff00ff);
			quad.visible = false;
			skin.addChild(quad);
			var arrowImage:Image = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/collections/arrow"));
			arrowImage.scaleY = arrowScale;
			arrowImage.alignPivot();
			arrowImage.x = quad.width / 2;
			arrowImage.y = quad.height / 2;
			skin.addChild(arrowImage);
			return skin;
		}
		
		private function scrollUpButton_triggeredHandler(e:Event):void 
		{
			SoundManager.instance.playSfx(SoundAsset.ButtonClick, 0, 0, SoundAsset.DEFAULT_BUTTON_CLICK_VOLUME, 0, true);
			
			spinnerIndex -= 1;
			if (spinnerIndex < 0)
			{
				spinnerIndex  = (spinnerList.dataProvider as ListCollection).length - 1;
			}
			showCollectionByIndex(spinnerIndex);
		}
		
		private function scrollDownButton_triggeredHandler(e:Event):void 
		{
			SoundManager.instance.playSfx(SoundAsset.ButtonClick, 0, 0, SoundAsset.DEFAULT_BUTTON_CLICK_VOLUME, 0, true);
			
			spinnerIndex += 1;
			if (spinnerIndex >= (spinnerList.dataProvider as ListCollection).length)
			{
				spinnerIndex = 0;
			}
			showCollectionByIndex(spinnerIndex);
		}
		
		private function showCollectionByIndex(spinnerIndex:int):void 
		{
			collectionContainer.collection = (spinnerList.dataProvider as ListCollection).getItemAt(spinnerIndex) as Collection;
		}
		
		private function spinnerList_changeHandler(e:Event):void 
		{
			collectionContainer.collection = spinnerList.selectedItem as Collection;
			spinnerIndex = spinnerList.selectedIndex;
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				spinnerList.scrollToDisplayIndex(spinnerIndex, 0.6);
			}
			
			if (firstDraw)
			{
				animateAppearance();
			}
			
			firstDraw = false;
			
			if (overlay)
			{
				overlay.removeFromParent();
				overlay = null;
			}
		}
		
		private function animateAppearance():void 
		{
			//SoundManager.instance.setSoundtrackVolume(SoundManager.BACKGROUND_LOW_VOLUME);
			SoundManager.instance.playSfx(SoundAsset.RoundResultsPopup);
			
			backgroundQuad.y = - backgroundQuad.height;
			Starling.juggler.tween(backgroundQuad, 0.2, { y:0 } );
			
			contentContainer.y = - contentContainer.height;
			TweenHelper.tween(contentContainer, 0.2, { y:getContentY() , onComplete: addCollectionContainer})
				.chain(collectionContainerSprite, 0.05, {scaleX:1.05, scaleY: 0.9, transition:Transitions.EASE_OUT} )
				.chain(collectionContainerSprite, 0.25, {scaleX:0.95, scaleY:1.1, transition:Transitions.EASE_IN_OUT})
				.chain(collectionContainerSprite, 0.2, { scaleX:1, scaleY:1, transition:Transitions.EASE_OUT_BACK } );
			
			animationContainer.y = -500 * pxScale;
			animationContainer.alpha = 0;
			animationContainer.scaleY = 2;
			
			TweenHelper.tween(animationContainer, 0.1, { alpha:1 } );
			
			TweenHelper.tween(animationContainer, 0.3, { delay: 0.1, y:360 * pxScale } )
				.chain(animationContainer, 0.1, {scaleX: 1.4, scaleY:0.6} )
				.chain(animationContainer, 0.3, {scaleX: 0.8, scaleY:1.2, transition:Transitions.EASE_IN_OUT} )
				.chain(animationContainer, 0.2, { scaleX: 1, scaleY:1, transition:Transitions.EASE_OUT_BACK } );
			
			activeOptionBackground.x = 350 * pxScale;
			Starling.juggler.tween(activeOptionBackground, 0.3, { delay: 0.2, x:17*pxScale, transition:Transitions.EASE_OUT_BACK } );
			
			spinnerList.x = 350 * pxScale;
			Starling.juggler.tween(spinnerList, 0.3, { delay: 0.3, x: 17 * pxScale, transition:Transitions.EASE_OUT_BACK } );
			
			makePopTween(scrollUpButton, 0.6);
			makePopTween(scrollDownButton, 0.6);
			
			title.alpha = 0;
			Starling.juggler.tween(title, 0.2, { delay: 0.45, alpha:1, transition:Transitions.EASE_OUT } );
				
			closeButton.scale = 0;
			TweenHelper.tween(closeButton, 0.2, { delay: 0.6, scale: contentContainer.scale*1.2, transition: Transitions.EASE_OUT } )
				.chain(closeButton, 0.15, { scale: contentContainer.scale, transition:Transitions.EASE_IN_CUBIC_OUT_BACK } );
				
			dustBar.y = -(dustBar.height + dustBar.pivotY);
			Starling.juggler.tween(dustBar, 0.2, { delay:0.45, y:dustBarY, transition:Transitions.EASE_OUT } );	
		}
		
		private function addCollectionContainer():void 
		{
			collectionContainerSprite.addChild(collectionContainer);
		}
		
		protected function makePopTween(target:DisplayObject, delay:Number):void
		{
			target.scale = 0;
			TweenHelper.tween(target, 0.2, { delay: delay, scale: 1.2, transition: Transitions.EASE_OUT } )
				.chain(target, 0.15, { scale: 1, transition:Transitions.EASE_IN_CUBIC_OUT_BACK } );
		}
		
		override protected function resizeContent():void 
		{
			super.resizeContent();
			
			var overlayScale:Number = contentContainer.scale;
			var overlayWidth:Number = layoutHelper.stageWidth / overlayScale;
			var overlayHeight:Number = layoutHelper.stageHeight/ overlayScale;
			
			pageRewardOverlay.scale = overlayScale;
			pageRewardOverlay.setSize(overlayWidth, overlayHeight);
			
			resizeOverlays();
			
			interactionLocker.width = layoutHelper.stageWidth;
			interactionLocker.height = layoutHelper.stageHeight;
			
			var freeTopHeight:int = getContentY() + 110 * pxScale * contentContainer.scale;
			closeButton.y = freeTopHeight/2;
			title.y = closeButton.y - title.height / 2;
			
			dustBar.scale = outerScale;
			dustBarY = Math.max(50 * pxScale * dustBar.scale, closeButton.y - 9 * pxScale * dustBar.scale);
			dustBar.y = dustBarY;
			dustBar.x = title.x + title.width + (closeButton.x - title.x - title.width - dustBar.width) / 2 + dustBar.pivotX + 20*pxScale*dustBar.scale; 
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
		
		override public function close():void 
		{
			//SoundManager.instance.setSoundtrackVolume(SoundManager.BACKGROUND_VOLUME);
			
			Starling.juggler.tween(backgroundQuad, 0.3, { delay: 0.2, y:-backgroundQuad.height, transition:Transitions.EASE_IN } );
			
			TweenHelper.tween(collectionContainerSprite, 0.15, { scaleX:1.2, scaleY:0.6, transition:Transitions.EASE_OUT} )
				.chain(collectionContainerSprite, 0.15, { scaleX:0.9, scaleY:1.6, transition:Transitions.EASE_IN } )
				.chain(contentContainer, 0.2, { y: - contentContainer.height } );
			
			Starling.juggler.tween(title, 0.2, { delay: 0.25, alpha:0, transition:Transitions.EASE_OUT } );
			
			Starling.juggler.tween(activeOptionBackground, 0.2, { delay: 0, x:350*pxScale, transition:Transitions.EASE_IN_BACK, onComplete: activeOptionBackground.removeFromParent} );
			
			Starling.juggler.tween(spinnerList, 0.2, { delay: 0.05, x:350 * pxScale, transition:Transitions.EASE_IN_BACK, onComplete:spinnerList.removeFromParent } );
			
			TweenHelper.tween(scrollUpButton, 0.15, { delay: 0.05, scale: 1.2, transition: Transitions.EASE_IN_CUBIC_OUT_BACK } )
				.chain(scrollUpButton, 0.2, { scale: 0, transition:Transitions.EASE_IN } );
				
			TweenHelper.tween(scrollDownButton, 0.15, { delay: 0.05, scale: 1.2, transition: Transitions.EASE_IN_CUBIC_OUT_BACK } )
				.chain(scrollDownButton, 0.2, { scale: 0, transition:Transitions.EASE_IN } );
			
			TweenHelper.tween(animationContainer, 0.2, {delay: 0.2, alpha:0 } );
			
			TweenHelper.tween(animationContainer, 0.15, { scaleX:1.2, scaleY:0.6, transition:Transitions.EASE_OUT} )
				.chain(animationContainer, 0.15, { scaleX:0.9, scaleY:1.6, transition:Transitions.EASE_IN } )
			
			Starling.juggler.delayCall(removeFromParent, 0.5, [true]); 
			
			if (Game.current && Game.current.gameScreen && Game.current.gameScreen.lobbyUI)
			{
//				Game.current.gameScreen.lobbyUI.refreshCollectionsButtonNewCount();
			}
			
			Starling.juggler.tween(dustBar, 0.2, { delay:0.2, y: -(dustBar.height + dustBar.pivotY), transition:Transitions.EASE_OUT} );	
			
			TweenHelper.tween(closeButton, 0.15, { delay: 0.0, scale: contentContainer.scale*1.1, transition: Transitions.EASE_OUT } )
				.chain(closeButton, 0.15, { scale: 0, transition:Transitions.EASE_IN_CUBIC_OUT_BACK } );
			
			removeEventListener(CardItemRenderer.EVENT_CARD_BURN, handler_cardBurn);
		}
		
		private function handler_cardBurn(event:Event):void
		{
			FadeQuad.show(this, 0.8, 0.65, false);
			
			var sourcePoint:Point = (event.target as CollectionItemRenderer).localToGlobal(new Point( -CardItemRenderer.WIDTH / 2 + 20 * pxScale, -CardItemRenderer.HEIGHT / 2 + 20 * pxScale));
			var startRandomAmplitudes:Point = new Point(CardItemRenderer.WIDTH/1.7, CardItemRenderer.HEIGHT/1.7);
			EffectsManager.particlesBezierTween(this, contentContainer.scale, AtlasAsset.CommonAtlas.getTexture("effects/green_puff"), sourcePoint, new Point(dustBar.x, dustBar.y), 30, startRandomAmplitudes);
			
			Starling.juggler.delayCall(FadeQuad.hide, 0.8, 0.6);
		}
	}
}

import com.alisacasino.bingo.controls.BaseFeathersRenderer;
import com.alisacasino.bingo.controls.XTextField;
import com.alisacasino.bingo.controls.XTextFieldStyle;
import com.alisacasino.bingo.models.collections.Collection;
import feathers.controls.List;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;

class SelectorListRenderer extends BaseFeathersRenderer
{
	private var label:XTextField;
	private var maskQuad:Quad;
	private var labelDark:XTextField;
	private var testQuad:Quad;
	
	public static const HEIGHT:Number = 74;
	
	private function get collectionData():Collection
	{
		return data as Collection;
	}
	
	override protected function draw():void 
	{
		super.draw();
		
		if (isInvalid(INVALIDATION_FLAG_DATA))
		{
			commitData();
		}
		
		updateMasking();
	}
	
	private function commitData():void 
	{
		if (collectionData && collectionData.name)
		{
			labelDark.text = label.text = collectionData.name.toUpperCase();
		}
	}
	
	
	public function SelectorListRenderer() 
	{
		super();
		
		maskQuad = new Quad(340*pxScale, (HEIGHT - 2)*pxScale, 0xff00ff);
		
		label = new XTextField(300*pxScale, 44*pxScale, XTextFieldStyle.getWalrus(60, 0xebebeb));
		label.autoScale = true;
		label.x = 20 * pxScale;
		label.y = 17 * pxScale;
		addChild(label);
		
		labelDark = new XTextField(300*pxScale, 44*pxScale, XTextFieldStyle.getWalrus(60, 0x3d3d3d));
		labelDark.autoScale = true;
		labelDark.visible = false;
		labelDark.x = 20 * pxScale;
		labelDark.y = 17 * pxScale;
		addChild(labelDark);
		
		setSizeInternal(340*pxScale, HEIGHT*pxScale, false);
		updateMasking();
	}
	
	override public function get y():Number 
	{
		return super.y;
	}
	
	override public function set y(value:Number):void 
	{
		super.y = value;
		updateMasking();
	}
	
	private function updateMasking():void 
	{
		if (!owner)
			return;
		
		var viewportY:Number = y - owner.verticalScrollPosition;
		if (viewportY >= 0 * pxScale && viewportY <= HEIGHT*2*pxScale)
		{
			labelDark.mask = maskQuad;
			maskQuad.y = HEIGHT * pxScale - viewportY - 10*pxScale;
			labelDark.visible = true;
		}
		else
		{
			labelDark.mask = null;
			labelDark.visible = false;
		}
	}
}