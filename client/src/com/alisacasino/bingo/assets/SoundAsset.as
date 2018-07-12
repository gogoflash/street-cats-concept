package com.alisacasino.bingo.assets
{
	import com.alisacasino.bingo.assets.loading.AssetBase;
	import com.alisacasino.bingo.assets.loading.assetLoaders.SoundAssetLoader;
	import com.alisacasino.bingo.utils.LoadUtils;
	import com.alisacasino.bingo.utils.misc.CallbackContainer;
	import treefortress.sound.SoundInstance;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import treefortress.sound.SoundAS;
	
	public class SoundAsset extends AssetBase implements IAsset
	{
		private var mSound:Sound;
		private var mName:String;
		
		public function get name():String 
		{
			return mName;
		}
		
		private var mFilePath:String;
		private var mType:String;
		private var mIsLoaded:Boolean;
		private var mIsLoading:Boolean;
		
		private var completeCallbackContainer:CallbackContainer;
		private var errorCallbackContainer:CallbackContainer;
		private var onCompleteArgs:Array;
		private var onErrorArgs:Array;
		
		public static const TYPE_SOUNDTRACK:String = "Soundtrack";
		public static const TYPE_SFX:String = "Sfx";
		public static const TYPE_SFX_SOUNDTRACK:String = "TYPE_SFX_SOUNDTRACK"; // temporal underchanging main soundtrack
		public static const TYPE_VOICEOVER:String = "Voiceover";
		private var loader:SoundAssetLoader;
		
		private var baseVolume:Number = 1;
		
		public static var DEFAULT_BUTTON_CLICK_VOLUME:Number = 0.7;
		
		private var timeToChange:int = 4000;
		
		/**
		 * @param	name
		 * @param	type
		 * @param	timeToChange:int - in microseconds. Now uses only for TYPE_SOUNDTRACK & TYPE_SFX_SOUNDTRACK. 
		 */
		public function SoundAsset(name:String, type:String)
		{
			completeCallbackContainer = new CallbackContainer();
			errorCallbackContainer = new CallbackContainer();
			
			mName = name;
			mType = type;
		
			if (type == TYPE_SOUNDTRACK)
				mFilePath = name;
			else if (type == TYPE_VOICEOVER)
				mFilePath = "sounds/voiceover/" + name + ".mp3";
			else if (type == TYPE_SFX || type == TYPE_SFX_SOUNDTRACK)
				mFilePath = "sounds/sfx/" + name + ".mp3";
		}
		
		public function get sound():Sound
		{
			return mSound;
		}
		
		public function load(onComplete:Function, onError:Function, onCompleteArgs:Array = null, onErrorArgs:Array = null):void
		{
			loadWithErrCallback(onComplete, onError, onCompleteArgs, onErrorArgs);
		}
		
		public function loadWithErrCallback(onComplete:Function, onError:Function = null, onCompleteArgs:Array = null, onErrorArgs:Array = null):void	{
			this.onCompleteArgs = onCompleteArgs;
			this.onErrorArgs = onErrorArgs;
			
			if (mIsLoaded) {
				// call async: to prevent stack growth in certain curcumstances
				setTimeout(onComplete, 1);
				return;
			}
			
			completeCallbackContainer.addCallback(onComplete);
			errorCallbackContainer.addCallback(onError);
			
			if (mIsLoading) {
				return;
			}
			
			mIsLoading = true;
			
			loader = new SoundAssetLoader(mFilePath);
			loader.finishOnFail = true;
			loader.load(onSoundLoad);
			addTrackedLoader(loader);
		}
		
		private function onSoundLoad(loader:SoundAssetLoader):void 
		{
			if (!loader)
				return;
			
			if (loader.failed)
			{
				loader.dispose();
				mIsLoading = false;
				completeCallbackContainer.clear();
				errorCallbackContainer.executeAndClearAllCallbacks(onErrorArgs);
			}
			else 
			{
				mSound = loader.getSound();
				SoundAS.addSound(mName, mSound);
				mIsLoaded = true;
				mIsLoading = false;
				errorCallbackContainer.clear();
				completeCallbackContainer.executeAndClearAllCallbacks(onCompleteArgs);
			}
			onErrorArgs = null;
			onCompleteArgs = null;
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
				mIsLoading = false;
				loader.dispose();
				loader = null;
				SoundAS.removeSound(mName);
			}
			mIsLoaded = false;
			clearListeners();
		}
		
		public function play(onComplete:Function=null, overwrite:Boolean = false, volume:Number = 1, ownTimeToChange:int = -1):SoundInstance
		{
			var instance:SoundInstance;
	
			if (overwrite)
			{
				instance = SoundAS.getSound(mName);
				if (instance)
				{
					instance.stop();
				}
				
				instance = null;
			}
			
			try {
				if (mIsLoaded == false) {
					load(function():void{
						play(onComplete, overwrite, volume);
					},
					function():void{
						sosTrace("SoundAsset.play error while loading [" + mName + "]", SOSLog.ERROR);;
					});
					return null;
				}
				
				var _timeToChange:uint = ownTimeToChange == -1 ? timeToChange : ownTimeToChange;
				
				if (mType == TYPE_SOUNDTRACK || mType == TYPE_SFX_SOUNDTRACK) {
					return SoundAS.playLoop(mName, baseVolume*volume).fadeFrom(0, baseVolume*volume, _timeToChange);
				} 
				else {
					if (onComplete) {
						instance = SoundAS.playFx(mName, baseVolume * volume);
						instance.onCompleteCallback = function():void {
							instance.onCompleteCallback = null;
							onComplete.call();
						};
						/*instance.soundCompleted.addOnce(function(arg:*):void {
							onComplete.call();
						});*/
					} else {
						instance = SoundAS.playFx(mName, baseVolume*volume);
					}
				}
			} catch (e:Error) {
				// deliberately swallow to avoid overlogging
			}
			
			return instance;
		}
		
		public function stop(immediately:Boolean = false, fadeTime:uint = 1000):void
		{
			if (mIsLoaded) {
				var sound:SoundInstance = SoundAS.getSound(mName);
				if(sound)
					sound.fadeTo(0, immediately ? 0 : fadeTime);
			}
		}
		
		public function get instance():SoundInstance
		{
			return SoundAS.getSound(mName);
		}
		
		public function get isRemovable():Boolean
		{
			return false;
		}
		
		public function toString():String 
		{
			return "[SoundAsset " + mType + "/" + mName + " loaded=" + loaded + "]";
		}
		
		public function setVolume(value:Number, fadeTime:uint = 1000):void 
		{
			if (mIsLoaded) {
				var sound:SoundInstance = SoundAS.getSound(mName);
				if(sound)
					sound.fadeTo(value, fadeTime, false);
			}
		}
		
		public function setProperties(volume:Number, timeToChange:int = 4000):SoundAsset
		{
			this.baseVolume = volume;
			this.timeToChange = timeToChange;
			return this;
		}
		
		/* INTERFACE com.alisacasino.bingo.assets.IAsset */
		
		public function get loaded():Boolean 
		{
			return mIsLoaded;
		}
		
		public function get uri():String
		{
			return mFilePath;
		}
		
		public static const SfxButton:SoundAsset = new SoundAsset("button", TYPE_SFX);
		public static const SfxMark:SoundAsset = new SoundAsset("mark", TYPE_SFX);
		public static const SfxScratchCardScratch:SoundAsset = new SoundAsset("scratch_card_scratch", TYPE_SFX);
		public static const SfxScratchCardTryAgain:SoundAsset = new SoundAsset("scratch_card_try_again", TYPE_SFX);
		public static const SfxScratchCardLogo:SoundAsset = new SoundAsset("scratch_card_logo", TYPE_SFX);
		public static const SfxScratchCardWin:SoundAsset = new SoundAsset("scratch_card_win", TYPE_SFX);
		
		public static const AvatarsChangeX1:SoundAsset 			= new SoundAsset("avatars_change_x1", TYPE_SFX);
		public static const AvatarsChangeX2:SoundAsset 			= new SoundAsset("avatars_change_x2", TYPE_SFX);
		public static const AvatarsChangeX3:SoundAsset 			= new SoundAsset("avatars_change_x3", TYPE_SFX);
		public static const AvatarsChangeX4:SoundAsset 			= new SoundAsset("avatars_change_x4", TYPE_SFX);
		public static const AvatarsChangeX5:SoundAsset 			= new SoundAsset("avatars_change_x5", TYPE_SFX);
		public static const ButtonClick:SoundAsset 	   			= new SoundAsset("button_click", TYPE_SFX);
		public static const CardsRoll:SoundAsset 				= new SoundAsset("cards_roll", TYPE_SFX);
		public static const CashStore:SoundAsset 				= new SoundAsset("cash_store", TYPE_SFX);
		public static const ChestActivate:SoundAsset 			= new SoundAsset("chest_activate", TYPE_SFX);
		public static const ChestClickHit:SoundAsset 			= new SoundAsset("chest_click_hit", TYPE_SFX);
		public static const ChestClickWindowPopUp:SoundAsset 	= new SoundAsset("chest_click_window_popup", TYPE_SFX);
		public static const ChestDropV2:SoundAsset 				= new SoundAsset("chest_drop_v2", TYPE_SFX);
		public static const LeaderboardFrameHit:SoundAsset 		= new SoundAsset("leaderboard_frame_hit", TYPE_SFX);
		public static const LeaderboardFrameMoveLoop:SoundAsset = new SoundAsset("leaderboard_frame_move_loop", TYPE_SFX);
		public static const LeaderboardWindowMoveDown:SoundAsset= new SoundAsset("leaderboard_window_move_down", TYPE_SFX);
		public static const NumberMarkV3:SoundAsset 			= new SoundAsset("number_mark_v3", TYPE_SFX);
		public static const OpenChestChestOpen:SoundAsset 		= new SoundAsset("open_chest_chest_open", TYPE_SFX);
		public static const OpenChestChestReopen:SoundAsset 	= new SoundAsset("open_chest_chest_reopen", TYPE_SFX);
		public static const OpenChestCollectionCard:SoundAsset 	= new SoundAsset("open_chest_collection_card", TYPE_SFX);
		public static const OpenChestJingleLoop:SoundAsset 		= new SoundAsset("open_chest_jingle_loop", TYPE_SFX_SOUNDTRACK).setProperties(1, 4000);
		public static const OpenChestResourcesCard:SoundAsset 	= new SoundAsset("open_chest_resources_card", TYPE_SFX);
		public static const PowerUpActivateLoop:SoundAsset 		= new SoundAsset("power_up_activate_loop", TYPE_SFX);
		public static const PowerUpClaimV3:SoundAsset 			= new SoundAsset("power_up_claim_v3", TYPE_SFX);
		public static const PowerUpDoubleDaubV4:SoundAsset 		= new SoundAsset("power_up_double_daub_v4", TYPE_SFX);
		public static const PowerUpDropV3:SoundAsset 			= new SoundAsset("power_up_drop_v3", TYPE_SFX);
		public static const PowerUpFill:SoundAsset 				= new SoundAsset("power_up_fill", TYPE_SFX);
		public static const PowerUpReset:SoundAsset 			= new SoundAsset("power_up_reset", TYPE_SFX);
		public static const PowerUpStore:SoundAsset 			= new SoundAsset("power_up_store", TYPE_SFX);
		public static const RoundResultsBingosPopup:SoundAsset 	= new SoundAsset("round_results_bingos_popup", TYPE_SFX);
		public static const RoundResultsCashPopup:SoundAsset 	= new SoundAsset("round_results_cash_popup", TYPE_SFX);
		public static const RoundResultsChests:SoundAsset 		= new SoundAsset("round_results_chests", TYPE_SFX);
		public static const RoundResultsCount:SoundAsset 		= new SoundAsset("round_results_count", TYPE_SFX);
		public static const RoundResultsLightningPopup:SoundAsset = new SoundAsset("round_results_lightning_popup", TYPE_SFX);
		public static const RoundResultsPopup:SoundAsset 		= new SoundAsset("round_results_popup", TYPE_SFX);
		public static const RoundResultsRankPointsHitV2:SoundAsset = new SoundAsset("round_results_rank_points_hit_v2", TYPE_SFX);
		public static const RoundResultsRewardsPopup:SoundAsset = new SoundAsset("round_results_rewards_popup", TYPE_SFX);
		public static const RoundResultsXpBar:SoundAsset 		= new SoundAsset("round_results_xp_bar", TYPE_SFX);
		public static const RoundResultsXpNumbers:SoundAsset 	= new SoundAsset("round_results_xp_numbers", TYPE_SFX);
		
		public static const BadBingoClose:SoundAsset 			= new SoundAsset("bad_bingo_close", TYPE_SFX);
		public static const BadBingoOpen:SoundAsset 			= new SoundAsset("bad_bingo_open", TYPE_SFX);
		public static const BadBingoTimer:SoundAsset 			= new SoundAsset("bad_bingo_timer", TYPE_SFX);
		public static const Bingo:SoundAsset 					= new SoundAsset("bingo", TYPE_SFX);
		public static const CardShowV2:SoundAsset 				= new SoundAsset("card_show_v2", TYPE_SFX);
		public static const CardShutter:SoundAsset 				= new SoundAsset("card_shutter", TYPE_SFX);
		public static const CardToCollections:SoundAsset 		= new SoundAsset("card_to_collections", TYPE_SFX);
		public static const CashBonus:SoundAsset 				= new SoundAsset("cash_bonus", TYPE_SFX);
		public static const RoundResultsChestsV3:SoundAsset 	= new SoundAsset("round_results_chests_v3", TYPE_SFX);
		public static const RoundResultsLevelUpJingle:SoundAsset= new SoundAsset("round_results_level_up_jingle", TYPE_SFX);
		public static const SuperChestJingleLoopV4:SoundAsset 	= new SoundAsset("super_chest_jingle_loop_v4", TYPE_SFX);
		public static const SuperChestRattleV2:SoundAsset 		= new SoundAsset("super_chest_rattle_v2", TYPE_SFX);
		
		public static const X2BoostEnd:SoundAsset 				= new SoundAsset("2x_boost_end", TYPE_SFX);
		public static const X2BoostFireLoop:SoundAsset 			= new SoundAsset("2x_boost_fire_loop", TYPE_SFX);
		public static const X2BoostStart:SoundAsset 			= new SoundAsset("2x_boost_start", TYPE_SFX);
		
		public static const CardBurning:SoundAsset 				= new SoundAsset("card_burning", TYPE_SFX);
		public static const QuestComplete:SoundAsset 			= new SoundAsset("quest_complete", TYPE_SFX);
		
		public static const CardsBoostX2:SoundAsset 			= new SoundAsset("cards_boost_x2", TYPE_SFX);
		public static const CardsBoostX3:SoundAsset 			= new SoundAsset("cards_boost_x3", TYPE_SFX);
		public static const CardsBoostX5:SoundAsset 			= new SoundAsset("cards_boost_x5", TYPE_SFX);
		public static const CatMoto:SoundAsset 					= new SoundAsset("cat_moto", TYPE_SFX);
		public static const CatMotoNoMeow:SoundAsset 			= new SoundAsset("cat_moto_no_meow", TYPE_SFX);
		
		public static const MarksFly_01:SoundAsset 				= new SoundAsset("marks_fly_01", TYPE_SFX);
		public static const MarksFly_02:SoundAsset 				= new SoundAsset("marks_fly_02", TYPE_SFX);
		public static const MarksFly_03:SoundAsset 				= new SoundAsset("marks_fly_03", TYPE_SFX);
		public static const MarksFly_04:SoundAsset 				= new SoundAsset("marks_fly_04", TYPE_SFX);
		
		
		public static const SlotsAppear:SoundAsset 				= new SoundAsset("slots_appear", TYPE_SFX);
		public static const SlotsReelAnticipation:SoundAsset 	= new SoundAsset("slots_reel_anticipation", TYPE_SFX);
		public static const SlotsSimpleWin:SoundAsset 			= new SoundAsset("slots_simple_win", TYPE_SFX);
		public static const SlotsSpinReel:SoundAsset 			= new SoundAsset("slots_spin_reel", TYPE_SFX);
		public static const SlotsReelSpin_01:SoundAsset 		= new SoundAsset("slots_reel_spin_01", TYPE_SFX);
		public static const SlotsReelSpin_02:SoundAsset 		= new SoundAsset("slots_reel_spin_02", TYPE_SFX);
		public static const SlotsReelSpin_03:SoundAsset 		= new SoundAsset("slots_reel_spin_03", TYPE_SFX);
		public static const SlotsReelSpin_04:SoundAsset 		= new SoundAsset("slots_reel_spin_04", TYPE_SFX);
		public static const SlotsReelSpin_05:SoundAsset 		= new SoundAsset("slots_reel_spin_05", TYPE_SFX);
		public static const SlotsReelSpin_06:SoundAsset 		= new SoundAsset("slots_reel_spin_06", TYPE_SFX);
		public static const SlotsReelStop_01:SoundAsset 		= new SoundAsset("slots_reel_stop_01", TYPE_SFX);
		public static const SlotsReelStop_02:SoundAsset 		= new SoundAsset("slots_reel_stop_02", TYPE_SFX);
		public static const SlotsReelStop_03:SoundAsset 		= new SoundAsset("slots_reel_stop_03", TYPE_SFX);
		public static const SlotsFireBurning:SoundAsset 		= new SoundAsset("slots_fire_burning", TYPE_SFX);
		public static const SlotsHeavensGates:SoundAsset 		= new SoundAsset("slots_heavens_gates", TYPE_SFX);
		public static const SlotsWinCompleted:SoundAsset 		= new SoundAsset("slots_win_completed", TYPE_SFX);
		public static const SlotsWinJingle:SoundAsset 			= new SoundAsset("slots_win_jingle", TYPE_SFX);
		public static const SlotsWinStart:SoundAsset 			= new SoundAsset("slots_win_start", TYPE_SFX);
		public static const SlotsBetChange:SoundAsset 			= new SoundAsset("slots_bet_change", TYPE_SFX);
		public static const SlotsAngelFreeSpinsMusic:SoundAsset = new SoundAsset("slots_angel_free_spins_music", TYPE_SFX);
		public static const SlotsDevilFreeSpinsMusic:SoundAsset = new SoundAsset("slots_devil_free_spins_music", TYPE_SFX);
		public static const SlotsCatMeow_1:SoundAsset 			= new SoundAsset("slots_cat_meow_1", TYPE_SFX);
		public static const SlotsCatMeow_2:SoundAsset 			= new SoundAsset("slots_cat_meow_2", TYPE_SFX);
		public static const SfxPlayerBingoed01:SoundAsset = new SoundAsset("player_bingoed01", TYPE_SFX);
		
	}
}
