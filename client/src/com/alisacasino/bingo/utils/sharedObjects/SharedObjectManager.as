package com.alisacasino.bingo.utils.sharedObjects 
{
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class SharedObjectManager 
	{
		static private var _instance:SharedObjectManager;
		
		public static function get instance():SharedObjectManager
		{
			if (!_instance)
			{
				_instance = new SharedObjectManager();
			}
			return _instance;
		}
		
		private var sharedObject:SharedObject;
		
		public function SharedObjectManager() 
		{
			try
			{
				sharedObject = SharedObject.getLocal("alisabingoarena");
			}
			catch (e:Error)
			{
				sosTrace( "Error while trying to access SharedObject : " + e, SOSLog.ERROR);
			}
		}
		
		public function getSharedProperty(propertyName:String, defaultValue:* = null):*
		{
			if (sharedObject && sharedObject.data)
			{
				return sharedObject.data[propertyName];
			}
			return defaultValue;
		}
		
		public function setSharedProperty(propertyName:String, propertyValue:*):void
		{
			if (sharedObject && sharedObject.data)
			{
				sharedObject.data[propertyName] = propertyValue;
				
				try
				{
					sharedObject.flush();
				}
				catch (e:Error)
				{
					sosTrace( "Failed to flush SharedObject : " + e, SOSLog.ERROR);
				}
			}
			else 
			{
				sosTrace( "Error - no sharedObject present", SOSLog.ERROR);
			}
		}
		
		public function clean():void
		{
			if (sharedObject)
			{
				try
				{
					sharedObject.clear();
				}
				catch (e:Error)
				{
					sosTrace( "Failed to clear SharedObject : " + e, SOSLog.ERROR);
				}
			}
		}
		
	}

}