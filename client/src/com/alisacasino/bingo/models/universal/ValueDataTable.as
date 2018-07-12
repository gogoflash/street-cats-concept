package com.alisacasino.bingo.models.universal 
{
	public class ValueDataTable 
	{
		public function ValueDataTable(raw:Object = null) 
		{
			values = new <Number>[];
			dataList = {};
			
			parse(raw);
		}
		
		private var values:Vector.<Number>;
		private var dataList:Object;
		private var length:uint;
		
		public function add(value:Number, data:*):void 
		{
			length = values.push(value);
			values.sort(sortAscending);
			dataList[value] = data;
		}
		
		public function parse(raw:Object):void 
		{
			if (!raw)
				return;
				
			for (var key:String in raw) {
				length = values.push(parseFloat(key));
				dataList[values[length - 1]] = raw[key];
			}
			
			values.sort(sortAscending);
		}
		
		public function getData(value:Number):*
		{
			if (values.length == 0)
				return null;
			
			var i:uint;
			for (i = 0; i < length; i++) {
				if (value <= values[i])
					return dataList[values[i]];
			}
			
			return dataList[values[length-1]];
		}
		
		private function sortAscending(a:Number, b:Number):int
		{
			return a - b;
		}
		
		private function sortDescending(a:Number, b:Number):int
		{
			return b - a;
		}	
	}

}