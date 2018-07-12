package com.alisacasino.bingo.protocol.SelfTestMessage {
	public final class InternalEvent {
		public static const ServerStarted:int = 0;
		public static const ServerStopping:int = 1;
		public static const ServerStopped:int = 2;
		public static const RoomCreated:int = 3;
		public static const RoomDeleted:int = 4;
		public static const ClientClosedConnection:int = 5;
		public static const ConnectionClosedByServer:int = 6;
	}
}
