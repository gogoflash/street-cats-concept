package com.alisacasino.bingo.models
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import starling.events.EventDispatcher;
	
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.SignInMessage.Platform;
	import com.alisacasino.bingo.protocol.StaticDataMessage;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.GameManager;
	import starling.events.Event;
	
	public class GameHintsManager extends EventDispatcher
	{
		public function GameHintsManager() {
			
		}
		
		public static const EVENT_CHANGE_ADD:String = "EVENT_GAME_HINTS_ADD";
		
		private var KEY_PURCHASED_DAUB_HINTS:String = "purchasedDaubHints";
		private var KEY_DAUB_HINT_USED_FOR_ROUND:String = "daubHintsUsedForRound";
		
		private var _isEnabledOnServer:Boolean = true; 		
		private var _freeDaubHintRounds:int; 					
		private var _hintPrice:int;  
		private var currentRoundCardsIdsHash:String = '';
		private var _purchasedDaubHintsFinished:Boolean;
		
		public function deserializeStaticData(staticData:StaticDataMessage):void
		{
			_isEnabledOnServer = staticData.daubHintsEnabled;
			_hintPrice = staticData.daubHintsPrice;
			_freeDaubHintRounds = staticData.freeDaubHintRounds;
			
			//gameManager.clientDataManager.setValue(KEY_DAILY_BONUS_GET_COUNT, 0);
		}
		
		public function get isEnabled():Boolean
		{
			//sosTrace("GameHintsManager.isEnabled()", purchasedDaubHint, Player.current.cardsIdsHash, gameManager.clientDataManager.getValue(KEY_DAUB_HINT_USED_FOR_ROUND, ''), SOSLog.INFO);
			//trace('s', purchasedDaubHint, Player.current.cardsIdsHash.toString(), gameManager.clientDataManager.getValue(KEY_DAUB_HINT_USED_FOR_ROUND, ''));
			if (!_isEnabledOnServer)
				return false;
				
			if (isEnabledForCurrentRound)
				return true;
			
			if (!Player.current)
				return false;	
				
			return Player.current.gamesCount < Math.max(freeDaubHintRounds, TutorialManager.TUTORIAL_HINTS_ROUNDS_COUNT) || purchasedDaubHint > 0;
		}
		
		public function get isEnabledForCurrentRound():Boolean
		{
			if (!Player.current)
				return false;
				
			return Player.current.cardsIdsHash != '' && Player.current.cardsIdsHash == currentRoundCardsIdsHash;//gameManager.clientDataManager.getValue(KEY_DAUB_HINT_USED_FOR_ROUND, '');
		}
		
		public function get isEnabledOnServer():Boolean
		{
			return _isEnabledOnServer;
		}
		
		public function get freeDaubHintRounds():int {
			return _freeDaubHintRounds;
		}
		
		public function get hintPrice():int {
			return _hintPrice;
		}
		
		public function get purchasedDaubHint():int
		{
			return gameManager.clientDataManager.getValue(KEY_PURCHASED_DAUB_HINTS, 0);
		}
		
		public function get purchasedDaubHintsFinished():Boolean
		{
			if (!_purchasedDaubHintsFinished) 
				return false;

			// сбрасывается после true
			_purchasedDaubHintsFinished = false;
			return true;
		}	
		
		public function get cellHintAlpha():Number 
		{
			if (Player.current.gamesCount <= TutorialManager.TUTORIAL_HINTS_ROUNDS_COUNT) {
				var alphaStep:Number = 1/(TutorialManager.TUTORIAL_HINTS_ROUNDS_COUNT - TutorialManager.TUTORIAL_HINTS_FULL_ALPHA_ROUNDS_COUNT);
				return 1 - (Player.current.gamesCount - TutorialManager.TUTORIAL_HINTS_FULL_ALPHA_ROUNDS_COUNT/* + 1*/) * alphaStep;
			}
			
			return 1;	
		}
		
		public function get cellAnimationRepeatCount():Number 
		{
			if (!gameManager.tutorialManager.tutorialFirstLevelPassed)
				return 0; // это значит повторять бесконечно
				
			return Math.max(1, 6 - 2*Player.current.gamesCount);
		}
		
		public function useDaubHint(gameId:String = ''):void
		{
			if ((gameManager.clientDataManager.getValue(KEY_PURCHASED_DAUB_HINTS, 0) <= 0) || (Player.current.gamesCount < freeDaubHintRounds))
				return;
			
			if (currentRoundCardsIdsHash == gameId)
				return;
				
			var newValue:int = Math.max(0, gameManager.clientDataManager.getValue(KEY_PURCHASED_DAUB_HINTS, 0) - 1);
			gameManager.clientDataManager.setValue(KEY_PURCHASED_DAUB_HINTS, newValue);
			
			_purchasedDaubHintsFinished = newValue == 0;
			
			currentRoundCardsIdsHash = gameId;
			
			gameManager.analyticsManager.sendCommodityAddedEvent(CommodityType.DAUB_ALERT, -1, "daubHintUse");
			//if(!(gameId == '' && gameManager.clientDataManager.setValue(KEY_DAUB_HINT_USED_FOR_ROUND, '') == ''))
				//gameManager.clientDataManager.setValue(KEY_DAUB_HINT_USED_FOR_ROUND, gameId);
		}
		
		public function purchase(count:int):Boolean
		{
			if (count <= 0)
				return false;
			
			if (Player.current.cashCount < (count*hintPrice))
			{
				return false;
			}
			
			Player.current.updateCashCount(-count*hintPrice, "daubAlertBuy");	
			gameManager.clientDataManager.setValue(KEY_PURCHASED_DAUB_HINTS, gameManager.clientDataManager.getValue(KEY_PURCHASED_DAUB_HINTS, 0) + count);
			Game.connectionManager.sendPlayerUpdateMessage();
			
			gameManager.analyticsManager.sendCommodityAddedEvent(CommodityType.DAUB_ALERT, count, "daubAlertBuy");
			
//			Game.current.currentScreen.cashBar.animateToValue(Player.current.cashCount);
			
			return true;
		}
		
		public function add(count:int):void
		{
			gameManager.clientDataManager.setValue(KEY_PURCHASED_DAUB_HINTS, gameManager.clientDataManager.getValue(KEY_PURCHASED_DAUB_HINTS, 0) + count);
			gameManager.analyticsManager.sendCommodityAddedEvent(CommodityType.DAUB_ALERT, count, "daubAlertBuy");
			dispatchEventWith(EVENT_CHANGE_ADD, false, count);
		}
	}
}
