package com.alisacasino.bingo.commands.gameLoading 
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	public class LocalStartSettings 
	{
		public function LocalStartSettings() {
			
		}
		
		private static var _instance:LocalStartSettings;
		
		private var completeCallback:Function;
		
		public static function get instance():LocalStartSettings {
			if (!_instance)
				_instance = new LocalStartSettings();
			return _instance;
		}
		
		public function execute(callback:Function):void {
			completeCallback = callback;
			const request:URLRequest = new URLRequest('local_config.xml');
			const loader:URLLoader = new URLLoader();
			loader.addEventListener(flash.events.Event.COMPLETE, handler_externalAppConfig);
			loader.addEventListener(IOErrorEvent.IO_ERROR, handler_externalAppConfig);
			loader.load(request);
		}
		
		private function handler_externalAppConfig(event:flash.events.Event):void
		{
			const loader:URLLoader = event.target as URLLoader;
			loader.removeEventListener(flash.events.Event.COMPLETE, handler_externalAppConfig);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, handler_externalAppConfig);
			if (event is ErrorEvent)
			{
				sosTrace("can't load local_config.xml");
				
				if(completeCallback != null)
					completeCallback();
				
				return;
			}
			
			var xml:XML = new XML(loader.data);
			var node:XML = xml.node.(@id == xml.@node)[0] as XML;
			
			if (node)
			{
				const nodes:XMLList = node[0].children();
				const o:Object = new Object();
				
				for each (var _node:XML in nodes)
				{
					o[_node.localName()] = _node.toString();
				}
				
				
				//$model.properties.domain = String(o.domain);
				//$model.properties.basePath = String(o.base_path);
			
			}
			else
			{
				trace('Error in local_config.xml');
			}
		
			if(completeCallback != null)
				completeCallback();
		}
	}

}