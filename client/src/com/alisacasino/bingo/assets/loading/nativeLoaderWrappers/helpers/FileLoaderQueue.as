package com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.helpers 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.net.FileReference;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class FileLoaderQueue
	{
		private var currentRequest:LoadRequest;
		private var loadQueue:Vector.<LoadRequest>;
		
		public function FileLoaderQueue() 
		{
			loadQueue = new Vector.<LoadRequest>();
		}
		
		public function loadFile(contentRoot:FileReference, uri:String, onFileLoaded:Function , onFileFailed:Function):void 
		{
			loadQueue.push(new LoadRequest(contentRoot, uri, onFileLoaded, onFileFailed));
			
			scheduleLoadQueueCheck();
		}
		
		private function checkLoadQueue():void
		{
			if (!currentRequest && loadQueue.length > 0)
			{
				processLoadRequest(loadQueue.shift());
			}
		}
		
		private function processLoadRequest(loadRequest:LoadRequest):void
		{
			sosTrace( "FileLoaderQueue.processLoadRequest > loadRequest : " + loadRequest );
			currentRequest = loadRequest;
			var contentRoot:File = loadRequest.contentRoot as File;
			var file:File = contentRoot.resolvePath(loadRequest.uri);
			if (!file.exists)
			{
				sosTrace("Could not find file " + file.nativePath, SOSLog.ERROR);
				processCurrentRequestFail();
			}
			else 
			{
				file.addEventListener(Event.COMPLETE, file_completeHandler);
				file.addEventListener(IOErrorEvent.IO_ERROR, file_ioErrorHandler);
				file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, file_securityErrorHandler);
				file.load();
			}
		}
		
		private function processCurrentRequestFail():void 
		{
			if (!currentRequest)
			{
				sosTrace( "No currentRequest, fail called ", SOSLog.ERROR);
				return;
			}
			if (currentRequest.onFileFailed != null)
			{
				currentRequest.onFileFailed();
			}
			currentRequest = null;
			scheduleLoadQueueCheck();
		}
		
		private function scheduleLoadQueueCheck():void 
		{
			gameManager.backgroundThreadManager.addNormalPriorityFunction(checkLoadQueue);
		}
		
		private function file_securityErrorHandler(e:SecurityErrorEvent):void 
		{
			stripListeners(e.target as EventDispatcher);
			processCurrentRequestFail();
		}
		
		private function stripListeners(eventDispatcher:EventDispatcher):void 
		{
			eventDispatcher.removeEventListener(Event.COMPLETE, file_completeHandler);
			eventDispatcher.removeEventListener(IOErrorEvent.IO_ERROR, file_ioErrorHandler);
			eventDispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, file_securityErrorHandler);
		}
		
		private function file_ioErrorHandler(e:IOErrorEvent):void 
		{
			stripListeners(e.target as EventDispatcher);
			processCurrentRequestFail();
		}
		
		private function file_completeHandler(e:Event):void 
		{
			stripListeners(e.target as EventDispatcher);
			processCurrentRequestComplete(e.target as File);
		}
		
		private function processCurrentRequestComplete(file:File):void 
		{
			if (!currentRequest)
			{
				sosTrace( "No currentRequest, completet called ", SOSLog.ERROR);
				return;
			}
			if (currentRequest.onFileLoaded != null)
			{
				currentRequest.onFileLoaded(file);
			}
			else
			{
				sosTrace( "No complete callback for " + currentRequest.uri, SOSLog.ERROR);
			}
			currentRequest = null;
			scheduleLoadQueueCheck();
		}
		
	}

}
import flash.net.FileReference;

class LoadRequest
{
	public var contentRoot:FileReference;
	public var uri:String;
	public var onFileFailed:Function;
	public var onFileLoaded:Function;
	public function LoadRequest(contentRoot:FileReference, uri:String, onFileLoaded:Function , onFileFailed:Function) 
	{
		super();
		this.onFileLoaded = onFileLoaded;
		this.onFileFailed = onFileFailed;
		this.uri = uri;
		this.contentRoot = contentRoot;
	}
	
	public function toString():String 
	{
		return "[LoadRequest uri=" + uri + "]";
	}
}