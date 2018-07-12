package com.alisacasino.bingo.utils.analytics.deltaDNAEvents 
{
	import com.alisacasino.bingo.models.universal.Price;
	import com.alisacasino.bingo.protocol.Type;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DDNATransactionEvent extends DDNAEvent
	{
		
		public function DDNATransactionEvent() 
		{
			super();
			addEventType("transaction");
		}
		
		protected function addSpentCurrency(type:int, quantity:Number):void 
		{
			var productsSpent:Object = {};
			
			if (type == Type.CASH)
			{
				productsSpent["virtualCurrencies"] = [DDNARewardsHelper.createVirtualCurrencyEventObject(type, quantity)];
			}
			else if (type == Type.DUST)
			{
				productsSpent["virtualCurrencies"] = [DDNARewardsHelper.createVirtualCurrencyEventObject(type, quantity)];
			}
			else if (type == Type.REAL)
			{
				productsSpent["realCurrency"] = DDNARewardsHelper.createRealCurrencyEventObject(quantity);
			}
			
			addParamsField("productsSpent", productsSpent);
		}
		
	}

}