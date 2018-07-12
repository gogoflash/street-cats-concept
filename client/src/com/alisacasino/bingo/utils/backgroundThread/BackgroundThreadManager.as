package com.alisacasino.bingo.utils.backgroundThread 
{
	import com.alisacasino.bingo.commands.ICommand;
	import flash.utils.getTimer;
	import starling.core.Starling;
	import starling.events.Event;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class BackgroundThreadManager 
	{
		private var normalPriorityQueue:BackgroundThreadQueue;
		private var lowPriorityQueue:BackgroundThreadQueue;
		private var timingPriorityQueue:BackgroundThreadQueue;
		
		private var timingPriorityQueueTimestamp:int;
		private var timingPriorityQueueInterval:int = 30;
		
		static public const PRIORITY_NORMAL:String = "priorityNormal";
		static public const PRIORITY_LOW:String = "priorityLow";
		
		static public const NORMAL_PRIORITY_PROCESSING_STEPS:int = 1;
		
		public static const BUDGET_INCREASED:Number = 10;
		public static const BUDGET_NORMAL:Number = 4;
		public static const BUDGET_MINIMAL:Number = 2;
		
		private const defaultOverrunCoefficent:Number = 3;
		private const defaultBackgroundExecutionCoefficent:Number = 0.2;
		
		private var budgetOverrun:Number = 0;
		private var maximumOverrun:Number = 0;
		private var currentBudgetBase:Number = BUDGET_NORMAL;
		
		public function BackgroundThreadManager() 
		{
			normalPriorityQueue = new BackgroundThreadQueue();
			lowPriorityQueue = new BackgroundThreadQueue();
			timingPriorityQueue = new BackgroundThreadQueue();
			setBudget(BUDGET_NORMAL);
		}
		
		public function addFunction(priority:String, func:Function, ...args):void
		{
			addFunctionWithArgumentList(priority, func, args);
		}
		
		public function addNormalPriorityFunction(func:Function, ...args):void 
		{
			addFunctionWithArgumentList(PRIORITY_NORMAL, func, args);
		}
		
		public function addTimingPriorityFunction(func:Function, ...args):void 
		{
			timingPriorityQueue.addFunctionWithArgumentList(func, args);
		}
		
		public function addFunctionWithArgumentList(priority:String, func:Function, argumentList:Array):void 
		{
			getQueueByPriority(priority).addFunctionWithArgumentList(func, argumentList);
		}
		
		private function getQueueByPriority(priority:String):BackgroundThreadQueue
		{
			if (priority == PRIORITY_LOW)
			{
				return lowPriorityQueue;
			}
			return normalPriorityQueue;
		}
		
		
		public function addCommand(priority:String, command:ICommand):void 
		{
			getQueueByPriority(priority).addCommand(command);
		}
		
		public function addNormalPriorityCommand(command:ICommand):void 
		{
			addCommand(PRIORITY_NORMAL, command);
		}
		
		public function initialize():void 
		{
			Starling.current.stage.addEventListener(Event.ENTER_FRAME, stage_enterFrameHandler);
		}
		
		public function setBudget(budget:Number, overrunCoefficent:Number = NaN):void 
		{
			//quick NaN check, just in case
			if (budget == budget)
			{
				currentBudgetBase = budget;
			}
			else
			{
				currentBudgetBase = BUDGET_NORMAL;
			}
			
			//NaN check
			if (overrunCoefficent == overrunCoefficent)
			{
				maximumOverrun = currentBudgetBase * overrunCoefficent;
			}
			else
			{
				maximumOverrun = currentBudgetBase * defaultOverrunCoefficent;
			}
		}
		
		public function setBudgetForBlockingLoad():void
		{
			setBudget(BUDGET_INCREASED, 0);
		}
		
		public function setNormalBudget():void 
		{
			setBudget(BUDGET_NORMAL, defaultOverrunCoefficent);
		}
		
		public function addBackgroundFunction(func:Function, ...args):void 
		{
			addFunctionWithArgumentList(PRIORITY_LOW, func, args);
		}
		
		private function stage_enterFrameHandler(e:Event):void 
		{
			if (normalPriorityQueue.length <= 0 && lowPriorityQueue.length <= 0 && timingPriorityQueue.length <= 0)
			{
				budgetOverrun = 0;
				return;
			}
			
			var budget:Number = currentBudgetBase - budgetOverrun;
			
			//Trying to prevent crashes, don't know if it matters, really
			var executeBackgroundQueue:Boolean = normalPriorityQueue.length <= 0;
			
			processQueue(normalPriorityQueue, budget, NORMAL_PRIORITY_PROCESSING_STEPS);
			
			
			
			if (budget > 0 && executeBackgroundQueue)
			{
				if (lowPriorityQueue.length > 0) {
					budget *= defaultBackgroundExecutionCoefficent;
					if (budget < 1)
						budget = 1;
					
					processQueue(lowPriorityQueue, budget, 1);
				}
				else if (getTimer() - timingPriorityQueueTimestamp > timingPriorityQueueInterval) {
					processQueue(timingPriorityQueue, budget, 1);
					timingPriorityQueueTimestamp = getTimer();
				}
			}
			
			budgetOverrun += -budget; //if budget was eaten up
			
			if (budgetOverrun > maximumOverrun) budgetOverrun = maximumOverrun;
			if (budgetOverrun < 0) budgetOverrun = 0;
		}
		
		/**
		 * 
		 * @param	queue
		 * @param	budget
		 * @param	maxProcessingSteps
		 * @return leftover budget
		 */
		private function processQueue(queue:BackgroundThreadQueue, budget:Number, maxProcessingSteps:int = -1):Number 
		{
			if (queue.length <= 0)
			{
				return budget;
			}
			
			var processingSteps:int = 0;
			
			var startTime:int = getTimer();
			var timeSpent:int = 0;
			while (timeSpent < budget)
			{
				queue.executeNext();
				timeSpent = getTimer() - startTime;
				processingSteps++;
				
				if (maxProcessingSteps > 0 && processingSteps >= maxProcessingSteps)
				{
					break;
				}
			}
			return budget - timeSpent;
		}
		
	}

}