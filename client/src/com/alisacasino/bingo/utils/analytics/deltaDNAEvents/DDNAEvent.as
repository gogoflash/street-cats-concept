package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	import com.alisacasino.bingo.assets.AssetsManager;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.chests.ChestPowerupPack;
	import com.alisacasino.bingo.models.collections.CollectionItem;
	import com.alisacasino.bingo.models.powerups.PowerupModel;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.SignInMessage.Platform;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.store.items.CashStoreItem;
	import com.alisacasino.bingo.store.items.ChestStoreItem;
	import com.alisacasino.bingo.utils.analytics.DeltaDNAAnalytics;
	import com.alisacasino.bingo.utils.analytics.events.AnalyticsEvent;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNAEvent extends AnalyticsEvent
	{
		
		private static const fieldMatch:Object = {
			eventType: "eventName",
			playerId	: "userID",
			sessionUUID: "sessionID",
			deviceId: "eventParams#deviceID",
			timestamp: "eventTimestamp",
			sessionTime: "eventParams#sessionTime"
		};
		
		private var paramsObject:Object;
		
		private var excludeFields:Array;
	
		public function DDNAEvent(excludeFields:Array = null) 
		{
			this.excludeFields = excludeFields;
			paramsObject = { };
			addBaseSchemaParameters();
		}
		
		protected function addBaseSchemaParameters():void
		{
			addMasterField("eventUUID", generateUUID());
			addMasterField("sessionID", gameManager.analyticsManager.ddnaSessionUUID);
			addMasterField("userID", Player.current ? Player.current.playerId.toString() : "-1");
			addParamsField("platform", getPlatformString(PlatformServices.platform));
			addParamsField("userLevel", Player.current ? Player.current.xpLevel : -1);
			addParamsField("userXP", Player.current ? Player.current.xpCount : -1);
		}
		
		protected function addRoundID():void
		{
			addParamsField("matchID", Room.current ? Room.current.roundID : Room.UNKNOWN_ROUND_ID);
		}
		
		/**
		 * addRoundID proxy
		 */
		protected function addMatchID():void
		{
			addRoundID();
		}
		
		private function getPlatformString(platform:int):String
		{
			switch(platform)
			{
				case Platform.FACEBOOK:
					return "FACEBOOK";
				case Platform.GOOGLE_PLAY:
					return "ANDROID";
				case Platform.AMAZON_APP_STORE:
					return "AMAZON";
				case Platform.APPLE_APP_STORE:
					return "IOS_MOBILE";
			}
			return "UNKNOWN";
		}
		
		override public function addEventType(type:String):AnalyticsEvent 
		{
			return addMasterField("eventName", type);
		}
		
		override public function addField(key:String, value:*):AnalyticsEvent 
		{
			var toParams:Boolean = true;
			if (fieldMatch.hasOwnProperty(key))
			{
				key = fieldMatch[key];
				if (key.indexOf("eventParams#") != -1)
				{
					key = key.substr(12);
					toParams = true;
				}
				else
				{
					toParams = false;
				}
			}
			
			if(toParams)
				return addParamsField(key, value);
			else
				return addMasterField(key, value);
		}
		
		public function addMasterField(key:String, value:*):AnalyticsEvent
		{
			return super.addField(key, value);
		}
		
		public function addParamsField(key:String, value:*):AnalyticsEvent
		{
			if (excludeFields && excludeFields.indexOf(key) != -1)
				return this;
			if (value == null)
			{
				sosTrace("DDNAEvent got null value for " + key + ": ",  new Error().getStackTrace(), SOSLog.ERROR);
				return this;
			}
			paramsObject[key] = value;
			return this;
		}
		
		private function convertType(eventType:String):String
		{
			if (DeltaDNAAnalytics.eventConversionTable.hasOwnProperty(eventType))
			{
				return DeltaDNAAnalytics.eventConversionTable[eventType];
			}
			return eventType;
		}
		
		public function getJSON():String
		{
			var exportObj:Object = _contents;
			exportObj["eventParams"] = paramsObject;
			return JSON.stringify(exportObj);
		}
		
		override public function getContents():Object 
		{
			_contents["eventParams"] = paramsObject;
			return super.getContents();
		}
		
		private function generateUUID():String
		{
			var uuid:String = "";
			for (var i:int = 0; i < 4; i++) 
			{
				uuid += uint(uint.MAX_VALUE * Math.random()).toString(16);
			}
			return uuid;
		}
		
		protected function createRewardProductsList(sourceItems:Array, powerupsObject:Object = null, collectionName:String = null):Object
		{
			return DDNARewardsHelper.createRewardProductsList(sourceItems, powerupsObject, collectionName);
		}
		
		protected function createRewardObject(rewardName:String, rewards:Array, powerupsObject:Object = null, collectionName:String = null):Object
		{
			var rewardObject:Object = { }
		
			rewardObject["rewardName"] = rewardName;
			
			rewardObject["rewardProducts"] = createRewardProductsList(rewards, powerupsObject, collectionName);
			return rewardObject;
		}
		
		
	}
	
}