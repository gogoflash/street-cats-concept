package com.alisacasino.bingo.commands.assetIndex 
{
	import com.alisacasino.bingo.commands.ICommand;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.utils.InternalStorageAPI;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class SaveLocalAssetIndex extends CommandBase
	{
		private var serializedData:ByteArray;
		
		public function SaveLocalAssetIndex(serializedData:ByteArray) 
		{
			this.serializedData = serializedData;
		}
		
		override protected function startExecution():void 
		{
			saveFile();
		}
		
		private function saveFile():void 
		{
			var file:File = (InternalStorageAPI.getCacheDirectory() as File).resolvePath("assetIndex.local");
			var fileStream:FileStream = new FileStream();  
			fileStream.open(file, FileMode.WRITE);  
			fileStream.writeBytes(serializedData);
			fileStream.close(); 
			finish();
		}
		
	}

}