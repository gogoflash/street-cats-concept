package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.SoundAsset;
	
	public class EnergyLootAnimation extends LootAnimation
	{
		public function EnergyLootAnimation(params:Object)
		{
			params.glow = "loot/energy_glow";
			params.item = "bars/energy";
			params.sparkle = "loot/sparkle_yellow";
			params.sfx = SoundAsset.SfxEnergyLoot;
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
