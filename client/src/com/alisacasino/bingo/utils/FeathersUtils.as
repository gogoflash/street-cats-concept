package com.alisacasino.bingo.utils 
{
	import feathers.data.ListCollection;
	
	public class FeathersUtils 
	{
        public static function refreshList(listCollection:ListCollection):void
		{
			if (!listCollection || listCollection.length == 0)
				return;
			
			var i:int;
			var length:int = listCollection.length;
			for (i = 0; i < length; i++) {
				listCollection.updateItemAt(i);
			}
		}
		
		
	}

}