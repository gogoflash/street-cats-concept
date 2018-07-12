package com.alisacasino.bingo.assets.loading.assetLoaders 
{
	import com.alisacasino.bingo.assets.loading.nativeLoaderWrappers.ILoaderWrapper;
	import com.catalystapps.gaf.core.ZipToGAFAssetConverter;
	import com.catalystapps.gaf.data.GAFBundle;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class GAFBundleLoader extends BinaryAssetLoader
	{
		private var animName:String;
		private var _gafBundle:GAFBundle;
		private var zipToGAFAssetConverter:ZipToGAFAssetConverter;
		
		public function GAFBundleLoader(uri:String, animName:String) 
		{
			this.animName = animName;
			super(uri);
		}
		
		override public function process():void 
		{
			extractBinaryData();
			
			if (!getBinaryData())
			{
				onFailedProcessing();
				return;
			}
			
			zipToGAFAssetConverter = new ZipToGAFAssetConverter(animName);
			zipToGAFAssetConverter.addEventListener(Event.COMPLETE, zipToGAFAssetConverter_completeHandler);
			zipToGAFAssetConverter.addEventListener(ErrorEvent.ERROR, zipToGAFAssetConverter_errorHandler);
			try
			{
				zipToGAFAssetConverter.convert(getBinaryData());
			}
			catch (e:Error)
			{
				sosTrace( "zipToGAFAssetConverter.convert error : " + e, SOSLog.ERROR);
				onFailedProcessing();
			}
		}
		
		private function zipToGAFAssetConverter_uncaughtErrorHandler(e:UncaughtErrorEvent):void 
		{
			sosTrace( "GAFBundleLoader.zipToGAFAssetConverter_uncaughtErrorHandler > e : " + e, SOSLog.ERROR);
			e.preventDefault();
			onFailedProcessing();
		}
		
		private function zipToGAFAssetConverter_errorHandler(e:ErrorEvent):void 
		{
			sosTrace( "GAFBundleLoader.zipToGAFAssetConverter_errorHandler > e : " + e, SOSLog.ERROR);
			e.preventDefault();
			onFailedProcessing();
		}
		
		
		private function zipToGAFAssetConverter_completeHandler(e:Event):void 
		{
			_gafBundle = zipToGAFAssetConverter.gafBundle;
			onSuccessfulProcessing();
		}
		
		override public function dispose():void 
		{
			if (_gafBundle)
			{
				_gafBundle.dispose();
			}
			super.dispose(); 
			
		}
		
		public function get gafBundle():GAFBundle 
		{
			return _gafBundle;
		}
		
		override protected function cleanupServiceData():void 
		{
			super.cleanupServiceData();
			if(getBinaryData())
				getBinaryData().clear();
		}
	}

}