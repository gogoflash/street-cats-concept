package com.alisacasino.bingo.utils.graphicsPresets 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class GraphicsSetHelperBase 
	{
		private var _graphicsSetKey:*;
		
		public function get graphicsSetKey():* 
		{
			return _graphicsSetKey;
		}
		
		public function set graphicsSetKey(value:*):void 
		{
			_graphicsSetKey = value;
		}
		
		protected var defaultSet:Object;
		protected var setByKey:Object;
		
		public function GraphicsSetHelperBase() 
		{
			setByKey = { };
		}
		
		protected function addSetByKey(key:*, setObject:Object):void 
		{
			setByKey[key] = setObject;
		}
		
		protected function getProperty(propertyName:String):*
		{
			if (getCurrentSet() && getCurrentSet().hasOwnProperty(propertyName))
			{
				return getCurrentSet()[propertyName];
			}
			
			return defaultSet[propertyName];
		}
		
		protected function getCurrentSet():Object
		{
			//TODO: cache current set
			if (graphicsSetKey != null && setByKey.hasOwnProperty(graphicsSetKey))
			{
				return setByKey[graphicsSetKey];
			}
			sosTrace( "Set for key " + graphicsSetKey + " not found!", SOSLog.ERROR);
			return defaultSet;
		}
		
	}

}