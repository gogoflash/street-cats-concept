package com.alisacasino.bingo.models
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.dialogs.BaseDialog;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.RateUsDialog;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.SignInMessage.Platform;
	import com.alisacasino.bingo.protocol.StaticDataMessage;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.GameManager;
	import starling.events.Event;
	
	public class RateDialogManager 
	{
		private static var _instance:RateDialogManager;
		
		public function RateDialogManager() {
			
		}
		
		private var KEY_LAST_SHOW_TIMESTAMP:String = "rateUsDialogShowTimestamp";
		private var KEY_RATED_STARS:String = "rateUsDialogRatedStars";
		private var KEY_DAILY_BONUS_GET_COUNT:String = "rateUsDialogDailyBonusGetCount";
		private var KEY_RATED_CLIENT_VERSION:String = "rateUsDialogRatedVersion";
		
		public var triggered:Boolean;
			
		private var showInterval:int;
		private var isEnabledOnServer:Boolean = true; 		
		private var gamesCount:int; 					
		private var triggerTourneyTopRankValue:int;  
		private var triggerDailyBonusCount:int;  	
		private var triggerBingosPerRoundCount:int = 2;  	
		
		private var onCompleteShowDialog:Function;
		private var iosRateUsURL:String;
		private var amazonRateUsURL:String;
		private var androidRateUsURL:String;
		private var ios7RateUsURL:String;
				
		public static function get instance():RateDialogManager {
			if (!_instance) 
				_instance = new RateDialogManager();
			
			return _instance;
		}
		
		public function deserializeStaticData(staticData:StaticDataMessage):void
		{
			triggered = false;
			
			showInterval = 'rateUsShowInterval' in staticData ? staticData['rateUsShowInterval'] : 0;
			isEnabledOnServer = 'rateUsEnabled' in staticData ? Boolean(staticData['rateUsEnabled']) : false;
			gamesCount = 'rateUsMinRounds' in staticData ? staticData['rateUsMinRounds'] : 0;			
			triggerTourneyTopRankValue = 'rateUsTournamentTopPlace' in staticData ? staticData['rateUsTournamentTopPlace'] : int.MAX_VALUE;
			triggerDailyBonusCount = 'rateUsDailyBonusesTaken' in staticData ? staticData['rateUsDailyBonusesTaken'] : int.MAX_VALUE;
			
			if (staticData.hasRateUsIosUrl)
			{
				iosRateUsURL = staticData.rateUsIosUrl;
			}
			
			if (staticData.hasRateUsAmazonUrl)
			{
				amazonRateUsURL = staticData.rateUsAmazonUrl;
			}
			
			if (staticData.hasRateUsAndroidUrl)
			{
				androidRateUsURL = staticData.rateUsAndroidUrl;
			}
			
			if (staticData.hasRateUsIos7Url)
			{
				ios7RateUsURL = staticData.rateUsIos7Url;
			}
				
			if(lastShowTimeStamp == 0)
                gameManager.clientDataManager.setValue(KEY_LAST_SHOW_TIMESTAMP, Game.connectionManager.currentServerTime);
				
			//gameManager.clientDataManager.setValue(KEY_RATED_STARS, 0);
			//gameManager.clientDataManager.setValue(KEY_LAST_SHOW_TIMESTAMP, 0);
			//gameManager.clientDataManager.setValue(KEY_DAILY_BONUS_GET_COUNT, 0);
		}
		
		public function get isEnabled():Boolean
		{
			/*sosTrace("RateUsDialogManager.isEnabled(), isEnabledOnServer: ", isEnabledOnServer, "ratedStars: ", ratedStars,
			"disabledByTimeout: ", (lastShowTimeStamp != 0 && (Game.connectionManager.currentServerTime - lastShowTimeStamp < showInterval)), 
			"disabledByGamesCount: ", (Player.current.gamesCount < gamesCount),
			"isIOS, versions: ", PlatformServices.isIOS, ratedClientVersion, GameManager.instance.getVersionString(), SOSLog.INFO);*/
			
			if (!PlatformServices.isMobile || !isEnabledOnServer)
				return false;
				
			if (PlatformServices.isIOS) {
				if (ratedClientVersion == GameManager.instance.getVersionString())
					return false;
			}
			else if(ratedStars > 0) {
				return false;
			}	
			
			if (Player.current.gamesCount < gamesCount)
				return false;	
			
			//trace("last show interval: ", Game.connectionManager.currentServerTime - lastShowTimeStamp, "dailyBonusGetCount", dailyBonusGetCount);
			if (lastShowTimeStamp != 0 && (Game.connectionManager.currentServerTime - lastShowTimeStamp < showInterval))
				return false;
				
			return true;
		}
		
		public function get isEnabledSettingsDialogRateButton():Boolean
		{
			return PlatformServices.isMobile && isEnabledOnServer;
		}
		
		public function increaseDailyBonusGetCount():void
		{
			if (!isEnabled) 
				return;
			
			gameManager.clientDataManager.setValue(KEY_DAILY_BONUS_GET_COUNT, dailyBonusGetCount + 1);
			
			if (dailyBonusGetCount >= triggerDailyBonusCount)
				triggered = true;
		}
		
		public function triggerTourneyTopRank(rank:int):void
		{
			if (rank >= triggerTourneyTopRankValue)
				triggered = true;
		}
		
		public function checkTriggerBingosPerRound(count:int):Boolean
		{
			return count >= triggerBingosPerRoundCount;
		}
		
		public function showRateDialog(onCompleteShowDialog:Function = null, ignoreCheckIsEnabled:Boolean = false):void
		{
			this.onCompleteShowDialog = onCompleteShowDialog;
			
			if (!(isEnabled || ignoreCheckIsEnabled) || !triggered) {
				callOnComplete();
				return;
			}
			
			gameManager.clientDataManager.setValue(KEY_LAST_SHOW_TIMESTAMP, Game.connectionManager.currentServerTime);
				
			var dialog:RateUsDialog = new RateUsDialog(RateUsDialog.MODE_RATE);
			dialog.addEventListener(BaseDialog.DIALOG_REMOVED_EVENT, handler_dialogRemoved);
			DialogsManager.addDialog(dialog);
			
			triggered = false;
		}
		
		public function rate(startCount:int):void
		{
			gameManager.clientDataManager.setValue(KEY_RATED_STARS, startCount);
			gameManager.clientDataManager.setValue(KEY_RATED_CLIENT_VERSION, GameManager.instance.getVersionString());
		}
		
		public function getRateUsURL():String
		{
			switch(PlatformServices.platform)
			{
				case Platform.APPLE_APP_STORE:
					if (PlatformServices.getIOSMajorVersion() == 7)
					{
						return ios7RateUsURL;
					}
					return iosRateUsURL;
				case Platform.AMAZON_APP_STORE:
					return amazonRateUsURL;
				case Platform.GOOGLE_PLAY:
					return androidRateUsURL;
				default:
					return "";
			}
		}
		
		private function handler_dialogRemoved(e:Event):void 
		{
			callOnComplete();
		}
		
		private function callOnComplete():void {
			if (onCompleteShowDialog != null)
				onCompleteShowDialog();
				
			onCompleteShowDialog = null;	
		}
		
		private function get lastShowTimeStamp():Number {
			return gameManager.clientDataManager.getValue(KEY_LAST_SHOW_TIMESTAMP, 0);
		}
		
		private function get ratedStars():int {
			return int(gameManager.clientDataManager.getValue(KEY_RATED_STARS, 0));
		}
		
		private function get dailyBonusGetCount():int {
			return int(gameManager.clientDataManager.getValue(KEY_DAILY_BONUS_GET_COUNT, 0));
		}
		
		private function get ratedClientVersion():String {
			return String(gameManager.clientDataManager.getValue(KEY_RATED_CLIENT_VERSION, ''));
		}
		
	}
}
