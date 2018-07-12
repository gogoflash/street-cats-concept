package com.alisacasino.bingo.models.offers 
{
	public class CardAlignProperties 
	{
		public function CardAlignProperties() {
		}
		
		public var x:int;
		public var y:int;
		public var rotationRadian:Number;
		
		public static function create(x:int, y:int, rotationDegrees:Number):CardAlignProperties
		{
			var item:CardAlignProperties = new CardAlignProperties();
			item.x = x;
			item.y = y;
			item.rotationRadian = rotationDegrees * Math.PI / 180;
			return item;
		}
		
	}

}