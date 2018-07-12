package com.alisacasino.bingo.platform.mobile
{
	import com.alisacasino.bingo.models.Player;
	public class FacebookDialogResponse
	{
		public function FacebookDialogResponse() {
			userIds;
			requestId;
		}
		
		public var userIds:Array;
	
		public var requestId:String;
		
		public var responseStatusOk:Boolean;
		
		public function get isEmpty():Boolean {
			return !userIds || userIds.length == 0;
		}
		
		public function parse(raw:Object):void {
			if (!raw)
				return;
				
			requestId = "request" in raw ? String(raw["request"]) : null;
			userIds = "to" in raw ? raw["to"] : null;
		}
		
		public static function create(idList:Vector.<String> = null):FacebookDialogResponse
		{
			var item:FacebookDialogResponse = new FacebookDialogResponse();
			item.userIds = [];
			
			if (!idList)
				return item;
			
			for (var i:int = 0; i < idList.length; i++) {
				item.userIds[i] = idList[i];
			}
			
			// uniq id:
			item.requestId = Player.current ? (Player.current.playerId.toString() + new Date().getTime().toString() + int(10000*Math.random()).toString()): null;
			
			return item;
		}
		
	}
}