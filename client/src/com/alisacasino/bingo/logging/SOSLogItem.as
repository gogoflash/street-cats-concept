package com.alisacasino.bingo.logging 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class SOSLogItem
	{
		public var time:int;
		
		public var message:String;
		
		public var type:String;
		
		public function SOSLogItem(message:String = "empty message", type:String ="", time:int = 0) 
		{
			this.message = message;
			this.type = type;
			this.time = time;
		}
		
	}

}