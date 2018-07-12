package com.alisacasino.bingo.models.collections
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.BackgroundAsset;
	import com.alisacasino.bingo.assets.ImageAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.protocol.CollectionDataMessage;
	import com.alisacasino.bingo.protocol.CollectionPageDataMessage;
	import starling.events.Event;

	public class Collection
	{
		private var _soundtrackAsset:SoundAsset;
		
		public function get soundtrackAsset():SoundAsset 
		{
			return _soundtrackAsset;
		}
		
		public var name:String;
		public var id:int;
		public var pages:Vector.<CollectionPage>;
		public var collectionEffects:CollectionEffects;
		public var cardBack:ImageAsset;
		
		private var _backgroundAsset:BackgroundAsset;
		
		public function get backgroundAsset():BackgroundAsset 
		{
			return _backgroundAsset;
		}

		
		
		public function Collection()
		{
			collectionEffects = new CollectionEffects();
		}
		
		public static function fromCollectionDataMessage(collectionDataMessage:CollectionDataMessage):Collection
		{
			var collection:Collection = new Collection();
			collection.deserialize(collectionDataMessage);
			return collection;
		}
		
		public function deserialize(collectionDataMessage:CollectionDataMessage):void 
		{
			name = collectionDataMessage.name;
			id = collectionDataMessage.collectionId;
			_soundtrackAsset = new SoundAsset(collectionDataMessage.soundtrackPath, SoundAsset.TYPE_SOUNDTRACK);
			_backgroundAsset = new BackgroundAsset(collectionDataMessage.backgroundPath);
			pages = new Vector.<CollectionPage>;
			cardBack = gameManager.loadManager.getImageAssetByName(collectionDataMessage.shirtPath);
			for each (var item:CollectionPageDataMessage in collectionDataMessage.pages) 
			{
				var collectionPage:CollectionPage = CollectionPage.fromDataMessage(item, this);
				collectionPage.addEventListener(Event.CHANGE, collectionPage_changeHandler);
				collectionPage.index = pages.length;
				pages.push(collectionPage);
				
			}
			
			var comingSoonPage:CollectionPage = CollectionPage.makeComingSoonPage(this);
			pages.push(comingSoonPage);
		}
		
		private function collectionPage_changeHandler(e:Event):void 
		{
			updateCollectionEffects();
		}
		
		private function updateCollectionEffects():void 
		{
			collectionEffects.reset();
			for each (var page:CollectionPage in pages) 
			{
				if (page.completed)
				{
					collectionEffects.applyEffect(page.getPermanentEffect());
				}
			}
			Game.dispatchEventWith(Game.COLLECTION_EFFECTS_UPDATED);
		}
		
		public function getCurrentPage():CollectionPage
		{
			for (var i:int = 0; i < pages.length; i++) 
			{
				if (pages[i].comingSoon)
					continue;
				
				if (!pages[i].completed || !pages[i].completionMarked)
				{
					return pages[i];
				}
			}
			return null;
		}
		
		public function toString():String 
		{
			return "[Collection name=" + name + " id=" + id + " backgroundAsset=" + backgroundAsset + "]";
		}
		
		public function getRandomCompletedPage(rnd:Number):CollectionPage 
		{
			var selection:Array = [];
			for each (var item:CollectionPage in pages) 
			{
				if (item.completed)
				{
					selection.push(item);
				}
			}
			if (selection.length <= 0)
			{
				return null;
			}
			
			return selection[int(selection.length * rnd)];
		}
		
		public function getRecentlyCollectedPageForCollectionsScreen():CollectionPage
		{
			var pageToShow:CollectionPage;
			for each (var collectionPage:CollectionPage in pages) 
			{
				if (collectionPage.needToShowInCollectionScreen)
				{
					pageToShow = collectionPage;
					break;
				}
			}
			return pageToShow;
		}
		
	}
}