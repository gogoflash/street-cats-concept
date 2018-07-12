package com.alisacasino.bingo.utils.clientData 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.serverRequests.SendClientDataSave;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.utils.TimeService;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ClientDataManager 
	{
		private var dataObject:Object;
		
		private var needToFlush:Boolean;
		
		public function ClientDataManager() 
		{
			dataObject = { };
			TimeService.instance.addOneSecondCallback(flushClientData);
		}
		
		private function flushClientData():void 
		{
			if (!Player.current)
			{
				needToFlush = false;
				return;
			}
			
			if (!needToFlush)
			{
				return;
			}
			
			gameManager.connectionManager.sendClientDataSaveMessage();
			//new SendClientDataSave(dataObject).execute();
			needToFlush = false;
		}
		
		public function get clientDataByteArray():ByteArray {
			var blob:ByteArray = new ByteArray();
			blob.writeObject(dataObject);
			return blob;
		}
		
		public function getValue(key:String, defaultValue:* = null):*
		{
			if (!dataObject)
			{
				sosTrace("Client data is not deserialized yet", SOSLog.WARNING);
				return defaultValue;
			}
			
			if (dataObject.hasOwnProperty(key))
			{
				return dataObject[key];
			}
			return defaultValue;
		}
		
		public function setValue(key:String, value:*, forceFlush:Boolean = false):void
		{
			sosTrace( "ClientDataManager.setValue > key : " + key + ", value : " + value, SOSLog.INFO);
			if (!dataObject)
			{
				sosTrace("Client data is not deserialized yet", SOSLog.WARNING);
				return;
			}
			
			if (dataObject[key] == value && !forceFlush)
			{
				return;
			}
			else
			{
				dataObject[key] = value;
				needToFlush = true;
			}
		}
		
		public function deleteValue(key:String):void
		{
			if (!dataObject)
			{
				sosTrace("Client data is not deserialized yet", SOSLog.WARNING);
				return;
			}
			
			if (!dataObject.hasOwnProperty(key))
			{
				return;
			}
			
			delete dataObject[key];
			needToFlush = true;
		}
		
		public function deserialize(serializedData:ByteArray):void
		{
			if (!serializedData)
			{
				dataObject = { };
				return;
			}
			
			//TODO should do shallow or deep copy, prolly.
			serializedData.position = 0;
			dataObject = serializedData.readObject();
			sosTrace( "dataObject : ", dataObject, SOSLog.INFO);
		}
		
		public function cleanAll():void
		{
			dataObject = { };
			needToFlush = true;
			flushClientData();
		}
		
	}

}