package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.SoundAsset;

	public class CoinsLootAnimation extends LootAnimation
	{
		public function CoinsLootAnimation(params:Object)
		{
			params.glow = "loot/coin_glow";
			params.item = "bars/cash";
			params.sparkle = "loot/sparkle_yellow";
			params.sfx = SoundAsset.SfxCoinsLoot;
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