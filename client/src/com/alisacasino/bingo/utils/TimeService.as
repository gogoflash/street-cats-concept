package com.alisacasino.bingo.utils 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.utils.misc.CallbackContainer;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class TimeService 
	{
		private var oneSecondTimer:Timer;
		private var oneSecondCallbackContainer:CallbackContainer;
		
		private static var _instance:TimeService;
		
		public static function get instance():TimeService
		{
			if (!_instance)
			{
				_instance = new TimeService();
			}
			
			return _instance;
		}
		
		public static function get serverTimeMs():Number
		{
			return instance.serverTimeMs;
		}
		
		public static function get serverTime():uint
		{
			return Math.ceil(instance.serverTimeMs/1000);
		}
		
		public function get serverTimeMs():Number
		{
			var result:Number;
			if (Game.current)
			{
				result = Game.connectionManager.currentServerTime;
			}
			if (result !== result)
			{
				sosTrace("Time is NaN", SOSLog.ERROR);
				result = new Date().getTime();
			}
			return result;
		}
		
		public function TimeService() 
		{
			oneSecondTimer = new Timer(1000);		
			oneSecondTimer.addEventListener(TimerEvent.TIMER, oneSecondTimer_timerHandler);
			oneSecondTimer.start();
			
			oneSecondCallbackContainer = new CallbackContainer();
		}
		
		public function pause():void
		{
			oneSecondTimer.stop();
		}
		
		public function resume():void
		{
			oneSecondTimer.start();
		}
		
		private function oneSecondTimer_timerHandler(e:TimerEvent):void 
		{
			oneSecondCallbackContainer.executeAllCallbacks(e);
		}
		
		public static function addOneSecondCallback(callback:Function):void
		{
			instance.addOneSecondCallback(callback);
		}
		
		static public function removeOneSecondCallback(callback:Function):void 
		{
			instance.removeOneSecondCallback(callback);
		}
		
		static public function hasOneSecondCallback(callback:Function):Boolean
		{
			return instance.oneSecondCallbackContainer.hasCallback(callback);
		}
		
		public function removeOneSecondCallback(callback:Function):void 
		{
			oneSecondCallbackContainer.removeCallback(callback);
		}
		
		public function addOneSecondCallback(callback:Function):void 
		{
			oneSecondCallbackContainer.addCallback(callback);
		}
		
	}

}