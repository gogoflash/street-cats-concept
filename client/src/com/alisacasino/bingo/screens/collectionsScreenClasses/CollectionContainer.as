package com.alisacasino.bingo.screens.collectionsScreenClasses 
{
	import com.alisacasino.bingo.assets.AssetsManager;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.ImageAsset;
	import com.alisacasino.bingo.assets.loading.LoadManager;
	import com.alisacasino.bingo.models.collections.Collection;
	import com.alisacasino.bingo.models.collections.CollectionItem;
	import com.alisacasino.bingo.models.collections.CollectionPage;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.CardItemRenderer;
	import com.alisacasino.bingo.utils.UIUtils;
	import feathers.controls.BasicButton;
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PageIndicator;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalLayout;
	import flash.geom.Point;
	import starling.animation.Transitions;
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
	public class CollectionContainer extends FeathersControl
	{
		static public const PAGE_CHANGE:String = "pageChange";
		
		
		private var _collection:Collection;
		private var list:List;
		private var layout:HorizontalLayout;
		private var pageIndicator:PageIndicator;
		private var leftButton:Button;
		private var rightButton:Button;
		private var infoButton:BasicButton;
		private var newCardRendererList:Array;
		
		public function get selectedPage():CollectionPage
		{
			if (list.horizontalPageIndex >= 0 && list.horizontalPageIndex < collection.pages.length)
			{
				return collection.pages[list.horizontalPageIndex];
			}
			return null;
		}
		
		public function get collection():Collection 
		{
			return _collection;
		}
		
		public function set collection(value:Collection):void 
		{
			if (_collection != value)
			{
				_collection = value;
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		public function CollectionContainer() 
		{
			
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			list = new List();
			addChild(list);
			
			var horisontalPadding:Number = 0 * pxScale;
			var verticalPadding:Number = 40 * pxScale;
			
			list.x = 2 * pxScale - horisontalPadding;
			list.y = 10 * pxScale - verticalPadding;
			
			list.width = 896 * pxScale + 2 * horisontalPadding;
			list.height = 530 * pxScale + 2 * verticalPadding;
			
			layout = new HorizontalLayout();
			layout.typicalItemWidth = list.width;
			layout.typicalItemHeight = list.height;
			layout.paddingTop = verticalPadding;
			layout.paddingBottom = verticalPadding;
			layout.paddingLeft = horisontalPadding;
			layout.paddingRight = horisontalPadding;
			list.layout = layout;
			
			list.verticalScrollPolicy = List.SCROLL_POLICY_OFF;
			list.snapToPages = true;
			list.clipContent = true;
			list.elasticity = 0.8;
			sosTrace( "list.maxHorizontalScrollPosition : " + list.maxHorizontalScrollPosition );

			list.itemRendererType = CollectionSetRenderer;
			list.itemRendererProperties.width = list.width;
			list.itemRendererProperties.height = list.height;
			list.elasticSnapDuration = 0.2;
			list.minimumPageThrowVelocity = 2;
			list.addEventListener(FeathersEventType.SCROLL_COMPLETE, list_scrollCompleteHandler);
			
			pageIndicator = new PageIndicator();
			pageIndicator.gap = 18 * pxScale;
			pageIndicator.x = 207 * pxScale;
			pageIndicator.y = 540 * pxScale;
			pageIndicator.setSize(500 * pxScale, 30 * pxScale);
			pageIndicator.normalSymbolFactory = createNormalPageIndicator;
			pageIndicator.selectedSymbolFactory = createSelectedPageIndicator;
			addChild(pageIndicator);
			pageIndicator.addEventListener(Event.CHANGE, pageIndicator_changeHandler);
			
			UIUtils.alignPivotAndMove(pageIndicator);
			
			leftButton = new Button();
			leftButton.defaultSkin = createButtonSkin(AtlasAsset.CommonAtlas.getTexture("dialogs/collections/previous_page"));
			//leftButton.x = 60 * pxScale;
			leftButton.y = 526 * pxScale;
			leftButton.scaleWhenDown = 0.8;
			leftButton.addEventListener(Event.TRIGGERED, leftButton_triggeredHandler);
			addChild(leftButton);
			leftButton.validate();
			UIUtils.alignPivotAndMove(leftButton, Align.LEFT, Align.CENTER);
			
			rightButton = new Button();
			rightButton.defaultSkin = createButtonSkin(AtlasAsset.CommonAtlas.getTexture("dialogs/collections/next_page"));
			//rightButton.x = /*rightButtonX;//*/697 * pxScale;
			rightButton.y = 526 * pxScale;
			rightButton.scaleWhenDown = 0.8;
			rightButton.addEventListener(Event.TRIGGERED, rightButton_triggeredHandler);
			addChild(rightButton);
			rightButton.validate();
			UIUtils.alignPivotAndMove(rightButton, Align.RIGHT, Align.CENTER);
			
			infoButton = new BasicButton();
			infoButton.defaultSkin = new Image(AtlasAsset.CommonAtlas.getTexture("dialogs/leaderboard/info_switch_button"));
			infoButton.x = 20 * pxScale;
			infoButton.y = 526 * pxScale;
			infoButton.addEventListener(Event.TRIGGERED, infoButton_triggeredHandler);
			addChild(infoButton);
		}
		
		private function animateAppearance():void 
		{
			pageIndicator.scaleX = 3;
			pageIndicator.scaleY = 0.4;
			TweenHelper.tween(pageIndicator, 0.15, { scaleX:0.8, scaleY:1.4,transition:Transitions.LINEAR} )
				.chain(pageIndicator, 0.15, { scaleX:1, scaleY:1, transition:Transitions.LINEAR } );
			
			rightButton.x -= 200;
			rightButton.scaleX = 1.2;
			rightButton.scaleY = 0;
			TweenHelper.tween(rightButton, 0.16, { delay: 0.2, scaleX:0.8, scaleY:1.4, x:rightButtonX, transition:Transitions.LINEAR} )
				.chain(rightButton, 0.15, { scaleX:1, scaleY:1, transition:Transitions.LINEAR } )
				
			leftButton.x += 200;
			leftButton.scaleX = 1.2;
			leftButton.scaleY = 0;
			TweenHelper.tween(leftButton, 0.16, { delay: 0.2, scaleX:0.8, scaleY:1.4, x: leftButtonX, transition:Transitions.LINEAR} )
				.chain(leftButton, 0.15, { scaleX:1, scaleY:1, transition:Transitions.LINEAR } )
		}
		
		private function infoButton_triggeredHandler(e:Event):void 
		{
			dispatchEventWith(CollectionsScreen.SHOW_PAGE_PRIZE_OVERLAY, false, getCurrentCollectionPage());
		}
		
		private function getCurrentCollectionPage():CollectionPage
		{
			return collection.pages[Math.min(pageIndicator.selectedIndex, collection.pages.length-1)];
		}
		
		private function createButtonSkin(texture:Texture):DisplayObject
		{
			var skin:Sprite = new Sprite();
			var image:Image = new Image(texture);
			image.alignPivot(Align.CENTER, Align.CENTER);
			var quad:Quad = new Quad(image.width + 60 * pxScale, 60 * pxScale, 0xff00ff);
			quad.visible = false;
			skin.addChild(quad);
			skin.addChild(image);
			image.x = quad.width / 2;
			image.y = quad.height / 2;
			return skin;
		}
		
		private function rightButton_triggeredHandler(e:Event):void 
		{
			pageIndicator.selectedIndex++;
		}
		
		private function leftButton_triggeredHandler(e:Event):void 
		{
			pageIndicator.selectedIndex--;
		}
		
		private function list_scrollCompleteHandler(e:Event):void 
		{
			pageIndicator.selectedIndex = list.horizontalPageIndex;
			dispatchEventWith(PAGE_CHANGE);
			updateButtonVisibility();
		}
		
		private function updateButtonVisibility():void 
		{
			leftButton.visible = pageIndicator.selectedIndex > 0;
			rightButton.visible = pageIndicator.selectedIndex < pageIndicator.pageCount - 1;
			infoButton.visible = getCurrentCollectionPage && !(getCurrentCollectionPage().comingSoon);
		}
		
		private function pageIndicator_changeHandler(e:Event):void 
		{
			if (list.horizontalPageIndex != pageIndicator.selectedIndex)
			{
				list.scrollToPageIndex(pageIndicator.selectedIndex, 0, 0.4);
			}
			dispatchEventWith(PAGE_CHANGE);
			updateButtonVisibility();
		}
		
		private function createNormalPageIndicator():Image
		{
			return new Image(AtlasAsset.CommonAtlas.getTexture("controls/page_indicator"));
		}
		
		private function createSelectedPageIndicator():Image
		{
			return new Image(AtlasAsset.CommonAtlas.getTexture("controls/page_indicator_selected"));
		}
		
		override protected function feathersControl_removedFromStageHandler(event:Event):void 
		{
			super.feathersControl_removedFromStageHandler(event);
			LoadManager.instance.releaseParent(this);
		}
		
		override protected function draw():void 
		{
			super.draw();
			
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				commitData();
			}
		}
		
		private function commitData():void 
		{
			if (collection && collection.pages)
			{
				list.dataProvider = new ListCollection(collection.pages);
				list.validate();
				pageIndicator.pageCount = list.horizontalPageCount;
				pageIndicator.selectedIndex = list.horizontalPageIndex;
				
				var pageToSelect:CollectionPage;
				var currentPage:CollectionPage = collection.getCurrentPage();
				var completedPageToShow:CollectionPage = collection.getRecentlyCollectedPageForCollectionsScreen();
				
				if (completedPageToShow)
				{
					pageToSelect = completedPageToShow;
					completedPageToShow.needToShowInCollectionScreen = false;
					if (currentPage)
					{
						Starling.juggler.delayCall(scrollToPage, 2, currentPage);
						dispatchEventWith(CollectionsScreen.LOCK_INTERACTION);
					}
				}
				else
				{
					pageToSelect = currentPage;
				}
				
				if (pageToSelect)
				{
					list.selectedItem = pageToSelect;
					pageIndicator.selectedIndex = list.selectedIndex;
					list.scrollToPageIndex(list.selectedIndex, 0, 0);
				}
				
				LoadManager.instance.releaseParent(this);
				for each (var collectionPage:CollectionPage in collection.pages) 
				{
					if (collectionPage.trophyImage)
					{
						collectionPage.trophyImage.loadForParent(null, null, this);
					}
				}
			}
			updateButtonVisibility();
			if (gameManager.collectionsData.newCollectionItems.length)
			{
				showNewItems();
			}
			
			animateAppearance();
		}
		
		private function scrollToPage(page:CollectionPage):void 
		{
			list.selectedItem = page;
			pageIndicator.selectedIndex = list.selectedIndex;
			dispatchEventWith(CollectionsScreen.UNLOCK_INTERACTION);
		}
		
		private function showNewItems():void 
		{
			var currentPage:CollectionPage = list.selectedItem as CollectionPage;
			if (!currentPage)
				return;
			
			var newItems:Vector.<CollectionItem> = gameManager.collectionsData.newCollectionItems;
			
			var order:int = 0;
			newCardRendererList = [];
			
			for (var i:int = 0; i < currentPage.items.length; i++) 
			{
				var item:CollectionItem = currentPage.items[i];
				if (newItems.indexOf(item) != -1)
				{
					newCardRendererList.push(createNewCardRenderer(item, currentPage, i));
				}
			}
			
			while (newItems.length)
				newItems.pop();
			
			if (newCardRendererList.length > 0)
			{
				dispatchEventWith(CollectionsScreen.LOCK_INTERACTION);
				Starling.juggler.delayCall(showNewCardsInOrder, 0.3);
			}
			
		}
		
		private function showNewCardsInOrder():void 
		{
			if (newCardRendererList && newCardRendererList.length)
			{
				
				var newCardRenderer:CollectionItemRenderer = newCardRendererList.shift();
				newCardRenderer.animateNew();
				newCardRenderer.addEventListener(CardItemRenderer.APPEAR_ANIMATION_COMPLETE, newCardRenderer_appearAnimationCompleteHandler);
				Starling.juggler.delayCall(showNewCardsInOrder, 0.8);
			}
			else
			{
				dispatchEventWith(CollectionsScreen.UNLOCK_INTERACTION);
			}
		}
		
		private function newCardRenderer_appearAnimationCompleteHandler(e:Event):void 
		{
			e.target.removeEventListener(CardItemRenderer.APPEAR_ANIMATION_COMPLETE, newCardRenderer_appearAnimationCompleteHandler);
			
			var cir:CollectionItemRenderer = e.target as CollectionItemRenderer;
			if (!cir)
				return;
			
			var item:CollectionItem = cir.item;
			cir.removeFromParent(true);
			
			var currentPage:CollectionPage = list.selectedItem as CollectionPage;
			if (!currentPage)
				return;
				
			currentPage.dispatchEventWith(CollectionPage.SHOW_ITEM, false, item);
		}
		
		private function createNewCardRenderer(item:CollectionItem, currentPage:CollectionPage, index:int):CollectionItemRenderer 
		{
			currentPage.dispatchEventWith(CollectionPage.HIDE_ITEM, false, item);
			var rendererCopy:CollectionItemRenderer = new CollectionItemRenderer();
			rendererCopy.item = item;
			rendererCopy.validate();
			rendererCopy.showPlaceholder();
			rendererCopy.touchable = false;
			
			var sourcePoint:Point = new Point(CollectionSetRenderer.getXForIndex(index), CollectionSetRenderer.getYForIndex(index));
			var globalPoint:Point = list.localToGlobal(sourcePoint);
			var rendererPosition:Point = globalToLocal(globalPoint);
			rendererCopy.move(rendererPosition.x + layout.paddingLeft, rendererPosition.y + layout.paddingTop);
			addChild(rendererCopy);
			return rendererCopy;
		}
		
		public function getPrizeInfoButtonPoint():Point
		{
			return new Point(infoButton.x + infoButton.width / 2, infoButton.y);
		}
		
		public function get rightButtonX():int
		{
			return 901 * pxScale; //697
		}
		
		public function get leftButtonX():int
		{
			return 60 * pxScale;
		}
	}

}