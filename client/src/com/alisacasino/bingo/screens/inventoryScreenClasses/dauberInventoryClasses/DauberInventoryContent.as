package com.alisacasino.bingo.screens.inventoryScreenClasses.dauberInventoryClasses 
{
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.protocol.CustomizationType;
	import com.alisacasino.bingo.models.skinning.SkinningDauberData;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.InventoryContentBase;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DauberInventoryContent extends InventoryContentBase
	{
		
		public function DauberInventoryContent() 
		{
			overlayClass = DauberOverlay;
			itemsType = CustomizationType.DAUB_ICON;
		}
		
		override protected function initialize():void 
		{
			var newSource:Vector.<CustomizerItemBase> = new Vector.<CustomizerItemBase>();
			
			for each (var item:SkinningDauberData in gameManager.skinningData.customDaubers) 
			{
				newSource.push(item);
			}
			
			source = newSource;
			
			super.initialize();
		}
		
	}

}