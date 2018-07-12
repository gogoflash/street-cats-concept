package com.alisacasino.bingo.screens.inventoryScreenClasses.voiceoverInventoryClasses 
{
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.protocol.CustomizationType;
	import com.alisacasino.bingo.models.skinning.VoiceoverData;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.InventoryContentBase;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.InventoryOverlayBase;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class VoiceoverInventoryContent extends InventoryContentBase 
	{
		
		public function VoiceoverInventoryContent() 
		{
			overlayClass = InventoryOverlayBase;
			itemsType = CustomizationType.VOICEOVER;
		}
		
		override protected function initialize():void 
		{
			
			var newSource:Vector.<CustomizerItemBase> = new Vector.<CustomizerItemBase>();
			
			for each (var item:VoiceoverData in gameManager.skinningData.customVoiceovers) 
			{
				newSource.push(item);
			}
			
			source = newSource;
			
			super.initialize();
		}
		
	}

}