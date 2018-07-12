package com.alisacasino.bingo.commands.dialogCommands 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.ImageAsset;
	import com.alisacasino.bingo.assets.loading.LoadManager;
	import com.alisacasino.bingo.commands.serviceClasses.CommandBase;
	import com.alisacasino.bingo.models.roomClasses.RoomType;
	import com.alisacasino.bingo.protocol.LiveEventInfoOkMessage;
	import com.alisacasino.bingo.utils.ConnectionManager;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class PrepareLiveEventDialog extends CommandBase 
	{
		public static const READY_PREPARE_LIVE_EVENT_DIALOG:String = "READY_PREPARE_LIVE_EVENT_DIALOG";
		
		private var roomType:RoomType;
		private var dudeAsset:ImageAsset;
		private var liveIconAsset:ImageAsset;
		private var dudeLoadedFlag:Boolean;
		private var liveIconLoadedFlag:Boolean;
		private var serverReadyFlag:Boolean;
		private var msg:LiveEventInfoOkMessage;
		
		public function PrepareLiveEventDialog(roomType:RoomType) 
		{
			super();
			this.roomType = roomType;
			Game.addEventListener(ConnectionManager.LIVE_EVENT_INFO_OK_EVENT, onLiveEventInfoOk);
		}
		
		private function onLiveEventInfoOk(e:Event):void 
		{
			msg = e.data as LiveEventInfoOkMessage;
			serverReadyFlag = true;
			Game.removeEventListener(ConnectionManager.LIVE_EVENT_INFO_OK_EVENT, onLiveEventInfoOk);
			checkLoadedConditions();
		}
		
		override protected function startExecution():void 
		{
			if (roomType.dudeTexture)
			{
				dudeAsset = LoadManager.instance.getImageAssetByName(roomType.dudeTexture, this);
				dudeAsset.addPurgeLock("PrepareLiveEventDialog");
				dudeAsset.load(dudeLoaded, dudeLoaded);
			}
			else
			{
				dudeLoaded();
			}
			
			if (roomType.liveEventIcon)
			{
				liveIconAsset = LoadManager.instance.getImageAssetByName(roomType.liveEventIcon, this);
				liveIconAsset.addPurgeLock("PrepareLiveEventDialog");
				liveIconAsset.load(liveIconLoaded, liveIconLoaded);
			}
			else
			{
				liveIconLoaded();
			}
			
			Game.connectionManager.sendLiveEventInfoMessage(roomType.activeEventName);
		}
		
		private function liveIconLoaded():void 
		{
			liveIconLoadedFlag = true;
			checkLoadedConditions();
		}
		
		private function dudeLoaded():void 
		{
			dudeLoadedFlag = true;
			checkLoadedConditions();
		}
		
		private function checkLoadedConditions():void 
		{
			if (dudeLoadedFlag && liveIconLoadedFlag && serverReadyFlag)
			{
				Game.dispatchEventWith(READY_PREPARE_LIVE_EVENT_DIALOG, false, msg);
				
				if(dudeAsset)
					dudeAsset.releasePurgeLock("PrepareLiveEventDialog");
				
				if (liveIconAsset)
					liveIconAsset.releasePurgeLock("PrepareLiveEventDialog");
			}
		}
		
	}

}