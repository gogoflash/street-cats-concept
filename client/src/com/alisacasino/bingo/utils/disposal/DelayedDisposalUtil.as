package com.alisacasino.bingo.utils.disposal 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.utils.GameManager;
	import starling.events.Event;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DelayedDisposalUtil 
	{
		private static var _instance:DelayedDisposalUtil;
		
		public static function get instance():DelayedDisposalUtil
		{
			if (!_instance)
			{
				_instance = new DelayedDisposalUtil;
			}
			return _instance;
		}
		
		private var disposeQueue:Vector.<IDisposable>;
		
		public function DelayedDisposalUtil() 
		{
			disposeQueue = new Vector.<IDisposable>();
			Game.addEventListener(Game.ACTIVATED, game_activatedHandler);
		}
		
		public function dispose(item:IDisposable):void
		{
			if (PlatformServices.isIOS && GameManager.instance.deactivated)
			{
				disposeQueue.push(item);
			}
			else 
			{
				item.dispose();
			}
		}
		
		private function game_activatedHandler(e:Event):void 
		{
			while (disposeQueue.length)
			{
				disposeQueue.pop().dispose();
			}
		}
		
	}

}