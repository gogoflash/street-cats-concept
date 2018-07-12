package com.alisacasino.bingo.models.collections 
{
	import com.alisacasino.bingo.assets.ImageAsset;
	import com.alisacasino.bingo.commands.player.ShowCompleteCollectionPageDialog;
	import com.alisacasino.bingo.protocol.CollectionItemDataMessage;
	import com.alisacasino.bingo.protocol.CollectionPageDataMessage;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.ModificatorMessage;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.utils.Constants;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CollectionPage extends EventDispatcher
	{
		static public const HIDE_ITEM:String = "hideItem";
		static public const SHOW_ITEM:String = "showItem";
		
		public var id:uint;
		public var name:String;
		public var trophyImage:ImageAsset;
		public var items:Array;
		public var collection:Collection;
		public var completionMarked:Boolean;
		public var prizes:Array;
		public var permanentEffects:Array;
		public var opengraphURL:String;
		public var comingSoon:Boolean;
		public var needToShowTrophyWindow:Boolean;
		public var needToShowInCollectionScreen:Boolean;
		public var index:int;
		
		private var _completed:Boolean;
		
		
		
		public function get completed():Boolean
		{
			return _completed;
		}
		
		public function CollectionPage() 
		{
			prizes = [];
			permanentEffects = [];
		}
		
		static public function fromDataMessage(collectionPageDataMessage:CollectionPageDataMessage, collection:Collection):CollectionPage 
		{
			var page:CollectionPage = new CollectionPage().deserialize(collectionPageDataMessage, collection);
			return page;
		}
		
		static public function makeComingSoonPage(collection:Collection):CollectionPage 
		{
			var page:CollectionPage = new CollectionPage();
			page.id = -1;
			page.comingSoon = true;
			page.collection = collection;
			page.name = "Coming soon!";
			page.prizes = [];
			page.permanentEffects = [];
			page.items = [];
			for (var i:int = 0; i < 8; i++) 
			{
				var item:CollectionItem = new CollectionItem();
				item.collection = collection;
				item.comingSoon = true;
				page.items.push(item);
			}
			return page;
		}
		
		public function deserialize(collectionPageDataMessage:CollectionPageDataMessage, collection:Collection):CollectionPage
		{
			id = collectionPageDataMessage.id;
			this.collection = collection;
			completionMarked = gameManager.collectionsData.getCollectionPageMarked(id);
			name = collectionPageDataMessage.name;
			trophyImage = gameManager.loadManager.getImageAssetByName(collectionPageDataMessage.trophy);
			prizes = collectionPageDataMessage.oneTimePrizes;
			permanentEffects = collectionPageDataMessage.permanentPrizes;
			opengraphURL = collectionPageDataMessage.opengraphUrl;
			items = [];
			for each (var itemDataMessage:CollectionItemDataMessage in collectionPageDataMessage.items) 
			{
				var item:CollectionItem = CollectionItem.fromDataMessage(itemDataMessage, collection);
				//item.owned = true;
				//item.duplicates = Math.random() * 20;
				item.addEventListener(Event.CHANGE, item_changeHandler);
				items.push(item);
			}
			items.sortOn("index");
			checkCompletion();
			return this;
		}
		
		private function item_changeHandler(e:Event):void 
		{
			checkCompletion();
		}
		
		private function checkCompletion():void 
		{
			var nowCompleted:Boolean = items.length > 0;
			for each (var item:CollectionItem in items) 
			{
				if (!item.owned)
				{
					nowCompleted = false;
					break;
				}
			}
			if (!completed && nowCompleted)
			{
				_completed = nowCompleted;
				if (!completionMarked)
				{
					needToShowTrophyWindow = true;
					needToShowInCollectionScreen = true;
				}
				dispatchEventWith(Event.CHANGE);
			}
		}
		
		public function getRandomCard(rarity:int = -1, rnd:Number = NaN):CollectionItem
		{
			if (isNaN(rnd))
			{
				rnd = Math.random();
			}
			
			var selection:Array = [];
			for each (var item:CollectionItem in items) 
			{
				if (rarity == -1 || item.rarity == rarity)
				{
					selection.push(item);
				}
			}
			
			if (selection.length <= 0)
			{
				return null;
			}
			
			return selection[int(rnd * selection.length)];
		}
		
		public function getPermanentEffect():ModificatorMessage
		{
			if (permanentEffects && permanentEffects.length > 0)
			{
				return permanentEffects[0];
			}
			return null;
		}
		
		public function getCashReward():int
		{
			for each (var item:CommodityItemMessage in prizes) 
			{
				if (item.type == Type.CASH)
				{
					return item.quantity;
				}
			}
			return 0;
		}
		
		public function getPowerupReward():int
		{
			for each (var item:CommodityItemMessage in prizes) 
			{
				if (item.type == Type.POWERUP)
				{
					return item.quantity;
				}
			}
			return 0;
		}
		
		public function toString():String 
		{
			return "[CollectionPage id=" + id + " name=" + name + " trophyImage=" + trophyImage + " collection=" + collection.name + 
						" completionMarked=" + completionMarked + " completed=" + completed + "]";
		}
		
		public function markAll():void 
		{
			for each (var item:CollectionItem in items) 
			{
				item.owned = true;
			}
		}
	}

}