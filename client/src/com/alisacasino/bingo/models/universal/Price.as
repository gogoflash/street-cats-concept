package com.alisacasino.bingo.models.universal 
{
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.utils.TypeParser;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class Price 
	{
		public var priceType:int = -1;
		public var price:Number = 0;
		public var isFree:Boolean;
		
		public function Price(priceType:int, price:Number) 
		{
			this.priceType = priceType;
			this.price = price;
		}
		
		public function parse(raw:Object):void
		{
			if (!raw)
				return;
			
			price = 'price' in raw ? Math.max(0, parseFloat(raw['price'])) : 0;	
			if ('priceType' in raw)	{
				priceType = TypeParser.parseFromString(raw['priceType']);
				isFree = raw['priceType'] == TypeParser.FREE;
			}
			else {
				priceType = Type.REAL;
			}
		}
		
		public function getPriceTypeString():String
		{
			switch(priceType)
			{
				default:
					return "unknown";
				case Type.DUST:
					return "dust";
				case Type.CASH:
					return "cash";
				case Type.REAL:
					return "real";
			}
		}
		
	}

}