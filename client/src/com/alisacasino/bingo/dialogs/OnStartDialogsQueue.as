package com.alisacasino.bingo.dialogs
{
	import avmplus.getQualifiedClassName;
	import com.alisacasino.bingo.dialogs.tournamentResultDialogClasses.TournamentResultDialog;
	import com.alisacasino.bingo.protocol.ClaimOfferOkMessage;
	import com.alisacasino.bingo.utils.Constants;
	import flash.utils.Dictionary;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	public class OnStartDialogsQueue extends EventDispatcher
	{
		public function OnStartDialogsQueue() {
			queue = [];
			orderList = new Dictionary();
			orderList[ClaimBonusDialog] = 1;
			orderList[InfoDialog] = 2;
			orderList[CollectionPageRewardDialog] = 30;
			orderList[TournamentResultDialog] = 100000;
		}
		
		private const ORDER_FREEBIE_CLAIM:int = 1;
		private const ORDER_FREEBIE_ERROR:int = 2;
		private const ORDER_OFFER_ERROR:int = 10;
		private const ORDER_COLLECTION_PAGE_REWARD:int = 30;
		private const ORDER_TOURNAMENT_RESULT:int = 100000;
		
		private var queue:Array;
		
		public var started:Boolean;
		public var completed:Boolean;
		
		private var blockingQuad:Quad;
		private var orderList:Dictionary;
		
		public function start():void
		{
			if (started)
				return;
				
			started = true;
			
			if (queue.length > 0) 
			{
				if (!blockingQuad) {
					blockingQuad = new Quad(layoutHelper.stageWidth, layoutHelper.stageHeight, 0x000000);
					blockingQuad.alpha = 0.0;
					//Starling.juggler.tween(blockingQuad, 0.5/*1 + 1.1*/, {alpha:0.0});
					Starling.current.stage.addChild(blockingQuad);
				}
				
				Starling.juggler.delayCall(showNext, 1.1);
			}
			else {
				dispatchEventWith(Event.COMPLETE);
				completed = true;
			}
		}
		
		public function addToQueue(dialogObject:DisplayObject, openOver:Boolean = false):void
		{
			if (completed)
			{
				sosTrace("Queue is completed, cannot add dialog [" + getQualifiedClassName(dialogObject) + "]!", SOSLog.ERROR);
			}
			queue.push(new ShowDialogItem(dialogObject, getDialogOrder(dialogObject)));
		}
		
		private function getDialogOrder(dialogObject:Object):int
		{
			for (var clazz:Class in orderList) 
			{
				if (dialogObject is clazz)
				{
					return orderList[clazz]
				}
			}
			return int.MAX_VALUE;
		}
		
		public function clean():void
		{
			started = false;
			completed = false;
			queue = [];
		}
		
		private function showNext():void
		{
			if (queue.length == 0) {
				dispatchEventWith(Event.COMPLETE);
				completed = true;
				return;
			}
			
			queue.sortOn('order');
			
			if (blockingQuad) {
				Starling.juggler.removeTweens(blockingQuad);
				blockingQuad.removeFromParent(true);
				blockingQuad = null;
			}
			
			var showDialogItem:ShowDialogItem = queue.shift() as ShowDialogItem;
			var dialog:DisplayObject = showDialogItem.dialog;
			dialog.addEventListener(Event.REMOVED_FROM_STAGE, dialog_removedFromStageHandler);
			DialogsManager.instance.addDialog(dialog, false, true);
		}
		
		private function dialog_removedFromStageHandler(e:Event):void 
		{
			e.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE, dialog_removedFromStageHandler);
			showNextIfPossible();
		}
		
		private function showNextIfPossible():void 
		{
			if (DialogsManager.activeDialog == null)
			{
				showNext();
			}
			else
			{
				Starling.juggler.delayCall(showNextIfPossible, 0.05);
			}
		}
	}		
}
import starling.display.DisplayObject;

final class ShowDialogItem {
	
	public var dialog:DisplayObject;
	public var order:int;
	
	public function ShowDialogItem(dialog:DisplayObject, order:int) 
	{
		this.dialog = dialog;
		this.order = order;
	}
}