package com.alisacasino.bingo.assets.loading.assetLoaders 
{
	import avmplus.getQualifiedClassName;
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.ILoaderWrapper;
	import starling.core.Starling;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ATFTextureLoader extends BinaryAssetLoader
	{
		private var _texture:Texture;
		private var notHandlingContextLoss:Boolean;
		private var cleanupCalled:Boolean;
		
		public function ATFTextureLoader(uri:String) 
		{
			super(uri);
		}
		
		override public function process():void 
		{
			/*
			trace(">> uri", uri);
			if (uri == "720/atlases/roomicons_blackout.atf")
			{
				trace("uri", uri);
				onFailedProcessing();
				return;
			}
			*/	
			
			extractBinaryData();
			
			if (!getBinaryData())
			{
				onFailedProcessing();
				return;
			}
			
			try
			{
				_texture = Texture.fromAtfData(getBinaryData(), 1, false);
				/*if (!Starling.handleLostContext)
				{
					notHandlingContextLoss = true;
				}*/
			}
			catch (e:Error)
			{
				sosTrace( "Error while uploading ATF data : " + e + " - " + uri, SOSLog.ERROR);
				sosTrace( "currentLoader : " + getQualifiedClassName(currentLoader) + " - " + currentLoader.getURI(), SOSLog.DEBUG);
				onFailedProcessing();
				return;
			}
			
			onSuccessfulProcessing();
			checkIfCanDisposeByteArray();
		}
		
		private function checkIfCanDisposeByteArray():void 
		{
			if (notHandlingContextLoss && cleanupCalled)
			{
				if (getBinaryData())
				{
					getBinaryData().clear();
				}
			}
		}
		
		public function get texture():Texture 
		{
			return _texture;
		}
		
		override protected function cleanupServiceData():void 
		{
			super.cleanupServiceData();
			cleanupCalled = true;
			checkIfCanDisposeByteArray();
		}
		
	}

}