package com.alisacasino.bingo.models.chests 
{
	public class StoredChest 
	{
		public var type:int;
		public var time:int;
		public var source:String;
		
		public function StoredChest(type:int, time:uint, source:String) 
		{
			this.type = type;
			this.time = time;
			this.source = source;
		}
		
		public static function parseFromRaw(storedChestsRaw:Array):Vector.<StoredChest>
		{
			var returnList:Vector.<StoredChest> = new <StoredChest> [];
			if (!storedChestsRaw)
				return returnList;
			
			var i:int = 0;
			var length:int = storedChestsRaw.length;
			var chestRaw:Array;
			for (i = 0; i < length; i++) 
			{
				chestRaw = storedChestsRaw[i];
				returnList.push(new StoredChest(chestRaw[0], chestRaw[1], chestRaw[2]));
			}
			
			return returnList;
		}
		
		public static function parseToRaw(storedChests:Vector.<StoredChest>):Array
		{
			var returnList:Array = [];
			if (!storedChests)
				return returnList;
				
			var i:int = 0;
			var length:int = storedChests.length;
			var storedChest:StoredChest;
			for (i = 0; i < length; i++) 
			{
				storedChest = storedChests[i];
				returnList.push([storedChest.type, storedChest.time, storedChest.source]);
			}
			
			return returnList;
		}
	}
}