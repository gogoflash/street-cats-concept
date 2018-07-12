package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	import com.alisacasino.bingo.assets.AssetsManager;
	import com.alisacasino.bingo.assets.loading.assetIndices.AssetIndexManager;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAEvent;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNAStartGameEvent extends DDNAEvent
	{
		
		public function DDNAStartGameEvent() 
		{
			super();
			addEventType("gameStarted");
			addParamsField("clientVersion", gameManager.getVersionString());
			addParamsField("dataVersion", AssetsManager.instance.assetIndexManager.getIndexVersion());
		}
		
	}

}