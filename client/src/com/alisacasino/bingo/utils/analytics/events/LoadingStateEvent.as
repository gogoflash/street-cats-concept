package com.alisacasino.bingo.utils.analytics.events 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class LoadingStateEvent extends AnalyticsEvent
	{
		static public const INITIALIZED:String = "initialized";
		static public const LOADING_STARTED:String = "loadingStarted";
		static public const FACEBOOK_PROMPT:String = "facebookPrompt";
		static public const SERVER_CONNECTION_STARTED:String = "serverConnectionStarted";
		static public const ASSET_LOADING:String = "assetLoading";
		static public const SCREEN_SHOWN:String = "screenShown";
		
		public function LoadingStateEvent(stage:String) 
		{
			addEventType("loading");
			addField("loadingStage", stage);
		}
		
	}

}