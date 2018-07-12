package com.alisacasino.bingo.models.sales 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class SaleType 
	{
		
		static public const NO_SALE:String = "no_sale";
		static public const SUPERSALE:String = "supersale";
		static public const BLACK_FRIDAY:String = "black_friday";
		
		static public function anySaleActive(saleType:String):Boolean
		{
			return saleType != NO_SALE;
		}
		
	}

}