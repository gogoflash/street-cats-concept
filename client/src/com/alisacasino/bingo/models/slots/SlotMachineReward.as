package com.alisacasino.bingo.models.slots 
{
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.protocol.ChestType;
	import com.alisacasino.bingo.protocol.SlotMachineStatic;
	
	public class SlotMachineReward 
	{
		public var id:int;
		
		public var name:String;
		
		public var stake:int = 0;
		
		public var weight:int = 0;
		
		public var spinType:String;
		
		public var rewardType:String;
		
		public var placeOnReel:Boolean;
		
		public var isCashReward:Boolean;
		
		private var _commodityItem:CommodityItem;
		
		public function SlotMachineReward() 
		{
			
		}
		
		public function get commodityItem():CommodityItem 
		{
			if (!_commodityItem) 
				_commodityItem = gameManager.slotsModel.getCommodityItemByTypeAndStake(rewardType, stake);
				
			return _commodityItem;	
		}
		
		public static function create(rewardType:String, commodityItem:CommodityItem, weight:Number, name:String = ''):SlotMachineReward
		{
			var item:SlotMachineReward = new SlotMachineReward();
			item.rewardType = rewardType;
			if(commodityItem)
				item._commodityItem = commodityItem;
			item.weight = weight;
			item.name = name;
			return item;
		}
		
		public function parse(raw:SlotMachineStatic):void 
		{
			id = raw.id;
			weight = raw.weight;
			stake = raw.stake;
			spinType = raw.type;
			//commodityItem = SlotMachineRewardType.getCommodityItemByType(raw.winningCombo);
			rewardType = raw.winningCombo;
			
			placeOnReel = rewardType != SlotMachineRewardType.CASH_1 && rewardType != SlotMachineRewardType.NO_WIN;
			isCashReward = SlotMachineRewardType.isCashType(rewardType);
		}
	
	}

}