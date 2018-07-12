package	com.alisacasino.bingo.utils
{
	import com.alisacasino.bingo.utils.backgroundThread.BackgroundThreadManager;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.OutputProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class InternalStorageAPI
	{
		private static var callbackByFileReference:Dictionary = new Dictionary(true);
		
		private static var saveQueue:Array = [];
		private static var currentRequest:SaveRequest;
		private static var currentFileStream:FileStream
		
		public static function saveFile(path:String, data:ByteArray, onCacheSaved:Function = null):void 
		{
			saveQueue.push(new SaveRequest(path, data, onCacheSaved));
			
			gameManager.backgroundThreadManager.addBackgroundFunction(checkSaveQueue);
		}
		
		static private function checkSaveQueue():void 
		{
			if (saveQueue.length > 0 && !currentRequest)
			{
				var saveRequest:SaveRequest = saveQueue.shift() as SaveRequest;
				currentRequest = saveRequest;
				saveFileInternal(saveRequest);
			}
		}
		
		static private function saveFileInternal(saveRequest:SaveRequest):void 
		{
			var data:ByteArray = saveRequest.data;
			var path:String = saveRequest.path;
			
			data.position = 0;
			var file:File = getCacheDirectory() as File;
			file = file.resolvePath(path); 
			//sosTrace( "InternalStorageAPI.saveFileInternal: " , file.url, path);
			var fileStream:FileStream = new FileStream();
			currentFileStream = fileStream;
			fileStream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, fileStream_outputProgressHandler);
			fileStream.addEventListener(IOErrorEvent.IO_ERROR, fileStream_ioErrorHandler);
			fileStream.addEventListener(Event.COMPLETE, fileStream_completeHandler);
			fileStream.addEventListener(Event.CLOSE, fileStream_closeHandler);
			try
			{
				fileStream.openAsync(file, FileMode.WRITE);  
				fileStream.writeBytes(data);
			}
			catch(e:Error)
			{
				sosTrace( "Error while trying to save file " + path + " : " + e, SOSLog.ERROR);
				if (currentRequest.callback != null)
				{
					currentRequest.callback();
				}
				currentRequest = null;
				gameManager.backgroundThreadManager.addBackgroundFunction(checkSaveQueue);
			}
		}
		
		static private function fileStream_closeHandler(e:Event):void 
		{
			sosTrace( "InternalStorageAPI.fileStream_closeHandler > e : " + e );
			var fileStream:FileStream = e.target as FileStream;
			if (!fileStream)
			{
				sosTrace( "NO fileStream on complete : " + fileStream, SOSLog.ERROR);
				return;
			}
			
			closeFileStream(fileStream);
		}
		
		static private function fileStream_completeHandler(e:Event):void 
		{
			sosTrace( "InternalStorageAPI.fileStream_completeHandler > e : " + e );
			var fileStream:FileStream = e.target as FileStream;
			if (!fileStream)
			{
				sosTrace( "NO fileStream on complete : " + fileStream, SOSLog.ERROR);
				return;
			}
			
			closeFileStream(fileStream);
		}
		
		static private function fileStream_outputProgressHandler(e:OutputProgressEvent):void 
		{
			sosTrace( "InternalStorageAPI.fileStream_outputProgressHandler > e : " + e );
			
			if (e.bytesPending > 0)
			{
				sosTrace( "e.bytesPending : " + e.bytesPending );
				return;
			}
			
			var fileStream:FileStream = e.target as FileStream;
			if (!fileStream)
			{
				sosTrace( "NO fileStream on output progress : " + fileStream, SOSLog.ERROR);
				return;
			}
			
			closeFileStream(fileStream);
		}
		
		static private function fileStream_ioErrorHandler(e:IOErrorEvent):void 
		{
			sosTrace( "InternalStorageAPI.fileStream_ioErrorHandler > e : " + e, SOSLog.ERROR);
			
			var fileStream:FileStream = e.target as FileStream;
			if (!fileStream)
			{
				sosTrace( "NO fileStream : " + fileStream, SOSLog.ERROR);
				return;
			}
			
			closeFileStream(fileStream);
		}
		
		static private function closeFileStream(fileStream:FileStream):void 
		{
			sosTrace( "InternalStorageAPI.closeFileStream > fileStream : " + fileStream, SOSLog.DEBUG);
			fileStream.removeEventListener(OutputProgressEvent.OUTPUT_PROGRESS, fileStream_outputProgressHandler);
			fileStream.removeEventListener(IOErrorEvent.IO_ERROR, fileStream_ioErrorHandler);
			fileStream.removeEventListener(Event.COMPLETE, fileStream_completeHandler);
			fileStream.removeEventListener(Event.CLOSE, fileStream_closeHandler);
			
			currentFileStream = null;
			fileStream.close();
			
			if (currentRequest.callback != null)
			{
				currentRequest.callback();
			}
			
			currentRequest = null;
			
			gameManager.backgroundThreadManager.addBackgroundFunction(checkSaveQueue);
		}
		
		//Verify error on social if typed to File
		private static var cacheDirectory:FileReference;
		
		private static var fileExistanceCheckCache:Object = { };
		
		public static function fileExists(path:String):Boolean 
		{
			if (fileExistanceCheckCache[path] == true)
			{
				return true;
			}
			
			var file:File = (getCacheDirectory() as File).resolvePath(path);  
			fileExistanceCheckCache[path] = file.exists;
			return fileExistanceCheckCache[path];
		}
		
		static public function getCacheDirectory():FileReference
		{
			if (!cacheDirectory)
			{
				cacheDirectory = File.cacheDirectory;
			}
			return cacheDirectory;
		}
	}
}

import flash.utils.ByteArray;

class SaveRequest
{
	public var path:String;
	public var data:ByteArray;
	public var callback:Function;
	public function SaveRequest(path:String, data:ByteArray, callback:Function) 
	{
		super();
		this.callback = callback;
		this.data = data;
		this.path = path;
	}
	
	public function toString():String 
	{
		return "[SaveRequest path=" + path + "]";
	}
}