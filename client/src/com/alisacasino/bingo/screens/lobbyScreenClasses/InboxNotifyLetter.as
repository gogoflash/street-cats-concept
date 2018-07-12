package com.alisacasino.bingo.screens.lobbyScreenClasses 
{
	import com.alisacasino.bingo.Game;
	import com.alisacasino.bingo.assets.AnimationContainer;
	import com.alisacasino.bingo.assets.MovieClipAsset;
	import com.alisacasino.bingo.commands.dialogCommands.ShowInboxDialog;
	import com.alisacasino.bingo.controls.XTextField;
	import com.alisacasino.bingo.controls.XTextFieldStyle;
	import com.alisacasino.bingo.dialogs.DialogsManager;
	import com.alisacasino.bingo.dialogs.inbox.InboxDialog;
	import com.alisacasino.bingo.models.gifts.GiftsModel;
	import com.catalystapps.gaf.display.GAFImage;
	import flash.utils.setInterval;
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextFieldAutoSize;



	public class InboxNotifyLetter extends Sprite implements IAnimatable
	{
		private var inboxAnimation:AnimationContainer;
		private var countLabel:XTextField;
		private var anchorGafImage:GAFImage;
		private var requestIsHandling:Boolean;
		
		public function InboxNotifyLetter() 
		{
			inboxAnimation = new AnimationContainer(MovieClipAsset.PackCommon, true, true);
			inboxAnimation.pivotX = 138*pxScale;
			inboxAnimation.pivotY = 100*pxScale;
			addChild(inboxAnimation);
			//x2Animation.scale = 0.73;
			//x2Animation.rotation = (50 * Math.PI) / 180;
			inboxAnimation.playTimeline('inbox_notify', false, true);
			
			anchorGafImage = inboxAnimation.currentClip.numChildren > 2 ? (inboxAnimation.currentClip.getChildAt(2) as GAFImage) : null;
			
			countLabel = new XTextField(1, 1, XTextFieldStyle.getWalrus(27));
			countLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			countLabel.alignPivot();
			//countLabel.text = '25';
			countLabel.x = 138 * pxScale;
			countLabel.y = 98 * pxScale;
			
			addChild(countLabel);
			
			Starling.juggler.add(this);
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			addEventListener(TouchEvent.TOUCH, handler_touch);
			
			useHandCursor = true;
		}
		
		private function onRemovedFromStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			Starling.juggler.remove(this);
		}
		
		/*override public function set x(value:Number):void 
		{
			trace();
			if ((value - super.x) < 1) {
				rotation = 0;
			}
			else if (value > super.x) {
				rotation = (2 * Math.PI) / 180;
			}
			else {
				rotation = -(2 * Math.PI) / 180;
			}
			
			
			super.x = value;
		}*/
		
		public function advanceTime(time:Number):void 
		{
			if (anchorGafImage) {
				countLabel.x = anchorGafImage.x*0.072 - 7.5 * pxScale; 
				countLabel.y = anchorGafImage.y * 0.67 - 40 * pxScale;
				
				countLabel.scaleX = anchorGafImage.scaleX; 
				countLabel.scaleY = anchorGafImage.scaleY; 
			}
		}
		
		public function set countText(value:String):void 
		{
			if (countLabel) {
				countLabel.text = value;
				countLabel.alignPivot();
			}
		}
		
		private function handler_touch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			if (touch == null)
				return;

			if (touch.phase == TouchPhase.ENDED) 
			{
				if (DialogsManager.instance.getDialogByClassInDialogList(InboxDialog) || requestIsHandling)
					return;
				
				gameManager.giftsModel.addEventListener(GiftsModel.GIFTS_DESERIALIZED, updateBadgeAndShowGiftAccept);
				Game.connectionManager.sendRequestIncomingItemsMessage();
				requestIsHandling = true;
				Starling.juggler.delayCall(dropHandlingRequestFlag, 1);
				
				function updateBadgeAndShowGiftAccept():void {
					requestIsHandling = false;
					gameManager.giftsModel.removeEventListener(GiftsModel.GIFTS_DESERIALIZED, updateBadgeAndShowGiftAccept);
					new ShowInboxDialog(ShowInboxDialog.TYPE_ON_NOTIFY).execute();
				}
			}
		}
		
		private function dropHandlingRequestFlag():void {
			requestIsHandling = false;
		}
	}

}