package com.alisacasino.bingo.controls
{
	import com.alisacasino.bingo.assets.SoundAsset;

	public class TicketsLootAnimation extends LootAnimation
	{
		public function TicketsLootAnimation(params:Object)
		{
			params.glow = "loot/ticket_glow";
			params.item = "bars/tickets";
			params.sparkle = "loot/sparkle_blue";
			params.sfx = SoundAsset.SfxTicketsLoot;
			super(params);
		}
		
		public static function getAnimationDuration(value:Number):Number
		{
			if (value == 0)
				return 0;
			else if (value < 16)
				return 1.0;
			else
				return 1.5;
		}
	}
}