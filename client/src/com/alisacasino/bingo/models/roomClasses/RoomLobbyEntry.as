package com.alisacasino.bingo.models.roomClasses 
{
	import com.alisacasino.bingo.protocol.LobbyRoomDataMessage;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class RoomLobbyEntry
	{
		private var _cachedRoomType:RoomType;
		
		public function get roomType():RoomType
		{
			if (!_cachedRoomType)
			{
				_cachedRoomType = gameManager.roomsModel.getRoomTypeByID(roomID);
			}
			return _cachedRoomType;
		}
		
		public var order:int;
		public var roomID:uint;
		public var eventOrder:int = -1;
		public var commonLobbyEventOrder:int = -1;
		public var addedFromWBT:Boolean;
		
		public function RoomLobbyEntry(roomID:uint = 0, order:int = 0) 
		{
			this.roomID = roomID;
			this.order = order;
		}
		
		public function deserialize(item:LobbyRoomDataMessage):RoomLobbyEntry
		{
			this.roomID = item.roomId;
			this.order = item.order;
			this.eventOrder = item.hasEventOrder ? item.eventOrder : -1;
			this.commonLobbyEventOrder = item.hasCommonLobbyEventOrder ? item.commonLobbyEventOrder : -1;
			return this;
		}
		
	}

}