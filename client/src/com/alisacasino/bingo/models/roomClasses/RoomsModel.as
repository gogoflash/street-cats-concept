package com.alisacasino.bingo.models.roomClasses 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.models.roomClasses.RoomType;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.LobbyDataMessage;
	import com.alisacasino.bingo.protocol.RoomTypeMessage;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.TimeService;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class RoomsModel 
	{
		public function get currentRoomTypeName():String
		{
			return PlatformServices.interceptor.currentRoomTypeName;
		}
		
		public function set currentRoomTypeName(roomTypeName:String):void
		{
			PlatformServices.interceptor.currentRoomTypeName = roomTypeName;
		}
		
		private var roomByID:Object;
		
		public function RoomsModel() 
		{
			roomByID = { };
		}
		
		
		public function getRoomByType(roomTypeName:String):RoomType
		{
			for each (var item:RoomType in RoomType.sAllRoomTypes) 
			{
				if (item.roomTypeName == roomTypeName)
				{
					return item;
				}
			}
			
			var newRoomType:RoomType = new RoomType(roomTypeName);			
			RoomType.sAllRoomTypes.push(newRoomType);
			return newRoomType;
		}
		
		public function deserializeRooms(roomTypes:Array):void 
		{
			for each (var item:RoomTypeMessage in roomTypes) 
			{
				var roomType:RoomType = getRoomByType(item.roomTypeName);
				if (roomType)
				{
					roomByID[item.roomId] = roomType.deserialize(item);
				}
			}
		}
		
		public function getRoomTypeByID(roomID:uint):RoomType
		{
			if (roomByID.hasOwnProperty(roomID))
			{
				return roomByID[roomID];
			}
			sosTrace("Could not find room with id " + roomID, SOSLog.ERROR);
			return null;
		}
		
		public function roomIDExists(roomID:uint):Boolean
		{
			return roomByID.hasOwnProperty(roomID);
		}
		
	}

}