package com.alisacasino.bingo.utils.backgroundThread 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	internal class FunctionCall
	{
		public var func:Function;
		public var args:Array;
		
		public function FunctionCall() 
		{
		}
		
		public function updateWithArgs(func:Function, args:Array = null):FunctionCall
		{
			this.func = func;
			this.args = args;
			return this;
		}
		
	}

}