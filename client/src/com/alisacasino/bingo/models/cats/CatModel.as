package com.alisacasino.bingo.models.cats 
{
	import starling.events.EventDispatcher;
	
	public class CatModel extends EventDispatcher
	{
		public function CatModel() 
		{
			
		}
		
		public var id:int;
		
		public var catUID:int;
		
		private var _health:int;
		
		public var role:String;
		
		public var targetCat:int = -1;
		
		
		public var active:Boolean;
		
		public function set health(value:int):void {
			_health = Math.max(0, value);
		}
		
		public function get health():int {
			return _health;
		}
	}

}