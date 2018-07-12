package com.alisacasino.bingo.models.scratchCard 
{
	import com.alisacasino.bingo.protocol.ScratchLotteryDataMessage;
	import com.alisacasino.bingo.protocol.ScratchWeightMessage;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ScratchResultChanceTable 
	{
		public var name:String;
		public var price:int;
		private var _weightedResults:Vector.<ScratchItem>;
		
		public function get weightedItems():Vector.<ScratchItem> 
		{
			return _weightedResults;
		}
		private var totalWeight:Number;
		
		public function ScratchResultChanceTable() 
		{
			_weightedResults = new Vector.<ScratchItem>();
			totalWeight = 0;
		}
		
		public function parse(dataMessage:ScratchLotteryDataMessage):ScratchResultChanceTable
		{
			if (!dataMessage)
			{
				name = "none";
				addDefaultDistribution();
				sosTrace("No data for scratch card!", SOSLog.FATAL);
			}
			else 
			{
				name = dataMessage.name;
				price = dataMessage.price;
				parseWeightTable(dataMessage.weights);
			}
			return this;
		}
		
		private function parseWeightTable(weights:Array):void 
		{
			totalWeight = 0;
			for each (var weightMessage:ScratchWeightMessage in weights) 
			{
				addWeightedResult(new ScratchItem(weightMessage.prizeQuantity, weightMessage.multiplier, weightMessage.weight));
			}
		}
		
		private function addDefaultDistribution():void 
		{
			addWeightedResult(new ScratchItem(0, 0, 1));
			addWeightedResult(new ScratchItem(1, 1, 1));
			addWeightedResult(new ScratchItem(2, 1, 1));
			addWeightedResult(new ScratchItem(3, 1, 1));
			addWeightedResult(new ScratchItem(4, 1, 1));
			addWeightedResult(new ScratchItem(5, 1, 1));
		}
		
		private function addWeightedResult(scratchItem:ScratchItem):void 
		{
			weightedItems.push(scratchItem);
			totalWeight += scratchItem.weight;
		}
		
		public function getRandomResult():ScratchItem
		{
			var randomNumber:Number = Math.random() * totalWeight;
			//sosTrace( "randomNumber : " + randomNumber );
			
			for (var i:int = 0; i < weightedItems.length; i++) 
			{
				var weightedResult:ScratchItem = weightedItems[i];
				if (randomNumber < weightedResult.weight)
				{
					//sosTrace( "weightedResult.template : " + weightedResult.template, SOSLog.DEBUG);
					return weightedResult;
				}
				else
				{
					randomNumber -= weightedResult.weight;
				}
			}
			
			throw new Error("Invalid calculation, shouldn't happen");
			return null;
		}
		
	}

}