package com.alisacasino.bingo.utils
{
	import avmplus.DescribeTypeJSON;
	import avmplus.getQualifiedClassName;
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.messages.HandleRequestHelloMessage;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.ReconnectDialog;
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
	import starling.core.Starling;
	
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
			mHost = '54.146.172.237';
			mPort = 8888;
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
			1 + 1
			Game.dispatchEventWith(ConnectionManager.CONNECTION_ESTABLISHED_EVENT);
			
			if (!rer)
				sendMessage(null);
		}
		
		private function onDisconnect(e:Event):void
		{
			
			var reconnectDialog1:ReconnectDialog = new ReconnectDialog(ReconnectDialog.TYPE_INFO, 'Socket event', 'Socket closet!');
			
			Starling.juggler.delayCall(DialogsManager.addDialog, 2.3, reconnectDialog1, true, true)
			//DialogsManager.addDialog(reconnectDialog1, true, true);
			
			return;
			
			
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

			//var dd1:String = mBuffer.readUTF();
			
			while (mBuffer.position < mBuffer.length) 
			{
				/*if (mMessageLength == 0) {
					var oldPosition:int = mBuffer.position;
					try {
						mMessageLength = readVarint32(mBuffer);
					} catch (e:Error) {
						mBuffer.position = oldPosition;
						break;
					}
				}*/
				if (true/*mMessageLength <= mBuffer.bytesAvailable*/) {
					var  msg:BaseMessage = new BaseMessage();
					
					var ba:ByteArray = new ByteArray();
					
					mBuffer.position = 0//oldPosition;
					var dd:String = mBuffer.readUTFBytes(mBuffer.bytesAvailable)//mBuffer.readUTFBytes(/*mBuffer.bytesAvailable - */mMessageLength);
					trace('<>>>>> ', dd);
					
					//dd = dd.replace('} {', '');
					var iii:int = dd.search('}{');
					var iiss:int = dd.indexOf('}{');
					
					if (iii != -1)
						dd = dd.slice(0, iii + 1);
					
					
					var sse:Object = JSON.parse(dd);
					
					/*var rawString:String = '';
					var ss:int;
					
					while (ss < dd.length) {
						var s:String;
						s = dd.charAt(ss);
						if (s == "\"" ) {
							rawString += '"';
						}
						else {
							rawString += s;
						}
						ss++;
						
					}
					
					var re:Object = JSON.parse(rawString);*/
					1  +1
					Game.connectionManager.parseMessageNew(sse);
					
					//msg.used_by_generated_code::readFromSlice(mBuffer, mBuffer.bytesAvailable - mMessageLength);
					//mMessageLength = 0;
					
					//Game.dispatchEventWith(Game.MESSAGE_RECEIVED_EVENT, false, msg);
					//Game.connectionManager.parseMessage(msg);
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
			
			
			
			if (!mSocket.connected)
			{
				sosTrace("Socket is not connected", SOSLog.ERROR);
				return;
			}
			
			
			if (rer)
				return;
				
			rer = true;	
			
			
			/*var baseMessage:BaseMessage = new BaseMessage();
			baseMessage.protocolVersion = Constants.PROTOCOL_VERSION;
			var messageClass:Class = Object(m).constructor;
			var type:FieldDescriptor = baseMessageFieldByClass[messageClass] as FieldDescriptor;
			if (type != null)
			{
				baseMessage[type.name] = m;
			}
			else
			{
				sosTrace("Message not registered " + getQualifiedClassName(m), SOSLog.FATAL);
			}*/
			
			
			var ba:ByteArray = new ByteArray();
			//baseMessage.writeDelimitedTo(ba);
			
			if (GameManager.instance.pwdHash == null) {
				GameManager.instance.createNewPwdHash();
			}
			
			var jso:Object = {
			   id: 2, //GameManager.instance.pwdHash
			   session: null,
			   name: "signIn",
			   payload: {platformId:1} 
			}
			
			var json:String = JSON.stringify(jso);
			ba.writeUTFBytes(json);	
			
			mSocket.writeBytes(ba);
			mSocket.flush();
			ba.clear();
		}
		
		private var rer:Boolean;
		
		
		public function sendMessageNew(data:Object):void
		{
			if (!mSocket.connected || !rer)
			{
				sosTrace("Socket is not connected", SOSLog.ERROR);
				return;
			}
			
			var ba:ByteArray = new ByteArray();
			
			
			var json:String = JSON.stringify(data);
			ba.writeUTFBytes(json);	
			
			mSocket.writeBytes(ba);
			mSocket.flush();
			ba.clear();
		}
		
		
		public function get host():String {
			return mHost;
		}
	}
}