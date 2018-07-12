package com.alisacasino.bingo.screens.inventoryScreenClasses.cardBackInventoryClasses 
{
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.protocol.CustomizationType;
	import com.alisacasino.bingo.models.skinning.SkinningCardData;
	import com.alisacasino.bingo.protocol.CustomizationType;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.InventoryContentBase;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.InventoryOverlayBase;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CardBackInventoryContent extends InventoryContentBase
	{
		
		public function CardBackInventoryContent() 
		{
			overlayClass = InventoryOverlayBase;
			itemsType = CustomizationType.CARD;
		}
		
		override protected function initialize():void 
		{
			var newSource:Vector.<CustomizerItemBase> = new Vector.<CustomizerItemBase>();
			
			
			for each (var item:SkinningCardData in gameManager.skinningData.customCardBacks) 
			{
				newSource.push(item);
			}
			
			source = newSource;
			
			super.initialize();
		}
		
	}

}