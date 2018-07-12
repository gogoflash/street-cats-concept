package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	public class DDNAReconnectShownEvent extends DDNAEvent 
	{
		public static var NO_CONNECTION:String = 'NO_CONNECTION';
		public static var NO_RESOURCES:String = 'NO_RESOURCES';
		public static var WATCHDOG:String = 'WATCHDOG';
		public static var OTHER:String = 'OTHER';
		
		public function DDNAReconnectShownEvent(callSource:String, additionalStringData:String = '') 
		{
			addEventType("reconnectDialogShown");
			addParamsField("callSource", callSource);
			addParamsField("additionalStringData", additionalStringData);
		}
	}

}