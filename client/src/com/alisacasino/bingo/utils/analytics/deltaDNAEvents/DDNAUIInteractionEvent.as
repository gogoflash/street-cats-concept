package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNAUIInteractionEvent extends DDNAEvent 
	{
		static public const TYPE_SCREEN:String = "screen";
		static public const LOCATION_GLOBAL:String = "global";
		static public const LOCATION_LOBBY:String = "lobby";
		static public const TYPE_DIALOG:String = "dialog";
		static public const LOCATION_SIDE_MENU:String = "sideMenu";
		static public const TYPE_BUTTON:String = "button";
		static public const ACTION_TRIGGERED:String = "triggered";
		static public const ACTION_LOADED:String = "loaded";
		static public const ACTION_DEACTIVATED:String = "deactivated";
		static public const ACTION_ACTIVATED:String = "activated";
		

		public function DDNAUIInteractionEvent(uiAction:String, uiLocation:String, uiName:String, uiType:String) 
		{
			addEventType("uiInteraction");
			addParamsField("UIAction", uiAction);
			addParamsField("UILocation", uiLocation);
			addParamsField("UIName", uiName);
			addParamsField("UIType", uiType);
		}
		
	}

}