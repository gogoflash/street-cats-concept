package com.alisacasino.bingo.commands.gameLoading 
{
	import com.alisacasino.bingo.assets.SoundAsset;
	import com.alisacasino.bingo.assets.loading.AssetQueue;
	import com.alisacasino.bingo.commands.ICommand;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.utils.sounds.SoundLoadAssetQueue;
	import com.alisacasino.bingo.utils.sounds.SoundManager;
	import starling.core.Starling;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class LoadSoundsAndAnimations extends CommandBase
	{
		
		public function LoadSoundsAndAnimations() 
		{
			
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			SoundManager.instance.soundLoadQueue = new SoundLoadAssetQueue();
			SoundManager.instance.soundLoadQueue.loadFullList(onComplete);
		}
		
		private function onComplete():void 
		{
			finish();
		}
		
	}

}