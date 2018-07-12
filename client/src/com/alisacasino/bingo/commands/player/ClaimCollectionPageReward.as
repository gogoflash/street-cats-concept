package com.alisacasino.bingo.commands.player 
{
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.models.collections.CollectionPage;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ClaimCollectionPageReward extends CommandBase
	{
		private var collectionPage:CollectionPage;
		
		public function ClaimCollectionPageReward(collectionPage:CollectionPage) 
		{
			this.collectionPage = collectionPage;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			collectionPage.completionMarked = true;
			gameManager.collectionsData.setCollectionPageMarked(collectionPage.id, true);
		}
		
	}

}