package com.alisacasino.bingo.controls.dustConversionClasses 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.dustConversionClasses.DustBar;
	import com.alisacasino.bingo.controls.ImageAssetContainer;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.collectionsScreenClasses.CollectionsScreen;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.InventoryItemRenderer;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.InventoryScreen;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.UIUtils;
	import feathers.controls.BasicButton;
	import feathers.controls.LayoutGroup;
	import feathers.core.FeathersControl;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.utils.Align;
	import starling.utils.TweenHelper;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DustOverlay extends FeathersControl
	{
		private var sourceBar:DustBar;
		private var bubbleBackground:Image;
		private var bubbleTail:Image;
		private var bubble:LayoutGroup;
		private var overlayQuad:Quad;
		private var rendererCopy:ImageAssetContainer;
		private var bubbleContent:FeathersControl;
		private var overlayTrigger:BasicButton;
		private var anchorShift:Point;
		protected var overlayBubbleClass:Class;
		
		private var FINGER_SHIFT:int = 0;
		
		public function DustOverlay() 
		{
			
		}
		
		public function showOverlayForBar(dustBar:DustBar):void 
		{
			this.sourceBar = dustBar;
			
			anchorShift = new Point(0, - 10*pxScale);
			
			visible = true;
			
			invalidate();
			validate();
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			visible = false;
			
			
			
			overlayTrigger = new BasicButton();
			overlayTrigger.addEventListener(Event.TRIGGERED, overlayTrigger_triggeredHandler);
			addChild(overlayTrigger);
			overlayQuad = new Quad(1, 1, 0x0);
			overlayQuad.alpha = 0.5;
			overlayTrigger.defaultSkin = overlayQuad;
			
			rendererCopy = new ImageAssetContainer();
			rendererCopy.setPivot(Align.CENTER, Align.CENTER);
			rendererCopy.touchable = false;
			rendererCopy.scale = 0.85;
			addChild(rendererCopy);
			
			bubble = new LayoutGroup();
			
			bubbleContent = new DustBubbleContent();
			bubbleContent.addEventListener(Event.CLOSE, exchangeBubbleContent_closeHandler);
			
			bubbleBackground = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/chest/window_white_bg"));
			bubbleBackground.scale9Grid = ResizeUtils.getScaledRect(25, 25, 55, 55);
			bubbleBackground.width = bubbleContent.width;
			bubbleBackground.height = bubbleContent.height;
			bubble.addChild(bubbleBackground);
			
			bubble.addChild(bubbleContent);
			
			bubbleTail = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/chest/window_white_corner"));
			bubbleTail.alignPivot();
			bubble.addChild(bubbleTail);
			
			addChild(bubble);
			
			if(layoutHelper.isIPhoneX || Constants.isDevFeaturesEnabled)
				Game.addEventListener(Game.EVENT_ORIENTATION_CHANGED, handler_deviceOrientationChanged);
		}
		
		private function exchangeBubbleContent_closeHandler(e:Event):void 
		{
			dispatchEventWith(Event.CLOSE);
			hide();
			
			var inventoryScreen:InventoryScreen = DialogsManager.instance.getDialogByClass(InventoryScreen) as InventoryScreen;
			if (inventoryScreen) {
				inventoryScreen.setSoundtrackVolumeOnClose = false;
				inventoryScreen.close();
			}
				
			var collectionsScreen:CollectionsScreen = DialogsManager.instance.getDialogByClass(CollectionsScreen) as CollectionsScreen;
			if (collectionsScreen)
				collectionsScreen.close();
		}
		
		private function overlayTrigger_triggeredHandler(e:Event):void 
		{
			hide();
		}
		
		private function hide():void 
		{
			visible = false;
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_SIZE))
			{
				overlayQuad.width = actualWidth;
				overlayQuad.height = actualHeight;
				overlayTrigger.setSize(actualWidth, actualHeight);
				
				if (sourceBar)
				{
					var sourceBounds:Rectangle = sourceBar.getBounds(this);
					
					rendererCopy.x = sourceBounds.x;
					rendererCopy.y = sourceBounds.y;
					
					bubble.scale = 1;
					fitAndAlignBubble(sourceBounds);
				}
			}
			
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				if (sourceBar)
				{
					bubbleContent.invalidate();
					//rendererCopy.source = null;
					//rendererCopy.source = sourceBar.item.uiAsset;
					/*
					if(bubbleContent is BubbleContentBase)
						(bubbleContent as BubbleContentBase).card = sourceBar.item;
					*/
					Starling.juggler.removeTweens(bubble);
					bubble.scale = 0;
					Starling.juggler.tween(bubble, 0.3, { scale:1, transition:Transitions.EASE_OUT_BACK } );
					//TweenHelper.tween(bubble, 0.2, { delay: 0, scale: 1.2, transition: Transitions.EASE_OUT } )
						//.chain(bubble, 0.15, { scale: 1, transition:Transitions.EASE_IN_CUBIC_OUT_BACK } );
				}
			}
		}
		
		private function fitAndAlignBubble(bounds:Rectangle):void 
		{
			var anchorBounds:Rectangle = bounds;
			bubble.validate();
			bubble.alignPivot(Align.CENTER, Align.TOP);
			
			//bubble.scale = layoutHelper.newBarScale;
			
			var anchorShiftX:Number = anchorShift ? anchorShift.x : 0;
			var anchorShiftY:Number = anchorShift ? anchorShift.y : 0;
			var iPhoneXShiftX:Number = layoutHelper.isIPhoneXOrientationLeft ? 35 : 0;
			var tooltipTargetX:Number = anchorBounds.left + anchorBounds.width / 2 + anchorShiftX// + iPhoneXShiftX;
			fitTooltipHorizontal(bubble, tooltipTargetX);
			
			
			bubble.x = tooltipTargetX + iPhoneXShiftX;
			bubble.y = anchorBounds.bottom + anchorShiftY + FINGER_SHIFT*layoutHelper.newBarScale*pxScale;
		}
		
		private function fitTooltipHorizontal(bubble:LayoutGroup, tooltipTargetX:Number):void 
		{
			var tooltipPivotShift:Number = 0;
			var borderLimit:Number = 30 * pxScale * layoutHelper.newBarScale;
			if (tooltipTargetX - bubble.width / 2 < borderLimit)
			{
				tooltipPivotShift = -bubble.width / 2 + tooltipTargetX - borderLimit;
			}
			else if (tooltipTargetX + (bubble.width*scale) / 2 > Starling.current.stage.stageWidth - borderLimit)
			{
				tooltipPivotShift = (bubble.width*scale) / 2 + tooltipTargetX*scale + borderLimit - Starling.current.stage.stageWidth;
			}
			
			var xShift:Number = tooltipPivotShift;
			bubble.pivotX += xShift;
			
			bubbleTail.rotation = Math.PI;
			bubbleTail.x = bubbleBackground.width / 2;
			bubbleTail.y = bubbleTail.pivotY * bubbleTail.scale;
			bubbleBackground.y = bubbleTail.height - 7 * pxScale;
			
			bubbleTail.x += xShift;
			if (bubbleTail.x > bubbleBackground.width - 60 * pxScale)
			{
				bubbleTail.x = bubbleBackground.width - 60 * pxScale;
			}
			else if (bubbleTail.x < 60 * pxScale)
			{
				bubbleTail.x = 60 * pxScale;
			}
			
			bubbleContent.x = bubbleBackground.x;
			bubbleContent.y = bubbleBackground.y;
		}
		
		private function handler_deviceOrientationChanged(event:Event):void {
			invalidate(INVALIDATION_FLAG_SIZE);
		}
		
	}

}