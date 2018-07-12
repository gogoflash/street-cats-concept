package com.alisacasino.bingo.assets.loading.assetIndices 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class AssetIndexEntry 
	{
		public var cdnPath:String;
		public var path:String;
		public var timestamp:int;
		public var size:int;
		
		public function AssetIndexEntry(path:String = "", size:int = 0, timestamp:int = 0, cdnPath:String = "")
		{
			this.timestamp = timestamp;
			this.size = size;
            this.path = path;
            this.cdnPath = cdnPath.length > 0 ? cdnPath + "/" : cdnPath;
		}
		
		static public function fromLine(entryLine:String):AssetIndexEntry
		{
			var dataset:Array = entryLine.split(";");
			if (dataset.length != 4)
			{
				return new AssetIndexEntry("invalid path", 0, 0);
			}
			
			return new AssetIndexEntry(dataset[1], dataset[2], dataset[3], dataset[0]);
		}
		
		public function toString():String 
		{
			return "[AssetIndexEntry cdnPath=" + cdnPath + " path=" + path + " timestamp=" + timestamp +
                    " size=" + size + "]";
		}
		
		public function isValid():Boolean
		{
			return path.length > 0 && timestamp > 0;
		}
		
		public function sameTo(indexEntry:AssetIndexEntry):Boolean
		{
			return timestamp == indexEntry.timestamp;
		}
		
	}

}