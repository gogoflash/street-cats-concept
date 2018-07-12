package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.SoundAsset;

	public class XpLootAnimation extends LootAnimation
	{
		public function XpLootAnimation(params:Object)
		{
			params.glow = "loot/xp_glow";
			params.item = "bars/exp";
			params.sparkle = "loot/sparkle_yellow";
			params.sfx = SoundAsset.SfxXpLoot;
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
	}
}