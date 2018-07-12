package com.alisacasino.bingo.commands.dialogCommands 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.player.UpdateLobbyBarsTrueValue;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.skinning.CustomizerItemBase;
	import com.alisacasino.bingo.screens.inventoryScreenClasses.ICardData;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNACardBurnEvent;
	
	public class BurnCardCommand extends CommandBase 
	{
		private var card:ICardData;
		private var exchangeValue:int;
		private var callBarsUpdate:Boolean;
		
		public function BurnCardCommand(card:ICardData, exchangeValue:int, callBarsUpdate:Boolean = false)
		{
			super();
			this.card = card;
			this.exchangeValue = exchangeValue;
			this.callBarsUpdate = callBarsUpdate;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			if (exchangeValue <= 0)
				return;
			
			var dustTotal:int = exchangeValue * card.dustGain;
			Player.current.reservedDustCount += dustTotal;
			Player.current.updateDustCount(dustTotal, "cardBurn:" + card.type);
			
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNACardBurnEvent(card, exchangeValue));
			
			card.changeQuantity( -exchangeValue);
			
			gameManager.questModel.cardBurned(card, exchangeValue);
			
			Game.connectionManager.sendPlayerUpdateMessage();
			
			if(card is CustomizerItemBase)
				gameManager.skinningData.hadleBurnSelected(card as CustomizerItemBase);
			
			if(callBarsUpdate)
				new UpdateLobbyBarsTrueValue(0.5).execute();
		}	
	}

}