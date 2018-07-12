package com.alisacasino.bingo.commands.player 
{
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.dialogs.CollectionPageRewardDialog;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.models.collections.CollectionPage;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ShowCompleteCollectionPageDialog extends CommandBase
	{
		private var collectionPage:CollectionPage;
		
		public function ShowCompleteCollectionPageDialog(collectionPage:CollectionPage) 
		{
			this.collectionPage = collectionPage;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			if (!collectionPage.needToShowTrophyWindow)
			{
				finish();
				return;
			}
			DialogsManager.addDialog(new CollectionPageRewardDialog(collectionPage));
			collectionPage.needToShowTrophyWindow = false;
		}
		
	}

}