package com.alisacasino.bingo.utils
{
	import avmplus.DescribeTypeJSON;
	import avmplus.getQualifiedClassName;
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.messages.HandleRequestHelloMessage;
	import com.alisacasino.bingo.protocol.BaseMessage;
	import com.alisacasino.bingo.protocol.BingoMessage;
	import com.alisacasino.bingo.protocol.BuyCardsMessage;
	import com.alisacasino.bingo.protocol.ClaimOfferMessage;
	import com.alisacasino.bingo.protocol.ClaimOfferV2Message;
	import com.alisacasino.bingo.protocol.ClientMessage;
	import com.alisacasino.bingo.protocol.GiftAcceptedMessage;
	import com.alisacasino.bingo.protocol.GiftMessage;
	import com.alisacasino.bingo.protocol.GiftsAcceptedMessage;
	import com.alisacasino.bingo.protocol.InviteMessage;
	import com.alisacasino.bingo.protocol.JoinMessage;
	import com.alisacasino.bingo.protocol.LeaveMessage;
	import com.alisacasino.bingo.protocol.LiveEventInfoMessage;
	import com.alisacasino.bingo.protocol.LiveEventLeaderboardsMessage;
	import com.alisacasino.bingo.protocol.LiveEventScoreUpdateMessage;
	import com.alisacasino.bingo.protocol.OfferAcceptedMessage;
	import com.alisacasino.bingo.protocol.PlayerUpdateMessage;
	import com.alisacasino.bingo.protocol.PurchaseMessage;
	import com.alisacasino.bingo.protocol.RequestServerStatusMessage;
	import com.alisacasino.bingo.protocol.RequestUnacceptedGiftsMessage;
	import com.alisacasino.bingo.protocol.SignInMessage;
	import com.netease.protobuf.FieldDescriptor;
	import com.netease.protobuf.Message;
	import com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.FieldDescriptor$TYPE_MESSAGE;
	import flash.utils.Dictionary;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.SecureSocket;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.setTimeout;
	
	public class ServerConnection
	{
		public function get connected():Boolean
		{
			return mSocket && mSocket.connected;
		}
		
		private var mSocket:Socket;
		private var mBuffer:ByteArray;
		private var mMessageLength:int;
		private var mHost:String;
		private var mPort:int;
		
		private static var sCurrentServerConnection:ServerConnection = null;
		
		private const baseMessageFieldByClass:Dictionary = new Dictionary();
		
		public static function get current():ServerConnection
		{
			return sCurrentServerConnection;
		}
		
		public static function set current(conn:ServerConnection):void
		{
			sCurrentServerConnection = conn;
		}
		
		public function ServerConnection(host:String, port:int, useSSL:Boolean)
		{
			mHost = host;
			mPort = port;
			mBuffer = new ByteArray();
			mMessageLength = 0;
			if (useSSL)
				mSocket = new SecureSocket();
			else
				mSocket = new Socket();
			
			mSocket.addEventListener(Event.CONNECT, onConnect);
			mSocket.addEventListener(Event.CLOSE, onDisconnect);
			mSocket.addEventListener(IOErrorEvent.IO_ERROR, onError);
			mSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			mSocket.addEventListener(ProgressEvent.SOCKET_DATA, onDataReceived);
			mSocket.addEventListener(Event.CLOSE, mSocket_close);
			mSocket.timeout = Constants.SOCKET_TIMEOUT_MILLIS;
			
			var classDescription:Object = new DescribeTypeJSON().getClassDescription(BaseMessage);
			var fieldDescriptorVariables:Array = classDescription["traits"]["variables"];
			for each (var fieldDescriptorVariableEntry:Object in fieldDescriptorVariables) 
			{
				
				var fieldDescriptor:FieldDescriptor$TYPE_MESSAGE = BaseMessage[fieldDescriptorVariableEntry["name"]] as com.netease.protobuf.fieldDescriptors.FieldDescriptor$TYPE_MESSAGE;
				if (fieldDescriptor)
				{
					baseMessageFieldByClass[fieldDescriptor.type] = fieldDescriptor;
				}
			}
		}
		
		public function getBaseMessageFields():Dictionary
		{
			return baseMessageFieldByClass;
		}
		
		private function mSocket_close(e:Event):void 
		{
			sosTrace( "ServerConnection.mSocket_close > e : " + e, SOSLog.ERROR);
		}
		
		public function connect():void
		{
			mSocket.connect(mHost, mPort);
			
			Game.connectionManager.helloReceived = false;
		}
		
		public function close():void
		{
			if (connected)
			{
				mSocket.close();
			}
		}
		
		public function onConnect(e:Event):void
		{
			Game.dispatchEventWith(ConnectionManager.CONNECTION_ESTABLISHED_EVENT);
		}
		
		private function onDisconnect(e:Event):void
		{
			current = null;
			Game.dispatchEventWith(ConnectionManager.CONNECTION_CLOSED_EVENT, false, 'Socket close');
		}
		
		public function onError(e:Event):void
		{
			sosTrace( "ServerConnection.onError > e : " + e, SOSLog.ERROR);
			
			var errorMessage:String;
			if (e is IOErrorEvent)
				errorMessage = (e as IOErrorEvent).text;
			else if (e is SecurityErrorEvent)
				errorMessage = (e as SecurityErrorEvent).text;
			else	
				errorMessage = 'unknown server connection error';
			
			Game.dispatchEventWith(ConnectionManager.CONNECTION_ERROR_EVENT, false, errorMessage);
		}
		
		public static function readVarint32(input:IDataInput):uint {
			var result:uint = 0
			for (var i:uint = 0;; i += 7) {
				if (input.bytesAvailable == 0)
					throw new Error("not enough data");
				var b:uint = input.readUnsignedByte()
				if (i < 32) {
					if (b >= 0x80) {
						result |= ((b & 0x7f) << i)
					} else {
						result |= (b << i)
						break
					}
				} else {
					while (input.readUnsignedByte() >= 0x80) {}
					break
				}
			}
			return result
		}
		
		public function onDataReceived(e:ProgressEvent):void
		{
			mSocket.readBytes(mBuffer, mBuffer.length, mSocket.bytesAvailable);
			
			mBuffer.endian = flash.utils.Endian.LITTLE_ENDIAN;

			while (mBuffer.position < mBuffer.length) {
				if (mMessageLength == 0) {
					var oldPosition:int = mBuffer.position;
					try {
						mMessageLength = readVarint32(mBuffer);
					} catch (e:Error) {
						mBuffer.position = oldPosition;
						break;
					}
				}
				if (mMessageLength <= mBuffer.bytesAvailable) {
					var  msg:BaseMessage = new BaseMessage();
					msg.used_by_generated_code::readFromSlice(mBuffer, mBuffer.bytesAvailable - mMessageLength);
					mMessageLength = 0;
					//Game.dispatchEventWith(Game.MESSAGE_RECEIVED_EVENT, false, msg);
					Game.connectionManager.parseMessage(msg);
				} else
					break;
			}
			
			if (mBuffer.bytesAvailable == 0)
			{
				mBuffer.clear();
			}
		}
		
		public function sendMessage(m:com.netease.protobuf.Message, doNotLog:Boolean = false):void
		{
			//trace('send message ', getQualifiedClassName(m) );
			if (ConnectionManager.LOGGING_ENABLED)
			{
				if (!doNotLog) {
					try {
						sosTrace( "ServerConnection.sendMessage > m : " + getQualifiedClassName(m) + ": " + m.toString(), SOSLog.INFO);
					}
					catch(error:Error) {
						sosTrace( "Cannot parse " + getQualifiedClassName(m) + ".toString() message ServerConnection.sendMessage ", error.name, error.message, SOSLog.INFO);
					}
				}
				else
				{
					try {
						sosTrace( "ServerConnection.sendMessage > m : " + getQualifiedClassName(m), SOSLog.INFO);
					}
					catch(error:Error) {
						sosTrace( "Cannot log " + getQualifiedClassName(m) + " message ServerConnection.sendMessage ", error.name, error.message, SOSLog.INFO);
					}
				}
			}
			
			if (!mSocket.connected)
			{
				sosTrace("Socket is not connected", SOSLog.ERROR);
				return;
			}
			
			
			
			var baseMessage:BaseMessage = new BaseMessage();
			baseMessage.protocolVersion = Constants.PROTOCOL_VERSION;
			var messageClass:Class = Object(m).constructor;
			var type:FieldDescriptor = baseMessageFieldByClass[messageClass] as FieldDescriptor;
			if (type != null)
			{
				baseMessage[type.name] = m;
				
				//var obj:Object = {};
				//obj[type.name] = m;
				//Game.messageLog.push(obj);
			}
			else
			{
				sosTrace("Message not registered " + getQualifiedClassName(m), SOSLog.FATAL);
			}
			
			if (ConnectionManager.LOGGING_ENABLED)
			{
				if (!doNotLog) {
					try {
						sosTrace( "baseMessage : " + baseMessage.toString(), SOSLog.INFO);
					}
					catch(error:Error) {
					}
				}
			}
			
			
			
			var ba:ByteArray = new ByteArray();
			baseMessage.writeDelimitedTo(ba);
			mSocket.writeBytes(ba);
			mSocket.flush();
			ba.clear();
		}
		
		public function get host():String {
			return mHost;
		}
	}
}