/**
 * @author grdy
 * @since 5/23/17
 */
package com.alisacasino.bingo.assets
{
	import com.alisacasino.bingo.assets.loading.AssetBase;
	import com.alisacasino.bingo.assets.loading.assetLoaders.XMLAssetLoader;
	import com.alisacasino.bingo.utils.misc.CallbackContainer;
	
	import treefortress.sound.SoundAS;
	
	use namespace SoundAS;
	
	public class XmlAsset extends AssetBase implements IAsset
	{
		
		private var _uri:String;
		private var loader:XMLAssetLoader;
		private var loadComplete:Boolean = false;
		
		private var completeCallbackContainer:CallbackContainer;
		private var errorCallbackContainer:CallbackContainer;
		private var onCompleteArgs:Array;
		private var onErrorArgs:Array;
		
		private var _xml:XML;
		
		public function XmlAsset(uri:String)
		{
			_uri = uri;
			completeCallbackContainer = new CallbackContainer();
			errorCallbackContainer = new CallbackContainer();
		}
		
		public function load(onComplete:Function, onError:Function, onCompleteArgs:Array = null, onErrorArgs:Array = null):void
		{
			this.onCompleteArgs = onCompleteArgs;
			this.onErrorArgs = onErrorArgs;
			completeCallbackContainer.addCallback(onComplete);
			errorCallbackContainer.addCallback(onError);
			
			loader = new XMLAssetLoader(_uri);
			loader.finishOnFail = false;
			loader.load(onXmlLoaded, onXmlLoaded);
			addTrackedLoader(loader);
		}
		
		public function clearListeners():void 
		{
			completeCallbackContainer.clear();
			errorCallbackContainer.clear();
			onCompleteArgs = null;
			onErrorArgs = null;
		}
		
		override public function purge():void
		{
			super.purge();
			if (loader && !loader.disposed)
			{
				loader.dispose();
				loader = null;
			}
			loadComplete = false;
		}
		
		public function get isRemovable():Boolean
		{
			return false;
		}
		
		public function get loaded():Boolean
		{
			return loadComplete;
		}
		
		public function get xml():XML
		{
			return _xml;
		}
		
		
		
		private function onXmlLoaded(loader:XMLAssetLoader):void
		{
			if (!loader)
				return;
			
			if (loader.failed)
			{
				loader.dispose();
				loadComplete = false;
				completeCallbackContainer.clear();
				errorCallbackContainer.executeAndClearAllCallbacks(onErrorArgs);
				onErrorArgs = null;
			}
			else
			{
				_xml = loader.xml;
				loadComplete = true;
				errorCallbackContainer.clear();
				completeCallbackContainer.executeAndClearAllCallbacks(onCompleteArgs);
				onCompleteArgs = null;
			}
		}
		
		public function get uri():String
		{
			return _uri;
		}
		
		public static const Snow:XmlAsset = new XmlAsset("particles/snow.pex");
		
		public function toString():String
		{
			return "[XmlAsset " + _uri + " loaded=" + loaded + "]";
		}
	}
}
