package com.alisacasino.bingo.assets.loading.assetIndices 
{
	import com.alisacasino.bingo.commands.assetIndex.SaveLocalAssetIndex;
	import com.alisacasino.bingo.utils.AbsoluteVersion;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.GameManager;
	import com.alisacasino.bingo.utils.TimeService;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class AssetIndexManager 
	{
		private var serverAssetIndexEntryByPath:Object;
		private var localAssetIndexEntryByPath:Object;
		
		private var indexLoadCallback:Function;
		
		private var needToSaveLocalIndex:Boolean;
		
		public var indexLoaded:Boolean = false;
		
		public function AssetIndexManager() 
		{
			serverAssetIndexEntryByPath = { };
			localAssetIndexEntryByPath = { };
			
		}
		
		private function saveIndex():void 
		{
			registerClassAlias("AssetIndexEntry", AssetIndexEntry);
			var serializedData:ByteArray = new ByteArray();
			serializedData.writeObject(localAssetIndexEntryByPath);
			
			new SaveLocalAssetIndex(serializedData).execute();
			
			TimeService.removeOneSecondCallback(saveIndex);
		}
		
		public function parseServerIndex(rawIndexData:String):void 
		{
			var lines:Array = rawIndexData.split(/(\r\n|\r|\n)/g);
			for each (var entryLine:String in lines) 
			{
				var assetIndexEntry:AssetIndexEntry = AssetIndexEntry.fromLine(entryLine);
				if (assetIndexEntry.isValid())
				{
					serverAssetIndexEntryByPath[assetIndexEntry.path] = assetIndexEntry;
				}
			}
			
			indexLoaded = true;
		}
		
		public function cachedFileIsUpToDate(uri:String):Boolean
		{
			if (!indexLoaded)
			{
				return true;
			}
			
			sosTrace( "AssetIndexManager.cachedFileIsUpToDate > uri : " + uri, SOSLog.DEBUG);
			var localIndexEntry:AssetIndexEntry = getLocalAssetIndexEntryByURI(uri);
			if (!localIndexEntry)
			{
				sosTrace("No local index entry, returning FALSE", SOSLog.DEBUG);
				return false;
			}
			
			var serverIndexEntry:AssetIndexEntry = getServerAssetIndexEntryByURI(uri);
			if(localIndexEntry.sameTo(serverIndexEntry))
			{
				sosTrace("Local index entry is the same or newer, returning TRUE", SOSLog.DEBUG);
				return true;
			}
			
			//sosTrace("Local index entry differs or is older, returning FALSE", SOSLog.DEBUG);
			return false;
		}
		
		public function getLocalAssetIndexEntryByURI(uri:String):AssetIndexEntry
		{
			if (localAssetIndexEntryByPath.hasOwnProperty(uri))
			{
				return localAssetIndexEntryByPath[uri];
			}
			return null;
		}
		
		public function getServerAssetIndexEntryByURI(uri:String):AssetIndexEntry
		{
			if (!indexLoaded)
			{
				//Use version as timestamp when we don't have asset index loaded. This fake timestamp is back in time enough to not create any collisions with asset indices.
				var versionInt:int =  AbsoluteVersion.fromString(GameManager.instance.getVersionString());
				return new AssetIndexEntry(uri, 0, versionInt);
			}
			
			if (!serverAssetIndexEntryByPath.hasOwnProperty(uri))
			{
				//sosTrace( "No asset index entry for path : " + uri, SOSLog.WARNING);
				var dummyEntry:AssetIndexEntry = getRandomizedIndexEntry(uri);
				serverAssetIndexEntryByPath[uri] = dummyEntry;
			}
			return serverAssetIndexEntryByPath[uri];
		}
		
		public function parseLocalIndex(localIndexRawData:ByteArray):void 
		{
			
			try
			{
				registerClassAlias("AssetIndexEntry", AssetIndexEntry);
				var rawData:Object = localIndexRawData.readObject();
				localAssetIndexEntryByPath = rawData;
			}
			catch (e:Error)
			{
				//sosTrace( "AssetIndexManager.parseLocalIndex error " + e, e.getStackTrace(), SOSLog.ERROR);
			}
			
			if (!localAssetIndexEntryByPath)
			{
				//sosTrace( "localAssetIndexEntryByPath is null ", SOSLog.DEBUG);
				localAssetIndexEntryByPath = { };
			}
			
			//sosTrace( "localAssetIndexEntryByPath : ", localAssetIndexEntryByPath, SOSLog.DEBUG);
		}
		
		public function addIndexEntryToLocalStorage(indexEntry:AssetIndexEntry):void
		{
			//sosTrace( "AssetIndexManager.addIndexEntryToLocalStorage > indexEntry : " + indexEntry, SOSLog.DEBUG);
			localAssetIndexEntryByPath[indexEntry.path] = indexEntry;
			TimeService.addOneSecondCallback(saveIndex);
		}
		
		public function updateLocalIndexToServer(uri:String):void 
		{
			addIndexEntryToLocalStorage(getServerAssetIndexEntryByURI(uri));
		}
		
		public function getRandomizedIndexEntry(uri:String):AssetIndexEntry
		{
			var randomTimestamp:int = !Constants.isLocalBuild ? int(Math.random() * int.MAX_VALUE) : 15;
			var randomSize:int = !Constants.isLocalBuild ? int(Math.random() * int.MAX_VALUE) : 10;
			return new AssetIndexEntry(uri, randomSize, randomTimestamp);
		}
		
		public function getIndexVersion():String
		{
			return "";
		}
		
	}

}