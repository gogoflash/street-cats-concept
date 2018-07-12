package com.alisacasino.bingo.assets.loading.nativeLoaderWrappers
{
	import avmplus.getQualifiedClassName;
	import com.alisacasino.bingo.utils.misc.CallbackContainer;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	internal class LoaderWrapperBase implements ILoaderWrapper
	{
		private var uri:String;
		
		public function getURI():String
		{
			return uri;
		}
		
		protected var _disposed:Boolean;
		
		public function get disposed():Boolean 
		{
			return _disposed;
		}
		
		private var _completeCallbackContainer:CallbackContainer;
		private var _errorCallbackContainer:CallbackContainer;
		private var _loadType:String;
		private var _randomizeResID:Boolean;
		
		private var _retryCount:int = 0;
		
		public function get retryCount():int 
		{
			return _retryCount;
		}
		
		public function set retryCount(value:int):void 
		{
			_retryCount = value;
		}
		
		public function LoaderWrapperBase()
		{
		}
		
		public function load(uri:String, callback:Function = null, errorCallback:Function = null):void
		{
			this.uri = uri;
			completeCallbackContainer.addCallback(callback);
			errorCallbackContainer.addCallback(errorCallback);
		}
		
		protected function complete():void
		{
			errorCallbackContainer.clear();
			completeCallbackContainer.executeAndClearAllCallbacks(this);
		}
		
		protected function fail():void
		{
			sosTrace(getQualifiedClassName(this) + ".fail", SOSLog.WARNING);
			completeCallbackContainer.clear();
			errorCallbackContainer.executeAndClearAllCallbacks(this);
		}
		
		public function dispose():void
		{
			if (_completeCallbackContainer)
			{
				_completeCallbackContainer.clear();
				_completeCallbackContainer = null;
			}
			
			if (_errorCallbackContainer)
			{
				_errorCallbackContainer.clear();
				_errorCallbackContainer = null;
			}
			
			_disposed = true;
		}
		
		public function addCompleteCallback(callback:Function):ILoaderWrapper
		{
			completeCallbackContainer.addCallback(callback);
			return this;
		}
		
		public function addErrorCallback(callback:Function):ILoaderWrapper
		{
			errorCallbackContainer.addCallback(callback);
			return this;
		}
		
		public function get progress():Number 
		{
			return 0;
		}
		
		public function get transferRate():Number 
		{
			return -1;
		}
		
		public function get shouldCache():Boolean 
		{
			return false;
		}
		
		public function set randomizeResID(value:Boolean):void 
		{
			_randomizeResID = value;
		}
		
		public function get randomizeResID():Boolean 
		{
			return _randomizeResID;
		}
		
		public function set loadType(value:String):void 
		{
			_loadType = value;
		}
		
		public function get loadType():String 
		{
			return _loadType;
		}
		
		public function get completeCallbackContainer():CallbackContainer 
		{
			if (!_completeCallbackContainer)
			{
				_completeCallbackContainer = new CallbackContainer();
			}
			return _completeCallbackContainer;
		}
		
		public function get errorCallbackContainer():CallbackContainer 
		{
			if (!_errorCallbackContainer)
			{
				_errorCallbackContainer = new CallbackContainer();
			}
			return _errorCallbackContainer;
		}
		
		// see flash.system.Worker
		public function get useWorker():Boolean 
		{
			return false;
		}
	
	}

}