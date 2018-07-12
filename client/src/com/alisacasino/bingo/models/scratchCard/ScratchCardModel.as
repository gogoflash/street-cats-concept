package com.alisacasino.bingo.models.scratchCard 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.PowerupType;
	import com.alisacasino.bingo.protocol.ScratchLotteryDataMessage;
	import com.alisacasino.bingo.protocol.Type;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAScratchCardTransactionEvent;
	import com.alisacasino.bingo.utils.analytics.events.BuyInGameItemEvent;
	import com.alisacasino.bingo.utils.clientData.ClientDataManager;
	import com.alisacasino.bingo.utils.sharedObjects.SharedObjectManager;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ScratchCardModel extends EventDispatcher
	{
		static public const X20_CARD_TYPE:String = "normal";
		static public const X50_CARD_TYPE:String = "high_rate";
		
		private var _wasShownForPlayer:Boolean;
		
		public function get wasShownForPlayer():Boolean
		{
			return _wasShownForPlayer;
		}
		
		private var _minimumCashCount:int = 100;
		
		public function get minimumCashCount():int
		{
			return _minimumCashCount;
		}
		
		private var chanceTableByType:Object;
		
		public var bonusScratchesLow:int = 0 ;
		public var bonusScratchesHigh:int = 0 ;
		
		
		public function getPricePerScratch(type:String):int 
		{
			if (chanceTableByType[type])
			{
				return (chanceTableByType[type] as ScratchResultChanceTable).price;
			}
			
			sosTrace("Could not find price for scratch card type " + type, SOSLog.ERROR);
			return 0;
		}
		
		public function ScratchCardModel() 
		{
			chanceTableByType = { };
			_wasShownForPlayer = gameManager.clientDataManager.getValue("scratchCardWasShownForPlayer", false);
		}
		
		public function markScratchCardAsShownForPlayer():void
		{
			_wasShownForPlayer = true;
			gameManager.clientDataManager.setValue("scratchCardWasShownForPlayer", true);
		}
		
		private function calculateScratch(cardType:String):ScratchResult
		{
			var chanceTable:ScratchResultChanceTable = chanceTableByType[cardType];
			return new ScratchResult(cardType).generateFromItem(chanceTable.getRandomResult(), chanceTable.weightedItems);
		}
		
		public function deserializeConfig(scratchLotteries:Array, minCashCount:int):void 
		{
			_minimumCashCount = minCashCount;
			
			for each (var item:ScratchLotteryDataMessage in scratchLotteries) 
			{
				var chanceTable:ScratchResultChanceTable = new ScratchResultChanceTable().parse(item);
				chanceTableByType[chanceTable.name] = chanceTable;
			}
		}
		
		public function buyScratchCard(cardType:String):ScratchResult
		{
			if (hasBonusScratch(cardType))
			{
				if (cardType == X20_CARD_TYPE)
				{
					bonusScratchesLow--;
				}
				else if(cardType == X50_CARD_TYPE)
				{
					bonusScratchesHigh--;
				}
				
				gameManager.connectionManager.sendPlayerUpdateMessage();
				gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAScratchCardTransactionEvent(cardType, 0));
			}
			else
			{
				var price:int = getPricePerScratch(cardType);
				Player.current.updateCashCount( -price, "scratchCardBuy");
				Game.connectionManager.sendPlayerUpdateMessage();
				
				gameManager.analyticsManager.sendEvent(new BuyInGameItemEvent("scratchCard", 1, "cash", price));
				gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAScratchCardTransactionEvent(cardType, price));
			}
			
			dispatchEventWith(Event.CHANGE);
			return calculateScratch(cardType);
		}
		
		public function shouldShowScratchCard():Boolean
		{
			return Player.current.cashCount > gameManager.scratchCardModel.minimumCashCount || gameManager.scratchCardModel.wasShownForPlayer;
		}
		
		
		public function addBonusScratch(cardType:String, quantity:int):void 
		{
			if (cardType == X20_CARD_TYPE)
			{
				bonusScratchesLow += quantity;
			}
			else if (cardType == X50_CARD_TYPE)
			{
				bonusScratchesHigh += quantity;
			}
			gameManager.connectionManager.sendPlayerUpdateMessage();
		}
		
		public function addBonusScratchesToAccount(account:Array):void 
		{
			var cim:CommodityItemMessage = new CommodityItemMessage();
			cim.type = Type.MINIGAME;
			cim.powerupType = PowerupType.SCRATCH_LOW;
			cim.quantity = bonusScratchesLow;
			account.push(cim);
			
			cim = new CommodityItemMessage();
			cim.type = Type.MINIGAME;
			cim.powerupType = PowerupType.SCRATCH_HIGH;
			cim.quantity = bonusScratchesHigh;
			account.push(cim);
		}
		
		public function deserializeBonusScratches(account:Array):void 
		{
			bonusScratchesLow = 0;
			bonusScratchesHigh = 0;
			for each (var item:CommodityItemMessage in account) 
			{
				if (item.type == Type.MINIGAME)
				{
					if (item.powerupType == PowerupType.SCRATCH_LOW)
					{
						bonusScratchesLow = item.quantity;
					}
					else if (item.powerupType == PowerupType.SCRATCH_HIGH)
					{
						bonusScratchesHigh = item.quantity;
						
					}
				}
			}
			
			dispatchEventWith(Event.CHANGE);
			//bonusScratchesLow = 3;
			//bonusScratchesHigh = 2;
		}
		
		public function hasBonusScratch(type:String):Boolean
		{
			return ((type == ScratchCardModel.X20_CARD_TYPE) && bonusScratchesLow > 0)
				||  ((type == ScratchCardModel.X50_CARD_TYPE) && bonusScratchesHigh > 0);
		}
		
		public function get totalBonusScratches():int
		{
			return bonusScratchesLow + bonusScratchesHigh;
		}
		
	}

}