package com.alisacasino.bingo.utils.analytics.events 
{
	import avmplus.getQualifiedClassName;
	import com.alisacasino.bingo.utils.TimeService;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class AnalyticsEvent 
	{
		protected var _contents:Object;
		
		public function get eventType():String
		{
			return _contents["eventType"];
		}
		
		public function getField(key:String):*
		{
			if (_contents)
				return _contents[key];
			
			return null;
		}
		
		public function AnalyticsEvent() 
		{
		}
		
		public function addEventType(type:String):AnalyticsEvent
		{
			return addField("eventType", type);
		}
		
		public function addSubtype(subtype:String):AnalyticsEvent
		{
			return addField("eventSubtype", subtype);
		}
		
		public function addField(key:String, value:*):AnalyticsEvent
		{
			if (!_contents)
			{
				_contents = { };
			}
			
			_contents[key] = value;
			return this;
		}
		
		public function export():Object
		{
			if (!_contents)
			{
				sosTrace( "No content to export from " + getQualifiedClassName(this), SOSLog.WARNING);
				return null;
			}
			return _contents;
		}
		
		public function getContents():Object
		{
			return _contents;
		}
		
	}

}