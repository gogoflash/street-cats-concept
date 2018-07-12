package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	import com.alisacasino.bingo.logging.SystemInfo;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.SignInMessage.Platform;
	import flash.system.Capabilities;
	import flash.system.System;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNAClientDeviceEvent extends DDNAEvent
	{
		
		public function DDNAClientDeviceEvent() 
		{
			super();
			addEventType("clientDevice");
			
			if (PlatformServices.isCanvas)
			{
				addParamsField("browserName",  SystemInfo.getBrowserName().substr(0, 71));
				addParamsField("browserVersion", SystemInfo.getBrowserVersion().substr(0,71));
				addParamsField("deviceType", "PC");
			}
			else
			{
				addParamsField("deviceType", gameManager.layoutHelper.isLargeScreen ? "TABLET" : "MOBILE_PHONE");
			}
			
			addParamsField("deviceName", PlatformServices.interceptor.getDeviceModel());
			addParamsField("operatingSystemVersion", PlatformServices.interceptor.getOS());
			addParamsField("manufacturer", Capabilities.manufacturer);
		}
		
	}

}