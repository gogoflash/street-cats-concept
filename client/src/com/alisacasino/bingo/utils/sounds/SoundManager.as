package com.alisacasino.bingo.utils.sounds
{
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.models.roomClasses.Room;
	import com.alisacasino.bingo.platform.IInterceptor;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.utils.Constants;
	import com.alisacasino.bingo.utils.GameManager;
	import flash.utils.getTimer;
	import starling.core.Starling;
	import treefortress.sound.SoundInstance;
	
	import flash.utils.setTimeout;
	
	import treefortress.sound.SoundAS;
	
	public class SoundManager
	{
		private static var sInstance:SoundManager = null;
		private var mCurrentSoundtrack:SoundAsset = null;
		private var mIsInBackground:Boolean = false;
		private var mSoundsToPreload:Array = null;
		
		private var mPlatformInterceptor:IInterceptor = PlatformServices.interceptor;
		
		private static const PHRASE_FREQUENCY:Number = 0.033;
		
		public static var VOICEOVER_VOLUME:Number = 1;//0.35;
		
		public static var BACKGROUND_VOLUME:Number = 1;
		public static var BACKGROUND_LOW_VOLUME:Number = 0.3;
		public static var BACKGROUND_STORE_VOLUME:Number = 0.18;
		public static var BACKGROUND_SLOT_MACHINE_VOLUME:Number = 0.18;
		
		public static var SOUNDS_VOLUME:Number = 1;
		
		
		private var muteFXSoundOnLocal:Boolean = true;
		private var muteBackgroundSoundOnLocal:Boolean = true;
		
		private var soundTrackDelayCallsIds:Vector.<uint> = new <uint> [];
		
		private var soundTrackForStop:Vector.<SoundAsset> = new <SoundAsset> [];
		private var sfxLoops:Object = {};
		
		private var voiceoverNumberSoundNames:Vector.<String> 
		private var voiceoverPhraseSoundNames:Vector.<String> 
		
		public static const BACKGROUND_MUSIC_ENABLED_KEY:String = "BackgroundMusicEnabled";
		public static const SFX_ENABLED_KEY:String = "SfxEnabled";
		public static const VOICEOVER_ENABLED_KEY:String = "VoiceoverEnabled";
		
		public var soundLoadQueue:SoundLoadAssetQueue;
		
		public function SoundManager()
		{
			PlatformServices.interceptor.setDefaultSoundType();
			
			voiceoverNumberSoundNames = new <String>[''];
			voiceoverPhraseSoundNames = new <String>[''];
			var i:int = 1;
			var numberString:String;
			while (i <= 75) {
				numberString = i < 10 ? ('0' + i.toString()): i.toString();
				voiceoverNumberSoundNames[i] = "number" + numberString;
				voiceoverPhraseSoundNames[i] = "phrase" + numberString;
				i++;
			}
		}
		
		public static function get instance():SoundManager
		{
			if (sInstance == null) {
				sInstance = new SoundManager();
			}
			return sInstance;
		}
		
		public function playSoundtrack(track:SoundAsset, overwrite:Boolean = true, timeToChange:int = -1):void
		{
			var noOtherSoundtracksPlaying:Boolean = mCurrentSoundtrack == null;
			
			stopFadedSoundtracks();
			
			if (mCurrentSoundtrack != null && overwrite) {
				mCurrentSoundtrack.instance.fadeTo(0, 200);
				
				soundTrackForStop.push(mCurrentSoundtrack);
				soundTrackDelayCallsIds.push(Starling.juggler.delayCall(stopFadedSoundtracks, 0.21, false));
			}
			
			mCurrentSoundtrack = track;
			
			if (backgroundMusicEnabled && !mIsInBackground && !GameManager.instance.deactivated) {
				if (noOtherSoundtracksPlaying)
					mCurrentSoundtrack.play(null, false, BACKGROUND_VOLUME, timeToChange);
				else if (backgroundMusicEnabled && !mIsInBackground)
					soundTrackDelayCallsIds.push(Starling.juggler.delayCall(mCurrentSoundtrack.play, 0.5, null, true, BACKGROUND_VOLUME, timeToChange));
			}
		}
		
		public function setSoundtrackVolume(volume:Number, fadeTime:uint = 1000):void 
		{
			if (!mCurrentSoundtrack || !backgroundMusicEnabled)
				return;
			
			mCurrentSoundtrack.setVolume(volume, fadeTime);
		}
		
		/*public function playFx(track:SoundAsset, overwrite:Boolean = true):void
		{
			var noOtherSoundtracksPlaying:Boolean = mCurrentSoundtrack == null;
			
			stopFadedSoundtracks();
			
			if (mCurrentSoundtrack != null && overwrite) {
				mCurrentSoundtrack.instance.fadeTo(0, 200);
				
				soundTrackForStop.push(mCurrentSoundtrack);
				soundTrackDelayCallsIds.push(Starling.juggler.delayCall(stopFadedSoundtracks, 0.21, false));
			}
			
			mCurrentSoundtrack = track;
			
			
			if (backgroundMusicEnabled && !mIsInBackground && !GameManager.instance.deactivated) {
				if (noOtherSoundtracksPlaying)
					mCurrentSoundtrack.play();
				else if (backgroundMusicEnabled && !mIsInBackground)
					soundTrackDelayCallsIds.push(Starling.juggler.delayCall(mCurrentSoundtrack.play, 0.5, null, true));
			}
		}*/
		
		
		public function stopSoundtrack():void
		{
			if (mCurrentSoundtrack != null)
				mCurrentSoundtrack.stop();
		}
		
		public function pause():void
		{
			SoundAS.pauseAll();
			mIsInBackground = true;
		}
		
		public function resume():void
		{
			if (!mIsInBackground)
			{
				return;
			}
			SoundAS.resumeAll();
			mIsInBackground = false;
		}
		
		public function playBallNumber(number:Number):void
		{
			if (!Room.current)
				return;
				
			if (!voiceoverEnabled || mIsInBackground)
				return;
			
			var index:int = number;// - 1;
			var numberSound:String = index < voiceoverNumberSoundNames.length ? voiceoverNumberSoundNames[index] : null;
			var phraseSound:String = index < voiceoverPhraseSoundNames.length ? voiceoverPhraseSoundNames[index] : null;
			var shouldPlayPhrase:Boolean = Math.random() < gameManager.skinningData.voiceover.phraseFrequency;
			
			if (shouldPlayPhrase)
				play(phraseSound, function():void{ play(numberSound, null, false, gameManager.skinningData.voiceover.volume)}, false, gameManager.skinningData.voiceover.volume);
			else
				play(numberSound, null, false, gameManager.skinningData.voiceover.volume);
		}
		
		public function playVoiceover(name:String, overwrite:Boolean = false, volume:Number = 1):void
		{
			if (!Room.current)
				return;
				
			if (!voiceoverEnabled || mIsInBackground)
				return;
				
			play(name, null, overwrite, volume * gameManager.skinningData.voiceover.volume);	
		}
		
		public function playBingo():void
		{
			var rand:Number = Math.random();
			if (rand < 0.33)
				playVoiceover('bingo1');
			else if (rand < 0.66)
				playVoiceover('bingo2');
			else 
				playVoiceover('bingo3');
		}
		
		public function playBadBingo():void
		{
			var rand:Number = Math.random();
			if (rand < 0.66)
				playVoiceover('bad_bingo');
			else
				playVoiceover("bad_call");
		}
		
		public function playSfx(asset:SoundAsset, delayTime:Number = 0, loops:int = 0, volume:Number = 1, startTime:Number = 0, allowMultiple:Boolean = false):SoundInstance
		{
			if (!asset)
				return null;
				
			if (canPlaySfx)
			{
				if (!asset.loaded)
				{
					sosTrace("Sound asset not loaded : " + asset.name, SOSLog.ERROR);
					return null;
				}
				
				try
				{
					var sound:SoundInstance = asset.instance;
					if (sound)
					{
						if(delayTime == 0)
							sound.play(volume*SOUNDS_VOLUME, startTime, loops, allowMultiple);
						else
							Starling.juggler.delayCall(sound.play, delayTime, volume*SOUNDS_VOLUME, startTime, loops, allowMultiple);
					}
					return sound;
				}
				catch (e:Error)
				{
					sosTrace("Error when trying to play sound asset : " + asset.name + " - " + e.getStackTrace(), SOSLog.ERROR);	
				}
			}
			return null;
		}
		
		public function stopSfx(asset:SoundAsset):void
		{
			if (!asset || !asset.loaded)
				return;
			
			try {
				if (asset.instance)
					asset.instance.stop();
			}
			catch (e:Error) {
				sosTrace("Error when trying to stop sound asset : " + asset.name + " - " + e.getStackTrace(), SOSLog.ERROR);	
			}
		}
		
		public function playMark():void
		{
			playSfx(SoundAsset.SfxMark);
		}
		
		public function playButton():void
		{
			playSfx(SoundAsset.ButtonClick)//SfxButton);
		}
		
		
		
		public function get backgroundMusicEnabled():Boolean
		{
			if (Constants.isLocalBuild && muteBackgroundSoundOnLocal)
			{
				return false;
			}
			
			return mPlatformInterceptor.backgroundMusicEnabled;
		}
		
		public function set backgroundMusicEnabled(value:Boolean):void
		{
			mPlatformInterceptor.backgroundMusicEnabled = value;
			
			if (value)
				playSoundtrack(mCurrentSoundtrack);
			else
				stopSoundtrack();
		}
		
		public function get sfxEnabled():Boolean
		{
			if (Constants.isLocalBuild && muteFXSoundOnLocal)
			{
				return false;
			}
			return mPlatformInterceptor.sfxEnabled;
		}
		
		public function get canPlaySfx():Boolean
		{
			return sfxEnabled && !mIsInBackground;
		}
		
		public function set sfxEnabled(value:Boolean):void
		{
			mPlatformInterceptor.sfxEnabled = value;
		}
		
		public function get voiceoverEnabled():Boolean
		{
			if (Constants.isLocalBuild && muteFXSoundOnLocal)
			{
				return false;
			}
			return mPlatformInterceptor.voiceoverEnabled;
		}
		
		public function set voiceoverEnabled(value:Boolean):void
		{
			mPlatformInterceptor.voiceoverEnabled = value;
		}
		
		
		/*public function preloadSounds():void {
			if (soundsToPreload.length <= 0) {
				trace("SoundManager::preloadSounds. done");
				return;
			}
			
			var soundAsset:SoundAsset = soundsToPreload.shift();
			soundAsset.loadWithErrCallback(preloadSounds, preloadSounds);
		}*/
		
		public function switchMuteSoundOnLocal():void {
			muteFXSoundOnLocal = !muteFXSoundOnLocal;
			muteBackgroundSoundOnLocal = muteFXSoundOnLocal;
		}
		
		private function stopFadedSoundtracks(cleanDelayCalls:Boolean = true):void 
		{
			while (cleanDelayCalls && soundTrackDelayCallsIds.length > 0) {
				Starling.juggler.removeByID(soundTrackDelayCallsIds.shift());
			}
			
			while (soundTrackForStop.length > 0) {
				soundTrackForStop.shift().instance.stop();
			}
		}
		
		public function playSfxLoop(asset:SoundAsset, delay:Number = 0, fadeInTime:Number = 0.5, fadeOutTime:Number = 0.8, volume:Number = 1, previousAsset:SoundInstance = null):void
		{
			//if(!previousAsset)
				//trace('playSfxLoop ', asset.name);
			//else
				//trace('playSfxLoop internal', asset.name);
				
			if (!canPlaySfx || !asset.loaded) {
				//trace('canPlaySfx asset.loaded', asset.name, canPlaySfx, asset.loaded);
				return;
			}
			
			if (!previousAsset) {
				//trace('stopSfxLoop when non previousAsset', asset.name);
				stopSfxLoop(asset);
			}
				
			var loopParams:Array = [];
			if (asset.name in sfxLoops)
				loopParams = sfxLoops[asset.name] as Array;
			else
				sfxLoops[asset.name] = loopParams;	
				
			if (previousAsset) 
				Starling.juggler.tween(previousAsset, fadeOutTime, {volume:0});
				
			try
			{
				var sound:SoundInstance = asset.instance;
				if (sound)
				{
					var playingsound:SoundInstance = asset.instance.clone().play(0, 0, 0, true);
					Starling.juggler.removeTweens(playingsound);
					Starling.juggler.tween(playingsound, fadeInTime, {volume:volume * SOUNDS_VOLUME});
					
					loopParams[0] = Starling.juggler.delayCall(playSfxLoop, delay, asset, delay, fadeInTime, fadeOutTime, volume, playingsound);
					loopParams[1] = playingsound;
					
					//trace('playSfxLoop internal', asset.name, loopParams[0], getTimer());
				}
			}
			catch (e:Error)
			{
				//trace("Error playSfxLoop : ", asset.name);
				sosTrace("Error playSfxLoop : " + asset.name + " - " + e.getStackTrace(), SOSLog.ERROR);	
			}
		}
		
		public function stopSfxLoop(asset:SoundAsset, fadeTime:Number = 0.5):void
		{
			if (!(asset.name in sfxLoops))
				return;
			
			var loopParams:Array = sfxLoops[asset.name] as Array;	
			if (loopParams.length > 1) {
				//trace('stopSfxLoop ', asset.name, loopParams[0], getTimer() );
				Starling.juggler.removeByID(loopParams[0]);	
				Starling.juggler.removeTweens(loopParams[1]);
				Starling.juggler.tween(loopParams[1], fadeTime, {volume:0});
			}
			else {
				//trace('stopSfxLoop loopParams.length == 0 ', asset.name, loopParams.length, getTimer() );
			}
			
			delete sfxLoops[asset.name];
		}
		
		
		
		
		public function play(name:String, onComplete:Function=null, overwrite:Boolean = false, volume:Number = 1):SoundInstance
		{
			if (name == null)
				return null;
			
			var instance:SoundInstance;
	
			if (overwrite)
			{
				instance = SoundAS.getSound(name);
				
				if (instance)
					instance.stop();
				
				instance = null;
			}
			
			try 
			{
				if (onComplete) 
				{
					instance = SoundAS.playFx(name, volume);
					instance.onCompleteCallback = function():void {
						instance.onCompleteCallback = null;
						onComplete.call();
					};
				} 
				else {
					instance = SoundAS.playFx(name, volume);
				}

			} catch (e:Error) {
				// deliberately swallow to avoid overlogging
			}
			
			return instance;
		}
		
		public function stop(name:String, immediately:Boolean = false, fadeTime:uint = 1000):void
		{
			var sound:SoundInstance = SoundAS.getSound(name);
			if(sound)
				sound.fadeTo(0, immediately ? 0 : fadeTime);
		}
		
	}
}