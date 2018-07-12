package com.alisacasino.bingo.utils.backgroundThread 
{
	import com.alisacasino.bingo.commands.ICommand;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class BackgroundThreadQueue 
	{
		private var queue:Array;
		
		private var functionCallPool:Vector.<FunctionCall>;
		
		public function BackgroundThreadQueue() 
		{
			queue = [];
			functionCallPool = new Vector.<FunctionCall>();
		}
		
		public function addCommand(command:ICommand):void
		{
			queue.push(command);
		}
		
		public function addFunction(func:Function, ...args):void
		{
			addFunctionWithArgumentList(func, args);
		}
		
		public function addFunctionWithArgumentList(func:Function, argumentList:Array):void
		{
			queue.push(getFunctionCall().updateWithArgs(func, argumentList));
		}
		
		public function get length():uint 
		{
			return queue.length;
		}
		
		private function getFunctionCall():FunctionCall
		{
			if (functionCallPool.length > 0)
			{
				return functionCallPool.pop();
			}
			return new FunctionCall();
		}
		
		public function executeNext():void
		{
			//sosTrace( "BackgroundThreadQueue.executeNext", SOSLog.DEBUG);
			if (queue.length > 0)
			{
				var nextItemToExecute:* = queue.shift();
				executeItem(nextItemToExecute);
			}
		}
		
		[Inline]
		final private function executeItem(item:*):void 
		{
			if (item is FunctionCall)
			{
				executeFunctionCall(item as FunctionCall);
			}
			else if (item is ICommand)
			{
				executeCommand(item as ICommand);
			}
		}
		
		private function executeCommand(command:ICommand):void 
		{
			command.execute();
		}
		
		private function executeFunctionCall(functionCall:FunctionCall):void 
		{
			if (functionCall.func == null)
			{
				putToPool(functionCall);
				return;
			}
			functionCall.func.apply(null, functionCall.args);
			putToPool(functionCall);
			
		}
		
		private function putToPool(functionCall:FunctionCall):void 
		{
			functionCall.updateWithArgs(null, null);
			functionCallPool.push(functionCall);
		}
		
	}

}