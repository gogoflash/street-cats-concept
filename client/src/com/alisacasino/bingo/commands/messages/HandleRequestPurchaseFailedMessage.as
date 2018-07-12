package com.alisacasino.bingo.commands.messages 
{
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.controls.LoadingWheel;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.PurchaseFailedMessage;
	import com.alisacasino.bingo.store.IStoreItem;
	import com.alisacasino.bingo.utils.Settings;
	import com.alisacasino.bingo.utils.analytics.deltaDNAEvents.DDNAStoreTransactionStateEvent;
	
	public class HandleRequestPurchaseFailedMessage extends CommandBase
	{
		private var message:PurchaseFailedMessage;
		
		public function HandleRequestPurchaseFailedMessage(message:PurchaseFailedMessage) 
		{
			this.message = message;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			LoadingWheel.removeIfAny();
			
			gameManager.analyticsManager.sendDeltaDNAEvent(new DDNAStoreTransactionStateEvent(DDNAStoreTransactionStateEvent.PURCHASE_FAILED_ON_SERVER, message.itemId));
			
			var item:IStoreItem = gameManager.storeData.findItemByItemId(message.itemId);
			PlatformServices.store.consumeItem(item);
			
			finish();
		}
		
	}

}