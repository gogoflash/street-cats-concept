package com.alisacasino.bingo.models.slots 
{
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.protocol.ChestType;
	
	public class SlotMachineRewardType 
	{
		public static const FREE_SPINS:String = 'free_spins';
		public static const SUPER_CHEST:String = 'super_chest';
		public static const GOLD_CHEST:String = 'gold_chest';
		public static const INSTABINGO:String = 'instabingo';
		public static const THREE_DAUBS:String = 'three_daubs';
		public static const DUST:String = 'dust';
		public static const VAULTS:String = 'vaults';
		public static const SACKS:String = 'sacks';
		public static const CASES:String = 'cases';
		public static const PACKS:String = 'packs';
		public static const CASH_2:String = 'cash2';
		public static const CASH_1:String = 'cash1';
		public static const NO_WIN:String = 'no_win';
		
		public function SlotMachineRewardType() 
		{
			
		}
		
		public static function getWinType(type:String):String
		{
			switch(type) 
			{
				case VAULTS: 		return SlotMachineWinType.MEGA;
				case SACKS: 		return SlotMachineWinType.MEGA;
				case CASES: 		return SlotMachineWinType.MEGA;
				case PACKS: 		return SlotMachineWinType.BIG;
				case CASH_2: 		return SlotMachineWinType.SIMPLE;
				case CASH_1: 		return SlotMachineWinType.SIMPLE;
				case NO_WIN: 		return SlotMachineWinType.SIMPLE;
				
				case FREE_SPINS: 	return SlotMachineWinType.BIG;
				case SUPER_CHEST: 	return SlotMachineWinType.MEGA;
				case GOLD_CHEST: 	return SlotMachineWinType.MEGA;
				case INSTABINGO: 	return SlotMachineWinType.BIG;
				case THREE_DAUBS: 	return SlotMachineWinType.SIMPLE;
				case DUST: 			return SlotMachineWinType.SIMPLE;
			}
			
			return SlotMachineWinType.SIMPLE;
		}
		
		public static function getName(type:String):String
		{
			switch(type) 
			{
				case FREE_SPINS: 	return 'FREE SPINS!';
				case SUPER_CHEST: 	return 'SUPER CHEST';
				case GOLD_CHEST: 	return 'GOLD CHEST';
				case INSTABINGO: 	return 'INSTANT BINGO';
				case THREE_DAUBS: 	return 'TRIPLE DAUBS';
				case DUST: 			return 'DUST';
				
				case VAULTS: 		
				case SACKS:
				case CASES:
				case PACKS:
				case CASH_2:
				case CASH_1:
				case NO_WIN: 		return 'CASH';
			}
			
			return 'NAME';
		}
		
		public static function getRewardTexture(type:String):String
		{
			var pathPrefix:String = 'slots/prizes/';
			
			switch(type) 
			{
				case FREE_SPINS: 	return pathPrefix + 'free_spins';
				case SUPER_CHEST: 	return pathPrefix + 'chest_super';
				case GOLD_CHEST: 	return pathPrefix + 'chest_gold';
				case INSTABINGO: 	return pathPrefix + 'powerup_bingo';
				case THREE_DAUBS: 	return pathPrefix + 'powerup_triple';
				case DUST: 			return pathPrefix + 'dust';
				
				case VAULTS: 		return pathPrefix + 'cash_save';
				case SACKS:			return pathPrefix + 'cash_bag';
				case CASES:			return pathPrefix + 'cash_case';
				case PACKS:			return pathPrefix + 'cash_sheaf';
				case CASH_2:		return pathPrefix + 'cash_note';
				case CASH_1:		return pathPrefix + 'cash_note';
			}
			
			return '';
		}
	
		public static function getCashAnimateDuration(count:int):Number {
			if (count <= 25)
				return 2;
			else if (count <= 50)
				return 4;
			else if (count <= 100)
				return 4;
			else if (count <= 250)
				return 4;
			else if (count <= 500)
				return 4;
			else if (count <= 1000)
				return 5;
				
			return 10;
		}
		
		public static function isCashType(value:String):Boolean 
		{
			switch(value) 
			{
				case VAULTS:
				case SACKS:
				case CASES:
				case PACKS:
				case CASH_2: 
				case CASH_1: return true;
			}
			
			return false;
		}
		
		private static var _sortedTotalStringTypes:Array;
		
		public static function get sortedTotalStringTypes():Array
		{
			if (!_sortedTotalStringTypes)
				_sortedTotalStringTypes = [CASH_1, DUST, SUPER_CHEST, GOLD_CHEST, INSTABINGO, THREE_DAUBS];
				
			return 	_sortedTotalStringTypes;
		}
		
	}

}