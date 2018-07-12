package com.alisacasino.bingo.screens.storeWindow.cash 
{
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class BigBlueItem extends SmallBlueItem
	{
		
		public function BigBlueItem() 
		{
			
		}
		
		override protected function getElementWidth():Number 
		{
			return 273 * pxScale;
		}
		
		override protected function getElementHeight():Number 
		{
			return 329 * pxScale;
		}
		
	}

}