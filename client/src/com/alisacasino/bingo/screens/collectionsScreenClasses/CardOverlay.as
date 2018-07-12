package com.alisacasino.bingo.screens.collectionsScreenClasses 
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.controls.ImageAssetContainer;
	import com.alisacasino.bingo.resize.ResizeUtils;
	import com.alisacasino.bingo.utils.UIUtils;
	import feathers.controls.BasicButton;
	import feathers.controls.LayoutGroup;
	import feathers.core.FeathersControl;
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
	public class CardOverlay extends FeathersControl
	{
		private var sourceRenderer:CollectionItemRenderer;
		private var bubbleBackground:Image;
		private var bubbleTail:Image;
		private var bubble:LayoutGroup;
		private var overlayQuad:Quad;
		private var rendererCopy:ImageAssetContainer;
		private var exchangeBubbleContent:ExchangeBubbleContent;
		private var overlayTrigger:BasicButton;
		
		public function CardOverlay() 
		{
			
		}
		
		public function showOverlayForRenderer(renderer:CollectionItemRenderer):void 
		{
			this.sourceRenderer = renderer;
			
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
			
			bubbleBackground = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/chest/window_white_bg"));
			bubbleBackground.scale9Grid = ResizeUtils.getScaledRect(25, 25, 55, 55);
			bubbleBackground.width = 471*pxScale;
			bubbleBackground.height = 364 * pxScale;
			bubble.addChild(bubbleBackground);
			
			exchangeBubbleContent = new ExchangeBubbleContent();
			exchangeBubbleContent.addEventListener(Event.CLOSE, exchangeBubbleContent_closeHandler);
			bubble.addChild(exchangeBubbleContent);
			
			bubbleTail = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/chest/window_white_corner"));
			bubbleTail.alignPivot();
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
				
				if (sourceRenderer)
				{
					var sourceBounds:Rectangle = sourceRenderer.getBounds(this);
					
					rendererCopy.x = sourceBounds.x;
					rendererCopy.y = sourceBounds.y;
					
					var align:String = Align.LEFT;
					
					if (sourceRenderer.index >= 4 && sourceRenderer.index <= 6)
					{
						align = Align.TOP;
					}
					else if (sourceRenderer.index == 0)
					{
						align = Align.RIGHT;
					}
					
					bubble.scale = 1;
					fitAndAlignBubble(sourceBounds, align);
				}
			}
			
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				if (sourceRenderer)
				{
					rendererCopy.source = null;
					rendererCopy.source = sourceRenderer.item.image;
					
					exchangeBubbleContent.card = sourceRenderer.item;
					Starling.juggler.removeTweens(bubble);
					bubble.scale = 0;
					Starling.juggler.tween(bubble, 0.3, { scale:1, transition:Transitions.EASE_OUT_BACK } );
					//TweenHelper.tween(bubble, 0.2, { delay: 0, scale: 1.2, transition: Transitions.EASE_OUT } )
						//.chain(bubble, 0.15, { scale: 1, transition:Transitions.EASE_IN_CUBIC_OUT_BACK } );
				}
			}
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