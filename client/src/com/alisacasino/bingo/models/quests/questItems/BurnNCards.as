package com.alisacasino.bingo.models.quests.questItems 
{
	import com.alisacasino.bingo.models.collections.CollectionItem;
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.protocol.QuestDataMessage;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.ICardData;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class BurnNCards extends QuestBase
	{
		static public const CUSTOMIZER:String = "customizer";
		static public const COLLECTION:String = "collection";
		static public const ANY:String = "any";
		
		private var cardType:String;
		
		public function BurnNCards() 
		{
			
		}
		
		/*
		schemas:
		[cardType:String]
		collection or customizer
		*/
		override public function deserialize(message:QuestDataMessage):void 
		{
			super.deserialize(message);
			var options:Array = parseOptions(message.options);
			cardType = options.length > 0 ? String(options[0]) : ANY;
		}
		
		override public function cardBurned(card:ICardData, quantity:int):void 
		{
			super.cardBurned(card, quantity);
			
			if (cardType != ANY)
			{
				if (card is CustomizerItemBase && cardType != CUSTOMIZER)
					return;
				
				if (card is CollectionItem && cardType != COLLECTION)
					return;
			}
			
			updateProgress(quantity);
		}
		
	}

}