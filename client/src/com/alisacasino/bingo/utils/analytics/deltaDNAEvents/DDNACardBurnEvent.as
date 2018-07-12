package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	import com.alisacasino.bingo.models.collections.CollectionItem;
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.ICardData;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNACardBurnEvent extends DDNAEvent
	{
		
		public function DDNACardBurnEvent(card:ICardData, quantity:int) 
		{
			addEventType("cardBurn");
			if (card is CustomizerItemBase)
			{
				addParamsField("cardType", "customizer");
				addParamsField("customizerType", (card as CustomizerItemBase).getTypeStringID());
			}
			else if (card is CollectionItem)
			{
				addParamsField("cardType", "collection");
			}
			else
			{
				addParamsField("cardType", "unknown");
			}
			
			addParamsField("cardID", card.id);
			addParamsField("cardName", card.name);
			addParamsField("cardQuantity", quantity);
			addParamsField("cardDustGain", int(card.dustGain));
			addParamsField("totalDustGain", int(card.dustGain * quantity));
		}
		
	}

}