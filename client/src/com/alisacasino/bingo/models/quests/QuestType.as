package com.alisacasino.bingo.models.quests 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class QuestType 
	{
		static public const DAILY_QUEST:String = "dailyQuest";
		static public const EVENT_QUEST:String = "eventQuest";
		static public const BONUS_QUEST:String = "bonusQuest";
		
		public function QuestType() 
		{
			
		}
		
		private static var _allTypes:Array;
		
		public static function get allTypes():Array 
		{
			if (!_allTypes)
				_allTypes = [DAILY_QUEST, EVENT_QUEST, BONUS_QUEST];
			
			return _allTypes;	
		}
		
		public static function getTypes(excludeType:String):Array 
		{
			var types:Array = types.concat(allTypes);
			var i:int = types.indexOf(excludeType);
			if (i != -1)
				types.splice(i, 1);
			
			return types;	
		}
		
	}

}