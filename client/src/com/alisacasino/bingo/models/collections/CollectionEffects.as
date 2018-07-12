package com.alisacasino.bingo.models.collections 
{
	import com.alisacasino.bingo.protocol.ModificatorMessage;
	import com.alisacasino.bingo.protocol.ModificatorType;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CollectionEffects 
	{
		public var cashBonusPercentMod:int = 0;
		public var cardDiscountPercentMod:int = 0;
		public var xpPercentMod:int = 0;
		public var scorePercentMod:int = 0;
		
		public function get cashBonusMod():Number
		{
			return 1 + cashBonusPercentMod / 100;
		}
		
		public function get cardDiscountMod():Number
		{
			return 1 - cardDiscountPercentMod / 100;
		}
		
		public function get xpMod():Number
		{
			return 1+ xpPercentMod / 100;
		}
		
		public function get scoreMod():Number
		{
			return 1 + scorePercentMod / 100;
		}
		
		public function CollectionEffects() 
		{
			reset();
		}
		
		public function reset():void 
		{
			cashBonusPercentMod = 0;
			cardDiscountPercentMod = 0;
			xpPercentMod = 0;
			scorePercentMod = 0;
		}
		
		public function applyEffect(permanentEffect:ModificatorMessage):void 
		{
			switch(permanentEffect.type)
			{
				case ModificatorType.CASH_MOD:
					cashBonusPercentMod += permanentEffect.quantity;
					break;
				case ModificatorType.DISCOUNT_MOD:
					cardDiscountPercentMod += permanentEffect.quantity;
					break;
				case ModificatorType.EXP_MOD:
					xpPercentMod += permanentEffect.quantity;
					break;
				case ModificatorType.SCORE_MOD:
					scorePercentMod += permanentEffect.quantity;
					break;
			}
		}
		
	}

}