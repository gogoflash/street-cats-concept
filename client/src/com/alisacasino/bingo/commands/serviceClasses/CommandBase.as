package com.alisacasino.bingo.commands.serviceClasses
{
	import avmplus.getQualifiedClassName;
	import com.alisacasino.bingo.commands.ICommand;
	import com.alisacasino.bingo.utils.misc.CallbackContainer;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CommandBase implements ICommand
	{
		public var warnOnStop:Boolean = true;
		
		private var _failed:Boolean;
		private var _finishOnFail:Boolean = false;
		private var _finished:Boolean = false;
		
		private var _running:Boolean;
		private var _stopped:Boolean;
		
		public function get stopped():Boolean 
		{
			return _stopped;
		}

		private var _progress:Number = 0.;
		
		public function get progress():Number 
		{
			return _progress;
		}
		
		protected var _completeCallbackContainer:CallbackContainer;
		protected function get completeCallbackContainer():CallbackContainer
		{
			if (_completeCallbackContainer == null) _completeCallbackContainer = new CallbackContainer; 
			return _completeCallbackContainer;
		}
		
		protected var _errorCallbackContainer:CallbackContainer;
		protected function get errorCallbackContainer():CallbackContainer
		{
			if (_errorCallbackContainer == null) _errorCallbackContainer = new CallbackContainer; 
			return _errorCallbackContainer;
		}
		
		protected var _progressCallbackContainer:CallbackContainer;
		protected function get progressCallbackContainer():CallbackContainer
		{
			if (_progressCallbackContainer == null) _progressCallbackContainer = new CallbackContainer; 
			return _progressCallbackContainer;
		}
		
		public function CommandBase()
		{
		}
		
		/**
		 * Starts command execution. To add business logic, override startExecution method
		 * @param	completeCallback called on success, tries to pass this command as an argument, can call 0-argument functions
		 * @param	errorCallback called if command cannot be fully executed, tries to pass this command as an argument, can call 0-argument functions
		 * @return self
		 */
		final public function execute(completeCallback:Function = null, errorCallback:Function = null):ICommand
		{
			if (finished || failed || running)
			{
				sosTrace("Calling execute on finished or running command " + this.toString(), SOSLog.WARNING);
			}
			_running = true;
			addCompleteCallback(completeCallback);
			addErrorCallback(errorCallback);
			startExecution();
			return this;
		}
		
		protected function startExecution():void 
		{
			
		}
		
		public function addCompleteCallback(callback:Function):ICommand
		{
			if (callback != null)
			{
				if (failed)
				{
					sosTrace("Adding complete callback on failed command " + this, SOSLog.WARNING);
					if(finishOnFail)
						completeCallbackContainer.executeCallback(callback, this);
				}
				else if (!finished)
				{
					completeCallbackContainer.addCallback(callback);
				}
				else
				{
					sosTrace("Adding complete callback on finished command " + this, SOSLog.WARNING);
					completeCallbackContainer.executeCallback(callback, this);
				}
			}
			return this;
		}
		
		public function removeCompleteCallback(callback:Function):ICommand
		{
			if (callback != null)
			{
				if(_completeCallbackContainer)
					completeCallbackContainer.removeCallback(callback);
			}
			return this;
		}
		
		public function addErrorCallback(callback:Function):ICommand
		{
			if (callback != null)
			{
				if (failed)
				{
					sosTrace("Adding error callback on failed command " + this, SOSLog.WARNING);
					errorCallbackContainer.executeCallback(callback, this);
				}
				else if (!finished)
				{
					errorCallbackContainer.addCallback(callback);
				}
				else
				{
					sosTrace("Adding error callback on finished command " + this, SOSLog.WARNING);
				}
			}
			return this;
		}
		
		public function removeErrorCallback(callback:Function):ICommand
		{
			if (callback != null)
			{
				if(_errorCallbackContainer)
					errorCallbackContainer.removeCallback(callback);
			}
			return this;
		}
		
		/**
		 * @param	callback  expected to accept command and progress number
		 * @return
		 */
		public function addProgressCallback(callback:Function):ICommand
		{
			if (failed)
			{
				sosTrace("Adding complete callback on failed command " + this, SOSLog.WARNING);
				progressCallbackContainer.executeCallback(callback, this, progress);
			}
			else if (!finished)
			{
				progressCallbackContainer.addCallback(callback);
			}
			else
			{
				sosTrace("Adding complete callback on finished command " + this, SOSLog.WARNING);
				progressCallbackContainer.executeCallback(callback, this, progress);
			}
			return this;
		}
		
		public function removeProgressCallback(callback:Function):ICommand
		{
			if (callback != null)
			{
				if(_progressCallbackContainer)
					progressCallbackContainer.removeCallback(callback);
			}
			return this;
		}
		
		protected function fail():void
		{
			_running = false;
			_failed = true;
			
			errorCallbackContainer.executeAndClearAllCallbacks(this);
			
			if (finishOnFail)
			{
				sosTrace("Command " + this.toString() + " failed, but will finish.", SOSLog.WARNING);
				finish();
			}
			else
			{
				sosTrace("Command " + this.toString() + " failed, and never finish", SOSLog.ERROR);
			}
		}
		
		public function toString():String
		{
			return "[" + getQualifiedClassName(this) + " finished=" + finished + "]";
		}
		
		public final function stop():void 
		{
			if (warnOnStop)
			{
				sosTrace( "Command " + getQualifiedClassName(this) + " stopped", SOSLog.WARNING);
			}
			
			if (!_running)
			{
				sosTrace( "Command " + getQualifiedClassName(this) + " stopped when not running", SOSLog.WARNING);
			}
			
			clearAllCallbacks();
			
			_running = false;
			_stopped = true;
			
			stopInternal();
		}
		
		protected function stopInternal():void 
		{
			
		}
		
		protected function finish():void
		{
			_running = false;
			_finished = true;
			errorCallbackContainer.clear();
			
			updateProgress(1.);
			
			if(_completeCallbackContainer)
				completeCallbackContainer.executeAndClearAllCallbacks(this);
				
			clearAllCallbacks();
		}
		
		private function clearAllCallbacks():void 
		{
			if(_completeCallbackContainer)
				completeCallbackContainer.clear();
			
			if(_errorCallbackContainer)	
				errorCallbackContainer.clear();
			
			if (_progressCallbackContainer)
				_progressCallbackContainer.clear();
		}
		
		protected function updateProgress(value:Number = 0.):void
		{
			_progress = value;
			doProgressCallbacks();
		}
		
		private function doProgressCallbacks():void 
		{
			if(_progressCallbackContainer)
				progressCallbackContainer.executeAllCallbacks(this, _progress);
		}
		
		public function get finished():Boolean
		{
			return _finished;
		}
		
		public function get finishOnFail():Boolean
		{
			return _finishOnFail;
		}
		
		public function set finishOnFail(value:Boolean):void
		{
			_finishOnFail = value;
			if (finishOnFail && failed)
			{
				sosTrace("Finish on fail set after failure. Finishing up and doing callbacks.", SOSLog.WARNING);
				finish();
			}
		}
		
		public function get failed():Boolean
		{
			return _failed;
		}
		
		public function get running():Boolean 
		{
			return _running;
		}
	
	}

}