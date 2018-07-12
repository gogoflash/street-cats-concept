package com.alisacasino.bingo.utils.graphics
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.screens.LoadingScreen;
	import flash.utils.getTimer;
	import starling.display.DisplayObject;
	import starling.events.EnterFrameEvent;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class FramerateWatchdog
	{
		private var sampleStart:int;
		private var framesInSample:int;
		private var lowFramerateSamples:int;
		private var game:Game;
		static public const SAMPLE_PERIOD_SECONDS:Number = 1;
		static public const MIN_FRAMERATE:Number = 55;
		static public const LOW_FRAMERATE_SAMPLE_THRESHOLD:Number = 5;
		
		
		public function FramerateWatchdog()
		{
			
		}
		
		public function initialize(game:Game):void
		{
			this.game = game;
			sampleStart = getTimer();
			lowFramerateSamples = 0;
			framesInSample = 0;
			game.addEventListener(EnterFrameEvent.ENTER_FRAME, game_enterFrameHandler);
		}
		
		private function game_enterFrameHandler(e:EnterFrameEvent):void
		{
			framesInSample += 1;
			
			var sampleTimeMs:int = getTimer() - sampleStart;
			
			if (sampleTimeMs > SAMPLE_PERIOD_SECONDS * 1000)
			{
				sampleStart = sampleStart + SAMPLE_PERIOD_SECONDS * 1000;
				
				if (gameManager.deactivated || game.currentScreen is LoadingScreen)
				{
					return;
				}
				
				//sosTrace( "framesInSample : " + framesInSample);
				if (framesInSample * 1 / SAMPLE_PERIOD_SECONDS < MIN_FRAMERATE)
				{
					
					lowFramerateSamples += 1;
					//sosTrace( "lowFramerateSamples : " + lowFramerateSamples);
					if (lowFramerateSamples > LOW_FRAMERATE_SAMPLE_THRESHOLD)
					{
						disableFiltersAndStopWatching();
					}
				}
				else
				{
					lowFramerateSamples = 0;
				}
				framesInSample = 0;
			}
		}
		
		private function disableFiltersAndStopWatching():void 
		{
			//sosTrace( "FramerateWatchdog.disableFiltersAndStopWatching");
			DisplayObject.optionalFiltersDisabled = true;
			if (game)
			{
				game.removeEventListener(EnterFrameEvent.ENTER_FRAME, game_enterFrameHandler);
			}
		}
	
	}

}