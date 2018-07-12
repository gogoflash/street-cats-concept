package com.alisacasino.bingo.utils.misc 
{
	import avmplus.getQualifiedClassName;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class FunctionCallData 
	{
		public var functionName:String;
		public var functionArguments:Array;
		
		public function FunctionCallData(functionName:String, functionArguments:Array) 
		{
			this.functionName = functionName;
			this.functionArguments = functionArguments;
		}
		
		public function callOnTarget(target:Object):void
		{
			if (!target.hasOwnProperty(functionName))
			{
				throw new Error("No function " + functionName + " on target " + getQualifiedClassName(target), SOSLog.ERROR);
				return;
			}
			
			var functionToCall:Function = target[functionName];
			functionToCall.apply(target, functionArguments);
		}
		
		[Inline]
		public static function callFunctionOnTarget(target:Object, functionName:String, args:Array):void
		{
			if (!target.hasOwnProperty(functionName))
			{
				throw new Error("No function " + functionName + " on target " + getQualifiedClassName(target), SOSLog.ERROR);
				return;
			}
			
			var functionToCall:Function = target[functionName];
			functionToCall.apply(target, args);	
		}
		
	}

}