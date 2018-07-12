package com.alisacasino.bingo.screens.inventoryScreenClasses 
{
	import com.alisacasino.bingo.assets.AssetsManager;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.ImageAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.assets.loading.LoadManager;
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.models.skinning.SkinningData;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import com.alisacasino.bingo.utils.UIUtils;
	import com.alisacasino.bingo.utils.tooltips.TooltipTrigger;
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
	public class InventoryContentBase extends FeathersControl
	{
		static public const PAGE_CHANGE:String = "pageChange";
		
		public var overlayClass:Class;
		
		private var list:List;
		private var layout:HorizontalLayout;
		private var pageIndicator:PageIndicator;
		private var leftButton:Button;
		private var rightButton:Button;
		private var newCardRendererList:Array;
		private var infoButton:TooltipTrigger;
		
		protected var itemsType:int;
		
		private var _source:Vector.<CustomizerItemBase>;
		
		public function get source():Vector.<CustomizerItemBase> 
		{
			return _source;
		}
		
		public function set source(value:Vector.<CustomizerItemBase>):void 
		{
			if (_source != value)
			{
				_source = value;
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		public function get selectedPage():InventoryItemsPage
		{
			if(!list.dataProvider)
				return null;
				
			if (list.horizontalPageIndex >= 0 && list.horizontalPageIndex < list.dataProvider.length)
			{
				return list.dataProvider[list.horizontalPageIndex];
			}
			return null;
		}
		
		public function InventoryContentBase() 
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
			
			list.width = 911 * pxScale + 2 * horisontalPadding;
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

			list.itemRendererType = InventoryItemsPageRenderer;
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
			leftButton.x = 60 * pxScale;
			leftButton.y = 526 * pxScale;
			leftButton.scaleWhenDown = 0.8;
			leftButton.addEventListener(Event.TRIGGERED, leftButton_triggeredHandler);
			addChild(leftButton);
			leftButton.validate();
			UIUtils.alignPivotAndMove(leftButton, Align.LEFT, Align.CENTER);
			
			rightButton = new Button();
			rightButton.defaultSkin = createButtonSkin(AtlasAsset.CommonAtlas.getTexture("dialogs/collections/next_page"));
			rightButton.x = 697 * pxScale;
			rightButton.y = 526 * pxScale;
			rightButton.scaleWhenDown = 0.8;
			rightButton.addEventListener(Event.TRIGGERED, rightButton_triggeredHandler);
			addChild(rightButton);
			rightButton.validate();
			UIUtils.alignPivotAndMove(rightButton, Align.RIGHT, Align.CENTER);
			
			infoButton = new TooltipTrigger(1, 1, Constants.INVENTORY_TOOLTIP, Align.TOP, null, true);
			infoButton.defaultSkin = createButtonSkinByTextureName("dialogs/leaderboard/info_switch_button");
			infoButton.alignPivot();
			infoButton.x = -7 * pxScale;
			infoButton.y = 504 * pxScale;
			infoButton.scaleWhenDown = 0.9;
			infoButton.useHandCursor = true;
			addChild(infoButton);
			
			animateAppearance();
			
			gameManager.skinningData.addEventListener(SkinningData.EVENT_SELECTION_CHANGED, handler_selectionChanged);
		}
		
		private function animateAppearance():void 
		{
			pageIndicator.scaleX = 3;
			pageIndicator.scaleY = 0.4;
			TweenHelper.tween(pageIndicator, 0.15, { scaleX:0.8, scaleY:1.4,transition:Transitions.LINEAR} )
				.chain(pageIndicator, 0.15, { scaleX:1, scaleY:1, transition:Transitions.LINEAR } );
			
			var rightButtonTargetX:Number = rightButton.x;
			rightButton.x -= 200;
			rightButton.scaleX = 1.2;
			rightButton.scaleY = 0;
			TweenHelper.tween(rightButton, 0.16, { delay: 0.2, scaleX:0.8, scaleY:1.4, x: rightButtonTargetX, transition:Transitions.LINEAR} )
				.chain(rightButton, 0.15, { scaleX:1, scaleY:1, transition:Transitions.LINEAR } )
				
			var leftButtonTargetX:Number = leftButton.x;
			leftButton.x += 200;
			leftButton.scaleX = 1.2;
			leftButton.scaleY = 0;
			TweenHelper.tween(leftButton, 0.16, { delay: 0.2, scaleX:0.8, scaleY:1.4, x: leftButtonTargetX, transition:Transitions.LINEAR} )
				.chain(leftButton, 0.15, { scaleX:1, scaleY:1, transition:Transitions.LINEAR } )
		}
		
		private function rightButton_triggeredHandler(e:Event):void 
		{
			SoundManager.instance.playSfx(SoundAsset.ButtonClick, 0, 0, SoundAsset.DEFAULT_BUTTON_CLICK_VOLUME, 0, true);
			pageIndicator.selectedIndex++;
		}
		
		private function leftButton_triggeredHandler(e:Event):void 
		{
			SoundManager.instance.playSfx(SoundAsset.ButtonClick, 0, 0, SoundAsset.DEFAULT_BUTTON_CLICK_VOLUME, 0, true);
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
			infoButton.visible = true//getCurrentCollectionPage && !(getCurrentCollectionPage().comingSoon);
		}
		
		/*private function getCurrentCollectionPage():CollectionPage
		{
			return collection.pages[pageIndicator.selectedIndex];
		}*/
		
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
			if (source)
			{
				source.sort(sortOwned);
				
				var pagedItems:ListCollection = new ListCollection();
				var pageIndex:int;
				var page:InventoryItemsPage;
				var pageWithSelectedItem:InventoryItemsPage;
				var selectedItem:CustomizerItemBase = gameManager.skinningData.getSelectedItemByType(itemsType);
				for each (var item:CustomizerItemBase in source) 
				{
					if (!page || page.length > 7)
					{
						page = new InventoryItemsPage();
						page.pageIndex = pageIndex++;
						pagedItems.push(page);
					}
					page.addItem(item);
					
					if (item == selectedItem)
						pageWithSelectedItem = page;
				}
				
				if (page)
				{
					while(page.length < 8)
					{
						page.addItem(createTempItem());
					}
				}
				
				pagedItems.push(createComingSoon(pageIndex++));
				
				list.dataProvider = pagedItems;
				list.validate();
				pageIndicator.pageCount = list.horizontalPageCount;
				pageIndicator.selectedIndex = list.horizontalPageIndex;
				
				LoadManager.instance.releaseParent(this);
			}
			else
			{
				list.dataProvider ? list.dataProvider.removeAll() : null;
			}
			
			updateButtonVisibility();
			
			if (!showNewItems())
			{
				scrollToPage(pageWithSelectedItem, 0);
			}
		}
		
		private function createTempItem():CustomizerItemBase
		{
			var fakeItem:CustomizerItemBase = new CustomizerItemBase();
			//fakeItem.id = -1;
			fakeItem.order = int.MAX_VALUE;
			return fakeItem;
		}
		
		private function createComingSoon(pageIndex:int):InventoryItemsPage
		{
			var page:InventoryItemsPage = new InventoryItemsPage();
			page.pageIndex = pageIndex;
			
			for (var i:int = 0; i < 8; i++) 
			{
				var comingSoonItem:CustomizerItemBase = new CustomizerItemBase();
				comingSoonItem.comingSoon = true;
				page.addItem(comingSoonItem);
			}
			
			
			return page;
		}
		
		private function sortOwned(a:CustomizerItemBase, b:CustomizerItemBase):int
		{
			if (a.defaultItem && !b.defaultItem)
				return -1;
			if (b.defaultItem && !a.defaultItem)
				return 1;
			if (a.quantity <= 0 && b.quantity <= 0)
				return 0;
			if (a.quantity > 0 && b.quantity <= 0)
				return -1;
			if (b.quantity > 0 && a.quantity <= 0)
				return 1;
			if (a.order < b.order)
				return -1;
			if (a.order > b.order)
				return 1;
			return 0;
		}
		
		private function scrollToPage(page:InventoryItemsPage, duration:Number = NaN):void 
		{
			if (!page)
				return;
			
			list.selectedItem = page;
			list.scrollToPageIndex(page.pageIndex, 0, duration);
			pageIndicator.selectedIndex = page.pageIndex;
			dispatchEventWith(InventoryScreen.UNLOCK_INTERACTION);
		}
		
		private function showNewItems():Boolean
		{
			var itemsPage:InventoryItemsPage = list.dataProvider ? (list.dataProvider.getItemAt(pageIndicator.selectedIndex) as InventoryItemsPage) : null;
			if (!itemsPage)
				return false;
			
			var lastItemsPage:InventoryItemsPage;	
				
			newCardRendererList = [];	
				
			var i:int;
			var index:int;
			var item:CustomizerItemBase;
			
			while (i < gameManager.skinningData.newCustomizerItems.length) 
			{
				item = gameManager.skinningData.newCustomizerItems[i];
				
				if (item.type != itemsType) {
					i++;
					continue;
				}
				
				itemsPage = getPageByItem(item);
				index = itemsPage ? itemsPage.items.indexOf(item) : -1;
				if (index != -1)
				{
					if (itemsPage) 
					{
						if (lastItemsPage && itemsPage && lastItemsPage != itemsPage)
							break;
						
						lastItemsPage = itemsPage;
						
						scrollToPage(itemsPage, 0);
					}
					
					gameManager.skinningData.newCustomizerItems.splice(i, 1);
					newCardRendererList.push(createNewCardRenderer(item, itemsPage, index));
				}
				else
				{
					i++;
				}
			}
		
			if (newCardRendererList.length > 0)
			{
				dispatchEventWith(InventoryScreen.LOCK_INTERACTION);
				Starling.juggler.delayCall(showNewCardsInOrder, 0.3);
			}
			
			gameManager.skinningData.dispatchEventWith(SkinningData.EVENT_NEW_ITEMS_CHANGE);
			
			return newCardRendererList.length > 0;
		}
		
		private function showNewCardsInOrder():void 
		{
			if (newCardRendererList && newCardRendererList.length)
			{
				
				var newCardRenderer:InventoryItemRenderer = newCardRendererList.shift();
				newCardRenderer.animateNew();
				newCardRenderer.addEventListener(CardItemRenderer.APPEAR_ANIMATION_COMPLETE, newCardRenderer_appearAnimationCompleteHandler);
				Starling.juggler.delayCall(showNewCardsInOrder, 0.8);
			}
			else
			{
				dispatchEventWith(InventoryScreen.UNLOCK_INTERACTION);
			}
		}
		
		private function newCardRenderer_appearAnimationCompleteHandler(e:Event):void 
		{
			e.target.removeEventListener(CardItemRenderer.APPEAR_ANIMATION_COMPLETE, newCardRenderer_appearAnimationCompleteHandler);
			
			if (!list.dataProvider)
				return;
				
			var inventoryItemRenderer:InventoryItemRenderer = e.target as InventoryItemRenderer;
			if (!inventoryItemRenderer)
				return;
			
			inventoryItemRenderer.removeFromParent(true);
			
			var currentPage:InventoryItemsPage = list.dataProvider.getItemAt(pageIndicator.selectedIndex) as InventoryItemsPage;
			if (!currentPage)
				return;
				
			currentPage.dispatchEventWith(InventoryItemsPageRenderer.SHOW_ITEM, false, inventoryItemRenderer.item);
		}
		
		private function createNewCardRenderer(item:CustomizerItemBase, itemsPage:InventoryItemsPage, index:int):InventoryItemRenderer 
		{
			itemsPage.dispatchEventWith(InventoryItemsPageRenderer.HIDE_ITEM, false, item);
			var rendererCopy:InventoryItemRenderer = new InventoryItemRenderer();
			rendererCopy.item = item;
			rendererCopy.validate();
			rendererCopy.showPlaceholder();
			rendererCopy.touchable = false;
			
			var sourcePoint:Point = new Point(InventoryItemsPageRenderer.getXForIndex(index), InventoryItemsPageRenderer.getYForIndex(index));
			var globalPoint:Point = list.localToGlobal(sourcePoint);
			var rendererPosition:Point = globalToLocal(globalPoint);
			rendererCopy.move(rendererPosition.x + layout.paddingLeft, rendererPosition.y + layout.paddingTop);
			addChild(rendererCopy);
			return rendererCopy;
		}
		
		private function createButtonSkinByTextureName(texture:String):Sprite
		{
			var container:Sprite = new Sprite();
			
			var touchQuad:Quad = new Quad(1, 1);
			touchQuad.width = 100 * pxScale;
			touchQuad.height = 100 * pxScale;
			touchQuad.alpha = 0.0;
			
			container.addChild(touchQuad);
			
			var background:Image = new Image(AtlasAsset.CommonAtlas.getTexture(texture));
			background.x = (touchQuad.width - background.width) / 2;
			background.y = (touchQuad.height - background.height) / 2;
			container.addChild(background);
			return container;
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
		
		private function handler_selectionChanged(event:Event):void
		{
			var item:CustomizerItemBase = event.data ? (event.data as CustomizerItemBase) : null;
			if (item && item.type == itemsType)
				scrollToPage(getPageByItem(item));
		}
		
		private function getPageByItem(item:CustomizerItemBase):InventoryItemsPage 
		{
			var page:InventoryItemsPage;
			var length:int = list.dataProvider ? list.dataProvider.length : 0;
			var i:int;
			for (i = 0; i < length; i++) {
				page = list.dataProvider.getItemAt(i) as InventoryItemsPage;
				if (item.id in page.itemsById)
					return page;
			}
			
			return null;
		}
		
		override public function dispose():void
		{
			gameManager.skinningData.removeEventListener(SkinningData.EVENT_SELECTION_CHANGED, handler_selectionChanged);
			super.dispose();
		}
	}

}