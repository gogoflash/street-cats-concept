package com.alisacasino.bingo.commands.messages 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.models.roomClasses.RoomType;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.EventPrizeMessage;
	import com.alisacasino.bingo.protocol.PrizeItemMessage;
	import com.alisacasino.bingo.protocol.RequestIncomingItemsOkMessage;
	import com.alisacasino.bingo.utils.Constants;
	import com.netease.protobuf.UInt64;
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class HandleRequestIncomingItemsOkMessage extends CommandBase
	{
		private var message:RequestIncomingItemsOkMessage;
		
		public function HandleRequestIncomingItemsOkMessage(message:RequestIncomingItemsOkMessage) 
		{
			this.message = message;
		}
		
		override protected function startExecution():void 
		{
			super.startExecution();
			
			if (!message)
			{
				sosTrace( "No message passed to HandleRequestIncomingItemsOkMessage : " + message, SOSLog.WARNING);
				finish();
				return;
			}
			
			gameManager.giftsModel.deserializeUnacceptedGifts(message.gifts);
			
			finish();
		}
		
		private function createDebugEventPrizes(roomTypeName:String):EventPrizeMessage
		{
			var eventPrizeMessage:EventPrizeMessage = new EventPrizeMessage();
			eventPrizeMessage.eventId = int(Math.random() * int.MAX_VALUE);
			eventPrizeMessage.roomType = roomTypeName;
			eventPrizeMessage.place = int(Math.random() * 100);
			eventPrizeMessage.score = int(Math.random() * 1000);
			
			var prizeItem:PrizeItemMessage = new PrizeItemMessage();
			prizeItem.id = UInt64.fromNumber(Math.random() * uint.MAX_VALUE);
			prizeItem.payload = [];
			var prizeItemsNum:int = 3;
			for (var i:int = 0; i < prizeItemsNum; i++) 
			{
				var commodityItem:CommodityItemMessage = new CommodityItemMessage();
				commodityItem.type = int(Math.random() * 4);
				commodityItem.quantity = int(Math.random() * 10 + 5);
				sosTrace( "commodityItem.quantity : " + commodityItem.quantity );
				prizeItem.payload.push(commodityItem);
			}
			eventPrizeMessage.prizePayload = prizeItem;
			return eventPrizeMessage;
		}
		
	}

}