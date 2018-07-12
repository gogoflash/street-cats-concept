package com.alisacasino.bingo.models.chests 
{
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.models.powerups.PowerupModel;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class ChestPowerupPack 
	{
		public var rarity:String;
		public var powerupData:Object;
		public var totalQuantity:int;
		
		public function ChestPowerupPack(rarity:String, powerupData:Object, totalQuantity:int) 
		{
			this.totalQuantity = totalQuantity;
			this.rarity = rarity;
			this.powerupData = powerupData;
		}
		
		public static function create(rarity:String, powerupData:Object):ChestPowerupPack 
		{
			var quantity:int;
			for each(var count:int in powerupData) {
				quantity += count;
			}
			
			return new ChestPowerupPack(rarity, powerupData, quantity);
		}
		
		public static function createByRarityAndCount(rarity:String, count:int):ChestPowerupPack 
		{
			return create(rarity, PowerupModel.createByRarityAndCount(rarity, count));
		}
		
		public function toString():String 
		{
			return "[ChestPowerupPack rarity=" + rarity + " powerupData=[" + SOSLog.objectToString(powerupData) + "] totalQuantity=" + totalQuantity + 
						"]";
		}
		
		public function get cardTexture():String 
		{
			return Powerup.getCardTexture(rarity);
		}
		
		public function get titleTextStyle():XTextFieldStyle
		{
			switch(rarity) {
				case Powerup.RARITY_NORMAL: return XTextFieldStyle.ChestCardTitleGreen;
				case Powerup.RARITY_MAGIC: return XTextFieldStyle.ChestCardTitleBlue;
				case Powerup.RARITY_RARE: return XTextFieldStyle.ChestCardTitleOrange;
			}
			return XTextFieldStyle.ChestCardTitleWhite;
		}
	}

}