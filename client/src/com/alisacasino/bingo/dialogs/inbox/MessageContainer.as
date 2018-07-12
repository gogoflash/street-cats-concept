package com.alisacasino.bingo.dialogs.inbox 
{
	import com.alisacasino.bingo.models.gifts.IncomingGiftData;
	import feathers.controls.List;
	import feathers.controls.Scroller;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;
	import feathers.layout.VerticalLayout;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class MessageContainer extends List
	{
		static public const GIFT_TRIGGERED:String = "giftTriggered";
		
		private var pool:Array;

		private var basePositionTweenTime:Number = 0.3;
		private var acceptAllCoeff:Number = 0.2;
		public function get positionTweenTime():Number 
		{
			return acceptingAllGifts ? basePositionTweenTime * acceptAllCoeff : basePositionTweenTime;
		}
		
		private var _uncollectedGifts:Vector.<IncomingGiftData>;
		private var giftSkip:int;
		private var acceptingAllGifts:Boolean;
		
		/**
		 * Might be mutated by MessageContainer, be careful.
		 */
		public function get uncollectedGifts():Vector.<IncomingGiftData> 
		{
			return _uncollectedGifts;
		}
		
		public function set uncollectedGifts(value:Vector.<IncomingGiftData>):void 
		{
			if (_uncollectedGifts != value)
			{
				_uncollectedGifts = value;
				
				dataProvider = new ListCollection(_uncollectedGifts);
				sosTrace( "MessageContainer.uncollectedGifts.dataProvider.length : " + dataProvider.length);
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		public function MessageContainer(width:Number, height:Number)
		{
			setSize(width, height);

			pool = [];
			itemRendererType = InboxItemRenderer;
			addEventListener(InboxItemRenderer.ROW_ACCEPT_TRIGGER, rowAcceptTriggerHandler);
			addEventListener(InboxItemRenderer.ROW_CANCEL_TRIGGER, rowCancelTriggerHandler);

			var vLayout:TiledRowsLayout = new TiledRowsLayout();
			vLayout.useVirtualLayout = true;
			vLayout.paddingTop = 7 * pxScale;
			vLayout.paddingBottom = 8 * pxScale;
			vLayout.requestedColumnCount = 1;
			vLayout.useSquareTiles = false;
			vLayout.typicalItem = inviteFriendRendererFactory();
			vLayout.verticalGap = 12 * pxScale;

			elasticity = 0.8;
			layout = vLayout;
			scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_NONE;
			verticalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			itemRendererFactory = inviteFriendRendererFactory;
		}

		private function inviteFriendRendererFactory():InboxItemRenderer
		{
			return new InboxItemRenderer(InboxItemRenderer.WIDTH * pxScale, InboxItemRenderer.HEIGHT * pxScale);
		}
		
		private function rowCancelTriggerHandler(e:Event):void 
		{
			var rowDisplay:InboxItemRenderer = e.data as InboxItemRenderer;
			if (rowDisplay)
			{
				animateRowDisappearance(rowDisplay, true);
				(rowDisplay.data as IncomingGiftData).cancelled = true;
				processGiftData(rowDisplay.data as IncomingGiftData);
			}
		}
		
		private function rowAcceptTriggerHandler(e:Event):void 
		{
			var rowDisplay:InboxItemRenderer = e.data as InboxItemRenderer;
			if (rowDisplay)
			{
				animateRowDisappearance(rowDisplay);
				processGiftData(rowDisplay.data as IncomingGiftData);
			}
		}
		
		private function animateRowDisappearance(rowDisplay:InboxItemRenderer, cancelled:Boolean = false):void
		{
			if (!rowDisplay)
				return;
			
			var bounds:Rectangle = rowDisplay.getBounds(this);
			var animationRow:InboxItemRenderer = getFromPool();
			animationRow.data = rowDisplay.data;
			animationRow.move(bounds.x, bounds.y);
			addChild(animationRow);
			
			fadeOutRow(animationRow, cancelled);
		}
		
		private function fadeOutRow(rowDisplay:InboxItemRenderer, cancelled:Boolean = false):void
		{
			rowDisplay.touchable = false;
			
			var targetX:Number = rowDisplay.x;
			var targetY:Number = rowDisplay.y;
			if (!cancelled)
			{
				targetX += -100 * pxScale;
			}
			else 
			{
				targetY += 50 * pxScale;
			}
			
			Starling.juggler.tween(rowDisplay, positionTweenTime, { "x#": targetX, "y#": targetY, "alpha#": 0, onComplete: onRowFadeComplete, onCompleteArgs:[rowDisplay] } );
		}

		private function onRowFadeComplete(rowDisplay:InboxItemRenderer):void
		{
			rowDisplay.removeFromParent();
			pool.push(rowDisplay);
			
			if (acceptingAllGifts)
			{
				for (var i:int = 0; i < giftSkip; i++) 
				{
					if (dataProvider.length)
					{
						dispatchGiftTriggeredEvent(dataProvider.shift() as IncomingGiftData);
					}
				}
				
				acceptFirst();
			}
		}

		
		public function acceptAllGifts():void 
		{
			acceptingAllGifts = true;
			giftSkip = uncollectedGifts.length / 30;
			acceptFirst();
		}
		
		
		private function processGiftData(incomingGiftData:IncomingGiftData):void 
		{
			if (!incomingGiftData)
				return;
			
			dispatchGiftTriggeredEvent(incomingGiftData);
			
			dataProvider.removeItem(incomingGiftData);
		}
		
		private function dispatchGiftTriggeredEvent(data:IncomingGiftData):void 
		{
			dispatchEventWith(GIFT_TRIGGERED, false, data);
		}
		
		private function acceptFirst():void 
		{
			verticalScrollPosition = 0;
			verticalScrollPolicy = SCROLL_POLICY_OFF;
			
			if (dataProvider.length)
			{
				var item:IncomingGiftData = dataProvider.getItemAt(0) as IncomingGiftData;
				if (!item)
				{
					return;
				}
				
				var animationRow:InboxItemRenderer = getFromPool();
				
				animationRow.data = item;
				animationRow.move(viewPort.contentX, viewPort.contentY);
				addChild(animationRow);
				
				fadeOutRow(animationRow);
				processGiftData(item);
			}
		}
		
		private function getFromPool():InboxItemRenderer
		{
			if (!pool.length)
			{
				var rowDisplay:InboxItemRenderer = inviteFriendRendererFactory();
				return rowDisplay;
			}
			
			var pooled:InboxItemRenderer = pool.pop();
			pooled.alpha = 1;
			pooled.data = null;
			pooled.x = 0;
			pooled.y = 0;
			pooled.touchable = false;
			
			return pooled;
		}

		
	}

}