package com.alisacasino.bingo.utils 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAEvent;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNALoadingTimingEvent;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAUIInteractionEvent;
	import com.alisacasino.bingo.utils.analytics.events.LoadingStateEvent;
	import flash.events.Event;
	import flash.utils.getTimer;
	import starling.events.EnterFrameEvent;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class LoadingWatchdog 
	{
		
		private var lastLoggedSecondOfLoading:int = 0;
		private var game:Game;
		private var loadEndTime:int;
		private var queue:Array;
		
		public function LoadingWatchdog() 
		{
			queue = [];
		}
		
		public function initialize(game:Game):void 
		{
			this.game = game;
			game.addEventListener(EnterFrameEvent.ENTER_FRAME, game_enterFrameHandler);
			
		}
		
		private function game_enterFrameHandler(e:EnterFrameEvent):void 
		{
			if (!gameManager.deactivated)
			{
				logActiveLoading(int(getTimer() / 1000));
			}
		}
		
		private function logActiveLoading(toTime:int):void 
		{
			while (toTime > lastLoggedSecondOfLoading)
			{
				lastLoggedSecondOfLoading++;
				logLoadingSecondToDDNA(lastLoggedSecondOfLoading);
			}
		}
		
		private function logLoadingSecondToDDNA(lastLoggedSecondOfLoading:int):void 
		{
			if (!Player.current)
			{
				queue.push(lastLoggedSecondOfLoading);
				return;
			}
			
			while(queue.length)
			{
				gameManager.analyticsManager.deltaDNAAnalytics.sendEvent(new DDNALoadingTimingEvent(queue.shift()));
			}
			gameManager.analyticsManager.deltaDNAAnalytics.sendEvent(new DDNALoadingTimingEvent(lastLoggedSecondOfLoading));
		}
		
		public function transitionedFromLoadingScreen():void 
		{
			gameManager.analyticsManager.sendEvent(new LoadingStateEvent(LoadingStateEvent.SCREEN_SHOWN));
			if (game)
			{
				game.removeEventListener(EnterFrameEvent.ENTER_FRAME, game_enterFrameHandler);
			}
			loadEndTime = int(getTimer() / 1000);
			if (gameManager.deactivated)
			{
				PlatformServices.interceptor.addNativeEventListener(Event.ACTIVATE, onActivateAfterLoading);
			}
			else
			{
				sendDDNAGameLoadedEvent();
				logActiveLoading(loadEndTime);
			}
		}
		
		private function sendDDNAGameLoadedEvent():void 
		{
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAUIInteractionEvent(DDNAUIInteractionEvent.ACTION_LOADED, DDNAUIInteractionEvent.LOCATION_GLOBAL, "gameScreen", DDNAUIInteractionEvent.TYPE_SCREEN));
		}
		
		private function onActivateAfterLoading(e:flash.events.Event):void 
		{
			sendDDNAGameLoadedEvent();
			logActiveLoading(loadEndTime);
		}
	}

}