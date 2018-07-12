package com.alisacasino.bingo.commands 
{
	import com.alisacasino.bingo.commands.serviceClasses.CommandSet;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class SequentialCommandSet extends CommandSet implements ICommandSet
	{
		private var currentCommandIndex:int;
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			currentCommandIndex = 0;
			executeNextCommand();
		}
		
		private function executeNextCommand():void 
		{
			while (true)
			{
				if (currentCommandIndex >= setToExecute.length)
				{
					checkIfFinished();
					return;
				}
				
				var commandToExecute:ICommand = setToExecute[currentCommandIndex];
				currentCommandIndex++;
				if (executeCommandInSet(commandToExecute))
				{
					break;
				}
			}
		}
		
		override protected function setElementFinishCallback(command:ICommand):void 
		{
			super.setElementFinishCallback(command);
			executeNextCommand();
		}
		
	}

}