package com.alisacasino.bingo.utils
{
	public class Server
	{
		private var mHost:String = "";
		private var mPort:int = 0;
		private var mUseSSL:Boolean = true;
		
		public function Server(host:String, port:int, useSSL:Boolean)
		{
			mHost = host;
			mPort = port;
			mUseSSL = useSSL;
		}
		
		public function get port():int
		{
			return mPort;
		}
		
		public function get host():String
		{
			return mHost;
		}
		
		public function get useSSL():Boolean
		{
			return mUseSSL;
		}
	}
}