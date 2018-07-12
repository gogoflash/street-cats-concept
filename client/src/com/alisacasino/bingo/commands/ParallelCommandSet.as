package com.alisacasino.bingo.commands 
{
	import com.alisacasino.bingo.commands.serviceClasses.CommandSet;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ParallelCommandSet extends CommandSet
	{
		
		override protected function startExecution():void 
		{
			for each (var item:ICommand in setToExecute)
			{
				executeCommandInSet(item);
			}
		}
		
		
	}

}