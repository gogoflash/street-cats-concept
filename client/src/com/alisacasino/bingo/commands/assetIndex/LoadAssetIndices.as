package com.alisacasino.bingo.commands.assetIndex 
{
	import com.alisacasino.bingo.commands.ParallelCommandSet;
	import com.alisacasino.bingo.commands.assetIndex.LoadServerAssetIndexCommand;
	import com.alisacasino.bingo.platform.PlatformServices;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class LoadAssetIndices extends ParallelCommandSet
	{
		
		public function LoadAssetIndices() 
		{
			addCommandToSet(new LoadServerAssetIndexCommand());
			if (!PlatformServices.isCanvas)
			{
				addCommandToSet(new LoadLocalAssetIndex());
			}
		}
		
	}

}