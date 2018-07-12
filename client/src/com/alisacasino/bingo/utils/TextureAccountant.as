package com.alisacasino.bingo.utils 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class TextureAccountant 
	{
		private static var quantityByStackTrace:Object = {};
		
		private static var storedState:Object;
		
		private static var pixelMasks:Dictionary = new Dictionary();
		
		public function TextureAccountant() 
		{
			
		}
		
		static public function storeState():void
		{
			storedState = {};
			for (var name:String in quantityByStackTrace) 
			{
				storedState[name] = quantityByStackTrace[name];
			}
		}
		
		static public function printCreatedAndUncollected():void
		{
			if (!storedState)
			{
				return;
			}
			
			for (var name:String in quantityByStackTrace) 
			{
				var currentValue:int = quantityByStackTrace[name];
				var oldValue:int = storedState.hasOwnProperty(name) ? storedState[name] : 0;
				if (currentValue > oldValue)
				{
					sosTrace(int(currentValue - oldValue).toString() + " new instances with stack trace of " + name);
				}
			}
		}
		
		static public function registerCreation(stackTrace:String):void 
		{
			if (quantityByStackTrace.hasOwnProperty(stackTrace))
			{
				quantityByStackTrace[stackTrace]++;
			}
			else
			{
				quantityByStackTrace[stackTrace] = 1;
			}
		}
		
		static public function registerRemoval(stackTraceSignature:String):void 
		{
			if (quantityByStackTrace.hasOwnProperty(stackTraceSignature))
			{
				if (quantityByStackTrace[stackTraceSignature] > 0)
				{
					quantityByStackTrace[stackTraceSignature]--;
					return;
				}
			}
			
			sosTrace("Weird shit happens yo");
		}
		
	}

}