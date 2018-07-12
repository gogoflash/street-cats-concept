package com.alisacasino.bingo.dialogs.slots 
{
	import com.alisacasino.bingo.models.slots.SlotMachineReward;
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class SlotMachineRewardView extends Image 
	{
		public var reward:SlotMachineReward;
		
		public function SlotMachineRewardView(texture:Texture) 
		{
			super(texture);
		}
		
	}

}