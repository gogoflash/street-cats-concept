package com.alisacasino.bingo.utils.misc 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CallbackContainer 
	{
		private var _callbackList:Vector.<Function>;
		
		public function CallbackContainer() 
		{
			
		}
		
		public function addCallback(callback:Function):void
		{
			if (callback != null)
			{
				if (callbackList.indexOf(callback) == -1)
				{
					callbackList.push(callback);
				}
			}
		}
		
		public function removeCallback(callback:Function):void
		{
			if (_callbackList)
			{
				var callbackIndex:int = callbackList.indexOf(callback);
				if (callbackIndex != -1)
				{
					callbackList.splice(callbackIndex, 1);
				}
			}
		}
		
		private function get callbackList():Vector.<Function>
		{
			if (!_callbackList)
			{
				_callbackList = new Vector.<Function>();
			}
			return _callbackList;
		}
		
		public function hasCallback(callback:Function):Boolean
		{
			return callbackList.indexOf(callback) != -1;
		}
		
		public function executeAllCallbacks(...args):void
		{
			if (_callbackList)
			{
				for each (var callbackFunction:Function in callbackList) 
				{
					executeCallbackInternal(callbackFunction, args);
				}
			}
		}
		
		public function executeAndClearAllCallbacks(...args):void
		{
			if (_callbackList)
			{
				while (callbackList.length)
				{
					var callbackFunction:Function = callbackList.pop();
					executeCallbackInternal(callbackFunction, args);
				}
			}
		}
		
		public function executeCallback(callbackFunction:Function, ...args):void
		{
			executeCallbackInternal(callbackFunction, args);
		}
		
		[Inline]
		final private function executeCallbackInternal(callbackFunction:Function, argumentArray:Array):void
		{
			if (callbackFunction.length == 0)
			{
				callbackFunction.call();
			}
			else if (callbackFunction.length == argumentArray.length)
			{
				callbackFunction.apply(null, argumentArray);
			}
			else 
			{
				throw new Error("Callback argument number mismatch");
			}
		}
		
		public function clear():void 
		{
			if (_callbackList)
			{
				_callbackList.length = 0;
			}
		}
		
	}

}