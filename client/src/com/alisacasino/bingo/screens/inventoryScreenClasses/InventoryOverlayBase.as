package com.alisacasino.bingo.screens.inventoryScreenClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.components.CardSelectorView;
	import com.alisacasino.bingo.controls.ImageAssetContainer;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.InventoryItemRenderer;
	import com.alisacasino.bingo.utils.UIUtils;
	import feathers.controls.BasicButton;
	import feathers.controls.LayoutGroup;
	import feathers.core.FeathersControl;
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.utils.Align;
	import starling.utils.TweenHelper;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class InventoryOverlayBase extends FeathersControl
	{	
		private var sourceRenderer:ICardRenderer;
		private var selectorView:CardSelectorView;
		private var bubbleBackground:Image;
		private var bubbleTail:Image;
		private var bubble:LayoutGroup;
		private var overlayQuad:Quad;
		private var rendererCopy:ImageAssetContainer;
		private var bubbleContent:InventoryBubbleContent;
		private var overlayTrigger:BasicButton;
		
		public function InventoryOverlayBase() 
		{
			
		}
		
		public function showOverlay(renderer:ICardRenderer):void 
		{
			this.sourceRenderer = renderer;
			
			SelectBubbleContent.sampleVoiceoverPlayed = false;	
			visible = true;
			
			invalidate();
			validate();
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			//visible = false;
			
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
			
			bubbleContent = new InventoryBubbleContent();
			bubbleContent.addEventListener(InventoryBubbleContent.EVENT_CHANGE_CONTENT, handler_bubbleChangeContent);
			bubbleContent.addEventListener(InventoryBubbleContent.EVENT_UPDATE_RENDERER, handler_updateRenderer);
			bubbleContent.addEventListener(Event.CLOSE, exchangeBubbleContent_closeHandler);
			bubbleContent.validate();
			
			bubbleBackground = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/chest/window_white_bg"));
			bubbleBackground.scale9Grid = ResizeUtils.getScaledRect(25, 25, 55, 55);
			bubbleBackground.width = bubbleContent.width;
			bubbleBackground.height = bubbleContent.height;
			bubble.addChild(bubbleBackground);
			
			bubble.addChild(bubbleContent);
			
			bubbleTail = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/chest/window_white_corner"));
			bubbleTail.alignPivot();
			bubbleTail.touchable = false;
			bubble.addChild(bubbleTail);
			
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
			rendererCopy.source = null;
			
			overlayTrigger.touchable = false;
			bubble.touchable = false;
			
			Starling.juggler.removeTweens(overlayTrigger);
			Starling.juggler.tween(overlayTrigger, 0.3, { alpha:0, transition:Transitions.EASE_OUT, onComplete:viewVisibilitySetter, onCompleteArgs:[overlayTrigger, false] });
			
			Starling.juggler.removeTweens(bubble);
			Starling.juggler.tween(bubble, 0.3, { scale:0, transition:Transitions.EASE_OUT, onComplete:viewVisibilitySetter, onCompleteArgs:[bubble, false] });
			
			if(selectorView)
				selectorView.visible = false;
				
				
			SelectBubbleContent.stopCurrentPreviewVoiceover();	
		}
		
		public function viewVisibilitySetter(view:DisplayObject, value:Boolean):void {
			view.visible = value;
		}
		
		override protected function draw():void 
		{
			super.draw();
			var isInvalidSize:Boolean = isInvalid(INVALIDATION_FLAG_SIZE);
			
			if (isInvalidSize)
			{
				overlayQuad.width = actualWidth;
				overlayQuad.height = actualHeight;
				overlayTrigger.setSize(actualWidth, actualHeight);
				
				if (sourceRenderer)
				{
					var sourceBounds:Rectangle = sourceRenderer.getBounds(this);
					
					rendererCopy.x = sourceBounds.x;
					rendererCopy.y = sourceBounds.y;
					
					var align:String = Align.LEFT;
					
					if (sourceRenderer.index == 0 || sourceRenderer.index == 4)
						align = Align.RIGHT;
					else
						align = Align.LEFT;
					
					bubble.scale = 1;
					bubble.invalidate();
					bubble.validate();
					fitAndAlignBubble(sourceBounds, align);
				}
			}
			
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				if (sourceRenderer)
				{
					rendererCopy.source = null;
					rendererCopy.source = sourceRenderer.cardAsset;
					
					if (sourceRenderer.isSelectedView) 
					{
						if (!selectorView) {
							selectorView = new CardSelectorView(138 * pxScale, 172 * pxScale, CardSelectorView.STATE_SHOW);
							//selectorView.x = -1 * pxScale;
							selectorView.y = -3 * pxScale;
							selectorView.state = CardSelectorView.STATE_SHOW_INSTANT;
							addChild(selectorView);
						}
						
						selectorView.visible = true;
						selectorView.x = rendererCopy.x;
						selectorView.y = rendererCopy.y - 3 * pxScale;
					}
					else {
						if(selectorView)
							selectorView.visible = false;
					}
					
					overlayTrigger.touchable = true;
					overlayTrigger.alpha = 0;
					overlayTrigger.visible = true;
					Starling.juggler.removeTweens(overlayTrigger);
					Starling.juggler.tween(overlayTrigger, 0.3, { alpha:1, transition:Transitions.EASE_OUT});
					
					bubbleContent.card = sourceRenderer.cardItem;
						
					Starling.juggler.removeTweens(bubble);
					bubble.scale = 0;
					bubble.visible = true;
					bubble.touchable = true;
					Starling.juggler.tween(bubble, 0.3, { scale:1, transition:Transitions.EASE_OUT_BACK } );
					//TweenHelper.tween(bubble, 0.2, { delay: 0, scale: 1.2, transition: Transitions.EASE_OUT } )
						//.chain(bubble, 0.15, { scale: 1, transition:Transitions.EASE_IN_CUBIC_OUT_BACK } );
				}
			}
		}
		
		private function handler_bubbleChangeContent(e:Event):void 
		{
			Starling.juggler.removeTweens(bubble);
			
			TweenHelper.tween(bubble, 0.1, { scale:0.9, transition:Transitions.EASE_OUT} )
					.chain(bubble, 0.1, { scale:1, transition:Transitions.EASE_OUT} );
			
					
			TweenHelper.tween(bubbleContent, 0.05, { alpha:0, transition:Transitions.LINEAR} )
					.chain(bubbleContent, 0.15, { alpha:1, transition:Transitions.EASE_OUT} );		
		}
		
		private function handler_updateRenderer(e:Event):void 
		{
			if (sourceRenderer)
				sourceRenderer.invalidate();
		}
		
		private function fitAndAlignBubble(bounds:Rectangle, align:String):void 
		{
			if (align == Align.LEFT)
			{
				bubbleTail.rotation = -Math.PI / 2;
				bubbleTail.x = bubbleBackground.width + bubbleTail.width / 2 - 7*pxScale;
				bubbleTail.y = bubbleBackground.height / 2;
				
				bubble.alignPivot(Align.RIGHT, Align.CENTER);
				bubble.x = bounds.x - bounds.width / 2 - 40 * pxScale;
				bubble.y = bounds.y;
			}
			else if (align == Align.RIGHT)
			{
				bubbleTail.rotation = Math.PI / 2;
				bubbleTail.x = -bubbleTail.width / 2 + 7*pxScale;
				bubbleTail.y = bubbleBackground.height / 2;
				
				bubble.alignPivot(Align.LEFT, Align.CENTER);
				bubble.x = bounds.x + bounds.width/2 + 40 * pxScale;
				bubble.y = bounds.y;
			}
			else
			{
				bubbleTail.rotation = 0;
				bubbleTail.y = bubbleBackground.height + bubbleTail.height / 2 - 7 * pxScale;
				
				bubble.alignPivot(Align.CENTER, Align.BOTTOM);
				
				bubble.x = bounds.x;
				if (bubble.x + bubbleBackground.width/2 + 40 * pxScale > actualWidth)
				{
					bubble.x = actualWidth - bubbleBackground.width/2 - 40 * pxScale;
				}
				bubble.y = bounds.y - bounds.height / 2 - 32 * pxScale;
				
				bubbleTail.x = bounds.x - bubble.x + bubble.pivotX;
			}
			
			
		}
		
	}

}