package com.alisacasino.bingo.commands.gameLoading 
{
	import com.alisacasino.bingo.assets.AssetsManager;
	import com.alisacasino.bingo.assets.ImageAsset;
	import com.alisacasino.bingo.assets.loading.LoadManager;
	import com.alisacasino.bingo.models.collections.Collection;
	import com.alisacasino.bingo.models.collections.CollectionItem;
	import com.alisacasino.bingo.models.collections.CollectionPage;
	import com.alisacasino.bingo.screens.GameScreen;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.models.roomClasses.RoomType;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class PreloadCollectionCards extends CommandBase
	{
		private var parent:Object;
		private var collection:Collection;
		
		public function PreloadCollectionCards(collection:Collection, parent:Object) 
		{
			this.parent = parent;
			this.collection = collection;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			if (collection)
			{
				for each (var page:CollectionPage in collection.pages) 
				{
					if (page.comingSoon)
						continue;
					
					for each (var item:CollectionItem in page.items) 
					{
						if(item.image)
							item.image.loadForParent(null, null, parent);
					}
				}
				finish();
			}
			else
			{
				fail();
			}
		}
		
	}

}