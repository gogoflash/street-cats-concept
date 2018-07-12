package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	import com.alisacasino.bingo.platform.PlatformServices;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNANotificationServicesEvent extends DDNAEvent 
	{

		public function DDNANotificationServicesEvent(pushToken:String) 
		{
			addEventType("notificationServices");
			if (PlatformServices.isAndroid)
			{
				addParamsField("androidRegistrationID", pushToken);
			}
			else if (PlatformServices.isIOS)
			{
				addParamsField("pushNotificationToken", pushToken.replace(/[<>\s]/g, ""));
			}
		}
		
	}

}