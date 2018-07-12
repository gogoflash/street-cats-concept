package com.alisacasino.bingo.utils
{
	import com.alisacasino.bingo.Game;
	
	import flash.external.ExternalInterface;
	
	public class HttpCookies
	{
		public static function getCookie(key:String):String
		{
			try {
				if (!Constants.isLocalBuild) {
					return ExternalInterface.call("getCookie", key);
				} else {
					return null;
				}
			} catch (e:Error) {
				Game.connectionManager.sendClientMessage("Error in HttpCookies.gC(), " + e.getStackTrace());
				return null;
			}
		}
		
		public static function setCookie(key:String, val:String):void
		{
			try {
				if (!Constants.isLocalBuild) {
					ExternalInterface.call("setCookie", key, val);
				}
			} catch(e:Error) {
				Game.connectionManager.sendClientMessage("Error in HttpCookies.sC(), " + e.getStackTrace());
			}
		}
	}
	
}
