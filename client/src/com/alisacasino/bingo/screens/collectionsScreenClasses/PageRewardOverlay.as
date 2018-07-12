package com.alisacasino.bingo.screens.collectionsScreenClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.ImageAssetContainer;
	import com.alisacasino.bingo.models.collections.CollectionPage;
	import com.alisacasino.bingo.resize.ResizeUtils;
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
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class PageRewardOverlay extends FeathersControl
	{
		private var bubbleBackground:Image;
		private var bubbleTail:Image;
		private var bubble:LayoutGroup;
		private var overlayQuad:Quad;
		private var rendererCopy:ImageAssetContainer;
		private var bubbleContent:PageRewardBubbleContent;
		private var collectionPage:CollectionPage;
		private var collectionContainer:CollectionContainer;
		private var overlayTrigger:BasicButton;
		
		public function PageRewardOverlay() 
		{
			
		}
		
		public function showOverlayForPage(collectionPage:CollectionPage, collectionContainer:CollectionContainer):void 
		{
			this.collectionContainer = collectionContainer;
			this.collectionPage = collectionPage;
			
			visible = true;
			
			
			bubble.scale = 1;
			
			invalidate();
			validate();
			
			bubble.scale = 0;
			Starling.juggler.removeTweens(bubble);
			Starling.juggler.tween(bubble, 0.3, { scale:1, transition:Transitions.EASE_OUT_BACK } );
		}
		
		public function updateData(collectionPage:CollectionPage):void 
		{
			if(collectionPage && !collectionPage.comingSoon)
				bubbleContent.collectionPage = collectionPage;
			else
				hide();
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
			
			bubble = new LayoutGroup();
			
			bubbleBackground = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/chest/window_white_bg"));
			bubbleBackground.scale9Grid = ResizeUtils.getScaledRect(25, 25, 55, 55);
			bubbleBackground.width = 471*pxScale;
			bubbleBackground.height = 344 * pxScale;
			bubble.addChild(bubbleBackground);
			
			bubbleContent = new PageRewardBubbleContent();
			bubble.addChild(bubbleContent);
			
			bubbleTail = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/chest/window_white_corner"));
			bubbleTail.alignPivot();
			bubble.addChild(bubbleTail);
			
			bubble.validate();
			bubble.alignPivot(Align.CENTER, Align.BOTTOM);
			
			addChild(bubble);
		}
		
		private function exchangeBubbleContent_closeHandler(e:Event):void 
		{
			dispatchEventWith(Event.CLOSE);
			hide();
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
				
				if (collectionContainer && collectionPage)
				{
					alignBubble(globalToLocal(collectionContainer.localToGlobal(collectionContainer.getPrizeInfoButtonPoint())));
					bubbleContent.collectionPage = collectionPage;
				}
			}
		}
		
		private function alignBubble(buttonPoint:Point):void 
		{
			bubble.x = buttonPoint.x;
			bubble.y = buttonPoint.y - 32 * pxScale;
			bubbleTail.x = bubbleBackground.width/2;
			bubbleTail.y = bubbleBackground.height + bubbleTail.height / 2 - 7*pxScale;
		}
		
	}

}