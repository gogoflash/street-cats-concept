package com.alisacasino.bingo.commands.serviceClasses 
{
	import com.alisacasino.bingo.commands.ICommand;
	import com.alisacasino.bingo.commands.ICommandSet;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CommandSet extends CommandBase implements ICommandSet
	{
		protected var setToExecute:Vector.<ICommand>;
		protected var setStopped:Boolean;
		
		public function CommandSet() 
		{
			setToExecute = new Vector.<ICommand>();
		}
		
		public function addCommandToSet(command:ICommand):ICommandSet
		{
			if (finished || failed || running)
			{
				sosTrace("Adding command finished or running set " + this.toString(), SOSLog.WARNING);
			}
			setToExecute.push(command);
			return this;
		}
		
		protected function checkIfFinished():void
		{
			var everyCommandFinished:Boolean = true;
			var someCommandFailed:Boolean = false;
			
			var completedItems:int = 0;
			
			//TODO: Better logic up in this part
			for each (var item:ICommand in setToExecute) 
			{
				sosTrace( getQualifiedClassName(item) + ".failed : " + item.failed );
				if (item.failed)
				{
					if (!item.finishOnFail)
					{
						someCommandFailed = true;
						everyCommandFinished = false;
					}
					else
					{
						completedItems++;
					}
				}
				else if (!item.finished)
				{
					everyCommandFinished = false;
				}
				else
				{
					completedItems++;
				}
			}
			
			if (someCommandFailed)
			{
				if (!finishOnFail)
				{
					stopFurtherExecution();
					fail();
				}
			}
			
			if (setToExecute.length > 0)
			{
				updateProgress(completedItems / setToExecute.length);
			}
			
			if (everyCommandFinished)
			{
				finish();
			}
		}
		
		protected function executeCommandInSet(item:ICommand):Boolean 
		{
			if (setStopped)
			{
				return false;
			}
			
			if (item.finished || item.failed || item.running)
			{
				return false;
			}
			
			item.execute(setElementFinishCallback, setElementFailCallback);
			
			return true;
		}
		
		private function setElementFailCallback():void 
		{
			checkIfFinished();
		}
		
		protected function setElementFinishCallback(command:ICommand):void 
		{
			checkIfFinished();
		}
		
		protected function stopFurtherExecution():void 
		{
			setStopped = true;
		}
		
		override protected function stopInternal():void 
		{
			super.stopInternal();
			stopFurtherExecution();
			for each (var item:ICommand in setToExecute) 
			{
				item.stop();
			}
		}
		
	}

}