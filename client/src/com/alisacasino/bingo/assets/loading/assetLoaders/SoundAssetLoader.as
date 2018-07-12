package com.alisacasino.bingo.assets.loading.assetLoaders 
{
	import com.alisacasino.bingo.assets.loading.assetLoaders.BinaryAssetLoader;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.IBinaryLoader;
	import com.alisacasino.bingo.utils.LoadUtils;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class SoundAssetLoader extends BinaryAssetLoader
	{
		private var _sound:Sound;
		private var soundCreated:Boolean;
		private var cleanupCalled:Boolean;
		
		public function SoundAssetLoader(uri:String) 
		{
			super(uri);
		}
		
		public function getSound():Sound
		{
			if (!_sound)
			{
				_sound = new Sound();
				_sound.addEventListener(Event.COMPLETE, sound_completeHandler);
				try
				{
					_sound.loadCompressedDataFromByteArray(binaryLoader.getBinaryData(), binaryLoader.getBinaryData().length);
				}
				catch (e:Error)
				{
					sosTrace( "Sound asset loader " + uri + " error e : " + e, SOSLog.ERROR);
					return null;
				}
			}
			return _sound;
		}
		
		override protected function checkConcreteAsset(binaryData:ByteArray):Boolean 
		{
			if (getSound())
			{
				return true;
			}
			return false;
		}
		
		private function sound_completeHandler(e:Event):void 
		{
			soundCreated = true;
			checkIfCanDisposeByteArray();
		}
		
		private function checkIfCanDisposeByteArray():void 
		{
			if (soundCreated && cleanupCalled)
			{
				if (getBinaryData())
				{
					getBinaryData().clear();
				}
			}
		}
		
		override public function dispose():void 
		{
			if (_sound)
			{
				_sound = null;
			}
			super.dispose();
		}
		
		override protected function cleanupServiceData():void 
		{
			super.cleanupServiceData();
			cleanupCalled = true;
			checkIfCanDisposeByteArray();
		}
		
	}

}