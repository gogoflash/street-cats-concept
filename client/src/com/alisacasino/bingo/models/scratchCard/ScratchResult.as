package com.alisacasino.bingo.models.scratchCard 
{
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.utils.GameManager;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ScratchResult 
	{
		private var _reward:CommodityItem;
		
		public function get reward():CommodityItem 
		{
			return _reward;
		}
		
		public var primeItem:ScratchItem;
		
		public var results:Vector.<ScratchCell>;
		private var repeatsByItem:Dictionary;
		private var allPossibleItems:Vector.<ScratchItem>;
		private var multipliedItems:Vector.<ScratchItem>;
		private var neededMultipliers:Vector.<int>;
		public var cardType:String;
		
		public function ScratchResult(cardType:String) 
		{
			this.cardType = cardType;
		}
		
		public function generateFromItem(primeItem:ScratchItem, allItems:Vector.<ScratchItem>):ScratchResult 
		{
			this.primeItem = primeItem;
			
			var i:int;
			
			
			results = new Vector.<ScratchCell>(9);
			neededMultipliers = new Vector.<int>();
			
			_reward = new CommodityItem(CommodityType.CASH, primeItem.winningQuantity * primeItem.multiplier);
			
			repeatsByItem = new Dictionary();
			multipliedItems = new Vector.<ScratchItem>();
			
			var squareNumbers:Array = [];
			for (i = 0; i < 9; i++) 
			{
				squareNumbers.push(i);
			}
			
			if (primeItem.winningQuantity > 0)
			{
				var toInsert:int = 3;
				if (primeItem.multiplier > 1)
				{
					insertItem(primeItem, getRandomSquare(squareNumbers), primeItem.multiplier);
					toInsert = 2;
				}
				for (var j:int = 0; j < toInsert; j++) 
				{
					insertItem(primeItem, getRandomSquare(squareNumbers), 1);
				}
			}
			
			allPossibleItems = new Vector.<ScratchItem>();
			for each (var item:ScratchItem in allItems) 
			{
				//Skip all items that are equal to our winning combo in quantity (digits on cell, basically) and no win case.
				if (item.winningQuantity == primeItem.winningQuantity || item.winningQuantity == 0)
					continue;
				
				
				if (item.multiplier > 1 && item.multiplier != primeItem.multiplier)
				{
					if (neededMultipliers.indexOf(item.multiplier) == -1)
					{
						neededMultipliers.push(item.multiplier);
					}
					
					//As this list is only used to place random cells, and multipliers have no effect, we need unique winnings values only.
				}
				
				var canAdd:Boolean = true;
				for each (var alreadyAddedItem:ScratchItem in allPossibleItems)
				{
					if (alreadyAddedItem.winningQuantity == item.winningQuantity)
					{
						canAdd = false;
						break;
					}
				}
				
				if (!canAdd)
					continue;
				
				allPossibleItems.push(item);
			}
			
			while (squareNumbers.length)
			{
				insertRandomItemExcluding(primeItem, getRandomSquare(squareNumbers));
			}
			
			return this;
		}
		
		private function insertItem(primeItem:ScratchItem, squareNumber:int, multiplier:int):void 
		{
			results[squareNumber] = new ScratchCell(primeItem, multiplier);
		}
		
		private function getRandomSquare(squareNumbers:Array):int 
		{
			return squareNumbers.splice(int(Math.random() * squareNumbers.length), 1)[0];
		}
		
		private function insertRandomItemExcluding(exclusion:ScratchItem, squareNumber:int):void
		{
			var randomItem:ScratchItem = getRandomItemWithExclusion(exclusion, 2);
			
			var multiplier:int = 1;
			if (neededMultipliers.length)
			{
				if (multipliedItems.indexOf(randomItem) == -1)
				{
					multipliedItems.push(randomItem);
					multiplier = neededMultipliers.pop();
				}
			}
			
			insertItem(randomItem, squareNumber, multiplier);
			
		}
		
		private function getRandomItemWithExclusion(exclusion:ScratchItem, maxRepeat:int):ScratchItem
		{
			var possibleItems:Vector.<ScratchItem> = allPossibleItems.concat();
			var excludedItemIndex:int = possibleItems.indexOf(exclusion);
			
			if (excludedItemIndex != -1)
			{
				possibleItems.splice(excludedItemIndex, 1);
			}
			
			var i:int = possibleItems.length;
			sosTrace( "possibleItems.length : " + possibleItems.length, SOSLog.DEBUG);
			while (i--)
			{
				if (repeatsByItem[possibleItems[i]] >= maxRepeat)
				{
					possibleItems.removeAt(i);
				}
			}
			
			
			if (possibleItems.length <= 0)
			{
				throw new Error("No valid items, check your templates");
			}
			
			var randomItem:ScratchItem = possibleItems[int(Math.random() * possibleItems.length)];
			sosTrace( "randomItem : " + randomItem );
			
			repeatsByItem[randomItem] = int(repeatsByItem[randomItem]) + 1;			
			
			return randomItem;
		}
		
		public function toString():String 
		{
			return "[ScratchResult reward=" + reward + " primeItem=" + primeItem + "]";
		}
	}

}