package com.alisacasino.bingo.utils 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.models.collections.Collection;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.gifts.AccumulatedGiftContents;
	import com.alisacasino.bingo.models.roomClasses.RoomType;
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import com.alisacasino.bingo.models.universal.CommodityType;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class DevUtils 
	{
		private var game:Game;
		
		public function DevUtils(game:Game) 
		{
			this.game = game;
		}
		
		public function runChecks():void 
		{
			
			//countGifts();
		}
		
		public function listRoomsAndItems():void 
		{
			var output:Object = {};
			
			sosTrace("Serialized room info : \n" + JSON.stringify(output));
		}
		
		private function countGifts():void
		{
			var accumulatedGiftContents:AccumulatedGiftContents = new AccumulatedGiftContents();
			
			for (var i:int = 0; i < 10000; i++) 
			{
				for (var j:int = 0; j < 80; j++) 
				{
					//var generatedGift:Object = GiftGenerationStrategy.generateGift(j);
					/*
					accumulatedGiftContents.addCommodityByType(CommodityType.TICKET, generatedGift["ticketsWon"]);
					accumulatedGiftContents.addCommodityByType(CommodityType.CASH, generatedGift["coinsWon"]);
					accumulatedGiftContents.addCommodityByType(CommodityType.ENERGY, generatedGift["energyWon"]);
					accumulatedGiftContents.addCommodityByType(CommodityType.KEY, generatedGift["keysWon"]);
					accumulatedGiftContents.addCommodityByType(CommodityType.SLOT_MACHINE_GIFT_SPIN, generatedGift["spinsWon"]);
					*/
				}
			}
			
			sosTrace( "accumulatedGiftContents.contents : " + accumulatedGiftContents.contents, SOSLog.DEBUG);
			for each (var item:CommodityItem in accumulatedGiftContents.contents) 
			{
				sosTrace(item.type + " : " + Number(item.quantity/10000).toFixed(2), SOSLog.DEBUG);
			}
		}
		
		public function countMagicboxes():void
		{
			
		}
		
		private static var nextValuesCache:Object = {};
		
		public static function getNextValue(id:String, values:Array, startIndex:int = 0):* 
		{
			if (nextValuesCache[id] != null) 
			{
				nextValuesCache[id]++;
				if (nextValuesCache[id] >= values.length)
					nextValuesCache[id] = 0;
				
				return values[nextValuesCache[id]];	
			}
			
			nextValuesCache[id] = startIndex;
			return values[startIndex];
		}
	}

}