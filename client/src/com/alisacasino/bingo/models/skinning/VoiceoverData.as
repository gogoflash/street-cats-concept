package com.alisacasino.bingo.models.skinning 
{
	import adobe.utils.CustomActions;
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.assets.ImageAsset;
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.assets.SoundZipAsset;
	import com.alisacasino.bingo.commands.serverRequests.SendClientDataSave;
	import com.alisacasino.bingo.protocol.CardType;
	import com.alisacasino.bingo.protocol.CustomCard;
	import com.alisacasino.bingo.protocol.CustomVoiceOver;
	import com.alisacasino.bingo.protocol.CustomizationType;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import flash.media.Sound;
	import starling.textures.Texture;
	import treefortress.sound.SoundAS;
	
	public class VoiceoverData extends CustomizerItemBase
	{
		public static const EVENT_SAMPLE_LOADED:String = 'EVENT_SAMPLE_LOADED';
		
		private var _assetName:String;
		private var _sampleAsset:SoundAsset;
		private var _soundZipAsset:SoundZipAsset;
		private var _callUseSoundsOnLoad:Boolean;
		private var _phraseFrequency:Number = 0;
		private var _volume:Number = 1;
		
		public function VoiceoverData() 
		{
			_type = CustomizationType.VOICEOVER;
		}
		
		public function get soundZipAsset():SoundZipAsset {
			return _soundZipAsset;
		}
		
		public function set callUseSoundsOnLoad(value:Boolean):void {
			_callUseSoundsOnLoad = value;
		}
		
		public function get phraseFrequency():Number {
			return _phraseFrequency;
		}
		
		public function get volume():Number 
		{
			return gameManager.skinningData.getVoiceoverVolume(_assetName);
		}
		
		/*public function getTexture(texture:String, x2:Boolean = false):Texture {
			return x2 ? gameManager.skinningData.cardSkinX2.atlas.getTexture(texture) : _atlas.getTexture(texture);
		}*/
		
		public function addToLoad(source:Array):void 
		{
			_callUseSoundsOnLoad = true;
			
			if (!_sampleAsset)
				_sampleAsset = new SoundAsset(_assetName, SoundAsset.TYPE_VOICEOVER);
			
			if (!_soundZipAsset)
				_soundZipAsset = new SoundZipAsset("sounds/voiceover/" + _assetName + '.zip', handleUseSoundsOnLoad);
				
			source.push(_sampleAsset);
			source.push(_soundZipAsset);
		}
		
		public function get isLoaded():Boolean
		{
			return isSampleLoaded && isPackLoaded;
		}
		
		public function get isSampleLoaded():Boolean
		{
			return sampleAsset && sampleAsset.loaded;
		}
		
		public function get isPackLoaded():Boolean
		{
			return soundZipAsset && soundZipAsset.loaded && _soundZipAsset.soundsList;
		}
		
		public function get sampleAsset():SoundAsset
		{
			return _sampleAsset;
		}
		
		public function get assetName():String
		{
			return _assetName;
		}
		
		public function deserialize(raw:CustomVoiceOver):VoiceoverData 
		{
			super.setBaseProperties(raw);
			_assetName = raw.assetUrl;
			_phraseFrequency = raw.phraseFrequency;
			_volume = 1;
			return this;
		}
		
		public function load(onComplete:Function = null):void 
		{
			if (isLoaded) 
			{
				handleUseSoundsOnLoad();
				
				if (onComplete != null)
					onComplete();
				
				return;
			}
			else
			{
				onLoadComplete = onComplete;
				
				if (!_sampleAsset)
					_sampleAsset = new SoundAsset(_assetName, SoundAsset.TYPE_VOICEOVER);
				
				_sampleAsset.load(loadZipPack, loadZipPack);
			}
		}
		
		private function handleUseSoundsOnLoad(...args):void 
		{
			if (_callUseSoundsOnLoad) {
				useSounds();
				_callUseSoundsOnLoad = false;
			}
		}
		
		private function loadZipPack():void 
		{
			if (!_soundZipAsset)
				_soundZipAsset = new SoundZipAsset("sounds/voiceover/" + _assetName + '.zip');
			
			dispatchEventWith(EVENT_SAMPLE_LOADED);
			_soundZipAsset.load(loadZipPackComplete, null);	
		}
		
		private function loadZipPackComplete():void 
		{
			handleUseSoundsOnLoad();
			callOnLoadComplete();
		}
		
		public function unload():void 
		{
			onLoadComplete = null;
			
			if (_sampleAsset) {
				_sampleAsset.purge();
				_sampleAsset = null;
			}
			
			if (_soundZipAsset) {
				_soundZipAsset.purge();
				_soundZipAsset = null;
			}
		}
		
		public function playSample():void 
		{
			if (_sampleAsset && _sampleAsset.loaded)
				_sampleAsset.play(null, null, SoundManager.VOICEOVER_VOLUME);
		}
		
		public function useSounds():Boolean
		{
			if (!isPackLoaded)
				return false;
			
			var soundName:String;	
			var soundsList:Object = _soundZipAsset.soundsList;	
			for (soundName in soundsList)
			{
				SoundAS.addSound(soundName, soundsList[soundName]);
			}
			
			return true;
		}
		
		public function create(id:int, assetName:String, imageName:String, name:String, order:int, quantity:int, rarity:int, weight:Number, phraseFrequency:Number = 0.033):void
		{
			_id = id;
			_assetName = assetName;
			_uiAssetPath = imageName;
			_name = name;
			this.order = order;
			_quantity = quantity;
			_rarity = rarity;
			this.weight = weight;
			_phraseFrequency = phraseFrequency;
		}
		
		override protected function get uiAssetPath():String {
			return 'customizers/voiceovers/' + _uiAssetPath + '.png';
		}
	}
}