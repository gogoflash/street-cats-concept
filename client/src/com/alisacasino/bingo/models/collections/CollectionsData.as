package com.alisacasino.bingo.models.collections 
{
	import com.alisacasino.bingo.commands.player.ShowCompleteCollectionPageDialog;
	import com.alisacasino.bingo.models.chests.WeightedList;
	import com.alisacasino.bingo.protocol.CardType;
	import com.alisacasino.bingo.protocol.CollectionDataMessage;
	import com.alisacasino.bingo.protocol.PlayerItemMessage;
	import com.alisacasino.bingo.protocol.PlayerMessage;
	import com.alisacasino.bingo.protocol.StaticDataMessage;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CollectionsData 
	{
		
		public var collectionList:Vector.<Collection>;
		
		public var completedPageProbabilty:Number = 0;
		
		private var collectionByID:Object;
		
		private var itemByID:Object;
		
		public var collectionDropItems:Vector.<CollectionItem>;
		
		public var newCollectionItems:Vector.<CollectionItem>;
		
		public function CollectionsData() 
		{
			reset();
		}
		
		private function reset():void 
		{
			collectionList = new Vector.<Collection>();
			collectionByID = { };
			itemByID = { };
			newCollectionItems = new <CollectionItem>[];
			collectionDropItems = new <CollectionItem>[];
		}
		
		public function deserializeStaticData(staticData:StaticDataMessage):void 
		{
			reset();
			completedPageProbabilty = staticData.completedPageProbabilty;
			
			for each (var item:CollectionDataMessage in staticData.collectionData) 
			{
				var collection:Collection = Collection.fromCollectionDataMessage(item);
				collectionByID[collection.id] = collection;
				collectionList.push(collection);
				
				for each (var page:CollectionPage in collection.pages) 
				{
					for each (var collectionItem:CollectionItem in page.items) 
					{
						itemByID[collectionItem.id] = collectionItem;
					}
				}
			}
		}
		
		public function getItemByID(id:int):CollectionItem
		{
			if (itemByID.hasOwnProperty(id))
			{
				return itemByID[id];
			}
			
			sosTrace("No item with ID " + id, SOSLog.ERROR);
			
			return null;
		}
		
		public function getCollectionByID(id:int):Collection
		{
			if (collectionByID[id])
			{
				return collectionByID[id];
			}
			
			sosTrace("Could not find collection with id " + id, SOSLog.ERROR);
			
			return null;
		}
		
		public function deserializePlayerInventory(items:Array):void 
		{
			for each (var playerItem:PlayerItemMessage in items) 
			{
				var collectionItem:CollectionItem = getItemByID(playerItem.itemId);
				if (collectionItem)
				{
					collectionItem.owned = playerItem.owned;
					collectionItem.duplicates = playerItem.quantity;
				}
			}
		}
		
		public function fillPlayerMessage(playerMessage:PlayerMessage):void 
		{
			var playerItems:Array = [];
			
			for each (var item:CollectionItem in itemByID) 
			{
				if (item.owned)
				{
					var playerItem:PlayerItemMessage = new PlayerItemMessage();
					playerItem.itemId = item.id;
					playerItem.owned = item.owned;
					playerItem.quantity = item.duplicates;
					playerItems.push(playerItem);
				}
			}
			
			playerMessage.items = playerItems;
		}
		
		public function getCollectionPageMarked(id:uint):Boolean
		{
			return gameManager.clientDataManager.getValue("collectionPageMarked" + id, false);
		}
		
		public function setCollectionPageMarked(id:uint, value:Boolean):void
		{
			gameManager.clientDataManager.setValue("collectionPageMarked" + id, value);
		}
		
		public function getCurrentCollection():Collection
		{
			return gameManager.tournamentData.collection;
		}
		
		public function getRandomCollectionItem(rarity:int, rnd:Number = NaN):CollectionItem
		{
			var collectionItem:CollectionItem;
			for each (var collection:Collection in collectionList)
			{
				for each (var collectionPage:CollectionPage in collection.pages) 
				{
					collectionItem = collectionPage.getRandomCard(rarity, rnd);
					if (collectionItem)
						return collectionItem;
				}
			}
			
			return collectionItem;
		}
		
		public function debugFillCollection():void
		{
			for each (var collection:Collection in collectionList) 
			{
				if (collection.getCurrentPage())
				{
					collection.getCurrentPage().markAll();
					break;
				}
			}
		}
		
		public function debugGetOwnedItems(count:int):Vector.<CollectionItem>
		{
			var items:Vector.<CollectionItem> = new <CollectionItem>[];
			
			for each (var item:CollectionItem in itemByID) 
			{
				if (items.length >= count)
					break;
					
				if (item.owned)
					items.push(item);
			}
			
			return items;
		}
		
		public function debugCreateOwnedItems(count:int):void
		{
			var items:Vector.<CollectionItem> = new <CollectionItem>[];
			
			for each (var item:CollectionItem in itemByID) 
			{
				if (count <= 0)
					break;
					
				if (!item.owned) {
					count--;
					item.duplicates = 1;
					item.owned = true;
				}
				else {
					count--;
					item.duplicates++;
				}
				
			}
			
		}
		
		public function showRecentlyCollectedPageIfAny():void 
		{
			var pageToShow:CollectionPage;
			for each (var collection:Collection in collectionList)
			{
				for each (var collectionPage:CollectionPage in collection.pages) 
				{
					if (collectionPage.needToShowTrophyWindow)
					{
						pageToShow = collectionPage;
						break;
					}
				}
				if (pageToShow)
					break;
			}
			
			if (pageToShow)
			{
				new ShowCompleteCollectionPageDialog(pageToShow).execute();
			}
		}
		
		public static function get allRarities():Vector.<int> {
			return new <int> [CardType.NORMAL, CardType.MAGIC, CardType.RARE];
		}
		
	}

}