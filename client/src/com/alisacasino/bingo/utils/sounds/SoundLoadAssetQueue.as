package com.alisacasino.bingo.utils.sounds 
{
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.assets.loading.AssetQueue;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class SoundLoadAssetQueue extends AssetQueue
	{
		
		public function SoundLoadAssetQueue() 
		{
			super("Sound load asset queue");
		}
		
		public function loadFullList(onComplete:Function):void 
		{
			load(getAllSoundAssets(), onComplete);
		}
		
		public function getAllSoundAssets():Array
		{
			return lobbySounds;
		}
		
		public function prioritizeSlotMachine():void
		{
	//		addToFront(slotSounds);
		}
		
		public function prioritizeCardBuySounds():void
		{
//			addToFront(cardBuySounds);
		}
		
		public function prioritizeScratchCardSounds():void
		{
		//	addToFront(scratchCardSounds);
		}
		
		public function prioritizeRoundSounds():void
		{
			sosTrace( "SoundLoadAssetQueue.prioritizeRoundSounds", SOSLog.FINER);
//			addToFront(roundSounds);
		}
		
		public function getFirstSessionSounds():Array 
		{
			return lobbySounds;
		}
		
		private function addToFront(sounds:Array):void 
		{
			sounds = sounds.concat();
			while (sounds.length)
			{
				assetsToLoad.unshift(sounds.pop());
			}
		}
		
		private const lobbySounds:Array = [
			SoundAsset.ButtonClick,
			SoundAsset.CashBonus,
			SoundAsset.CardsRoll,
			SoundAsset.CashStore,
			SoundAsset.ChestActivate,
			SoundAsset.ChestClickHit,
			SoundAsset.ChestClickWindowPopUp,
			SoundAsset.ChestDropV2,
			SoundAsset.OpenChestChestOpen,
			SoundAsset.OpenChestChestReopen,
			SoundAsset.OpenChestCollectionCard,
			SoundAsset.OpenChestJingleLoop,
			SoundAsset.OpenChestResourcesCard,
			SoundAsset.SuperChestJingleLoopV4,
			SoundAsset.SuperChestRattleV2,
			SoundAsset.CardToCollections,
			SoundAsset.CardBurning,
			SoundAsset.QuestComplete,
			SoundAsset.PowerUpStore,
			SoundAsset.SfxButton, 
			SoundAsset.SfxMark, 
		];
		
	}
		

}