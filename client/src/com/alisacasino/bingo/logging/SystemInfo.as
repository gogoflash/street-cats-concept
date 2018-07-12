package com.alisacasino.bingo.logging 
{
	import flash.display.Stage3D;
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;

	/**
	 * ...
	 * @author Dmitriy Barabanaschikov
	 */
	public class SystemInfo
	{
		static public function getDriverInfo(stage3D:Stage3D):String
		{
			try
			{
				if (!stage3D.context3D)
				{
					return "Context3D not initialized";
				}
				else
				{
					return stage3D.context3D.driverInfo;
				}
				
			}
			catch (e:Error)
			{
				return "error";
			}
			return "unexpected function termination";
		}
		
		
		static public function getUserAgentString():String
		{
			if (!ExternalInterface.available)
				return "Not available";
			
			var data:Object = ExternalInterface.call(CHECK_VERSION);
			return String(data.userAgent);
		}
		
		static public function getBrowserName():String
		{
			if (!ExternalInterface.available)
				return "Not available";
			
			var data:Object = ExternalInterface.call(CHECK_VERSION);
			return String(data.appName);
		}
		
		static public function getBrowserVersion():String
		{
			if (!ExternalInterface.available)
				return "Not available";
			
			var data:Object = ExternalInterface.call(CHECK_VERSION);
			return String(data.version);
		}
		
		static public function getUserAgentData():Object
		{
			if (!ExternalInterface.available)
				return null;
			
			return ExternalInterface.call(CHECK_VERSION);
		}
		
		static public function get canUseAtfTextures():Boolean
		{
			var version:String = Capabilities.version;
			if (version) 
			{
				var match:Array = version.match(/\d+/g);
				var major:int = match.length > 1 ? int(match[0]) : 0;
				var minor:int = match.length > 1 ? int(match[1]) : 0;
				if ((major >= 12) || (major == 11 && minor >= 4))
					return true;
			}
			
			return false;
		}
		
		private static const CHECK_VERSION:XML = <![CDATA[
             function( ) { 
				 return { appName: navigator.appName, version:navigator.appVersion, userAgent: navigator.userAgent };
                }
            ]]>;
		
	}

}