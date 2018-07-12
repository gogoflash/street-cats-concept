package com.alisacasino.bingo.assets.loading 
{
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Dvalimona
	 */
	public class AssetLoadingEvent extends Event 
	{
		
		public static const PROGRESS:String = "asset_progress";
		public static const FAIL:String = "asset_fail";
		
		public function get progress():Number
		{
			return Number(data);
		}
		
		public function AssetLoadingEvent(type:String, bubbles:Boolean=false, data:Object=null) 
		{
			super(type, bubbles, data);	
		}
		
	}

}