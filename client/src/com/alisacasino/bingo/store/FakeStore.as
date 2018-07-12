package com.alisacasino.bingo.store
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.messages.HandlePurchaseOkMessage;
	import com.alisacasino.bingo.controls.LoadingWheel;
	import com.alisacasino.bingo.dialogs.ServiceDialog;
	import com.alisacasino.bingo.models.Player;
	import com.alisacasino.bingo.models.offers.OfferManager;
	import com.alisacasino.bingo.platform.PlatformServices;
	import com.alisacasino.bingo.protocol.PurchaseOkMessage;
	import com.alisacasino.bingo.screens.IScreen;
	import com.alisacasino.bingo.screens.storeWindow.StoreScreen;
	import com.alisacasino.bingo.utils.Constants;
	import starling.core.Starling;
	
	import flash.utils.setTimeout;

	public class FakeStore implements IStore
	{
		private static var sInstance:FakeStore = null;
		
		public static function get instance():FakeStore
		{
			if (sInstance == null) {
				sInstance = new FakeStore();
			}
			return sInstance;
		}
		
		public function init():void
		{
		}
		
		public function purchaseItem(item:IStoreItem):void
		{
			trace("FakeStore::requestItem " + item);
			
			if(ServiceDialog.DEBUG_PAYMENTS && Constants.isDevBuild)
				requestCompleted(item);
		}
		
		public function consumeItem(item:IStoreItem):void
		{
			trace("FakeStore::consumeItem ", item);
		}
		
		
		/* INTERFACE com.alisacasino.bingo.store.IStore */
		
		public function get lastPurchaseReceiptObject():Object 
		{
			return null;
		}
		
		private function requestCompleted(item:IStoreItem, delay:Number = 0.5):void
		{
			var purchaseOkMessage:PurchaseOkMessage = new PurchaseOkMessage();
			purchaseOkMessage.itemId = item.itemId;
			var handleCommand:HandlePurchaseOkMessage = new HandlePurchaseOkMessage(purchaseOkMessage);
			Starling.juggler.delayCall(handleCommand.execute, delay);
		}
		
		public function get appStoreLink():String
		{
			return '';
		}
	}
}