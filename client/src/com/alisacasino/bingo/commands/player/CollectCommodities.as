package com.alisacasino.bingo.commands.player 
{
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.powerups.PowerupDropTable;
	import com.alisacasino.bingo.models.universal.CommodityItem;
	import com.alisacasino.bingo.models.universal.CommodityType;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class CollectCommodities extends CommandBase
	{
		public var powerupDropResult:Object;
		private var commodities:Array;
		private var powerupDropTable:PowerupDropTable;
		private var source:String;
		private var lobbyBarsUpdateDelay:Number = 0;
		private var updateLobbyBars:Boolean;
		
		public function CollectCommodities(commodities:Array, source:String, powerupDropTable:PowerupDropTable = null, updateLobbyBars:Boolean = true, lobbyBarsUpdateDelay:Number = 0) 
		{
			this.source = source;
			this.powerupDropTable = powerupDropTable;
			this.commodities = commodities;
			this.lobbyBarsUpdateDelay = lobbyBarsUpdateDelay;
			this.updateLobbyBars = updateLobbyBars;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			var item:Object;
			for each (item in commodities) 
			{
				var collectCommodityItem:CollectCommodityItem = new CollectCommodityItem(new CommodityItem(CommodityType.getTypeByCommodityItemMessageType(item.type), item.quantity), source, powerupDropTable, false);
				collectCommodityItem.execute();
				
				if (collectCommodityItem.powerupDropResult)
				{
					powerupDropResult = collectCommodityItem.powerupDropResult; //not handling multiple powerup messages right now
				}
			}
			
			if(updateLobbyBars)
				new UpdateLobbyBarsTrueValue(lobbyBarsUpdateDelay).execute();
			
			finish();
		}
		
	}

}