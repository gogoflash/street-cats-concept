package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.SoundAsset;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	
	public class KeysLootAnimation extends LootAnimation
	{
		private var disappearKeysFaster:Boolean;
		
		public function KeysLootAnimation(params:Object)
		{
			params.glow = "loot/key_glow";
			params.item = "bars/key";
			params.sparkle = "loot/sparkle_yellow";
			params.sfx = SoundAsset.SfxEnergyLoot;
			disappearKeysFaster = 'disappearKeysFaster' in params ? params['disappearKeysFaster'] : false;
			super(params);
		}
		
		public static function getAnimationDuration(value:Number):Number
		{
			if (value == 0)
				return 0;
			else if (value < 50)
				return 1.0;
			else
				return 1.5;
		}
		
		override protected function get disappearDelay():Number {
			return disappearKeysFaster ? (600) : super.disappearDelay;
		}
		
		override protected function disappear():void {
			super.disappear();
				
			for (var i:int = 0; i < mItemsCount; i++) {
				Starling.juggler.tween(mItems[i], 0.2, {
					transition: Transitions.EASE_IN_BACK,
					scaleX: 0,
					scaleY: 0,
					alpha: 0
				});
			}
		}
		
		
	}
}
